;;
runGaleSeedMenu:
	call clearOam
	call @runState
	jp mapMenu_drawSprites

@runState:
	ld a,(wMenuActiveState)
	rst_jumpTable
	.dw galeSeedMenu_state0
	.dw galeSeedMenu_state1
	.dw galeSeedMenu_state2
	.dw galeSeedMenu_state3

;;
galeSeedMenu_state0:
	call mapMenu_state0

	; This will be incremented, so set to 0, in the next function call
	ld a,$ff
	ld (wMapMenu.warpIndex),a

	ld a,$01
	ld (wMapMenu.drawWarpDestinations),a

	jp galeSeedMenu_addOffsetToWarpIndex

;;
; State 1: waiting for input (direction buttons, A or B)
galeSeedMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	jr nz,@end

	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed

	and (BTN_START | BTN_A)
	jr nz,@aPressed

	ld hl,@directionButtonOffsets
	call getDirectionButtonOffsetFromHl
	jr nc,@end

	; Direction button pressed
	call galeSeedMenu_addOffsetToWarpIndex
	ld a,SND_MENU_MOVE
	call nz,playSound
@end:
	jp mapMenu_loadPopupData

@bPressed:
	call mapGetRoomTextOrReturn
	ld a,$03
	ld c,<TX_0301 ; Reselect prompt
	jr @setState

@aPressed:
	call mapGetRoomTextOrReturn
	ld a,c
	ld (wTextSubstitutions+2),a
	ld c,<TX_0300 ; Warp prompt
	ld a,$02

@setState:
	ld (wMenuActiveState),a
	ld b,>TX_0300
	jp showText

@directionButtonOffsets:
	.db $01 ; Right
	.db $ff ; Left
	.db $ff ; Up
	.db $01 ; Down

;;
; State 2: selected a warp destination; waiting for confirmation
galeSeedMenu_state2:
	call retIfTextIsActive

	ld a,(wSelectedTextOption)
	or a
	jr nz,galeSeedMenu_gotoState1
	ld (wOpenedMenuType),a ; $00
	ld a,(wActiveGroup)
	or $80
	ld (wWarpDestGroup),a
	ld a,(wMapMenu.warpIndex)
	call getTreeWarpDataIndex
	ldi a,(hl)
	ld (wWarpDestRoom),a
	ldi a,(hl)
	ld (wWarpDestPos),a
	ld a,$05
	ld (wWarpTransition),a
	ld a,$03
	ld (wWarpTransition2),a
	ld a,$03
	call setMusicVolume
	jp fadeoutToWhite

;;
galeSeedMenu_gotoState1:
	ld a,$01
	ld (wMenuActiveState),a
	ret

;;
; State 3: pressed B button; waiting for confirmation to exit
galeSeedMenu_state3:
	call retIfTextIsActive

	; If chose "reselect", go to state 1
	ld a,(wSelectedTextOption)
	or a
	jr z,galeSeedMenu_gotoState1

	; Otherwise exit the menu
	ld a,$ff
	ld (wWarpTransition2),a
	jp closeMenu

;;
; @param	a	Value to add to wMapMenu.warpIndex
; @param[out]	zflag	nz if the warp index changed.
galeSeedMenu_addOffsetToWarpIndex:
	ld e,a
	ld a,(wMapMenu.warpIndex)
	ld d,a
--
	; Keep adding the offset to the index until we reach a valid entry.
	ld a,d
	add e
	and $07
	ld d,a
	call getTreeWarpDataIndex
	ld a,(hl)
	or a
	jr z,--

	; We can only use entry if we've visited the room.
	call mapMenu_checkRoomVisited
	jr z,--

	ldi a,(hl)
	ld (wMapMenu.cursorIndex),a

	ld hl,wMapMenu.warpIndex
	ld a,d
	cp (hl)
	ld (hl),a
	ret
