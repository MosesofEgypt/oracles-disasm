;;
initGbaModePaletteData:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w2GbaModePaletteData
	ld ($ff00+R_SVBK),a

	ld hl,gbaModePaletteData
	ld de,w2GbaModePaletteData
	ld b,$80
	call copyMemory

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; Redraw dirty palettes
refreshDirtyPalettes:
	ld a,$02
	ld ($ff00+R_SVBK),a

	ldh a,(<hDirtyBgPalettes)
	ld d,a
	ldh a,(<hBgPaletteSources)
	ld e,a
	ld l,<w2TilesetBgPalettes
	call @refresh

	ldh a,(<hDirtySprPalettes)
	ld d,a
	ldh a,(<hSprPaletteSources)
	ld e,a
	ld l,<w2TilesetSprPalettes
;;
; @param d Bitset of dirty palettes
; @param e Bitset of where to get the palettes from
; @param l $80 for background, $c0 for sprites
@refresh:
	ld a,d
	or a
	ret z

	srl d
	jr nc,@nextPalette

	ld h,>w2TilesetBgPalettes
	srl e
	jr nc,+

	; h = >w2FadingBgPalettes (or equivalently, >w2FadingSprPalettes)
	inc h
+
	ldh a,(<hGameboyType)
	inc a
	jr nz,@gbcMode

@gbaMode:
	call @gbaBrightenPalette
	call @gbaBrightenPalette
	call @gbaBrightenPalette
	call @gbaBrightenPalette
	jr @refresh

@gbcMode:
	push de
	ld b,>w2BgPalettesBuffer
	ld c,l
	res 7,c
.ifdef ENABLE_RING_REDUX
	push bc
.endif
	ld e,$08
-
	ldi a,(hl)
	ld (bc),a
	inc c
	dec e
	jr nz,-
.ifdef ENABLE_RING_REDUX
	; maybe make palettes monochrome green
	ld a,DMG_COLOR_RING
	call cpActiveRing
	pop bc
	jr nz,+
		push hl
		ld h,b
		ld l,c
		call @convertToDmgColor
		call @convertToDmgColor
		call @convertToDmgColor
		call @convertToDmgColor
		pop hl
	+
.endif

	pop de
	jr @refresh

@nextPalette:
	ld a,l
	add $08
	ld l,a
	srl e
	jr @refresh

;;
@gbaBrightenPalette:
.ifdef ENABLE_RING_REDUX
	; maybe make palettes monochrome green
	ld a,DMG_COLOR_RING
	call cpActiveRing
	jr nz,+
		; backup color for restoring later and then convert
		push de
		push hl
		ldi a,(hl)
		ld b,a
		ldd a,(hl)
		ld c,a
		push bc
		call @convertToDmgColor
		dec l
		dec l
	+
.endif
	ldi a,(hl)
	ld c,a
	and $e0
	ld b,a
	ld a,(hl)
	and $03
	or b
	swap a
	ld b,a
	ldd a,(hl)
	and $7c
	rrca
	rrca
	push hl
	ld hl,w2GbaModePaletteData+$60
	rst_addAToHl
	ld a,b
	ld b,(hl)
	ld hl,w2GbaModePaletteData+$21
	rst_addAToHl
	ldd a,(hl)
	or b
	ld b,a
	ld a,c
	and $1f
	ld c,(hl)
	ld hl,w2GbaModePaletteData
	rst_addAToHl
	ld a,(hl)
	or c
	pop hl
	ld c,h
	res 7,l
	ld h,$df
	ldi (hl),a
	ld a,b
	ldi (hl),a
	set 7,l
	ld h,c
.ifdef ENABLE_RING_REDUX
	ld a,DMG_COLOR_RING
	call cpActiveRing
	jr nz,+
		; restore color
		pop bc
		ld d,h
		ld e,l
		pop hl
		ld (hl),b
		inc l
		ld (hl),c
		ld h,d
		ld l,e
		pop de
	+
.endif
	ret

