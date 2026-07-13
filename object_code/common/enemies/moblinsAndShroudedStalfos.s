; ==================================================================================================
; ENEMY_ARROW_MOBLIN
; ENEMY_MASKED_MOBLIN
; ENEMY_ARROW_SHROUDED_STALFOS
;
; These enemies and ENEMY_ARROW_DARKNUT share some code.
; ==================================================================================================
enemyCode0c:
enemyCode20:
enemyCode22:
	call ecom_checkHazards
	jr z,@normalStatus

	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jr z,@dead
	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret
@dead:
	ld e,Enemy.subid
	ld a,(de)
	cp $02
	jr nz,++
	ld hl,wKilledGoldenEnemies
	set 1,(hl)
++
	jp enemyDie

@normalStatus:
	call ecom_checkScentSeedActive
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw moblin_state_uninitialized
	.dw moblin_state_stub
.ifdef ENABLE_RING_REDUX
	.dw ecom_stateHeld
.else
	.dw moblin_state_stub
.endif
	.dw moblin_state_switchHook
	.dw moblin_state_scentSeed
	.dw ecom_blownByGaleSeedState
	.dw moblin_state_stub
	.dw moblin_state_stub
	.dw moblin_state_8
	.dw moblin_state_9


moblin_state_uninitialized:
	; Enable chasing scent seeds
	ld h,d
	ld l,Enemy.var3f
	set 4,(hl)

	ld l,Enemy.subid
	bit 1,(hl)
	jr z,++
	ld a,(wKilledGoldenEnemies)
	bit 1,a
	jp nz,enemyDelete
++
.ifdef ENABLE_NEW_GAME_PLUS
	call arrowDarknut_state_uninitialized
	ld h,d
	ld l,Enemy.id
	ld a,(hl)
	ld hl,@ngpEnemy0CUpgradeTable
	cp ENEMY_MASKED_MOBLIN
	jr nz,+
		ld hl,@ngpEnemy20UpgradeTable
	+
	cp ENEMY_ARROW_SHROUDED_STALFOS
	jr nz,+
		ld hl,@ngpEnemy22UpgradeTable
	+

	jp tryNgpUpgradeWeakEnemy

@ngpEnemy0CUpgradeTable:
	.dw @ngpEnemy0CUpgradeSubtable1
	.dw @ngpEnemy0CUpgradeSubtable1
	.dw @ngpEnemy0CUpgradeSubtable2

@ngpEnemy0CUpgradeSubtable1:
	.dw @ngpEnemy0CRedUpgrades1
	.dw @ngpEnemy0CBlueUpgrades
	.dw @ngpEnemy0CGoldUpgrades

@ngpEnemy0CUpgradeSubtable2:
	.dw @ngpEnemy0CRedUpgrades2
	.dw @ngpEnemy0CBlueUpgrades
	.dw @ngpEnemy0CGoldUpgrades

	@ngpEnemy0CRedUpgrades1:
		m_ngp_upgrade_p_si_d_h			PALETTE_RED   0 06 04
	@ngpEnemy0CRedUpgrades2:
		m_ngp_upgrade_p_si_d_h_s		PALETTE_RED   0 06 04 SPEED_c0
	@ngpEnemy0CBlueUpgrades:
		m_ngp_upgrade_p_si_d_h_s		PALETTE_BLUE  1 06 06 SPEED_c0
		m_ngp_upgrade_p_si_d_h_s_term	PALETTE_GREEN 1 08 08 SPEED_c0

	@ngpEnemy0CGoldUpgrades:
		m_ngp_upgrade_d_s_term						  16 SPEED_120

@ngpEnemy20UpgradeTable:
	.dw @ngpEnemy20UpgradeSubtable1
	.dw @ngpEnemy20UpgradeSubtable1
	.dw @ngpEnemy20UpgradeSubtable2

@ngpEnemy20UpgradeSubtable1:
	.dw @ngpEnemy20RedUpgrades1
	.dw @ngpEnemy20BlueUpgrades

@ngpEnemy20UpgradeSubtable2:
	.dw @ngpEnemy20RedUpgrades2
	.dw @ngpEnemy20BlueUpgrades

	@ngpEnemy20RedUpgrades1:
		m_ngp_upgrade_p_si_d_h			PALETTE_RED   0 06 03
	@ngpEnemy20RedUpgrades2:
		m_ngp_upgrade_p_si_d_h_s		PALETTE_RED   0 06 03 SPEED_c0
	@ngpEnemy20BlueUpgrades:
		m_ngp_upgrade_p_si_d_h_s		PALETTE_BLUE  1 06 05 SPEED_c0
		m_ngp_upgrade_p_si_d_h_s_term	PALETTE_GREEN 1 08 07 SPEED_c0

@ngpEnemy22UpgradeTable:
	.dw @ngpEnemy22UpgradeSubtable1
	.dw @ngpEnemy22UpgradeSubtable1
	.dw @ngpEnemy22UpgradeSubtable2

@ngpEnemy22UpgradeSubtable1:
	.dw @ngpEnemy22Upgrades1

@ngpEnemy22UpgradeSubtable2:
	.dw @ngpEnemy22Upgrades2

	@ngpEnemy22Upgrades1:
		m_ngp_upgrade_p_si_d_h			PALETTE_GREEN 0 06 05
	@ngpEnemy22Upgrades2:
		m_ngp_upgrade_p_si_d_h			PALETTE_GREEN 0 06 05
		m_ngp_upgrade_p_si_d_h_s		PALETTE_BLUE  0 06 07 SPEED_c0
		m_ngp_upgrade_p_si_d_h_s_term	PALETTE_RED   0 08 09 SPEED_c0
.else
	jp arrowDarknut_state_uninitialized
.endif


moblin_state_scentSeed:
	ld a,(wScentSeedActive)
	or a
	jp z,arrowDarknut_setState8WithRandomAngleAndCounter

	call ecom_updateAngleToScentSeed
	ld e,Enemy.angle
	ld a,(de)
	add $04
	and $18
	ld (de),a
	call ecom_updateAnimationFromAngle
	call ecom_applyVelocityForSideviewEnemy
	jp enemyAnimate


; Also used by darknuts
moblin_state_switchHook:
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


moblin_state_stub:
	ret


; Also darknut state 8 (moving in some direction)
moblin_state_8:
	call ecom_decCounter1
	jr z,+
	call ecom_applyVelocityForSideviewEnemyNoHoles
	jr nz,++
+
	call ecom_incState
	ld l,Enemy.counter1
	ld (hl),$08
++
	jp enemyAnimate


; Standing until counter1 reaches 0 and a new direction is decided on.
moblin_state_9:
	call ecom_decCounter1
	ret nz
	call ecom_setRandomCardinalAngle
	call arrowDarknut_setState8WithRandomAngleAndCounter
	jr arrowDarknut_fireArrowEveryOtherTime
