; ==================================================================================================
; INTERAC_RABBIT
; ==================================================================================================
interactionCode4b:
.if defined(ROM_COMBO)
	jpab agesInteractionsBank11.interactionCode4b_body
.else
	jpab dataLoading.interactionCode4b_body
.endif