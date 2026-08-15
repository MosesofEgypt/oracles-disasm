; ==================================================================================================
; INTERAC_MONKEY
; ==================================================================================================
interactionCode39:
.if defined(ROM_COMBO)
	jpab agesInteractionsBank11.interactionCode39_body
.else
	jpab bank3f.interactionCode39_body
.endif