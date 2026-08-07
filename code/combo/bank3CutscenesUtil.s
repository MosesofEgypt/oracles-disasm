
;;
incCutsceneState:
	ld hl,wCutsceneState
	inc (hl)
	ret

;;
cutscene_clearObjects:
	call clearDynamicInteractions
	call clearLinkObject
	jp refreshObjectGfx

;;
; @param	bc	ID of interaction to create
createInteraction:
	call getFreeInteractionSlot
	ret nz
	ld (hl),b
	inc l
	ld (hl),c
	ret

;;
clearFadingPalettes2:
	; Clear w2FadingBgPalettes and w2FadingSprPalettes
	ld a,:w2FadingBgPalettes
	ld ($ff00+R_SVBK),a
	ld hl,w2FadingBgPalettes
	ld b,$80
	call clearMemory

	xor a
	ld ($ff00+R_SVBK),a
	dec a
	ldh (<hSprPaletteSources),a
	ldh (<hDirtySprPalettes),a
	ld a,$fd
	ldh (<hBgPaletteSources),a
	ldh (<hDirtyBgPalettes),a
	ret

disableLcdAndLoadRoom_body:
	ld (wRoomStateModifier),a
	ld a,b
	ld (wActiveGroup),a
	ld a,c
	ld (wActiveRoom),a
	call disableLcd
	call clearScreenVariablesAndWramBank1
	ld hl,wLinkInAir
	ld b,wcce9-wLinkInAir
	call clearMemory

;;
cutscene_decCBB3IfNotFadingOut:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	jp decCbb3

;;
cutscene_decCBB3IfTextNotActive:
	ld a,(wTextIsActive)
	or a
	ret nz
	jp decCbb3

cutscene_loadAObjectGfxBTimes:
	ld hl,wLoadedObjectGfx
cutscene_loadAintoHL_BTimes:
	ldi (hl),a
	inc a
	ld (hl),$01
	inc l
	dec b
	jr nz,cutscene_loadAintoHL_BTimes
	ret