.ifdef ENABLE_RING_REDUX
@convertToDmgColor:
	ldi a,(hl)
	and $e0
	ld b,a
	ld a,(hl)
	and $03
	or b
	swap a
	ld b,a
	srl b
	ldd a,(hl)
	and $7c
	rrca
	rrca
	ld c,a
	ld a,(hl)
	and $1f

	; a now contains red, b contains green, c contains blue
	push hl
	push af

	; convert RGB into luminance
	ld a,b
	rra
	ld hl,@greenConvTable
	rst_addAToHl
	ld b,(hl)

	ld a,c
	rra
	ld hl,@blueConvTable
	rst_addAToHl
	ld c,(hl)

	pop af
	rra
	ld hl,@redConvTable
	rst_addAToHl
	ld a,(hl)

	; add together to get total luminance
	add b
	add c

	; convert luminance to equivalent DMG color
	ld hl,@dmgColorTable
	; reduce fidelity from 32 values to 8 to reduce table size
	srl a
	srl a
	add a
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld a,(hl)
	pop hl

	; replace the colors
	ld (hl),b
	inc l
	ld (hl),a
	inc l
	ret

@redConvTable:
	.db $00 $00 $01 $01 $02 $03 $03 $04
	.db $04 $05 $06 $06 $07 $07 $08 $09

@greenConvTable:
	.db $00 $01 $02 $03 $04 $06 $07 $08
	.db $09 $0a $0c $0d $0e $0f $10 $12

@blueConvTable:
	.db $00 $00 $00 $01 $01 $01 $01 $02
	.db $02 $02 $03 $03 $03 $04 $04 $04

@dmgColorTable:
	; colors are RGB555 LE with high bit ignored, and R in lower bits
	; NOTE: leaving the full palette in here in case i decide
	;       it's necessary to go back to 16 instead of 8.
	.dw (( 1<<10)|( 5<<5)| 2)
	;.dw (( 1<<10)|( 7<<5)| 2)
	.dw (( 1<<10)|( 8<<5)| 3)
	;.dw (( 1<<10)|( 9<<5)| 4)
	.dw (( 2<<10)|(11<<5)| 5)
	;.dw (( 3<<10)|(12<<5)| 7)
	.dw (( 4<<10)|(13<<5)| 9)
	;.dw (( 5<<10)|(15<<5)|11)
	.dw (( 6<<10)|(16<<5)|14)
	;.dw (( 6<<10)|(16<<5)|15)
	.dw (( 7<<10)|(17<<5)|16)
	;.dw (( 7<<10)|(18<<5)|17)
	.dw (( 8<<10)|(19<<5)|18)
	;.dw (( 8<<10)|(21<<5)|19)
	.dw (( 9<<10)|(22<<5)|21)
	;.dw ((10<<10)|(24<<5)|22)

.endif

gbaModePaletteData:
	.db $00 $05 $07 $08 $0a $0b $0c $0e
	.db $10 $11 $12 $13 $14 $15 $16 $17
	.db $18 $19 $1a $1b $1b $1c $1c $1d
	.db $1d $1e $1e $1e $1f $1f $1f $1f
	.db $00 $00 $a0 $00 $e0 $00 $00 $01
	.db $40 $01 $60 $01 $80 $01 $c0 $01
	.db $00 $02 $20 $02 $40 $02 $60 $02
	.db $80 $02 $a0 $02 $c0 $02 $e0 $02
	.db $00 $03 $20 $03 $40 $03 $60 $03
	.db $60 $03 $80 $03 $80 $03 $a0 $03
	.db $a0 $03 $c0 $03 $c0 $03 $c0 $03
	.db $e0 $03 $e0 $03 $e0 $03 $e0 $03
	.db $00 $14 $1c $20 $28 $2c $30 $38
	.db $40 $44 $48 $4c $50 $54 $58 $5c
	.db $60 $64 $68 $6c $6c $70 $70 $74
	.db $74 $78 $78 $78 $7c $7c $7c $7c

;;
resumeThreadNextFrameIfLcdIsOn:
	ld a,($ff00+R_LCDC)
	rlca
	ret nc

	call resumeThreadNextFrameAndSaveBank
	ret

;;
; Goes through wLoadedObjectGfx, and reloads each entry. This is called when closing
; the inventory screen and things like that.
reloadObjectGfx:
	ld a,(wLoadedItemGraphic1)
	or a
	call nz,loadUncompressedGfxHeader

	ld a,(wLoadedItemGraphic2)
	or a
	call nz,loadUncompressedGfxHeader
agesFunc_3f_4133:
	ld hl,wLoadedObjectGfx
