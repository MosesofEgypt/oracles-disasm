.if defined(ROM_COMBO)
.enum 0
	COMBO_FLAG_BIT_LINKED_STARTED	db
	COMBO_FLAG_BIT_LINKED_BEATEN	db
	COMBO_FLAG_BIT_2				db
	COMBO_FLAG_BIT_3				db
	COMBO_FLAG_BIT_4				db
	COMBO_FLAG_BIT_5				db
	COMBO_FLAG_BIT_6				db
	COMBO_FLAG_BIT_PREVIOUS_GAME	db ; set for seasons, unset for ages
.ende
.endif

; Parameters:
; 1 - Offset to start copying to
; 2 - Length of data to copy
.macro m_LoadSavefileSection_len
	.assert NARGS == 2
	push hl
	ld bc,(\1)-wFileStart
	add hl,bc
	ld de,\1
	ld bc,\2
	call copyMemoryBc
	pop hl
.endm

; Parameters:
; 1 - Offset to start copying to
; 2 - End of the data to copy to(offset + copy length)
.macro m_LoadSavefileSection_end
	.assert NARGS == 2
	m_LoadSavefileSection_len \1, (\2)-(\1)
.endm

; Parameters:
; 1 - Offset to start clearing
; 2 - Length of data to clear
; 3 - Byte to fill with(defaults to $00)
.macro m_ClearSavefileSection_len
	.if NARGS == 3
		.if \3 == $00
			xor a
		.else
			ld a,\3
		.endif
	.else
		.assert NARGS == 2
		xor a
	.endif
	ld hl,\1
	ld bc,\2
	call fillMemoryBc
.endm

; Parameters:
; 1 - Offset to start clearing
; 2 - End of the data to clear(offset + copy length)
.macro m_ClearSavefileSection_end
	.if NARGS == 2
		m_ClearSavefileSection_len \1, (\2)-(\1), $00
	.else
		.assert NARGS == 2
		m_ClearSavefileSection_len \1, (\2)-(\1), (\3)
	.endif
.endm

.if defined(ROM_COMBO) || defined(ENABLE_NEW_GAME_PLUS)
; NOTE: we're intentionally preserving the ore flags between games and NG+ cycles
ngpAndComboTreasureFlagMask:
	.db $10	; count
	.db $02 ; TREASURE_SHIELD
	.db $30	; TREASURE_BIGGORON_SWORD, TREASURE_BOMBCHUS
	.db $00
	.db $00
	.db $00
	.db $90	; TREASURE_RING_BOX, TREASURE_POTION
	.db $00
	.db $00
	.db $00
	.db $00
.if defined(ROM_COMBO)
	; for the combo, the ore flags were moved to allow them to
	; exist in both an ages and seasons save, allowing them to
	; persist across both NG+ cycle and game world switches.
	.db $c0	; TREASURE_RED_ORE, TREASURE_BLUE_ORE
	.db $80	; TREASURE_HARD_ORE
.else
	.db $07 ; TREASURE_RED_ORE, TREASURE_BLUE_ORE, TREASURE_HARD_ORE
	.db $00
.endif
	.db $00
	.db $00
	.db $00
	.db $00
.endif

;;
; @param c What operation to do on the file
; @param hActiveFileSlot File index
fileManagementFunction:
	ld a,c
	rst_jumpTable
	.dw initializeFile
	.dw saveFile
	.dw loadFile
	.dw eraseFile
	.dw copyFile
.if defined(ROM_COMBO)
	.dw comboLoadOtherGame
	.dw comboLoadSpecificGame
	.dw setComboCompleted
.else
	.dw noFileManagementOp
	.dw noFileManagementOp
	.dw noFileManagementOp
.endif
.ifdef ENABLE_NEW_GAME_PLUS
	.dw initializeNgpFile
.else
	.dw noFileManagementOp
.endif

.ifdef ENABLE_NEW_GAME_PLUS
initializeNgpFile:
.if defined(ROM_COMBO)
	; mark save as not having both games started/beaten
	ld a,$0a
	ld ($1111),a
	call getComboSaveFileFlags
	res COMBO_FLAG_BIT_LINKED_STARTED,(hl)
	res COMBO_FLAG_BIT_LINKED_BEATEN,(hl)
	xor a
	ld ($1111),a

	; reset the "linked game" flag
	ld (wFileIsLinkedGame),a
.endif

	; Unequip all rings and remove from box
.ifdef ENABLE_MULTI_RING
	ld hl,wRingReduxFlags
	ld a,$1f
	ld (hl),a
.endif
	m_ClearSavefileSection_len wRingBoxContents, $05, $ff

.if defined(ENABLE_MULTI_RING) || defined(EXTENDED_RING_BOX)
	ld hl,wRingReduxFlagsExt
	ld a,$1f
	ld (hl),a
.endif

.ifdef EXTENDED_RING_BOX
	m_ClearSavefileSection_len wRingBoxContentsExt, $05, $ff
