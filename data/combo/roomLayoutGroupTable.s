; Format:
; First byte indicates whether it's a dungeon or not (and consequently what compression it uses)
; 3 byte pointer to a table containing relative offsets for room data for each sector on the map
; 3 byte pointer to the base offset of the actual layout data
roomLayoutGroupTable_ages: ; $4f6c
	.db $01
	3BytePointer roomLayoutGroup0Table_ages
	3BytePointer ages_room0000
	.db $00

	.db $01
	3BytePointer roomLayoutGroup1Table_ages
	3BytePointer ages_room0100
	.db $00

	.db $01
	3BytePointer roomLayoutGroup2Table_ages
	3BytePointer ages_room0200
	.db $00

	.db $01
	3BytePointer roomLayoutGroup3Table_ages
	3BytePointer ages_room0300
	.db $00

	.db $00
	3BytePointer roomLayoutGroup4Table_ages
	3BytePointer ages_room0400
	.db $00

	.db $00
	3BytePointer roomLayoutGroup5Table_ages
	3BytePointer ages_room0500
	.db $00

roomLayoutGroupTable_seasons: ; $4f6c
	.db $01
	3BytePointer roomLayoutGroup0Table_seasons
	3BytePointer seasons_room0000
	.db $00

	.db $01
	3BytePointer roomLayoutGroup1Table_seasons
	3BytePointer seasons_room0100
	.db $00

	.db $01
	3BytePointer roomLayoutGroup2Table_seasons
	3BytePointer seasons_room0200
	.db $00

	.db $01
	3BytePointer roomLayoutGroup3Table_seasons
	3BytePointer seasons_room0300
	.db $00

	.db $01
	3BytePointer roomLayoutGroup4Table_seasons
	3BytePointer seasons_room0400
	.db $00

	.db $00
	3BytePointer roomLayoutGroup5Table_seasons
	3BytePointer seasons_room0500
	.db $00

	.db $00
	3BytePointer roomLayoutGroup6Table_seasons
	3BytePointer seasons_room0600
	.db $00
