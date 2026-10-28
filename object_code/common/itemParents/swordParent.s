.ifdef ENABLE_RING_REDUX
beamosComboActive:
	isRingEquipped LIGHT_RING_L1
	ret nz
	isRingEquipped LIGHT_RING_L2
	ret

swordShmupComboActive:
	isRingEquipped CHARGE_RING
	ret nz
	isRingEquipped LIGHT_RING_L1
	ret z
	isRingEquipped LIGHT_RING_L2
	ret
.endif

;;
; ITEM_SWORD ($05)
parentItemCode_sword:
	call clearParentItemIfCantUseSword
.ifdef ENABLE_RING_REDUX
	; moving fast enough with steadfast ring and
	; sword out is considered a steadfast dash.
	; link also has to be moving in the direction he's facing
	ld hl,wOptimizationFlags
	res 5,(hl)
	isRingEquipped STEADFAST_RING
	jr nz,+
		ld a,(w1Link.speed)
		cp SPEED_140
		jr c,+
			; the code is a bit complex, but it just allows for diagonal movement
			ld a,(w1Link.direction)
			rlca
			ld e,a
			ld a,(w1Link.angle)
			rrca
			rrca
			inc a
			sub e
			and $07
			cp $03
			jr nc,+
				set 5,(hl)
	+
.endif
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
	.dw @state6
	.dw @state7
	.dw @state8
	.dw @state9


; Initialization
@state0:
	xor a
	ld e,Item.var2f
	ld (de),a
	ld hl,wcc63
	bit 7,(hl)
	jr nz,++

	ld (hl),$00
	call updateLinkDirectionFromAngle

.ifndef ENABLE_RING_REDUX
	; If double-edged ring in use, [Item.var3a] = $f8
	ld a,(wLinkHealth)
	cp $05
	jr c,++
	isRingEquipped DBL_EDGED_RING
	jr nz,++
	ld e,Item.var3a
	ld a,$f8
	ld (de),a
.endif
++
	; Initialize child item
	ld hl,w1WeaponItem.enabled
	ld a,(hl)
	or a
	ld b,$04
	call nz,clearMemory16ByteBlocks
	ld h,d
	ld l,Item.enabled
	set 7,(hl)
	call parentItemLoadAnimationAndIncState
.ifdef ENABLE_RING_REDUX
	call itemCreateChild
	ret c ; failed to create child

	isRingEquipped PLUNGING_RING
	ret nz
	ld a,(wLinkInAir)
	or a
	ret z
	.if defined(ROM_COMBO) || defined(ROM_AGES)
		.if defined(ROM_COMBO)
			call wIsSeasons
			jr c,++
		.endif
		ld a,(wTilesetFlags)
		and TILESETFLAG_UNDERWATER
		ret nz
		++
	.endif
	jp @doPlungingAttack
.else
	jp itemCreateChild
.endif

@doPlungingAttack:
	ld e,Item.state
	ld a,$07
	ld (de),a

	; mark this as a plunging attack
	ld a,$02
	ld e,Item.var2f
	ld (de),a

	ld a,LINK_ANIM_MODE_DOWNSTAB
	call specialObjectSetAnimationWithLinkData

	; draw sword in-front of link if he's facing any direction but up
	ld a,(w1Link.direction)
	cpa DIR_UP
	ld a,$81
	jr nz,+
		; draw behind
		inc a
	+
	ld (w1WeaponItem.visible),a
	ret

; starting plunging attack
@state7:
	; move to holding stance
	ld a,$08
	ld e,Item.state
	ld (de),a

	; Set child item to state 4 (swordspinning and downstabbing)
	ld hl,w1WeaponItem.state
	ld (hl),$07

	; multiply base damage by 1.6666x
	ld l,Item.var3a
	ld a,(hl)
	sra a
	add (hl)
	ld (hl),a

	; make link start to fall
	ld hl,w1Link.speedZ
	ld bc,$0180
	ld (hl),c
	inc l
	ld (hl),b

	; disable item use until attack finishes
	ld a,$80
	ld (wcc63),a