--
	ldi a,(hl)
	ld e,a
	ld d,(hl)
	dec l
	or a
	jr z,+

	call insertIndexIntoLoadedObjectGfx
	call resumeThreadNextFrameIfLcdIsOn
+
	inc l
	ld (hl),d
	inc l
	ld a,l
	cp <wLoadedObjectGfxEnd
	jr c,--

	; Also reload the tree graphics

	ld hl,wLoadedTreeGfxActive
	ld e,(hl)
	ld (hl),$00
	jp loadTreeGfx_body

;;
refreshObjectGfx_body:
	call markAllLoadedObjectGfxUnused

	; Re-check which object gfx indices are in use by checking all objects of
	; all types.

	; Check enemies
	ld d,FIRST_ENEMY_INDEX
@nextEnemy:
	call enemyGetObjectGfxIndex
	call markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Check parts
	ld d,FIRST_PART_INDEX
@nextPart:
	call partGetObjectGfxIndex
	call markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,@nextPart

	; Check interactions
	ld d,FIRST_INTERACTION_INDEX
@nextInteraction:
	call interactionGetObjectGfxIndex
	call markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_INTERACTION_INDEX+1
	jr c,@nextInteraction

	; Check items
	ld d,FIRST_ITEM_INDEX
@nextItem:
	call itemGetObjectGfxIndex
	call markLoadedObjectGfxUsed
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@nextItem

; Now check whether to load extra gfx for an interaction or enemy.

	ld a,(wEnemyIDToLoadExtraGfx)
	or a
	jr z,+

	call getObjectGfxIndexForEnemy
	jr ++
+
	ld hl,wInteractionIDToLoadExtraGfx
	ldi a,(hl)
	or a
	ret z
	ld e,(hl)
	ld (hl),$00
	call getDataForInteraction
	ld a,(hl)
++
	call addIndexToLoadedObjectGfx
	call resumeThreadNextFrameIfLcdIsOn
	ld a,e
	call findIndexInLoadedObjectGfx
	ld a,l
	sub <wLoadedObjectGfx
	srl a

@nextExtraGfxIndex:
	inc a
	and $07
	ld b,a
	ld hl,wLoadedObjectGfx+1
	rst_addDoubleIndex

	; Remember old values, they may need to be moved to another spot
	ldd a,(hl)
	ld d,a
	ld c,(hl)
	inc e

	; Load the next gfx index
	call insertIndexIntoLoadedObjectGfx

	; If there was something here before, reload it into another slot
	ld a,d
	or a
	jr z,+
	ld a,c
	push de
	call addIndexToLoadedObjectGfx
	pop de
+
	call updateTileIndexBaseForAllObjects

	; Check if bit 7 in the second parameter of objectGfxHeaderTable is set (indicating
	; the end of the data)
	ld d,$00
	ld hl,objectGfxHeaderTable+1
	add hl,de
	add hl,de
	add hl,de
	bit 7,(hl)
	ld a,b
	jr z,@nextExtraGfxIndex

	ld (wLoadedObjectGfxIndex),a
	xor a
	ld (wEnemyIDToLoadExtraGfx),a
	ld (wInteractionIDToLoadExtraGfx),a
	jp incLoadedObjectGfxIndex

;;
; Forces an object gfx header to be loaded into slot 4 (address 0:8800). Handy way to load
; extra graphics, but uses up object slots. Used by the pirate ship and various things in
; seasons, but apparently unused in ages.
;
; @param	e	Object gfx header (minus 1)
loadObjectGfxHeaderToSlot4_body:
	push de
	call refreshObjectGfx_body
	pop de
	ld a,$03
	jr refreshObjectGfx_body@nextExtraGfxIndex

;;
; @param	e	Tree gfx index
loadTreeGfx_body:
	ld hl,wLoadedTreeGfxActive
	ld a,e
	cp (hl)
	ret z

	call insertIndexIntoLoadedObjectGfx
	jp resumeThreadNextFrameIfLcdIsOn

;;
updateTileIndexBaseForAllObjects:
	push bc
	push de
	push hl

	; Enemies
	ld a,Enemy.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_ENEMY_INDEX
@nextEnemy:
	call enemyGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,@nextEnemy

	; Parts
	ld a,Part.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_PART_INDEX
@nextPart:
	call partGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_PART_INDEX+1
	jr c,@nextPart

	; Interactions
	ld a,Interaction.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_DYNAMIC_INTERACTION_INDEX
