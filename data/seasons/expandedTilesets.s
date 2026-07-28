; HACK-BASE: Expanded GFX, tilemap, and collision data for tilesets are stored here.


; Not using the "3BytePointer" macro here because we want the 1st byte "$ff" to mean "is a seasonal
; tileset". (Technically bank "$ff" could end up in use when ROM is expanded.)
.macro m_TilesetGfxPointer
.ifdef ROM_COMBO
	m_ReadGfxDataHashedFilename seasons_{\1}
.else
	m_ReadGfxDataHashedFilename \1
.endif
	dwbe {filename}
	.db :{filename}
.endm

.macro m_TilesetMappingPointer
.ifdef ROM_COMBO
	dwbe {\1}_seasons
	.db :{\1}_seasons
.else
	dwbe \1
	.db :\1
.endif
.endm


.macro m_TilesetMappingSection
.ifdef ROM_COMBO
.section expanded_tileset_mappings_\1_seasons SUPERFREE
tilesetMappings\1_seasons:
.else
.section expanded_tileset_mappings_\1 SUPERFREE
tilesetMappings\1:
.endif
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

.section expanded_tileset_mappings_seasonal_00 SUPERFREE

tilesetMappings00_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings00_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions00_spring.bin"
tilesetMappings00_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings00_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions00_summer.bin"
tilesetMappings00_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings00_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions00_autumn.bin"
tilesetMappings00_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings00_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions00_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_01 SUPERFREE

tilesetMappings01_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings01_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions01_spring.bin"
tilesetMappings01_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings01_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions01_summer.bin"
tilesetMappings01_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings01_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions01_autumn.bin"
tilesetMappings01_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings01_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions01_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_02 SUPERFREE

tilesetMappings02_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings02_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions02_spring.bin"
tilesetMappings02_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings02_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions02_summer.bin"
tilesetMappings02_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings02_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions02_autumn.bin"
tilesetMappings02_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings02_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions02_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_03 SUPERFREE

tilesetMappings03_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings03_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions03_spring.bin"
tilesetMappings03_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings03_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions03_summer.bin"
tilesetMappings03_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings03_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions03_autumn.bin"
tilesetMappings03_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings03_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions03_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_04 SUPERFREE

tilesetMappings04_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings04_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions04_spring.bin"
tilesetMappings04_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings04_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions04_summer.bin"
tilesetMappings04_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings04_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions04_autumn.bin"
tilesetMappings04_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings04_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions04_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_05 SUPERFREE

tilesetMappings05_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings05_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions05_spring.bin"
tilesetMappings05_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings05_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions05_summer.bin"
tilesetMappings05_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings05_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions05_autumn.bin"
tilesetMappings05_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings05_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions05_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_06 SUPERFREE

tilesetMappings06_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings06_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions06_spring.bin"
tilesetMappings06_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings06_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions06_summer.bin"
tilesetMappings06_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings06_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions06_autumn.bin"
tilesetMappings06_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings06_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions06_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_07 SUPERFREE

tilesetMappings07_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings07_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions07_spring.bin"
tilesetMappings07_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings07_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions07_summer.bin"
tilesetMappings07_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings07_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions07_autumn.bin"
tilesetMappings07_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings07_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions07_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_08 SUPERFREE

tilesetMappings08_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings08_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions08_spring.bin"
tilesetMappings08_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings08_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions08_summer.bin"
tilesetMappings08_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings08_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions08_autumn.bin"
tilesetMappings08_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings08_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions08_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_09 SUPERFREE

tilesetMappings09_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings09_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions09_spring.bin"
tilesetMappings09_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings09_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions09_summer.bin"
tilesetMappings09_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings09_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions09_autumn.bin"
tilesetMappings09_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings09_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions09_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_0a SUPERFREE

tilesetMappings0a_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0a_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0a_spring.bin"
tilesetMappings0a_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0a_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0a_summer.bin"
tilesetMappings0a_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0a_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0a_autumn.bin"
tilesetMappings0a_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0a_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0a_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_0b SUPERFREE

tilesetMappings0b_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0b_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0b_spring.bin"
tilesetMappings0b_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0b_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0b_summer.bin"
tilesetMappings0b_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0b_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0b_autumn.bin"
tilesetMappings0b_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0b_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0b_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_0c SUPERFREE

