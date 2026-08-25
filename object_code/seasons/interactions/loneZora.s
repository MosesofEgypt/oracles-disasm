; ==================================================================================================
; INTERAC_LONE_ZORA
; ==================================================================================================
m_InteractionCode $e7
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld a,$36
	call interactionSetHighTextIndex
	ld e,$7e
	ld a,GLOBALFLAG_BEGAN_KING_ZORA_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld (de),a
	ld hl,{SCRIPTS_1}.linkedGameNpcScript
	call interactionSetScript
	ld a,$02
	call interactionSetAnimation
@state1:
	call interactionRunScript
	jp npcFaceLinkAndAnimate
