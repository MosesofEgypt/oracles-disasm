;;
; ITEM_BOMBCHUS ($0d)
parentItemCode_bombchu:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw parentItemGenericState1

@state0:
.ifdef ROM_AGES
	; Must be above water
	call isLinkUnderwater
	jp nz,clearParentItem
	; Can't be on raft
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jp z,clearParentItem
.endif

	; Can't be swimming
	ld a,(wLinkSwimmingState)
	or a
	jp nz,clearParentItem

	; Must have bombchus
	ld a,(wNumBombchus)
.ifdef ENABLE_RING_REDUX
	call alchemyRingRestock
	jr z,+
		ld (wNumBombchus),a
+
.endif
	or a
	jp z,clearParentItem

	call parentItemLoadAnimationAndIncState

	; Create a bombchu if there isn't one on the screen already
.ifdef ENABLE_RING_REDUX
	call getBombLimit
.else
	ld e,$01
.endif
	jp itemCreateChildAndDeleteOnFailure

;;
; ITEM_BOMB ($03)
parentItemCode_bomb:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw parentItemGenericState1
	.dw parentItemCode_bracelet@state2
	.dw parentItemCode_bracelet@state3
	.dw parentItemCode_bracelet@state4
.ifdef ENABLE_RING_REDUX
	.dw parentItemCode_bracelet@state6
	.dw parentItemCode_bracelet@state6
.endif

@state0:
.ifdef ROM_AGES
	call isLinkUnderwater
	jp nz,clearParentItem
	; If Link is riding something other than a raft, don't allow usage of bombs
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jr z,+
.endif
	ld a,(wLinkObjectIndex)
	rrca
	jp c,clearParentItem
+
	ld a,(wLinkSwimmingState)
	ld b,a
	ld a,(wLinkInAir)
	or b
	jp nz,clearParentItem

	; Try to pick up a bomb
	call tryPickupBombs
	jp nz,parentItemCode_bracelet@beginPickupAndSetAnimation

	; Try to create a bomb
	ld a,(wNumBombs)
	or a
.ifdef ENABLE_RING_REDUX
	call alchemyRingRestock
	jr z,+
		ld (wNumBombs),a
	+

	push af
	call remoteBombComboActive
	jr nz,+
		; check if there's a bomb to remote detonate
		ld c,ITEM_BOMB
		call findItemWithID
		jr nz,+
			ld l,Item.var2f
			pop af

			; skip if already exploding
			bit 4,(hl)
			ret nz

			; set the bit that indicates to explode
			set 4,(hl)
			jp clearParentItem
    +
	pop af
.endif
	jp z,clearParentItem

	call parentItemLoadAnimationAndIncState

.ifdef ENABLE_RING_REDUX
	call getBombLimit
.else
	ld e,$01
	ld a,BOMBERS_RING
	call cpActiveRing
	jr nz,+
	inc e
+
.endif
	call itemCreateChild
	jp c,clearParentItem

	call makeLinkPickupObjectH
	jp parentItemCode_bracelet@beginPickup

;;
; Makes Link pick up a bomb object if such an object exists and Link's touching it.
;
; @param[out]	zflag	Unset if a bomb was picked up
tryPickupBombs:
	; Return if Link's using something?
	ld a,(wLinkUsingItem1)
	or a
	jr nz,@setZFlag

	; Return with zflag set if there is no existing bomb object
	ld c,ITEM_BOMB
	call findItemWithID
	jr nz,@setZFlag

	call @pickupObjectIfTouchingLink
	ret nz

	; Try to find a second bomb object & pick that up
	ld c,ITEM_BOMB
	call findItemWithID_startingAfterH
	jr nz,@setZFlag


; @param	h	Object to check
; @param[out]	zflag	Set on failure (no collision with Link)
@pickupObjectIfTouchingLink:
	ld l,Item.var2f
	ld a,(hl)
	and $b0
	jr nz,@setZFlag
	call objectHCheckCollisionWithLink
	jr c,makeLinkPickupObjectH

@setZFlag:
	xor a
	ret

