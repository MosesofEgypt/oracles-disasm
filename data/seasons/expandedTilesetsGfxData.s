; For simplicity I'm using the "m_GfxData" macro, which can handle data crossing banks.
; But since each tileset is exactly 0x1000 bytes (and is uncompressed) it doesn't actually
; cross over any banks.

.REPT $1b index tmpi
	.if defined(ROM_COMBO)
		m_GfxData seasons_gfx_tileset{%.2x{tmpi}}_spring
		m_GfxData seasons_gfx_tileset{%.2x{tmpi}}_summer
		m_GfxData seasons_gfx_tileset{%.2x{tmpi}}_autumn
		m_GfxData seasons_gfx_tileset{%.2x{tmpi}}_winter
	.else
		m_GfxData gfx_tileset{%.2x{tmpi}}_spring
		m_GfxData gfx_tileset{%.2x{tmpi}}_summer
		m_GfxData gfx_tileset{%.2x{tmpi}}_autumn
		m_GfxData gfx_tileset{%.2x{tmpi}}_winter
	.endif
.ENDR

.REPT $80-$1b index tmpi
	.if defined(ROM_COMBO)
		m_GfxData seasons_gfx_tileset{%.2x{tmpi+$1b}}
	.else
		m_GfxData gfx_tileset{%.2x{tmpi+$1b}}
	.endif
.ENDR