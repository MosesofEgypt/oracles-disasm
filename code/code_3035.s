; For some reason this code shifts places between Ages and Seasons.

;;
; @param	hl
objectLoadMovementScript:
	ldh a,(<hRomBank)
	push af
.if defined(ROM_COMBO)
	callfrombank0 objectMovement.objectLoadMovementScript_body
.elif defined(ROM_AGES)
	callfrombank0 bank0e.objectLoadMovementScript_body
.else
	callfrombank0 bank0d.objectLoadMovementScript_body
.endif
	pop af
	rst_setrombank
	ret

;;
objectRunMovementScript:
	ldh a,(<hRomBank)
	push af
.if defined(ROM_COMBO)
	callfrombank0 objectMovement.objectRunMovementScript_body
.elif defined(ROM_AGES)
	callfrombank0 bank0e.objectRunMovementScript_body
.else
	callfrombank0 bank0d.objectRunMovementScript_body
.endif
	pop af
	rst_setrombank
	ret

;;
decCbb3:
	ld hl,wTmpcbb3
	dec (hl)
	ret

;;
incCbc1:
	ld hl,wMapMenu.drawWarpDestinations
	inc (hl)
	ret

;;
incCbc2:
	ld hl,wGenericCutscene.cbc2
	inc (hl)
	ret

;;
; @param	e
endgameCutsceneHandler:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank3Cutscenes.endgameCutsceneHandler_body
	pop af
	rst_setrombank
	ret

;;
getEntryFromObjectTable1:
	ldh a,(<hRomBank)
	push af
.ifdef ROM_COMBO
	ld hl, objectData_seasons.objectTable1
	ld a, :objectData_seasons.objectTable1
	call wIsSeasons
	jr c,+
		ld hl, objectData.objectTable1
		ld a, :objectData.objectTable1
	+
	rst_setrombank
	ld a,b
.else
	ld a, :objectData.objectTable1
	rst_setrombank
	ld a,b
	ld hl, objectData.objectTable1
.endif
	rst_addDoubleIndex
	rst_derefHl
	pop af
	rst_setrombank
	ret

;;
fileSelect_redrawDecorations:
	ldh a,(<hRomBank)
	push af
	callfrombank0 bank2.fileSelect_redrawDecorationsAndSetWramBank4
	pop af
	rst_setrombank
	xor a
	ld ($ff00+R_SVBK),a
	ret


.if defined(ROM_AGES) || defined(ROM_COMBO)
;;
; Does a lot of initialization, sets wActiveGroup/wActiveRoom to the given values. This
; does not load the room's objects.
;
; After calling this, the LCD needs to be re-enabled, and the Link object needs to be
; created.
;
; @param	b	Group
; @param	c	Room
disableLcdAndLoadRoom:
	ldh a,(<hRomBank)
	push af
.ifdef ROM_COMBO
	callfrombank0 bank3Cutscenes.disableLcdAndLoadRoom_body_ages
.else
	callfrombank0 bank3Cutscenes.disableLcdAndLoadRoom_body
.endif
	pop af
	rst_setrombank
	ret

;;
; Plays SND_WAVE, and writes something to 'hl'.
;
; @param	hl
playWaveSoundAtRandomIntervals:
	ldh a,(<hRomBank)
	push af
.ifdef ROM_COMBO
	callfrombank0 bank3Cutscenes.agesFunc_10_7298@playWaveSoundAtRandomIntervals_body
.else
	callfrombank0 cutscenesBank10.agesFunc_10_7298@playWaveSoundAtRandomIntervals_body
.endif
	pop af
	rst_setrombank
	ret

.endif


;;
; Same as "addSpritesToOam_withOffset", except this changes the bank first.
;
; @param	bc	Sprite offset
; @param	e	Bank where the OAM data is
; @param	hl	OAM data
addSpritesFromBankToOam_withOffset:
	ldh a,(<hRomBank)
	push af
	ld a,e
	rst_setrombank
	call addSpritesToOam_withOffset
	pop af
	rst_setrombank
	ret


.if defined(ROM_AGES) || defined(ROM_COMBO)

;;
; Same as "addSpritesToOam", except this changes the bank first.
;
; @param	e	Bank where the OAM data is
; @param	hl	OAM data
addSpritesFromBankToOam:
	ldh a,(<hRomBank)
	push af
	ld a,e
	rst_setrombank
	call addSpritesToOam
	pop af
	rst_setrombank
	ret

.endif