;;
; @param	h	Object to make Link pick up
makeLinkPickupObjectH:
	ld l,Item.enabled
	set 1,(hl)

	ld l,Item.substate
	xor a
	ldd (hl),a
	ld (hl),$02

	ld (w1Link.relatedObj2),a
	ld a,h
	ld (w1Link.relatedObj2+1),a
	or a
	ret


;;
; Bracelet's code is also heavily used by bombs.
;
; ITEM_BRACELET ($16)
parentItemCode_bracelet:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
.ifdef ENABLE_RING_REDUX
	.dw @state6
.endif

; State 0: not grabbing anything
@state0:
	call checkLinkOnGround
	jp nz,clearParentItem

.ifdef ROM_SEASONS
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	jp z,clearParentItem
.endif

	ld a,(w1ReservedItemC.enabled)
	or a
	jp nz,clearParentItem

	call parentItemCheckButtonPressed
	jp z,@dropAndDeleteSelf

	ld a,(wLinkUsingItem1)
	or a
	jr nz,++

	; Check if there's anything to pick up
	call checkGrabbableObjects
	jr c,@beginPickupAndSetAnimation
	call tryPickupBombs
	jr nz,@beginPickupAndSetAnimation

	; Try to grab a solid tile
	call @checkWallInFrontOfLink
	jr nz,++
	ld a,$41
	ld (wLinkGrabState),a
	jp parentItemLoadAnimationAndIncState
++
	ld a,(w1Link.direction)
	or $80
	ld (wBraceletGrabbingNothing),a
.ifdef ENABLE_RING_REDUX
	jr @tryPunching
.endif
	ret


; State 1: grabbing a wall
@state1:
	call @deleteAndRetIfSwimmingOrGrabState0
	ld a,(w1Link.knockbackCounter)
	or a
	jp nz,@dropAndDeleteSelf

	call parentItemCheckButtonPressed
	jp z,@dropAndDeleteSelf

	ld a,(wLinkInAir)
	or a
	jp nz,@dropAndDeleteSelf

	call @checkWallInFrontOfLink
	jp nz,@dropAndDeleteSelf

	; Check that the correct direction button is pressed
	ld a,(w1Link.direction)
	ld hl,@counterDirections
	rst_addAToHl
	call andHlWithGameKeysPressed
	ld a,LINK_ANIM_MODE_LIFT_3
	jp z,specialObjectSetAnimationWithLinkData

	; Update animation, wait for animParameter to set bit 7
	call specialObjectAnimate_optimized
	ld e,Item.animParameter
	ld a,(de)
	rlca
	ret nc

	; Try to lift the tile, return if not possible
	call @checkWallInFrontOfLink
	jp nz,@dropAndDeleteSelf
	lda BREAKABLETILESOURCE_BRACELET
	call tryToBreakTile
	ret nc

	; Create the sprite to replace the broken tile
	ld hl,w1ReservedItemC.enabled
	ld a,$03
	ldi (hl),a
	ld (hl),ITEM_BRACELET

	; Set subid to former tile ID
	inc l
	ldh a,(<hFF92)
	ldi (hl),a
	ld e,Item.var37
	ld (de),a

	; Set child item's var03 (the interaction ID for the effect on breakage)
	ldh a,(<hFF8E)
	ldi (hl),a

	lda Item.start
	ld (w1Link.relatedObj2),a
	ld a,h
	ld (w1Link.relatedObj2+1),a

@beginPickupAndSetAnimation:
	ld a,LINK_ANIM_MODE_LIFT_4
	call specialObjectSetAnimationWithLinkData

.ifdef ENABLE_RING_REDUX
	jr @beginPickup

@tryPunching:
	push bc
	call kenpoMasterComboActive
	jr z,+
		pop bc
		ret
	+

	; make sure the button was just pressed so we can't rapid-fire punch
	ld e,Item.var03
	ld a,(de)
	ld b,a
	ld a,(wGameKeysJustPressed)
	cp b
	pop bc
	ret nz

	; not grabbing anything, so act as if link is unequipped and try punching.
	; change the item type to punch and run the item code for it
	ld a,ITEM_PUNCH
	ld e,Item.id
	ld (de),a
	jp parentItemCode_punch
.endif

