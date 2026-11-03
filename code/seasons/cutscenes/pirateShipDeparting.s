;;
; CUTSCENE_S_PIRATES_DEPART
cutsceneHandler_0c:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw cutsceneHandler_0c_stage0 ; initial
	.dw cutsceneHandler_0c_stage1 ; digging through subrosia
	.dw cutsceneHandler_0c_stage2 ; inside ship
	.dw cutsceneHandler_0c_stage3 ; out in samasa desert
	.dw cutsceneHandler_0c_stage4 ; back inside ship
	.dw cutsceneHandler_0c_stage5 ; approaching west coast

cutsceneHandler_0c_stage0:
	ld b,$10
	ld hl,wGenericCutscene.cutsceneTimer
	call clearMemory
	call clearWramBank1
	xor a
	ld (wDisabledObjects),a
	ld (wScrollMode),a
	ld a,(wGfxRegs2.SCY)
	ld (wGenericCutscene.cbba),a
	ld a,$80
	ld (wMenuDisabled),a
	ld a,$01
	ld (wCutsceneState),a
	ret

cutsceneHandler_0c_stage1:
	call seasonsFunc_03_6b6c
	ld a,(wFrameCounter)
	and $07
	ret nz
	ld a,(wGenericCutscene.cutsceneTimer)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	call incCbb3
	ld a,$08
	ld (wGenericCutscene.cbb8),a
	ld a,$04
	ld (wGenericCutscene.cbb4),a
	ld a,GFXH_PIRATE_SHIP_LEAVING_SUBROSIA_LAYOUT
	call loadGfxHeader
	ld a,GFXH_PIRATE_SHIP_MOVING_EXTRA_TILES
	call loadGfxHeader
	ld a,$04
	ldh (<hNextLcdInterruptBehaviour),a
	call seasonsFunc_03_681a
	jp seasonsFunc_03_67f8
@state0Func0:
	ld hl,@subrosianSandReplacementPositions
	ld d,$0f
-
	ldi a,(hl)
	ld c,a
	ld a,$0f
	push hl
	call setTile
	pop hl
	dec d
	jr nz,-
	ret
@subrosianSandReplacementPositions:
	.db $04 $05 $06 $07 $08
	.db $14 $15 $16 $17 $18
	.db $24 $25 $26 $27 $28

@state1:
	ld hl,wGenericCutscene.cbb4
	dec (hl)
	ret nz
	ld bc,TX_4e00
	call showText
	call @state0Func0
	jp incCbb3

@state2:
	call retIfTextIsActive
.ifdef ROM_COMBO
	ld hl,objectData_seasons.objectData_sandPuffsFromShipDigging
.else
	ld hl,objectData.objectData_sandPuffsFromShipDigging
.endif
	call parseGivenObjectData
	ld a,MUS_TRIUMPHANT
	call playSound
	jp incCbb3

@state3:
	call incCbbfAndCbb8
	ld a,(hl)
	cp $10
	jr c,+
	call seasonsFunc_03_681a
	jr nz,+
	call incCbb3
+
	jp seasonsFunc_03_67f8

@state4:
	call incCbbfAndCbb8
	ld a,(hl)
	cp $30
	jr c,seasonsFunc_03_67f8
	call fadeoutToWhite
	call incCbb3
	jr seasonsFunc_03_67f8

@state5:
	call incCbbfAndCbb8
	ld a,(wPaletteThread_mode)
	or a
	jr nz,seasonsFunc_03_67f8
	ld a,$c7
	ld (wGfxRegs1.WINY),a
	ld (wGfxRegs2.WINY),a
	ld a,$03
	ldh (<hNextLcdInterruptBehaviour),a
	ld a,$02
seasonsFunc_03_67e9:
	ld (wCutsceneState),a
	xor a
	ld (wTmpcfc0.normal.cfc0),a
	ld b,$10
	ld hl,wGenericCutscene.cutsceneTimer
	jp clearMemory

seasonsFunc_03_67f8:
	ld a,$40
	ld (wGfxRegs2.LYC),a
	ld a,$47
	ld (wGfxRegs2.WINX),a
	ld a,$a5
	ld (wGfxRegs1.WINX),a
	ld a,(wGenericCutscene.cbb8)
	ld (wGfxRegs2.WINY),a
	ld (wGfxRegs1.WINY),a
	ld (wGenericCutscene.cbbc),a
	jr seasonsFunc_03_684c