@nextInteraction:
	call interactionGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_INTERACTION_INDEX+1
	jr c,@nextInteraction

	; Items
	ld a,Item.enabled
	ldh (<hActiveObjectType),a
	ld d,FIRST_ITEM_INDEX
@nextItem:
	call itemGetObjectGfxIndex
	call @updateTileIndexBase
	inc d
	ld a,d
	cp LAST_ITEM_INDEX+1
	jr c,@nextItem

	call drawAllSpritesUnconditionally
	call resumeThreadNextFrameIfLcdIsOn
	pop hl
	pop de
	pop bc
	ret

;;
; Updates the oamTileIndexBase for an object (after graphics may have changed places).
;
; @param	a	Object gfx index
; @param	d	Object index
@updateTileIndexBase:
	or a
	ret z

	call findIndexInLoadedObjectGfx
	ldh a,(<hActiveObjectType)
	ld e,a
	ld a,(de)
	or a
	ret z

	; If sprite uses vram bank 1, don't readjust oamTileIndexBase
	ld a,e
	add Object.oamFlags
	ld e,a
	ld a,(de)
	bit 3,a
	ret nz

	; e = Object.oamTileIndexBase
	inc e
	ld a,(de)
	and $1f
	add c
	ld (de),a
	ret

;;
; Finds the given object gfx index in wLoadedObjectGfx and marks it as in use, or
; sets the carry flag if it's not found.
;
; @param	a	Object gfx index
; @param[out]	c
; @param[out]	hl	Address where gfx is loaded (if it is loaded)
; @param[out]	cflag	nc if index is loaded
findIndexInLoadedObjectGfx:
	or a
	ret z

	ld hl,wLoadedObjectGfx
	ld b,$08
	ld c,a
--
	ldi a,(hl)
	cp c
	jr z,+

	inc l
	dec b
	jr nz,--

	ld c,$01
	scf
	ret
+
	ld (hl),$01
	dec l
	ld a,l
	sub <wLoadedObjectGfx
	swap a
	ld c,a
	ret

;;
; Gets the first unused entry of wLoadedObjectGfx it finds?
; @param[out]	c	Relative position in wLoadedObjectGfx which is free
; @param[out]	hl
; @param[out]	cflag	Set on failure.
findUnusedIndexInLoadedObjectGfx:
	ld b,$08
--
	call getAddressOfLoadedObjectGfxIndex
	inc l
	ldd a,(hl)
	or a
	jr z,+

	call incLoadedObjectGfxIndex
	dec b
	jr nz,--

	ld c,$01
	scf
	ret
+
	ld a,l
	sub <wLoadedObjectGfx
	swap a
	ld c,a
	ret

;;
incLoadedObjectGfxIndex:
	ld a,(wLoadedObjectGfxIndex)
	inc a
	and $07
	ld (wLoadedObjectGfxIndex),a
	ret

;;
; Gets an address in wLoadedObjectGfx based on wLoadedObjectGfxIndex.
getAddressOfLoadedObjectGfxIndex:
	ld a,(wLoadedObjectGfxIndex)
	ld hl,wLoadedObjectGfx
	rst_addDoubleIndex
	ret

;;
; Adds the given index into wLoadedObjectGfx if it's not in there already.
;
; @param	a	Object gfx index
; @param[out]	a	Relative position where it's placed in wLoadedObjectGfx
; @param[out]	cflag	Set if graphics were queued to be loaded and lcd is
;			currently on
addIndexToLoadedObjectGfx:
	or a
	ret z

	push hl
	push bc
	ld e,a
	call findIndexInLoadedObjectGfx
	jr nc,+

	call findUnusedIndexInLoadedObjectGfx
	call nc,insertIndexIntoLoadedObjectGfx
+
	ld a,c
	pop bc
	pop hl
	ret

;;
; Adds index "e" into the wLoadedObjectGfx buffer at the specified position, or into
; wLoadedTreeGfx if that's what hl is pointing to.
;
; Also performs the actual loading of the gfx, and removes any duplicates in
; the list.
;
; @param	e	Object gfx index
; @param	hl	Address in wLoadedObjectGfx?
insertIndexIntoLoadedObjectGfx:
	ld a,l
	cp <wLoadedTreeGfxActive
	jr nc,++

	; First, remove any references to it if it's already loaded (to prevent
	; redundancy)
	push hl
	ld hl,wLoadedObjectGfx
