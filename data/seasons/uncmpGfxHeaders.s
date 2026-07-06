; See data/ages/uncmpGfxHeaders.s for documentation.

.define NUM_UNCMP_GFX_HEADERS $36

uncmpGfxHeaderTable:
	.repeat NUM_UNCMP_GFX_HEADERS index COUNT
		.dw uncmpGfxHeader{%.2x{COUNT}}
	.endr

.ifndef WIDE_INVENTORY_SPRITES
	; CROSSITEMS: Extra gfx headers appended to the end of the table (starting at $36)
	.dw uncmpGfxHeader_magicBoomerangInv
	.dw uncmpGfxHeader_hyperSlingshotInv
.endif
	.dw uncmpGfxHeader_caneOfSomaria
	.dw uncmpGfxHeader_switchHook
	.dw uncmpGfxHeader_seedShooter

.ifdef WIDE_INVENTORY_SPRITES
	.dw uncmpGfxHeader_itemIconsEquippedExt1
	.dw uncmpGfxHeader_itemIconsEquippedExt2
	.dw uncmpGfxHeader_itemIconsWide
	.dw uncmpGfxHeader_boomerang
	.dw uncmpGfxHeader_magicBoomerang
	.dw uncmpGfxHeader_bracelet
	.dw uncmpGfxHeader_powerGlove
	.dw uncmpGfxHeader_feather
	.dw uncmpGfxHeader_rocsCape
	.dw uncmpGfxHeader_magnetGlovesSouth
	.dw uncmpGfxHeader_magnetGlovesNorth
	.dw uncmpGfxHeader_switchHookL1
	.dw uncmpGfxHeader_switchHookL2
	.dw uncmpGfxHeader_swordL1
	.dw uncmpGfxHeader_swordL2
	.dw uncmpGfxHeader_swordL3
.ifdef ENABLE_NEW_GAME_PLUS
	.dw uncmpGfxHeader_swordL4
.endif
	.dw uncmpGfxHeader_shieldL1
	.dw uncmpGfxHeader_shieldL2
	.dw uncmpGfxHeader_shieldL3
.ifdef ENABLE_NEW_GAME_PLUS
	.dw uncmpGfxHeader_shieldL4
.endif
	.dw uncmpGfxHeader_noTune
	.dw uncmpGfxHeader_tuneOfEchoes
	.dw uncmpGfxHeader_tuneOfCurrents
	.dw uncmpGfxHeader_tuneOfAges
	.dw uncmpGfxHeader_fluteNone
	.dw uncmpGfxHeader_fluteRicky
	.dw uncmpGfxHeader_fluteDimitri
	.dw uncmpGfxHeader_fluteMoosh
.endif
.ifdef ENABLE_NEW_GAME_PLUS
	.dw uncmpGfxHeader_lifeVialInv
	.dw uncmpGfxHeader_swordShieldInv
.endif
.ifdef ENABLE_SETTINGS_MENU
	.dw uncmpGfxHeader_inventorySubscreen4GfxRevert
	.dw uncmpGfxHeader_inventorySubscreen4Page0Gfx
	.dw uncmpGfxHeader_inventorySubscreen4Page1Gfx
.endif


uncmpGfxHeader00:

uncmpGfxHeader01:
	m_GfxHeaderRam w4TileMap, $8601, $1a
	m_GfxHeaderEnd

uncmpGfxHeader02:
	m_GfxHeaderRam w4ItemIconGfx, $8781, $08
	; Fall through

uncmpGfxHeader03:
	m_GfxHeaderRam w4StatusBarAttributeMap, $9fc1, $04
	m_GfxHeaderRam w4StatusBarTileMap,      $9fc0, $04
	m_GfxHeaderEnd

uncmpGfxHeader04:
	m_GfxHeaderRam w4AttributeMap+$40, $9801, $1a
	m_GfxHeaderRam w4TileMap+$40,      $9800, $1a
	m_GfxHeaderEnd

