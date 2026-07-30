; Each bit represents whether maple can appear on the corresponding screen
; (0 if she can appear, 1 if she can't)

.ifdef ROM_COMBO
maplePresentLocationsTable_seasons:
	.dw maplePresentLocationsRickyCompanion_seasons
	.dw maplePresentLocationsDimitriCompanion_seasons
	.dw maplePresentLocationsMooshCompanion_seasons
.else
maplePresentLocationsTable:
	.dw maplePresentLocationsRickyCompanion
	.dw maplePresentLocationsDimitriCompanion
	.dw maplePresentLocationsMooshCompanion
.endif

.ifdef ROM_COMBO
maplePresentLocationsRickyCompanion_seasons:
.else
maplePresentLocationsRickyCompanion:
.endif
	dbrev %11111111 %11111111
	dbrev %11011111 %01111111
	dbrev %10011111 %00011111
	dbrev %10111100 %00111111
	dbrev %10110010 %00001111
	dbrev %00111000 %11011111
	dbrev %11110001 %01111111
	dbrev %11100110 %01111011
	dbrev %11110110 %10110110
	dbrev %11110110 %11111111
	dbrev %11100111 %11100111
	dbrev %11111101 %11100111
	dbrev %00001110 %01011111
	dbrev %11101000 %11111111
	dbrev %11110000 %00011111
	dbrev %11111111 %11111111

.ifdef ROM_COMBO
maplePresentLocationsDimitriCompanion_seasons:
.else
maplePresentLocationsDimitriCompanion:
.endif
	dbrev %11111111 %11111111
	dbrev %11011111 %01111111
	dbrev %10011111 %00011111
	dbrev %10111100 %00111111
	dbrev %10110011 %01111111
	dbrev %00111000 %01111111
	dbrev %11110001 %01111111
	dbrev %11100110 %01111011
	dbrev %11110110 %10110110
	dbrev %11110110 %11111111
	dbrev %11100111 %11100111
	dbrev %11111101 %11100111
	dbrev %00001110 %01011111
	dbrev %11101000 %11111111
	dbrev %11110000 %00011111
	dbrev %11111111 %11111111

.ifdef ROM_COMBO
maplePresentLocationsMooshCompanion_seasons:
.else
maplePresentLocationsMooshCompanion:
.endif
	dbrev %11111111 %11111111
	dbrev %11011111 %01111111
	dbrev %10011111 %00011111
	dbrev %10111100 %00111111
	dbrev %10110000 %01111111
	dbrev %00111000 %01111111
	dbrev %11110001 %01110111
	dbrev %11100110 %01111011
	dbrev %11110110 %10110110
	dbrev %11110110 %11111111
	dbrev %11100111 %11100111
	dbrev %11111101 %11100111
	dbrev %00001110 %01011111
	dbrev %11101000 %11111111
	dbrev %11110000 %00011111
	dbrev %11111111 %11111111