-
	ldi a,(hl)
	cp e
	jr nz,+

	xor a
	ldd (hl),a
	ldi (hl),a
+
	inc l
	ld a,l
	cp <wLoadedObjectGfxEnd
	jr c,-

	pop hl
++
	push bc
	push de
	push hl
	ld (hl),e
	inc l
	ld (hl),$01
	dec l
	ld a,l
	cp <wLoadedTreeGfxActive
	jr c,@object

@tree:
	ld b,$92
	ld hl,treeGfxHeaderTable
	jr ++

@object:
	sub <wLoadedObjectGfx
	or $80
	ld b,a
	ld hl,objectGfxHeaderTable
++
	ld d,$00
	add hl,de
	add hl,de
	add hl,de
	call loadObjectGfx
	pop hl
	pop de
	pop bc
	ret

;;
; Mark a particular object gfx index as used. This doesn't insert the index into
; wLoadedObjectGfx if it's not found, though.
; @param a Object gfx index to mark as used
markLoadedObjectGfxUsed:
	or a
	ret z

	push bc
	push hl
	ld hl,wLoadedObjectGfx
	ld c,a
-
	ldi a,(hl)
	cp c
	jr z,@found

	inc l
	ld a,l
	cp <wLoadedObjectGfxEnd
	jr c,-

	jr @end

@found:
	ld (hl),$01
@end:
	pop hl
	pop bc
	ret

;;
; Sets the 2nd byte of every entry in the wLoadedObjectGfx buffer to $00,
; indicating that they are not being used.
markAllLoadedObjectGfxUnused:
	push bc
	push hl
	ld hl,wLoadedObjectGfx
	ld b,$08
	xor a
-
	inc l
	ldi (hl),a
	dec b
	jr nz,-

	pop hl
	pop bc
	ret

;;
; Get an enemy's gfx index, as well as a pointer to the rest of its data.
; @param[out]	a	Object gfx index
; @param[out]	hl	Pointer to 3 more bytes of enemy data
enemyGetObjectGfxIndex:
	ld e,Enemy.id
	ld a,(de)

;;
; @param	a	Enemy ID
getObjectGfxIndexForEnemy:
	push bc
	add a
	ld c,a
	ld b,$00
	ld hl,enemyData
	add hl,bc
	add hl,bc
	pop bc
	ldi a,(hl)
	ret

;;
; @param[out]	a	Object gfx index
; @param[out]	hl	Pointer to 7 more bytes of part data
partGetObjectGfxIndex:
	push bc
	ld e,Part.id
	ld a,(de)
	call multiplyABy8
	ld hl,partData
	add hl,bc
	pop bc
	ldi a,(hl)
	ret

;;
interactionGetObjectGfxIndex:
	push bc
	call interactionGetData
	pop bc
	ldi a,(hl)
	ret

;;
itemGetObjectGfxIndex:
	ld e,Item.id
	ld a,(de)

	; a *= 3
	ld l,a
	add a
	add l

	ld hl,itemData
	rst_addAToHl
	ldi a,(hl)
	ret

;;
; Loading an enemy?
enemyLoadGraphicsAndProperties:
	call enemyGetObjectGfxIndex
	call addIndexToLoadedObjectGfx
	ld c,a
	call c,resumeThreadNextFrameIfLcdIsOn
	ld e,Enemy.id
	ld a,(de)
	ld e,Enemy.collisionType
	bit 7,(hl)
	jr z,+
	set 7,a
