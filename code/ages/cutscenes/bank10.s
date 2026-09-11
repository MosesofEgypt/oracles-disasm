; TODO: Some code in this file is shared with "code/seasons/cutscenes/endgameCutscenes.s"

.if !defined(ROM_COMBO)
m_section_superfree Cutscenes_Bank10 NAMESPACE cutscenesBank10
.endif

; Input values for the intro cutscene in the temple
templeIntro_simulatedInput:
	dwb   45  $00
	dwb   16  BTN_UP
	dwb   48  $00
	dwb   32  BTN_UP
	dwb   24  $00
	dwb   32  BTN_UP
	dwb   48  $00
	dwb   34  BTN_UP
	dwb  112  $00
	dwb    5  BTN_UP
	dwb   32  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb    5  BTN_UP
	dwb   36  $00
	dwb   12  BTN_UP
	.dw $ffff

; Exiting tower
blackTowerEscape_simulatedInput1:
	dwb  96 $00
	; Fall though

; Leaving screen
blackTowerEscape_simulatedInput2:
	dwb  33 BTN_DOWN
	dwb 256 $00
	.dw $ffff

; Walking up to ambi's guards
blackTowerEscape_simulatedInput3:
	dwb  48 BTN_UP
	dwb   4 $00
	dwb  16 BTN_RIGHT
	dwb   1 BTN_UP
	dwb 256 $00
	.dw $ffff

; Same room as above
blackTowerEscape_simulatedInput4:
	dwb  16 BTN_UP
	dwb 256 $00
	.dw $ffff


agesFunc_10_70f6:
	xor a
	ldh (<hOamTail),a
	ld de,wGenericCutscene.endingCutsceneSubstate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
@substate0:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incEndingCutsceneSubstate
	call disableLcd
	call clearDynamicInteractions
	call clearOam
	xor a
	ld (wTmpcfc0.genericCutscene.cfde),a
	ld a,GFXH_CREDITS_SCROLL
	call loadGfxHeader
	ld a,PALH_a0
	call loadPaletteHeader
	ld a,$09
	call loadGfxRegisterStateIndex
	call fadeinFromWhite
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_CREDITS_TEXT_VERTICAL
	ld l,Interaction.yh
	ld (hl),$e8
	inc l
	inc l
	ld (hl),$50
	ret
@substate1:
	ld a,(wTmpcfc0.genericCutscene.cfdf)
	or a
	ret z
	ld hl,wGenericCutscene.cutsceneTimer
	ld (hl),$e0
	inc hl
	ld (hl),$01
	jp incEndingCutsceneSubstate
@substate2:
	ld hl,wGenericCutscene.cutsceneTimer
	call decHlRef16WithCap
	ret nz
	call checkIsLinkedGame
	jr nz,@func_7174
.ifdef ROM_COMBO
	call cutscene_clearTmpCBB3
.else
	callab bank3Cutscenes.cutscene_clearTmpCBB3
.endif
	ld a,$03
	ld (wMapMenu.drawWarpDestinations),a
	ld a,$04
	jp fadeoutToWhiteWithDelay
@func_7174:
	ld a,$04
	ld (wGenericCutscene.cutsceneTimer),a
	ld a,(wGfxRegs1.SCY)
	ldh (<hCameraY),a
	ld a,UNCMP_GFXH_01
	call loadUncompressedGfxHeader
	ld a,PALH_0b
	call loadPaletteHeader
	ld b,$03
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_INTRO_SPRITES_1
	inc l
	ld (hl),$09
	inc l
	dec b
	ld (hl),b
	jr nz,-
+
	jp incEndingCutsceneSubstate
@substate3:
	ld a,(wGfxRegs1.SCY)
	or a
	jr nz,@func_71aa
	ld a,$78
	ld (wGenericCutscene.cutsceneTimer),a
	jp incEndingCutsceneSubstate
@func_71aa:
	call decCutsceneTimer
	ret nz
	ld (hl),$04
	ld hl,wGfxRegs1.SCY
	dec (hl)
	ld a,(hl)
	ldh (<hCameraY),a
	ret
@substate4:
	call decCutsceneTimer
	ret nz
	ld a,$ff
	ld (wTmpcbba),a
	jp incEndingCutsceneSubstate
@substate5:
	ld hl,wGenericCutscene.cutsceneTimer
	ld b,$01
	call flashScreen
	ret z
	call disableLcd
	ld a,GFXH_CREDITS_LINKED_WAVING_GOODBYE
	call loadGfxHeader
	ld a,PALH_9f
	call loadPaletteHeader
	call clearDynamicInteractions
	ld b,$03
-
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),INTERAC_cf
	inc l
	dec b
	ld (hl),b
	jr nz,-
+
	ld a,$04
	call loadGfxRegisterStateIndex
	ld a,$04
	call fadeinFromWhiteWithDelay
	call incEndingCutsceneSubstate
	ld a,$f0
	ld (wGenericCutscene.cutsceneTimer),a
