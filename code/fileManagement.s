.if defined(ROM_COMBO)
; Parameters:
; 1 - Offset to start copying to
; 2 - Length of data to copy
.macro m_LoadSavefileSection_len
	push hl
	ld bc,\1-wFileStart
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
	m_LoadSavefileSection_len \1 (\2-\1)
.endm
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
.if defined(ROM_COMBO)
	.dw comboLoadOtherGame
.else
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
	; mark save as not having both games started
	ld a,$0a
	ld ($1111),a
	call getComboSaveFileFlags
	res 0,(hl)
	xor a
	ld ($1111),a
.endif

	; Unequip all rings, but don't remove from box
	ld hl,wRingReduxFlags
	ld a,$1f
	ld (hl),a

.ifdef EXTENDED_RING_BOX
	ld hl,wRingReduxFlagsExt
	ld (hl),a
.endif

	; record whether or not the player has the biggorons sword
	ld a,(wObtainedTreasureFlags+(TREASURE_BIGGORON_SWORD>>3))
	and 1<<(TREASURE_BIGGORON_SWORD&$07)
	push af

	xor a
	ld hl,wDeathRespawnBuffer
	ld b,wGashaSpotFlags-wDeathRespawnBuffer
	call fillMemory

	ld hl,(wGashaMaturity+2)
	ld b,wLinkMaxHealth-(wGashaMaturity+2)
	call fillMemory

	ld hl,wNumEmberSeeds
	ld b,wRingBoxContents-wNumEmberSeeds
	call fillMemory

	ld hl,wKilledGoldenEnemies
	ld b,(wSecretType+1)-wKilledGoldenEnemies
	call fillMemory

	; we want to clear all the room flags EXCEPT the one
	; indicating if the screen was seen or not. this way
	; the minimap discovery carries over between games
	ld hl,wGroup0RoomFlags
	ld bc,$200
	-
		ld a,(hl)
		and $10
		ldi (hl),a
		dec bc
		xor a
		or c
		jr nz,-
		or b
		jr nz,-

	xor a
	ld hl,wGroup4RoomFlags
	ld bc,$200
	call fillMemoryBc

	ld (wFluteIcon),a
	ld (wObtainedSeasons),a
	ld (wNumBombs),a
	ld (wNumBombchus),a

	ld (wSatchelSelectedSeeds),a
	ld (wShooterSelectedSeeds),a
	ld (wSlingshotSelectedSeeds),a

	ld hl,initialFileVariables_ages
	call initializeFileVariables
.if defined(ROM_COMBO)
	ld hl,initialFileVariables_seasons
	call wIsSeasons
	call c,initializeFileVariables
.endif

	pop af
	or a
	jr z,+
		; add biggoron sword to inventory
		ld hl,initialNgpFileVariables_biggoronsword
		call initializeFileVariables
	+

	; set wLinkHealth to wLinkMaxHealth
	ld hl,wLinkMaxHealth
	ldd a,(hl)
	ld (hl),a

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
.endif

