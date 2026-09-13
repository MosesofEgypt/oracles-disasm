; ==================================================================================================
; INTERAC_MUSTACHE_MAN
; ==================================================================================================
m_InteractionCode $42
	ld e,Interaction.subid
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	call checkInteractionState
	jr nz,@@initialized

.if defined(ROM_COMBO)
	ld a,GLOBALFLAG_FINISHEDGAME_AGES
.else
	ld a,GLOBALFLAG_FINISHEDGAME
.endif
	call checkGlobalFlag
	jp nz,interactionDelete
	call @initGraphicsAndScript
@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

@subid1:
	call checkInteractionState
	jr nz,@@initialized

	ld e,Interaction.var32
	ld a,$02
	ld (de),a
	call @initGraphicsAndScript

@@initialized:
	call interactionRunScript
	jp interactionAnimateAsNpc

; Unused
@func_52e8:
	call interactionInitGraphics
	call objectMarkSolidPosition
	jp interactionIncState

@initGraphicsAndScript:
	call interactionInitGraphics
	call objectMarkSolidPosition

	ld a,>TX_0f00
	call interactionSetHighTextIndex

	ld e,Interaction.subid
	ld a,(de)
	ld hl,@scriptTable
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	jp interactionIncState

@scriptTable:
	.dw {SCRIPTS_1}.mustacheManScript
	.dw {SCRIPTS_1}.genericNpcScript
