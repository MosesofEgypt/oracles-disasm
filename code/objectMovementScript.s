;;
; See include/movementscript_commands.s.
;
; @param	hl	Script address
objectLoadMovementScript:
	ldh a,(<hActiveObjectType)
	add Object.subid
	ld e,a
	ld a,(de)
	rst_addDoubleIndex
	rst_derefHl

	ld a,e
	add Object.speed-Object.subid
	ld e,a
	ldi a,(hl)
	ld (de),a

	ld a,e
	add Object.direction-Object.speed
	ld e,a
	ldi a,(hl)
	ld (de),a

	ld a,e
	add Object.var30-Object.direction 
	ld e,a
	ld a,l
	ld (de),a
	inc e
	ld a,h
	ld (de),a

;;
; See include/movementscript_commands.s.
objectRunMovementScript:
	ldh a,(<hActiveObjectType)
	add Object.var30
	ld e,a
	ld a,(de)
	ld l,a
	inc e
	ld a,(de)
	ld h,a

@nextOp:
	ldi a,(hl)
	push hl
	rst_jumpTable
	.dw @cmd00_jump
	.dw @moveUp
	.dw @moveRight
	.dw @moveDown
	.dw @moveLeft
	.dw @wait
.if defined(ROM_AGES) || defined(ROM_COMBO)
	.dw @setstate
.endif


@cmd00_jump:
	pop hl
	rst_derefHl
	jr @nextOp

@moveUp:
	pop bc
	ld h,d
	ldde $08,ANGLE_UP
	scf
	jr @move

@moveDown:
	pop bc
	ld h,d
	ldde $0a,ANGLE_DOWN
	scf
	jr @move

@moveLeft:
	pop bc
	ld h,d
	ldde $0b,ANGLE_LEFT
	scf
	ccf
	jr @move

@moveRight:
	pop bc
	ld h,d
	ldde $09,ANGLE_RIGHT
	scf
	ccf

@move:
	ldh a,(<hActiveObjectType)
	jr c,+
		inc a
	+
	add Object.var32
	ld l,a
	ld a,(bc)
	ld (hl),a

	ld a,l
	and $c0
	add Object.angle
	ld l,a
	ld (hl),e

	add Object.state-Object.angle
	ld l,a
	ld (hl),d
	ld d,h
	jr @storePointer


@wait:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.counter1
	ld l,a
	ld a,(bc)
.if defined(ROM_AGES) || defined(ROM_COMBO)
	ldd (hl),a

	dec l
	ld (hl),$0c ; [state]
.else
	ld (hl),a
	ld a,l
	add $fe
	ld l,a
	ld (hl),$0c
.endif

@storePointer:
	inc bc
.if defined(ROM_AGES) || defined(ROM_COMBO)
	ld a,l
.endif
	add Object.var30-Object.state
	ld l,a
	ld (hl),c
	inc l
	ld (hl),b
	ret

.if defined(ROM_AGES) || defined(ROM_COMBO)
@setstate:
	pop bc
	ld h,d
	ldh a,(<hActiveObjectType)
	add Object.counter1
	ld l,a
	ld a,(bc)
	ldd (hl),a

	dec l
	inc bc
	ld a,(bc)
	ld (hl),a ; [state]

	jr @storePointer
.endif