@func_71fd:
	xor a
	ldh (<hOamTail),a
	ld a,(wGfxRegs1.SCY)
	cp $60
	jr nc,+
	cpl
	inc a
	ld b,a
	ld a,(wFrameCounter)
	and $01
	jr nz,+
	ld c,a
.ifdef ROM_COMBO
	ld hl,oamData_4ed8
	ld e,:oamData_4ed8
.else
	ld hl,bank16.oamData_4ed8
	ld e,:bank16.oamData_4ed8
.endif
	call addSpritesFromBankToOam_withOffset
+
	ld a,(wGfxRegs1.SCY)
	cpl
	inc a
	ld b,$c7
	add b
	ld b,a
	ld c,$38
.ifdef ROM_COMBO
	ld hl,oamData_4f21
	ld e,:oamData_4f21
.else
	ld hl,bank16.oamData_4f21
	ld e,:bank16.oamData_4f21
.endif
	push bc
	call addSpritesFromBankToOam_withOffset
	pop bc
	ld a,(wGfxRegs1.SCY)
	cp $60
	ret c
.ifdef ROM_COMBO
	ld hl,oamData_4f56
	ld e,:oamData_4f56
.else
	ld hl,bank16.oamData_4f56
	ld e,:bank16.oamData_4f56
.endif
	jp addSpritesFromBankToOam_withOffset
@substate6:
	call @func_71fd
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCutsceneTimer
	ret nz
	ld a,$04
	ld (wGenericCutscene.cutsceneTimer),a
	jp incEndingCutsceneSubstate
@substate7:
	ld a,(wGfxRegs1.SCY)
	cp $98
	jr nz,@func_7262
	ld a,$f0
	ld (wGenericCutscene.cutsceneTimer),a
	call incEndingCutsceneSubstate
	jr ++
@func_7262:
	call decCutsceneTimer
	jr nz,++
	ld (hl),$04
	ld hl,wGfxRegs1.SCY
	inc (hl)
	ld a,(hl)
	ldh (<hCameraY),a
	cp $60
	jr nz,++
	call clearDynamicInteractions
	ld a,UNCMP_GFXH_2c
	call loadUncompressedGfxHeader
++
	jp @func_71fd
@substate8:
	call @func_71fd
	call decCutsceneTimer
	ret nz
.ifdef ROM_COMBO
	call cutscene_clearTmpCBB3
.else
	callab bank3Cutscenes.cutscene_clearTmpCBB3
.endif
	ld a,$03
	ld (wMapMenu.drawWarpDestinations),a
	ld a,$04
	jp fadeoutToWhiteWithDelay


agesFunc_10_7298:
	ld de,wGenericCutscene.endingCutsceneSubstate
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
	.dw @substate4
	.dw @substate5
	.dw @substate6
	.dw @substate7
	.dw @substate8
.ifndef REGION_JP
	.dw @substate9
	.dw @substateA
	.dw @substateB
.endif
@substate0:
	call checkIsLinkedGame
	call nz,agesFunc_10_70f6@func_71fd
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call disableLcd
	call incEndingCutsceneSubstate
.ifdef ROM_COMBO
	call func_60f1
.else
	callab bank3Cutscenes.func_60f1
.endif
	call clearDynamicInteractions
	call clearOam
	call checkIsLinkedGame
	jp z,@func_72ec
	ld a,GFXH_CREDITS_LINKED_THE_END
	call loadGfxHeader
	ld a,PALH_aa
	call loadPaletteHeader
	ld hl,objectData.objectData5574
	call parseGivenObjectData
	jr ++
@func_72ec:
	ld a,GFXH_CREDITS_THE_END
	call loadGfxHeader
	ld a,PALH_a9
	call loadPaletteHeader
++
	ld a,$04
	call loadGfxRegisterStateIndex
	xor a
	ld hl,hCameraY
	ldi (hl),a
	ldi (hl),a
	ldi (hl),a
	ld (hl),a
	ld hl,wGenericCutscene.cutsceneTimer
	ld (hl),$f0
	ld (hl),a
	ld a,SNDCTRL_MEDIUM_FADEOUT
	call playSound
	ld a,$04
	jp fadeinFromWhiteWithDelay
@substate1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call incEndingCutsceneSubstate
@func_731b:
	call checkIsLinkedGame
	ret z
	ld hl,wTmpcbb4
	ld a,(hl)
	or a
	jr z,@playWaveSoundAtRandomIntervals_body
	dec (hl)
	ret

;;
; Called from playWaveSoundAtRandomIntervals in bank 0.
;
; Part of the cutscene where tokays steal your stuff? "SND_WAVE" gets played at random
; intervals?
;
; @param	hl	Place to write a counter to (how many frames until calling this
;			again)
@playWaveSoundAtRandomIntervals_body:
	push hl
	ld a,SND_WAVE
	call playSound
	pop hl
	call getRandomNumber
	and $03
	ld bc,@@data
	call addAToBc
	ld a,(bc)
	ld (hl),a
	ret

@@data:
	.db $a0 $c8 $10 $f0

@substate2:
	call @func_731b
	call decCutsceneTimer
	ret nz
	call incEndingCutsceneSubstate
