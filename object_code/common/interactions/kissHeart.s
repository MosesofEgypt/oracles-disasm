; ==================================================================================================
; INTERAC_KISS_HEART
; ==================================================================================================
m_InteractionCode $b7
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state1
	.dw interactionAnimate

@state1:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	jp objectSetVisible82
