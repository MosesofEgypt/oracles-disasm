; See data/ages/uniqueGfxHeaders.s for documentation.

.define NUM_UNIQUE_GFX_HEADERS $29

uniqueGfxHeadersStart:

m_UniqueGfxHeaderStart $00, UNIQUE_GFXH_NONE

m_UniqueGfxHeaderStart $01, UNIQUE_GFXH_HORON_VILLAGE
	m_GfxHeader gfx_tileset_horon_village, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $02, UNIQUE_GFXH_CLOCK_HOUSE
	m_GfxHeader gfx_tileset_clock_house, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $03, UNIQUE_GFXH_MAKU_TREE_GATE
	m_GfxHeader gfx_tileset_maku_tree_gate, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $04, UNIQUE_GFXH_GNARLED_ROOT_ENTRANCE_OPENED
	m_GfxHeader gfx_tileset_gnarled_root_entrance_opened, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $05, UNIQUE_GFXH_SNAKES_REMAINS_ENTRANCE
	m_GfxHeader gfx_tileset_snakes_remains_entrance, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $06, UNIQUE_GFXH_POISON_MOTHS_LAIR_ENTRANCE
	m_GfxHeader gfx_tileset_poison_moths_lair_entrance, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $07, UNIQUE_GFXH_SPOOL_SWAMP_SOUTH
	m_GfxHeader gfx_tileset_spool_swamp_south, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $08, UNIQUE_GFXH_TARM_RUINS_ENTRANCE
	m_GfxHeader gfx_tileset_tarm_ruins_entrance, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd PALH_SPR_ANCIENT_RUINS_ENTRANCE

m_UniqueGfxHeaderStart $09, UNIQUE_GFXH_DANCING_DRAGON_DUNGEON_ENTRANCE
	m_GfxHeader gfx_tileset_dancing_dragon_dungeon_entrance, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0a, UNIQUE_GFXH_SUNKEN_CITY
	m_GfxHeader gfx_tileset_sunken_city, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0b, UNIQUE_GFXH_SYRUPS_HUT
	m_GfxHeader gfx_tileset_syrups_hut, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0c, UNIQUE_GFXH_UNICORNS_CAVE_ENTRANCE
	m_GfxHeader gfx_tileset_unicorns_cave_entrance, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0d, UNIQUE_GFXH_TARM_RUINS_PEDESTAL
	m_GfxHeader gfx_tileset_tarm_ruins_pedestal, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0e, UNIQUE_GFXH_TARM_RUINS_NORTH
	m_GfxHeader gfx_tileset_tarm_ruins_north, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $0f, UNIQUE_GFXH_ANCIENT_RUINS_ENTRANCE
	m_GfxHeader gfx_tileset_ancient_ruins_entrance, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $10, UNIQUE_GFXH_SAMASA_DESERT
	m_GfxHeader gfx_tileset_samasa_desert, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $11, UNIQUE_GFXH_SAMASA_DESERT_PIRATE_SHIP
	m_GfxHeader gfx_tileset_samasa_desert_pirate_ship, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $12, UNIQUE_GFXH_WESTERN_COAST
	m_GfxHeader gfx_tileset_western_coast, VRAM_1_TILEDATA_2+$600
.ifdef ROM_COMBO
	m_GfxHeader seasons_gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04
.else
	m_GfxHeader gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04
.endif
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $13, UNIQUE_GFXH_EXPLORERS_CRYPT_ENTRANCE
	m_GfxHeader gfx_tileset_explorers_crypt_entrance, VRAM_1_TILEDATA_2+$600
.ifdef ROM_COMBO
	m_GfxHeader seasons_gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04
.else
	m_GfxHeader gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04