.endif

	m_ClearSavefileSection_end wDeathRespawnBuffer, wBoughtShopItems1
	m_ClearSavefileSection_end wCompanionStates, wGashaSpotFlags
	m_ClearSavefileSection_end (wGashaMaturity+2), wObtainedTreasureFlags
	m_ClearSavefileSection_end wChildStage, (wSlingshotSelectedSeeds+1)
	m_ClearSavefileSection_end wPortalGroup, wSaveFileMainSectionEnd
	call clearShopFlags

	; reset global flags while avoiding ones we want to
	; persist across NG cycles, such as vasu rewards,
	; linked secret flags, and upgrades received.
	push de
	ld de,wGlobalFlags
	ld hl,@ngpGlobalFlagMask
	call applyFlagMask
	pop de

	; reset the flags for any secrets that don't have both
	; the "begin" and "done" flags set. the "begin" flag for
	; the sister secret in each game will be set when the
	; secret is learned in the first game, and the "done"
	; flag will be set when it's told in the other game.
	; for example, the DEKU and TINGLE secret are sisters
	; as they're mutually exclusive based on the order the
	; games are played, but they still give the same reward.
	; if both aren't set then NG+ was started without a secret
	; having been told, so the process needs to be restarted.
	ld hl,@ngpPairedGlobalFlags
	ldi a,(hl)
	-
		ld b,a
		ldi a,(hl)
		ld c,a
		call @resetPairedFlags
		ld a,c ; swap the begin and done
		ld c,b ; flags around to check
		ld b,a ; both cases
		call @resetPairedFlags

		ldi a,(hl)
		or a
		jr nz,-

	; mask out treasure flags to keep from previous game cycle
	ld hl,ngpAndComboTreasureFlagMask
	ld de,wObtainedTreasureFlags
	call applyFlagMask

	; clear all the room flags
	ld hl,wGroup0RoomFlags
	ld b,$40
	call clearMemory16ByteBlocks

	ld (wFluteIcon),a
	ld (wObtainedSeasons),a
	ld (wNumBombs),a
	ld (wNumBombchus),a

	ld (wEssencesObtained),a
	.ifndef ENABLE_MULTI_RING
		ld (wActiveRing),a
	.endif

	ld hl,initialFileVariables_ages
	call initializeFileVariables
.if defined(ROM_COMBO)
	ld hl,initialFileVariables_seasons
	call wIsSeasons
	call c,initializeFileVariables
.endif

	; set wLinkHealth to wLinkMaxHealth
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a

	; put temporary items in the equipped slots so the items
	; we give the player get put into the inventory instead
	ld a,ITEM_PUNCH
	ld hl,wInventoryB
	ldi (hl),a
	ld  (hl),a

	ld a,ITEM_LIFE_VIAL
	ld c,$00
	call giveTreasure

	; give the player the bonus items
	ld hl,@bonusInventoryItems
	-
		ld a,(hl)
		call checkTreasureObtained
		ldi a,(hl)
		ld c,(hl)
		inc hl
		push hl
		call c,giveTreasure
		pop hl
		ld a,(hl)
		or a
		jr nz,-

	; remove the temporary items
	xor a
	ld hl,wInventoryB
	ldi (hl),a
	ld  (hl),a

	; refill(or initialize) the life vial
	ld hl,wLifeVialMaxCharges
	ldd a,(hl)
	; minimum of 5 charges
	cp $05
	jr nc,+
		ld a,$05
	+
	ldi (hl),a
	ld (hl),a

	; Load in a: wFileIsHeroGame (bit 1), wFileIsLinkedGame (bit 0)
	ld hl,wFileIsHeroGame
	ldd a,(hl)
	add a
	add (hl) ; wFileIsLinkedGame

	; Initialize data differently based on whether it's a linked or hero game
	ld hl,initialNgpFileVariablesTable
	rst_addDoubleIndex
	rst_derefHl
	call initializeFileVariables

	; increment NG+ cycle
	ld hl,wFileIsCompleted
	ld a,(hl)
	and $f0
	add $10
	cp $40
	jr c,+
		; cap to NG+3
		or $30
	+
	ld (hl),a
	ret

@resetPairedFlags:
	push hl
	ld a,c
	call checkGlobalFlag
	pop hl
	ld a,b
	push hl
	call z,unsetGlobalFlag
	pop hl
	ret

@bonusInventoryItems:
	.db TREASURE_BIGGORON_SWORD,	$00
	.db TREASURE_BOMBCHUS,			$00
	.db TREASURE_RING_BOX,			$01
	.db TREASURE_SHIELD,			$01
	.db $00

; masks for each GLOBALFLAG that should persist between NG+ cycles
@ngpGlobalFlagMask:
	.db $0f; number of bytes to mask

	.db $ff ; keep all first $0a flags
	.db $03
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
.if defined(ROM_COMBO)
	.db $f8 ; GLOBALFLAG_STARTED_TRADE_QUEST_SEASONS
	;         GLOBALFLAG_STARTED_TRADE_QUEST_AGES
	;         GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY
	;         GLOBALFLAG_GOT_SATCHEL_UPGRADE
	;         GLOBALFLAG_GOT_RED_AND_BLUE_ORE
.elif defined(ROM_AGES)
	.db $70 ; GLOBALFLAG_STARTED_TRADE_QUEST
	;         GLOBALFLAG_GOT_BOMB_UPGRADE_FROM_FAIRY
	;         GLOBALFLAG_GOT_SATCHEL_UPGRADE
.else
	.db $90 ; GLOBALFLAG_STARTED_TRADE_QUEST
	;         GLOBALFLAG_GOT_RED_AND_BLUE_ORE
.endif
	.db $ff ; keep all flags from $50 to $78(linked secrets)
	.db $ff
	.db $ff
	.db $ff
	.db $ff

