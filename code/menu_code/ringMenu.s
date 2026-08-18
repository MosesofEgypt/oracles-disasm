.if defined(ROM_COMBO)
; NOTE: these are copies of data and functions in bank2
showItemText2:
	ld hl,wInventory.activeText
	cp (hl)
	ret z

	ld (hl),a
	ld c,a
	ld b,>TX_0900
	bit 7,c
	jr z,+

	ld b,>TX_3000
	ld c,$c0
	and $3f
	ld l,a
	add <TX_3040
	bit 6,c ; Bit 6 is always set?
	ld c,a
	jr z,+

	ld (wTextSubstitutions+2),a
	ld a,l
	add <TX_3080
	ld (wTextSubstitutions+3),a
	ld c,<TX_30c1
+
	jp showTextOnInventoryMenu

getDirectionButtonOffsetFromHl:
	call getInputWithAutofire
	and $f0
	swap a
	call getLowestSetBit
	ret nc
	rst_addAToHl
	ld a,(hl)
	or a
	scf
	ret

fillRectangleInTilemap:
	push hl
	ld a,c
--
	ld (hl),d
	set 2,h
	ld (hl),e
	res 2,h
	inc hl
	dec a
	jr nz,--

	pop hl
	ld a,$20
	rst_addAToHl
	dec b
	jr nz,fillRectangleInTilemap
	ret

;;
closeMenu:
	ld hl,wMenuLoadState
	inc (hl)
	ld a,(wOpenedMenuType)
	cp MENU_SAVEQUIT
	ld a,SND_CLOSEMENU
	call nz,playSound
	xor a
	ld (wTextIsActive),a
	jp fastFadeoutToWhite

.ifdef EXTENDED_RING_BOX
arrowUpSpriteBlue
	.db $01
	.db $00 $00 $0e $04

arrowDownSpriteRed
	.db $01
	.db $00 $00 $0e $45

getRingBoxContents:
	ld hl,wRingBoxContents
	cp $05
	ret c
	ld hl,wRingBoxContentsExt
	ret

getRingBoxClippedIndex:
	cp $05
	ret c
	sub $05
	ret
.endif

;;
; @param[out] a Capacity of ring box.
getRingBoxCapacity:
.ifdef RESIZE_RING_BOX
	ld a,(wRingBoxLevel)
	bit 3,a
	jr z,+
		ld a,(wRingBoxLevel)
		swap a
		jr ++
	+
		push hl
		and $0f
		ld hl,@ringBoxCapacities
		rst_addAToHl
		ld a,(hl)
		pop hl
	++
	and $0f
	ret

@ringBoxCapacities:
	.db $00
	.db RING_BOX_L1_SIZE
	.db RING_BOX_L2_SIZE
	.db RING_BOX_L3_SIZE
.else
	push hl
	ld a,(wRingBoxLevel)
	ld hl,@ringBoxCapacities
	rst_addAToHl
	ld a,(hl)
	or a
	pop hl
	ret

@ringBoxCapacities:
	.db $00 $01 $03 $05
.endif
.endif

;;
; This is either the "ring appraisal" or "ring list" menu.
; If "wRingMenu_mode" is 0, it's the appraisal menu; otherwise it's the ring list.
runRingMenu:
	; Clear OAM, but always leave the first 4 slots reserved for status bar items.
	call clearOam
.ifdef WIDE_INVENTORY_SPRITES
	ld a,$18
.else
	ld a,$10
.endif
	ld (wEquippedItemOamTail),a
	ldh (<hOamTail),a

	ld hl,wTextboxFlags
	set TEXTBOXFLAG_BIT_NOCOLORS,(hl)

	ld a,:w4TileMap
	ld ($ff00+R_SVBK),a

	call @runStateCode

	; Only draw the status bar on the appraisal menu, not the list menu
	ld a,(wRingMenu_mode)
	or a
	ret nz
	jp updateStatusBar

@runStateCode:
	ld a,(wMenuActiveState)
	rst_jumpTable
	.dw ringMenu_state0
	.dw ringMenu_state1
	.dw ringMenu_state2

;;
; State 0: initalization
ringMenu_state0:
	call loadCommonGraphics
	xor a
	ld (wRingMenu.tileMapIndex),a
	dec a
	ld (wRingMenu.ringNameTextIndex),a
	ld a,$80
	ld (wRingMenu.boxCursorFlickerCounter),a

	ld a,(wRingMenu_mode)
.if defined(ROM_COMBO)
	add GFXH_UNAPPRAISED_RING_LIST_SEASONS
	call wIsSeasons
	jr c,+
		add GFXH_UNAPPRAISED_RING_LIST_AGES-GFXH_UNAPPRAISED_RING_LIST_SEASONS
	+
.else
	add GFXH_UNAPPRAISED_RING_LIST
.endif
	call loadGfxHeader
	ld a,PALH_0a
	call loadPaletteHeader

.if defined(ROM_COMBO)
	callab bank19.realignUnappraisedRings
.else
	callab bank3f.realignUnappraisedRings
.endif
	call ringMenu_calculateNumPagesForUnappraisedRings
	call ringMenu_redrawRingListOrUnappraisedRings

	; Go to state 1
	ld hl,wMenuActiveState
	inc (hl)

	call fastFadeinFromWhite

	ld a,$05
	ldh (<hNextLcdInterruptBehaviour),a

	ld a,(wRingMenu_mode)
	add $0f
	jp loadGfxRegisterStateIndex

