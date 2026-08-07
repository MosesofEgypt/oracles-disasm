;;
; CUTSCENE_BLACK_TOWER_ESCAPE_ATTEMPT
cutscene1f:
.ifdef ROM_COMBO
	callab bank3Cutscenes_3.func_03_7cb7
.else
	callab bank3Cutscenes.func_03_7cb7
.endif
	call updateStatusBar
	jp updateAllObjects