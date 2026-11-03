; See data/ages/uncmpGfxHeaders.s for documentation.

.redefine NUM_UNCMP_GFX_HEADERS $36

.if defined(ROM_COMBO)
uncmpGfxHeaderTable_seasons:
.else
uncmpGfxHeaderTable:
.endif
	.repeat NUM_UNCMP_GFX_HEADERS index COUNT
		.dw @uncmpGfxHeader{%.2x{COUNT}}
	.endr

.if defined(ROM_COMBO)
	; NOTE: including these to ensure header enums match between games
	.repeat $40-$36 index COUNT
		.dw @uncmpGfxHeader35
	.endr
.endif

.ifndef WIDE_INVENTORY_SPRITES
	; CROSSITEMS: Extra gfx headers appended to the end of the table (starting at $36)
	.dw @uncmpGfxHeader_magicBoomerangInv
	.dw @uncmpGfxHeader_hyperSlingshotInv
.endif
	.dw @uncmpGfxHeader_caneOfSomaria
	.dw @uncmpGfxHeader_switchHook
	.dw @uncmpGfxHeader_seedShooter

.if defined(ROM_COMBO)
	; NOTE: including these to ensure header enums match between games
	.dw @uncmpGfxHeader_seedShooter
	.dw @uncmpGfxHeader_seedShooter
	.dw @uncmpGfxHeader_seedShooter
	.dw @uncmpGfxHeader_seedShooter
	.dw @uncmpGfxHeader_seedShooter
	.dw @uncmpGfxHeader_seedShooter
.endif

.ifdef WIDE_INVENTORY_SPRITES
	.dw @uncmpGfxHeader_biggoronSwordVertical
	.dw @uncmpGfxHeader_biggoronSwordHorizontal
	.dw @uncmpGfxHeader_itemIconsEquipped
	.dw @uncmpGfxHeader_itemIconsWide
	.dw @uncmpGfxHeader_boomerang
	.dw @uncmpGfxHeader_magicBoomerang
	.dw @uncmpGfxHeader_bracelet
	.dw @uncmpGfxHeader_powerGlove
	.dw @uncmpGfxHeader_feather
	.dw @uncmpGfxHeader_rocsCape
	.dw @uncmpGfxHeader_magnetGlovesSouth
	.dw @uncmpGfxHeader_magnetGlovesNorth
	.dw @uncmpGfxHeader_switchHookL1
	.dw @uncmpGfxHeader_switchHookL2
	.dw @uncmpGfxHeader_swordL1
	.dw @uncmpGfxHeader_swordL2
	.dw @uncmpGfxHeader_swordL3
.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
	.dw @uncmpGfxHeader_swordL4
.endif
	.dw @uncmpGfxHeader_shieldL1
	.dw @uncmpGfxHeader_shieldL2
	.dw @uncmpGfxHeader_shieldL3
.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
	.dw @uncmpGfxHeader_shieldL4
.endif
	.dw @uncmpGfxHeader_noTune
	.dw @uncmpGfxHeader_tuneOfEchoes
	.dw @uncmpGfxHeader_tuneOfCurrents
	.dw @uncmpGfxHeader_tuneOfAges
	.dw @uncmpGfxHeader_fluteNone
	.dw @uncmpGfxHeader_fluteRicky
	.dw @uncmpGfxHeader_fluteDimitri
	.dw @uncmpGfxHeader_fluteMoosh
.endif
.ifdef ENABLE_NEW_GAME_PLUS
	.dw @uncmpGfxHeader_lifeVialInv
.endif
.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
	.dw @uncmpGfxHeader_swordShieldInv
.endif
.ifdef ENABLE_SETTINGS_MENU
	.dw @uncmpGfxHeader_inventorySubscreen4GfxRevert
	.dw @uncmpGfxHeader_inventorySubscreen4Page0Gfx
	.dw @uncmpGfxHeader_inventorySubscreen4Page1Gfx
	.dw @uncmpGfxHeader_inventorySubscreen4Page2Gfx
	.dw @uncmpGfxHeader_inventorySubscreen4Page3Gfx
	.dw @uncmpGfxHeader_inventorySubscreen4Page4Gfx
.endif


@uncmpGfxHeader00:

