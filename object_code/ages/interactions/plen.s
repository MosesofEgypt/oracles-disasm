; ==================================================================================================
; INTERAC_PLEN
; ==================================================================================================
interactionCodecc:
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0

@subid0:
	call checkInteractionState
	jr nz,@state1

@state0:
	call @initialize
	call interactionSetAlwaysUpdateBit

@state1:
	call interactionRunScript
	jp c,interactionDelete
	jp interactionAnimateAsNpc
	call interactionInitGraphics
	jp interactionIncState

@initialize:
	call interactionInitGraphics
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw mainScripts.plenSubid0Script