; holding plunging attack stance
@state8:
	call specialObjectAnimate_optimized

	ld hl,wLinkInAir

	; check if link hit ground
	ld a,(wTilesetFlags)
	bit TILESETFLAG_BIT_SIDESCROLL,a
	jr nz,+
		ld a,(w1Link.zh)
		bit 7,a
		jr ++
	+
		ld a,(hl)
		or a
	++

	; remove reduced gravity and prevent further jumping
	res 5,(hl)
	set 4,(hl)

	jr nz,+
		; move to landing stance
		ld a,$09
		ld e,Item.state
		ld (de),a

		; setup a shockwave and recoil counter
		ld a,$1e
		ld e,Item.counter1
		ld (de),a
		ld a,$03
		inc e
		ld (de),a

		ld c,$09
		-
			dec c
			push bc
			callab itemCode.tryBreakTileWithSwordDirInC_calculateLevel
			pop bc
			ld a,c
			or a
			jr nz,-

		; move the sword item into the shockwave state
		ld a,$08
		ld (w1WeaponItem.state),a

		; make a nice impact sound and visual effect
		ld a,$04
		call setScreenShakeCounter
		xor a
		ld (wScreenShakeMagnitude),a

		; reenable jumping
		xor a
		ld (wLinkInAir),a

		ld a,SND_DOORCLOSE
		jp playSound
	+

	; if the sword hit something, make link bounce
	ld hl,w1WeaponItem.var2a
	bit 0,(hl)
	ret z
	res 0,(hl)

	; don't bounce unless currently moving downward
	ld hl,w1Link.speedZ+1
	bit 7,(hl)
	ret nz

	ld bc,$fd90
	ld a,(wActiveGroup)
	cp FIRST_SIDESCROLL_GROUP
	jr c,+
		; Jump higher in sidescrolling rooms
		ld bc,$fd00
	+
	ld (hl),b
	dec l
	ld (hl),c

	; trigger the flip animation and reenable jumping
	ld a,(wFeatherLevel)
	cp $02
	ld a,$40
	jr c,+
		ld a,$41
	+
	ld (wLinkInAir),a

	; stop downstabbing now that a hit has connected
	jp @deleteSelf

; landed during plunging attack(several frames of downtime)
@state9:
	call itemDecCounter2
	jr nz,+
		ld hl,w1WeaponItem.state
		inc (hl)
	+

	call itemDecCounter1
	ret nz

	; done recoiling
	jp @deleteSelf


; Sword being swung
@state1:
	ld a,(wcc63)
	rlca
	jp c,@doSpinAttack

	call specialObjectAnimate_optimized
.ifdef ENABLE_RING_REDUX
	isRingEquipped HASTE_RING
	call z,specialObjectAnimate_optimized
.endif
	ld h,d
	ld e,Item.animParameter
	ld a,(de)
	or a
	jr z,++

	ld l,Item.var3a
	bit 7,(hl)
	jr nz,++
	ld l,Item.enabled
	res 7,(hl)
++
	; Check for bit 7 of animParameter (marks end of swing animation)
	ld l,e
	bit 7,a
	jr nz,@state6

	bit 5,a
	ret z
	res 5,(hl)
	ld a,(wSwordLevel)

.ifdef ENABLE_RING_REDUX
	call victoryRingIncLevel
.endif

	cp $02
	jp nc,@checkCreateSwordBeam
	ret


; State 6: re-initialize after sword poke (also executed after sword swing)
@state6:
	ld a,(w1WeaponItem.var2a)
	or a
	jp nz,@enemyContact

	ld a,(wLinkObjectIndex)
	rrca
	jp c,@deleteSelf
	call parentItemCheckButtonPressed
	jp z,@deleteSelf

	ld a,$01
	ld (wcc63),a

	; Set child item to state 2
	inc a
	ld (w1WeaponItem.state),a

	ld a, $80 | ITEMCOLLISION_SWORD_HELD
	ld (w1WeaponItem.collisionType),a

	ld l,Item.state
	ld (hl),$02

	; [Item.substate] = 0
	inc l
	xor a
	ld (hl),a

	ld l,Item.var3a
	ld (hl),a
	ld l,Item.var3f
	ld (hl),a

	ld l,Item.counter1
	ld (hl),$28

	jp itemEnableLinkMovement