@beginPickup:
	call itemDisableLinkMovementAndTurning
	ld a,$c2
	ld (wLinkGrabState),a
	xor a
	ld (wLinkGrabState2),a
	ld hl,w1Link.collisionType
	res 7,(hl)

	ld a,$02
	ld e,Item.state
	ld (de),a
	ld e,Item.var3f
	ld a,$0f
	ld (de),a

	ld a,SND_PICKUP
	jp playSound


; Opposite direction to press in order to use bracelet
@counterDirections:
	.db BTN_DOWN	; DIR_UP
	.db BTN_LEFT	; DIR_RIGHT
	.db BTN_UP	; DIR_DOWN
	.db BTN_RIGHT	; DIR_LEFT


; State 2: picking an item up.
; This is also state 2 for bombs.
@state2:
	call @deleteAndRetIfSwimmingOrGrabState0
	call specialObjectAnimate_optimized

	; Check if link's pulling a lever?
	ld a,(wLinkGrabState2)
	rlca
	jr nc,++

	; Go to state 5 for lever pulling?
	ld a,$83
	ld (wLinkGrabState),a
	ld e,Item.state
	ld a,$05
	ld (de),a
	ld a,LINK_ANIM_MODE_LIFT_2
	jp specialObjectSetAnimationWithLinkData
++
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	jr nz,++

	; The animParameter determines the object's offset relative to Link?
	ld a,(wLinkGrabState2)
	and $f0
	add (hl)
	ld (wLinkGrabState2),a
	ret
++
	; Pickup animation finished
	ld a,$83
	ld (wLinkGrabState),a
	ld l,Item.state
	inc (hl)
	ld l,Item.var3f
	ld (hl),$00

	; Re-enable link collisions & movement
	ld hl,w1Link.collisionType
	set 7,(hl)
	jp itemEnableLinkMovementAndTurning


; State 3: holding the object
; This is also state 3 for bombs.
@state3:
	call @deleteAndRetIfSwimmingOrGrabState0
	ld a,(wLinkInAir)
	rlca
	ret c
	ld a,(wcc67)
	or a
	ret nz
	ld a,(w1Link.var2a)
	or a
	jr nz,++

.ifdef ENABLE_QUICK_ITEM_DROP
.ifdef ENABLE_RING_REDUX
	call isHasteRingEquipped
	ld a,(wGameKeysJustPressed)
	jr nz,+
.endif
	ld a,(wGameKeysPressed)
	+
.else
	ld a,(wGameKeysJustPressed)
.endif
	and BTN_A|BTN_B
	ret z
.ifdef ENABLE_RING_REDUX
	; get the opposite button of the one this item is assigned
	; to and use it to determine if we smack with the item
	call wasOppositeItemButtonPressed
	jr z,+++
		; only smack if the button was JUST pressed
		ld c,a
		ld a,(wGameKeysJustPressed)
		and c
		ret z

		call judoMasterComboActive
		jr nz,+++
			ld h,d
			ld l,Item.state
			ld (hl),$06

			ld l,Item.animCounter
			ld (hl),$0f
			xor a
			inc l
			ld (hl),a

			; retrieve the held object
			call getHeldObject

			; if this isn't an item, don't do any of this
			ld a,l
			or a
			jr nz,+
				; Enable collisions on the throwable
				ld l,Object.collisionType
				set 7,(hl)
				inc l
				inc l

				; set the collision radius
				ld a,$08
				ldi (hl),a
				ld (hl),a

				ld l,Object.direction
				ld a,(w1Link.direction)
				ld (hl),a
				; update the angle
				ldi a,(hl)
				swap a
				rrca
				ldd (hl),a
			+

			; disable link movement
			call itemDisableLinkMovementAndTurning

			; unsetting this will prevent updateGrabbedObjectPosition from including
			; link's animation in the objects position(it's meant for bobbing up/down)
			ld hl,wLinkGrabState
			res 0,(hl)

			; these are both really good, so it's hard to choose
			;ld a,SND_SCENT_SEED
			ld a,SND_SEEDSHOOTER
			jp playSound
	+++
@forceThrow:
.endif

	call updateLinkDirectionFromAngle
