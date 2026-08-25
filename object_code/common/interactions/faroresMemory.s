; ==================================================================================================
; INTERAC_FARORES_MEMORY
; ==================================================================================================
m_InteractionCode $1c
	call checkInteractionState
	jp nz,interactionRunScript

; Initialization

	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr nz,+
	call checkIsLinkedGame
	jp z,interactionDelete
+
	call interactionInitGraphics
	call objectSetVisible83

	ld hl,{SCRIPTS_1}.faroresMemoryScript
	call interactionSetScript

	jp interactionIncState