; @param	a	Value of Item.var2a
@enemyContact:
	bit 0,a
	jp z,@deleteSelf

	; Check for double-edged ring
	ld e,Item.var3a
	ld a,(de)
	or a
	jp z,@deleteSelf

	ld hl,w1Link.damageToApply
	add (hl)
	ld (hl),a
	xor a
	ld (de),a
	jp @deleteSelf


; Sword being held, charging swordspin
@state2:
	ld a,(wLinkObjectIndex)
	rrca
	jp c,@deleteSelf
	call parentItemCheckButtonPressed
	jp z,@deleteSelf
	call @checkAndRetForSwordPoke
	isRingEquipped CHARGE_RING
	ld c,$01
	jr nz,+
	ld c,$04
+
	ld l,Item.counter1
	ld a,(hl)
	sub c
	ld (hl),a
	ret nc

.ifdef ENABLE_RING_REDUX
	call swordShmupComboActive
	jr nz,+
		call @createSwordBeam

		ld h,d
		ld l,Item.counter1
		ld (hl),SUPER_BEAM_DELAY
		ret
.else
	isRingEquipped ENERGY_RING
	jr nz,+
		call @createSwordBeam
		jp @triggerSwordPoke
.endif
+
	ld l,Item.state
	inc (hl)
	ld l,Item.enabled
	set 7,(hl)
	ld a,$03
	ld (w1WeaponItem.state),a
	ld a,SND_CHARGE_SWORD
	jp playSound


; Sword being held, fully charged
@state3:
	call @checkAndRetForSwordPoke
	call parentItemCheckButtonPressed
	ret nz
.ifdef ENABLE_RING_REDUX
	; reset this
	xor a
	ld (wSwordDamageCached),a
.else
	ret nz
.endif

@doSpinAttack:
	ld h,d
	ld a,$02
	ld (wcc63),a
	ld l,Item.state
	ld (hl),$04
.ifdef ENABLE_RING_REDUX
	ld a,$05
.else
	isRingEquipped SPIN_RING
	ld a,$05
	jr nz,+
	ld a,$09
+
.endif
	ld l,Item.counter1
	ld (hl),a
	ld l,Item.var3f
	ld (hl),$0f

.if defined(ROM_AGES) || defined(ROM_COMBO)
	call isLinkUnderwater
	ld c,LINK_ANIM_MODE_28
	jr z,+
	ld c,LINK_ANIM_MODE_30
+
	ld a,(w1Link.direction)
	add c

.else; ROM_SEASONS
	ld a,(w1Link.direction)
	add LINK_ANIM_MODE_28
.endif

	call specialObjectSetAnimationWithLinkData
	ld h,d
	ld l,Item.animParameter
	res 6,(hl)

	ld hl,w1WeaponItem.state
	ld (hl),$04

	; double base damage for spin attack
	ld l,Item.var3a
	sla (hl)

.ifdef ENABLE_RING_REDUX
	ld hl,wLinkSwimmingState
	ld a,(hl)
	or (hl)
	jr nz,+
		isRingEquipped HURRICANE_RING
		ld h,d
		ld l,Item.var2f
		ld (hl),$00
		jr nz,+
			; mark this as a super spin using an unused variable
			ld (hl),$01
			ld l,Item.counter1
			ld (hl),SPIN_SWING_COUNTER
			jr ++
	+
	call itemDisableLinkMovement
	++
.else
	call itemDisableLinkMovement
.endif

	ld a,SND_SWORDSPIN
	jp playSound


; Performing a swordspin
@state4:
	call specialObjectAnimate_optimized
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	ret z

	res 7,(hl)
	ld l,Item.counter1
	dec (hl)
