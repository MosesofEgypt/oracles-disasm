; ==================================================================================================
; INTERAC_GAME_COMPLETE_DIALOG
; ==================================================================================================
m_InteractionCode $d1
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw interactionRunScript

@state0:
	ld a,$01
	ld (de),a
	ld c,a
	callab bank1.loadDeathRespawnBufferPreset
	ld hl,{SCRIPTS_1}.gameCompleteDialogScript
.if defined(ROM_COMBO) && defined(ENABLE_NEW_GAME_PLUS)
	call checkIsLinkedGame
	jr z,+
		; completed linked game
		ld hl,{SCRIPTS_1}.linkedGameCompleteDialogScript
	+
.endif
	jp interactionSetScript
