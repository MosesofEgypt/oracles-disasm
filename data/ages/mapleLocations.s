; Each bit represents whether maple can appear on the corresponding screen 
; (0 if she can appear, 1 if she can't)

.ifdef ROM_COMBO
maplePresentLocationsTable_ages:
	.dw maplePresentLocationsRickyCompanion_ages
	.dw maplePresentLocationsDimitriCompanion_ages
	.dw maplePresentLocationsMooshCompanion_ages
.else
maplePresentLocationsTable:
	.dw maplePresentLocationsRickyCompanion
	.dw maplePresentLocationsDimitriCompanion
	.dw maplePresentLocationsMooshCompanion
.endif

.ifdef ROM_COMBO
maplePresentLocationsRickyCompanion_ages:
.else
maplePresentLocationsRickyCompanion:
.endif
	dbrev %10010100 %11111111
	dbrev %11010011 %11011111
	dbrev %10111111 %11000111
	dbrev %11011111 %11100011
	dbrev %01110111 %11000011
	dbrev %11111111 %10111111
	dbrev %00111111 %10111011
	dbrev %11111111 %11111011
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111

.ifdef ROM_COMBO
maplePresentLocationsDimitriCompanion_ages:
.else
maplePresentLocationsDimitriCompanion:
.endif
	dbrev %10010100 %11111111
	dbrev %11010011 %11011111
	dbrev %10111111 %11000111
	dbrev %11011111 %11100011
	dbrev %01110111 %11000011
	dbrev %11111111 %10111111
	dbrev %00111111 %10111011
	dbrev %11111111 %11111011
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111

.ifdef ROM_COMBO
maplePresentLocationsMooshCompanion_ages:
.else
maplePresentLocationsMooshCompanion:
.endif
	dbrev %10010100 %11111111
	dbrev %11010011 %11011111
	dbrev %10111111 %11000111
	dbrev %11011111 %11100011
	dbrev %01110111 %11000011
	dbrev %11111111 %10111111
	dbrev %00111111 %10111011
	dbrev %11111111 %11111011
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111

maplePastLocations:
	dbrev %11010111 %11111111
	dbrev %00010111 %01011111
	dbrev %10111111 %01000111
	dbrev %01010111 %11011111
	dbrev %11111111 %11111011
	dbrev %11111111 %10111111
	dbrev %00010111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
	dbrev %11111111 %11111111
