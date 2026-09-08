.include "include/constants.s"
.include "include/rominfo.s"
.include "include/structs.s"
.include "include/macros.s"

.SLOT 1
; "${BUILD_DIR}/textData.s" will determine where this data starts.
.if defined(ROM_COMBO)
; NOTE: These includes define their own .bank and .orga
    .include {"{BUILD_DIR}/ages_textData.s"}
    .include {"{BUILD_DIR}/seasons_textData.s"}
.else
    .include {"{BUILD_DIR}/textData.s"}
.endif

.REDEFINE DATA_ADDR TEXT_END_ADDR
.REDEFINE DATA_BANK TEXT_END_BANK

.include {"{GAME_DATA_DIR}/roomLayoutData.s"}

m_section_superfree Room_Layout_Tables
	.include {"{GAME_DATA_DIR}/smallRoomLayoutTables.s"}
	.include {"{GAME_DATA_DIR}/largeRoomLayoutTables.s"}
.ends