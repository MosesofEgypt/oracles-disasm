; ==================================================================================================
; INTERAC_D6_CRYSTAL_TRAP_ROOM
; ==================================================================================================
interactionCode65:
	call returnIfScrollMode01Unset
	call func_5258
	jp nz,interactionDelete
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
@state0:
	ld a,$01
	ld (de),a
	call objectSetReservedBit1
	ld e,Interaction.subid
	ld a,(de)
	or a
	jr nz,@notSubId0
	ld e,$46
	ld a,$78
	ld (de),a

	ld a,$02
	ld ($ff00+R_SVBK),a

	ld a,$80
	ld hl,w2TmpGfxBuffer
	call @func_51c0

	ld hl,w2TmpGfxBuffer+$a0
	call @func_51c0

	ld a,$0b
	ld hl,w2TmpAttrBuffer
	call @func_51c0

	ld hl,w2TmpAttrBuffer+$a0
	call @func_51c0

	xor a
	ld ($ff00+R_SVBK),a

	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D6_CRYSTAL_TRAP_ROOM
	inc l
	ld (hl),$01
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_D6_CRYSTAL_TRAP_ROOM
	inc l
	ld (hl),$02
	ret
@notSubId0:
	ld e,Interaction.state
	ld a,$02
	ld (de),a
	ret
@func_51c0:
	ld b,$20
-
	ldi (hl),a
	dec b
	jr nz,-
	ret
@state1:
	xor a
	ld (wDisableScreenTransitions),a
	ld a,$3c
	ld (wScreenShakeCounterX),a
	call interactionDecCounter1
	ret nz
	ld (hl),$78
	ld a,$01
	ld (wDisableScreenTransitions),a
	ld hl,wTmpcfc0.genericCutscene.cfd0
	inc (hl)
	call func_5261
	call func_545a
	call func_52d9
	call func_537e
	xor a
	ld ($ff00+R_SVBK),a
	ldh a,(<hActiveObject)
	ld d,a
	ld a,$70
	call playSound
	ld a,$0f
	ld (wScreenShakeCounterY),a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $09
	ret c
	call func_5258
	jp nz,interactionDelete
	ld a,$11
	ld (wLinkForceState),a
	ld a,$81
	ld (wcc50),a
	jp interactionDelete
@state2:
	call func_5258
	jp nz,interactionDelete
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	cp $09
	jr z,func_524d
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld c,$08
	call multiplyAByC
	ld a,l
	add $10
	ld b,a
	ld hl,w1Link.yh
	ld a,(hl)
	cp b
	jr nc,+
	ld (hl),b
+
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld b,a
	ld a,$15
	sub b
	ld c,$08
	call multiplyAByC
	ld a,l
	sub $0e
	ld b,a
	ld hl,w1Link.yh
	ld a,(hl)
	cp b
	ret c
	ld (hl),b
	ret
func_524d:
	ld a,$08
	call setScreenShakeCounter
	ld a,$58
	ld (w1Link.yh),a
	ret
func_5258:
	ld a,(wActiveRoom)
	cp $c5
	ret z
	cp $c6
	ret
func_5261:
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld a,(wScreenOffsetX)
	cpl
	inc a
	swap a
	rlca
	ldh (<hFF8B),a
	xor a
	call func_5293
	ld a,$04
	call func_5293
	ld a,$08
	call func_5293
	ld a,$0c
	call func_5293
	ld a,$10
	call func_5293
	ld a,$14
	call func_5293
	ld a,$18
	call func_5293
	ld a,$1c
func_5293:
	ld hl,table_52a6
	rst_addAToHl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	rst_derefHl
	ldh a,(<hFF8B)
	ld c,a
	ld b,$00
	add hl,bc
	jr func_52c6
table_52a6:
	.dw w2TmpGfxBuffer+$20 w2TmpGfxBuffer+$c0
	.dw w2TmpGfxBuffer+$40 w2TmpGfxBuffer+$e0
	.dw w2TmpGfxBuffer+$60 w2TmpGfxBuffer+$100
	.dw w2TmpGfxBuffer+$80 w2TmpGfxBuffer+$120
	.dw w2TmpAttrBuffer+$20 w2TmpAttrBuffer+$c0
	.dw w2TmpAttrBuffer+$40 w2TmpAttrBuffer+$e0
	.dw w2TmpAttrBuffer+$60 w2TmpAttrBuffer+$100
	.dw w2TmpAttrBuffer+$80 w2TmpAttrBuffer+$120
func_52c6:
	ld b,$20
--
	ld a,(hl)
	ld (de),a
	inc de
	inc l
	ld a,l
	and $1f
	jr nz,+
	ld a,l
	sub $20
	ld l,a
+
	dec b
	jr nz,--
	ret
func_52d9:
	push de
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	add a
	ld hl,table_5326
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	push hl
	ld hl,w2TmpAttrBuffer
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,w2TmpGfxBuffer
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	add a
	ld hl,table_5352
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	inc hl
	push hl
	ld hl,w2TmpAttrBuffer+$60
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop hl
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,w2TmpGfxBuffer+$60
	ld b,$05
	ld c,$02
	call queueDmaTransfer
	pop de
	ret
table_5326:
	.db $01 $98 $00 $98
	.db $01 $98 $00 $98
	.db $21 $98 $20 $98
	.db $41 $98 $40 $98
	.db $61 $98 $60 $98
	.db $81 $98 $80 $98
	.db $a1 $98 $a0 $98
	.db $c1 $98 $c0 $98
	.db $e1 $98 $e0 $98
	.db $01 $99 $00 $99
	.db $21 $99 $20 $99
