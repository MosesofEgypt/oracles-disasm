; ITEM_ROD_OF_SEASONS
itemCode07:
	call itemTransferKnockbackToLink
	ld e,Object.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
.ifdef ENABLE_RING_REDUX
	; reset this
	xor a
	ld hl,wSwordBaseDamageCached
	ldi (hl),a
	ld (hl),a
.endif
	ld a,$01
	ld (de),a
	ld h,d
	ld l,Item.enabled
	ld (hl),$03
	ld l,Item.counter1
	ld (hl),$10
	ld a,SND_SWORDSLASH
	call playSound
.if defined(ROM_COMBO)
	ld a,UNCMP_GFXH_SEASONS_1c
	call wIsSeasons
	jr c,+
		ld a,UNCMP_GFXH_AGES_ROD_OF_SEASONS
	+
.elif defined(ROM_AGES)
	ld a,UNCMP_GFXH_AGES_ROD_OF_SEASONS
.else
	ld a,UNCMP_GFXH_SEASONS_1c
.endif
	call loadWeaponGfx
	call itemLoadAttributesAndGraphics
	jp objectSetVisible82

@state1:
.if defined(ROM_AGES) && !defined(ROM_COMBO)
	ret
.endif
.if defined(ROM_SEASONS) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	call wIsSeasons
	ret nc
.endif
	ld h,d
	ld l,Item.counter1
	dec (hl)
	ret nz
	ld a,(wActiveTileType)
	cp TILETYPE_STUMP
	ret nz
	call getFreeInteractionSlot
	ret nz
	ld (hl),INTERAC_USED_ROD_OF_SEASONS
	ld e,Item.angle
	ld l,Interaction.angle
	ld a,(de)
	ldi (hl),a
	jp objectCopyPosition
.endif
