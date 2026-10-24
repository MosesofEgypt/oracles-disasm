;;
; Gets the data for a chest in the current room.
; Defaults to position $00, contents TREASURE_OBJECT_RUPEES_00 if a chest is not found.
;
; @param[out]	bc	Chest contents
; @param[out]	e	Chest position
getChestData:
.if defined(ROM_COMBO)
	ld hl,chestDataGroupTable_seasons
	call wIsSeasons
	jr c,+
		ld hl,chestDataGroupTable_ages
	+
	ld a,(wActiveGroup)
.else
	ld a,(wActiveGroup)
	ld hl,chestDataGroupTable
.endif
	rst_addDoubleIndex
	rst_derefHl
	ld a,(wActiveRoom)
	ld b,a
-
	ldi a,(hl)
	ld e,a
	inc a
	jr nz,+
        ; chest not found
    	ld bc,TREASURE_OBJECT_RUPEES_00
        ret
    +

	ldi a,(hl)
	cp b
	jr z,+

	inc hl
	inc hl
	jr -
+
	ld b,(hl)
	inc hl
	ld c,(hl)
	; if this is the red or blue ore in seasons, replace
	; it with a gold ore chunk if they've been obtained
.if defined(ROM_AGES) || !defined(ENABLE_NEW_GAME_PLUS)
	ret
.else
	.if defined(ROM_COMBO)
		call wIsSeasons
		ret nc
	.endif

	ld a,b
	cp TREASURE_RED_ORE
	jr z,+
		cp TREASURE_BLUE_ORE
		ret nz
	+
	ld a,GLOBALFLAG_GOT_RED_AND_BLUE_ORE
	call checkGlobalFlag
	ret z

	; already have both, so replace
	ld bc,TREASURE_OBJECT_ORE_CHUNKS_01
	ret
.endif