@uncmpGfxHeader01:
	m_GfxHeaderRam w4TileMap, VRAM_1_TILEDATA_0+$600, $1a
	m_GfxHeaderEnd

@uncmpGfxHeader02:
	m_GfxHeaderRam w4ItemIconGfx, VRAM_1_TILEDATA_0+$780, $08
	; Fall through

@uncmpGfxHeader03:
	m_GfxHeaderRam w4StatusBarAttributeMap, VRAM_1_TILEMAP_1+$3c0, $04
	m_GfxHeaderRam w4StatusBarTileMap,      VRAM_0_TILEMAP_1+$3c0, $04
	m_GfxHeaderEnd

@uncmpGfxHeader04:
	m_GfxHeaderRam w4AttributeMap+$40, VRAM_1_TILEMAP_0, $1a
	m_GfxHeaderRam w4TileMap+$40,      VRAM_0_TILEMAP_0, $1a
	m_GfxHeaderEnd

@uncmpGfxHeader05:
	m_GfxHeaderRam w4AttributeMap+$40, VRAM_1_TILEMAP_1, $1a
	m_GfxHeaderRam w4TileMap+$40,      VRAM_0_TILEMAP_1, $1a
	m_GfxHeaderEnd

@uncmpGfxHeader06:
	m_GfxHeaderRam w4AttributeMap+$40, VRAM_1_TILEMAP_0, $20
	m_GfxHeaderRam w4TileMap+$40,      VRAM_0_TILEMAP_0, $20
	m_GfxHeaderEnd

@uncmpGfxHeader07:
	m_GfxHeaderRam w4GfxBuf1, VRAM_1_TILEDATA_1+$400, $30
	m_GfxHeaderEnd

@uncmpGfxHeader08:
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_1, $24
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_1, $24
	m_GfxHeaderEnd

@uncmpGfxHeader09:
	m_GfxHeaderRam w4TileMap, VRAM_0_TILEDATA_0, $60
	m_GfxHeaderEnd

@uncmpGfxHeader0a:
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_0, $2c
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_0, $2c
	m_GfxHeaderEnd

@uncmpGfxHeader0b:
	m_GfxHeaderRam w5NameEntryCharacterGfx, VRAM_0_TILEDATA_1, $80
	m_GfxHeaderEnd

@uncmpGfxHeader0c:
	m_GfxHeaderRam w5NameEntryCharacterGfx, VRAM_1_TILEDATA_0+$600, $20
	m_GfxHeaderEnd

@uncmpGfxHeader0d:
	m_GfxHeaderRam w4TileMap+$140,      VRAM_0_TILEMAP_1+$2a0, $16
	m_GfxHeaderRam w4AttributeMap+$140, VRAM_1_TILEMAP_1+$2a0, $16
	m_GfxHeaderEnd

@uncmpGfxHeader0e:
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0, $2c
	m_GfxHeaderRam w3VramTiles, VRAM_0_TILEMAP_0, $2c
	m_GfxHeaderEnd

@uncmpGfxHeader0f:
	m_GfxHeaderRam w3VramTiles, VRAM_0_TILEMAP_0, $20
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0, $20
	m_GfxHeaderEnd

@uncmpGfxHeader10:
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0, $2c
	m_GfxHeaderRam w3VramTiles, VRAM_0_TILEMAP_0, $2c
	m_GfxHeaderEnd

@uncmpGfxHeader11:
	m_GfxHeaderRam w3TileMappingIndices+$60, VRAM_1_TILEMAP_0+$060, $02
	m_GfxHeaderRam w3VramTiles+$60,          VRAM_0_TILEMAP_0+$060, $02
	m_GfxHeaderEnd

@uncmpGfxHeader12:
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_0, $24
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_0, $24
	m_GfxHeaderEnd

@uncmpGfxHeader13:
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_0, $20
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_0, $20
	m_GfxHeaderRam w4AttributeMap+$200, VRAM_1_TILEMAP_0+$3c0, $04
	m_GfxHeaderRam w4TileMap+$200,      VRAM_0_TILEMAP_0+$3c0, $04
	m_GfxHeaderEnd

@uncmpGfxHeader14:
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_1, $24
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_1, $24
	m_GfxHeaderEnd

