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
.if defined(ROM_COMBO)
	.dw galeSeedMenu_state4
	.dw galeSeedMenu_state5
.endif

;;
galeSeedMenu_state0:
	call mapMenu_state0

.if defined(ROM_COMBO)
	; give the player instructions if they've not travelled to the other game
	ld a,(wFileIsCompleted)
	or a
	jr z,+
		bit 3,a
		jr nz,+
			ld a,$02
			ld (wTextboxPosition),a

			ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
			ld (wTextboxFlags),a

			ld bc,TX_034d
			call showText
	+
.endif

	; This will be incremented, so set to 0, in the next function call
	ld a,$ff
	ld (wMapMenu.warpIndex),a

	ld a,$01
	ld (wMapMenu.drawWarpDestinations),a

	jp galeSeedMenu_addOffsetToWarpIndex

;;
; State 1: waiting for input (direction buttons, A or B)
galeSeedMenu_state1:
	call retIfTextIsActive

	ld a,(wPaletteThread_mode)
	or a
	jr nz,@end

	ld a,(wKeysJustPressed)
	bit BTN_BIT_B,a
	jr nz,@bPressed

	and (BTN_START | BTN_A)
	jr nz,@aPressed

	.if defined(ROM_COMBO)
		ld a,(wKeysJustPressed)
		and BTN_SELECT
		jr nz,@selectPressed
	.endif

	ld hl,@directionButtonOffsets
	call getDirectionButtonOffsetFromHl
	jr nc,@end

	; Direction button pressed
	call galeSeedMenu_addOffsetToWarpIndex
	ld a,SND_MENU_MOVE
	call nz,playSound
@end:
	jp mapMenu_loadPopupData

.if defined(ROM_COMBO)
@selectPressed:
	; only allow switching games if this game is completed
	; or both games were started on this file
	ld a,(wFileIsCompleted)
	or a
	ret z

	ld a,$03
	ld (wTextboxPosition),a

	ld a,TEXTBOXFLAG_NOCOLORS | TEXTBOXFLAG_DONTCHECKPOSITION
	ld (wTextboxFlags),a

	ld a,$04
	ld c,<TX_034b ; "Warp to other game" prompt
	jr @setState
.endif

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

.if defined(ROM_COMBO)
galeSeedMenu_state4:
	call retIfTextIsActive

	; If chose "cancel", go to state 1
	ld a,(wSelectedTextOption)
	or a
	jr nz,galeSeedMenu_gotoState1

	; otherwise fade out and prepare to load other game
	ld a,$05
	ld (wMenuActiveState),a

	jp fastFadeoutToWhite

galeSeedMenu_state5:
	; wait till fade is done to initialize game
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	; close the menu
	xor a
	ld (wOpenedMenuType),a
	ld (wTextIsActive),a

	; load the other game file
	call comboLoadOtherGame

	xor a
	ld (wCutsceneState),a
	ld (wGameState),a
	ret
.endif

;;
; @param[out] cflag		Set if we have visisted at least one tree
galeSeedMenu_anyWarpsAvailable:
	push de
	push hl
	push bc
	ld a,(wMapMenu.cursorIndex)
	ld b,a
	ld a,(wMapMenu.warpIndex)
	ld c,a
	ld a,$01
	call galeSeedMenu_addOffsetToWarpIndex
	ld a,c
	ld (wMapMenu.warpIndex),a
	ld a,b
	ld (wMapMenu.cursorIndex),a
	pop bc
	pop hl
	pop de
	ret

;;
; @param	a	Value to add to wMapMenu.warpIndex
; @param[out]	zflag	nz if the warp index changed.
galeSeedMenu_addOffsetToWarpIndex:
	ld e,a
	ld a,(wMapMenu.warpIndex)
	ld d,a
	push bc
	ld b,$09
--
	; Keep adding the offset to the index until we reach a valid entry.
	ld a,d
	add e
	and $07
	ld d,a
	call getTreeWarpDataIndex
	ld a,(hl)
	dec b
	jr nz,+
		pop bc
		scf
		ccf
		ret
	+
	or a
	jr z,--

	; We can only use entry if we've visited the room.
	call mapMenu_checkRoomVisited
	jr z,--
	pop bc

	ldi a,(hl)
	ld (wMapMenu.cursorIndex),a

	ld hl,wMapMenu.warpIndex
	ld a,d
	cp (hl)
	ld (hl),a
	scf
	ret