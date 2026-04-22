;;
; ITEM_BOOMERANG
itemCode06:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4

@state0:
	call itemLoadAttributesAndGraphics
	ld e,Item.subid
	ld a,(de)
.ifdef ROM_AGES
	add UNCMP_GFXH_AGES_L1_BOOMERANG
.else
	add UNCMP_GFXH_18 ; Either this or UNCMP_GFXH_19
.endif
	call loadWeaponGfx

	call itemIncState

	ld bc,(SPEED_1a0<<8)|$28
	ld l,Item.subid
	bit 0,(hl)
	jr z,+

	; level-2
	ld l,Item.collisionType
	ld (hl),$80|ITEMCOLLISION_L2_BOOMERANG
	ld l,Item.oamFlagsBackup
	ld a,$0c
	ldi (hl),a
	ldi (hl),a
	ld bc,(SPEED_260<<8)|$78
+
	ld l,Item.speed
	ld (hl),b
	ld l,Item.counter1
	ld (hl),c

.ifdef ENABLE_RING_REDUX
	ld a,TOSS_RING
	call cpActiveRing
	jr z,+
		ld a,HASTE_RING
		call cpActiveRing
		jr nz,++
	+
	ld bc,(RANG_RING_L2<<8)|RANG_RING_L1
	call eitherRingActive
	jr z,+
	jr c,+
	jr ++
	+
		ld l,Item.speed
		ld (hl),SPEED_300
		ld l,Item.counter1
		ld (hl),$78
	++

	ld bc,(RANG_RING_L2<<8)|RANG_RING_L1
	call eitherRingActive
	ld c,-1
	jr nz,+
		ld c,-4
		jr c,+
			ld c,-2
		jr +++
	+
	jr nc,++
	+++
.else
	ld c,-1
	ld a,RANG_RING_L1
	call cpActiveRing
	jr z,+

	ld a,RANG_RING_L2
	call cpActiveRing
	jr nz,++
	ld c,-2
+
.endif
	; One of the rang rings are equipped; damage output increased (value of 'c')
	ld l,Item.damage
	ld a,(hl)
	add c
	ld (hl),a
++
	call objectSetVisible82
	xor a
	jp itemSetAnimation


; State 1: boomerang moving outward
@state1:
	call magicBoomerangTryToBreakTile

	ld e,Item.var2a
	ld a,(de)
	or a
.ifdef ENABLE_RING_REDUX
	jr z,+
		; if both rings equipped, keep flying even after hitting an enemy
		call checkBothRangRingsEquipped
		jr nc,@returnToLink
		xor a
		ld (de),a
	+
.endif
	jr nz,@returnToLink

	call objectCheckTileCollision_allowHoles
	jr nc,@noCollision
	call itemCheckCanPassSolidTile
	jr nz,@hitWall

@noCollision:
	call objectCheckWithinRoomBoundary
.ifdef ENABLE_RING_REDUX
	jr c,+
		call checkBoomerangParentStillValid
		jr z,@returnToLink

		call checkBothRangRingsEquipped
		jp c,@hitWall
	+
.endif
	jr nc,@returnToLink

	; Nudge angle toward a certain value. (Is this for the magical boomerang?)
	ld e,Item.var34
	ld a,(de)
	call objectNudgeAngleTowards
.ifdef ENABLE_RING_REDUX
	call checkBothRangRingsEquipped
	jr nc,+
		; if both rings are equipped, only decrement if the parent is gone
		call checkBoomerangParentStillValid
		jp nz,@updateSpeedAndAnimation
	+
.endif
	; Decrement counter until boomerang must return
	call itemDecCounter1
	jr nz,@updateSpeedAndAnimation

; Decide on the angle to change to, then go to the next state
@returnToLink:
	call objectGetAngleTowardLink
	ld c,a

	; If the boomerang's Y or X has gone below 0 (above $f0), go directly to link?
	ld h,d
	ld l,Item.yh
	ld a,$f0
	cp (hl)
	jr c,@@setAngle
	ld l,Item.xh
	cp (hl)
	jr c,@@setAngle

	; If the boomerang is already moving in Link's general direction, don't bother
	; changing the angle?
	ld l,Item.angle
	ld a,c
	sub (hl)
	add $08
	cp $11
	jr c,@nextState

@@setAngle:
	ld l,Item.angle
	ld (hl),c
	jr @nextState

@hitWall:
.ifdef ENABLE_RING_REDUX
	call @infiniteBoomerangControl
.else
	call objectCreateClinkInteraction

	; Reverse direction
	ld h,d
	ld l,Item.angle
	ld a,(hl)
	xor $10
	ld (hl),a
.endif

@nextState:
	ld l,Item.state
	inc (hl)

	; Clear link to parent item
	ld l,Item.relatedObj1
	xor a
	ldi (hl),a
	ld (hl),a

	jr @updateSpeedAndAnimation


