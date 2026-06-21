; ==================================================================================================
; ENEMY_BUBBLE
; ==================================================================================================
enemyCode15:
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c

	; Check if collided with Link; disable sword if so.
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_LINK
	jr nz,@normalStatus

.ifdef ENABLE_RING_REDUX
	ld a,RED_HOLY_RING
.else
	ld a,WHISP_RING
.endif
	call cpActiveRing
	jr z,@normalStatus

.ifdef ENABLE_NEW_GAME_PLUS
	call getNewGamePlusCycle
	; add 3 seconds for each newgame cycle
	ld e,a
	ld a,90
	-
		add 45
		dec e
		jr nz,-

	ld l,Enemy.subid
	ld h,d
	bit 0,(hl)
	jr z,+
		ld hl,wRingsDisabledCounter
		ld b,(hl)
		ld (hl),a

		; only show the message if not already disabled
		ld a,b
		or a
		ld bc,TX_51_RINGS_DISABLED
		call z,showText
		jr @normalStatus
	+
		ld (wSwordDisabledCounter),a
.else
	ld a,180
	ld (wSwordDisabledCounter),a
.endif

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw @state_uninitialized
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state_stub
	.dw @state8

@state_uninitialized:
	call getRandomNumber_noPreserveVars
	and $18
	ld e,Enemy.angle
	ld (de),a
	ld a,SPEED_c0
	call ecom_setSpeedAndState8
.ifdef ENABLE_NEW_GAME_PLUS
	ld hl,@ngpUpgradeTable
	xor a	; indicate this is a weak enemy
	call tryNgpUpgradeUncapped
.endif
	jp objectSetVisible82


.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpUpgradeSubtable
	.dw @ngpUpgradeSubtable
	.dw @ngpUpgradeSubtable

@ngpUpgradeSubtable:
	.dw @ngpUpgrades

	@ngpUpgrades:
		m_ngp_upgrade_p_si_s		PALETTE_RED   0 SPEED_c0
		m_ngp_upgrade_p_si_s		PALETTE_GOLD  1 SPEED_c0
		m_ngp_upgrade_p_si_s		PALETTE_RED   0 SPEED_180
		m_ngp_upgrade_p_si_s_term	PALETTE_GOLD  1 SPEED_180
.endif


@state_stub:
	ret


@state8:
	call @checkCenteredOnTile
	call z,@chooseNewDirection
	call ecom_applyVelocityForSideviewEnemyNoHoles
	call z,@chooseNewDirection
	jp enemyAnimate

;;
@chooseNewDirection:
	ldbc $07,$18
	call ecom_randomBitwiseAndBCE
	or b
	ret nz
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	ret

;;
; @param[out]	zflag	z if centered
@checkCenteredOnTile:
	ld h,d
	ld l,Enemy.yh
	ldi a,(hl)
	ld b,a
	inc l
	ld c,(hl)
	or c
	and $07
	ret
