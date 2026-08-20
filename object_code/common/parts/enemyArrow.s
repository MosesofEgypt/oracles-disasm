; ==================================================================================================
; PART_ENEMY_ARROW
; ==================================================================================================
m_PartCode $1a
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $80
	jr z,@partDelete
	jr @func_11_513a
@normalStatus:
	ld e,$c2
	ld a,(de)
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@subid0:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$50
	ld l,$cb
	ld b,(hl)
	ld l,$cd
	ld c,(hl)
	call partCommon_setPositionOffsetAndRadiusFromAngle
.ifdef ENABLE_NEW_GAME_PLUS
	ld hl,@ngpUpgradeTable
	call tryNgpUpgradeProjectileIgnoreSubids
.endif
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81

@@state1:
	call partCommon_checkTileCollisionOrOutOfBounds
	jr nc,@objectApplySpeed
	jr z,@partDelete
	jr @func_11_513a

@subid1:
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @@state0
	.dw @@state1
	.dw @subid0@state1
	.dw partCommon_updateSpeedAndDeleteWhenCounter1Is0

@@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$c6
	ld (hl),$08
	ld l,$d0
	ld (hl),$50
	ld e,$c9
	ld a,(de)
	swap a
	rlca
	call partSetAnimation
	jp objectSetVisible81

@@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,+
	ld l,e
	inc (hl)
	jr @subid0@state1
+
	call partCommon_checkOutOfBounds
	jr z,@partDelete
@objectApplySpeed:
	jp objectApplySpeed
@partDelete:
	jp partDelete
@func_11_513a:
	ld e,$c2
	ld a,(de)
	or a
	ld a,$02
	jr z,+
	ld a,$03
+
	ld e,$c4
	ld (de),a
	ld a,$04
	jp partCommon_bounceWhenCollisionsEnabled

.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpProjectileUpgrades
	.dw @ngpProjectileUpgrades
	.dw @ngpProjectileUpgrades

	@ngpProjectileUpgrades:
		m_ngp_upgrade_d_s			06 SPEED_300
		m_ngp_upgrade_p_d_s_term	PALETTE_GOLD  08 SPEED_400
.endif