roomLayoutGroup4Table_ages:
.rept $100 START $400 index COUNT
	m_RoomLayoutPointer ages_room{%.4x{COUNT}} ages_room0400
.endr

roomLayoutGroup5Table_ages:
.rept $100 START $500 index COUNT
	m_RoomLayoutPointer ages_room{%.4x{COUNT}} ages_room0500
.endr

roomLayoutGroup5Table_seasons:
.rept $100 START $500 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0500
.endr

roomLayoutGroup6Table_seasons:
.rept $100 START $600 index COUNT
	m_RoomLayoutPointer seasons_room{%.4x{COUNT}} seasons_room0600
.endr