; This is a list of tiles that can be landed on when jumping down a cliff, despite being
; solid. It is a list of tiles ending with the byte $00.
.ifdef ROM_COMBO
landableTileFromCliffExceptions_ages:
.else
landableTileFromCliffExceptions:
.endif
	.dw @overworld
	.dw @indoors
	.dw @dungeons
	.dw @sidescrolling
	.dw @underwater
	.dw @five

@indoors:
@dungeons:
@five:
	.db TILEINDEX_RAISABLE_FLOOR_1 TILEINDEX_RAISABLE_FLOOR_2
@overworld:
@sidescrolling:
@underwater:
	.db $00