noFileManagementOp:
	ret

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
		; the code for creating the exclamation mark is the same
		; for both games, so we're just using ages for both
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
		bit 7,(hl)

		; if the flag differs, that means both games were started
		; on this savefile, so we need to indicate this via flags
		jr z,++
			res 7,(hl)
			set 0,(hl)
			jr ++
	+
		; seasons
		bit 7,(hl)
		jr nz,++
			set 7,(hl)
			set 0,(hl)
			jr ++
	++
	xor a
	ld ($1111),a

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
loadFile:
.ifdef ROM_COMBO
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
	call getBothGamesStarted

	ld hl,wFileChecksum ; using checksum to tell if loaded or initialized
	push hl
	jr nz,+
		call initializeComboGame
		xor a
		jr ++
	+
		call loadAcrossComboGame
		ld a,$ff
	++
	pop hl
	ldi (hl),a
	ldi (hl),a

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
	push bc
	; record bonus items the player has
	ld b,$00
	ld a,TREASURE_BIGGORON_SWORD
	call checkTreasureObtained
	jr nc,+
		set 0,b
	+
	push bc

	; get the savefile address to read from
	call getFileAddress1
	ld h,b
	ld l,c

	; enable SRAM chip
	ld a,$0a
	ld ($1111),a

	m_LoadSavefileSection_len wChildStatus,			$06
	m_LoadSavefileSection_len wSavefileString,		$08
	m_LoadSavefileSection_len wFluteIcon,			$01
	m_LoadSavefileSection_end wDeathRespawnBuffer,	wLinkHealth
	m_LoadSavefileSection_end wEssencesObtained,	wTradeItem+1
	m_LoadSavefileSection_end wKilledGoldenEnemies,	wSlingshotSelectedSeeds+1
	m_LoadSavefileSection_end wBiggoronSwordOverflowItem, wSaveFileMainSectionEnd
	m_LoadSavefileSection_end wGroup0RoomFlags,		wGroupRoomFlagsEnd

	; disable SRAM chip
	xor a
	ld ($1111),a
	pop bc

	; give the player the bonus items
	bit 0,b
	jr z,+
		ld a,TREASURE_BIGGORON_SWORD
		call checkTreasureObtained
		call nc,giveTreasure
	+

	pop bc
	ret

;;
; Working from the existing WRAM save data, this clears and initializes
; select portions of the save file so it can be used for the other game.
initializeComboGame:
	; track whether the user got the ring box from vasu to prevent a free upgrade
	ld a,GLOBALFLAG_OBTAINED_RING_BOX
	call checkGlobalFlag
	push af

	; unset all the treasure flags except the ones specified below
	ld hl,wObtainedTreasureFlags

	ld a,1<<TREASURE_ROD_OF_SEASONS			; $07
	and (hl)
	ldi (hl),a

	ld a,1<<(TREASURE_BIGGORON_SWORD-$08)	; $0c
	and (hl)
	ldi (hl),a

	ld a,1<<(TREASURE_HARP-$10)				; $11
	and (hl)
	ldi (hl),a

	xor a
	ldi (hl),a

	ld a,1<<(TREASURE_TUNE_OF_ECHOES-$20)	; $25
	or   1<<(TREASURE_TUNE_OF_CURRENTS-$20)	; $26
	or   1<<(TREASURE_TUNE_OF_AGES-$20)		; $27
	and (hl)
	ldi (hl),a

	ld a,1<<(TREASURE_POTION-$28)			; $2f
	and (hl)
	ldi (hl),a

	; clear the rest of the flags
	xor a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld  (hl),a

	; toggle the game type and set as linked game
	ld hl,wWhichGame
	ld a,(hl)
	xor $01
	ldi (hl),a
	; set the linked-game bit
	set 0,(hl)
	ld hl,wFileIsCompleted
	ld a,$f0
	and (hl)
	; set the bit indicating that warping to other game is allowed
	or $08
	ld (hl),a

	.ifdef ENABLE_RING_REDUX
		xor a
		ld (wRingReduxFlagsExt),a
	.endif

	; clear all game tracker variables and such
	ld hl,wDeathRespawnBuffer
	ld b,wObtainedTreasureFlags-wDeathRespawnBuffer
	call clearMemory

	ld hl,wFluteIcon
	ld b,wRingBoxLevel-wFluteIcon
	call clearMemory

	ld hl,wGlobalFlags
	ld b,(wSlingshotSelectedSeeds+1)-wGlobalFlags
	call clearMemory

	ld hl,wBiggoronSwordOverflowItem
	ld bc,wSaveFileMainSectionEnd-wBiggoronSwordOverflowItem
	call clearMemoryBc

	ld hl,wGroup0RoomFlags
	ld bc,wGroupRoomFlagsEnd-wGroup0RoomFlags
	call clearMemoryBc

	ld a,(1<<TREASURE_PUNCH)
	ld (wObtainedTreasureFlags),a

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

	ld a,$ff
	; clear the ring box
	ld hl,wRingBoxContents
	ld b,$05
	call fillMemory

	.ifdef EXTENDED_RING_BOX
		ld hl,wRingBoxContentsExt
		ld b,$05
		call fillMemory
	.endif

	; restore the ring box flag
	pop af
	ld a,GLOBALFLAG_OBTAINED_RING_BOX
	call nz,setGlobalFlag

	; put temporary items in the equipped slots so the items
	; we give the player get put into the inventory instead
	ld a,ITEM_SWORD
	ld hl,wInventoryB
	ldi (hl),a
	ld  (hl),a

	; give the player the bonus items they had
	ld hl,@bonusItems
	ld a,(hl)
	-
		call checkTreasureObtained
		ldi a,(hl)
		call c,giveTreasure
		ld a,(hl)
		or a
		jr nz,-

	; ensure the player has a way to get back to the other game if they want to
	ld a,TREASURE_SEED_SATCHEL
	call giveTreasure
	ld a,TREASURE_GALE_SEEDS
	call giveTreasure

	; these are automatically given with the satchel. remove them
	ld a,TREASURE_EMBER_SEEDS
	call loseTreasure

	ld a,$03
	ld (wSatchelSelectedSeeds),a

	ld a,$01
	ld (wSelectedHarpSong),a

	; remove the temporary items
	xor a
	ld hl,wInventoryB
	ldi (hl),a
	ld  (hl),a

	; save the new file
	jp saveFile

