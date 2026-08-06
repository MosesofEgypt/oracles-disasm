; TODO: Synchronize with Ages version of file
.ifdef ROM_COMBO
applyAllTileSubstitutions_seasons:
.else
applyAllTileSubstitutions:
.endif
	call applySingleTileChanges
.ifdef ROM_COMBO
	call applyStandardTileSubstitutions_seasons
.else
	call applyStandardTileSubstitutions
.endif
	call replaceOpenedChest
	ld a,(wActiveGroup)
	cp $02
	jr z,++
	cp NUM_SMALL_GROUPS
	jr nc,+
	; groups 0,1,3
	call loadSubrosiaObjectGfxHeader
.ifdef ROM_COMBO
	jp applyRoomSpecificTileChanges_seasons
.else
	jp applyRoomSpecificTileChanges
.endif
+
	; groups 4,5,6,7
	call replaceShutterForLinkEntering
	call replaceSwitchTiles
.ifdef ROM_COMBO
	jp applyRoomSpecificTileChanges_seasons
.else
	jp applyRoomSpecificTileChanges
.endif
++
	; group 2
	ld e,OBJ_GFXH_04-1
	jp loadObjectGfxHeaderToSlot4

loadSubrosiaObjectGfxHeader:
	ld a,(wMinimapGroup)
	cp $01
	ret nz
	ld e,OBJ_GFXH_07-1
	jp loadObjectGfxHeaderToSlot4

;;
; @param de Structure for tiles to replace
; (format: tile to replace with, tile to replace, repeat, $00 to end)
.ifdef ROM_COMBO
replaceTiles_seasons:
.else
replaceTiles:
.endif
	ld a,(de)
	or a
	ret z
	ld b,a
	inc de
	ld a,(de)
	inc de
	call findTileInRoom
.ifdef ROM_COMBO
	jr nz,replaceTiles_seasons
.else
	jr nz,replaceTiles
.endif
	ld (hl),b
	ld c,a
	ld a,l
	or a
.ifdef ROM_COMBO
	jr z,replaceTiles_seasons
.else
	jr z,replaceTiles
.endif
-
	dec l
	ld a,c
	call backwardsSearch
.ifdef ROM_COMBO
	jr nz,replaceTiles_seasons
.else
	jr nz,replaceTiles
.endif
	ld (hl),b
	ld c,a
	ld a,l
	or a
.ifdef ROM_COMBO
	jr z,replaceTiles_seasons
.else
	jr z,replaceTiles
.endif
	jr -

.ifdef ROM_COMBO
applyStandardTileSubstitutions_seasons:
	call getThisRoomFlags
	ldh (<hFF8B),a

	ld hl,standardTileSubstitutions_seasons@bit0
	bit 0,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions_seasons@bit1
	ldh a,(<hFF8B)
	bit 1,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions_seasons@bit2
	ldh a,(<hFF8B)
	bit 2,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions_seasons@bit3
	ldh a,(<hFF8B)
	bit 3,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions_seasons@bit7
.else
applyStandardTileSubstitutions:
	call getThisRoomFlags
	ldh (<hFF8B),a
	ld hl,standardTileSubstitutions@bit0
	bit 0,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit1
	ldh a,(<hFF8B)
	bit 1,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit2
	ldh a,(<hFF8B)
	bit 2,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit3
	ldh a,(<hFF8B)
	bit 3,a
	call nz,@locFunc

	ld hl,standardTileSubstitutions@bit7
.endif
	ldh a,(<hFF8B)
	bit 7,a
	ret z
@locFunc:
	ld a,(wActiveGroup)
	rst_addDoubleIndex
	rst_derefHl
	ld e,l
	ld d,h
.ifdef ROM_COMBO
	jr replaceTiles_seasons
.else
	jr replaceTiles
.endif

.ifndef ROM_COMBO
.include {"{GAME_DATA_DIR}/tile_properties/standardTileSubstitutions.s"}
.include "code/commonTileSubstitutions.s"
.endif