.endif
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $14, UNIQUE_GFXH_BLACK_BEAST
	m_GfxHeader gfx_tileset_black_beast, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $15, UNIQUE_GFXH_TEMPLE_REMAINS
	m_GfxHeader gfx_tileset_temple_remains, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $16, UNIQUE_GFXH_ONOX_CASTLE_OUTSIDE
	m_GfxHeader gfx_tileset_onox_castle_outside_1, VRAM_1_TILEDATA_2+$200
	m_GfxHeader gfx_tileset_onox_castle_outside_2, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $17, UNIQUE_GFXH_TEMPLE_OF_SEASONS_OUTSIDE
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_1, VRAM_1_TILEDATA_1+$300
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_2, VRAM_1_TILEDATA_1+$600
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_3, VRAM_1_TILEDATA_2
	m_GfxHeader gfx_tileset_temple_of_seasons_outside_4, VRAM_1_TILEDATA_2+$400
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $18, UNIQUE_GFXH_SUBROSIA
	m_GfxHeader gfx_tileset_subrosia_2, VRAM_1_TILEDATA_1+$300
	m_GfxHeader gfx_tileset_subrosia_3, VRAM_1_TILEDATA_1+$600
	m_GfxHeader gfx_tileset_subrosia_4, VRAM_1_TILEDATA_2
	m_GfxHeader gfx_tileset_subrosia_5, VRAM_1_TILEDATA_2+$5b0
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $19, UNIQUE_GFXH_SUBROSIA_VILLAGE
	m_GfxHeader gfx_tileset_subrosia_village, VRAM_1_TILEDATA_2+$440
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $1a, UNIQUE_GFXH_SUBROSIAN_SMITHY_OUTSIDE
	m_GfxHeader gfx_tileset_subrosian_smithy_outside, VRAM_1_TILEDATA_2+$4c0
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $1b, UNIQUE_GFXH_SUBROSIAN_MARKET_OUTSIDE
	m_GfxHeader gfx_tileset_subrosian_market_outside, VRAM_1_TILEDATA_2+$480
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $1c, UNIQUE_GFXH_SUBROSIA_PIRATE_SHIP
	m_GfxHeader gfx_tileset_subrosia_pirate_ship_1, VRAM_1_TILEDATA_2+$400
	m_GfxHeader gfx_tileset_subrosia_pirate_ship_2, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $1d, UNIQUE_GFXH_MAKU_TREE_BOTTOM
	m_GfxHeader gfx_tileset_maku_tree_1, VRAM_1_TILEDATA_1+$440
	m_GfxHeader gfx_tileset_maku_tree_2, VRAM_1_TILEDATA_2
	m_GfxHeader gfx_tileset_maku_tree_3, VRAM_1_TILEDATA_2+$400
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $1e, UNIQUE_GFXH_MAKU_TREE_TOP
	m_GfxHeader gfx_tileset_maku_tree_top_1, VRAM_1_TILEDATA_1+$700
	m_GfxHeader gfx_tileset_maku_tree_top_2, VRAM_1_TILEDATA_2
	m_GfxHeader gfx_tileset_maku_tree_top_3, VRAM_1_TILEDATA_2+$400
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $1f, UNIQUE_GFXH_BIGGORON
.ifdef ROM_COMBO
	m_GfxHeader seasons_gfx_animations_1, VRAM_1_TILEDATA_1+$080, $08, $40
.else
	m_GfxHeader gfx_animations_1, VRAM_1_TILEDATA_1+$080, $08, $40
.endif
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $20, UNIQUE_GFXH_GNARLED_ROOT_ENTRANCE_CLOSED
	m_GfxHeader gfx_tileset_gnarled_root_entrance_closed, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $21, UNIQUE_GFXH_GNARLED_ROOT_ENTRANCE_OPENING_1
	m_GfxHeader gfx_tileset_gnarled_root_entrance_opening_1, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $22, UNIQUE_GFXH_GNARLED_ROOT_ENTRANCE_OPENING_2
	m_GfxHeader gfx_tileset_gnarled_root_entrance_opening_2, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $23, UNIQUE_GFXH_GNARLED_ROOT_ENTRANCE_OPENING_3
	m_GfxHeader gfx_tileset_gnarled_root_entrance_opening_3, VRAM_1_TILEDATA_2+$600
	m_GfxHeaderEnd

m_UniqueGfxHeaderStart $24, UNIQUE_GFXH_24
	m_GfxHeaderEnd PALH_TILESET_SWORD_AND_SHIELD_MAZE_ICE

m_UniqueGfxHeaderStart $25, UNIQUE_GFXH_25
	m_GfxHeaderEnd PALH_TILESET_SWORD_AND_SHIELD_MAZE_FIRE

m_UniqueGfxHeaderStart $26, UNIQUE_GFXH_SWORD_AND_SHIELD_MAZE_FIRE_MINIBOSS
	m_GfxHeaderEnd PALH_TILESET_SWORD_AND_SHIELD_MAZE_FIRE_MINIBOSS

m_UniqueGfxHeaderStart $27, UNIQUE_GFXH_EXPLORERS_CRYPT_PALETTE_A
	m_GfxHeaderEnd PALH_TILESET_EXPLORERS_CRYPT_A

m_UniqueGfxHeaderStart $28, UNIQUE_GFXH_EXPLORERS_CRYPT_PALETTE_B
	m_GfxHeaderEnd PALH_TILESET_EXPLORERS_CRYPT_B


uniqueGfxHeaderTable:
	.repeat NUM_UNIQUE_GFX_HEADERS index COUNT
		.dw uniqueGfxHeader{%.2x{COUNT}}
	.endr