++
	; Item is being thrown

	; Unlink related object from Link, set its "substate" to $02 (meaning just thrown)
	ld hl,w1Link.relatedObj2
	xor a
	ld c,(hl)
	ldi (hl),a
	ld b,(hl)
	ldi (hl),a
	ld a,c
	add Object.substate
	ld l,a
	ld h,b
	ld (hl),$02

.ifdef ENABLE_RING_REDUX
	ld a,l
	and $c0
	jr z,+
		ld l,Enemy.invincibilityCounter
		push hl
		ld h,d
		ld l,Item.substate
		xor a
		or (hl)
		ld a,$da ; long throw timer
		jr z,++
			ld a,$e8 ; short throw timer
		++
		pop hl
		; make enemy invincible so they don't take damage till hitting ground
		ld (hl),a
	+
.endif

	; If it was a tile that was picked up, don't create any new objects
	ld e,Item.var37
	ld a,(de)
	or a
	jr nz,@@throwItem

	; If this is referencing an item object beyond index $d7, don't create object $dc
	ld a,c
	cpa Item.start
	jr nz,@@createPlaceholder
	ld a,b
	cp FIRST_DYNAMIC_ITEM_INDEX
	jr nc,@@throwItem

	; Create an invisible bracelet object to be used for collisions?
	; This is used when throwing dimitri, but not for picked-up tiles.
@@createPlaceholder:
	push de
	ld hl,w1ReservedItemC.enabled
	inc (hl)
	inc l
	ld a,ITEM_BRACELET
	ldi (hl),a

	; Copy over this parent item's former relatedObj2 & Y/X to the new "physical" item
	ld l,Item.relatedObj2
	ld a,c
	ldi (hl),a
	ld (hl),b
	add Item.yh
	ld e,a
	ld d,b
	call objectCopyPosition_rawAddress
	pop de

@@throwItem:
	ld a,(wLinkAngle)
	rlca
	jr c,+
	ld a,(w1Link.direction)
	swap a
	rrca
+
	ld l,Item.angle
	ld (hl),a
	ld l,Item.var38
	ld a,(wLinkGrabState2)
	ld (hl),a
	xor a
	ld (wLinkGrabState2),a
	ld (wLinkGrabState),a
	ld h,d
	ld l,Item.state
	inc (hl)
	ld l,Item.var3f
	ld (hl),$0f

	ld c,LINK_ANIM_MODE_THROW

.ifdef ROM_AGES ; TODO: why does only ages check this?
	; Load animation depending on whether Link's riding a minecart
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_MINECART
	jr nz,+
.endif

	ld a,(wLinkObjectIndex)
	rrca
	jr nc,+
	ld c,LINK_ANIM_MODE_25
+
	ld a,c
	call specialObjectSetAnimationWithLinkData
	call itemDisableLinkMovementAndTurning
	ld a,SND_THROW
	jp playSound


; State 4: Link in throwing animation.
; This is also state 4 for bombs.
@state4:
	ld e,Item.animParameter
	ld a,(de)
	rlca
	jp nc,specialObjectAnimate_optimized
	jr @dropAndDeleteSelf

;;
@deleteAndRetIfSwimmingOrGrabState0:
.ifdef ENABLE_RING_REDUX
	; if the held object is gone, also drop
	push hl
	call getHeldObject
	jp nz,++
		xor a
		cp h
		; only clear if the pointer is valid
		jr z,++
			; clear the object's x, y, and z values, as it appears they
			; arent always cleared, causing objects to float if reloaded
			ld a,l
			add Object.y
			ld l,a
			ld b,$06
			call clearMemory
			jr +
	++
	pop hl
.endif
	ld a,(wLinkSwimmingState)
	or a
	jr nz,+
	ld a,(wLinkGrabState)
	or a
	ret nz
+
	pop af

@dropAndDeleteSelf:
	call dropLinkHeldItem
	jp clearParentItem

