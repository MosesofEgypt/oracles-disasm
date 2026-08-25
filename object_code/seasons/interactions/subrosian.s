; ==================================================================================================
; INTERAC_SUBROSIAN
; ==================================================================================================
m_InteractionCode $30
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5
@state0:
	ld a,$01
	ld (de),a
	call interactionInitGraphics
	ld h,d
	ld l,$6b
	ld (hl),$00
	ld l,$49
	ld (hl),$ff
	ld l,$42
	ld a,(hl)
	cp $25
	jr nz,+
	call checkIsLinkedGame
	jp z,interactionDelete
	ld a,GLOBALFLAG_UNBLOCKED_AUTUMN_TEMPLE
	call checkGlobalFlag
	jp z,interactionDelete
	ld e,$7e
	ld a,GLOBALFLAG_BEGAN_PLEN_SECRET-GLOBALFLAG_FIRST_SEASONS_BEGAN_SECRET
	ld (de),a
+
	ld e,$42
	ld a,(de)
	ld hl,table_607f
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	call interactionRunScript
	call interactionRunScript
	jp c,interactionDelete
	jp objectSetVisible82
@state1:
	ld a,(wActiveGroup)
	dec a
	jr nz,+
	call objectGetTileAtPosition
	ld (hl),$00
+
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	jp npcFaceLinkAndAnimate
@state2:
	call objectCheckCollidedWithLink_notDeadAndNotGrabbing
	call c,@func_600e
@animateAndRunScript:
	call interactionAnimate
	call interactionAnimate
	call interactionRunScript
	ld c,$60
	call objectUpdateSpeedZ_paramC
	ret nz
	ld bc,$fe00
	jp objectSetSpeedZ
@func_600e:
	ld hl,wTmpcfc0.normal.cfc0
	set 1,(hl)
	ret
@state3:
	call objectGetAngleTowardLink
	ld e,$49
	ld (de),a
	call objectApplySpeed
	jr @animateAndRunScript
@state4:
	ld c,$20
	call objectUpdateSpeedZ_paramC
	call interactionRunScript
	jp c,interactionDelete
	ret
@state5:
	call interactionRunScript
	ld e,$45
	ld a,(de)
	rst_jumpTable
	.dw @substate0
	.dw @substate1
	.dw @substate2
	.dw @substate3
@substate0:
	ld a,(wTmpcfc0.normal.cfc0)
	call getHighestSetBit
	ret nc
	cp $03
	jr nz,+
	ld e,$44
	ld a,$04
	ld (de),a
	ret
+
	ld b,a
	inc a
	ld e,$45
	ld (de),a
	ld a,b
	add $04
	jp interactionSetAnimation
@substate1:
	call interactionAnimate
	ld a,(wTmpcfc0.normal.cfc0)
	or a
	ret z
	ld e,$45
	xor a
	ld (de),a
	jr @substate0
@substate2:
@substate3:
	call interactionAnimate
	ld h,d
	ld l,$61
	ld a,(hl)
	or a
	jr z,+
	ld (hl),$00
	ld l,$4d
	add (hl)
	ld (hl),a
+
	ld a,(wTmpcfc0.normal.cfc0)
	or a
	ret z
	ld l,$45
	ld (hl),$00
	jr @substate0

table_607f:
	/* $00 */ .dw {SCRIPTS_1}.subrosianScript_smelterByAutumnTemple
	/* $01 */ .dw {SCRIPTS_1}.subrosianScript_smelterText1 ; unused?
	/* $02 */ .dw {SCRIPTS_1}.subrosianScript_smelterText1
	/* $03 */ .dw {SCRIPTS_1}.subrosianScript_smelterText2
	/* $04 */ .dw {SCRIPTS_1}.subrosianScript_smelterText3
	/* $05 */ .dw {SCRIPTS_1}.subrosianScript_smelterText4
	/* $06 */ .dw {SCRIPTS_1}.subrosianScript_beachText1
	/* $07 */ .dw {SCRIPTS_1}.subrosianScript_beachText2
	/* $08 */ .dw {SCRIPTS_1}.subrosianScript_beachText3
	/* $09 */ .dw {SCRIPTS_1}.subrosianScript_beachText4
	/* $0a */ .dw {SCRIPTS_1}.subrosianScript_villageText1
	/* $0b */ .dw {SCRIPTS_1}.subrosianScript_villageText2
	/* $0c */ .dw {SCRIPTS_1}.subrosianScript_shopkeeper
	/* $0d */ .dw {SCRIPTS_1}.subrosianScript_wildsText1
	/* $0e */ .dw {SCRIPTS_1}.subrosianScript_wildsText2
	/* $0f */ .dw {SCRIPTS_1}.subrosianScript_wildsText3
	/* $10 */ .dw {SCRIPTS_1}.subrosianScript_strangeBrother1_stealingFeather
	/* $11 */ .dw {SCRIPTS_1}.subrosianScript_strangeBrother2_stealingFeather
	/* $12 */ .dw {SCRIPTS_1}.subrosianScript_strangeBrother1_inHouse
	/* $13 */ .dw {SCRIPTS_1}.subrosianScript_strangeBrother2_inHouse
	/* $14 */ .dw {SCRIPTS_1}.subrosianScript_5716
	/* $15 */ .dw {SCRIPTS_1}.subrosianScript_westVolcanoesText1
	/* $16 */ .dw {SCRIPTS_1}.subrosianScript_westVolcanoesText2
	/* $17 */ .dw {SCRIPTS_1}.subrosianScript_eastVolcanoesText1
	/* $18 */ .dw {SCRIPTS_1}.subrosianScript_eastVolcanoesText2
	/* $19 */ .dw {SCRIPTS_1}.subrosianScript_southOfExitToSuburbsPortal
	/* $1a */ .dw {SCRIPTS_1}.subrosianScript_nearExitToTempleRemainsNorthsPortal
	/* $1b */ .dw {SCRIPTS_1}.subrosianScript_wildsNearLockedDoor
	/* $1c */ .dw {SCRIPTS_1}.subrosianScript_boomerangSubrosianFriend
	/* $1d */ .dw {SCRIPTS_1}.subrosianScript_screenRightOfBoomerangSubrosian
	/* $1e */ .dw {SCRIPTS_1}.subrosianScript_wildsInAreaWithOre
	/* $1f */ .dw {SCRIPTS_1}.subrosianScript_wildsOtherSideOfTreesToOre
	/* $20 */ .dw {SCRIPTS_1}.subrosianScript_wildsNorthOfStrangeBrothersHouse
	/* $21 */ .dw {SCRIPTS_1}.subrosianScript_wildsOutsideStrangeBrothersHouse
	/* $22 */ .dw {SCRIPTS_1}.subrosianScript_villageSouthOfShop
	/* $23 */ .dw {SCRIPTS_1}.subrosianScript_hasLavaPoolInHouse
	/* $24 */ .dw {SCRIPTS_1}.subrosianScript_beachText5
	/* $25 */ .dw {SCRIPTS_1}.subrosianScript_goldenByBombFlower
	/* $26 */ .dw {SCRIPTS_1}.subrosianScript_signsGuy