@substate3:
	call @func_731b
	ld hl,wFileIsLinkedGame
	ldi a,(hl)
	add (hl)
	cp $02
	ret z
	ld a,(wKeysJustPressed)
	and (BTN_A|BTN_B|BTN_START)
	ret z
	call incEndingCutsceneSubstate
	jp fadeoutToWhite
@substate4:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$ff
	ld (wGenericCutscene.cbba),a
	call incEndingCutsceneSubstate
	call disableLcd
.if !defined(ROM_COMBO)
	callab bank3.generateGameTransferSecret
	ld a,($ff00+R_SVBK)
	push af
	ld a,TEXT_BANK
	ld ($ff00+R_SVBK),a
	ld hl,w7SecretText1
	ld de,w7d800
	ld bc,$1800
-
	ldi a,(hl)
	call copyTextCharacterGfx
	dec b
	jr nz,-
	pop af
	ld ($ff00+R_SVBK),a
.endif
	
	ld a,GFXH_SECRET_FOR_LINKED_GAME
	call loadGfxHeader
	ld a,UNCMP_GFXH_2b
	call loadUncompressedGfxHeader
	ld a,PALH_05
	call loadPaletteHeader
	call checkIsLinkedGame
.if defined(ROM_COMBO)
	ld a,GFXH_NEW_GAME_PLUS_BANNER
.else
	ld a,GFXH_HEROS_SECRET_TEXT
.endif
	call nz,loadGfxHeader
	call clearDynamicInteractions
	call clearOam
	ld a,$04
	call loadGfxRegisterStateIndex
	ld hl,wGenericCutscene.cutsceneTimer
	ld (hl),$3c
	call fileSelect_redrawDecorations
.if defined(ROM_COMBO)
	call checkIsLinkedGame
	jr nz,+
		ld a,MUS_ESSENCE_ROOM
		call playSound
	+
.endif
	jp fadeinFromWhite
@substate5:
	call fileSelect_redrawDecorations
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	call decCutsceneTimer
	ret nz
	ld hl,wGenericCutscene.cutsceneTimer
.if defined(ROM_COMBO)
	ld b,$01
.else
	ld b,$3c
	call checkIsLinkedGame
	jr z,+
	ld b,$b4
+
.endif
	ld (hl),b
	jp incEndingCutsceneSubstate
@substate6:
	call fileSelect_redrawDecorations
	call decCutsceneTimer
	ret nz
.if !defined(ROM_COMBO)
	call checkIsLinkedGame
	jr nz,+
.endif
	call getFreeInteractionSlot
	jr nz,+
	ld (hl),$d1
	xor a
	ld (wTmpcfc0.genericCutscene.cfde),a
+
	jp incEndingCutsceneSubstate
@substate7:
	call fileSelect_redrawDecorations
.if defined(ROM_COMBO)
	ld a,(wTextIsActive)
	or a
	ret nz

	ld a,(wTmpcfc0.genericCutscene.cfde)
	or a
	ret z
.else
	call checkIsLinkedGame
	jr z,+
	ld a,(wKeysJustPressed)
	and BTN_A
	jr nz,++
	ret
+
	ld a,(wTmpcfc0.genericCutscene.cfde)
	or a
	ret z
++
.endif
	call incEndingCutsceneSubstate
	ld a,SNDCTRL_FAST_FADEOUT
	call playSound
	jp fadeoutToWhite
@substate8:
	call fileSelect_redrawDecorations
	ld a,(wPaletteThread_mode)
	or a
	ret nz

.ifdef REGION_JP
	jp resetGame
.else
	call checkIsLinkedGame
	jp nz,resetGame
	call disableLcd
	call clearOam
	call incEndingCutsceneSubstate
.ifdef ROM_COMBO
	ld a,GFXH_TO_BE_CONTINUED_AGES
.else
	ld a,GFXH_TO_BE_CONTINUED
.endif
	call loadGfxHeader
	ld a,PALH_a7
	call loadPaletteHeader
	call fadeinFromWhite
	ld a,$04
	jp loadGfxRegisterStateIndex
@substate9:
	call @func_7450
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wGenericCutscene.cutsceneTimer
	ld (hl),$b4
	jp incEndingCutsceneSubstate
@func_7450:
.ifdef ROM_COMBO
	ld hl,oamData_4fec
	ld e,:oamData_4fec
.else
	ld hl,bank16.oamData_4fec
	ld e,:bank16.oamData_4fec
.endif
	ld bc,$3038
	xor a
	ldh (<hOamTail),a
	jp addSpritesFromBankToOam_withOffset
@substateA:
	call @func_7450
	ld hl,wGenericCutscene.cutsceneTimer
	ld a,(hl)
	or a
	jr z,@func_746a
	dec (hl)
	ret
@func_746a:
	ld a,(wKeysJustPressed)
	and BTN_A
	ret z
	call incEndingCutsceneSubstate
	jp fadeoutToWhite
@substateB:
	call @func_7450
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp resetGame

.endif ; !REGION_JP

.if !defined(ROM_COMBO)
.ends
.endif
