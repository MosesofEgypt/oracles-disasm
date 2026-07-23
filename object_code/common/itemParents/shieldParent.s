;;
; ITEM_SHIELD ($01)
parentItemCode_shield:
	; Verify that the shield can be used
	call @checkShieldIsUsable
	jr nc,@deleteSelf

	; Return if any other item is in use
	call checkNoOtherParentItemsInUse
	ret nz

	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	; Go to state 1
	ld a,$01
	ld (de),a

	ld a,SND_SHIELD
	call playSound

@state1:
	; It seems that wUsingShield will get unset from elsewhere each frame, so not
	; running this code would suffice to stop using the shield
	ld a,(wShieldLevel)
.ifdef ENABLE_RING_REDUX
	call victoryRingIncLevel
.endif
	ld (wUsingShield),a
.ifdef ENABLE_RING_REDUX
	call @shieldHeldLastFrame
	ret nz
	; shield wasn't out last frame.
	; check if the timer for parry attempts is empty
	ld bc,wShieldParryTimers
	ld a,(bc)
	and $1f
	jr nz,+
		; attempt timer is empty, so reset it and the active timer.
		ld a,(wUsingShield)
		dec a
		and $03
		add a
		ld hl,@parryTimers
		rst_addAToHl
		ldi a,(hl)
		or (hl)
		; fall through
	+
	; attempt timer isn't empty, so set the active timer to 0 as a fail.
	ld (bc),a
	ret

@parryTimers:
	.db $1e (4<<5)
	.db $1b (4<<5)
	.db $18 (5<<5)
	.db $14 (6<<5)

.else
	ret
.endif

@deleteSelf:
	xor a
	ld (wUsingShield),a
.ifdef ENABLE_RING_REDUX
	ld hl,wShieldParryTimers
	ld a,(hl)
	and $1f
	ld (hl),a
.endif
	jp clearParentItem

;;
; @param[out]	cflag	Set if the shield is ok to use (and the button is held)
@checkShieldIsUsable:
	; Can't use while swimming
	ld a,(wLinkSwimmingState)
	or a
	jr nz,@@disallowShield

	; Check if in a spinner
	ld a,(wcc95)
	rlca
	jr c,@@disallowShield

.if defined(ROM_AGES) || defined(ROM_COMBO)
	; Can't use underwater
	call isLinkUnderwater
	jr nz,@@disallowShield

	; Can use on the raft, but not on any other rides
	ld a,(w1Companion.id)
	cp SPECIALOBJECT_RAFT
	jr z,+
.endif

	ld a,(wLinkObjectIndex)
	rrca
	jr c,@@disallowShield
+
	; Shield is allowed; now check that the button is still held
	call parentItemCheckButtonPressed
	jr z,@@disallowShield
	scf
	ret

@@disallowShield:
	xor a
	ret


.ifdef ENABLE_RING_REDUX
@shieldHeldLastFrame:
	ld h,d
	ld l,Item.var03
	ld a,(wKeysPressedLastFrame)
	and (hl)
	ret
.endif