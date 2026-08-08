
;;
runKidNameEntryMenu:
	call fileSelect_redrawDecorationsAndSetWramBank4
	call @func
	jp drawNameInputCursors

@func:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw @mode1
	.dw @mode2

@mode0:
	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	ld a,$01
	call copyNameToW4NameBuffer
	jp fadeinFromWhite

@mode1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp runTextInput

@mode2:
	call getNameBufferLength
	ld a,$01
	jr z,+

	ld hl,w4NameBuffer
	ld de,wKidName
	ld b,$06
	call copyMemory
	ld a,SND_SELECTITEM
	call playSound
	xor a
+
	ld (wTextInputResult),a
	jp closeMenu