; list of global flags for secrets that form a pair of begin/end pair.
; this is used to determine if an end secret is set(for carrying over
; to the other game), and resetting it on NG+ if the begin isn't set.
@ngpPairedGlobalFlags:
	.db GLOBALFLAG_BEGAN_KING_ZORA_SECRET,	GLOBALFLAG_DONE_KING_ZORA_SECRET
	.db GLOBALFLAG_BEGAN_LIBRARY_SECRET,	GLOBALFLAG_DONE_LIBRARY_SECRET
	.db GLOBALFLAG_BEGAN_TOKAY_SECRET,		GLOBALFLAG_DONE_TOKAY_SECRET
	.db GLOBALFLAG_BEGAN_TINGLE_SECRET,		GLOBALFLAG_DONE_TINGLE_SECRET
	.db GLOBALFLAG_BEGAN_ELDER_SECRET,		GLOBALFLAG_DONE_ELDER_SECRET
	.db GLOBALFLAG_BEGAN_SYMMETRY_SECRET,	GLOBALFLAG_DONE_SYMMETRY_SECRET
	.db GLOBALFLAG_BEGAN_FAIRY_SECRET,		GLOBALFLAG_DONE_FAIRY_SECRET
	.db GLOBALFLAG_BEGAN_TROY_SECRET,		GLOBALFLAG_DONE_TROY_SECRET

	.db GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET,	GLOBALFLAG_DONE_CLOCK_SHOP_SECRET
	.db GLOBALFLAG_BEGAN_SMITH_SECRET,		GLOBALFLAG_DONE_SMITH_SECRET
	.db GLOBALFLAG_BEGAN_PIRATE_SECRET,		GLOBALFLAG_DONE_PIRATE_SECRET
	.db GLOBALFLAG_BEGAN_DEKU_SECRET,		GLOBALFLAG_DONE_DEKU_SECRET
	.db GLOBALFLAG_BEGAN_BIGGORON_SECRET,	GLOBALFLAG_DONE_BIGGORON_SECRET
	.db GLOBALFLAG_BEGAN_RUUL_SECRET,		GLOBALFLAG_DONE_RUUL_SECRET
	.db GLOBALFLAG_BEGAN_GRAVEYARD_SECRET,	GLOBALFLAG_DONE_GRAVEYARD_SECRET
	.db GLOBALFLAG_BEGAN_SUBROSIAN_SECRET,	GLOBALFLAG_DONE_SUBROSIAN_SECRET
	.db $00 ; terminator

.endif

noFileManagementOp:
	ret

.if defined(ROM_COMBO) || defined(ENABLE_NEW_GAME_PLUS)
clearShopFlags:
	push hl
	; selectively clear the flags for what's been bought from each shop
	; to prevent obtaining multiple satchel/bomb/ring box upgrades
	ld hl,wBoughtShopItems1
	ld a,$11 ; preserve flag for ring box and satchel upgrades
	and (hl)
	ldi (hl),a
	xor a
	ldi (hl),a ; clear wBoughtShopItems2
	ldi (hl),a ; clear wMapleState
	ld a,$04 ; preserve flag for bomb bag upgrade
	and (hl)
	ld (hl),a
	pop hl
	ret
.endif

;;
initializeFile:
	ld hl,initialFileVariables
	call initializeFileVariables
.if defined(ROM_COMBO)
	ld hl,initialFileVariables_seasons
	call wIsSeasons
	call c,initializeFileVariables

	; unset the flags indicating various things about the combo games
	ld a,$0a
	ld ($1111),a
	call getComboSaveFileFlags
	ld (hl),$00
	xor a
	ld ($1111),a
.endif

	; Load in a: wFileIsHeroGame (bit 1), wFileIsLinkedGame (bit 0)
	ld hl,wFileIsHeroGame
	ldd a,(hl)
	add a
	add (hl) ; wFileIsLinkedGame
	push af

	; Initialize data differently based on whether it's a linked or hero game
	ld hl,initialFileVariablesTable
	rst_addDoubleIndex
	rst_derefHl
	call initializeFileVariables

	; Clear unappraised rings
	pop af
	ld c,a
	ld hl,wUnappraisedRings
	ld b,$40
	ld a,$ff
	call fillMemory

	; Clear ring box contents
	ld hl,wRingBoxContents
	ld b,$06
	ld a,$ff
	call fillMemory
.ifdef ENABLE_MULTI_RING
	; set the flags to 0
	ld hl,wRingReduxFlags
	ld (hl),$00
.endif

	; If hero game, give victory ring
	ld a,c
	cp $02
	jr nz,++

	ld hl,wObtainedTreasureFlags
	ld a,TREASURE_RING
	call setFlag
	ld a,VICTORY_RING | $40
	ld (wUnappraisedRings),a
++
	.if defined(ROM_COMBO)
		callab interactionCodeAges11.initializeChildOnGameStart
	.else
		callab interactionCode5.initializeChildOnGameStart
	.endif
.ifdef ROM_COMBO
	call wIsSeasons
	jr c,saveFile
.endif
.if defined(ROM_AGES) || defined(ROM_COMBO)
	callab roomTileChanges.initializeVinePositions
.endif

;;
; In addition to saving, this is called after creating a file, as well as when it's about
; to be loaded (for some reason)
saveFile:
	; Write $01 here for "ages", $00 for "seasons"
	ld hl,wWhichGame