;;
; @param[out]	bc	Y/X of tile Link is grabbing
; @param[out]	zflag	Set if Link is directly facing a wall
@checkWallInFrontOfLink:
	ld a,(w1Link.direction)
	ld b,a
	add a
	add b
	ld hl,@@data
	rst_addAToHl
	ld a,(w1Link.adjacentWallsBitset)
	and (hl)
	cp (hl)
	ret nz

	inc hl
	ld a,(w1Link.yh)
	add (hl)
	ld b,a
	inc hl
	ld a,(w1Link.xh)
	add (hl)
	ld c,a
	xor a
	ret

; b0: bits in w1Link.adjacentWallsBitset that should be set
; b1/b2: Y/X offsets from Link's position
@@data:
	.db $c0 $fb $00 ; DIR_UP
	.db $03 $00 $07 ; DIR_RIGHT
	.db $30 $07 $00 ; DIR_DOWN
	.db $0c $00 $f8 ; DIR_LEFT


; State 5: pulling a lever?
@state5:
	call parentItemCheckButtonPressed
	jp z,@dropAndDeleteSelf
	call @deleteAndRetIfSwimmingOrGrabState0
	ld a,(w1Link.knockbackCounter)
	or a
	jp nz,@dropAndDeleteSelf

	ld a,(w1Link.direction)
	ld hl,@counterDirections
	rst_addAToHl
	ld a,(wGameKeysPressed)
	and (hl)
	ld a,LINK_ANIM_MODE_LIFT_2
	jp z,specialObjectSetAnimationWithLinkData
	jp specialObjectAnimate_optimized

.ifdef ENABLE_RING_REDUX
@state6:
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	jr nz,+
		dec l ; decrement animCounter
		dec (hl)
		jr z,++
			call isHasteRingEquipped
			jr nz,++
				dec (hl)
		++
		ld a,(hl)

		jr nz,++
			inc l ; move back to animParameter
			set 7,(hl)
		++

		; use links throwing sprite
		ld l,Item.var31
		ld (hl),$b0
		ld l,Item.var3f
		ld (hl),$0f

		; if this isn't an item, do an underhand throw instead of swinging
		call getHeldObject
		jr z,++
			ld c,a
			ld a,l
			and $c0
			ld a,c
			jr z,+++
				; invert frame order for throwing non-items
				ld a,15
				sub c
			jr +++
		++
			; delete object if it's no longer valid
			ld h,d
			ld a,l
			add Object.state-Object.enabled
			ld l,a
			ld (hl),$00
			jp itemEnableLinkMovementAndTurning
		+++

		push hl
		ld hl,@swingAnimStates
		rst_addAToHl
		ld a,(hl)

		; load links var03 with the custom grab state to override with
		ld hl,w1Link.var03
		push af
		and $3f
		ld (hl),a
		pop af
		pop hl

		; if this isn't an item, release it on the
		; frame it gets closest to the ground
		bit 7,l
		jr nz,++
			bit 6,l
			jr z,++++
			++
				bit 6,a
				jr z,++
				ld h,d
				ld l,Item.state
				ld (hl),$03
				inc l
				; NOTE: substate indicates to use a short invincibility
				;		timer since the enemy will bounce less
				ld (hl),$01
				jp @forceThrow

		++++
			ld l,Item.oamFlags
			bit 7,a
			res 6,(hl)
			jr z,++
				set 6,(hl)
		++
		ret
	+
	; reset to holding state and anim
	ld l,Item.state
	ld (hl),$03

	; reset links sprite
	ld l,Item.var32
	ld (hl),$5c
	xor a
	ld l,Item.var3f
	ld (hl),a

	; get the object(if it's still valid)
	call getHeldObject

	; object is still valid. disable collisions
	jr z,+
		ld l,Item.collisionType
		res 7,(hl)

		; set low bit if necessary so object bobs while link moves
		ld hl,wLinkGrabState
		xor a
		or (hl)
		jr z,+
			set 0,(hl)
	+
	jp itemEnableLinkMovementAndTurning

; Bit 7:    If set, vertically mirror the item
; Bit 6:    If set, non-item objects are released on this frame
; Bits 4-5: Weight of object(affects position)
; Bits 0-3: Low nibble to use as wLinkGrabState2
@swingAnimStates:
	.db $08 $08
	.db $04 $04 $04
	.db $04 $84 $84
	.db $81 $81 $c2
	.db $c2 $82 $94
	.db $94 $14
.endif