@uncmpGfxHeader15:
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_1, $10
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_1, $10
	m_GfxHeaderRam w4TileMap+$100,      VRAM_0_TILEMAP_0+$100, $02
	m_GfxHeaderRam w4AttributeMap+$200, VRAM_1_TILEMAP_0+$3c0, $04
	m_GfxHeaderRam w4TileMap+$200,      VRAM_0_TILEMAP_0+$3c0, $04
	m_GfxHeaderEnd

@uncmpGfxHeader16:
	m_GfxHeaderRam w4StatusBarTileMap,      VRAM_0_TILEMAP_1+$1c0, $0a
	m_GfxHeaderRam w4StatusBarAttributeMap, VRAM_1_TILEMAP_1+$1c0, $0a
	m_GfxHeaderEnd

@uncmpGfxHeader17:
	m_GfxHeaderRam w7TextGfxBuffer, VRAM_1_TILEDATA_2+$200, $20
	m_GfxHeaderEnd

@uncmpGfxHeader18:
	m_GfxHeader spr_boomerang, VRAM_1_TILEDATA_0+$4e0, $04
	m_GfxHeaderEnd

@uncmpGfxHeader19:
	m_GfxHeader spr_boomerang, VRAM_1_TILEDATA_0+$4e0, $04, $40
	m_GfxHeaderEnd

@uncmpGfxHeader1a:
	m_GfxHeader spr_swords, VRAM_1_TILEDATA_0+$520, $0a
	m_GfxHeaderEnd

@uncmpGfxHeader1b:
.if defined(ENABLE_ALT_BIGGORON_SPRITES)
	m_GfxHeader spr_biggoron_sword_item_alt, VRAM_1_TILEDATA_0+$560, $06, $40
.elif defined(WIDE_INVENTORY_SPRITES)
	m_GfxHeader spr_swords, VRAM_1_TILEDATA_0+$560, $06, $e0
.else
	m_GfxHeader spr_swords, VRAM_1_TILEDATA_0+$520, $0e, $a0
.endif
	m_GfxHeaderEnd

@uncmpGfxHeader1c:
	m_GfxHeader spr_rod_of_seasons, VRAM_1_TILEDATA_0+$520
	m_GfxHeaderEnd

@uncmpGfxHeader1d:
	m_GfxHeader spr_slingshot, VRAM_1_TILEDATA_0+$520
	m_GfxHeaderEnd

@uncmpGfxHeader1e:
	m_GfxHeader spr_magnet_gloves, VRAM_1_TILEDATA_0+$520
	m_GfxHeaderEnd

@uncmpGfxHeader1f:
	m_GfxHeader spr_item_icons_2, VRAM_1_TILEDATA_0+$520, $02, $140
	m_GfxHeaderEnd

@uncmpGfxHeader20:
	m_GfxHeaderRam w7d800, VRAM_0_TILEDATA_2+$200, $10
	m_GfxHeaderEnd

@uncmpGfxHeader21:
	m_GfxHeaderRam w7d800+$100, VRAM_0_TILEDATA_2+$200, $10
	m_GfxHeaderEnd

@uncmpGfxHeader22:
	m_GfxHeaderRam w7d800+$200, VRAM_0_TILEDATA_2+$240, $0b
	m_GfxHeaderEnd

@uncmpGfxHeader23:
	m_GfxHeaderRam w7d800+$2b0, VRAM_0_TILEDATA_2+$240, $0a
	m_GfxHeaderEnd

@uncmpGfxHeader24:
	m_GfxHeaderRam w7d800+$350, VRAM_0_TILEDATA_2+$240, $06
	m_GfxHeaderEnd

@uncmpGfxHeader25:
	m_GfxHeaderRam w7d800+$3b0, VRAM_0_TILEDATA_2+$240, $04
	m_GfxHeaderEnd

@uncmpGfxHeader26:
	m_GfxHeaderRam w7d800+$3f0, VRAM_0_TILEDATA_2+$240, $04
	m_GfxHeaderEnd

@uncmpGfxHeader27:
@uncmpGfxHeader28:
	m_GfxHeaderRam w7d800+$430, VRAM_0_TILEDATA_2+$240, $02
	m_GfxHeaderEnd

@uncmpGfxHeader29:
	m_GfxHeaderRam w7d800+$450, VRAM_0_TILEDATA_2+$200, $04
	m_GfxHeaderEnd