.ifdef ROM_COMBO
	ld (hl),$00
	call wIsSeasons
	jr c,+
		inc (hl)
	+

	ld a,$0a
	ld ($1111),a
	call getComboSaveFileFlags
	; set or unset the flag to indicate which game was last played
	call wIsSeasons
	jr c,+
		; ages
		bit COMBO_FLAG_BIT_PREVIOUS_GAME,(hl)

		; if the flag differs, that means both games were started
		; on this savefile, so we need to indicate this via flags
		jr z,++
			res COMBO_FLAG_BIT_PREVIOUS_GAME,(hl)
			set COMBO_FLAG_BIT_LINKED_STARTED,(hl)
			jr ++
	+
		; seasons
		bit COMBO_FLAG_BIT_PREVIOUS_GAME,(hl)
		jr nz,++
			set COMBO_FLAG_BIT_PREVIOUS_GAME,(hl)
			set COMBO_FLAG_BIT_LINKED_STARTED,(hl)
			jr ++
	++
	xor a
	ld ($1111),a

	call getComboCompleted
	ld hl,wFileIsCompleted
	jr z,+
		set COMBO_FLAG_BIT_LINKED_BEATEN,(hl)
	+

.elif defined(ROM_AGES)
	ld (hl),$01
.else
	ld (hl),$00
.endif
	; String to verify save integrity (unique between ages/seasons)
	ld hl,wSavefileString
	.ifdef ROM_COMBO
		call wIsSeasons
		ld de,saveVerificationString_seasons
		jr c,+
			ld de,saveVerificationString_ages
		+
	.else
		ld de,saveVerificationString
	.endif
	ld b,$08
	call copyMemoryReverse

	; Calculate checksum
	ld l,<wFileStart
	call calculateFileChecksum
	ld (hl),e
	inc l
	ld (hl),d

	; Save file
	ld l,<wFileStart
	call getFileAddress1
	ld e,c
	ld d,b
.ifdef ROM_COMBO
	jp copyFileFromHlToDe
.else
	call copyFileFromHlToDe

	; Save file to backup slot?
	call getFileAddress2
	ld e,c
	ld d,b
	call copyFileFromHlToDe

	; Redundant?
	jr verifyFileCopies
.endif

;;
; @param[out]	a	$00 if file was loaded successfully.
;                   $01 if first file copy is invalid.
;                   $02 if second file copy is invalid.
;                   $ff if all file copies are invalid.
loadFile:
.ifdef ROM_COMBO
	call getLastGamePlayed
	call setIsSeasons

comboLoadSpecificGame:
	call getFileAddress1
	ld l,c
	ld h,b
	call verifyFileAtHl
	push af
	call c,eraseFile
	call getFileAddress1
.else
	call verifyFileCopies
	push af
	or a
	jr nz,+

	call getFileAddress1
	jr ++
+
	call getFileAddress2
++
.endif
	ld l,c
	ld h,b
	ld de,wFileStart
	call copyFileFromHlToDe
.ifdef ENABLE_NEW_GAME_PLUS
	xor a
	ld (wLinkPoisonCounter),a
.endif
	pop af
	ret

.if defined(ROM_COMBO)
;;
; Working from the existing WRAM save data, this either loads portions of
; the other game's save file, or clears and initializes them. The result
; is that the other game can be switched to while carrying health, rupees,
; upgrades, and various other things like rings over between games.
; The current game is saved before any of this is done, however.
; @param[out]	zflag	Set if a new game was initialized rather than loaded.
comboLoadOtherGame:
	call saveFile

	push hl
	push de
	push bc
	call toggleIsSeasons
	call getComboStarted
	
	; preserve global flags for vasu
	ld de,wGlobalFlags
	push de
	ld a,(de)
	ld b,a
	inc de
	ld a,(de)
	and $03
	ld c,a
	push bc

	jr nz,+
		call initializeComboGame
		xor a
		jr ++
	+
		call loadAcrossComboGame
		ld a,$ff
	++
	ld hl,wFileChecksum ; using checksum to tell if loaded or initialized
	ldi (hl),a
	ldi (hl),a

	; restore vasu flags
	pop bc
	pop hl	; wGlobalFlags
	ld a,b
	or (hl)
	ldi (hl),a
	ld a,c
	or (hl)
	ld (hl),a

	; stop music and sfx to prevent item acquisition sounds from playing
	ld a,SNDCTRL_STOPMUSIC
	call playSound
	ld a,SNDCTRL_STOPSFX
	call playSound

	pop bc
	pop de
	pop hl
	ret