incCbb3:
	ld hl,wGenericCutscene.cutsceneTimer
	inc (hl)
	ret

seasonsFunc_03_681a:
	ld a,(wGenericCutscene.cbb7)
	ld hl,seasonsTable_03_6844
	rst_addAToHl
	ld a,(hl)
	cp $ff
	ret z
	ld l,a
	ld h,FIRST_INTERACTION_INDEX
	push hl
	ld de,VRAM_0_TILEMAP_1
	ld bc,$0f02
	call queueDmaTransfer
	pop hl
	set 2,h
	ld e,$01
	call queueDmaTransfer
	ld a,$08
	ld (wGenericCutscene.cbb8),a
	ld hl,wGenericCutscene.cbb7
	inc (hl)
	ret

seasonsTable_03_6844:
	.db $c0 $a0 $80 $60
	.db $40 $20 $00 $ff

seasonsFunc_03_684c:
	ld a,$02
	ldh (R_SVBK),a
	ld a,(wGenericCutscene.cbb8)
	and $07
	ld hl,w2WaveScrollValues
	rst_addDoubleIndex
	ld de,w2PirateShipUnknownTileRow5
	ld b,$10
	call copyMemory
	ld a,(wGenericCutscene.cbb8)
	and $07
	ld hl,w2WaveScrollValues+$20
	rst_addDoubleIndex
	ld de,w2PirateShipUnknownTileRow6
	ld b,$10
	call copyMemory
	ld a,$00
	ldh (R_SVBK),a
	ld hl,w2PirateShipUnknownTileRow5
	ld de,VRAM_1_TILEDATA_2+$4e0
	ld bc,$0102
	jp queueDmaTransfer

cutsceneHandler_0c_stage2:
	ld a,(wGenericCutscene.cutsceneTimer)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@seasonsFunc_03_688c:
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call incCbb3
	ld bc,ROOM_SEASONS_5d4
	call cutsceneHandler_0c_stage3@loadNewRoom
	ld hl,w1Link.enabled
	ld (hl),$03
	ld l,<w1Link.yh
	ld (hl),$58
	ld l,<w1Link.xh
	ld (hl),$70
	ld l,<w1Link.direction
	ld (hl),$02
	xor a
	ld (wLinkForceState),a
	ld a,$01
	ld (wScreenShakeMagnitude),a
	call resetCamera
	ld a,$02
	jp cutsceneHandler_0c_stage3@state0Func1

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call @seasonsFunc_03_688c
.ifdef ROM_COMBO
	ld hl,objectData_seasons.objectData_insidePirateShipLeavingSubrosia
.else
	ld hl,objectData.objectData_insidePirateShipLeavingSubrosia
.endif
	jp parseGivenObjectData

@state1:
	ret

@state2:
	ld a,$03
	call seasonsFunc_03_67e9
	jp fadeoutToWhite

cutsceneHandler_0c_stage3:
	ld a,(wGenericCutscene.cutsceneTimer)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call incCbb3
	ld a,$40
	ld (wGenericCutscene.cbb8),a
	ld (wGenericCutscene.cbbf),a
	ld a,$1e
	ld (wGenericCutscene.cbb4),a
	ld a,$01
	ld (wRoomStateModifier),a
	ld bc,ROOM_SEASONS_0fe
	call @loadNewRoom
	call @state0Func2
	ld e,OBJ_GFXH_0d-1
	call loadObjectGfxHeaderToSlot4
	ld a,GFXH_PIRATE_SHIP_LEAVING_DESERT_LAYOUT
	call loadGfxHeader
.ifdef ROM_COMBO
	ld hl,objectData_seasons.objectData_leavingSamasaDesert
.else
	ld hl,objectData.objectData_leavingSamasaDesert
.endif
	call parseGivenObjectData
	ld a,$11
	jr @state0Func1
@loadNewRoom:
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call loadScreenMusicAndSetRoomPack
	call loadTilesetData
	call loadTilesetGraphics
	jp func_131f
@state0Func1:
	push af
	ld a,$01
	ld (wScrollMode),a
	call fadeinFromWhite
	call loadCommonGraphics
	pop af
	jp loadGfxRegisterStateIndex
@state0Func2:
	ld hl,@state0Table0
-
	ldi a,(hl)
	cp $ff
	ret z
	ld c,a
	ldi a,(hl)
	push hl
	call setTile
	pop hl
	jr -
