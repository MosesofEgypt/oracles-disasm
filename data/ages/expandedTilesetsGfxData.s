; For simplicity I'm using the "m_GfxData" macro, which can handle data crossing banks.
; But since each tileset is exactly 0x1000 bytes (and is uncompressed) it doesn't actually
; cross over any banks.

.REPT $80 index tmpi
	m_GfxData gfx_tileset{%.2x{tmpi}}
.ENDR