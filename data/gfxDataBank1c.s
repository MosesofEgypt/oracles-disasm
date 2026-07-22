; The first $e characters of gfx_font are blank, so they aren't
; included in the rom. In order to get the offsets correct, use
; gfx_font_start as the label instead of gfx_font.

m_ReadGfxDataHashedFilename gfx_font
.define gfx_font_start {filename}-$e0
.export gfx_font_start

m_GfxDataSimple gfx_font_jp ; $70000
m_GfxDataSimple gfx_font_tradeitems ; $70600
m_GfxDataSimple gfx_font $e0 ; $70800
m_GfxDataSimple gfx_font_heartpiece ; $71720

m_GfxDataSimple map_rings ; $717a0

.ifdef ENABLE_DOUBLE_HEART_CAP
	m_GfxDataSimple gfx_overlap_hearts
.endif