; State 2: boomerang returning to Link
@state2:
	call objectGetAngleTowardLink
	call objectNudgeAngleTowards

	; Increment state if within 10 pixels of Link
	ld bc,$140a
	call itemCheckWithinRangeOfLink
	call c,itemIncState

	jr @breakTileAndUpdateSpeedAndAnimation


; State 3: boomerang within 10 pixels of link; move directly toward him instead of nudging
; the angle.
@state3:
	call objectGetAngleTowardLink
	ld e,Item.angle
	ld (de),a

	; Check if within 2 pixels of Link
	ld bc,$0402
	call itemCheckWithinRangeOfLink
	jr nc,@breakTileAndUpdateSpeedAndAnimation

	; Go to state 4, make invisible, disable collisions
	call itemIncState
	ld l,Item.counter1
	ld (hl),$04
	ld l,Item.collisionType
	ld (hl),$00
	jp objectSetInvisible


; Stays in this state for 4 frames before deleting itself. I guess this creates a delay
; before the boomerang can be used again?
@state4:
	call itemDecCounter1
	jp z,itemDelete

	ld a,(wLinkObjectIndex)
	ld h,a
	ld l,SpecialObject.yh
	jp objectTakePosition

@breakTileAndUpdateSpeedAndAnimation:
	call magicBoomerangTryToBreakTile

@updateSpeedAndAnimation:
	call objectApplySpeed
	ld h,d
	ld l,Item.animParameter
	ld a,(hl)
	or a
	ld (hl),$00

	; Play sound when animParameter is nonzero
	ld a,SND_BOOMERANG
	call nz,playSound

	jp itemAnimate

.ifdef ENABLE_RING_REDUX
@infiniteBoomerangControl
	ld e,Item.counter2
	ld a,(de)
	or a
	jr z,+
		dec a
	+
	ld (de),a

	; if the parent was deleted, return
	call checkBoomerangParentStillValid
	ret z

	; if boomerang has already changed angle, wait a couple
	; frames before it's allowed to try changing again
	ld a,(de)
	or a
	jr nz,+
		; setup a timer so the clink doesn't happen too often
		ld a,5
		ld (de),a

		call objectCheckWithinRoomBoundary
		; don't clink if it's returning because it hit the screen edge
		call c,objectCreateClinkInteraction
		ld h,d
		ld l,Item.angle
		ld a,(hl)
		xor $10
		ld (hl),a

	+
	; if this isn't the magic boomerang, return when wall is struck
	ld e,Item.subid
	ld a,(de)
	or a
	ret z

	; this is the magic boomerang, so if both rang rings are equipped
	; then it can continue flying as long as the button is held, even
	; after hitting a solid tile.
	call checkBothRangRingsEquipped
	ret nc

    ; intentional stack manipulation to jump out of parent call
	pop af
	jp @updateSpeedAndAnimation
.endif

magicBoomerangTryToBreakTile:
.ifdef ENABLE_RING_REDUX
	; if wearing these rings, the boomerang just eats dirt up
	push bc
	ld bc,(TOSS_RING<<8)|DISCOVERY_RING
	call eitherRingActive
	jr nz,+
	jr nc,+
		ld bc,(RANG_RING_L2<<8)|RANG_RING_L1
		call eitherRingActive
		jr c,++
		jr nz,+
		++
			ld a,BREAKABLETILESOURCE_SHOVEL
			call itemTryToBreakTile
	+
	pop bc
.endif

	ld e,Item.subid
	ld a,(de)
	or a
	ret z

	; level-2
	ld a,BREAKABLETILESOURCE_07
	jp itemTryToBreakTile

;;
; Assumes that both objects are of the same size (checks top-left positions)
;
; @param	b	Should be double the value of c
; @param	c	Range to be within
; @param[out]	cflag	Set if within specified range of link
itemCheckWithinRangeOfLink:
	ld hl,w1Link.yh
	ld e,Item.yh
	ld a,(de)
	sub (hl)
	add c
	cp b
	ret nc

	ld l,<w1Link.xh
	ld e,Item.xh
	ld a,(de)
	sub (hl)
	add c
	cp b
	ret

.ifdef ENABLE_RING_REDUX
;;
; @param[out]	cflag	Set if both rang rings are equipped
checkBothRangRingsEquipped:
	push bc
	ld bc,(RANG_RING_L2<<8)|RANG_RING_L1
	call eitherRingActive
	pop bc
	ret nc
	ret z
	ccf
	ret

;;
; @param[out]	zflag	Set if the parent is null
checkBoomerangParentStillValid:
	push hl
	ld h,d
	ld l,Item.relatedObj1
	ldi a,(hl)
	ld h,(hl)
	ld l,a
	ld a,(hl)
	cp $00
	pop hl
	ret
.endif