@uncmpGfxHeader2a:
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_1+$160, $16
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_1+$160, $16
	m_GfxHeaderEnd

@uncmpGfxHeader2b:
	m_GfxHeaderRam w7d800,               VRAM_1_TILEDATA_1+$400, $30
	m_GfxHeaderRam w3VramTiles,          VRAM_0_TILEMAP_0, $2c
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0, $2c
	m_GfxHeaderEnd

@uncmpGfxHeader2c:
	m_GfxHeaderRam w4TileMap,      VRAM_0_TILEMAP_0, $0c
	m_GfxHeaderRam w4AttributeMap, VRAM_1_TILEMAP_0, $0c
	m_GfxHeaderEnd

@uncmpGfxHeader2d:
	m_GfxHeaderRam w3VramTiles,          VRAM_0_TILEMAP_0+$040, $20
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0+$040, $20
	m_GfxHeaderEnd

@uncmpGfxHeader2e:
	m_GfxHeaderRam w3VramTiles,          VRAM_0_TILEMAP_0+$0c0, $14
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0+$0c0, $14
	m_GfxHeaderEnd

@uncmpGfxHeader2f:
	m_GfxHeaderRam w3VramTiles+$140,          VRAM_0_TILEMAP_0+$200, $0e
	m_GfxHeaderRam w3TileMappingIndices+$140, VRAM_1_TILEMAP_0+$200, $0e
	m_GfxHeaderEnd

@uncmpGfxHeader30:
	m_GfxHeaderRam w6d3c0, VRAM_0_TILEMAP_1+$360, $04
	m_GfxHeaderRam w6d7c0, VRAM_1_TILEMAP_1+$360, $04
	m_GfxHeaderEnd

@uncmpGfxHeader31:
	m_GfxHeaderRam w3VramTiles,          VRAM_0_TILEMAP_0+$060, $20
	m_GfxHeaderRam w3TileMappingIndices, VRAM_1_TILEMAP_0+$060, $20
	m_GfxHeaderEnd

@uncmpGfxHeader32:
	m_GfxHeaderRam w2TmpGfxBuffer, VRAM_0_TILEDATA_0+$200, $20
	m_GfxHeaderEnd

@uncmpGfxHeader33:
	m_GfxHeaderRam w2TmpGfxBuffer, VRAM_0_TILEDATA_0+$400, $20
	m_GfxHeaderEnd

@uncmpGfxHeader34:
@uncmpGfxHeader35:
	m_GfxHeaderRam w7d800, VRAM_0_TILEDATA_0+$300, $30
	m_GfxHeaderEnd


.ifdef WIDE_INVENTORY_SPRITES
@uncmpGfxHeader_biggoronSwordVertical:
.if defined(ENABLE_ALT_BIGGORON_SPRITES)
	m_GfxHeader spr_biggoron_sword_item_alt, VRAM_1_TILEDATA_0+$520, $04, $a0
.else
	m_GfxHeader spr_swords, VRAM_1_TILEDATA_0+$520, $04, $140
.endif
	m_GfxHeaderEnd

@uncmpGfxHeader_biggoronSwordHorizontal:
.if defined(ENABLE_ALT_BIGGORON_SPRITES)
	m_GfxHeader spr_biggoron_sword_item_alt, VRAM_1_TILEDATA_0+$520, $04, $00
.else
	m_GfxHeader spr_swords, VRAM_1_TILEDATA_0+$520, $04, $a0
.endif
	m_GfxHeaderEnd

@uncmpGfxHeader_itemIconsEquipped:
	m_GfxHeaderRam w4ItemIconGfxExt, VRAM_1_TILEDATA_0+$5c0, $04
	m_GfxHeaderEnd

@uncmpGfxHeader_itemIconsWide:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0
	m_GfxHeader gfx_item_icons_wide_fixup_tiles, VRAM_0_TILEDATA_0+$7e0
	m_GfxHeader spr_item_icons_wide_seeds_sprite, VRAM_0_TILEDATA_1+$160
	m_GfxHeader spr_item_icons_song_sprites, VRAM_0_TILEDATA_0+$1c0, $04
	m_GfxHeader spr_item_icons_song_sprites, VRAM_0_TILEDATA_0+$2c0, $04, $40
	m_GfxHeader spr_item_icons_song_sprites, VRAM_0_TILEDATA_0+$5a0, $04, $80