;;
; Working from the existing WRAM save data, this loads select portions of
; the other game's save file in preparation for switching to running it.
loadAcrossComboGame:
	; get the savefile address to read from
	call getFileAddress1
	ld h,b
	ld l,c

	; enable SRAM chip
	ld a,$0a
	ld ($1111),a

	m_LoadSavefileSection_len wChildStatus,               $07
	m_LoadSavefileSection_len wSavefileString,            $08
	m_LoadSavefileSection_len wFluteIcon,                 $01
	m_LoadSavefileSection_len wBoughtShopItems2,          $01
	m_LoadSavefileSection_len wMapleState,                $01
	m_LoadSavefileSection_end wDeathRespawnBuffer,        wBoughtShopItems1
	m_LoadSavefileSection_end wCompanionStates,           wObtainedTreasureFlags
	m_LoadSavefileSection_end wEssencesObtained,          wTradeItem+1
	m_LoadSavefileSection_end wKilledGoldenEnemies,       wGlobalFlags+10
	m_LoadSavefileSection_end wGlobalFlags+15,            wSlingshotSelectedSeeds+1
	m_LoadSavefileSection_end wBiggoronSwordOverflowItem, wSaveFileMainSectionEnd
	m_LoadSavefileSection_end wGroup0RoomFlags,           wGroupRoomFlagsEnd

	push hl
	; mask out shop flags to keep from previous game
	ld de,wBoughtShopItems1
	ld bc,wBoughtShopItems1-wFileStart
	add hl,bc
	ld a,(de)
	and $11 ; preserve flag for ring box and satchel upgrades
	or (hl)
	ld (de),a

	; move to wBoughtSubrosianShopItems
	.rept 3
		inc de
		inc hl
	.endr
	ld a,(de)
	and $04 ; preserve flag for bomb bag upgrade
	or (hl)
	ld (de),a

	pop hl
	push hl

	call determineSecretSet
	ld de,wGlobalFlags+12
	ld a,(de)
	push af
	push de
	jr nz,+
		; load first 20 secret bits
		m_LoadSavefileSection_len wGlobalFlags+10, 3
		pop de
		ld a,(de)
		and $0f
		ld (de),a
		pop af
		and $f0
		jr ++
	+
		; load second 20 secret bits
		m_LoadSavefileSection_len wGlobalFlags+12, 3
		pop de
		ld a,(de)
		and $f0
		ld (de),a
		pop af
		and $0f
	++
	; merge the flags for the overlapping byte
	ld l,a
	ld a,(de)
	or l
	ld (de),a

	; if this is the linked game(second one played), set the 
	; "DONE" flags for secrets with a sister "DONE" flag set
	ld a,(wFileIsLinkedGame)
	bit 0,a
	jr z,++
		ld d,$0a
		ld e,GLOBALFLAG_DONE_CLOCK_SHOP_SECRET
		ld c,20
		call wIsSeasons
		jr c,+
			ld e,GLOBALFLAG_DONE_KING_ZORA_SECRET
			ld c,-20
		+

		-
			ld a,e
			call checkGlobalFlag
			jr z,+
				ld a,e
				add c
				call setGlobalFlag
			+
			inc e
			dec d
			jr nz,-
	++

	; mask out treasure flags to keep from previous game
	ld hl,ngpAndComboTreasureFlagMask
	ld de,wObtainedTreasureFlags
	call applyFlagMask
	pop hl

	; merge the current game's flags in from the savefile
	ld de,wObtainedTreasureFlags
	ld bc,wObtainedTreasureFlags-wFileStart
	add hl,bc
	ld b,$10 ; byte count
	call mergeFlags

	; disable SRAM chip
	xor a
	ld ($1111),a

	; give the player the bonus items
	ld hl,@bonusInventoryItems
	-
		ld a,(hl)
		call checkTreasureObtained
		ldi a,(hl)
		ld c,(hl)
		inc hl
		push hl
		call c,giveTreasure
		pop hl
		ld a,(hl)
		or a
		jr nz,-

	; set the bit indicating that warping to other game is allowed
	ld hl,wFileIsCompleted
	ld a,$f7
	and (hl)
	or $08
	ld (hl),a

	; NOTE: this bit will make its way into the file select to cause
	;       the triforce to be drawn. instead of indicating this as a
	;       "Hero Mode" file, it indicates the full game was beaten.
	call getComboCompleted
	jr z,+
		set COMBO_FLAG_BIT_LINKED_BEATEN,(hl)
	+
	ret

@bonusInventoryItems:
	.db TREASURE_BIGGORON_SWORD,	$00
	.db TREASURE_BOMBCHUS,			$00
	.db TREASURE_RING_BOX,			$01
	.db TREASURE_SHIELD,			$01
	.db $00

;;
; Working from the existing WRAM save data, this clears and initializes
; select portions of the save file so it can be used for the other game.
initializeComboGame:
	; toggle the game type and set as linked game
	ld hl,wWhichGame
	ld a,(hl)
	xor $01
	ldi (hl),a
	; set the linked-game bit
	set 0,(hl)

	; unset all treasure flags that cannot be carried over
	push de
	ld de,wObtainedTreasureFlags
	call wIsSeasons
	ld hl,@comboTreasureFlagMask_seasons
	jr c,+
		ld hl,@comboTreasureFlagMask_ages
	+
	call applyFlagMask
	pop de

	; set the bit indicating that warping to other game is allowed
	ld hl,wFileIsCompleted
	ld a,$f0
	and (hl)
	or $08
	ld (hl),a

	.if defined(ENABLE_MULTI_RING) || defined(EXTENDED_RING_BOX)
		xor a
		ld (wRingReduxFlagsExt),a
	.endif

	; clear all game tracker variables and such
	m_ClearSavefileSection_end wDeathRespawnBuffer,        wBoughtShopItems1
	m_ClearSavefileSection_end wCompanionStates,           wObtainedTreasureFlags
	m_ClearSavefileSection_end wFluteIcon,                 wRingBoxLevel
	m_ClearSavefileSection_end wGlobalFlags,               wGlobalFlags+10
	; NOTE: avoiding clearing secret flags to carry them across games
	m_ClearSavefileSection_end wGlobalFlags+15,            wSlingshotSelectedSeeds+1
	m_ClearSavefileSection_end wBiggoronSwordOverflowItem, wSaveFileMainSectionEnd
	m_ClearSavefileSection_end wGroup0RoomFlags,           wGroupRoomFlagsEnd

	call clearShopFlags
	call wIsSeasons
	jr c,+
		ld hl,initialFileVariables_ages
		call initializeFileVariables

		ld hl,initialFileVariables_linkedGame_ages
		call initializeFileVariables
		jr ++
	+
		ld hl,initialFileVariables_seasons
		call initializeFileVariables
	++

	.if defined(ENABLE_NEW_GAME_PLUS)
		call getIsNewGamePlus
		ld hl,initialNgpFileVariables_linkedGame
		call nz,initializeFileVariables
	.endif

	; refill link's health
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ldi (hl),a

	; clear the ring box
	m_ClearSavefileSection_len wRingBoxContents, $05, $ff
	.ifdef EXTENDED_RING_BOX
		m_ClearSavefileSection_len wRingBoxContentsExt, $05, $ff
	.endif

	; put temporary items in the equipped slots so the items
	; we give the player get put into the inventory instead
	ld a,ITEM_PUNCH
	ld hl,wInventoryB
	ldi (hl),a
	ld  (hl),a

	; give the player the bonus items they had
	ld hl,@bonusInventoryItems
	ld a,(hl)
	-
		call checkTreasureObtained
		ldi a,(hl)
		ld c,$00 ; give 0 of whatever the consumable item is
		call c,giveTreasure
		ld a,(hl)
		or a
		jr nz,-

	; ensure the player has a way to get back to the other game if they want to
	; they won't be able to use them until they get a seed satchel, but thats fine
	ld a,TREASURE_GALE_SEEDS
	call giveTreasure

	; remove the temporary items
	xor a
	ld hl,wInventoryB
	ldi (hl),a
	ld  (hl),a

	; save the new file
	jp saveFile

