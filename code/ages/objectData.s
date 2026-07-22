	;;
	getObjectDataAddress:
		ld a,(wActiveGroup)
		ld hl,objectDataGroupTable
		rst_addDoubleIndex
		rst_derefHl
		ld a,(wActiveRoom)
		ld e,a
		ld d,$00
		add hl,de
		add hl,de
		ldi a,(hl)
		ld d,(hl)
		ld e,a
		ret