;;
; Uses an uncompressed gfx header (one of $12-$15, depending on variables) to copy the
; tilemap to vram.
ringMenu_copyTilemapToVram:
	ld hl,wRingMenu_mode
	ld a,(wRingMenu.tileMapIndex)
	and $01
	add a
	add (hl)
	add UNCMP_GFXH_12
	jp loadUncompressedGfxHeader

;;
; Clears the textbox, and decides whether to draw ring list or unappraised rings.
ringMenu_redrawRingListOrUnappraisedRings:
	xor a
	call showItemText2
	ld hl,ringMenu_copyTilemapToVram
	push hl

	ld a,(wRingMenu_mode)
	rst_jumpTable
	.dw ringMenu_drawUnappraisedRings
	.dw ringMenu_drawRingBox

;;
; Draws the ring box along with the rings in it in the ring list menu.
ringMenu_drawRingBox:
	ld a,(wMenuActiveState)
	or a
	jr nz,++

	; Draw appropriate slots for rings
.ifdef RESIZE_RING_BOX
	call getRingBoxLevel
.else
	ld a,(wRingBoxLevel)
.endif
	inc a
.if defined(ROM_COMBO)
	ld d,a
	callab bank2.mapMenu_performTileSubstitutionsWrapper
.else
	call mapMenu_performTileSubstitutions
.endif

	; Draw ring box icon at appropriate level
	ld de,w4TileMap+$201
	ld a,$fe
	call getRingTiles
++
	call ringMenu_drawRingBoxContents
	ld a,$04
	ld (wRingMenu.numPages),a
	ld a,$fe
	ld (wRingMenu.displayedRingNumberComparator),a
	jp ringMenu_drawRingList

;;
; State 1: "normal" state; processes input, etc.
ringMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wRingMenu_mode)
	rst_jumpTable
	.dw ringMenu_state1_unappraisedRings
	.dw ringMenu_state1_ringList

;;
ringMenu_state1_unappraisedRings:
	call ringMenu_drawSprites

	ld a,(wSubmenuState)
	rst_jumpTable
	.dw ringMenu_unappraisedRings_state0
	.dw ringMenu_unappraisedRings_state1
	.dw ringMenu_unappraisedRings_state2
	.dw ringMenu_unappraisedRings_state3
	.dw ringMenu_unappraisedRings_state4
	.dw ringMenu_unappraisedRings_state5

;;
; State 0: waiting for player to choose an unappraised ring
ringMenu_unappraisedRings_state0:
	ld a,(wTextIsActive)
	or a
	ld a,<TX_3004 ; "Which one shall I appraise?"
	call z,ringMenu_setDisplayedText

	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed
	bit BTN_BIT_A,a
	jr nz,@aPressed
	bit BTN_BIT_SELECT,a
	jp nz,ringMenu_initiateScrollRight
	jp ringMenu_checkRingListCursorMoved

@bPressed:
	; Don't allow exiting if this is the first time (they don't have a ring box yet)
	call ringMenu_checkObtainedRingBox
	ld a,<TX_3012
	jp z,ringMenu_setDisplayedText

	jp closeMenu

@aPressed:
	call ringMenu_updateSelectedRingFromList
	call ringMenu_getUnappraisedRingIndex
	rlca
	ret c

	; Selected a valid ring
	ld a,$01
	ld (wSubmenuState),a
	call ringMenu_checkObtainedRingBox
	ld a,<TX_3011 ; Doesn't mention rupees (first time appraising)
	jr z,+
	ld a,<TX_3005
+
	jp ringMenu_setDisplayedText

;;
; State 1: selected a ring; waiting for confirmation
ringMenu_unappraisedRings_state1:
	call ringMenu_retIfTextIsPrinting

	; If player chose "no", go back
	ld a,(wSelectedTextOption)
	or a
	jr nz,ringMenu_state1_restart

	; First time appraising, it's free
	call ringMenu_checkObtainedRingBox
	jr z,++

	; Check if Link has 20 rupees; subtract that amount if so
	ld a,RUPEEVAL_020
	call cpRupeeValue
	ld b,<TX_3006 ; "You don't have enough rupees"
	jp nz,ringMenu_unappraisedRings_gotoState5
	ld a,RUPEEVAL_020
	call removeRupeeValue
++
	ld hl,wNumRingsAppraised
	call incHlRefWithCap

	; Get the text to display for this ring's name
	call ringMenu_getUnappraisedRingIndex
	res 6,(hl)
	ld a,(hl)
	ld (wRingMenu.textDelayCounter2),a
	add <TX_3040
	ld (wTextSubstitutions+2),a
	ld bc,TX_301c ; "I call this the..."
	call ringMenu_showExitableText

	ld a,$02
	ld (wSubmenuState),a

	call ringMenu_drawUnappraisedRings
	jp ringMenu_copyTilemapToVram

;;
; Restart state 1 (begin prompt for ring appraisal again).
;
ringMenu_state1_restart:
	xor a
	ld (wSubmenuState),a
	ld (wTextIsActive),a
	ret

;;
; State 2: just appraised a ring; after the "ring name" textbox closes, this will print
; the ring's description and go to state 3.
ringMenu_unappraisedRings_state2:
	call ringMenu_retIfTextIsPrinting

	ld a,$03
	ld (wSubmenuState),a

	call ringMenu_getUnappraisedRingIndex
	add <TX_3080
	ld c,a
	ld b,>TX_3000
	jr ringMenu_showExitableText

