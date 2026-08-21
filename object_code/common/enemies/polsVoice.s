; ==================================================================================================
; ENEMY_POLS_VOICE
;
; Variables:
;   var30: gravity
; ==================================================================================================
m_EnemyCode $23
	call ecom_checkHazardsNoAnimationForHoles
	call polsVoice_checkLinkPlayingInstrument
	jr z,@normalStatus
	sub ENEMYSTATUS_NO_HEALTH
	ret c
	jp z,enemyDie

.ifdef ENABLE_NEW_GAME_PLUS
	ld e,Enemy.state
	ld a,(de)
	cp $0c
	jr nc,@normalStatus

	; ENEMYSTATUS_JUST_HIT or ENEMYSTATUS_KNOCKBACK
	push af
	ld e,Enemy.var2a
	ld a,(de)
	and $7f
	cp ITEMCOLLISION_L3_SHIELD
	; L-3/4 shield can block them
	jr nc,+
		ld e,Enemy.state
		ld a,(de)
		cp $09
		jr nz,+
			ld e,Enemy.speedZ+1
			ld a,(de)
			bit 7,a
			jr nz,+
				; hit link(or his shield) while moving
				; downward in a jump, so latch on
				ld e,Enemy.state
				pop af
				ld a,$0c
				ld (de),a
				jr @normalStatus
	+
	pop af
.endif

	dec a
	jp nz,ecom_updateKnockbackAndCheckHazards
	ret

@normalStatus:
	ld e,Enemy.state
	ld a,(de)
	rst_jumpTable
	.dw polsVoice_state_uninitialized
	.dw polsVoice_state_stub
.ifdef ENABLE_RING_REDUX
	.dw ecom_stateHeld
.else
	.dw polsVoice_state_stub
.endif
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw ecom_blownByGaleSeedState
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_state8
	.dw polsVoice_state9
.ifdef ENABLE_NEW_GAME_PLUS
	.dw polsVoice_state_stub
	.dw polsVoice_state_stub
	.dw polsVoice_stateC
	.dw polsVoice_stateD
.endif

polsVoice_state_uninitialized:
	; Note: a is uninitialized; arbitrary speed
	call ecom_setSpeedAndState8

.ifdef ENABLE_NEW_GAME_PLUS
	ld hl,@ngpUpgradeTable
	call tryNgpUpgradeStrongEnemyIgnoreSubids
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,+
		; make these guys able to be hurt by the sword if
		; we're making them immune to music and more durable
		ld a,ENEMYCOLLISION_GHINI
		ld e,Enemy.enemyCollisionMode
		ld (de),a
	+
.endif

	call getRandomNumber_noPreserveVars
	ld e,Enemy.counter1
	and $3f
	inc a
	ld (de),a
	jp polsVoice_setLandedAnimation

.ifdef ENABLE_NEW_GAME_PLUS
@ngpUpgradeTable:
	.dw @ngpEnemyUpgrades1
	.dw @ngpEnemyUpgrades2
	.dw @ngpEnemyUpgrades2

@ngpEnemyUpgrades1:
	m_ngp_upgrade_p_d_h			PALETTE_GOLD     6  5
	m_ngp_upgrade_p_si_d_h_term	PALETTE_BLUE  1  8 10
@ngpEnemyUpgrades2
	m_ngp_upgrade_p_d_h			PALETTE_GOLD     6  5
	m_ngp_upgrade_p_si_d_h		PALETTE_BLUE  1  8 10
	m_ngp_upgrade_p_si_d_h		PALETTE_BLUE  1  8 13
	m_ngp_upgrade_p_si_d_h_term	PALETTE_RED   2 10 15
.endif


polsVoice_state_stub:
	ret


polsVoice_state8:
	call ecom_decCounter1
	ret nz

	ld l,e
	inc (hl) ; [state] = 9

	; Randomly read in 3 speed values: speedZ, gravity (var30), and speed.
	ld bc,$0f1c
	call ecom_randomBitwiseAndBCE
	or b
	ld hl,@jumpSpeeds1
	jr nz,+
	ld hl,@jumpSpeeds2