+
	ld (de),a

	; e = Enemy.enemyCollisionMode
	inc e
	ldi a,(hl)
	and $7f
	ld (de),a
	bit 7,(hl)
	jr z,+

	; If bit 7 is set, read the next 2 bytes as the address of a table.
	; Each entry in the table is for a particular subID. hl will be set to
	; [the table's start address] + (subID*2), or the first entry without
	; bit 7 set, whichever comes first.
	ldi a,(hl)
	and $7f
	ld l,(hl)
	ld h,a
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	ld e,$00
-
	bit 7,(hl)
	jr z,+

	ld a,e
	cp b
	jr z,+

	inc hl
	inc hl
	inc e
	jr -
+
	ldi a,(hl)
	push hl
	add a
	ld hl,extraEnemyData
	rst_addDoubleIndex
	ld e,$a6
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a
	pop hl
	ld a,(hl)
	and $0f
	add a
	add c
	ld e,Enemy.oamTileIndexBase
	ld (de),a
	ld a,(hl)
	swap a
	and $0f
	dec e
	ld (de),a
	dec e
	ld (de),a
	xor a
	jp enemySetAnimation

;;
; Loading a part?
partLoadGraphicsAndProperties:
	call partGetObjectGfxIndex
	call addIndexToLoadedObjectGfx
	ld c,a
	call c,resumeThreadNextFrameIfLcdIsOn
	ld e,Part.id
	ld a,(de)
	bit 7,(hl)
	jr z,+
	set 7,a
+
	ld e,Part.collisionType
	ld (de),a

	; e = Part.enemyCollisionMode
	inc e
	ldi a,(hl)
	and $7f
	ld (de),a

	; e = Part.collisionRadiusY
	inc e
	ld a,(hl)
	swap a
	and $0f
	ld (de),a

	; e = Part.collisionRadiusX
	inc e
	ldi a,(hl)
	and $0f
	ld (de),a

	; e = Part.damage
	inc e
	ldi a,(hl)
	ld (de),a

	; e = Part.health
	inc e
	ldi a,(hl)
	ld (de),a

	ld e,Part.oamTileIndexBase
	ldi a,(hl)
	add c
	ld (de),a

	; e = Part.oamFlags
	dec e
	ldi a,(hl)
	ld (de),a

	; Also write to Part.oamFlagsBackup
	dec e
	ld (de),a

	xor a
	jp partSetAnimation

;;
; Load the object gfx index for an interaction, and get the values for the
; Interaction.oam variables.
;
; @param	d	Interaction index
; @param[out]	a	Initial animation index to use
interactionLoadGraphics:
	call interactionGetObjectGfxIndex
	call addIndexToLoadedObjectGfx
	ld c,a

	; If LCD is on and graphics are queued, wait until they're loaded
	call c,resumeThreadNextFrameIfLcdIsOn

	; Calculate Interaction.oamTileIndexBase, which is the offset to add to
	; the tile index of all sprites in its animation. "c" currently
	; contains the offset where the graphics are loaded.
	ldi a,(hl)
	and $7f
	add c
	ld e,Interaction.oamTileIndexBase
	ld (de),a

	; Write palette into Interaction.oamFlags
	ld a,(hl)
	swap a
	and $0f
	dec e
	ld (de),a

	; Also write it into Interaction.oamFlagsBackup
	dec e
	ld (de),a

	; Return the animation index to start on
	ld a,(hl)
	and $0f
	ret

;;
; Same as above function, but for items.
; @param d Item index
itemLoadGraphics:
	call itemGetObjectGfxIndex
	call addIndexToLoadedObjectGfx
	ld c,a

	; If LCD is on and graphics are queued, wait until they're loaded
	call c,resumeThreadNextFrameIfLcdIsOn

	; Calculate Item.oamTileIndexBase
	ldi a,(hl)
	add c
	ld e,Item.oamTileIndexBase
	ld (de),a

	; Write palette / flags into Item.oamFlags
	ld a,(hl)
	dec e
	ld (de),a

	; Also write it into Item.oamFlagsBackup
	dec e
	ld (de),a
	ret

;;
interactionGetData:
	ld h,d
	ld l,Interaction.id
	ldi a,(hl)
	ld e,(hl)

;;
; @param	a	Interaction ID
; @param	e	Interaction subID
getDataForInteraction:
	ld c,a
	ld b,$00
	ld hl,interactionData+1
	add hl,bc
	add hl,bc
	add hl,bc
	ldd a,(hl)
	rlca
	ret nc

	ldi a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld c,$03

	; a = subID
	ld a,e
	or a
	ret z
-
	inc hl
	bit 7,(hl)
	dec hl
	ret nz

	add hl,bc
	dec a
	jr nz,-
	ret

;;
; @param e Uncompressed gfx header to load
loadWeaponGfx:
	ld hl,wLoadedItemGraphic1
	ld a,e
	cp UNCMP_GFXH_1a
	jr nc,+
	inc l
+
	cp (hl)
	ret z

	ld (hl),a
	push de
	call loadUncompressedGfxHeader
	pop de
	ret
