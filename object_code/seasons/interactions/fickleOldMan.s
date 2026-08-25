; ==================================================================================================
; INTERAC_FICKLE_OLD_MAN
; ==================================================================================================
m_InteractionCode $80
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld b,$07
	call checkIfHoronVillageNPCShouldBeSeen
	ld a,c
	or a
	jp z,interactionDelete
	ld e,Interaction.subid
	ld a,b
	ld (de),a
	ld hl,@table_7717
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	jp objectSetVisible82
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc
@table_7717:
	.dw {SCRIPTS_1}.fickleOldManScript_text1
	.dw {SCRIPTS_1}.fickleOldManScript_text1
	.dw {SCRIPTS_1}.fickleOldManScript_text2
	.dw {SCRIPTS_1}.fickleOldManScript_text2
	.dw {SCRIPTS_1}.fickleOldManScript_text3
	.dw {SCRIPTS_1}.fickleOldManScript_text4
	.dw {SCRIPTS_1}.fickleOldManScript_text4
	.dw {SCRIPTS_1}.fickleOldManScript_text4
	.dw {SCRIPTS_1}.fickleOldManScript_text5
	.dw {SCRIPTS_1}.fickleOldManScript_text2
	.dw {SCRIPTS_1}.fickleOldManScript_text6
