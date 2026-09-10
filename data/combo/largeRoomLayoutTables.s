roomLayoutGroup4Table_ages:
.rept $100 index tmpi
	m_RoomLayoutPointer ages_room{%.4x{tmpi+$400}} ages_room0400
.endr

roomLayoutGroup5Table_ages:
.rept $100 index tmpi
	m_RoomLayoutPointer ages_room{%.4x{tmpi+$500}} ages_room0500
.endr

roomLayoutGroup5Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi+$500}} seasons_room0500
.endr

roomLayoutGroup6Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi+$600}} seasons_room0600
.endr