uncmpGfxHeader05:
	m_GfxHeaderRam w4AttributeMap+$40, $9c01, $1a
	m_GfxHeaderRam w4TileMap+$40,      $9c00, $1a
	m_GfxHeaderEnd

uncmpGfxHeader06:
	m_GfxHeaderRam w4AttributeMap+$40, $9801, $20
	m_GfxHeaderRam w4TileMap+$40,      $9800, $20
	m_GfxHeaderEnd

uncmpGfxHeader07:
	m_GfxHeaderRam w4GfxBuf1, $8c01, $30
	m_GfxHeaderEnd

uncmpGfxHeader08:
	m_GfxHeaderRam w4TileMap,      $9c00, $24
	m_GfxHeaderRam w4AttributeMap, $9c01, $24
	m_GfxHeaderEnd

uncmpGfxHeader09:
	m_GfxHeaderRam w4TileMap, $8000, $60
	m_GfxHeaderEnd

uncmpGfxHeader0a:
	m_GfxHeaderRam w4TileMap,      $9800, $2c
	m_GfxHeaderRam w4AttributeMap, $9801, $2c
	m_GfxHeaderEnd

uncmpGfxHeader0b:
	m_GfxHeaderRam w5NameEntryCharacterGfx, $8800, $80
	m_GfxHeaderEnd

uncmpGfxHeader0c:
	m_GfxHeaderRam w5NameEntryCharacterGfx, $8601, $20
	m_GfxHeaderEnd

uncmpGfxHeader0d:
	m_GfxHeaderRam w4TileMap+$140,      $9ea0, $16
	m_GfxHeaderRam w4AttributeMap+$140, $9ea1, $16
	m_GfxHeaderEnd

uncmpGfxHeader0e:
	m_GfxHeaderRam w3TileMappingIndices, $9801, $2c
	m_GfxHeaderRam w3VramTiles, $9800, $2c
	m_GfxHeaderEnd

uncmpGfxHeader0f:
	m_GfxHeaderRam w3VramTiles, $9800, $20
	m_GfxHeaderRam w3TileMappingIndices, $9801, $20
	m_GfxHeaderEnd

uncmpGfxHeader10:
	m_GfxHeaderRam w3TileMappingIndices, $9801, $2c
	m_GfxHeaderRam w3VramTiles, $9800, $2c
	m_GfxHeaderEnd

uncmpGfxHeader11:
	m_GfxHeaderRam w3TileMappingIndices+$60, $9861, $02
	m_GfxHeaderRam w3VramTiles+$60,          $9860, $02
	m_GfxHeaderEnd

uncmpGfxHeader12:
	m_GfxHeaderRam w4AttributeMap, $9801, $24
	m_GfxHeaderRam w4TileMap,      $9800, $24
	m_GfxHeaderEnd

uncmpGfxHeader13:
	m_GfxHeaderRam w4AttributeMap+$000, $9801, $20
	m_GfxHeaderRam w4TileMap+$000,      $9800, $20
	m_GfxHeaderRam w4AttributeMap+$200, $9bc1, $04
	m_GfxHeaderRam w4TileMap+$200,      $9bc0, $04
	m_GfxHeaderEnd

uncmpGfxHeader14:
	m_GfxHeaderRam w4AttributeMap, $9c01, $24
	m_GfxHeaderRam w4TileMap,      $9c00, $24
	m_GfxHeaderEnd

uncmpGfxHeader15:
	m_GfxHeaderRam w4AttributeMap+$000, $9c01, $10
	m_GfxHeaderRam w4TileMap+$000,      $9c00, $10
	m_GfxHeaderRam w4TileMap+$100,      $9900, $02
	m_GfxHeaderRam w4AttributeMap+$200, $9bc1, $04
	m_GfxHeaderRam w4TileMap+$200,      $9bc0, $04
	m_GfxHeaderEnd

uncmpGfxHeader16:
	m_GfxHeaderRam w4StatusBarTileMap,      $9dc0, $0a
	m_GfxHeaderRam w4StatusBarAttributeMap, $9dc1, $0a
	m_GfxHeaderEnd

