;;
; ITEM_SWORD
itemCode05:
	call itemTransferKnockbackToLink
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

@swordSounds:
	.db SND_SWORDSLASH
	.db SND_SWISH
	.db SND_BOOMERANG
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH
	.db SND_SWISH
	.db SND_SWORDSLASH
	.db SND_SWORDSLASH


@state0:
.ifdef ENABLE_RING_REDUX
	; reset this
	xor a
	ld (wSwordDamageCached),a
.endif
	ld a,UNCMP_GFXH_1a
	call loadWeaponGfx

	; Play a random sound
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@swordSounds
	rst_addAToHl
	ld a,(hl)
	call playSound

	ld e,Item.var31
	xor a
	ld (de),a


; State 6: partial re-initialization?
@state6:
	call loadAttributesAndGraphicsAndIncState

	; Load collisiontype and damage
	ld a,(wSwordLevel)

.ifdef ENABLE_RING_REDUX
	call victoryRingIncLevel
.endif

	ld hl,@swordLevelData-2
	rst_addDoubleIndex

	ld e,Item.collisionType
	ldi a,(hl)
	ld (de),a
	ld c,(hl)
.ifdef ENABLE_NEW_GAME_PLUS
	; in NG+2 and higher, sword does 1 less damage
	call getNewGamePlusCycle
	cp $02
	jr c,+
		inc c
	+
.endif

	; If var31 was nonzero, skip whimsical ring check?
	ld e,Item.var31
	ld a,(de)
	or a
	ld a,c
	ld (de),a
.ifndef ENABLE_RING_REDUX
	jr nz,@@setDamage

	; Whimsical ring: usually 1 damage, with a 1/256 chance of doing 12 damage
	isRingEquipped WHIMSICAL_RING
	jr nz,@@setDamage
	call getRandomNumber
	or a
	ld c,-1
	jr nz,@@setDamage
	ld a,SND_LIGHTNING
	call playSound
	ld c,-12
.endif

@@setDamage:
	ld e,Item.var3a
	ld a,c
	ld (de),a

	ld e,Item.state
	ld a,$01
	ld (de),a

	; don't change rendering mode if this as a plunging attack
	ld a,(w1ParentItem2.var2f)
	bit 1,a
	ret nz

	jp objectSetVisible82

; b0: collisionType
; b1: base damage
@swordLevelData:
	; L-1
	.db ($80|ITEMCOLLISION_L1_SWORD)
	.db (-2)

	; L-2
	.db ($80|ITEMCOLLISION_L2_SWORD)
	.db (-3)

	; L-3
	.db ($80|ITEMCOLLISION_L3_SWORD)
	.db (-5)

.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
	; L-4
	.db ($80|ITEMCOLLISION_L3_SWORD)
	.db (-6)
.endif


; State 8: downstabbing shockwave
@state8:
	; prevent link from being knocked back
	xor a
	ld (w1Link.knockbackCounter),a

	; change the swords damage type to a weak shield bump to
	; act as a shockwave for knocking away nearby enemies
	ld a,$80|ITEMCOLLISION_L1_SHIELD
	jr +

; State 9: downstabbing recoil
@state9:
	; prevent link from being knocked back
	xor a
	ld (w1Link.knockbackCounter),a
	jr +

; State 7: downstabbing
@state7:
; State 4: swordspinning
@state4:
	ld a,$80|ITEMCOLLISION_SWORDSPIN
	+
	ld e,Item.collisionType
	ld (de),a


; State 1: being swung
@state1:
	ld h,d
	ld l,Item.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
	ret


; State 2: charging
@state2:
	ld e,Item.var31
	ld a,(de)
	ld e,Item.var3a
	ld (de),a

.ifdef ENABLE_RING_REDUX
@trySteadfastDashBreakTile:
	ld a,(wOptimizationFlags)
	bit 5,a
	ret z
	ld a,(w1Link.direction)
	add a
	jp tryBreakTileWithSword_calculateLevel
.else
	ret
.endif


; State 3: sword fully charged, flashing
@state3:
	ld h,d
	ld l,Item.counter1
	inc (hl)
	bit 2,(hl)
	ld l,Item.oamFlagsBackup
	ldi a,(hl)
	jr nz,+
	ld a,$0d
+
	ld (hl),a
.ifdef ENABLE_RING_REDUX
	jr @trySteadfastDashBreakTile
.else
	ret
.endif


; State 5: end of swordspin
@state5:
	; Try to break tile at Link's feet, then delete self
	ld a,$08
	call tryBreakTileWithSword_calculateLevel
	jp itemDelete