@bonusInventoryItems:
	.db TREASURE_SWORD
	.db TREASURE_BIGGORON_SWORD
	.db TREASURE_BOMBCHUS
.if defined(WIDE_INVENTORY_SPRITES) || !defined(ENABLE_DOUBLE_HEART_CAP)
	; NOTE: these can only be allowed with wide inventory sprites due to
	;       there not being any tiles remaining for part of the top left
	;       part of the harp in seasons, or the spring tile in ages.
	;       this only applies with a doubled heart cap, as the tile in
	;       question is being overwritten by an overlapped heart tile.
	.db TREASURE_ROD_OF_SEASONS
	.db TREASURE_HARP
.endif
	.db $00

; NOTE: we're intentionally preserving the ore flags between games
@comboTreasureFlagMask_ages:
	.db $10
	.db $a4	; TREASURE_PUNCH, TREASURE_SWORD, TREASURE_ROD_OF_SEASONS
	.db $30	; TREASURE_BIGGORON_SWORD, TREASURE_BOMBCHUS
	.db $00
	.db $00
	.db $00
	.db $90	; TREASURE_RING_BOX, TREASURE_POTION
	.db $00
	.db $00
	.db $00
	.db $00
	.db $c0	; TREASURE_RED_ORE, TREASURE_BLUE_ORE
	.db $80	; TREASURE_HARD_ORE
	.db $00
	.db $00
	.db $00
	.db $00

@comboTreasureFlagMask_seasons:
	.db $10
	.db $24	; TREASURE_PUNCH, TREASURE_SWORD
	.db $30	; TREASURE_BIGGORON_SWORD, TREASURE_BOMBCHUS
	.db $02	; TREASURE_HARP
	.db $00
	.db $e0	; TREASURE_TUNE_OF_ECHOES, TREASURE_TUNE_OF_CURRENTS, TREASURE_TUNE_OF_AGES
	.db $90	; TREASURE_RING_BOX, TREASURE_POTION
	.db $00
	.db $00
	.db $00
	.db $00
	.db $c0	; TREASURE_RED_ORE, TREASURE_BLUE_ORE
	.db $80	; TREASURE_HARD_ORE
	.db $00
	.db $00
	.db $00
	.db $00

;;
;  Param[out]	zflag	Set   if ages-linked/seasons-unlinked.
;                       Unset if seasons-linked/ages-unlinked.
determineSecretSet:
	xor a
	push hl
	ld hl,wFileIsLinkedGame
	bit 0,(hl)
	pop hl
	call wIsSeasons
	jr nc,+
		; seasons
		ret z

		; linked
		inc a ; unset zflag
		ret
	+

	; ages
	jr nz,+
		; unlinked
		inc a ; unset zflag
	+

	or a
	ret
.endif

;;
eraseFile:
	call getFileAddress1
	call @clearFile

.if defined(ROM_COMBO)
	; clear both files
	call toggleIsSeasons

	call getFileAddress1
	call @clearFile
	jp toggleIsSeasons
.else
	call getFileAddress2
.endif
;;
; @param bc
@clearFile:
	ld a,$0a
	ld ($1111),a
	ld l,c
	ld h,b
	call clearFileAtHl
	xor a
	ld ($1111),a
	ret

;;
copyFile:
	ld a,$0a
	ld ($1111),a

	; backup source save slot into c
	ldh a,(<hActiveFileSlot)
	ld c,a

.if defined(ROM_COMBO)
	; copy the game flags
	call getComboSaveFileFlags
	ld a,b
	ldh (<hActiveFileSlot),a
	ld a,(hl)
	call getComboSaveFileFlags
	ld (hl),a

	; copy the save data
	call toggleIsSeasons
	call @copyFile
	call toggleIsSeasons
.endif
	call @copyFile

	; disable SRAM chip
	ld a,$00
	ld ($1111),a
	ret

@copyFile
	; get the address to copy to
	push bc
	ld a,b
	ldh (<hActiveFileSlot),a
	call getFileAddress1
	ld d,b
	ld e,c
	pop bc

	; get the address to copy from
	push bc
	ld a,c
	ldh (<hActiveFileSlot),a
	call getFileAddress1
	ld h,b
	ld l,c

	; do the copy
	ld bc,$550
	call copyMemoryBc
	pop bc
	ret

;;
; Clear $0550 bytes at hl
clearFileAtHl:
.if defined(ROM_COMBO)
	push hl
	call getComboSaveFileFlags
	; unset all combo game flags
	xor a
	ld (hl),a
	pop hl
.endif
	ld bc,$0550
	jp clearMemoryBc

