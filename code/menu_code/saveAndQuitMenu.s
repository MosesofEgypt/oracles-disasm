;;
; @param[out]	zflag	nz if we got here from a game over.
saveQuitMenu_checkIsGameOver:
	ld a,(wSaveQuitMenu.gameOver)
	or a
	ret

;;
runSaveAndQuitMenu:
	ld a,$00
	ld ($ff00+R_SVBK),a
	call @runState
	jp saveQuitMenu_drawSprites

@runState:
	ld a,(wSaveQuitMenu.state)
	rst_jumpTable
	.dw saveQuitMenu_state0
	.dw saveQuitMenu_state1
	.dw saveQuitMenu_state2

;;
; State 0: initialization (loading graphics, setting music, etc)
saveQuitMenu_state0:
	call disableLcd
	call stopTextThread

	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	ld a,GFXH_SAVE_MENU_LAYOUT
	call loadGfxHeader
	ld a,GFXH_SAVE_MENU_GFX
	call loadGfxHeader

.ifdef ENABLE_NEW_GAME_PLUS
	call getIsInNgpDungeon
	ld a,GFXH_SAVE_MENU_GFX_DUNGEON_NGP
	call nz,loadGfxHeader
.endif

	call saveQuitMenu_checkIsGameOver
	jr z,@notGameOver

@gameOver:
	call restartSound
	ld a,THREAD_1
	call threadStop

	ld hl,wDeathCounter
	ld bc,$0001
	call addDecimalToHlRef
	cp $0a
	jr c,+
	ld (hl),$99 ; Death counter can't exceed 999
	inc l
	ld (hl),$09
+
.ifdef ENABLE_NEW_GAME_PLUS
	call getIsInNgpDungeon
	ld a,GFXH_SAVE_MENU_LAYOUT_DUNGEON_NGP_GAMEOVER
	call nz,loadGfxHeader
.endif
	ld a,GFXH_GAME_OVER_GFX
	call loadGfxHeader

	ld a,MUS_GAMEOVER
	call playSound

	ld a,PALH_06
	jr ++

@notGameOver:
	xor a
	call setMusicVolume
	ld a,PALH_05
++
	call loadPaletteHeader
	ld a,UNCMP_GFXH_08
	call loadUncompressedGfxHeader

	call fastFadeinFromWhite

	ld a,$01
	ld (wSaveQuitMenu.state),a

	ld a,$05
	jp loadGfxRegisterStateIndex


.ifdef ENABLE_NEW_GAME_PLUS
getIsInNgpDungeon:
	push hl
	ld h,a
	call getIsNewGamePlus
	jr z,+
		ld a,(wDungeonIndex)
		cp $ff ; overworld
		jr z,+
		.if defined(ROM_AGES) || defined(ROM_COMBO)
			.if defined(ROM_COMBO)
				call wIsSeasons
				jr c,++
			.endif
			cp $0e ; lots of non-dungeon areas
			jr z,+
			++
		.endif
		or $01
	+
	ld a,h
	pop hl
	ret
.endif

;;
; State 1: processing input
saveQuitMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wKeysJustPressed)
	ld c,$ff
	bit BTN_BIT_UP,a
	jr nz,@upOrDown
	ld c,$01
	bit BTN_BIT_DOWN,a
	jr nz,@upOrDown

	bit BTN_BIT_B,a
	jr nz,@bPressed

	and (BTN_START|BTN_A)
	ret z

	; A pressed
.ifdef ENABLE_NEW_GAME_PLUS
	call getIsInNgpDungeon
	jr nz,+
		; no saving in NGP dungeon
		ld a,(wSaveQuitMenu.cursorIndex)
		or a
		call nz,saveFile ; Save for options 2 and 3
	+
.else
	ld a,(wSaveQuitMenu.cursorIndex)
	or a
	call nz,saveFile ; Save for options 2 and 3
.endif

	ld a,$02
	ld (wSaveQuitMenu.state),a
	ld a,$1e
	ld (wSaveQuitMenu.delayCounter),a

	ld a,SND_SELECTITEM
	jp playSound

@upOrDown:
	ld hl,wSaveQuitMenu.cursorIndex
	ld a,(hl)
	add c
	cp $03
	ret nc
.ifdef ENABLE_NEW_GAME_PLUS
	call getIsInNgpDungeon
	jr z,+
		; only 2 options in NGP dungeon game over screen
		push hl
		ld h,a
		call saveQuitMenu_checkIsGameOver
		ld a,h
		pop hl
		jr z,+
			cp $02
			ret nc
	+
.endif
	ld (hl),a
	ld a,SND_MENU_MOVE
	jp playSound

@bPressed:
	call saveQuitMenu_checkIsGameOver
	ret nz
	jp closeMenu

;;
; State 2: selected an option; after a delay, decide whether to reset, etc.
saveQuitMenu_state2:
	ld hl,wSaveQuitMenu.delayCounter
	dec (hl)
	ret nz

.ifdef ENABLE_NEW_GAME_PLUS
	call getIsInNgpDungeon
	jr z,+
		call saveQuitMenu_checkIsGameOver
		ld a,(wSaveQuitMenu.cursorIndex)
		jr z,++
			; continue option(opt 0) is removed from game over screen
			inc a
		++
		; check if selected continue
		or a
		jp z,closeMenu

		; check if selected quit
		dec a
		jp nz,resetGame

		; must have selected reload
		call loadFile
		call initSound
		ld a,$01
		ld (wSaveQuitMenu.delayCounter),a
		ld a,THREAD_0
		ld bc,thread_runSaveAndQuit
		call threadRestart
		jr ++
	+
.endif
	ld a,(wSaveQuitMenu.cursorIndex)
	cp $02
	jp z,resetGame

	call saveQuitMenu_checkIsGameOver
	jp z,closeMenu

.ifdef ENABLE_NEW_GAME_PLUS
	++
.endif
	; Reset game
	ld a,THREAD_1
	ld bc,mainThreadStart
	call threadRestart
	jp stubThreadStart

;;
saveQuitMenu_drawSprites:
.if defined(ROM_COMBO)
	callab bank2.fileSelect_redrawDecorationsAndSetWramBank4
.else
	call fileSelect_redrawDecorationsAndSetWramBank4
.endif

	; Flicker acorn if applicable
	ld a,(wSaveQuitMenu.delayCounter)
	and $04
	ret nz

	ld c,a ; c = 0
	ld a,(wSaveQuitMenu.cursorIndex)
	ld b,a
	add a
	add b
	swap a
	rrca
	ld b,a
	ld hl,@acornSprite
	jp addSpritesToOam_withOffset

@acornSprite:
	.db $01
	.db $48 $29 $28 $04