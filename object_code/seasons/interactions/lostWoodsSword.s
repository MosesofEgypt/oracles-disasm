; ==================================================================================================
; INTERAC_LOST_WOODS_SWORD
; ==================================================================================================
m_InteractionCode $59
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call getThisRoomFlags
	and $40
	jp nz,interactionDelete
	ld a,TREASURE_SWORD
	call checkTreasureObtained
	jr nc,++
		or a
		jr z,+
			dec a
		+
		.if defined(ROM_COMBO)
			cp $03
		.else
			cp $02
		.endif
		jp nc,interactionDelete
		ld e,Interaction.subid
		ld (de),a
	++
	call interactionInitGraphics
	call interactionIncState
	call objectSetVisible
	call objectSetVisible80
	ld hl,{SCRIPTS_1}.lostWoodsSwordScript
	call interactionSetScript
	ld a,$4d
	call playSound
	ldbc INTERAC_SPARKLE $04
	jp objectCreateInteraction
@state1:
	call interactionRunScript
	jp c,interactionDelete
	ret