.if   defined(ENABLE_ALT_BIGGORON_SPRITES) && defined(ULTRAWIDE_INVENTORY_SPRITES)
	m_GfxHeader gfx_biggoron_sword_alt_large, VRAM_1_TILEDATA_0+$280, $08, $00
.elif defined(ENABLE_ALT_BIGGORON_SPRITES)
	m_GfxHeader gfx_biggoron_sword_alt, VRAM_1_TILEDATA_0+$280, $08, $00
.elif defined(ULTRAWIDE_INVENTORY_SPRITES)
	m_GfxHeader gfx_biggoron_sword_large, VRAM_1_TILEDATA_0+$280, $08, $00
.endif
	m_GfxHeaderEnd

; overwrite item icons with their higher level variants
@uncmpGfxHeader_boomerang:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$240, $04, $240
	m_GfxHeaderEnd

@uncmpGfxHeader_magicBoomerang:
	m_GfxHeader spr_item_icons_wide_boomerang_l2, VRAM_1_TILEDATA_0+$240
	m_GfxHeaderEnd

@uncmpGfxHeader_bracelet:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$0c0, $04, $c0
	m_GfxHeaderEnd

@uncmpGfxHeader_powerGlove:
	m_GfxHeader spr_item_icons_wide_bracelet_l2, VRAM_1_TILEDATA_0+$0c0
	m_GfxHeaderEnd

@uncmpGfxHeader_feather:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$080, $04, $80
	m_GfxHeaderEnd

@uncmpGfxHeader_rocsCape:
	m_GfxHeader spr_item_icons_wide_feather_l2, VRAM_1_TILEDATA_0+$080
	m_GfxHeaderEnd

@uncmpGfxHeader_magnetGlovesSouth:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$320, $04, $320
	m_GfxHeaderEnd

@uncmpGfxHeader_magnetGlovesNorth:
	m_GfxHeader spr_item_icons_wide_magnet_glove_n, VRAM_1_TILEDATA_0+$320
	m_GfxHeaderEnd

@uncmpGfxHeader_switchHookL1:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$200, $04, $200
	m_GfxHeaderEnd

@uncmpGfxHeader_switchHookL2:
	m_GfxHeader spr_item_icons_wide_switch_hook_l2, VRAM_1_TILEDATA_0+$200
	m_GfxHeaderEnd

@uncmpGfxHeader_swordL1:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0, $04
	m_GfxHeaderEnd

@uncmpGfxHeader_shieldL1:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$040, $04, $40
	m_GfxHeaderEnd

@uncmpGfxHeader_swordL2:
	m_GfxHeader spr_item_icons_wide_sword_l2, VRAM_1_TILEDATA_0
	m_GfxHeaderEnd

@uncmpGfxHeader_shieldL2:
	m_GfxHeader spr_item_icons_wide_shield_l2, VRAM_1_TILEDATA_0+$040
	m_GfxHeaderEnd

@uncmpGfxHeader_swordL3:
	m_GfxHeader spr_item_icons_wide_sword_l3, VRAM_1_TILEDATA_0
	m_GfxHeaderEnd

@uncmpGfxHeader_shieldL3:
	m_GfxHeader spr_item_icons_wide_shield_l3, VRAM_1_TILEDATA_0+$040
	m_GfxHeaderEnd

@uncmpGfxHeader_noTune:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$580, $04, $560
	m_GfxHeaderEnd

@uncmpGfxHeader_tuneOfEchoes:
	m_GfxHeader spr_item_icons_wide_songs, VRAM_1_TILEDATA_0+$580, $04, $80
	m_GfxHeaderEnd

@uncmpGfxHeader_tuneOfCurrents:
	m_GfxHeader spr_item_icons_wide_songs, VRAM_1_TILEDATA_0+$580, $04, $40
	m_GfxHeaderEnd

@uncmpGfxHeader_tuneOfAges:
	m_GfxHeader spr_item_icons_wide_songs, VRAM_1_TILEDATA_0+$580, $04
	m_GfxHeaderEnd

@uncmpGfxHeader_fluteNone:
	m_GfxHeader spr_item_icons_wide, VRAM_1_TILEDATA_0+$460, $02, $460
	m_GfxHeaderEnd

