.if defined(ROM_COMBO)
animationGfxHeaders_ages:
.else
animationGfxHeaders:
.endif
	; waterfall 1
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$040, $02, $000
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$040, $02, $020
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$040, $02, $040
	m_GfxHeaderAnim gfx_animations_1, VRAM_1_TILEDATA_1+$040, $02, $060

	; ocean waves, water, and flowers
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$060, $06, $000
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$060, $06, $060
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$060, $06, $0c0
	m_GfxHeaderAnim gfx_animations_2, VRAM_1_TILEDATA_1+$060, $06, $120

	; polluted water 1
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_1+$0c0, $04, $000
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_1+$0c0, $04, $040
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_1+$0c0, $04, $080
	m_GfxHeaderAnim gfx_animations_3, VRAM_1_TILEDATA_1+$0c0, $04, $0c0

	; whirlpool
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$100, $04, $000
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$100, $04, $040
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$100, $04, $080
	m_GfxHeaderAnim gfx_animations_4, VRAM_1_TILEDATA_1+$100, $04, $0c0

	; water current
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$680, $04, $000
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$680, $04, $040
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$680, $04, $080
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_2+$680, $04, $0c0

	; water current
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $000
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $040
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $080
	m_GfxHeaderAnim gfx_animations_5, VRAM_1_TILEDATA_1+$0c0, $04, $0c0

	; waterfall 2
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6c0, $02, $000
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6c0, $02, $020
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6c0, $02, $040
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6c0, $02, $060

	; waterfall top edge 1
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $080
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $0a0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $0c0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $0e0

	; waterfall top edge 2
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6e0, $02, $080
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6e0, $02, $0a0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6e0, $02, $0c0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$6e0, $02, $0e0

	; waterfall top edge 3
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$300, $02, $080
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$300, $02, $0a0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$300, $02, $0c0
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_2+$300, $02, $0e0

	; waterfall 3
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $100
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $120
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $140
	m_GfxHeaderAnim gfx_animations_6, VRAM_1_TILEDATA_1+$0c0, $02, $160

	; bubbling lava
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_2+$700, $05, $000
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_2+$700, $05, $050
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_2+$700, $05, $0a0
	m_GfxHeaderAnim gfx_animations_7, VRAM_1_TILEDATA_2+$700, $05, $0f0

	; waterfall edge and conveyor
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$040, $08, $000
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$040, $08, $080
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$040, $08, $100
	m_GfxHeaderAnim gfx_animations_8, VRAM_1_TILEDATA_1+$040, $08, $180

	; polluted water 2
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$0c0, $04, $000
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$0c0, $04, $040
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$0c0, $04, $080
	m_GfxHeaderAnim gfx_animations_9, VRAM_1_TILEDATA_1+$0c0, $04, $0c0

	; seaweed
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_2, $08, $000
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_2, $08, $080
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_2, $08, $100
	m_GfxHeaderAnim gfx_animations_10, VRAM_1_TILEDATA_2, $08, $180

	; torch, water, sand, and bubbling lava
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $0b, $000
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $0b, $0b0
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $0b, $160
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $0b, $210

	; waterfall 4
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1b0, $01, $000
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1b0, $01, $010
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1b0, $01, $020
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1b0, $01, $030

	; orb and spike
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1c0, $02, $000
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1c0, $02, $020
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1c0, $02, $040
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1c0, $02, $060

	; water?
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1e0, $02, $080
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1e0, $02, $0a0
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1e0, $02, $0c0
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1e0, $02, $0e0

	; waterfall 5
	m_GfxHeaderAnim gfx_animations_14, VRAM_1_TILEDATA_1+$1c0, $01, $000
	m_GfxHeaderAnim gfx_animations_14, VRAM_1_TILEDATA_1+$1c0, $01, $010
	m_GfxHeaderAnim gfx_animations_14, VRAM_1_TILEDATA_1+$1c0, $01, $020
	m_GfxHeaderAnim gfx_animations_14, VRAM_1_TILEDATA_1+$1c0, $01, $030

	; torch and water
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $04, $000
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $04, $0b0
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $04, $160
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $04, $210

	; conveyor?
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$140, $02, $100
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$140, $02, $120
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$140, $02, $140
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$140, $02, $160

	; blob?
	m_GfxHeaderAnim gfx_animations_15, VRAM_1_TILEDATA_1+$160, $04, $000
	m_GfxHeaderAnim gfx_animations_15, VRAM_1_TILEDATA_1+$160, $04, $040
	m_GfxHeaderAnim gfx_animations_15, VRAM_1_TILEDATA_1+$160, $04, $080
	m_GfxHeaderAnim gfx_animations_15, VRAM_1_TILEDATA_1+$160, $04, $0c0

	; torch, water, and sand?
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $06, $000
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $06, $0b0
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $06, $160
	m_GfxHeaderAnim gfx_animations_11, VRAM_1_TILEDATA_1+$100, $06, $210

	; jabu jabu gut walls
	m_GfxHeaderAnim gfx_animations_16, VRAM_1_TILEDATA_1+$160, $06, $000
	m_GfxHeaderAnim gfx_animations_16, VRAM_1_TILEDATA_1+$160, $06, $060
	m_GfxHeaderAnim gfx_animations_16, VRAM_1_TILEDATA_1+$160, $06, $0c0
	m_GfxHeaderAnim gfx_animations_16, VRAM_1_TILEDATA_1+$160, $06, $120

	; waterfall 6
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1c0, $01, $000
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1c0, $01, $010
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1c0, $01, $020
	m_GfxHeaderAnim gfx_animations_12, VRAM_1_TILEDATA_1+$1c0, $01, $030

	; spikes
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1d0, $01, $010
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1d0, $01, $030
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1d0, $01, $050
	m_GfxHeaderAnim gfx_animations_13, VRAM_1_TILEDATA_1+$1d0, $01, $070

	; misc
	m_GfxHeaderAnim gfx_animations_18, VRAM_1_TILEDATA_1+$500, $0e, $000
	m_GfxHeaderAnim gfx_animations_18, VRAM_1_TILEDATA_1+$500, $0e, $100
	m_GfxHeaderAnim gfx_animations_18, VRAM_1_TILEDATA_1+$500, $0e, $200
	m_GfxHeaderAnim gfx_animations_18, VRAM_1_TILEDATA_1+$500, $0e, $300
