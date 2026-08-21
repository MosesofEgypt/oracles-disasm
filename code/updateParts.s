.include "code/standardPartUpdate.s"

;;
; Update all parts with 'state' variables equal to 0.
_updatePartsIfStateIsZero:
	ld d,FIRST_PART_INDEX
	ld a,d
-
	ldh (<hActiveObject),a
	ld e,Part.enabled
	ld a,(de)
	or a
	jr z,@next
		rlca
		jr c,+
			ld e,Part.state
			ld a,(de)
			or a
			jr nz,@next
		+
		call updatePart
@next
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,-
	ret

;;
updateParts:
	ld a,Part.start
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
		call updatePart

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
	call partStandardUpdate

.if defined(ROM_COMBO)
	ld hl,partCodeTable_seasons
	call wIsSeasons
	jr c,+
		ld hl,partCodeTable_ages
	+
.else
	ld hl,partCodeTable
.endif

	ld e,Part.id
	ld a,(de)
.if defined(ENABLE_NEW_GAME_PLUS) || defined(ROM_COMBO)
	jp updateObjectCaller
.else
	; hl = partCodeTable + [Part.id] * 2
	rst_addDoubleIndex
	rst_derefHl

	ld a,c
	or a
	jp hl
.endif