tilesetMappings0c_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0c_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0c_spring.bin"
tilesetMappings0c_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0c_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0c_summer.bin"
tilesetMappings0c_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0c_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0c_autumn.bin"
tilesetMappings0c_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0c_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0c_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_0d SUPERFREE

tilesetMappings0d_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0d_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0d_spring.bin"
tilesetMappings0d_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0d_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0d_summer.bin"
tilesetMappings0d_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0d_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0d_autumn.bin"
tilesetMappings0d_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0d_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0d_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_0e SUPERFREE

tilesetMappings0e_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0e_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0e_spring.bin"
tilesetMappings0e_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0e_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0e_summer.bin"
tilesetMappings0e_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0e_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0e_autumn.bin"
tilesetMappings0e_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0e_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0e_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_0f SUPERFREE

tilesetMappings0f_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0f_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0f_spring.bin"
tilesetMappings0f_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0f_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0f_summer.bin"
tilesetMappings0f_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0f_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0f_autumn.bin"
tilesetMappings0f_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings0f_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions0f_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_10 SUPERFREE

tilesetMappings10_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings10_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions10_spring.bin"
tilesetMappings10_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings10_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions10_summer.bin"
tilesetMappings10_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings10_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions10_autumn.bin"
tilesetMappings10_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings10_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions10_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_11 SUPERFREE

tilesetMappings11_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings11_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions11_spring.bin"
tilesetMappings11_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings11_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions11_summer.bin"
tilesetMappings11_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings11_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions11_autumn.bin"
tilesetMappings11_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings11_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions11_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_12 SUPERFREE

tilesetMappings12_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings12_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions12_spring.bin"
tilesetMappings12_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings12_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions12_summer.bin"
tilesetMappings12_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings12_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions12_autumn.bin"
tilesetMappings12_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings12_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions12_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_13 SUPERFREE

tilesetMappings13_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings13_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions13_spring.bin"
tilesetMappings13_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings13_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions13_summer.bin"
tilesetMappings13_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings13_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions13_autumn.bin"
tilesetMappings13_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings13_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions13_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_14 SUPERFREE

tilesetMappings14_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings14_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions14_spring.bin"
tilesetMappings14_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings14_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions14_summer.bin"
tilesetMappings14_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings14_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions14_autumn.bin"
tilesetMappings14_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings14_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions14_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_15 SUPERFREE

tilesetMappings15_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings15_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions15_spring.bin"
tilesetMappings15_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings15_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions15_summer.bin"
tilesetMappings15_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings15_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions15_autumn.bin"
tilesetMappings15_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings15_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions15_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_16 SUPERFREE

tilesetMappings16_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings16_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions16_spring.bin"
tilesetMappings16_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings16_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions16_summer.bin"
tilesetMappings16_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings16_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions16_autumn.bin"
tilesetMappings16_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings16_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions16_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_17 SUPERFREE

tilesetMappings17_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings17_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions17_spring.bin"
tilesetMappings17_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings17_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions17_summer.bin"
tilesetMappings17_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings17_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions17_autumn.bin"
tilesetMappings17_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings17_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions17_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_18 SUPERFREE

tilesetMappings18_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings18_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions18_spring.bin"
tilesetMappings18_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings18_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions18_summer.bin"
tilesetMappings18_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings18_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions18_autumn.bin"
tilesetMappings18_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings18_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions18_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_19 SUPERFREE

tilesetMappings19_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings19_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions19_spring.bin"
tilesetMappings19_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings19_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions19_summer.bin"
tilesetMappings19_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings19_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions19_autumn.bin"
tilesetMappings19_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings19_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions19_winter.bin"

.ends

.section expanded_tileset_mappings_seasonal_1a SUPERFREE

tilesetMappings1a_spring:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings1a_spring.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions1a_spring.bin"
tilesetMappings1a_summer:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings1a_summer.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions1a_summer.bin"
tilesetMappings1a_autumn:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings1a_autumn.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions1a_autumn.bin"
tilesetMappings1a_winter:
	.incbin "tileset_layouts_expanded/seasons/tilesetMappings1a_winter.bin"
	.incbin "tileset_layouts_expanded/seasons/tilesetCollisions1a_winter.bin"

.ends

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