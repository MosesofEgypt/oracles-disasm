;;
; Checks everything in wAButtonSensitiveObjectList (npcs mostly) and triggers them if the
; A button has been pressed near them.
;
; @param[out]	c	Non-zero if Link just pressed A next to the object
linkInteractWithAButtonSensitiveObjects_body:
    ld c,$00
	ld a,(wGameKeysJustPressed)
	and BTN_A
	ret z

	; If he's in a shop, he can interact while holding something
	ld a,(wInShop)
	or a
	jr nz,+

	; If he's not in a shop, this should return if he's holding something
	ld a,(wLinkGrabState)
	or a
	ret nz
+
	push de
	ld e,SpecialObject.direction
	ld a,(de)
	ld hl,@positionOffsets
	rst_addDoubleIndex

	; Store y + offset into [hFF8D]
	ld e,SpecialObject.yh
	ld a,(de)
	add (hl)
	ldh (<hFF8D),a

	; Store x + offset into [hFF8C]
	inc hl
	ld e,SpecialObject.xh
	ld a,(de)
	add (hl)
	ldh (<hFF8C),a

	; Check all objects in the list
	ld de,wAButtonSensitiveObjectList
---
	; Get the object in hl
	ld a,(de)
	ld h,a
	inc e
	ld a,(de)
	ld l,a
	or h
	jr z,+

	; Check if link is directly in front of the object
	push hl
	ldh a,(<hFF8D)
	ld b,a
	ldh a,(<hFF8C)
	ld c,a
	call objectHCheckContainsPoint
	pop hl
	jr nc,+

	; Link is next to the object; only trigger it if the "pressedAButton" variable is
	; not already set.
	bit 0,(hl)
	jr z,@foundObject
+
	inc e
	ld a,e
	cp <wAButtonSensitiveObjectListEnd
	jr c,---

	; No object found
	pop de
    ld c,$00
	ret

@foundObject:
	; Set the object's "pressedAButton" variable.
	set 0,(hl)

	; For some reason, set Link's invincibility whenever triggering an object?
	ld hl,w1Link.invincibilityCounter
	ld a,(hl)
	or a
	ld a,$fc
	jr z,++

	bit 7,(hl)
	jr nz,@negativeValue

	; Link's invincibility already has a positive value ($01-$7f), meaning he's
	; flashing red from damage.
	; Make sure he stays invincible for at least 4 more frames?
	ld a,$04
	cp (hl)
	jr c,@doneWithInvincibility
	jr ++

	; Negative value for invincibility means he isn't flashing red.
	; Again, this makes sure he stays invincible for at least 4 more frames.
@negativeValue:
	cp (hl)
	jr nc,@doneWithInvincibility
++
	ld (hl),a

