; ==================================================================================================
; ENEMY_MANHANDLA
; ==================================================================================================
m_EnemyCode $7d
	jr z,@normalStatus
	sub $03
	ret c
	dec a
	jr z,+
	dec a
	jr z,@normalStatus
	ld e,Enemy.subid
	ld a,(de)
	dec a
	jp z,enemyBoss_dead
	dec a
	call z,ecom_killRelatedObj1
	jp enemyDie_uncounted
+
	call manhandla_handleCollision
@normalStatus:
	call ecom_getSubidAndCpStateTo08
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
+
	dec b
	ld a,b
	rst_jumpTable
	.dw @subid1
	.dw @subid2
	.dw @subid3
	.dw @subid4
	.dw @subid5
	.dw @subid6

@state0:
	ld a,b
	or a
	jr nz,+
	ld a,$7d
	ld b,$85
	call enemyBoss_initializeRoom
	jr @state1
+
	dec a
	ld hl,@table_7828
	rst_addAToHl
	ld e,Enemy.var30
	ld a,(hl)
	ld (de),a
	call enemySetAnimation
	call ecom_setSpeedAndState8
	ld e,Enemy.subid
	ld a,(de)
	cp $03
	jr nc,+
	dec a
	jr z,++
	jp objectSetInvisible
+
	call func_7a14
	ld e,Enemy.var31
	ld a,$03
	ld (de),a
	ld e,Enemy.subid
	ld a,(de)
	sub $04
	cp $02
	jp c,objectSetVisible82
++
	jp objectSetVisible83

@table_7828:
	.db $00 $05 $09
	.db $0d $0b $07

@state1:
	ld b,$06
	call checkBEnemySlotsAvailable
	ret nz
	ld b,ENEMY_MANHANDLA
	call ecom_spawnUncountedEnemyWithSubid01
	ld l,Enemy.enabled
	ld e,l
	ld a,(de)
	ld (hl),a
	call objectCopyPosition
	push hl
	ld c,h
	call ecom_spawnUncountedEnemyWithSubid01
	inc (hl)
	call objectCopyPosition
	call func_7a3d
	ld a,h
	ld hl,$ff8a
	ldi (hl),a
	ld a,$04
-
	ldh (<hFF8F),a
	push hl
	call ecom_spawnUncountedEnemyWithSubid01
	call func_7a1f
	ld a,h
	pop hl
	ldi (hl),a
	ldh a,(<hFF8F)
	dec a
	jr nz,-
	pop hl
	ld bc,$ff8a
	ld l,Enemy.var31
	ld e,$05
-
	ld a,(bc)
	ldi (hl),a
	inc c
	dec e
	jr nz,-
	jp enemyDelete

@stateStub:
	ret

@subid1:
	call manhandla_handleElectricShockInvulnerabilityTimer
	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD
	.dw @@stateE
	
@@state8:
	ld a,(wcc93)
	or a
	ret nz
	ld h,d
	ld l,Enemy.speed
	ld (hl),SPEED_40
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_MANHANDLA_BODY_INVULNERABLE

	ld l,Enemy.var36
	ld (hl),$04	; initialize the number of heads that exist
	inc l
	ld (hl),$58
	inc l
	ld (hl),$78
	inc l
	ld (hl),$ff
	call @@func_78ce
	ld a,$2e
	ld (wActiveMusic),a
	jp playSound
	
@@state9:
	call ecom_decCounter1
	jr nz,@@bounceAndApplySpeed
	ld (hl),$78
	ld l,e
	inc (hl)
	xor a
	call enemySetAnimation
@@bounceAndApplySpeed:
	call ecom_bounceOffWallsAndHoles
	call objectApplySpeed
@@animate:
	jp enemyAnimate
	
@@stateA:
	call ecom_decCounter1
	ret nz
	
@@func_78ce:
	ld l,e
	ld (hl),$09
	call getRandomNumber_noPreserveVars
	and $07
	ld hl,@@table_78f6
	rst_addAToHl
	ld e,Enemy.counter1
	ld a,(hl)
	ld (de),a
	ld bc,$5078
	call objectGetRelativeAngle
	push af
	call getRandomNumber_noPreserveVars
	and $01
	pop af
	jr z,+
	sub $02
	and $1f
+
	ld e,Enemy.angle
	ld (de),a
	jr @@animate

@@table_78f6:
	.db $a0 $b0 $c0 $d0
	.db $d0 $e0 $f0 $00

; this is the state where the body is vulnerable to the boomerang,
; and is moving back to the center before running in a figure-eight
@@stateB:
	call func_7ab4
	jr nc,+
	ld l,e
	inc (hl)
	ld l,Enemy.angle
	ld (hl),$00
	ld l,Enemy.counter1
	ld (hl),$04
	ld l,Enemy.speed
	ld (hl),SPEED_220
	jr @@animate
