; In common folder because Ages has a stub

;;
; ITEM_FOOLS_ORE
itemCode1e:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw foolsOreRet

@state0:
.ifdef ENABLE_RING_REDUX
	; reset this
	xor a
	ld hl,wSwordBaseDamageCached
	ldi (hl),a
	ld (hl),a
.endif
.if defined(ROM_COMBO)
	ld a,UNCMP_GFXH_SEASONS_1f
	call wIsSeasons
	jr c,+
		ld a,UNCMP_GFXH_AGES_FOOLS_ORE
	+
.elif defined(ROM_AGES)
	ld a,UNCMP_GFXH_AGES_FOOLS_ORE
.else
	ld a,UNCMP_GFXH_SEASONS_1f
.endif
	call loadWeaponGfx
	call loadAttributesAndGraphicsAndIncState
	xor a
	call itemSetAnimation
	jp objectSetVisible82
