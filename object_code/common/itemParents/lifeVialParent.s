;;
; ITEM_LIFE_VIAL ($12)
parentItemCode_lifeVial:
	; Any time the shield can be used is a time the vial can be used
	call parentItemCode_shield@checkShieldIsUsable
	jp nc,clearParentItem

	; ensure there are charges to use
	ld hl,wLifeVialCharges
	ld a,(hl)
	or a
	jr nz,+
		ld a,(wKeysJustPressed)
		and BTN_BIT_A|BTN_BIT_B

		ld a,SND_ERROR
		call nz,playSound
		jp clearParentItem
	+

	; ensure health isn't already full
	call getLinkMaxHealth
	ld l,a
	ld a,(wLinkHealth)
	cp l
	jp z,clearParentItem

	; Return if any other item is in use
	call checkNoOtherParentItemsInUse
	ret nz

	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	ld a,$01
	ld (de),a

	; exactly 17 frames between heart refills
	ld a,$11
	ld e,Item.counter1
	ld (de),a

@state1:
	call parentItemLoadAnimationAndIncState

	; count down till we can heal again
	ld h,d
	ld l,Item.counter1
	ld a,(hl)
	or a
	jr z,+
		dec (hl)
		ret nz
	+
	ld hl,wLinkHealth
	ldi a,(hl)
	cp (hl)

	; make sure we don't overheal
	ret z

	ld hl,wLifeVialCharges
	ld a,(hl)
	or a

	; don't heal if no charges are left
	ret z

	; reduce charges by 1
	dec a
	daa
	ldi (hl),a

	; indicate the item count needs to be refreshed
	ld hl,wStatusBarNeedsRefresh
	set 1,(hl)

	; heal 1 heart
	ld hl,wLinkHealth
	ldi a,(hl)
	inc a
	cp (hl)
	jr z,+
		inc a
		cp (hl)
		jr z,+
			inc a
			cp (hl)
			jr z,+
				inc a
	+
	dec l
	ld (hl),a

	jr @state0