; ==================================================================================================
; INTERAC_MISC_MAN
; ==================================================================================================
m_InteractionCode $41
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero
	.dw @subidNonzero

@subid0:
	call checkInteractionState
	jr nz,++
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jp nz,interactionDelete
	ld a,GLOBALFLAG_0b
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsIncStateAndLoadScript
++
	call interactionRunScript
	jp npcFaceLinkAndAnimate

@subidNonzero:
	call checkInteractionState
	jr nz,@@initialized

	ld a,$01
	ld e,Interaction.oamFlags
	ld (de),a

	callab getGameProgress_1
	ld e,Interaction.subid
	ld a,(de)
	dec a
	cp b
	jp nz,interactionDelete

	ld hl,@scriptTable+2
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript

	ld a,>TX_2600
	call interactionSetHighTextIndex
	call @initGraphicsAndIncState

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

@initGraphicsAndIncState:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

;;
@initGraphicsIncStateAndLoadScript:
	call interactionInitGraphics
	call objectMarkSolidPosition
	ld a,>TX_2600
	call interactionSetHighTextIndex
	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw {SCRIPTS_1}.manOutsideD2Script
	.dw {SCRIPTS_1}.lynnaManScript_befored3
	.dw {SCRIPTS_1}.lynnaManScript_afterd3
	.dw {SCRIPTS_1}.lynnaManScript_afterNayruSaved
	.dw {SCRIPTS_1}.lynnaManScript_afterd7
	.dw {SCRIPTS_1}.lynnaManScript_afterGotMakuSeed
	.dw {SCRIPTS_1}.lynnaManScript_postGame
