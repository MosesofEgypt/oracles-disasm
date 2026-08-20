_updatePartsIfStateIsZero:
	ld d,FIRST_PART_INDEX
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,$c0
	ld a,(de)
	or a
	jr z,++
	rlca
	jr c,+
	ld e,$c4
	ld a,(de)
	or a
	jr nz,++
+
	call objectUpdating.updatePart
++
	inc d
	ld a,d
	cp $e0
	jr c,-
	ret

;;
updateParts:
	ld a,$c0
	ldh (<hActiveObjectType),a
	ld a,(wScrollMode)
	cp $08
	jr z,_updatePartsIfStateIsZero
	ld a,(wTextIsActive)
	or a
	jr nz,_updatePartsIfStateIsZero

	ld a,(wDisabledObjects)
	and $88
	jr nz,_updatePartsIfStateIsZero

	ld d,FIRST_PART_INDEX
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,Part.enabled
	ld a,(de)
	or a
	jr z,+

	call objectUpdating.updatePart
	ld h,d
	ld l,Part.var2a
	res 7,(hl)
+
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,-
	ret

;;
updatePart:
	call partCommon_standardUpdate

	ld e,Part.id
	ld a,(de)
.if defined(ENABLE_NEW_GAME_PLUS) || defined(ROM_COMBO)
	push bc

	.if defined(ROM_COMBO)
		call wIsSeasons
		ld hl,partCodeTable_seasons
		jr c,+
			ld hl,partCodeTable_ages
		+
	.else
		ld hl,partCodeTable
	.endif

	ld b,$00
	ld c,a

	; hl = partCodeTable + [Part.id] * 3
	add hl,bc
	add hl,bc
	add hl,bc

	pop bc
	ldh a,(<hRomBank)
	push af
	jp updatePartCaller
.else
	; hl = partCodeTable + [Part.id] * 2
	add a
	add <partCodeTable
	ld l,a
	ld a,$00
	adc >partCodeTable
	ld h,a
	ldi a,(hl)
	ld h,(hl)
	ld l,a

	ld a,c
	or a
	jp hl
.endif