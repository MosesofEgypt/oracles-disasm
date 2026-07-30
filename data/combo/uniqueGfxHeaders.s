.include "data/seasons/uniqueGfxHeaders.s"

; NOTE: due to data/seasons/uniqueGfxHeaders.s having uniqueGfxHeaderTable
;       defined at the end, we can append the ages headers to it like this
.define NUM_AGES_UNIQUE_GFX_HEADERS $14
.repeat NUM_AGES_UNIQUE_GFX_HEADERS START NUM_UNIQUE_GFX_HEADERS index COUNT
	.dw uniqueGfxHeader{%.2x{COUNT}}
.endr

.redefine NUM_UNIQUE_GFX_HEADERS NUM_UNIQUE_GFX_HEADERS + NUM_AGES_UNIQUE_GFX_HEADERS
.undefine NUM_AGES_UNIQUE_GFX_HEADERS

m_UniqueGfxHeaderStart $29, UNIQUE_GFXH_LYNNA_CITY_1
m_UniqueGfxHeaderStart $2a, UNIQUE_GFXH_LYNNA_CITY_2
m_UniqueGfxHeaderStart $2b, UNIQUE_GFXH_YOLL_GRAVEYARD
m_UniqueGfxHeaderStart $2c, UNIQUE_GFXH_BLACK_TOWER_OUTSIDE
m_UniqueGfxHeaderStart $2d, UNIQUE_GFXH_FOREST_OF_TIME
m_UniqueGfxHeaderStart $2e, UNIQUE_GFXH_FAIRY_FOREST
m_UniqueGfxHeaderStart $2f, UNIQUE_GFXH_CRESCENT_ISLAND
m_UniqueGfxHeaderStart $30, UNIQUE_GFXH_SYMMETRY_CITY_RUINED
m_UniqueGfxHeaderStart $31, UNIQUE_GFXH_TALUS_PEAKS
m_UniqueGfxHeaderStart $32, UNIQUE_GFXH_TALUS_PEAKS_PAST
m_UniqueGfxHeaderStart $33, UNIQUE_GFXH_SYMMETRY_CITY_RESTORED
m_UniqueGfxHeaderStart $34, UNIQUE_GFXH_ROLLING_RIDGE_PRESENT
m_UniqueGfxHeaderStart $35, UNIQUE_GFXH_ROLLING_RIDGE_PAST
m_UniqueGfxHeaderStart $36, UNIQUE_GFXH_EYEGLASS_LIBRARY_OUTSIDE
m_UniqueGfxHeaderStart $37, UNIQUE_GFXH_SEA_OF_NO_RETURN
m_UniqueGfxHeaderStart $38, UNIQUE_GFXH_NUUN_HIGHLANDS
m_UniqueGfxHeaderStart $39, UNIQUE_GFXH_AMBIS_PALACE_OUTSIDE
m_UniqueGfxHeaderStart $3a, UNIQUE_GFXH_JABU_JABU_OUTSIDE
m_UniqueGfxHeaderStart $3b, UNIQUE_GFXH_UNDERWATER
m_UniqueGfxHeaderStart $3c, UNIQUE_GFXH_ANCIENT_TOMB_BOSS
	m_GfxHeaderEnd PALH_TILESET_ANCIENT_TOMB_BOSS
