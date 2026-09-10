roomLayoutGroup0Table_ages:
.rept $100 index tmpi
	m_RoomLayoutPointer ages_room{%.4x{tmpi}} ages_room0000
.endr

roomLayoutGroup1Table_ages:
.rept $100 index tmpi
	m_RoomLayoutPointer ages_room{%.4x{tmpi+$100}} ages_room0100
.endr

roomLayoutGroup2Table_ages:
.rept $100 index tmpi
	m_RoomLayoutPointer ages_room{%.4x{tmpi+$200}} ages_room0200
.endr

roomLayoutGroup3Table_ages:
.rept $100 index tmpi
	m_RoomLayoutPointer ages_room{%.4x{tmpi+$300}} ages_room0300
.endr

roomLayoutGroup0Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi}} seasons_room0000
.endr

roomLayoutGroup1Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi+$100}} seasons_room0100
.endr

roomLayoutGroup2Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi+$200}} seasons_room0200
.endr

roomLayoutGroup3Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi+$300}} seasons_room0300
.endr

roomLayoutGroup4Table_seasons:
.rept $100 index tmpi
	m_RoomLayoutPointer seasons_room{%.4x{tmpi+$400}} seasons_room0400
.endr