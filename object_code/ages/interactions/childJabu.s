; ==================================================================================================
; INTERAC_CHILD_JABU
; ==================================================================================================
m_InteractionCode $ba
	call checkInteractionState
	jr nz,@state0

@state1:
	call interactionInitGraphics
	call interactionSetAlwaysUpdateBit
	call interactionIncState
	ld bc,$0e06
	call objectSetCollideRadii
	ld hl,{SCRIPTS_1}.childJabuScript
	call interactionSetScript
	jp objectSetVisible82

@state0:
	call interactionAnimateAsNpc
	jp interactionRunScript
