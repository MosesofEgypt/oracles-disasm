inventoryMenuState0_body:
	ld hl,wInventorySubmenu2CursorPos
	ld a,(hl)
	cp $08
	jr nc,+
	ld (hl),$00
+

	xor a
	ld (wInventorySubmenu),a
	ld (wInventory.cbba),a

	call loadCommonGraphics
.if defined(ROM_COMBO)
	ld a,GFXH_INVENTORY_SCREEN_SEASONS
	call wIsSeasons
	jr c,+
		ld a,GFXH_INVENTORY_SCREEN_AGES
	+
.else
	ld a,GFXH_INVENTORY_SCREEN
.endif
	call loadGfxHeader

.ifdef ENABLE_NEW_GAME_PLUS
	ld a,UNCMP_GFXH_LIFE_VIAL_INV
	call loadUncompressedGfxHeader
.endif
.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
.ifndef WIDE_INVENTORY_SPRITES
	ld a,UNCMP_GFXH_L4_SWORD_SHIELD
	call loadUncompressedGfxHeader
.endif
.endif

.ifdef WIDE_INVENTORY_SPRITES
	; load the wide item icons
	ld a,UNCMP_GFXH_ITEM_ICONS_WIDE
	call loadUncompressedGfxHeader
	call fixupWideItemGfx
.else
	; CROSSITEMS: Overwrite L-1 boomerang sprite with L-2 sprite if applicable. (This was
	; necessary due to VRAM limitations.)
	ld a,(wBoomerangLevel)
	cp $02
	jr nz,+
	ld a,UNCMP_GFXH_MAGIC_BOOMERANG_INV
	call loadUncompressedGfxHeader
+
	; Do the same with the hyper slingshot.
	ld a,(wSlingshotLevel)
	cp $02
	jr nz,+
	ld a,UNCMP_GFXH_HYPER_SLINGSHOT_INV
	call loadUncompressedGfxHeader
+
.endif

	ld a,UNCMP_GFXH_06
	call loadUncompressedGfxHeader
	ld a,PALH_0a
	call loadPaletteHeader
.if defined(ROM_COMBO)
	callab bank19.getNumUnappraisedRings
.else
	callab dataLoading.getNumUnappraisedRings
.endif
	callab bank2.func_02_55b2
	ld a,$01
	ld (wMenuActiveState),a
	call fastFadeinFromWhite
	ld a,$03
	jp loadGfxRegisterStateIndex

.ifdef WIDE_INVENTORY_SPRITES
fixupWideItemGfx:
	push hl
	push bc
	ld hl,itemGfxIconFixupInfo
	-
		ld b,>wc600Block
		ldi a,(hl)
		ld c,a

		; increment the level if necessary
		cp <wSwordLevel
		jr z,+
			cp <wShieldLevel
		+

		; get the item level\subid
		ld a,(bc)
		.ifdef ENABLE_RING_REDUX
			call z,victoryRingIncLevel
		.endif
		ld c,a

		push hl
		rst_derefHl
		ldi a,(hl)
		ld b,a
		ld a,c
		cp b
		jr c,+
			ld a,b
		+
		rst_addAToHl

		; get the gfx header to load and load it
		ld a,(hl)
		call loadUncompressedGfxHeader
		pop hl
		inc hl
		inc hl

		ld a,(hl)
		or a
		jr nz,-

	pop bc
	pop hl
	jp fixupWideItemGfx_harpOfAges

itemGfxIconFixupInfo:
    .db <wBoomerangLevel
    .dw @itemGfxHeadersBySubid_boomerang

    .db <wBraceletLevel
    .dw @itemGfxHeadersBySubid_bracelet

    .db <wFeatherLevel
    .dw @itemGfxHeadersBySubid_feather

    .db <wMagnetGlovePolarity
    .dw @itemGfxHeadersBySubid_magnetGlove

    .db <wSwitchHookLevel
    .dw @itemGfxHeadersBySubid_switchHook

    .db <wSwordLevel
    .dw @itemGfxHeadersBySubid_sword

    .db <wShieldLevel
    .dw @itemGfxHeadersBySubid_shield

    .db <wFluteIcon
    .dw @itemGfxHeadersBySubid_flutePartners

	.db $00; terminator

