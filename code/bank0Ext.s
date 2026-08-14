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

.ifdef ENABLE_NEW_GAME_PLUS
getNgpUpgradeCount:
	push de
	push hl
	ld de,wNgpUncappedUpgradesThisRoom
	ld hl,@ngpUncappedEnemyUpgradeTimes
	jr nc,+
		ld de,wNgpEnemiesUpgradedThisRoom
		ld hl,@ngpEnemyUpgradeTimes
	+
	call getNewGamePlusCycle
	dec a	; NG+0 doesn't have values
	; multiply NG+ cycle by 8
	add a
	add a
	add a
	bit 0,b
	jr z,+
		; strong enemy, so skip the first set of 24 values
		add $18
	+
	rst_addAToHl
	ld a,(de)
	bit 0,b
	jr z,+
		; strong enemy, so grab upper nibble for count
		swap a
	+
	and $0f
	ld c,a
	srl a
	rst_addAToHl
	ld a,(hl)
	; if count is even, use upper nibble as the times
	bit 0,c
	jr nz,+
		swap a
	+
	and $0f
	pop hl
	pop de
	ret

@ngpUncappedEnemyUpgradeTimes:
	; same structure and function as @ngpEnemyUpgradeTimes
	; under the getEnemyUpgradeCount function. the difference
	; is that since this is for respawning objects, the count
	; should be more or less consistent since we're going to
	; loop back around to the beginning once we hit the end
	.db $11 $21 $11 $21 $11 $21 $11 $21; NG+1 enemy
	.db $23 $41 $21 $31 $21 $31 $21 $31; NG+2 enemy
	.db $42 $31 $32 $31 $42 $31 $32 $31; NG+3 enemy

	.db $11 $11 $11 $11 $11 $11 $11 $11; NG+1 projectile
	.db $11 $21 $11 $21 $11 $21 $11 $21; NG+2 projectile
	.db $21 $21 $21 $21 $21 $21 $21 $21; NG+3 projectile

@ngpEnemyUpgradeTimes:
	; dictates how many times an enemy can be upgraded.
	; each set of 8 bytes corresponds to how many times
	; enemies have already been upgraded this screen.

	; each nibble corresponds to one of the 16 times an
	; upgrade occurs per screen. to make it easy to read,
	; the high nibble represents an even numbered count
	; while low nibble represents an odd numbered count.

	; this table is critical to creating variety in how
	; many enemies are upgraded per screen. this helps
	; prevent straight converting a room of red darknuts
	; into a room of a blue/green.

	; to prevent players killing weak enemies to get weak
	; ones to spawn on reloading the room, the low indices
	; should be the highest upgrade counts. these values
	; should approach and reach 0 at higher indices, but
	; take longer to do so on higher NG+ cycles.
	.db $22 $22 $31 $11 $00 $00 $00 $00; NG+1 weak enemy
	.db $33 $22 $23 $22 $11 $11 $00 $00; NG+2 weak enemy
	.db $43 $14 $21 $32 $11 $11 $11 $10; NG+3 weak enemy

	.db $21 $11 $00 $00 $00 $00 $00 $00; NG+1 strong enemy
	.db $21 $22 $10 $00 $00 $00 $00 $00; NG+2 strong enemy
	.db $43 $23 $21 $10 $00 $00 $00 $00; NG+3 strong enemy
.endif

;;
; Set Link's death respawn point based on the current room / position variables.
setDeathRespawnPoint:
	ld hl,wDeathRespawnBuffer
	ld a,(wActiveGroup)
	ldi (hl),a
	ld a,(wActiveRoom)
	ldi (hl),a
	ld a,(wRoomStateModifier)
	ldi (hl),a
	ld a,(w1Link.direction)
	ldi (hl),a
	ld a,(w1Link.yh)
	ldi (hl),a
	ld a,(w1Link.xh)
	ldi (hl),a
	ld a,(wRememberedCompanionId)
	ldi (hl),a
	ld a,(wRememberedCompanionGroup)
	ldi (hl),a
	ld a,(wRememberedCompanionRoom)
	ldi (hl),a
	ld a,(wLinkObjectIndex)
	ldi (hl),a
	inc l
	ld a,(wRememberedCompanionY)
	ldi (hl),a
	ld a,(wRememberedCompanionX)
	ldi (hl),a
	ret

