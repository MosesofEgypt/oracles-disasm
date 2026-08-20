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