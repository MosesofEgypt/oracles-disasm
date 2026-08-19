; ==================================================================================================
; INTERAC_MONKEY
; ==================================================================================================
interactionCode39:
.if defined(ROM_COMBO)
	jpab agesInteractionsBank11.interactionCode39_body
.else
	jpab dataLoading.interactionCode39_body
.endif