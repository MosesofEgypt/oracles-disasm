.include "include/constants.s"
.include "include/rominfo.s"
.include "include/structs.s"
.include "include/macros.s"
.include "include/gfxDataMacros.s"

.SLOT 1
; HACK-BASE: Expanded tileset data
.include {"{GAME_DATA_DIR}/expandedTilesets.s"}


.REDEFINE DATA_ADDR $4000
.if defined(I_LIKE_BIG_ROMS_AND_I_CANNOT_LIE_GFX)
	.REDEFINE DATA_BANK MIN_RAWDATA_BANK_NUM
.elif defined(ROM_COMBO)
	.REDEFINE DATA_BANK $70
.else
	.REDEFINE DATA_BANK $40
.endif


.BANK DATA_BANK SLOT 1
.ORG 0
	.include {"{GAME_DATA_DIR}/gfxDataMain.s"}
	.include {"{GAME_DATA_DIR}/expandedTilesetsGfxData.s"}