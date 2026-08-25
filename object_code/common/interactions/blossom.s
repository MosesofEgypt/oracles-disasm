; ==================================================================================================
; INTERAC_BLOSSOM
; ==================================================================================================
m_InteractionCode $2b
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call interactionInitGraphics
	ld a,>TX_4400
	call interactionSetHighTextIndex
	call interactionIncState

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript

	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @initAnimation0
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation0
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4
	.dw @initAnimation4

@initAnimation0:
	ld a,$00
	call interactionSetAnimation
	jp @updateCollisionAndVisibility

@initAnimation4:
	ld a,$04
	call interactionSetAnimation
	jp @updateCollisionAndVisibility

@state1:
	call interactionRunScript
	jp @updateAnimation

@updateAnimation:
	call interactionAnimate

@updateCollisionAndVisibility:
	call objectPreventLinkFromPassing
	jp objectSetPriorityRelativeToLink_withTerrainEffects

@scriptTable:
	.dw {SCRIPTS_1}.blossomScript0
	.dw {SCRIPTS_1}.blossomScript1
	.dw {SCRIPTS_1}.blossomScript2
	.dw {SCRIPTS_1}.blossomScript3
	.dw {SCRIPTS_1}.blossomScript4
	.dw {SCRIPTS_1}.blossomScript5
	.dw {SCRIPTS_1}.blossomScript6
	.dw {SCRIPTS_1}.blossomScript7
	.dw {SCRIPTS_1}.blossomScript8
	.dw {SCRIPTS_1}.blossomScript9