@uncmpGfxHeader_fluteRicky:
	m_GfxHeader spr_item_icons_wide_flute_partners, VRAM_1_TILEDATA_0+$460, $02
	m_GfxHeaderEnd

@uncmpGfxHeader_fluteDimitri:
	m_GfxHeader spr_item_icons_wide_flute_partners, VRAM_1_TILEDATA_0+$460, $02, $20
	m_GfxHeaderEnd

@uncmpGfxHeader_fluteMoosh:
	m_GfxHeader spr_item_icons_wide_flute_partners, VRAM_1_TILEDATA_0+$460, $02, $40
	m_GfxHeaderEnd
.else

; CROSSITEMS: Magical boomerang overwriting L-1 boomerang for inventory gfx
@uncmpGfxHeader_magicBoomerangInv:
	m_GfxHeader spr_boomerang, VRAM_1_TILEDATA_0+$380, $02, $40
	m_GfxHeaderEnd

; Hyper slingshot overwriting L-1 slingshot for inventory gfx
@uncmpGfxHeader_hyperSlingshotInv:
	m_GfxHeader spr_hyperslingshot_inventory, VRAM_1_TILEDATA_0+$020
	m_GfxHeaderEnd
.endif

@uncmpGfxHeader_caneOfSomaria:
	m_GfxHeader spr_cane_of_somaria, VRAM_1_TILEDATA_0+$520
	m_GfxHeaderEnd

@uncmpGfxHeader_switchHook:
	m_GfxHeader spr_switch_hook, VRAM_1_TILEDATA_0+$520
	m_GfxHeaderEnd

@uncmpGfxHeader_seedShooter:
	m_GfxHeader spr_seed_shooter, VRAM_1_TILEDATA_0+$520
	m_GfxHeaderEnd

.ifdef ENABLE_NEW_GAME_PLUS
@uncmpGfxHeader_lifeVialInv:
.ifdef WIDE_INVENTORY_SPRITES
	m_GfxHeader spr_item_icons_life_vial, VRAM_1_TILEDATA_0+$720
.else
	m_GfxHeader spr_item_icons_life_vial_slim, VRAM_1_TILEDATA_0+$720
.endif
	m_GfxHeaderEnd
.endif

.if defined(ENABLE_RING_REDUX) || defined(ROM_COMBO)
@uncmpGfxHeader_swordShieldInv:
	m_GfxHeader spr_item_icons_sword_shield_l4, VRAM_0_TILEDATA_1+$100
	m_GfxHeaderEnd

.if defined(WIDE_INVENTORY_SPRITES)
@uncmpGfxHeader_swordL4:
	m_GfxHeader spr_item_icons_wide_sword_l4, VRAM_1_TILEDATA_0
	m_GfxHeaderEnd

@uncmpGfxHeader_shieldL4:
	m_GfxHeader spr_item_icons_wide_shield_l4, VRAM_1_TILEDATA_0+$040
	m_GfxHeaderEnd
.endif
.endif

.ifdef ENABLE_SETTINGS_MENU
@uncmpGfxHeader_inventorySubscreen4GfxRevert:
	m_GfxHeader gfx_rings_uncomp, VRAM_0_TILEDATA_1+$200
	m_GfxHeaderEnd

@uncmpGfxHeader_inventorySubscreen4Page0Gfx:
	m_GfxHeader gfx_settings_text_page_0, VRAM_0_TILEDATA_1+$200
	m_GfxHeaderEnd

@uncmpGfxHeader_inventorySubscreen4Page1Gfx:
	m_GfxHeader gfx_settings_text_page_1, VRAM_0_TILEDATA_1+$200
	m_GfxHeaderEnd

@uncmpGfxHeader_inventorySubscreen4Page2Gfx:
	m_GfxHeader gfx_settings_text_page_2, VRAM_0_TILEDATA_1+$200
	m_GfxHeaderEnd

@uncmpGfxHeader_inventorySubscreen4Page3Gfx:
	m_GfxHeader gfx_settings_text_page_3, VRAM_0_TILEDATA_1+$200
	m_GfxHeaderEnd

@uncmpGfxHeader_inventorySubscreen4Page4Gfx:
	m_GfxHeader gfx_settings_text_page_4, VRAM_0_TILEDATA_1+$200
	m_GfxHeaderEnd
.endif