table_5352:
	.db $61 $9a $60 $9a
	.db $61 $9a $60 $9a
	.db $41 $9a $40 $9a
	.db $21 $9a $20 $9a
	.db $01 $9a $00 $9a
	.db $e1 $99 $e0 $99
	.db $c1 $99 $c0 $99
	.db $a1 $99 $a0 $99
	.db $81 $99 $80 $99
	.db $61 $99 $60 $99
	.db $41 $99 $40 $99
func_537e:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	or a
	ret z
	bit 0,a
	jr nz,func_53a1
	srl a
	swap a
	ld l,a
	ld a,$0f
	call func_53bb
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$0f
	jr func_53bb
func_53a1:
	inc a
	srl a
	swap a
	ld l,a
	ld a,$0c
	call func_53bb
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	inc a
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$03
func_53bb:
	ld e,a
	ld b,$10
	ld h,>wRoomCollisions
-
	ld a,(hl)
	or e
	ldi (hl),a
	dec b
	jr nz,-
	ret
func_53c7:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	or a
	ret z
	bit 0,a
	ret nz
	srl a
	swap a
	ld l,a
	ld a,$b0
	call func_53e7
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	srl a
	ld b,a
	ld a,$0a
	sub b
	swap a
	ld l,a
	ld a,$b2
func_53e7:
	ld b,$10
	ld h,>wRoomLayout
-
	ldi (hl),a
	dec b
	jr nz,-
	ret

;;
; $02: D6 wall-closing room
roomTileChangesAfterLoad02_body:
	; NOTE: this function expects SVBK to have already been set to 3
	call func_537e
	call func_53c7
	ld hl,w3VramTiles
	ld de,w3TileMappingData+$c0
	call func_5440
	ld hl,w3VramTiles+$20
	ld de,w3TileMappingData+$e0
	call func_5440
	ld hl,w3VramAttributes
	ld de,w3TileMappingData+$4c0
	call func_5440
	ld hl,w3VramAttributes+$20
	ld de,w3TileMappingData+$4e0
	call func_5440
	ld hl,w3VramTiles+$280
	ld de,w3TileMappingData+$100
	call func_5440
	ld hl,w3VramTiles+$2a0
	ld de,w3TileMappingData+$120
	call func_5440
	ld hl,w3Filler2+$80
	ld de,w3TileMappingData+$500
	call func_5440
	ld hl,w3Filler2+$a0
	ld de,w3TileMappingData+$520
	call func_5440
	jr func_545a
func_5440:
	ld a,$03
	ld ($ff00+R_SVBK),a
	push de
	ld de,wTmpVramBuffer
	ld b,$20
	call copyMemory
	pop de
	ld a,$02
	ld ($ff00+R_SVBK),a
	ld hl,wTmpVramBuffer
	ld b,$20
	jp copyMemory

func_545a:
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	or a
	ret z
	push de
	push hl
	ld hl,w2TmpGfxBuffer+$c0
	ld de,wTmpVramBuffer
	ld b,$40
	ld c,$02
	call func_553a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld hl,table_5544
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,wTmpVramBuffer
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,w2TmpGfxBuffer+$100
	ld de,wTmpVramBuffer
	ld b,$40
	ld c,$02
	call func_553a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld hl,table_5558
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld hl,wTmpVramBuffer
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,w2TmpAttrBuffer+$4c0
	ld de,wTmpVramBuffer
	ld b,$40
	ld c,$02
	call func_553a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld hl,table_5544
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	add $04
	ld d,a
	ld hl,wTmpVramBuffer
	ld b,$40
	ld c,$03
	call func_553a
	ld hl,w2TmpAttrBuffer+$100
	ld de,wTmpVramBuffer
	ld b,$40
	ld c,$02
	call func_553a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld hl,table_5558
	rst_addDoubleIndex
	ldi a,(hl)
	ld e,a
	ld a,(hl)
	add $04
	ld d,a
	ld hl,wTmpVramBuffer
	ld b,$40
	ld c,$03
	call func_553a
	ld a,$03
	ld ($ff00+R_SVBK),a
	ld hl,w3VramTiles
	ld a,$80
	call func_552a
	ld hl,w3VramAttributes
	ld a,$0b
	call func_552a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld c,a
	ld b,$00
	ld a,$16
	sub c
	ld c,a
	ld a,$20
	call multiplyAByC
	ld c,l
	ld b,h
	ld hl,w3VramTiles
	add hl,bc
	ld a,$80
	push hl
	call func_552a
	pop hl
	ld bc,$0400
	add hl,bc
	ld a,$0b
	call func_552a
	xor a
	ld ($ff00+R_SVBK),a
	pop hl
	pop de
	ret
func_552a:
	ld e,a
	ld a,(wTmpcfc0.genericCutscene.cfd0)
	ld c,a
	ld a,e
--
	ld b,$20
-
	ldi (hl),a
	dec b
	jr nz,-
	dec c
	jr nz,--
	ret
func_553a:
	ld a,c
	ld ($ff00+R_SVBK),a
	call copyMemory
	xor a
	ld ($ff00+R_SVBK),a
	ret
table_5544:
	.db $00 $d8
	.db $20 $d8
	.db $40 $d8
	.db $60 $d8
	.db $80 $d8
	.db $a0 $d8
	.db $c0 $d8
	.db $e0 $d8
	.db $00 $d9
	.db $20 $d9
table_5558:
	.db $80 $da
	.db $60 $da
	.db $40 $da
	.db $20 $da
	.db $00 $da
	.db $e0 $d9
	.db $c0 $d9
	.db $a0 $d9
	.db $80 $d9
	.db $60 $d9