@state0Table0:
	; position - tile - position - tile
	.db $05 $ad $06 $ad
	.db $08 $ae $09 $ae
	.db $15 $ad $16 $ad
	.db $18 $ae $19 $ae
	.db $25 $ad $26 $ad
	.db $28 $ae $29 $ae
	.db $35 $ad $36 $ad
	.db $38 $ae $39 $ae
	.db $ff

@state1:
	ld hl,wGenericCutscene.cbb4
	dec (hl)
	ret nz
	call incCbb3
	xor a
	ldh (<hCameraY),a
	ldh (<hCameraX),a
	ld bc,TX_4e09
	jp showText

@state2:
	call retIfTextIsActive
	ld a,$ff
	ld (wTmpcfc0.normal.cfc0),a
	jp incCbb3

@state3:
	ld a,(wFrameCounter)
	and $07
	ret nz
	call incCbbfAndCbb8
	ld a,(hl)
	cp $70
	jr c,seasonsFunc_03_69d1
	call fadeoutToWhite
	ld a,$fb
	call playSound
	call incCbb3
	jr seasonsFunc_03_69d1

@state4:
	ld a,(wFrameCounter)
	and $07
	ret nz
	call incCbbfAndCbb8
	ld a,(wPaletteThread_mode)
	or a
	jr nz,seasonsFunc_03_69d1
	ld a,$c7
	ld (wGfxRegs1.WINY),a
	ld (wGfxRegs2.WINY),a
	ld a,$04
	ld (wCutsceneState),a
	ld b,$10
	ld hl,wGenericCutscene.cutsceneTimer
	jp clearMemory

seasonsFunc_03_69d1:
	ld a,$a5
	ld (wGfxRegs1.WINX),a
	ld a,(wGenericCutscene.cbb8)
	ld (wGfxRegs2.WINY),a
	ld (wGfxRegs1.WINY),a
	ld (wGenericCutscene.cbbc),a
	ret

cutsceneHandler_0c_stage4:
	ld a,(wGenericCutscene.cutsceneTimer)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call cutsceneHandler_0c_stage2@seasonsFunc_03_688c
	xor a
	ld (wTmpcfc0.normal.cfc0),a
.ifdef ROM_COMBO
	ld hl,objectData_seasons.objectData_sickPiratiansInShip
.else
	ld hl,objectData.objectData_sickPiratiansInShip
.endif
	jp parseGivenObjectData

@state1:
	ret

@state2:
	ld a,$05
	call seasonsFunc_03_67e9
	jp fadeoutToWhite

cutsceneHandler_0c_stage5:
	call seasonsFunc_03_6b6c
	ld a,(wGenericCutscene.cutsceneTimer)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call clearScreenVariablesAndWramBank1
	call incCbb3
	ld a,$90
	ld (wGenericCutscene.cbb8),a
	ld (wGenericCutscene.cbbf),a
	ld a,$10
	ld (wGenericCutscene.cbbd),a
	ld a,$03
	ld (wRoomStateModifier),a
	ld bc,ROOM_SEASONS_0f2
	call cutsceneHandler_0c_stage3@loadNewRoom
	ld a,$ff
	ld (wTilesetAnimation),a
	ld e,OBJ_GFXH_PIRATE_SHIP_TILES_1-1
	call loadObjectGfxHeaderToSlot4
	ld a,GFXH_PIRATE_SHIP_ARRIVING_LAYOUT
	call loadGfxHeader
	ld a,GFXH_PIRATE_SHIP_MOVING_EXTRA_TILES
	call loadGfxHeader
.ifdef ROM_COMBO
	ld hl,objectData_seasons.objectData_pirateShipEnteringWestCoast
.else
	ld hl,objectData.objectData_pirateShipEnteringWestCoast
.endif
	call parseGivenObjectData
	ld a,$12
	jp cutsceneHandler_0c_stage3@state0Func1

@state1:
	ld a,(wFrameCounter)
	and $03
	jr nz,@state1Func0
	call decCbbfAndCbb8
	ld a,(hl)
	cp $09
	jp nc,@state1Func0
	call seasonsFunc_03_6b30
	call incCbb3
@state1Func0:
	call seasonsFunc_03_69d1
	jr seasonsFunc_03_6aca

@state2:
	ld a,(wFrameCounter)
	and $07
	jr nz,@state1Func0
	call decCbbfAndCbb8
	ld a,(hl)
	cp $09
	jr nc,@state1Func0
	call seasonsFunc_03_6b30
	jr nz,@state1Func0
	ld a,GLOBALFLAG_PIRATE_SHIP_DOCKED
	call setGlobalFlag
	xor a
	ld (wActiveMusic),a
	ld hl,@state2WarpDestVariables
	jp setWarpDestVariables
