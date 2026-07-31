roomLayoutGroup0Table_ages:
.rept $100 index COUNT
	m_RoomLayoutPointer ages_room{%.4x{COUNT}} ages_room0000
.endr

roomLayoutGroup1Table_ages:
.rept $100 START $100 index COUNT
	m_RoomLayoutPointer ages_room{%.4x{COUNT}} ages_room0100
.endr

roomLayoutGroup2Table_ages:
.rept $100 START $200 index COUNT
	m_RoomLayoutPointer ages_room{%.4x{COUNT}} ages_room0200
.endr

roomLayoutGroup3Table_ages:
.rept $100 START $300 index COUNT
	m_RoomLayoutPointer ages_room{%.4x{COUNT}} ages_room0300
.endr

roomLayoutGroup0Table_seasons:
.rept $100 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0000
.endr

roomLayoutGroup1Table_seasons:
.rept $100 START $100 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0100
.endr

roomLayoutGroup2Table_seasons:
.rept $100 START $200 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0200
.endr

roomLayoutGroup3Table_seasons:
.rept $100 START $300 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0300
.endr

roomLayoutGroup4Table_seasons:
.rept $100 START $400 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0400
.endr