+
.ifdef ENABLE_NEW_GAME_PLUS
	ld e,Enemy.subid
	ld a,(de)
	add a
	add a
	rst_addAToHl
.endif
	ld e,Enemy.speedZ
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

	; [var30] = gravity
	ld e,Enemy.var30
	ldi a,(hl)
	ld (de),a

	ld e,Enemy.speed
	ld a,(hl)
	ld (de),a
	cp SPEED_80
	jr z,++

	; For high speed jump, target Link directly instead of using a random angle
	call objectGetAngleTowardEnemyTarget
	add $02
	and $1c
	ld c,a
++
	ld e,Enemy.angle
	ld a,c
	ld (de),a
	xor a
	call enemySetAnimation
	jp objectSetVisiblec1


; Word: Initial speedZ
; Byte: gravity
; Byte: speed
@jumpSpeeds1:
	dwbb -$128, $0c, SPEED_80
.ifdef ENABLE_NEW_GAME_PLUS
	dwbb -$1a8, $10, SPEED_a0
	dwbb -$200, $18, SPEED_c0
.endif
@jumpSpeeds2:
	dwbb -$180, $0c, SPEED_c0
.ifdef ENABLE_NEW_GAME_PLUS
	dwbb -$200, $10, SPEED_100
	dwbb -$280, $18, SPEED_140
.endif


.ifdef ENABLE_NEW_GAME_PLUS

hopOff:
	xor a
	ld e,Enemy.counter1
	ld (de),a
	ld e,Enemy.speedZ
	ld (de),a
	inc e
	ld a,$fe
	ld (de),a
	xor a
	call enemySetAnimation
	ld e,Enemy.state
	ld a,$09
	ld (de),a
	ret

; Just latched onto Link
polsVoice_stateC:
	ld h,d
	ld l,e
	inc (hl) ; [state]

	ld l,Enemy.counter2
	ld (hl),180

	; increase draw priority
	call objectSetVisiblec0

; Currently latched onto Link
polsVoice_stateD:
	ld a,(w1Link.yh)
	ld e,Enemy.yh
	ld (de),a
	ld a,(w1Link.xh)
	ld e,Enemy.xh
	ld (de),a
	ld a,(w1Link.zh)
	sub $08
	ld e,Enemy.zh
	ld (de),a

	call ecom_decCounter2
	jr z,hopOff

	; If any button is pressed, counter2 goes down more quickly
	ld a,(wGameKeysJustPressed)
	or a
	jr z,++
		call ecom_decCounter2
		call ecom_decCounter2
		call ecom_decCounter2
	++

	; alternate pose every half second
	bit 4,(hl)
	ld a,$01
	jr z,+
		ld a,(de)
		; lower height to hit link
		add $02
		ld (de),a
		xor a
	+
	call enemySetAnimation

	; Invert movement
	ld a,$02
	ld (wUseSimulatedInput),a
	ret
.endif


polsVoice_state9:
	call ecom_applyVelocityForSideviewEnemyNoHoles
	ld e,Enemy.var30
	ld a,(de)
	ld c,a
	call objectUpdateSpeedZ_paramC
	ret nz

	; Landed
	ld h,d
	ld l,Enemy.state
	dec (hl) ; [state] = 8
	ld l,Enemy.counter1
	ld (hl),$20
.ifdef ENABLE_NEW_GAME_PLUS
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,polsVoice_setLandedAnimation
	srl (hl)
	dec a
	jr z,polsVoice_setLandedAnimation
	srl (hl)
.endif

polsVoice_setLandedAnimation:
	ld a,$01
	call enemySetAnimation
	jp objectSetVisiblec2

;;
; @param	a	Enemy status
; @param[out]	a	Updated enemy status
polsVoice_checkLinkPlayingInstrument:
	ld b,a
	ld a,(wLinkPlayingInstrument)
	or a
	jr z,+
.ifdef ENABLE_NEW_GAME_PLUS
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,++
		call polsVoice_setLandedAnimation
		ld e,Enemy.stunCounter
		ld a,90
		ld (de),a
		jr +
	++
.endif
	ld b,ENEMYSTATUS_NO_HEALTH
+
	ld a,b
	or a
	ret
