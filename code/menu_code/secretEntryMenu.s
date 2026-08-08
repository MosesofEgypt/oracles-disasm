
;;
; A secret entry menu called from in-game (not called from file select)
runSecretEntryMenu:
	call fileSelect_redrawDecorationsAndSetWramBank4
	call @func
	jp drawSecretInputCursors

@func:
	ld a,(wFileSelect.mode2)
	rst_jumpTable
	.dw @mode0
	.dw @mode1
	.dw @mode2
	.dw closeMenu
	.dw textInput_waitForInput

@mode0:
	ld a,GFXH_FILE_MENU_GFX
	call loadGfxHeader
	call func_02_465c
	jp fadeinFromWhite

; Run text input
@mode1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp runTextInput

; Check whether secret is good
@mode2:
	ld hl,w4SecretBuffer
	ld de,wTmpcec0
	ld b,$20
	call copyMemory

	; Unpack the secret (b=$01)
	ldbc $01,$03
	ld a,(wSecretInputType)
	rlca
	jr c,+
	ld c,$02
+
	call secretFunctionCaller
	jr nz,@invalidSecret

	; Verify the secret (b=$02)
	ld b,$02
	call secretFunctionCaller
	jr nz,@invalidSecret


	; [wEnemyPlacement.cec4] = the unpacked secret's "wShortSecretIndex" value (only for short secret
	; types)
	ld a,(wEnemyPlacement.cec4)
	ld b,a
	ld a,(wSecretInputType)
	cp $ff
	jr nz,++

	; 5-letter secret from farore (doesn't check which 5-letter secret it is)
	xor a
	ld (wSecretInputType),a
	ld a,b
	jr @setTextInputResult

++
	cp $02
	jr z,@loadRingSecretData

	; 5-letter secret: check that [wEnemyPlacement.cec4] == [wSecretInputType]&$3f (basically, this
	; is the short secret type that we're looking for, not somebody else's)
	and $3f
	sub b
	jr z,@setTextInputResult

@invalidSecret:
	ld a,$01

@setTextInputResult:
	ld (wTextInputResult),a
	jr nz,fileSelect_printError

	ld a,SND_SOLVEPUZZLE
	call playSound
	jp closeMenu

@loadRingSecretData:
	; Load the data from the ring secret (updates obtained rings)
	ldbc $04,$02
	call secretFunctionCaller
	xor a
	jr @setTextInputResult