; ==================================================================================================
; ENEMY_ARM_MIMIC
;
; Shares code with ENEMY_LINK_MIMIC.
;
; Variables:
;   var30: Animation index
; ==================================================================================================
enemyCode4e:
	call ecom_checkHazards
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw armMimic_uninitialized
	.dw armMimic_state_stub
.ifdef ENABLE_RING_REDUX
	.dw ecom_stateHeld
.else
	.dw armMimic_state_stub
.endif
	.dw armMimic_state_switchHook
	.dw armMimic_state_stub
	.dw ecom_blownByGaleSeedState
	.dw armMimic_state_stub
	.dw armMimic_state_stub
	.dw armMimic_state8


armMimic_uninitialized:
	ld e,Enemy.var30
	ld a,(w1Link.direction)
	add $02
	and $03
	ld (de),a
	call enemySetAnimation

	ld a,SPEED_100
.ifdef ENABLE_NEW_GAME_PLUS
	call ecom_setSpeedAndState8AndVisible
	ld hl,@ngpUpgradeTable
	jp tryNgpUpgradeStrongEnemyIgnoreSubids
.else
	jp ecom_setSpeedAndState8AndVisible
.endif

.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpEnemyUpgrades
	.dw @ngpEnemyUpgrades
	.dw @ngpEnemyUpgrades

@ngpEnemyUpgrades:
	m_ngp_upgrade_p_d_h				PALETTE_GOLD      10  7
	m_ngp_upgrade_p_d_h				PALETTE_RED       10  7
	m_ngp_upgrade_p_si_d_h_s		PALETTE_BLUE   01 10  7 SPEED_180
	m_ngp_upgrade_p_si_d_h_s_term	PALETTE_GREEN  02 16 12 SPEED_140
.endif


armMimic_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
	ret


armMimic_state_stub:
	ret


; Only "normal" state; simply moves in reverse of Link's direction.
armMimic_state8:
	; Check that Link is moving
	ld a,(wLinkAngle)
	inc a
.ifdef ENABLE_NEW_GAME_PLUS
	ld h,d
	ld l,Enemy.subid
	jr nz,+
		ld a,(hl)
		cp $02
		ret nz

		call objectGetAngleTowardLink
		; update angle
		ld h,d
		ld l,Enemy.angle
		ldd (hl),a

		; update direction
		sla a
		swap a
		and $03
		ldd (hl),a

		push af
		ld e,Enemy.angle
		call ecom_applyVelocityForSideviewEnemyNoHoles
		pop af
		ld h,d
		ld l,Enemy.var30
		jr ++
	+
	ld e,a
	ld a,(hl)
	or a
	jr z,+
		ld hl,wFrameCounter
		xor a
		bit 5,(hl)
		jr z,+
			add $08
			bit 6,(hl)
			jr z,+
				add $10
	+
	add e
.else
	ret z
.endif
	add $0f
	and $1f
	ld e,Enemy.angle
	ld (de),a
	call ecom_applyVelocityForSideviewEnemyNoHoles

	ld h,d
	ld l,Enemy.var30
	ld a,(w1Link.direction)
	add $02
	and $03
	++
	cp (hl)
	jr z,@animate

	ld (hl),a
	call enemySetAnimation
@animate:
	jp enemyAnimate
