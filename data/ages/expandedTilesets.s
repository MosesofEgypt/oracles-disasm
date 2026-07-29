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
	.incbin "tileset_layouts_expanded/ages/tilesetMappings\1.bin"
	.incbin "tileset_layouts_expanded/ages/tilesetCollisions\1.bin"
.ends
.endm

.SLOT 1
.section ExpandedTilesetPointers SUPERFREE

expandedTilesetGfxTable:
.REPT $80 index tmpi
	m_TilesetGfxPointer gfx_tileset{%.2x{tmpi}}
.ENDR


expandedTilesetMappingsTable:
.REPT $80 index tmpi
	m_TilesetMappingPointer tilesetMappings{%.2x{tmpi}}
.ENDR
.ends


.BANK $40 SLOT 1
.ORGA $4000

.redefine DATA_ADDR $4000
.redefine DATA_BANK $40

	; For simplicity I'm using the "m_GfxData" macro, which can handle data crossing banks.
	; But since each tileset is exactly 0x1000 bytes (and is uncompressed) it doesn't actually
	; cross over any banks.
.REPT $80 index tmpi
	m_GfxData gfx_tileset{%.2x{tmpi}}
.ENDR

.REPT $80 index tmpi
	m_TilesetMappingSection {"{%.2x{tmpi}}"}
.ENDR