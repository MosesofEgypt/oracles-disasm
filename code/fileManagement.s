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
.ifdef ENABLE_NEW_GAME_PLUS
	.dw initializeNgpFile

initializeNgpFile:
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

	ld hl,initialNgpFileVariables_spawn
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

;;
initializeFile:
	ld hl,initialFileVariables
	call initializeFileVariables
.if defined(ROM_COMBO)
	ld hl,initialFileVariables_seasons
	call wIsSeasons
	call c,initializeFileVariables
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
initialNgpFileVariables_spawn:
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