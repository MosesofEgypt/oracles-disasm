;;
; This function is used by "drawRectangleToVramTiles".
readParametersForRectangleDrawing:
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ret

;;
; Unused in seasons?
;
; @param	b	# of columns to write before moving to next row
; @param	c	# of rows
; @param	de	Where to write the data (should point to w3VramTiles)
; @param	hl	The address of the data to write to the given address
drawRectangleToVramTiles_withParameters:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	jr drawRectangleToVramTiles@nextRow

;;
; This function takes a data struct in hl which is expected to point to somewhere in
; w3VramTiles. This function is used to rewrite a rectangular area in that buffer.
;
; @param	hl	Pointer to data struct:
; 			b0-b1: Where to write the data (should point to w3VramTiles)
; 			b2: # of columns to write before moving to next row
; 			b3: # of rows
; 			b4+: The data to write to the given address
drawRectangleToVramTiles:
	ld a,($ff00+R_SVBK)
	push af
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	call readParametersForRectangleDrawing

@nextRow:
	push bc
--
	ldi a,(hl)
	ld (de),a
	set 2,d
	ldi a,(hl)
	ld (de),a
	res 2,d
	inc de
	dec c
	jr nz,--
	pop bc
	ld a,$20
	sub c
	call addAToDe
	dec b
	jr nz,@nextRow

	pop af
	ld ($ff00+R_SVBK),a
	ret

.if defined(ROM_COMBO) || defined(ROM_AGES)
;;
copyRectangleFromTmpGfxBuffer_paramBc:
	ld l,c
	ld h,b
.endif

;;
; @param	hl	Pointer to data struct:
; 			b0: # of columns
; 			b1: # of rows
; 			b2-b3: Where to write the data (should point somewhere in wram 3)
; 			b4-b5: Where to read data from (should point somewhere in wram 2)
copyRectangleFromTmpGfxBuffer:
	ld a,($ff00+R_SVBK)
	push af

	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a
	rst_derefHl

@nextRow:
	push bc
--
	ld a,:w2TmpGfxBuffer
	ld ($ff00+R_SVBK),a
	ldi a,(hl)
	ld b,a
	ld a,:w3VramTiles
	ld ($ff00+R_SVBK),a
	ld a,b
	ld (de),a
	inc de
	dec c
	jr nz,--
	pop bc
	ld a,$20
	sub c
	call addAToDe
	ld a,$20
	sub c
	rst_addAToHl
	dec b
	jr nz,@nextRow

	pop af
	ld ($ff00+R_SVBK),a
	ret

;;
; @param	hl	Pointer to data struct:
;			b0-b1: Where to write the data (should point to wRoomLayout)
;			b2: # of columns
;			b3: # of rows
;			b4+: Data to write (even bytes go to wRoomLayout, odd bytes go to
;			wRoomCollisions)
copyRectangleToRoomLayoutAndCollisions:
	ldi a,(hl)
	ld e,a
	ldi a,(hl)
	ld d,a

;;
; @param	de	Where to write the data
; @param	hl	Pointer to data struct (same as above method except first 2 bytes)
copyRectangleToRoomLayoutAndCollisions_paramDe:
	ldi a,(hl)
	ld b,a
	ldi a,(hl)
	ld c,a

@nextRow:
	push bc
--
	ldi a,(hl)
	ld (de),a
	dec d
	ldi a,(hl)
	ld (de),a
	inc d
	inc de
	dec c
	jr nz,--
	pop bc
	ld a,$10
	sub c
	call addAToDe
	dec b
	jr nz,@nextRow
	ret