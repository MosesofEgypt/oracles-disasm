.if defined(ROM_COMBO)

; these function copies were added so they're available from this bank

cutscene02:
	ret

setCutsceneIndexIfCutsceneTriggerSet:
	ld a,(wCutsceneTrigger)
	and $7f
	ld (wCutsceneIndex),a
	xor a
	ld (wCutsceneTrigger),a
	ld (wCutsceneState),a
	ret

applyWarpTransition2:
	ld hl,wWarpTransition2
	ld a,(hl)
	ld b,a
	ld (hl),$00
	and $0f
	cp $02
	jr nc,++

	ld a,$01
	ld (wGameState),a
	lda CUTSCENE_LOADING_ROOM
	ld (wCutsceneIndex),a
	ret
++
	ld a,(wLinkObjectIndex)
	cp $d1
	jr nz,+
	inc b
+
	ld a,b
	and $0f
	ld (wCutsceneIndex),a
	bit 7,b
	jp z,fadeoutToWhite

	ld a,$04
	jp fadeoutToWhiteWithDelay

func_5d41:
	call func_1613
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2
	jp updateAllObjects

func_5d31:
	call func_1613
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2

	call updateStatusBar
	jp updateAllObjects
.endif

;;
; CUTSCENE_S_DIN_DANCING
cutscene06:
	ld e,$00
	jp multiIntroCutsceneCaller

;;
; CUTSCENE_S_DIN_IMPRISONED
cutscene07:
	ld e,$01
	call multiIntroCutsceneCaller
	call updateInteractionsAndDrawAllSprites
	jp updateAnimationsAfterCutscene

;;
; CUTSCENE_S_TEMPLE_SINKING
cutscene08:
	ld e,$02
	call multiIntroCutsceneCaller
	jp updateInteractionsAndDrawAllSprites

;;
; CUTSCENE_S_DIN_CRYSTAL_DESCENDING
cutscene09:
	call func_1613
	ld e,$00
	call endgameCutsceneHandler
	ld a,(wWarpTransition2)
	or a
	ret z
	jp applyWarpTransition2

;;
; CUTSCENE_S_ROOM_OF_RITES_COLLAPSE
cutscene0f:
	call func_1613
	ld e,$02
	jp endgameCutsceneHandler

;;
; CUTSCENE_S_CREDITS
cutscene0a:
	ld e,$01
	jp endgameCutsceneHandler

;;
; CUTSCENE_S_VOLCANO_ERUPTING
cutscene0b:
.ifdef ROM_COMBO
	callab bank3Cutscenes_2.cutsceneHandler_0b
.else
	callab bank3Cutscenes.cutsceneHandler_0b
.endif
	jr func_5d31

;;
; CUTSCENE_S_PIRATES_DEPART
cutscene0c:
.ifdef ROM_COMBO
	callab bank3Cutscenes_2.cutsceneHandler_0c
.else
	callab bank3Cutscenes.cutsceneHandler_0c
.endif
	jr func_5d31

;;
; CUTSCENE_S_PREGAME_INTRO
cutscene0d:
	call func_1613
	ld e,$03
	jp multiIntroCutsceneCaller

;;
; CUTSCENE_S_ONOX_TAUNTING
cutscene0e:
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2
	ld e,$04
	call multiIntroCutsceneCaller
	jp updateAnimationsAfterCutscene

;;
; CUTSCENE_S_FLAME_OF_DESTRUCTION
cutscene10:
	call flameOfDestructionsCutsceneCaller
	jp func_5d41

;;
; CUTSCENE_S_ZELDA_VILLAGERS
cutscene11:
	call zeldaAndVillagersCutsceneCaller
	jp func_5d31

;;
; CUTSCENE_S_ZELDA_KIDNAPPED
cutscene12:
	call zeldaKidnappedCutsceneCaller
	jp func_5d41
