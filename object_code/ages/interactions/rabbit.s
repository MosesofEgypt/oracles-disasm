; ==================================================================================================
; INTERAC_RABBIT
; ==================================================================================================
interactionCode4b:
.if defined(ROM_COMBO)
	jpab agesInteractionsBank11.interactionCode4b_body
.else
	jpab bank3f.interactionCode4b_body
.endif