gfxRegisterStates:
	.db $c3 $00 $00 $c7 $c7 $c7 ; 0x00: DMG mode screen, capcom intro, ...
	.db $c3 $00 $00 $c7 $c7 $c7

	.db $c7 $00 $00 $c7 $c7 $c7 ; 0x01
	.db $00 $00 $00 $c7 $c7 $c7

	.db $ef $f0 $00 $8f $8f $0f ; 0x02: Post-d3 cutscene, twinrova/ganon fight, CUTSCENE_BLACK_TOWER_ESCAPE
	.db $e7 $00 $00 $c7 $c7 $c7

	.db $ef $f0 $00 $10 $c7 $0f ; 0x03
	.db $f7 $f0 $00 $10 $c7 $75

	.db $c7 $00 $00 $c7 $c7 $c7 ; 0x04: titlescreen
	.db $00 $00 $00 $c7 $c7 $c7

	.db $cf $00 $00 $c7 $c7 $c7 ; 0x05
	.db $00 $00 $00 $c7 $c7 $c7

	.db $a7 $00 $b0 $c7 $c7 $1f ; 0x06
	.db $8f $00 $00 $c7 $c7 $c7

	.db $c7 $00 $00 $c7 $c7 $c7 ; 0x07: map screens (both overworld and dungeon)?
	.db $00 $00 $00 $c7 $c7 $c7

	.db $a7 $00 $00 $90 $07 $00 ; 0x08
	.db $a7 $40 $00 $90 $07 $c7

	.db $c7 $70 $00 $c7 $c7 $c7 ; 0x09: temple in intro
	.db $c7 $00 $00 $c7 $c7 $c7

	.db $cf $70 $00 $c7 $c7 $c7 ; 0x0a: scrolling up the tree in the intro
	.db $cf $00 $00 $c7 $c7 $c7

	.db $cf $00 $20 $c7 $c7 $c7 ; 0x0b
	.db $cf $00 $00 $c7 $c7 $c7

	.db $a7 $00 $00 $78 $07 $27 ; 0x0c
	.db $af $f0 $00 $78 $07 $c7

	.db $c7 $10 $30 $c7 $c7 $c7 ; 0x0d
	.db $c7 $00 $00 $c7 $c7 $c7

	.db $e7 $01 $00 $4c $4c $c7 ; 0x0e
	.db $c7 $00 $00 $c7 $c7 $c7

	.db $af $f0 $00 $10 $07 $17 ; 0x0f: ring appraisal menu
	.db $f7 $f0 $00 $10 $c7 $57

	.db $b7 $f0 $00 $10 $07 $1f ; 0x10: ring list menu
	.db $f7 $f0 $00 $10 $c7 $47

	.db $ef $f0 $00 $8f $8f $0f ; 0x11
	.db $e7 $00 $00 $40 $57 $c7

	.db $ef $f0 $00 $8f $8f $0f ; 0x12
	.db $e7 $00 $00 $90 $47 $c7

	.db $e7 $00 $28 $c7 $c7 $c7 ; 0x13
	.db $e7 $00 $28 $c7 $c7 $c7

	.db $ef $f0 $00 $8f $8f $00 ; 0x14
	.db $e7 $00 $00 $c7 $c7 $c7

	.db $e7 $00 $00 $c7 $c7 $c7 ; 0x15
	.db $e7 $00 $00 $c7 $c7 $c7

	.db $ff $30 $00 $60 $07 $18 ; 0x16: farore's secret list
	.db $ff $30 $00 $60 $07 $c7

	.db $ef $00 $00 $90 $07 $00 ; 0x17: intro cinematic screen 1
	.db $e7 $00 $00 $90 $07 $c7

	.db $ef $98 $00 $68 $07 $40 ; 0x18
	.db $ef $98 $00 $68 $07 $c7

	.db $ef $00 $00 $90 $07 $30 ; 0x19
	.db $e7 $98 $00 $60 $07 $c7


.ifdef ENABLE_RING_REDUX
quickSwapHeldItems_body:
	ld hl,wInventoryStorage
	ld de,wInventoryB

.ifndef ONE_HANDED_BIGGORON_SWORD
	; if either the first or second items are the
	; biggorons sword, we need to swap both with it
	ld a,(hl)
	cp ITEM_BIGGORON_SWORD
	jp z,@swapToBiggoron

	inc l
	ld a,(hl)
	cp ITEM_BIGGORON_SWORD
	jp z,@swapToBiggoron
	dec l

	ld a,(de)
	cp ITEM_BIGGORON_SWORD
	jp z,@swapFromBiggoron
.endif
	call @swapItems
	inc de
	inc hl

@swapItems:
	ld a,(de)
	ld c,a
	ld a,(hl)
	ld (de),a
	ld (hl),c
	ret

.ifndef ONE_HANDED_BIGGORON_SWORD
@swapFromBiggoron:
	; swap with the overflowed item
	ld a,(wBiggoronSwordOverflowItem)
	inc e
	ld (de),a
	dec e
	xor a
	ld (wBiggoronSwordOverflowItem),a

	call @swapItems
	inc de
	inc hl
	call @swapItems
	ret

@swapToBiggoron:
	xor a
	ld (hl),a

	ld a,(wInventoryB)
	call @putItemInFirstBlankSlot

	ld a,(wInventoryA)
	call @putItemInFirstBlankSlot

	ld a,ITEM_BIGGORON_SWORD
	ld (de),a
	inc e
	ld (de),a
	ret
.endif

;;
; @param a Item to put in a blank slot
@putItemInFirstBlankSlot:
	or a
	ret z

	ld c,a
	ld l,<wInventoryStorage
-
	ld a,<wInventoryStorage+$10
	cp l
	jr nz,+
		; overflowing out of inventory.
		; put in overflow location
		ld a,c
		ld (wBiggoronSwordOverflowItem),a
		ret
	+
	ldi a,(hl)
	or a
	jr nz,-

	; clear this
	xor a
	ld (wBiggoronSwordOverflowItem),a

	dec l
	ld (hl),c
	ret
.endif

.ifdef REDUX_UTIL_FUNCS
;;
; Removes the specified ring from the players ring list and unequips it
;
; @param	b	The ring to remove
;
removeRing:
	push hl
	push bc
	ld a,b
	ld hl,wRingsObtained
	call unsetFlag
	ld a,b

	; remove from primary ring box
	ld hl,wRingBoxContents
	call @removeRingLoop

.ifdef EXTENDED_RING_BOX
	; remove from extended ring box
	ld hl,wRingBoxContentsExt
	call @removeRingLoop
.endif

.ifndef ENABLE_MULTI_RING
	; remove from active ring
	ld hl,(wActiveRing)
	cp (hl)
	jr nz,+
		ld (hl),$ff
	+
.endif
	pop bc
	pop hl
	ret

@removeRingLoop:
	ld b,$05
	-
		cp (hl)
		jr nz,+
			ld (hl),$ff
		+
		inc l
		dec b
		jr nz,-
	ret

.endif