; HACK-BASE: Expanded GFX, tilemap, and collision data for tilesets are stored here.


; Not using the "3BytePointer" macro here because we want the 1st byte "$ff" to mean "is a seasonal
; tileset". (Technically bank "$ff" could end up in use when ROM is expanded.)
.macro m_TilesetGfxPointer
	m_ReadGfxDataHashedFilename \1
	dwbe {filename}
	.db (:{filename})&$ff
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

.REPT $80 index tmpi
	m_TilesetMappingSection {"{%.2x{tmpi}}"}
.ENDR