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
			and $03
		.else
			and $01
		.endif
		jp nc,interactionDelete
		dec a
		ld e,$42
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