.ifdef ENABLE_RING_REDUX
	ld l,Item.var2f
	ld a,$01
	cp (hl)
	ld l,Item.counter1
	jr z,+
		; not hurricane spin
		ld a,(hl)
		or a
		jr ++
	+

	; play sword swish
	ld a,(hl)
	and $03
	jr nz,+
		push hl
		ld a,SND_SWORDSPIN
		call playSound
		pop hl
	+

	.ifdef INDEFINITE_HURRICANE_SPIN
		push hl
		call parentItemCheckButtonPressed
		pop hl
		jr z,+
			ld a,(hl)
			cp a,$01
			jr nz,+
				; add another spin to the count while button is held
				add $04
				ld (hl),a
		+
	.endif

	; cleanup
	ld a,(hl)
	or a
	jr nz,++
		ld a,$05
		ld (w1WeaponItem.state),a
		call @deleteSelf

	; make link dizzy when spin finishes
	ld a,SND_LINK_DEAD
	call playSound
	push hl
	ld hl,wLinkForceState
	ld a,LINK_STATE_COLLAPSED
	ldi (hl),a
	ld a,$00
	ldi (hl),a
	ld hl,w1Link.counter1
	ld (hl),$01
	pop hl

	ld a,(hl)
	or a

	++
.endif
	ret nz

	ld a,$05
	ld (w1WeaponItem.state),a
	jp @deleteSelf

; Swordspin ending
@state5:
	call specialObjectAnimate_optimized
	ld h,d
	ld l,Item.animParameter
	bit 7,(hl)
	ret z

	ld l,Item.subid
	ld a,(hl)
	or a
	jr z,@deleteSelf

	; Go to state 6
	ld a,$06
	ld (w1WeaponItem.state),a
	ld l,Item.state
	inc (hl)

	xor a
	ld (w1WeaponItem.var2a),a
	ret


@deleteSelf:
	xor a
	ld (wcc63),a
	jp clearParentItem


; Checks if Link's doing sword poke; sets animations, etc, and returns from the caller if
; so?
@checkAndRetForSwordPoke:
	xor a
	ld e,Item.subid
	ld (de),a

.ifdef ENABLE_RING_REDUX
	; don't trigger sword poke termination if steadfast dashing
	ld a,(wOptimizationFlags)
	bit 5,a
	jr z,+
		; reset "sword collided with enemy" status
		; and set the "object collidable" bit
		xor a
		ld (w1WeaponItem.var2a),a
		ld a,(w1WeaponItem.collisionType)
		or $80
		ld (w1WeaponItem.collisionType),a
		ret
	+
.endif

	ld a,(w1WeaponItem.var2a)
	cp $04
	jr z,+
		or a
		jr nz,++
			call checkLinkPushingAgainstWall
			ret nc
	+
		; set flag to indicate that tryBreakTileWithSword
		; should create a clink effect when it's called.
		ld e,Item.subid
		ld a,$01
		ld (de),a
	++
	; Return from caller
	pop hl

	xor a
	ld (w1WeaponItem.collisionType),a

@triggerSwordPoke:
	ld h,d
	ld l,Item.var3f
	ld (hl),$08

	ld l,Item.state
	ld (hl),$05

	call itemDisableLinkMovement

.if defined(ROM_AGES) || defined(ROM_COMBO)
	call isLinkUnderwater
	ld a,LINK_ANIM_MODE_1f
	jr z,+
	ld a,LINK_ANIM_MODE_2c
+
.else; ROM_SEASONS
	ld a,LINK_ANIM_MODE_1f
.endif
	jp specialObjectSetAnimationWithLinkData

@checkCreateSwordBeam:
.ifdef ENABLE_RING_REDUX
	; figure out the heart cutoff for firing
	call swordBeamHeartCutoff
.else
	ld c,$08
	isRingEquipped LIGHT_RING_L1
	jr z,++
	ld c,$0c
	isRingEquipped LIGHT_RING_L2
	jr z,++
	ld c,$00
++
.endif
	ld hl,wLinkHealth
	ldi a,(hl)
	add c
	cp (hl)
	ret c

@createSwordBeam:
.ifdef ENABLE_RING_REDUX
	call beamosComboActive
	ld e,$01
	jr nz,+
		ld e,SWORD_BEAM_LIMIT
	+
	ldbc ITEM_SWORD_BEAM,$00
.else
	ldbc ITEM_SWORD_BEAM,$00
	ld e,$01
.endif
	call getFreeItemSlotWithObjectCap
	ret c

	inc (hl)
	inc l
	ld a,b
	ldi (hl),a
	ld a,c
	ldi (hl),a

	; Copy link direction, angle, & position variables
	push de
	ld de,w1Link.direction
	ld l,Item.direction
	ld b,$08
	call copyMemoryReverse

	pop de
	scf
	ret
