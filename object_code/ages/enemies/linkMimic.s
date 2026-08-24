; ==================================================================================================
; ENEMY_LINK_MIMIC
;
; Shares code with ENEMY_ARM_MIMIC.
; ==================================================================================================
m_EnemyCode $64
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie
	dec a
	jp nz,ecom_updateKnockback
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw linkMimic_state_stub
	.dw linkMimic_state_stub
	.dw linkMimic_state_switchHook
	.dw linkMimic_state_stub
	.dw ecom_blownByGaleSeedState
	.dw linkMimic_state_stub
	.dw linkMimic_state_stub
	.dw linkMimic_state8


@state_uninitialized:
	ld a,PALH_82
	call loadPaletteHeader
.if defined(ROM_COMBO)
	callab enemyCode2.armMimic_uninitialized
.else
	call armMimic_uninitialized
.endif
	jp objectSetVisible83


linkMimic_state8:
	ld a,(wDisabledObjects)
	or a
	ret nz
.if defined(ROM_COMBO)
	jpab enemyCode2.armMimic_state8
.else
	jr armMimic_state8
.endif

linkMimic_state_switchHook:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw ecom_incSubstate
	.dw @substate1
	.dw @substate2
	.dw ecom_fallToGroundAndSetState8

@substate1:
@substate2:
linkMimic_state_stub:
	ret