@itemGfxHeadersBySubid_boomerang:
	.db $02
	.db UNCMP_GFXH_ITEM_ICONS_BOOMERANG_L1
	.db UNCMP_GFXH_ITEM_ICONS_BOOMERANG_L1
	.db UNCMP_GFXH_ITEM_ICONS_BOOMERANG_L2

@itemGfxHeadersBySubid_bracelet:
	.db $02
	.db UNCMP_GFXH_ITEM_ICONS_BRACELET_L1
	.db UNCMP_GFXH_ITEM_ICONS_BRACELET_L1
	.db UNCMP_GFXH_ITEM_ICONS_BRACELET_L2

@itemGfxHeadersBySubid_feather:
	.db $02
	.db UNCMP_GFXH_ITEM_ICONS_FEATHER_L1
	.db UNCMP_GFXH_ITEM_ICONS_FEATHER_L1
	.db UNCMP_GFXH_ITEM_ICONS_FEATHER_L2

@itemGfxHeadersBySubid_magnetGlove:
	.db $01
	.db UNCMP_GFXH_ITEM_ICONS_MAGNET_GLOVE_S
	.db UNCMP_GFXH_ITEM_ICONS_MAGNET_GLOVE_N

@itemGfxHeadersBySubid_switchHook:
	.db $02
	.db UNCMP_GFXH_ITEM_ICONS_SWITCH_HOOK_L1
	.db UNCMP_GFXH_ITEM_ICONS_SWITCH_HOOK_L1
	.db UNCMP_GFXH_ITEM_ICONS_SWITCH_HOOK_L2

@itemGfxHeadersBySubid_sword:
.ifdef ENABLE_NEW_GAME_PLUS
	.db $04
.else
	.db $03
.endif
	.db UNCMP_GFXH_ITEM_ICONS_SWORD_L1
	.db UNCMP_GFXH_ITEM_ICONS_SWORD_L1
	.db UNCMP_GFXH_ITEM_ICONS_SWORD_L2
	.db UNCMP_GFXH_ITEM_ICONS_SWORD_L3
.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
	.db UNCMP_GFXH_ITEM_ICONS_SWORD_L4
.endif

@itemGfxHeadersBySubid_shield:
.ifdef ENABLE_NEW_GAME_PLUS
	.db $04
.else
	.db $03
.endif
	.db UNCMP_GFXH_ITEM_ICONS_SHIELD_L1
	.db UNCMP_GFXH_ITEM_ICONS_SHIELD_L1
	.db UNCMP_GFXH_ITEM_ICONS_SHIELD_L2
	.db UNCMP_GFXH_ITEM_ICONS_SHIELD_L3
.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
	.db UNCMP_GFXH_ITEM_ICONS_SHIELD_L4
.endif

@itemGfxHeadersBySubid_flutePartners:
	.db $04
	.db UNCMP_GFXH_ITEM_ICONS_FLUTE_NONE
	.db UNCMP_GFXH_ITEM_ICONS_FLUTE_RICKY
	.db UNCMP_GFXH_ITEM_ICONS_FLUTE_DIMITRI
	.db UNCMP_GFXH_ITEM_ICONS_FLUTE_MOOSH


fixupWideItemGfx_harpOfAges:
	push hl
    ld a,(wSelectedHarpSong)
	and $03
    ld hl,@itemGfxHeadersBySubid_harpTunes
	rst_addAToHl
	ld a,(hl)
	call loadUncompressedGfxHeader
	pop hl
	ret

@itemGfxHeadersBySubid_harpTunes:
	.db UNCMP_GFXH_ITEM_ICONS_NO_TUNE
	.db UNCMP_GFXH_ITEM_ICONS_TUNE_OF_ECHOES
	.db UNCMP_GFXH_ITEM_ICONS_TUNE_OF_CURRENTS
	.db UNCMP_GFXH_ITEM_ICONS_TUNE_OF_AGES

.endif