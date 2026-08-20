.macro m_TilesetGfxPointer
    m_ReadGfxDataHashedFilename \1
	dwbe {filename}
	.db (:{filename})&$ff
.endm

.macro m_SeasonalTilesetGfxPointer
	.db $ff
	.dw \1_season_table
.endm

.macro m_TilesetMappingPointer
    dwbe \1
    .db :\1
.endm


.macro m_TilesetMappingSection
.ifdef ROM_AGES
    .section expanded_tileset_mappings_\1_ages SUPERFREE
    ages_tilesetMappings\1:
        .incbin "tileset_layouts_expanded/ages/tilesetMappings\1.bin"
        .incbin "tileset_layouts_expanded/ages/tilesetCollisions\1.bin"
.else
.section expanded_tileset_mappings_\1_seasons SUPERFREE
    seasons_tilesetMappings\1:
        .incbin "tileset_layouts_expanded/seasons/tilesetMappings\1.bin"
        .incbin "tileset_layouts_expanded/seasons/tilesetCollisions\1.bin"
.endif
.ends
.endm


.SLOT 1
.define ROM_AGES
.section ExpandedTilesetPointers_ages SUPERFREE

    expandedTilesetGfxTable_ages:
    .REPT $80 index tmpi
        m_TilesetGfxPointer ages_gfx_tileset{%.2x{tmpi}}
    .ENDR


    expandedTilesetMappingsTable_ages:
    .REPT $80 index tmpi
        m_TilesetMappingPointer ages_tilesetMappings{%.2x{tmpi}}
    .ENDR
.ends


.undefine ROM_AGES
.section ExpandedTilesetPointers_seasons SUPERFREE

    expandedTilesetGfxTable_seasons:
    .REPT $1b index tmpi
        m_SeasonalTilesetGfxPointer gfx_tileset{%.2x{tmpi}}
    .ENDR

    .REPT $80-$1b START $1b index tmpi
        m_TilesetGfxPointer seasons_gfx_tileset{%.2x{tmpi}}
    .ENDR

    .REPT $1b index tmpi
    gfx_tileset{%.2x{tmpi}}_season_table:
        m_TilesetGfxPointer seasons_gfx_tileset{%.2x{tmpi}}_spring
        m_TilesetGfxPointer seasons_gfx_tileset{%.2x{tmpi}}_summer
        m_TilesetGfxPointer seasons_gfx_tileset{%.2x{tmpi}}_autumn
        m_TilesetGfxPointer seasons_gfx_tileset{%.2x{tmpi}}_winter
    .ENDR

    expandedTilesetMappingsTable_seasons:
    .REPT $1b index tmpi
        m_SeasonalTilesetGfxPointer tilesetMappings{%.2x{tmpi}}
    .ENDR
    .REPT $80-$1b START $1b index tmpi
        m_TilesetMappingPointer seasons_tilesetMappings{%.2x{tmpi}}
    .ENDR

    .REPT $1b index tmpi
    tilesetMappings{%.2x{tmpi}}_season_table:
        m_TilesetMappingPointer tilesetMappings{%.2x{tmpi}}_spring
        m_TilesetMappingPointer tilesetMappings{%.2x{tmpi}}_summer
        m_TilesetMappingPointer tilesetMappings{%.2x{tmpi}}_autumn
        m_TilesetMappingPointer tilesetMappings{%.2x{tmpi}}_winter
    .ENDR
.ends


.REPT $1b index tmpi
.section expanded_tileset_mappings_seasonal_{%.2x{tmpi}} SUPERFREE
tilesetMappings{%.2x{tmpi}}_spring:
	.incbin {"tileset_layouts_expanded/seasons/tilesetMappings{%.2x{tmpi}}_spring.bin"}
	.incbin {"tileset_layouts_expanded/seasons/tilesetCollisions{%.2x{tmpi}}_spring.bin"}
tilesetMappings{%.2x{tmpi}}_summer:
	.incbin {"tileset_layouts_expanded/seasons/tilesetMappings{%.2x{tmpi}}_summer.bin"}
	.incbin {"tileset_layouts_expanded/seasons/tilesetCollisions{%.2x{tmpi}}_summer.bin"}
tilesetMappings{%.2x{tmpi}}_autumn:
	.incbin {"tileset_layouts_expanded/seasons/tilesetMappings{%.2x{tmpi}}_autumn.bin"}
	.incbin {"tileset_layouts_expanded/seasons/tilesetCollisions{%.2x{tmpi}}_autumn.bin"}
tilesetMappings{%.2x{tmpi}}_winter:
	.incbin {"tileset_layouts_expanded/seasons/tilesetMappings{%.2x{tmpi}}_winter.bin"}
	.incbin {"tileset_layouts_expanded/seasons/tilesetCollisions{%.2x{tmpi}}_winter.bin"}
.ends
.ENDR

.REPT $80-$1b START $1b index tmpi
	m_TilesetMappingSection {"{%.2x{tmpi}}"}
.ENDR


.define ROM_AGES
.REPT $80 index tmpi
    m_TilesetMappingSection {"{%.2x{tmpi}}"}
.ENDR
.undefine ROM_AGES