.ifndef ROM_COMBO
;;
; Checks both copies of the file data to see if one is valid.
; If one is valid but not the other, this also updates the invalid copy with the valid
; copy's data.
; @param[out] a $01 if copy 2 was valid while copy 1 wasn't
verifyFileCopies:
	call getFileAddress2
	ld l,c
	ld h,b
	call verifyFileAtHl
	and $01
	push af

	call getFileAddress1
	ld l,c
	ld h,b
	call verifyFileAtHl
	pop bc
	rl b

	; bit 0 set if copy 1 failed, bit 1 set if copy 2 failed
	ld a,b
	rst_jumpTable
	.dw @bothCopiesValid
	.dw @copy1Invalid
	.dw @copy2Invalid
	.dw @bothCopiesInvalid

;;
@copy2Invalid:
	call getFileAddress2
	ld e,c
	ld d,b
	call getFileAddress1
	ld l,c
	ld h,b
	call copyFileFromHlToDe

;;
@bothCopiesValid:
	xor a
	ret

;;
@copy1Invalid:
	call getFileAddress1
	ld e,c
	ld d,b
	call getFileAddress2
	ld l,c
	ld h,b
	call copyFileFromHlToDe
	ld a,$01
	ret

;;
@bothCopiesInvalid:
	ld a,$ff
	ret
.endif

;;
; Copy a file ($0550 bytes) from hl to de.
; @param de Destination address
; @param hl Source address
copyFileFromHlToDe:
	push hl
	ld a,$0a
	ld ($1111),a
	ld bc,$0550
	call copyMemoryBc
	xor a
	ld ($1111),a
	pop hl
	ret

;;
; @param hl Address of file
; @param[out] a Equals $ff if verification failed
; @param[out] cflag Set if verification failed
verifyFileAtHl:
	push hl
	ld a,$0a
	ld ($1111),a

	; Verify checksum
	call calculateFileChecksum
	ldi a,(hl)
	cp e
	jr nz,@verifyFailed
	ldi a,(hl)
	cp d
	jr nz,@verifyFailed

	; Verify the savefile string
	.ifdef ROM_COMBO
		call wIsSeasons
		ld de,saveVerificationString_seasons
		jr c,+
			ld de,saveVerificationString_ages
		+
	.else
		ld de,saveVerificationString
	.endif
	ld b,$08
@nextChar:
	ld a,(de)
	cp (hl)
	jr nz,@verifyFailed

	inc de
	inc hl
	dec b
	jr nz,@nextChar

@verifyDone:
	xor a
	ld ($1111),a
	pop hl
	ld a,b
	rrca
	ret

	; Clear the save data
@verifyFailed:
	pop hl
	push hl
	call clearFileAtHl
	ld b,$ff
	jr @verifyDone

;;
; Calculate a checksum over $550 bytes (excluding the first 2) for a save file
; @param hl Address to start at
; @param[out] de Checksum
calculateFileChecksum:
	push hl
	ld a,$02
	rst_addAToHl
	ld bc,$02a7
	ld de,$0000
--
	ldi a,(hl)
	add e
	ld e,a
	ldi a,(hl)
	adc d
	ld d,a
	dec bc
	ld a,b
	or c
	jr nz,--

	pop hl
	ret

;;
; Get the first address of the save data
; @param hActiveFileSlot Save slot
; @param[out] bc Address
getFileAddress1:
	ld c,$00
.ifdef ROM_COMBO
	call wIsSeasons
	jr nc,+
.else
	jr +
.endif

;;
; Get the second (backup?) address of the save data
; @param hActiveFileSlot Save slot
; @param[out] bc Address
getFileAddress2:
	ld c,$03
+
	push hl
	ldh a,(<hActiveFileSlot)
	add c
	ld hl,@saveFileAddresses
	rst_addDoubleIndex
	ldi a,(hl)
	ld b,(hl)
	ld c,a
	pop hl
	ret

@saveFileAddresses:
	; ages saves in combo rom
	.dw $a010
	.dw $a560
	.dw $aab0

	; seasons saves in combo rom
	.dw $b000
	.dw $b550
	.dw $baa0

.if defined(ROM_COMBO)
;;
; @param[out] cflag Set if the last game played was seasons
getLastGamePlayed:
	push hl
	call _comboFlagHelper
	ld a,(hl)
	rlca
	jr _comboFlagReturn

;;
; @param[out] zflag Unset if both games were started on this savefile
getComboStarted:
	push hl
	call _comboFlagHelper
	bit COMBO_FLAG_BIT_LINKED_STARTED,(hl)
	jr _comboFlagReturn

setComboCompleted:
	push hl
	call _comboFlagHelper
	set COMBO_FLAG_BIT_LINKED_BEATEN,(hl)
	jr _comboFlagReturn

getComboCompleted:
	push hl
	call _comboFlagHelper
	bit COMBO_FLAG_BIT_LINKED_BEATEN,(hl)

_comboFlagReturn:
	; disable SRAM chip
	ld a,$00
	ld ($1111),a
	pop hl
	ret

_comboFlagHelper:
	; enable SRAM chip
	ld a,$0a
	ld ($1111),a
	call getComboSaveFileFlags
	ret

;;
; @param[out] hl Address of the flags for this savefile combo
getComboSaveFileFlags:
	push af
	ldh a,(<hActiveFileSlot)
	ld hl,@comboGameFlagAddresses
	rst_addDoubleIndex
	rst_derefHl
	pop af
	ret

@comboGameFlagAddresses:
	.dw $bff0 + $00
	.dw $bff0 + $01
	.dw $bff0 + $02