;;
; State 3: after printing the ring's description, check if Link has the ring, print the
; appropriate text, then go to state 4.
ringMenu_unappraisedRings_state3:
	call ringMenu_retIfTextIsPrinting

	; Remove ring from unappraised list
	call ringMenu_getUnappraisedRingIndex
	ld c,a
	ld (hl),$ff

	ld hl,wRingsObtained
	call checkFlag
	jr nz,@refund

	; Put ring into list
	ld a,c
	call setFlag
	xor a
	ld b,<TX_3017 ; "I'll put it in your ring box"
	jr ++
@refund:
	ld a,RUPEEVAL_030
	ld b,<TX_3007 ; "You already have this"
++
	ld (wRingMenu.rupeeRefundValue),a
	call ringMenu_checkObtainedRingBox
	jp z,closeMenu

	ld a,40 ; Wait 40 frames after the next textbox closes
	ld (wRingMenu.textDelayCounter2),a

	ld a,$04
	ld (wSubmenuState),a

	ld a,b
	jp ringMenu_setDisplayedText

;;
; State 4: redraw ring list without the just-appraised ring, check whether to exit the
; ring menu or whether to keep going.
ringMenu_unappraisedRings_state4:
	call ringMenu_retIfTextIsPrinting
	call ringMenu_retIfCounterNotFinished

	; Refund if applicable
	ld a,(wRingMenu.rupeeRefundValue)
	or a
	ld c,a
	ld a,TREASURE_RUPEES
	call nz,giveTreasure

.if defined(ROM_COMBO)
	callab bank19.getNumUnappraisedRings
.else
	callab bank3f.getNumUnappraisedRings
.endif
	call ringMenu_drawUnappraisedRings
	call ringMenu_copyTilemapToVram

	ld a,(wNumRingsAppraised)
	cp 100
	jr nz,@not100th

	; 100th ring
	ld a,GLOBALFLAG_APPRAISED_HUNDREDTH_RING
	call setGlobalFlag
	ld b,<TX_303c
	jr ringMenu_unappraisedRings_gotoState5

@not100th:
	; If we still have some rings left, go back to state 0
	ld a,(wNumUnappraisedRingsBcd)
	or a
	jp nz,ringMenu_state1_restart

	; Otherwise, proceed to exit the ring menu.
	ld b,<TX_3002 ; "I've appraised all your rings"

	; Fall through

;;
; @param	b	Low byte of text index to show
ringMenu_unappraisedRings_gotoState5:
	ld a,$05
	ld (wSubmenuState),a
	ld a,$3c
	ld (wRingMenu.textDelayCounter2),a
	ld a,b
	jp ringMenu_setDisplayedText

