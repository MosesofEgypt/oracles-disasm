; ==================================================================================================
; PART_ZORA_FIRE
; PART_GOPONGA_PROJECTILE
; ==================================================================================================
m_PartCode $19
m_PartCode $31
	jp nz,partDelete
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.counter1
	ld (hl),$08
	ld l,Part.speed
	ld (hl),SPEED_180
.ifdef ENABLE_NEW_GAME_PLUS
	ld hl,@ngpUpgradeTable
	call tryNgpUpgradeProjectileIgnoreSubids
.endif
	jp objectSetVisible81

@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,Part.subid
	bit 0,(hl)
	jr z,+
	ldh a,(<hFFB2)
	ld b,a
	ldh a,(<hFFB3)
	ld c,a
	call objectGetRelativeAngle
	ld e,Part.angle
	ld (de),a
	ret
+
	call objectGetAngleTowardEnemyTarget
	ld e,Part.angle
	ld (de),a
	ret

@state2:
	ld a,(wFrameCounter)
	and $03
	jr nz,+
	ld e,Part.oamFlags
	ld a,(de)
	xor $07
	ld (de),a
+
	call objectApplySpeed
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	jp partAnimate

.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpProjectileUpgrades1
	.dw @ngpProjectileUpgrades2
	.dw @ngpProjectileUpgrades2

	@ngpProjectileUpgrades1:
		m_ngp_upgrade_d_s_term		04 SPEED_280
	@ngpProjectileUpgrades2:
		m_ngp_upgrade_p_d_s_term	PALETTE_BLUE_INV  08 SPEED_400
.endif