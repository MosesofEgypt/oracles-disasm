; HACK-BASE: Expanded GFX, tilemap, and collision data for tilesets are stored here.


; Not using the "3BytePointer" macro here because we want the 1st byte "$ff" to mean "is a seasonal
; tileset". (Technically bank "$ff" could end up in use when ROM is expanded.)
.macro m_TilesetGfxPointer
	m_ReadGfxDataHashedFilename \1
	dwbe {filename}
	.db :{filename}
.endm

.macro m_TilesetMappingPointer
	dwbe \1
	.db :\1
.endm


.macro m_TilesetMappingSection
.section expanded_tileset_mappings_\1 SUPERFREE
tilesetMappings\1:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings\1.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions\1.bin"
.ends
.endm

.macro m_SeasonalTilesetGfxPointer
	.db $ff
	.dw \1_season_table
.endm

.SLOT 1
.section ExpandedTilesetPointers SUPERFREE

expandedTilesetGfxTable:
.REPT $1b index tmpi
	m_SeasonalTilesetGfxPointer gfx_tileset{%.2x{tmpi}}
.ENDR
.REPT $80-$1b START $1b index tmpi
	m_TilesetGfxPointer gfx_tileset{%.2x{tmpi}}
.ENDR

.REPT $1b index tmpi
gfx_tileset{%.2x{tmpi}}_season_table:
	m_TilesetGfxPointer gfx_tileset{%.2x{tmpi}}_spring
	m_TilesetGfxPointer gfx_tileset{%.2x{tmpi}}_summer
	m_TilesetGfxPointer gfx_tileset{%.2x{tmpi}}_autumn
	m_TilesetGfxPointer gfx_tileset{%.2x{tmpi}}_winter
.ENDR

expandedTilesetMappingsTable:
.REPT $1b index tmpi
	m_SeasonalTilesetGfxPointer tilesetMappings{%.2x{tmpi}}
.ENDR
.REPT $80-$1b START $1b index tmpi
	m_TilesetMappingPointer tilesetMappings{%.2x{tmpi}}
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


.BANK $40 SLOT 1
.ORGA $4000

.redefine DATA_ADDR $4000
.redefine DATA_BANK $40

	; For simplicity I'm using the "m_GfxData" macro, which can handle data crossing banks.
	; But since each tileset is exactly 0x1000 bytes (and is uncompressed) it doesn't actually
	; cross over any banks.
.REPT $1b index tmpi
	m_GfxData gfx_tileset{%.2x{tmpi}}_spring
	m_GfxData gfx_tileset{%.2x{tmpi}}_summer
	m_GfxData gfx_tileset{%.2x{tmpi}}_autumn
	m_GfxData gfx_tileset{%.2x{tmpi}}_winter
.ENDR

	; For simplicity I'm using the "m_GfxData" macro, which can handle data crossing banks.
	; But since each tileset is exactly 0x1000 bytes (and is uncompressed) it doesn't actually
	; cross over any banks.
.REPT $80-$1b START $1b index tmpi
	m_GfxData gfx_tileset{%.2x{tmpi}}
.ENDR