dungeonRoomPropertiesGroupTable:

.if defined(ROM_COMBO)
	.dw dungeonRoomPropertiesGroup4Data_ages
	.dw dungeonRoomPropertiesGroup5Data_ages
	.dw dungeonRoomPropertiesGroup4Data_seasons
	.dw dungeonRoomPropertiesGroup5Data_seasons

	dungeonRoomPropertiesGroup4Data_ages:
		m_IncRoomData ages group4DungeonProperties.bin
	dungeonRoomPropertiesGroup5Data_ages:
		m_IncRoomData ages group5DungeonProperties.bin

	dungeonRoomPropertiesGroup4Data_seasons:
		m_IncRoomData seasons group4DungeonProperties.bin
	dungeonRoomPropertiesGroup5Data_seasons:
		m_IncRoomData seasons group5DungeonProperties.bin
.else
	.dw dungeonRoomPropertiesGroup4Data
	.dw dungeonRoomPropertiesGroup5Data

	.if defined(ROM_AGES)
		dungeonRoomPropertiesGroup4Data:
			m_IncRoomData ages group4DungeonProperties.bin
		dungeonRoomPropertiesGroup5Data:
			m_IncRoomData ages group5DungeonProperties.bin
	.else
		dungeonRoomPropertiesGroup4Data:
			m_IncRoomData seasons group4DungeonProperties.bin
		dungeonRoomPropertiesGroup5Data:
			m_IncRoomData seasons group5DungeonProperties.bin
	.endif
.endif