@doneWithInvincibility:
	; Disable ring transformations for 8 frames? (He can't normally interact with
	; objects while transformed... so what's the point of this?)
	ld a,$08
	ld (wDisableRingTransformations),a

	; Disable pushing animation
	ld a,$80
	ld (wForceLinkPushAnimation),a

	ld hl,wLinkTurningDisabled
	set 7,(hl)

	pop de
    ld c,$01
	ret

@positionOffsets:
	.db $f6 $00 ; DIR_UP
	.db $00 $0a ; DIR_RIGHT
	.db $0a $00 ; DIR_DOWN
	.db $00 $f6 ; DIR_LEFT



.ifdef CONTEXT_SENSITIVE_AUTO_EQUIP
;;
; @param	b		The item to auto-equip or un-equip.
; @param	zflag	Equip item if set. Otherwise unequip.
; @param[out]	zflag	Set if swap occurred.
handleAutoEquipItem_body:
    ld a,b
	push hl
	push af
.ifdef MORE_MESSAGE_SPEEDS
	ld hl,wMiscSettings
	bit 4,(hl)
	jr z,++
.endif
		bit 5,(hl)
		ld hl,wInventoryB
		jr z,+
			inc l
		+
		pop af
		push af
		push de
		ld d,a
		jr nz,+
			; equipping. only swap if not already equipped
			cp (hl)
			jr z,++++
				ld a,(wAutoEquipInvSlot)
				cp $ff
				jr nz,++++
					call @swapItemWithInventory
				jr +++
			++++
				or $01
				jr +++
		+
		; unequipping. only swap if it was auto-equipped
		cp (hl)
		jr nz,+++
			ld a,(wAutoEquipInvSlot)
			cp $ff
			jr z,++++
				call @swapItemWithInventory
				ld a,$ff
				ld (wAutoEquipInvSlot),a
				jr +++
		++++
			or $01
		+++
			pop de
	++
	pop hl
	ld a,h
	pop hl
	ret

;;
; @param d                 The item to auto-equip or un-equip.
; @param hl                The equipped item slot to swap out
; @param wAutoEquipInvSlot The inventory item slot to swap with.
;                          If this is $ff, it must be searched for.
@swapItemWithInventory:
	ld a,(wAutoEquipInvSlot)
	cp $ff
	jr nz,+
		push hl
		; find d in wInventoryStorage
		ld hl,wInventoryStorage
		ld e,$10
		-
			ldi a,(hl)
			cp d
			jr z,++
				dec e
				jr nz,-
					; failed to find it
					pop hl
					ret
			++
		dec l
		ld a,l
		ld (wAutoEquipInvSlot),a
		pop hl
	+
	ld a,(wAutoEquipInvSlot)
	ld e,a
	ld d,>wInventoryStorage

	ld a,(de)
.ifndef ONE_HANDED_BIGGORON_SWORD
	cp ITEM_BIGGORON_SWORD
	jr nz,+
		; biggoron sword being equipped. put it in both slots
		ld d,(hl)
		push hl
		ld l,<wInventoryB
		ldi (hl),a
		ldi (hl),a
		pop hl
		ld (hl),d
	+
.endif
	ld d,a
	ld a,(hl)
.ifndef ONE_HANDED_BIGGORON_SWORD
	cp ITEM_BIGGORON_SWORD
	jr nz,+
		; biggoron sword being unequipped. remove from both slots
		push hl
		ld l,<wInventoryB
		xor a
		ldi (hl),a
		ldi (hl),a
		ld a,ITEM_BIGGORON_SWORD
		pop hl
	+
.endif
	ld (hl),d
	ld d,>wInventoryStorage
	ld (de),a

	ld hl,(wStatusBarNeedsRefresh)
	set 0,(hl)
	set 1,(hl)
	xor a ; set flag indicating swap occurred
	ret
.endif

.ifdef ENABLE_RING_REDUX
fractionOf8Multiply:
	push hl
	push de
	ld a,b
	ld e,c

	; store the number of whole increments of 8 in h
	ld h,a
	srl h
	srl h
	srl h

	; copy the fractional-multiples into l for decrementing
	and $07
	ld l,a

	; store the base as a positive value in d
	ld a,e
	bit 7,a
	jr z,+
		cpl
		inc a
	+
	ld d,a

	ld b,$00
	ld c,b

	; add fractions if there are any
	ld a,l
	or a
	ld a,c
	jr z,+
		-
			add d
			jr nc,++
				inc b
			++
			dec l
			jr nz,-

		; convert the whole multiples into fractions
		srl a
		srl a
		srl a
		ld c,a

		ld a,b
		swap a
		sla a
		and $e0
		or c
		ld c,a

		srl b
		srl b
		srl b
	+

	; add the whole multiples
	ld a,h
	or a
	ld a,c
	jr z,+
		-
			add d
			jr nc,++
				inc b
			++
			dec h
			jr nz,-
		ld c,a
	+

	bit 7,e
	jr z,+
		; fix the sign
		ld a,c
		cpl
		inc a
		ld c,a
		ld a,b
		cpl
		jr nc,++
			inc a
		++
		ld b,a
	+

	pop de
	pop hl
	ret
.endif