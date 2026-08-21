; ==================================================================================================
; ENEMY_ARROW_DARKNUT
; ==================================================================================================
m_EnemyCode $21
	call ecom_seasonsFunc_4446
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
	.dw arrowDarknut_state_uninitialized
	.dw moblin_state_stub
.ifdef ENABLE_RING_REDUX
	.dw ecom_stateHeld
.else
	.dw moblin_state_stub
.endif
	.dw moblin_state_switchHook
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_8
	.dw arrowDarknut_state_9


; Also used by moblins
arrowDarknut_state_uninitialized:
	ld e,Enemy.speed
	ld a,SPEED_80
	ld (de),a
.ifdef ENABLE_NEW_GAME_PLUS
	ld hl,@ngpUpgradeTable
	call tryNgpUpgradeWeakEnemy
.endif
	call ecom_setRandomCardinalAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter
	jp objectSetVisiblec2

.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpUpgradeSubtable1
	.dw @ngpUpgradeSubtable1
	.dw @ngpUpgradeSubtable2

@ngpUpgradeSubtable1:
	.dw @ngpRedUpgrades1
	.dw @ngpBlueUpgrades
	.dw @ngpGoldUpgrades

@ngpUpgradeSubtable2:
	.dw @ngpRedUpgrades2
	.dw @ngpBlueUpgrades
	.dw @ngpGoldUpgrades

	@ngpRedUpgrades1:
		m_ngp_upgrade_p_si_d_h		PALETTE_RED   0 06 08
	@ngpRedUpgrades2:
		m_ngp_upgrade_p_si_d_h		PALETTE_RED   0 06 08
	@ngpBlueUpgrades:
		m_ngp_upgrade_p_si_d_h		PALETTE_BLUE  1 08 11
		m_ngp_upgrade_p_si_d_h_term	PALETTE_GREEN 1 10 12

	@ngpGoldUpgrades:
		m_ngp_upgrade_p_si_h_s_term	PALETTE_GOLD  2 16 SPEED_100
.endif


arrowDarknut_state_9:
	call ecom_decCounter1
	ret nz
	call arrowDarknut_chooseAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter

; This is also used by moblin's state 9.
; Every other time they move, if they're facing Link, fire an arrow.
arrowDarknut_fireArrowEveryOtherTime:
	ld h,d
	ld l,Enemy.var30
	inc (hl)
	bit 0,(hl)
	ret z
	call objectGetAngleTowardEnemyTarget
	add $04
	and $18
	ld h,d
	ld l,Enemy.angle
	cp (hl)
	ret nz
	ld b,PART_ENEMY_ARROW
	jp ecom_spawnProjectile


;;
; Sets random angle and counter, and goes to state 8.
arrowDarknut_setState8WithRandomAngleAndCounter:
	call getRandomNumber_noPreserveVars
	and $3f
	add $30
	ld h,d
	ld l,Enemy.counter1
	ld (hl),a
	ld l,Enemy.state
	ld (hl),$08
	jp ecom_updateAnimationFromAngle

;;
; 1-in-4 chance of turning to face Link directly, otherwise turns in a random direction.
arrowDarknut_chooseAngle:
	call getRandomNumber_noPreserveVars
	and $03
	jp z,ecom_updateCardinalAngleTowardTarget
	jp ecom_setRandomCardinalAngle
