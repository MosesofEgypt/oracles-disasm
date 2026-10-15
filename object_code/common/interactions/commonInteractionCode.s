;;
; Reloads the tiles for "price" on the item selection area when necessary.
checkReloadShopItemTiles:
	ld a,(wScrollMode)
	cp $02
	ret z

	ld hl,wInShop
	bit 2,(hl)
	ret z

	res 2,(hl)
	push de
	ld a,UNCMP_GFXH_11
	call loadUncompressedGfxHeader
	pop de
	ret


;;
; @param[out]	hl	Script to run if no shop items exist
; @param[out]	zflag	Set if at least one shop item exists
shopkeeperCheckAllItemsBought:
	ldhl FIRST_DYNAMIC_INTERACTION_INDEX, Interaction.enabled
---
	ld l,Interaction.enabled
	ldi a,(hl)
	or a
	jr z,@next
	ld a,(hl)
	cp INTERAC_SHOP_ITEM
	ret z
@next:
	inc h
	ld a,h
	cp LAST_INTERACTION_INDEX+1
	jr c,---

	ld hl,{SCRIPTS_1}.shopkeeperScript_boughtEverything
	or d
	ret

shopItemPrices:
	/* $00 */ .db RUPEEVAL_300
	/* $01 */ .db RUPEEVAL_010
.ifdef ENABLE_GASHA_REBALANCE
	/* $02 */ .db RUPEEVAL_050
.else
	/* $02 */ .db RUPEEVAL_300
.endif
	/* $03 */ .db RUPEEVAL_030
	/* $04 */ .db RUPEEVAL_020
.ifdef ROM_AGES
	/* $05 */ .db RUPEEVAL_300
.else
	/* $05 */ .db RUPEEVAL_200
.endif
.ifdef ENABLE_GASHA_REBALANCE
	/* $06 */ .db RUPEEVAL_050
.else
	/* $06 */ .db RUPEEVAL_500
.endif
	/* $07 */ .db RUPEEVAL_300
.ifdef ENABLE_GASHA_REBALANCE
	/* $08 */ .db RUPEEVAL_050
.else
	/* $08 */ .db RUPEEVAL_300
.endif
	/* $09 */ .db RUPEEVAL_300
.ifdef ENABLE_GASHA_REBALANCE
	/* $0a */ .db RUPEEVAL_050
.else
	/* $0a */ .db RUPEEVAL_300
.endif
	/* $0b */ .db RUPEEVAL_100
.ifdef ENABLE_NEW_GAME_PLUS
	; this is how much it costs for each charge you already have
	/* $0c */ .db RUPEEVAL_050
.else
	/* $0c */ .db RUPEEVAL_010
.endif
	/* $0d */ .db RUPEEVAL_150
.ifdef ENABLE_GASHA_REBALANCE
	/* $0e */ .db RUPEEVAL_050
.else
	/* $0e */ .db RUPEEVAL_100
.endif
	/* $0f */ .db RUPEEVAL_100
	/* $10 */ .db RUPEEVAL_100
	/* $11 */ .db RUPEEVAL_050
	/* $12 */ .db RUPEEVAL_080
	/* $13 */ .db RUPEEVAL_030
.ifdef ROM_AGES
	/* $14 */ .db RUPEEVAL_300
	/* $15 */ .db RUPEEVAL_500
.if MAX_RING_BOX_LEVEL > 3
	/* $16 */ .db RUPEEVAL_999
.endif
.endif