; ==================================================================================================
; INTERAC_TUNI_NUT
; ==================================================================================================
interactionCodeb1:
.if defined(ROM_COMBO)
	jpab agesInteractionsBank11.interactionCodeb1_body
.elif defined(ENABLE_NEW_GAME_PLUS)
	jpab bank3e.interactionCodeb1_body
.else
	jpab bank3f.interactionCodeb1_body
.endif