;;
; Shows an "exitable" textbox (used when vasu's speaking) unlike the "passive" textboxes
; used for ring descriptions most of the time.
;
; @param	bc	Text index
ringMenu_showExitableText:
	ld a,$02
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	jp showText

;;
; State 5: exit ring menu after a delay.
ringMenu_unappraisedRings_state5:
	call ringMenu_retIfTextIsPrinting
	call ringMenu_retIfCounterNotFinished
	jp closeMenu

;;
ringMenu_checkObtainedRingBox:
	ld a,GLOBALFLAG_OBTAINED_RING_BOX
	jp checkGlobalFlag

;;
; @param[out]	a	The value of the unappraised ring that the cursor is over
; @param[out]	hl	The address of the ring in wUnappraisedRings
ringMenu_getUnappraisedRingIndex:
	ld a,(wRingMenu.selectedRing)
	ld hl,wUnappraisedRings
	rst_addAToHl
	ld a,(hl)
	ret

;;
; Returns from caller unless wRingMEnu_textDelayCounter2 has counted down to zero.
ringMenu_retIfCounterNotFinished:
	ld hl,wRingMenu.textDelayCounter2
	ld a,(hl)
	or a
	ret z
	dec (hl)
	pop af
	ret

;;
ringMenu_state1_ringList:
	call ringMenu_drawRingBoxCursor
	call ringMenu_drawEquippedRingSprite
	call ringMenu_drawSpritesForRingsInBox

	ld a,(wSubmenuState)
	rst_jumpTable
	.dw ringMenu_ringList_substate0
	.dw ringMenu_ringList_substate1

;;
; Substate 0: cursor is on the ring box (selecting a slot in the ring box)
ringMenu_ringList_substate0:
	ld a,(wRingMenu.boxCursorFlickerCounter)
	or a
	jr z,@aPressed

	ld hl,wRingMenu.textDelayCounter
	ld a,(hl)
	or a
	jr z,+
	dec (hl)
	jr @checkInput
+
	; Display text for the ring we're hovering over in the ring box
	ld a,(wRingMenu.ringBoxCursorIndex)
.ifdef EXTENDED_RING_BOX
	call getRingBoxContents
	call getRingBoxClippedIndex
.else
	ld hl,wRingBoxContents
.endif
	rst_addAToHl
	ld a,(hl)
	ld (wRingMenu.selectedRing),a
	call ringMenu_updateDisplayedRingNumberWithGivenComparator
	call ringMenu_updateRingText

@checkInput:
	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed
	bit BTN_BIT_A,a
	jp z,ringMenu_checkRingBoxCursorMoved

; Selected a ring box slot; move the cursor to the ring list (substate 1).
@aPressed:
	xor a
	ld (wRingMenu.boxCursorFlickerCounter),a
	inc a
	ld (wSubmenuState),a
	ld a,$80
	ld (wRingMenu.displayedRingNumberComparator),a
	ld a,$ff
	ld (wRingMenu.descriptionTextIndex),a
	ret

@bPressed:
.ifndef ENABLE_MULTI_RING
	; Deactivate active ring if it was put away
	ld a,(wActiveRing)
	call ringMenu_checkRingIsInBox
	jr nc,+
	ld a,$ff
	ld (wActiveRing),a
+
.endif
	; Exit the ring menu
	xor a
	ld (wTextIsActive),a
	ld (wTextboxFlags),a
	jp closeMenu

;;
; Substate 1: cursor is on the ring list (selecting something to insert into the box)
ringMenu_ringList_substate1:
	ld a,(wKeysJustPressed)
	bit BTN_BIT_A,a
	jr nz,ringMenu_selectedRingFromList
	bit BTN_BIT_B,a
	jp nz,ringMenu_moveCursorToRingBox
	bit BTN_BIT_SELECT,a
	jp nz,ringMenu_initiateScrollRight

	call ringMenu_checkRingListCursorMoved
	call ringMenu_updateSelectedRingFromList
	call ringMenu_updateDisplayedRingNumber
	call ringMenu_drawSprites
	call ringMenu_retIfCounterNotFinished

	; Fall through

;;
; The ring list (not appraisal screen) runs this to update the textbox at the bottom.
ringMenu_updateRingText:
	; Determine what text to show for the ring name
	ld a,(wRingMenu.selectedRing)
	ld c,a
	ld hl,wRingsObtained
	call checkFlag
	jr z,+ ; If we don't have this ring, don't show its text
	ld a,c
	or $80
+
	; Check if the text to show is different from the text currently being shown
	ld hl,wRingMenu.ringNameTextIndex
	cp (hl)
	jr z,+
	call showItemText2
	ld a,$01
	ld (wRingMenu.textDelayCounter),a
	ret
+
	; Determine what text to show for the description
	ld a,(wRingMenu.selectedRing)
	ld c,a
	cp $ff
	ld a,<TX_30c0 ; Blank text
	jr z,@printDescription

	ld a,c
	ld hl,wRingsObtained
	call checkFlag
	ld a,<TX_30c0 ; Blank text
	jr z,@printDescription

	ld a,c
	add <TX_3080
@printDescription:
	; Check if the text to show is different from the text currently being shown
	ld hl,wRingMenu.descriptionTextIndex
	cp (hl)
	ret z

	; Display the textbox
	ld (hl),a
	ld c,a
	ld b,>TX_3000
	ld a,$04
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	jp showTextNonExitable

;;
; Selected something from the ring list; put it into the ring box and move the cursor back
; there.
ringMenu_selectedRingFromList:
	ld a,SND_SELECTITEM
	call playSound

	; Put the ring (if it exists) in the box
	call ringMenu_updateSelectedRingFromList
	ld c,a
	ld hl,wRingsObtained
	call checkFlag
	jr nz,+
	ld c,$ff
+
	ld a,(wRingMenu.ringBoxCursorIndex)
	ld b,a
	ld a,c
	call ringMenu_checkRingIsInBox
	jr c,+
	ld (hl),$ff
	cp b
	jr z,ringMenu_moveCursorToRingBox
+
	ld a,b
.ifdef EXTENDED_RING_BOX
	call getRingBoxContents
	call getRingBoxClippedIndex
.else
	ld hl,wRingBoxContents
.endif
	rst_addAToHl
	ld (hl),c

	; Fall through

;;
; Sets the cursor to be at the ring box instead of ring list.
ringMenu_moveCursorToRingBox:
	xor a
	ld (wSubmenuState),a
	ld a,$80
	ld (wRingMenu.boxCursorFlickerCounter),a
	ld a,$ff
	ld (wTextIsActive),a
	ld (wRingMenu.ringNameTextIndex),a
	ld (wRingMenu.descriptionTextIndex),a
	call ringMenu_drawRingBoxContents
	jp ringMenu_copyTilemapToVram

;;
; @param	a	Ring to check if it's in the ring box
; @param[out]	a	The ring's index in the ring box
; @param[out]	cflag	nc if the ring's in the box
ringMenu_checkRingIsInBox:
	push bc
	ld hl,wRingBoxContents+4
.ifdef EXTENDED_RING_BOX
	ld c,$00
@checkRings
.endif
	ld b,$05
@nextRing:
	cp (hl)
	jr z,@foundRing
	dec l
	dec b
	jr nz,@nextRing

.ifdef EXTENDED_RING_BOX
	push af
	ld a,l
	cp <wRingBoxContents-1
	jr nz,+
		ld hl,wRingBoxContentsExt+4
		pop af
		ld c,$05
		jr @checkRings
+
	pop af
.endif
	pop bc
	scf
	ret

@foundRing:
	dec b
	ld a,b
.ifdef EXTENDED_RING_BOX
	add c
.endif
	pop bc
	ret

;;
ringMenu_initiateScrollRight:
	ld a,$01
	ld (wRingMenu.scrollDirection),a
	ld (wRingMenu.displayedRingNumberComparator),a
	xor a
	ld (wRingMenu.ringListCursorIndex),a
	ld a,(wRingMenu.page)
	inc a

;;
; @param	a	Page to scroll to
ringMenu_initiateScroll:
	ld hl,wRingMenu.numPages
	cp (hl)
	jr c,++
	ld a,$01
	cp (hl)
	ret z

	dec a
++
	ld (wRingMenu.page),a

	ld a,$02

;;
; @param	a	State to go to
ringMenu_setState:
	ld hl,wMenuActiveState
	ldi (hl),a
	xor a
	ld (hl),a ; [wSubmenuState] = 0
	ld (wTextIsActive),a

	ld a,$ff
	ld (wRingMenu.descriptionTextIndex),a
	ret

;;
; State 2: scrolling between pages
ringMenu_state2:
	ld a,(wRingMenu_mode)
	or a
	jr z,+
	call ringMenu_drawRingBoxCursor
	call ringMenu_drawEquippedRingSprite
+
	ld a,(wSubmenuState)
	rst_jumpTable
	.dw @substate0
	.dw @substate1

; Initiating scroll
@substate0:
	ld hl,wRingMenu.tileMapIndex
	ld a,(hl)
	xor $01
	ld (hl),a

	call ringMenu_redrawRingListOrUnappraisedRings

	ld a,(wRingMenu.scrollDirection)
	bit 7,a
	ld a,$9f
	jr z,++
	ld hl,wGfxRegs2.LCDC
	ld a,(hl)
	xor $48
	ld (hl),a
	ld a,$98
	ld (wGfxRegs2.SCX),a
	ld a,$07
++
	ld (wGfxRegs2.WINX),a
	ld hl,wSubmenuState
	inc (hl)
	ld a,SND_OPENMENU
	jp playSound

; In the process of scrolling
@substate1:
	ld bc,$089f
	ld hl,wGfxRegs2.WINX
	ld de,wGfxRegs2.SCX
	ld a,(wRingMenu.scrollDirection)
	bit 7,a
	jr z,@scrollRight

@scrollLeft:
	ld a,(hl)
	add b
	cp c
	jr c,+
	ld a,c
+
	ld (hl),a
	ld a,(de)
	sub b
	ld (de),a
	cp $08
	ret nc
	jr @doneScrolling

@scrollRight:
	ld a,(hl)
	sub b
	cp $07
	jr nc,+
	ld a,$07
+
	ld (hl),a
	ld a,(de)
	add b
	ld (de),a
	cp $98
	ret c
	ld a,(wGfxRegs2.LCDC)
	xor $48
	ld (wGfxRegs2.LCDC),a

@doneScrolling:
	ld a,$c7
	ld (wGfxRegs2.WINX),a
	xor a
	ld (wGfxRegs2.SCX),a
	ld a,$01
	jp ringMenu_setState

;;
ringMenu_checkRingListCursorMoved:
	ld hl,@directionOffsets
	call getDirectionButtonOffsetFromHl
	ret nc

	ld c,a

	; Update position
	ld hl,wRingMenu.ringListCursorIndex
	ld e,a
	add (hl)
	ld b,a
	and $0f
	ld (hl),a

	; Check if we hit the edge of the screen
	bit 0,c
	jr z,@playSound
	bit 4,b
	jr z,@playSound

	; Initiate screen scrolling
	ld a,e
	ld (wRingMenu.scrollDirection),a
	ld a,(wRingMenu.page)
	add e
	cp $ff
	jr nz,++

	ld a,(wRingMenu.numPages)
	cp $01
	jr z,@playSound
	dec a
++
	call ringMenu_initiateScroll

@playSound:
	ld a,SND_MENU_MOVE
	call playSound
	scf
	ret

@directionOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $f8 ; Up
	.db $08 ; Down

;;
; Update the cursor position in the ring box by checking if a direction button is pressed
ringMenu_checkRingBoxCursorMoved:
	call getRingBoxCapacity
	ld e,a
	ld hl,@directionOffsets
	call getDirectionButtonOffsetFromHl
	ret nc
	ret z
	ld hl,wRingMenu.ringBoxCursorIndex
.ifdef EXTENDED_RING_BOX
	add (hl)

	; if would move to before start, move relative to end
	cp $80
	jr c,+
		ld b,a
		ld a,e
		add b
+
	; if would move past end, move relative to start
	cp e
	jr c,+
		sub e
+
	; handle edge cases when ring box size isn't at least 5
	cp e
	jr c,+
		ld a,e
		dec a
+
	cp $80
	jr c,+
		xor a
+
	ld (hl),a

	push af
	ld hl,wRingMenu.displayedRingNumberComparator
	ld a,(hl)
	cp $ff
	jr nz,+
		; force redraw by setting previous value to an invalid index
		ld (hl),$80
+
	; redraw
	call ringMenu_drawRingBoxContents
	pop af
.else
	add (hl)
	cp e
	ret nc
	ld (hl),a
.endif
	ld a,SND_MENU_MOVE
	jp playSound

@directionOffsets:
	.db $01 ; Right
	.db $ff ; Left
.ifdef EXTENDED_RING_BOX
	.db $fb ; Up
	.db $05 ; Down
.else
	.db $00 ; Up
	.db $00 ; Down
.endif

;;
; Draw sprites for the cursor, and arrows indicating you can scroll between pages (if
; there's more than one page).
ringMenu_drawSprites:
	ld a,(wRingMenu.numPages)
	dec a
	ld hl,@arrowSprites
	call nz,addSpritesToOam

	ld hl,wRingMenu.listCursorFlickerCounter
	inc (hl)
	bit 3,(hl)
	ret nz
	ld bc,$3e20
	ld a,(wRingMenu.ringListCursorIndex)
	cp $08
	jr c,+
	ld b,$56
+
	and $07
	swap a
	add c
	ld c,a
	ld hl,@cursorSprite
	jp addSpritesToOam_withOffset

@cursorSprite:
	.db $01
	.db $00 $fc $0e $02

@arrowSprites:
	.db $02
	.db $3c $0c $08 $04
	.db $3c $9c $08 $24

;;
; Draws the "E" for equipped next to the equipped ring in the ring box.
ringMenu_drawEquippedRingSprite:
.ifdef ENABLE_MULTI_RING
	ld hl,wRingBoxContents+4
.ifdef EXTENDED_RING_BOX
	ld a,(wRingMenu.ringBoxCursorIndex)
	cp $05
	jr c,+
		ld hl,wRingBoxContentsExt+4
	+
.endif
	push bc
	ld b,$05
	-
		ldd a,(hl)
		push hl
		call cpActiveRingCheckFF
		jr nz,+
			ld a,b
			dec a
			push bc
			call ringMenu_getSpriteOffsetForRingBoxPosition
			ld hl,@equippedSprite
			call addSpritesToOam_withOffset
			pop bc
		+
		pop hl
		dec b
		jr nz,-
	pop bc
	ret
.else
	ld a,(wActiveRing)
	cp $ff
	ret z
	call ringMenu_checkRingIsInBox
	ret c
.ifdef EXTENDED_RING_BOX
	cp $05

	push af
	ld a,(wRingMenu.ringBoxCursorIndex)
	cp $05

	jr c,+
		; viewing second row. return if equipped ring is on first
		pop af
		ret c
		jr ++
	+
		; viewing first row. return if equipped ring is on second
		pop af
		ret nc
	++
	call getRingBoxClippedIndex
.endif

	call ringMenu_getSpriteOffsetForRingBoxPosition
	ld hl,@equippedSprite
	jp addSpritesToOam_withOffset
.endif

@equippedSprite:
	.db $01
	.db $10 $00 $ec $04

;;
; @param[out]	bc	An offset to use for sprites to be drawn on a ring in the ring box
ringMenu_getSpriteOffsetForRingBoxPosition:
	ld hl,@offsets
.ifdef EXTENDED_RING_BOX
	cp $05
	jr c,+
		sub $05
	+
.endif
	rst_addAToHl
	ld c,(hl)
	ld b,$00
	ret

@offsets:
	.db $38 $50 $68 $80 $98

;;
ringMenu_drawRingBoxCursor:
	ld hl,wRingMenu.boxCursorFlickerCounter
	bit 7,(hl)
	jr z,++

	; Flicker the cursor with this counter
	inc (hl)
	res 4,(hl)
	bit 3,(hl)
	ret nz
++
	ld a,(wRingMenu.ringBoxCursorIndex)
	call ringMenu_getSpriteOffsetForRingBoxPosition
	ld hl,@ringBoxCursor
.ifdef EXTENDED_RING_BOX
	call addSpritesToOam_withOffset
	call getRingBoxCapacity
	cp $06
	ret c

	ld a,(wRingMenu.ringBoxCursorIndex)
	ld hl,arrowDownSpriteRed
	cp $05

	jr c,+
		ld hl,arrowUpSpriteBlue
+
	ld bc,$111a
	push hl
	call addSpritesToOam_withOffset
	pop hl

	ld c,$20
	push hl
	call addSpritesToOam_withOffset
	pop hl

	ld c,$26
.endif
	jp addSpritesToOam_withOffset

@ringBoxCursor:
	.db $01
	.db $1e $fc $0e $03

;;
; For each ring in the ring box, this draws a sprite (the letter "C") on the corresponding
; ring in the ring list.
ringMenu_drawSpritesForRingsInBox:
.ifdef EXTENDED_RING_BOX
	call getRingBoxCapacity
.else
	ld a,$05
.endif
@loop:
	push af

.ifdef EXTENDED_RING_BOX
	; tweaking is needed to convert from one-based indexing to zero-based
	dec a
	call getRingBoxContents
	call getRingBoxClippedIndex
	inc a
	dec hl
.else
	ld hl,wRingBoxContents-1
.endif

	rst_addAToHl
	ld a,(wRingMenu.page)
	swap a
	ld c,a

	ld a,(hl)
.ifdef REMAP_RING_LIST
	call ringMenu_unmapSelectedRingIndex
.endif
	cp $ff
	jr z,@nextRing

	; Make sure the ring is on this page
	sub c
	cp $10
	jr nc,@nextRing

	; Calculate the position to draw the "c" at
	ld b,$30
	bit 3,a
	jr z,+
	ld b,$48
+
	and $07
	swap a
	ld c,a
	ld hl,@sprite
	call addSpritesToOam_withOffset
@nextRing:
	pop af
	dec a
	jr nz,@loop
	ret

@sprite:
	.db $01
	.db $00 $20 $ef $05

;;
ringMenu_calculateNumPagesForUnappraisedRings:
.if defined(ROM_COMBO)
	callab bank19.getNumUnappraisedRings
.else
	callab bank3f.getNumUnappraisedRings
.endif
	ld a,(wNumUnappraisedRingsBcd)
	or a
	ret z

	ld a,b
	dec a
	swap a
	and $0f
	inc a
	ld (wRingMenu.numPages),a
	ret

.ifdef REMAP_RING_LIST
;;
ringMenu_isRingList:
	push bc
	ld c,a
	ld a,(wRingMenu_mode)
	or a
	ld a,c
	pop bc
	ret

ringMenu_remapSelectedRingIndex:
	; only remap rings if in the ring box, not the appraisal menu
	call ringMenu_isRingList
	ret z
ringMenu_forceRemapSelectedRingIndex:
	push hl
	ld hl,ringMapTable
	rst_addAToHl
	ld a,(hl)
	pop hl
	ret

ringMenu_unmapSelectedRingIndex:
	; only remap rings if in the ring box, not the appraisal menu
	call ringMenu_isRingList
	ret z

ringMenu_forceUnmapSelectedRingIndex:
	; linear searches suck, but oh well. im not hardcoding an inverse table
	push hl
	push bc
	ld b,$40
	ld hl,ringMapTable
-
	cp (hl)
	jr z,+
		inc hl
		dec b
		jr nz,-
	ld a,$ff 	; fallback
	jr ++
+
	ld a,$40
	sub b
++
	pop bc
	pop hl
	ret

ringMapTable
	.db RING_LIST_PG1_UP_LEFT
	.db RING_LIST_PG1_UP_RIGHT
	.db RING_LIST_PG1_DOWN_LEFT
	.db RING_LIST_PG1_DOWN_RIGHT

	.db RING_LIST_PG2_UP_LEFT
	.db RING_LIST_PG2_UP_RIGHT
	.db RING_LIST_PG2_DOWN_LEFT
	.db RING_LIST_PG2_DOWN_RIGHT

	.db RING_LIST_PG3_UP_LEFT
	.db RING_LIST_PG3_UP_RIGHT
	.db RING_LIST_PG3_DOWN_LEFT
	.db RING_LIST_PG3_DOWN_RIGHT

	.db RING_LIST_PG4_UP_LEFT
	.db RING_LIST_PG4_UP_RIGHT
	.db RING_LIST_PG4_DOWN_LEFT
	.db RING_LIST_PG4_DOWN_RIGHT
.endif

;;
ringMenu_updateSelectedRingFromList:
	ld a,(wRingMenu.page)
	swap a
	ld c,a
	ld a,(wRingMenu.ringListCursorIndex)
	add c
.ifdef REMAP_RING_LIST
	call ringMenu_remapSelectedRingIndex
.endif
	ld (wRingMenu.selectedRing),a
	ret

;;
; Clear all ring icons in the selection area.
ringMenu_clearRingSelectionArea:
	ld hl,w4TileMap+$040
	ldbc $05,$14
	ldde $00,$07
	jp fillRectangleInTilemap

;;
ringMenu_drawUnappraisedRings:
	call ringMenu_clearRingSelectionArea

	ld b,$10
	ld a,(wRingMenu.page)
	swap a
	ld hl,wUnappraisedRings
	rst_addAToHl
@nextRing:
	ldi a,(hl)
	ld c,a
	call ringMenu_drawRing
	dec b
	jr nz,@nextRing

	jr ringMenu_drawPageCounter

;;
ringMenu_drawRingList:
	call ringMenu_clearRingSelectionArea

	ld b,$10
	ld a,(wRingMenu.page)
	swap a
	ld c,a
@nextRing:
	ld a,c
.ifdef REMAP_RING_LIST
	call ringMenu_remapSelectedRingIndex
.endif
	ld hl,wRingsObtained
	call checkFlag
	call nz,ringMenu_drawRing
	inc c
	dec b
	jr nz,@nextRing

;;
ringMenu_drawPageCounter:
	; Draw page number
	ld hl,w4TileMap+$10f
	ld a,(wRingMenu.page)
	add $11
	ldi (hl),a

	; Draw total page number
	inc l
	ld a,(wRingMenu.numPages)
	add $10
	ld (hl),a
	ret

.ifdef RESIZE_RING_BOX
ringMenu_drawRingBoxArea:
	push bc
	push de
	push hl

	; figure out how many slots we have
	call getRingBoxCapacity
	ld b,a

	ld a,(wRingMenu.ringBoxCursorIndex)
	cp 5
	ld a,b
	jr c,+
		; second row. clip size by 5
		sub 5
	+
		; first row
		cp 6
		jr c,++
			ld a,5
	++
	; calculate how many tiles to fill(1+3*(slot_count-2))
	dec a
	dec a
	ld b,a
	add b
	add b
	inc a
	push af

	; clear existing tiles
	ld hl,w4TileMap+$204 	; ring box top-left corner
	ldbc $02,$14 			; height/width
	ldde $00,$07 			; tile index/flags
	push hl
	call fillRectangleInTilemap
	pop hl

	; draw the outer-left brackets
	xor a
	call @drawOutsideBracket

	; draw the inside brackets
	pop af
	bit 7,a
	jr nz,+
		inc hl
		inc hl

		ld b,$02 		; height
		ld c,a			; width
		ldde $07,$07 	; tile index/flags
		push hl
		call fillRectangleInTilemap
		pop hl

		; vertically mirror top row
		set 2,h		; move to flags
		-
			set 6,(hl)	; set vertical-mirror
			inc hl
			dec c
			jr nz,-

		res 2,h		; move back to tiles
	+

	inc hl
	inc hl

	; draw the outer-right brackets
	ld a,$20
	call @drawOutsideBracket

	pop hl
	pop de
	pop bc
	ret

@drawOutsideBracket:
	or $07 			; flags
	; draw the outer-left brackets
	ldbc $02,$01 	; height/width
	ld d,$06 		; tile index
	ld e,a
	push hl
	call fillRectangleInTilemap
	pop hl

	; vertically mirror top row
	set 2,h		; move to flags
	set 6,(hl)	; set vertical-mirror
	res 2,h		; move back to tiles
	inc hl		; move to the next tile
	ret
.endif

;;
; Draws the contents of the ring box for the ring list menu
ringMenu_drawRingBoxContents:
.ifdef EXTENDED_RING_BOX
.ifdef RESIZE_RING_BOX
	call ringMenu_drawRingBoxArea
.endif
	ld a,(wRingMenu.ringBoxCursorIndex)
	call getRingBoxContents
	ld a,$11

@nextRing:
	push af
	push hl
	ld hl,ringMenu_ringPositionList-2
	rst_addDoubleIndex
	rst_derefHl
	ld bc,$0202
	ld de,$0007
	call fillRectangleInTilemap
	pop hl
	ldi a,(hl)
	cp $ff
	pop bc
	ld c,a
	ld a,b
	jr z,++
		push af
		call ringMenu_drawRing
		pop af
++
	inc a
	cp $16
.else
	ld hl,wRingBoxContents
	ld b,$11 ; b = index for ringMenu_drawRing function (cycles from $11-$15)

@nextRing:
	ldi a,(hl)
	cp $ff
	jr nz,@drawRing

	; Blank ring slot: fill with empty square
	push hl
	push bc
	ld a,b
	ld hl,ringMenu_ringPositionList-2
	rst_addDoubleIndex
	rst_derefHl
	ldbc $02,$02
	ldde $00,$07
	call fillRectangleInTilemap
	pop bc
	pop hl
	jr ++
@drawRing:
	ld c,a
	call ringMenu_drawRing
++
	inc b
	ld a,l
	cp <wRingBoxContents+5
.endif
	jr c,@nextRing
	ret

;;
; Draws a ring's tiles at a position in the ring list.
;
; @param	b	Position index
; @param	c	Ring index
ringMenu_drawRing:
	push bc
	push hl
	ld a,b
	ld hl,ringMenu_ringPositionList-2
	rst_addDoubleIndex
	ldi a,(hl)
	ld d,(hl)
	ld e,a
	ld a,c

.ifdef REMAP_RING_LIST
	ld a,b
	; if the selected ring is 16 or higher, it's
	; in the ring box and shouldnt be remapped.
	; we check $11 instead of $10 because this
	; code uses one-based indexing.
	cp $11
	ld a,c
	jr nc,+
		call ringMenu_remapSelectedRingIndex
	+
.endif

	call getRingTiles
	pop hl
	pop bc
	ret

ringMenu_ringPositionList:
	; Lower row
	.dw w4TileMap+$0b0
	.dw w4TileMap+$0ae
	.dw w4TileMap+$0ac
	.dw w4TileMap+$0aa
	.dw w4TileMap+$0a8
	.dw w4TileMap+$0a6
	.dw w4TileMap+$0a4
	.dw w4TileMap+$0a2

	; Upper row
	.dw w4TileMap+$050
	.dw w4TileMap+$04e
	.dw w4TileMap+$04c
	.dw w4TileMap+$04a
	.dw w4TileMap+$048
	.dw w4TileMap+$046
	.dw w4TileMap+$044
	.dw w4TileMap+$042

	; Ring box contents
	.dw w4TileMap+$205
	.dw w4TileMap+$208
	.dw w4TileMap+$20b
	.dw w4TileMap+$20e
	.dw w4TileMap+$211

;;
; Load the tiles for ring 'a' to address 'de'. Attributes go to de+$200.
;
; @param	a	Ring index ($ff=none, $fe=ring box)
; @param	de	Where to load ring tiles into
getRingTiles:
	cp $ff
	ret z

	; Unappraised ring?
	bit 6,a
	jr z,+

	; Ring box?
	cp $fe
	ld a,$40
	jr nz,+
.ifdef RESIZE_RING_BOX
	call getRingBoxLevel
.else
	ld a,(wRingBoxLevel)
.endif
	add $40
	jr +
+
	call multiplyABy8
	m_ReadGfxDataHashedFilename map_rings
	ld hl,{filename}
	add hl,bc
	push de
	call copy8BytesFromRingMapToCec0
	pop hl
	ld de,wTmpcec0
	call @drawTile
	inc l
	call @drawTile
	ld a,$1f
	rst_addAToHl
	call @drawTile
	inc l
@drawTile:
	ld a,(de)
	ld (hl),a
	inc e
	set 2,h
	ld a,(de)
	ld (hl),a
	inc e
	res 2,h
	ret

;;
; Updates the "ring number" displayed below the ring list.
ringMenu_updateDisplayedRingNumber:
	ld a,(wRingMenu.ringListCursorIndex)

	; Fall through

;;
; @param	a	Value to compare against "wRingMenu.displayedRingNumberComparator"
;			for changes
ringMenu_updateDisplayedRingNumberWithGivenComparator:
	ld hl,wRingMenu.displayedRingNumberComparator
	cp (hl)
	ret z

	ld (hl),a

	; If no ring is selected, print two dashes
	ld a,(wRingMenu.selectedRing)
.ifdef REMAP_RING_LIST_NUMBERS
	call ringMenu_forceUnmapSelectedRingIndex
.endif
	inc a
	jr z,@noRing

	; Calculate the ring's number in bcd
	call hexToDec
	set 4,a
	set 4,c
	jr @drawNumber

@noRing:
	; Display two dashes
	ld a,$e8
	ld c,a
@drawNumber:
	ld hl,w4TileMap+$105
	ldd (hl),a
	ld (hl),c
	jp ringMenu_copyTilemapToVram

;;
; @param	a	Text index to show ($30XX)
ringMenu_setDisplayedText:
	ld hl,wRingMenu.descriptionTextIndex
	cp (hl)
	ret z

	ld (hl),a
	ld c,a
	ld b,>TX_3000
	ld a,$02
	ld (wTextboxPosition),a
	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a
	jp showTextNonExitable

;;
; Returns from caller if text is still in the process of printing.
ringMenu_retIfTextIsPrinting:
	ld a,(wTextIsActive)
	and $7f
	ret z
	pop af
	ret