.endif

;;
; @param hl Address of initial values (should point to initialFileVariables or some
; variant)
initializeFileVariables:
	ld d,>wc600Block
--
	ldi a,(hl)
	or a
	jr z,+

	ld e,a
.if defined(ROM_COMBO)
	cp <wAnimalCompanion
	ldi a,(hl)
	jr nz,++
		call wIsSeasons
		jr nc,++
			; seasons needs to start with companion as ricky
			ld a,SPECIALOBJECT_RICKY
	++
.else
	ldi a,(hl)
.endif
	ld (de),a
	jr --
+
	ret

; Table to distinguish initial file data based on whether it's a standard, linked, or hero
; game.
initialFileVariablesTable:
	.dw initialFileVariables_standardGame
	.dw initialFileVariables_linkedGame
	.dw initialFileVariables_heroGame
	.dw initialFileVariables_linkedGame

; Initial values for variables in the c6xx block.
initialFileVariables:
.ifdef MORE_MESSAGE_SPEEDS
	.db <wMiscSettings,			$9d
	.db <wMiscSettings+1,		$80
.else
	.db <wTextSpeed,			$04
.endif
	.db <wc608,				$01
	.db <wLinkName+5,			$00 ; Ensure names have null terminator
	.db <wKidName+5,			$00
	.db <wObtainedTreasureFlags,		1<<TREASURE_PUNCH
	.db <wMaxBombs,				$10
	.db <wLinkHealth,			$10 ; 4 hearts (gets overwritten in standard game)
	.db <wLinkMaxHealth,			$10
.if defined(ENABLE_NEW_GAME_PLUS) || defined(ROM_COMBO)
initialFileVariables_ages:
.endif
.if defined(ROM_AGES) || defined(ROM_COMBO)
	; Initial spawn location
	.db <wDeathRespawnBuffer.group,		$00
	.db <wDeathRespawnBuffer.room,		$8a
	.db <wDeathRespawnBuffer.y,		$38
	.db <wDeathRespawnBuffer.x,		$48
	.db <wDeathRespawnBuffer.facingDir,	$00

	.db <wJabuWaterLevel,			$21
	.db <wPortalGroup,			$ff
	.db <wPirateShipRoom,			$b6
	.db <wPirateShipY,			$48
	.db <wPirateShipX,			$48
	.db <wPirateShipAngle,			$02
.if defined(ROM_COMBO)
	.db $00

initialFileVariables_seasons:
.endif
.endif
.if defined(ROM_SEASONS) || defined(ROM_COMBO)
	; Initial spawn location
	.db <wDeathRespawnBuffer.group,		$00
	.db <wDeathRespawnBuffer.room,		$a7
	.db <wDeathRespawnBuffer.y,		$38
	.db <wDeathRespawnBuffer.x,		$48
	.db <wDeathRespawnBuffer.facingDir,	$02
.endif
.if defined(ROM_COMBO)
	; these are in a union with seasons variables, so ensure they're cleared
	.db <wJabuWaterLevel,			$00
	.db <wPortalGroup,				$00
	.db <wPirateShipRoom,			$00
	.db <wPirateShipY,				$00
	.db <wPirateShipX,				$00
	.db <wPirateShipAngle,			$00
.endif
	.db $00

; Standard game (not linked or hero)
initialFileVariables_standardGame:
	.db <wLinkHealth,			$0c ; 3 hearts
	.db <wLinkMaxHealth,			$0c
	; Continue reading the following data

; Hero game (not linked+hero game)
initialFileVariables_heroGame:
	.db <wChildStatus,			$00
	.db <wShieldLevel,			$01
.if defined(ROM_AGES) || defined(ROM_COMBO)
	.db <wAnimalCompanion,			$00
.else
	.db <wAnimalCompanion,			SPECIALOBJECT_RICKY
.endif
	.db $00

; Linked game, or linked+hero game
initialFileVariables_linkedGame:
	.db <wSwordLevel,			$01
	.db <wShieldLevel,			$01
	.db <wInventoryStorage,			ITEM_SWORD
	.db <wObtainedTreasureFlags,	(1<<TREASURE_PUNCH) | (1<<TREASURE_SWORD)
.if defined(ROM_AGES) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
initialFileVariables_linkedGame_ages:
.endif
	.db <wPirateShipY,			$58
	.db <wPirateShipX,			$78
.endif
	.db $00

.ifdef ENABLE_NEW_GAME_PLUS
initialNgpFileVariablesTable:
	.dw initialNgpFileVariables_standardGame
	.dw initialNgpFileVariables_linkedGame
	.dw initialNgpFileVariables_heroGame
	.dw initialNgpFileVariables_linkedGame

initialNgpFileVariables_linkedGame:
	.db <wInventoryStorage,			ITEM_SWORD
	.db <wObtainedTreasureFlags,	(1<<TREASURE_PUNCH) | (1<<TREASURE_SWORD)
	.db $00

initialNgpFileVariables_standardGame:
initialNgpFileVariables_heroGame:
	.db <wChildStatus,				$00
	.db <wAnimalCompanion,			$00
	.db $00

.endif

; This string is different in ages and seasons.
.ifdef ROM_COMBO
saveVerificationString_ages:
	;.ASC "Z-AGES-0"
	.ASC "Z21216-0"
saveVerificationString_seasons:
	;.ASC "Z-SEAS-0"
	.ASC "Z11216-0"
.else
saveVerificationString:
.if defined(ROM_AGES)
	.ASC "Z21216-0"
.else
	.ASC "Z11216-0"
.endif
.endif