uncmpGfxHeader17:
	m_GfxHeaderRam w7TextGfxBuffer, $9201, $20
	m_GfxHeaderEnd

uncmpGfxHeader18:
	m_GfxHeader spr_boomerang, $84e1, $04
	m_GfxHeaderEnd

uncmpGfxHeader19:
	m_GfxHeader spr_boomerang, $84e1, $04, $40
	m_GfxHeaderEnd

uncmpGfxHeader1a:
	m_GfxHeader spr_swords, $8521, $0a
	m_GfxHeaderEnd

uncmpGfxHeader1b:
	m_GfxHeader spr_swords, $8521, $0e, $a0
	m_GfxHeaderEnd

uncmpGfxHeader1c:
	m_GfxHeader spr_rod_of_seasons, $8521
	m_GfxHeaderEnd

uncmpGfxHeader1d:
	m_GfxHeader spr_slingshot, $8521
	m_GfxHeaderEnd

uncmpGfxHeader1e:
	m_GfxHeader spr_magnet_gloves, $8521
	m_GfxHeaderEnd

uncmpGfxHeader1f:
	m_GfxHeader spr_item_icons_2, $8521, $02, $140
	m_GfxHeaderEnd

uncmpGfxHeader20:
	m_GfxHeaderRam w7d800+$000, $9200, $10
	m_GfxHeaderEnd

uncmpGfxHeader21:
	m_GfxHeaderRam w7d800+$100, $9200, $10
	m_GfxHeaderEnd

uncmpGfxHeader22:
	m_GfxHeaderRam w7d800+$200, $9240, $0b
	m_GfxHeaderEnd

uncmpGfxHeader23:
	m_GfxHeaderRam w7d800+$2b0, $9240, $0a
	m_GfxHeaderEnd

uncmpGfxHeader24:
	m_GfxHeaderRam w7d800+$350, $9240, $06
	m_GfxHeaderEnd

uncmpGfxHeader25:
	m_GfxHeaderRam w7d800+$3b0, $9240, $04
	m_GfxHeaderEnd

uncmpGfxHeader26:
	m_GfxHeaderRam w7d800+$3f0, $9240, $04
	m_GfxHeaderEnd

uncmpGfxHeader27:
uncmpGfxHeader28:
	m_GfxHeaderRam w7d800+$430, $9240, $02
	m_GfxHeaderEnd

uncmpGfxHeader29:
	m_GfxHeaderRam w7d800+$450, $9200, $04
	m_GfxHeaderEnd

uncmpGfxHeader2a:
	m_GfxHeaderRam w4TileMap,      $9d60, $16
	m_GfxHeaderRam w4AttributeMap, $9d61, $16
	m_GfxHeaderEnd

uncmpGfxHeader2b:
	m_GfxHeaderRam w7d800,               $8c01, $30
	m_GfxHeaderRam w3VramTiles,          $9800, $2c
	m_GfxHeaderRam w3TileMappingIndices, $9801, $2c
	m_GfxHeaderEnd

uncmpGfxHeader2c:
	m_GfxHeaderRam w4TileMap,      $9800, $0c
	m_GfxHeaderRam w4AttributeMap, $9801, $0c
	m_GfxHeaderEnd

uncmpGfxHeader2d:
	m_GfxHeaderRam w3VramTiles,          $9840, $20
	m_GfxHeaderRam w3TileMappingIndices, $9841, $20
	m_GfxHeaderEnd

uncmpGfxHeader2e:
	m_GfxHeaderRam w3VramTiles,          $98c0, $14
	m_GfxHeaderRam w3TileMappingIndices, $98c1, $14
	m_GfxHeaderEnd

uncmpGfxHeader2f:
	m_GfxHeaderRam w3VramTiles+$140,          $9a00, $0e
	m_GfxHeaderRam w3TileMappingIndices+$140, $9a01, $0e
	m_GfxHeaderEnd

uncmpGfxHeader30:
	m_GfxHeaderRam w6d3c0, $9f60, $04
	m_GfxHeaderRam w6d7c0, $9f61, $04
	m_GfxHeaderEnd

