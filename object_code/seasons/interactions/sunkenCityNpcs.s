; ==================================================================================================
; INTERAC_FLOODED_HOUSE_GIRL
; INTERAC_MASTER_DIVERS_WIFE
; INTERAC_MASTER_DIVER
; ==================================================================================================
m_InteractionCode $8a
m_InteractionCode $8b
m_InteractionCode $8d
	call checkInteractionState
	jr nz,@state1
	ld a,$01
	ld (de),a
	ld e,$41
	ld a,(de)
.if defined(ROM_COMBO)
	cp INTERAC_MASTER_DIVER_SEASONS
.else
	cp INTERAC_MASTER_DIVER
.endif
	jr nz,+
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jp nc,interactionDelete
	call getHighestSetBit
	cp $02
	jp c,interactionDelete
	; master diver - at least 3rd essence gotten
+
	call getSunkenCityNPCVisibleSubId_caller
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
	cp $01
	jr nz,@npcShouldAppear
	; 4th essence gotten
	ld e,$41
	ld a,(de)
	cp INTERAC_MASTER_DIVERS_WIFE
	jr nz,@npcShouldAppear
	ld a,GLOBALFLAG_MOBLINS_KEEP_DESTROYED
	call checkGlobalFlag
	ld b,<ROOM_SEASONS_05d
	jr nz,@wifeShouldAppear
	ld b,<ROOM_SEASONS_1b6
@wifeShouldAppear:
	ld a,(wActiveRoom)
	cp b
	jp nz,interactionDelete
@npcShouldAppear:
	call interactionInitGraphics
	ld e,$49
	ld a,$04
	ld (de),a
	ld e,$41
	ld a,(de)
	ld hl,@floodedHouseGirlScripts
	cp INTERAC_FLOODED_HOUSE_GIRL
	jr z,@setScript
	ld hl,@masterDiversWifeScripts
	cp INTERAC_MASTER_DIVERS_WIFE
	jr z,@setScript
	ld hl,@masterDiverScripts
@setScript:
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
@state1:
	call interactionRunScript
	jp interactionAnimateAsNpc

@floodedHouseGirlScripts:
	.dw {SCRIPTS_1}.floodedHouseGirlScript_text1
	.dw {SCRIPTS_1}.floodedHouseGirlScript_text2
	.dw {SCRIPTS_1}.floodedHouseGirlScript_text3
	.dw {SCRIPTS_1}.floodedHouseGirlScript_text4
	.dw {SCRIPTS_1}.floodedHouseGirlScript_text5

@masterDiversWifeScripts:
	.dw {SCRIPTS_1}.masterDiversWifeScript_text1
	.dw {SCRIPTS_1}.masterDiversWifeScript_text2
	.dw {SCRIPTS_1}.masterDiversWifeScript_text3
	.dw {SCRIPTS_1}.masterDiversWifeScript_text4
	.dw {SCRIPTS_1}.masterDiversWifeScript_text5

@masterDiverScripts:
	.dw {SCRIPTS_1}.masterDiverScript_text1
	.dw {SCRIPTS_1}.masterDiverScript_text2
	.dw {SCRIPTS_1}.masterDiverScript_text3
	.dw {SCRIPTS_1}.masterDiverScript_text4
	.dw {SCRIPTS_1}.masterDiverScript_text5
