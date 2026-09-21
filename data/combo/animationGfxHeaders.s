.rept 20 index tmpi
	.redefine gfx_animations_{%.1d{tmpi}} {"ages_gfx_animations_{%.1d{tmpi}}"}
.endr

.include "data/ages/animationGfxHeaders.s"

.rept 20 index tmpi
	.redefine gfx_animations_{%.1d{tmpi}} {"seasons_gfx_animations_{%.1d{tmpi}}"}
.endr
.include "data/seasons/animationGfxHeaders.s"

.rept 20 index tmpi
	.undefine gfx_animations_{%.1d{tmpi}}
.endr