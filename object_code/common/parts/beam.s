; ==================================================================================================
; PART_BEAM
; ==================================================================================================
m_PartCode $29
	jr z,@normalStatus
	ld e,$ea
	ld a,(de)
	cp $83
	jp z,partDelete
@normalStatus:
	ld e,Part.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
.ifdef ENABLE_NEW_GAME_PLUS
	ld h,d
	ld l,Part.speed
	ld (hl),SPEED_200 ; default for beam
	ld hl,@ngpUpgradeTable
	call tryNgpUpgradeProjectileIgnoreSubids
.endif
	ld h,d
	ld l,e
	inc (hl)
	ld l,Part.counter1
	ld (hl),$02
	ld l,Part.angle
	ld c,(hl)
.ifdef ENABLE_NEW_GAME_PLUS
	ld l,Part.speed
	ld b,(hl)
.else
	ld b,$50
.endif

.ifdef ENABLE_EVIL_BULLSHIT_BEAMOS
	ld l,Part.var2f
	ld (hl),b
.endif
	ld a,$04
	call objectSetComponentSpeedByScaledVelocity
	ld e,Part.angle
	ld a,(de)
	and $0f
	ld hl,@table_5737
	rst_addAToHl
	ld a,(hl)
	jp partSetAnimation

.ifdef ENABLE_NEW_GAME_PLUS
; on NG+ the beams get crazy
@ngpUpgradeTable:
	.dw @ngpProjectileUpgrades1
	.dw @ngpProjectileUpgrades2
	.dw @ngpProjectileUpgrades3

@ngpProjectileUpgrades1:
	m_ngp_upgrade_d_s_term		08 SPEED_200

@ngpProjectileUpgrades2:
	m_ngp_upgrade_p_d_s_term	PALETTE_RED_INV  12 SPEED_300

@ngpProjectileUpgrades3:
	m_ngp_upgrade_p_d_s_term	PALETTE_RED      24 SPEED_400
.endif

@table_5737:
	.db $00 $00 $01 $02
	.db $02 $02 $03 $04
	.db $04 $04 $05 $06
	.db $06 $06 $07 $00

@state1:
	call partCommon_decCounter1IfNonzero
	jr nz,func_5758
	ld l,e
	inc (hl)

@state2:
	call func_5758
	call partCommon_checkTileCollisionOrOutOfBounds
	jp c,partDelete
	ret

func_5758:
.ifdef ENABLE_EVIL_BULLSHIT_BEAMOS
	call objectGetAngleTowardLink
	call objectNudgeAngleTowards

	ld e,Part.angle
	ld a,(de)
	ld c,a
	ld e,Part.var2f
	ld a,(de)
	ld b,a
	ld a,$04
	call objectSetComponentSpeedByScaledVelocity
	ld e,Part.angle
	ld a,(de)
	and $0f
	ld hl,partCode29@table_5737
	rst_addAToHl
	ld a,(hl)
	call partSetAnimation
.endif
	call objectApplyComponentSpeed
	ld e,Part.subid
	ld a,(de)
	ld b,a
	ld a,(wFrameCounter)
	and b
	jp z,objectSetVisible81
	jp objectSetInvisible
