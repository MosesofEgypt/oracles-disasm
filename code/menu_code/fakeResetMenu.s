
;;
; Runs the fake reset that happens when getting the sign ring in Seasons.
runFakeReset:
	ld a,(wFakeResetMenu.state)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call disableLcd
	call clearOam
	call clearVram
	call initializeVramMaps

	ld a,SNDCTRL_DISABLE
	call playSound

	ld a,GFXH_NINTENDO_CAPCOM_SCREEN
	call loadGfxHeader
	ld a,PALH_01
	call loadPaletteHeader

	ld a,120 ; Wait 2 seconds before fading the nintendo/capcom logo away
	ld (wFakeResetMenu.delayCounter),a

	ld hl,wFakeResetMenu.state
	inc (hl)

	call fadeinFromWhite
	xor a
	jp loadGfxRegisterStateIndex

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld hl,wFakeResetMenu.delayCounter
	dec (hl)
	ret nz

	ld a,SNDCTRL_ENABLE
	call playSound
	ld hl,wMenuLoadState
	inc (hl)
	jp fadeoutToWhite

