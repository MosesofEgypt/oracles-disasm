; ==================================================================================================
; PART_OCTOROK_PROJECTILE
; ==================================================================================================
partCode18:
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jp z,partDelete
	ld h,d
	ld l,$c4
	ld a,(hl)
	cp $02
	jr nc,@normalStatus
	ld (hl),$02

@normalStatus:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
.ifdef ENABLE_NEW_GAME_PLUS
	ld hl,@ngpUpgradeTable
	xor a	; indicate this is a weak projectile
	call tryNgpUpgradeUncapped
.endif
	jp objectSetVisible81

@state1:
	call objectCheckWithinScreenBoundary
	jp nc,partDelete
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,+
	jp z,partDelete
	ld e,$c4
	ld a,$02
	ld (de),a
+
	jp objectApplySpeed

@state2:
	ld a,$03
	ld (de),a
	xor a
	jp partCommon_bounceWhenCollisionsEnabled

.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpUpgradeSubtable1
	.dw @ngpUpgradeSubtable2
	.dw @ngpUpgradeSubtable2

@ngpUpgradeSubtable1:
	.dw @ngpProjectileUpgrades1
	@ngpProjectileUpgrades1:
		m_ngp_upgrade_d_s_term		06 SPEED_200

@ngpUpgradeSubtable2:
	.dw @ngpProjectileUpgrades2
	@ngpProjectileUpgrades2:
		m_ngp_upgrade_p_d_s_term	PALETTE_RED 08 SPEED_300
.endif