uncmpGfxHeader31:
	m_GfxHeaderRam w3VramTiles,          $9860, $20
	m_GfxHeaderRam w3TileMappingIndices, $9861, $20
	m_GfxHeaderEnd

uncmpGfxHeader32:
	m_GfxHeaderRam w2TmpGfxBuffer, $8200, $20
	m_GfxHeaderEnd

uncmpGfxHeader33:
	m_GfxHeaderRam w2TmpGfxBuffer, $8400, $20
	m_GfxHeaderEnd

uncmpGfxHeader34:
uncmpGfxHeader35:
	m_GfxHeaderRam w7d800, $8300, $30
	m_GfxHeaderEnd


.ifdef WIDE_INVENTORY_SPRITES
uncmpGfxHeader_itemIconsEquippedExt1:
	m_GfxHeaderRam w4ItemIconGfxExt, $84e1, $04
	m_GfxHeaderEnd

uncmpGfxHeader_itemIconsEquippedExt2:
	m_GfxHeaderRam w4ItemIconGfxExt, $85c1, $04
	m_GfxHeaderEnd

uncmpGfxHeader_itemIconsWide:
	m_GfxHeader spr_item_icons_wide, $8001
	m_GfxHeader gfx_item_icons_wide_fixup_tiles, $87e0
	m_GfxHeader spr_item_icons_wide_seeds_sprite, $8960
	m_GfxHeader spr_item_icons_song_sprites, $81c0, $04
	m_GfxHeader spr_item_icons_song_sprites, $82c0, $04, $40
	m_GfxHeader spr_item_icons_song_sprites, $85a0, $04, $80
	m_GfxHeaderEnd

; overwrite item icons with their higher level variants
uncmpGfxHeader_boomerang:
	m_GfxHeader spr_item_icons_wide, $8241, $04, $240
	m_GfxHeaderEnd

uncmpGfxHeader_magicBoomerang:
	m_GfxHeader spr_item_icons_wide_boomerang_l2, $8241
	m_GfxHeaderEnd

uncmpGfxHeader_bracelet:
	m_GfxHeader spr_item_icons_wide, $80c1, $04, $c0
	m_GfxHeaderEnd

uncmpGfxHeader_powerGlove:
	m_GfxHeader spr_item_icons_wide_bracelet_l2, $80c1
	m_GfxHeaderEnd

uncmpGfxHeader_feather:
	m_GfxHeader spr_item_icons_wide, $8081, $04, $80
	m_GfxHeaderEnd

uncmpGfxHeader_rocsCape:
	m_GfxHeader spr_item_icons_wide_feather_l2, $8081
	m_GfxHeaderEnd

uncmpGfxHeader_magnetGlovesSouth:
	m_GfxHeader spr_item_icons_wide, $8321, $04, $320
	m_GfxHeaderEnd

uncmpGfxHeader_magnetGlovesNorth:
	m_GfxHeader spr_item_icons_wide_magnet_glove_n, $8321
	m_GfxHeaderEnd

uncmpGfxHeader_switchHookL1:
	m_GfxHeader spr_item_icons_wide, $8201, $04, $200
	m_GfxHeaderEnd

uncmpGfxHeader_switchHookL2:
	m_GfxHeader spr_item_icons_wide_switch_hook_l2, $8201
	m_GfxHeaderEnd

uncmpGfxHeader_swordL1:
	m_GfxHeader spr_item_icons_wide, $8001, $04
	m_GfxHeaderEnd

uncmpGfxHeader_shieldL1:
	m_GfxHeader spr_item_icons_wide, $8041, $04, $40
	m_GfxHeaderEnd

uncmpGfxHeader_swordL2:
	m_GfxHeader spr_item_icons_wide_sword_l2, $8001
	m_GfxHeaderEnd

uncmpGfxHeader_shieldL2:
	m_GfxHeader spr_item_icons_wide_shield_l2, $8041
	m_GfxHeaderEnd

