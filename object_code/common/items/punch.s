;;
; ITEM_PUNCH
; ITEM_NONE also points here, but this doesn't get called from there normally
itemCode00:
itemCode02:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1

@state0:
	call itemLoadAttributesAndGraphics
	ld c,SND_STRIKE
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04
	ld l,Item.subid
	bit 0,(hl)
.ifdef ENABLE_RING_REDUX
	jr nz,+
		; regular punch
		ld a,c
		jp playSound
	+
	call @updatePunchAttributes
	call tryBreakTileWithExpertsRing

	ld a,SND_EXPLOSION
.else
	jr z,++

	; Expert's ring (bit 0 of Item.subid set)

	ld l,Item.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ldi (hl),a

	; Increase Item.damage
	ld a,(hl)
	add $fd
	ld (hl),a

	; Use ITEMCOLLISION_EXPERT_PUNCH for expert's ring
	ld l,Item.collisionType
	inc (hl)

	; Check for clinks against bombable walls?
	call tryBreakTileWithExpertsRing

	ld c,SND_EXPLOSION
++
	ld a,c
.endif
	jp playSound

@state1:
	call itemDecCounter1
	jp z,itemDelete
	ret

.ifdef ENABLE_RING_REDUX
@updatePunchAttributes:
	ld l,Item.subid
	bit 0,(hl)
	ret z

	ld a,FIST_RING
	call cpActiveRing
	jr z,+
		; expert punch
		ldbc 8,-4
		jr ++
	+
		; super punch
		ldbc 15,-6
	++

	; expert punch (bit 0 of Item.subid set)
    ; increment to ITEMCOLLISION_EXPERT_PUNCH
	ld l,Item.collisionType
	inc (hl)
	inc hl
	inc hl

	; increase collision radius
	ld a,b
	ldi (hl),a
	ldi (hl),a

	; increase damage
	ld (hl),c
	ret
.endif