@state2WarpDestVariables:
	m_HardcodedWarpA ROOM_SEASONS_0e2 $0f $66 $03

seasonsFunc_03_6a9d:
	ld a,$02
	ldh (R_SVBK),a
	ld a,(wGenericCutscene.cbbe)
	dec a
	and $03
	ld hl,seasonsTable_03_6b1a
	rst_addDoubleIndex
	rst_derefHl
	ld a,(wGenericCutscene.cbb8)
	and $07
	rst_addDoubleIndex
	ld de,w2PirateShipUnknownTileRow5
	call seasonsFunc_03_6b22
	ld a,$00
	ldh (R_SVBK),a
	ld hl,w2PirateShipUnknownTileRow5
	ld de,VRAM_0_TILEDATA_1+$4e0
	ld bc,$0102
	jp queueDmaTransfer

seasonsFunc_03_6aca:
	ld hl,wGenericCutscene.cbbd
	dec (hl)
	jr nz,seasonsFunc_03_6a9d
	ld (hl),$10
	ld a,$02
	ldh (R_SVBK),a
	ld a,(wGenericCutscene.cbbe)
	ld hl,seasonsTable_03_6b1a
	rst_addDoubleIndex
	rst_derefHl
	ld de,w2PirateShipUnknownTileRow3
	push hl
	call seasonsFunc_03_6b22
	pop hl
	ld a,(wGenericCutscene.cbb8)
	and $07
	rst_addDoubleIndex
	ld de,w2PirateShipUnknownTileRow5
	call seasonsFunc_03_6b22
	ld a,$00
	ldh (R_SVBK),a
	ld hl,w2PirateShipUnknownTileRow3
	ld de,VRAM_1_TILEDATA_1+$e0
	ld bc,$0102
	call queueDmaTransfer
	ld hl,w2PirateShipUnknownTileRow5
	ld de,VRAM_0_TILEDATA_1+$4e0
	ld bc,$0102
	call queueDmaTransfer
	ld a,(wGenericCutscene.cbbe)
	inc a
	and $03
	ld (wGenericCutscene.cbbe),a
	ret

seasonsTable_03_6b1a:
	.dw w2PirateShipBgTiles+$40
	.dw w2PirateShipBgTiles+$80
	.dw w2PirateShipBgTiles+$c0
	.dw w2PirateShipBgTiles+$100

seasonsFunc_03_6b22:
	ld b,$10
	call copyMemory
	ld bc,$0010
	add hl,bc
	ld b,$10
	jp copyMemory

seasonsFunc_03_6b30:
	ld a,(wGenericCutscene.cbb7)
	ld hl,seasonsTable_03_6b59
	rst_addDoubleIndex
	ldi a,(hl)
	cp $ff
	ret z
	ld h,(hl)
label_03_196:
	ld l,a
	push hl
	ld de,VRAM_0_TILEMAP_1
	ld bc,$2102
	call queueDmaTransfer
	pop hl
	set 2,h
	ld e,$01
	call queueDmaTransfer
	ld a,$10
	ld (wGenericCutscene.cbb8),a
	ld hl,wGenericCutscene.cbb7
	inc (hl)
	ret

seasonsTable_03_6b59:
	.dw w2TmpGfxBuffer+$20
	.dw w2TmpGfxBuffer+$40
	.dw w2TmpGfxBuffer+$60
	.dw w2TmpGfxBuffer+$80
	.dw w2TmpGfxBuffer+$a0
	.dw w2TmpGfxBuffer+$c0
	.dw w2TmpGfxBuffer+$e0
	.dw w2TmpGfxBuffer+$100
	.dw w2TmpGfxBuffer+$120
	.db $ff

seasonsFunc_03_6b6c:
	ld hl,oamData_03_6b72
	jp addSpritesToOam

oamData_03_6b72:
	.db $01
	.db $10 $a6 $4c $09

incCbbfAndCbb8:
	ld hl,wGenericCutscene.cbbf
	inc (hl)
	ld hl,wGenericCutscene.cbb8
	inc (hl)
	ret

decCbbfAndCbb8:
	ld hl,wGenericCutscene.cbbf
	dec (hl)
	ld hl,wGenericCutscene.cbb8
	dec (hl)
	ret