+
	call objectGetRelativeAngleWithTempVars
	ld e,Enemy.angle
	ld (de),a
	jr @@bounceAndApplySpeed

; this is the state where the body is running in a figure-eight
; and is vulnerable to the boomerang, but not the sword
@@stateC:
	call ecom_decCounter1
	jr nz,@@bounceAndApplySpeed
	ld (hl),$04
	ld l,Enemy.var39
	ld e,Enemy.angle
	ld a,(de)
	add (hl)
	and $1f
	ld (de),a
	or a
	jr nz,@@bounceAndApplySpeed
	ld a,(hl)
	cpl
	inc a
	ld (hl),a
	jr @@bounceAndApplySpeed

; this is the state where the body is standing in one spot and
; is stunned and able to be hit with the boomerang or sword
@@stateD:
	; decrement the stunned counter
	call ecom_decCounter1

	; if still stunned, just animate
	jr nz,@@animateAndUpdateMovingPlatform

	; otherwise reset the counter and decrement the counter
	; for how many times the boomerang has hit the body
	ld (hl),$3c
	ld l,Enemy.var30
	ld a,(hl)
	dec a
	ld (hl),a

	jr nz,+
		; hit count went to zero, so move back
		; to the running-in-figure-eight state
		ld l,Enemy.state
		ld (hl),$0b
	+
	jp enemySetAnimation

; this is the state where the body is split open with the
; core exposed, waiting for a single sword swing to kill it
@@stateE:
	call ecom_decCounter1
	jr nz,+
	inc (hl)
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.collisionType
	ld (hl),$fd
	ld l,Enemy.var30
	dec (hl)
	ld a,(hl)
	call enemySetAnimation
	jp objectSetVisible82
+
	ld a,(hl)
	cp $78
	jr nz,@@animateAndUpdateMovingPlatform
	ld l,Enemy.var30
	inc (hl)
	ld a,(hl)
	jp enemySetAnimation
@@animateAndUpdateMovingPlatform:
	call enemyAnimate
	jp ecom_updateMovingPlatform

; this is the core
@subid2:
	call func_7ad6
	ld e,Enemy.state
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	.dw @@stateA

@@state8:
	ld h,d
	ld l,e
	inc (hl)
	; make the core uncollidable
	ld l,Enemy.collisionType
	res 7,(hl)
	; set the enemy collision mode
	inc l
	ld (hl),ENEMYCOLLISION_MANHANDLA_CORE
	ret

@@state9:
	; check if the body is in its exposed "core vulnerable" state
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0e
	ret nz
	ld h,d
	ld l,Enemy.state
	inc (hl)

	; make the core collidable
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.zh
	ld (hl),$f9
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a
	call objectSetVisible81
	ld a,$05
	jp enemySetAnimation

@@stateA:
	ld a,$04
	call objectGetRelatedObject1Var
	ld a,(hl)
	cp $0d
	jr nz,+
	ld h,d
	ld l,Enemy.state
	dec (hl)
	ld l,Enemy.collisionType
	; make uncollidable
	res 7,(hl)
	jp objectSetInvisible
+
	ld l,Enemy.counter1
	ld a,(hl)
	cp $78
	ret nc
	add $03
	and $0c
	rrca
	rrca
	ld hl,@@table_79d9
	rst_addAToHl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

@@table_79d9:
	.db $00 $02 $00 $fe

@subid3:
@subid4:
@subid5:
@subid6:
	ld a,(de)
	sub $08
	rst_jumpTable
	.dw @@state8
	.dw @@state9
	
@@state8:
	call ecom_decCounter1
	jr nz,@@toFunc7ad6
	call manhandlaHead_prepareToFireProjectile
	jr c,@@toFunc7ad6
--
	call getRandomNumber_noPreserveVars
	and $50
	add $5a
	ld e,Enemy.counter1
	ld (de),a
@@toFunc7ad6:
	jp func_7ad6
	
@@state9:
	call ecom_decCounter1
	jr z,+
	ld a,(hl)
	cp $5a
	jr nz,@@toFunc7ad6
	ld b,PART_GOPONGA_PROJECTILE
	call ecom_spawnProjectile
	jr @@toFunc7ad6
+
	ld l,Enemy.var30
	dec (hl)
	ld a,(hl)
	call enemySetAnimation

func_7a14:
	ld h,d
	ld l,Enemy.state
	ld (hl),$08
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_TWINROVA
	jr --

func_7a1f:
	push bc
	push hl
	ldh a,(<hFF8F)
	ld b,a
	ld a,$07
	sub b
	ld (hl),a
	call func_7af2
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	ld b,a
	inc hl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld c,a
	pop hl
	ld l,e
	ld (hl),c
	ld l,Enemy.yh
	ld (hl),b
	pop bc

func_7a3d:
	ld l,Enemy.relatedObj1
	ld a,$80
	ldi (hl),a
	ld (hl),c
	ret