@bonusItems:
	.db TREASURE_ROD_OF_SEASONS
	.db TREASURE_BIGGORON_SWORD
	.db TREASURE_HARP
	.db $00

.endif

;;
eraseFile:
	call getFileAddress1
.ifndef ROM_COMBO
	call @clearFile

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
; Clear $0550 bytes at hl
clearFileAtHl:
.if defined(ROM_COMBO)
	push hl
	call getComboSaveFileFlags
	; unset the flag indicating the other game in the file was started
	res 0,(hl)
	; unset the flag indicating which game was last loaded
	res 7,(hl)
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
; @param[out] zflag Unset if both games were started on this savefile
getBothGamesStarted:
	push hl
	
	; enable SRAM chip
	ld a,$0a
	ld ($1111),a
	call getComboSaveFileFlags
	xor a
	bit 0,(hl)

	; disable SRAM chip
	ld ($1111),a

	pop hl
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
	ldi a,(hl)
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
.ifdef ENABLE_NEW_GAME_PLUS
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
	.db <wObtainedTreasureFlags,		(1<<TREASURE_PUNCH) | (1<<TREASURE_SWORD)
.if defined(ROM_COMBO)
initialFileVariables_linkedGame_ages:
.endif
.if defined(ROM_AGES) || defined(ROM_COMBO)
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
initialNgpFileVariables_standardGame:
initialNgpFileVariables_heroGame:
	.db <wInventoryStorage+1,		ITEM_LIFE_VIAL
	.db <wObtainedTreasureFlags+2,	(1<<(TREASURE_LIFE_VIAL-16))
	.db <wChildStatus,				$00
	.db <wAnimalCompanion,			$00
	.db $00

initialNgpFileVariables_biggoronsword:
	.db <wInventoryStorage+$0f,									ITEM_BIGGORON_SWORD
	.db <wObtainedTreasureFlags+(TREASURE_BIGGORON_SWORD>>3),	(1<<(TREASURE_BIGGORON_SWORD&$07))
	.db $00
.endif

; This string is different in ages and seasons.
.ifdef ROM_COMBO
saveVerificationString_ages:
	.ASC "Z21216-0"
saveVerificationString_seasons:
	.ASC "Z11216-0"
.else
saveVerificationString:
.if defined(ROM_AGES)
	.ASC "Z21216-0"
.else
	.ASC "Z11216-0"
.endif
.endif