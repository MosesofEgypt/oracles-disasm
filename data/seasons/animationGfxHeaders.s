.if defined(ROM_COMBO)
animationGfxHeaders_seasons:
.else
animationGfxHeaders:
.endif
	; water and flowers
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$080, $04, $140
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$080, $04, $180
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$080, $04, $1c0
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$080, $04, $200

	; ocean waves 2
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $02, $020
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $02, $060
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $02, $0a0
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $02, $0e0

	; ocean waves 1
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_2+$600, $04, $000
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_2+$600, $04, $040
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_2+$600, $04, $080
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_2+$600, $04, $0c0

	; ocean waves 1
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $000
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $040
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $080
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $0c0

	; waterfall and waterfal edge
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$0c0, $04, $240
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$0c0, $04, $280
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$0c0, $04, $2c0
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$0c0, $04, $300

	; torch
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$680, $02, $000
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$680, $02, $020
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$680, $02, $040
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$680, $02, $060

	; torch
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$630, $02, $000
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$630, $02, $020
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$630, $02, $040
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_2+$630, $02, $060

	; quicksand
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $100
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $140
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $180
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$0c0, $04, $1c0

	; water current
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $000
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $040
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $080
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $0c0

	; water current
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$380, $04, $000
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$380, $04, $040
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$380, $04, $080
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$380, $04, $0c0

	; lava bubbling
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$0a0, $05, $020
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$0a0, $05, $0b0
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$0a0, $05, $140
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$0a0, $05, $1d0

	; waterfall
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $02, $000
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $02, $090
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $02, $120
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $02, $1b0

	; waterfall
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $04, $000
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $04, $090
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $04, $120
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$080, $04, $1b0

	; biggoron mouth
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$080, $08, $040
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$080, $08, $0c0

	; blank?
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_2+$090, $01, $000
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_2+$090, $01, $010
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_2+$090, $01, $020
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_2+$090, $01, $030

	; lava bubbling and flowers
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$580, $07, $000
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$580, $07, $100
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$580, $07, $200
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$580, $07, $300

	; waterfall
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$5f0, $01, $070
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$5f0, $01, $170
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$5f0, $01, $270
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$5f0, $01, $370

	; ocean sand
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $01, $080
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $01, $180
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $01, $280
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $01, $380

	; ocean sand and waves
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $05, $080
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $05, $180
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $05, $280
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$700, $05, $380
	
	; torch, water, and lava
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$100, $0b, $000
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$100, $0b, $0b0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$100, $0b, $160
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$100, $0b, $210

	; waterfall
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1b0, $01, $000
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1b0, $01, $010
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1b0, $01, $020
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1b0, $01, $030

	; orb and spike
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1c0, $02, $040
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1c0, $02, $060
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1c0, $02, $080
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1c0, $02, $0a0

	; water and rupee
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1e0, $02, $0c0
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1e0, $02, $0e0
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1e0, $02, $100
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_1+$1e0, $02, $120

	; rupee
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$1e0, $02, $000
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$1e0, $02, $020
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$1e0, $02, $040
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$1e0, $02, $060

	; misc animations 2
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_1+$500, $0e, $000
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_1+$500, $0e, $100
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_1+$500, $0e, $200
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_1+$500, $0e, $300