uncmpGfxHeader_swordL3:
	m_GfxHeader spr_item_icons_wide_sword_l3, $8001
	m_GfxHeaderEnd

uncmpGfxHeader_shieldL3:
	m_GfxHeader spr_item_icons_wide_shield_l3, $8041
	m_GfxHeaderEnd

uncmpGfxHeader_noTune:
	m_GfxHeader spr_item_icons_wide, $8561, $04, $560
	m_GfxHeaderEnd

uncmpGfxHeader_tuneOfEchoes:
	m_GfxHeader spr_item_icons_wide_songs, $8561, $04, $80
	m_GfxHeaderEnd

uncmpGfxHeader_tuneOfCurrents:
	m_GfxHeader spr_item_icons_wide_songs, $8561, $04, $40
	m_GfxHeaderEnd

uncmpGfxHeader_tuneOfAges:
	m_GfxHeader spr_item_icons_wide_songs, $8561, $04
	m_GfxHeaderEnd

uncmpGfxHeader_fluteNone:
	m_GfxHeader spr_item_icons_wide, $8461, $02, $520
	m_GfxHeaderEnd

uncmpGfxHeader_fluteRicky:
	m_GfxHeader spr_item_icons_wide_flute_partners, $8461, $02
	m_GfxHeaderEnd

uncmpGfxHeader_fluteDimitri:
	m_GfxHeader spr_item_icons_wide_flute_partners, $8461, $02, $20
	m_GfxHeaderEnd

uncmpGfxHeader_fluteMoosh:
	m_GfxHeader spr_item_icons_wide_flute_partners, $8461, $02, $40
	m_GfxHeaderEnd

.else

; CROSSITEMS: Magical boomerang overwriting L-1 boomerang for inventory gfx
uncmpGfxHeader_magicBoomerangInv:
	m_GfxHeader spr_boomerang, $8381, $02, $40
	m_GfxHeaderEnd

; Hyper slingshot overwriting L-1 slingshot for inventory gfx
uncmpGfxHeader_hyperSlingshotInv:
	m_GfxHeader spr_hyperslingshot_inventory, $8021
	m_GfxHeaderEnd
.endif

uncmpGfxHeader_caneOfSomaria:
	m_GfxHeader spr_cane_of_somaria, $8521
	m_GfxHeaderEnd

uncmpGfxHeader_switchHook:
	m_GfxHeader spr_switch_hook, $8521
	m_GfxHeaderEnd

uncmpGfxHeader_seedShooter:
	m_GfxHeader spr_seed_shooter, $8521
	m_GfxHeaderEnd

.ifdef ENABLE_NEW_GAME_PLUS
uncmpGfxHeader_lifeVialInv:
.ifdef WIDE_INVENTORY_SPRITES
	m_GfxHeader spr_item_icons_life_vial, $8721
.else
	m_GfxHeader spr_item_icons_life_vial_slim, $8721
.endif
	m_GfxHeaderEnd

uncmpGfxHeader_swordShieldInv:
	m_GfxHeader spr_item_icons_sword_shield_l4, $8900
	m_GfxHeaderEnd

.ifdef WIDE_INVENTORY_SPRITES
uncmpGfxHeader_swordL4:
	m_GfxHeader spr_item_icons_wide_sword_l4, $8001
	m_GfxHeaderEnd

uncmpGfxHeader_shieldL4:
	m_GfxHeader spr_item_icons_wide_shield_l4, $8041
	m_GfxHeaderEnd
.endif
.endif

.ifdef ENABLE_SETTINGS_MENU
uncmpGfxHeader_inventorySubscreen4GfxRevert:
	m_GfxHeader gfx_rings_uncomp, $8a00
	m_GfxHeaderEnd

uncmpGfxHeader_inventorySubscreen4Page0Gfx:
	m_GfxHeader gfx_settings_text_page_0, $8a00
	m_GfxHeaderEnd

uncmpGfxHeader_inventorySubscreen4Page1Gfx:
	m_GfxHeader gfx_settings_text_page_1, $8a00
	m_GfxHeaderEnd
.endif