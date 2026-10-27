;;
; CUTSCENE_FAIRIES_HIDE

cutscene13:
.ifdef ROM_COMBO
	callab bank3Cutscenes_3.func_03_6103
.else
	callab bank3Cutscenes.func_03_6103
.endif
	call maybeRefreshObjectGfx
	jp updateAllObjects

;;
; CUTSCENE_BOOTED_FROM_PALACE
cutscene14:
.ifdef ROM_COMBO
	callab bank3Cutscenes_3.func_03_6275
.else
	callab bank3Cutscenes.func_03_6275
.endif
	call maybeRefreshObjectGfx
	call updateAllObjects
	jp updateStatusBar