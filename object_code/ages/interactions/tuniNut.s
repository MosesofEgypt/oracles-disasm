; ==================================================================================================
; INTERAC_TUNI_NUT
; ==================================================================================================
interactionCodeb1:
.ifdef ENABLE_NEW_GAME_PLUS
	jpab bank3e.interactionCodeb1_body
.else
	jpab bank3f.interactionCodeb1_body
.endif
