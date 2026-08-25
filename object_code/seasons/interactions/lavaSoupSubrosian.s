; ==================================================================================================
; INTERAC_LAVA_SOUP_SUBROSIAN
; ==================================================================================================
m_InteractionCode $5c
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	call interactionIncState
	ld l,$49
	ld (hl),$04
	ld a,>TX_0b00
	call interactionSetHighTextIndex
	ld hl,{SCRIPTS_1}.lavaSoupSubrosianScript
	call interactionSetScript
@state1:
	call interactionRunScript
	ld e,$7f
	ld a,(de)
	or a
	jp z,npcFaceLinkAndAnimate
	call interactionAnimate
	jp objectSetPriorityRelativeToLink_withTerrainEffects