manhandla_handleCollision:
	ld h,d
	ld l,Enemy.var2a
	ld e,Enemy.subid
	ld a,(de)
	dec a

	; jump if this is the body 
	jr z,manhandla_handleBodyCollision
	dec a
	ret z

	; if this is a head, check if it's dead
	ld l,Enemy.health
	ld a,(hl)
	or a
	ret nz

	; it's dead. decrement the head counter on the body
	ld a,Object.var36
	call objectGetRelatedObject1Var
	dec (hl)

	; if the number of heads is now zero, make the body vulnerable
	jr z,manhandla_enterBodyVulnerablePhase

	; otherwise increase manhandla's speed a bit
	ld l,Enemy.speed
	ld a,(hl)
	add SPEED_80
	ld (hl),a
	ret
	
manhandla_enterBodyVulnerablePhase:
	ld l,Enemy.state
	ld (hl),$0b
	ld l,Enemy.speed
	ld (hl),SPEED_200
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_MANHANDLA_BODY_VULNERABLE
	ret

manhandla_handleBodyCollision:
	ld l,Enemy.var2a
	ld a,(hl)
	cp $80|ITEMCOLLISION_ELECTRIC_SHOCK
	jr nz,+
		; set the shock timer
		ld l,Enemy.var3a
		ld (hl),$3c
	+

	; continually reset manhandla's health to $40
	ld l,Enemy.health
	ld (hl),$40

	; if there are any heads alive, don't run code below that
	; handles making the body vulnerable to the boomerang/sword
	ld l,Enemy.var36
	ld a,(hl)
	or a
	ret nz

	; check that the collision was with the L-2 boomerang
	ld l,Enemy.var2a
	ld a,(hl)
.if defined(ROM_COMBO)
	cp $80|ITEMCOLLISION_L2_BOOMERANG_S
.else
	cp $80|ITEMCOLLISION_L2_BOOMERANG
.endif
	ret nz

	; it was, so increment the counter for how many
	; times it's been hit by the boomerang in a row
	ld l,Enemy.var30
	ld a,(hl)
	inc a
	cp $03
	ld (hl),a

	; 3 consecutive hits will make it vulnerable to the sword
	jr nc,manhandla_enterVulnerableToSwordPhase

	; otherwise put it in a short stunned phase 
	ld l,Enemy.counter1
	ld (hl),$3c
	ld l,Enemy.state
	ld (hl),$0d
	call enemySetAnimation
	jp objectSetVisible81
	
manhandla_enterVulnerableToSwordPhase:
	ld (hl),$03
	ld l,Enemy.state
	ld (hl),$0e
	ld l,Enemy.counter1
	ld (hl),$b4
	ld l,Enemy.collisionType
	ld (hl),$a9
	ld a,$03
	jp enemySetAnimation
	
func_7ab4:
	ld h,d
	ld l,Enemy.var37
	call ecom_readPositionVars
	sub c
	add $04
	cp $09
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $04
	cp $09
	ret

manhandla_handleElectricShockInvulnerabilityTimer:
	ld h,d
	ld l,Enemy.var3a
	ld a,(hl)
	or a
	ret z
	pop bc
	dec (hl)
	ret nz
	ld l,Enemy.collisionType
	; make collidable again
	set 7,(hl)
	ret

func_7ad6:
	ld a,$0b
	call objectGetRelatedObject1Var
	ld b,(hl)
	ld l,Enemy.xh
	ld c,(hl)
	ld l,Enemy.animParameter
	ld e,Enemy.subid
	ld a,(de)
	call func_7af2
	ld e,Enemy.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Enemy.xh
	ld a,(hl)
	add c
	ld (de),a
	ret
	
func_7af2:
	sub $02
	ld e,a
	add a
	add e
	add a
	add (hl)
	ld hl,table_7afe
	rst_addAToHl
	ret

table_7afe:
	.db $0a $00 $0a $00 $0a $00 ; subid2
	.db $f0 $0a $f2 $0a $f1 $0a ; subid3
	.db $00 $0b $02 $0b $01 $0b ; subid4
	.db $00 $f5 $01 $f5 $02 $f5 ; subid5
	.db $f0 $f6 $f1 $f6 $f2 $f6 ; subid6

manhandlaHead_prepareToFireProjectile:
	call objectGetAngleTowardEnemyTarget ; $7b1c
	ld b,a
	ld e,Enemy.subid
	ld a,(de)
	sub $03
	swap a
	rrca
	sub b
	cp $f8
	ret nc
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.enemyCollisionMode
	ld (hl),ENEMYCOLLISION_MANHANDLA_HEAD_VULNERABLE
	ld l,Enemy.counter1
	ld (hl),$78
	ld l,Enemy.var30
	inc (hl)
	ld a,(hl)
	call enemySetAnimation
	scf
	ret
