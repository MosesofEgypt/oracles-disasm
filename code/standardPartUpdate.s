
;;
; Analagous to the "enemyStandardUpdate" function.
partStandardUpdate:
	ld h,d
	ld l,Part.state
	ld a,(hl)
	or a
	jr z,@uninitialized

	ld l,Part.invincibilityCounter
	ld a,(hl)
	or a
	jr z,@doneUpdatingInvincibility
	rlca
	jr nc,++
	inc (hl)
	jr @doneUpdatingInvincibility
++
	dec (hl)

@doneUpdatingInvincibility:
	dec l
	bit 7,(hl) ; [Part.var2a]
	jr nz,@collision
	dec l
	ld a,(hl) ; [Part.health]
	or a
	jr z,@dead
	ld c,PARTSTATUS_NORMAL
	ret

@uninitialized:
.ifdef ROM_COMBO
	callab gfxLoading.partLoadGraphicsAndProperties
.else
	callab dataLoading.partLoadGraphicsAndProperties
.endif
	ld e,Part.var3e
	ld a,$08 ; TODO: what's this
	ld (de),a
	ld c,PARTSTATUS_NORMAL
	ret

@collision:
	ld c,PARTSTATUS_JUST_HIT
	ret

@dead:
	ld c,PARTSTATUS_DEAD
	ret