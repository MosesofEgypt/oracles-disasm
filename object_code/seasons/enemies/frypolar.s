; ==================================================================================================
; ENEMY_FRYPOLAR
; ==================================================================================================
m_EnemyCode $77
	jr z,@normalStatus
	sub $03
	ret c
.if defined(ENABLE_RING_REDUX)
	; in the redux it's possible to get to frypolar in reverse.
	; we need to unlock the key door to his room on death if so.
	jr nz,+
		push de
		ld a,DIR_LEFT*4
		call setRoomFlagsForUnlockedKeyDoor
		pop de
		jp enemyBoss_dead
	+
.else
	jp z,enemyBoss_dead
.endif
	dec a
	jp nz,ecom_updateKnockbackNoSolidity
	ld e,Enemy.var32
	ld a,(de)
	or a
	jr nz,@normalStatus
	ld e,Enemy.var2a
	ld a,(de)
	cp $80|ITEMCOLLISION_MYSTERY_SEED
	jr z,+
	cp $80|ITEMCOLLISION_EMBER_SEED
	jr nz,@normalStatus
	ld e,Enemy.subid
	ld a,(de)
	or a
	jr z,@normalStatus
	ld a,SND_BOSS_DAMAGE
	call playSound
	ld h,d
	ld l,Enemy.invincibilityCounter
	ld (hl),$3c
	ld l,Enemy.health
.if defined(ENABLE_RING_REDUX)
	ld a,MYSTIC_SEED_RING
	call cpActiveRing
	jr nz,++
		; double damage from seeds
		dec (hl)
		; if we hit zero don't decrement again
		jr z,+++
	++
		dec (hl)
	+++
.else
	dec (hl)
.endif
	jr nz,+
	ld l,Enemy.collisionType
	res 7,(hl)
+
	ld e,Enemy.var32
	ld a,$1e
	ld (de),a
	ld a,SND_MAGIC_POWDER
	call playSound
@normalStatus:
	call func_6257
	call func_6273
	call ecom_getSubidAndCpStateTo08
	cp $0a
	jr nc,+
	rst_jumpTable
	.dw @state0
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @stateStub
	.dw @state8
	.dw @state9
+
	call func_62b1
	ld a,b
	rst_jumpTable
	.dw @subid0
	.dw @subid1

@state0:
	ld bc,$010c
	call enemyBoss_spawnShadow
	ret nz
	call ecom_setSpeedAndState8
	ld l,Enemy.var3f
	set 5,(hl)
	ld b,$00
	ld a,$77
	jp enemyBoss_initializeRoom

@stateStub:
	ret

@state8:
	inc e
	ld a,(de)
	rst_jumpTable
	.dw @@substate0
	.dw @@substate1
	.dw @@substate2
	.dw @@substate3

@@substate0:
	ld a,(wcc93)
	or a
	ret nz
	inc a
	ld (de),a
	ld (wDisabledObjects),a
	ret

@@substate1:
	call ecom_decCounter2
	ret nz
	ld b,$02
	call checkBPartSlotsAvailable
	ret nz
	ld e,Enemy.counter1
	ld a,(de)
	ld hl,@@table_6169
	rst_addDoubleIndex
	ldi a,(hl)
	ld c,(hl)
	ld b,a
	call getFreePartSlot
	ld (hl),PART_3d
	inc l
	ld (hl),$03
	inc l
	inc (hl)
	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c
	call getFreePartSlot
	ld (hl),PART_3e
	ld l,Part.var03
	inc (hl)
	ld l,Part.yh
	ld a,$58
	sub b
	add $58
	ldi (hl),a
	inc l
	ld a,$78
	sub c
	add $78
	ld (hl),a
	ld l,Part.relatedObj1
	ld a,$80
	ldi (hl),a
	ld (hl),d
	ld h,d
	ld l,Enemy.counter2
	ld (hl),$0f
	dec l
	inc (hl)
	ldd a,(hl)
	cp $10
	ret c
	inc (hl)
	ret

@@table_6169:
	.db $20 $78
	.db $28 $50
	.db $3c $30
	.db $58 $20
	.db $70 $34
	.db $7c $58
	.db $80 $78
	.db $70 $a0
	.db $58 $b8
	.db $40 $a0
	.db $38 $78
	.db $40 $60
	.db $58 $48
	.db $64 $5c
	.db $68 $70
	.db $5c $84

@@substate2:
	call ecom_decCounter1
	ret nz
	ldbc INTERAC_PUFF $02
	call objectCreateInteraction
	ret nz
	ld a,h
	ld h,d
	ld l,Enemy.relatedObj2+1
	ldd (hl),a
	ld (hl),Interaction.enabled
	ld l,Enemy.substate
	inc (hl)
	ret

@@substate3:
	ld a,Object.animParameter
	call objectGetRelatedObject2Var
	bit 7,(hl)
	ret z
	ld h,d
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.counter1
	ld (hl),$3c
	ld l,Enemy.yh
	ld (hl),$56
	ld l,Enemy.zh
	ld (hl),-2
	call objectSetVisible83
	xor a
	ld (wDisabledObjects),a
	ld a,MUS_MINIBOSS
	ld (wActiveMusic),a
	jp playSound

@state9:
	call ecom_decCounter1
	jp nz,enemyAnimate
	ld l,e
	inc (hl)
	ret

@subid0:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @@stateA
	.dw @@stateB
	.dw @@stateC
	.dw @@stateD

@@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_220
	ld l,Enemy.var34
	ldh a,(<hEnemyTargetY)
	ldi (hl),a
	ldh a,(<hEnemyTargetX)
	ld (hl),a
	jr @@animate

@@stateB:
	ld a,(wFrameCounter)
	and $0f
	ld a,SND_FRYPOLAR_MOVEMENT
	call z,playSound
	call func_62cc
	call nc,ecom_moveTowardPosition
@@animate:
	jp enemyAnimate

@@stateC:
	call ecom_decCounter1
	jr z,+
	call func_62f3
	jr @@animate
+
	call func_62a8
	call func_6304
	jr @@animate

@@stateD:
	call ecom_decCounter1
	jr nz,@@animate
	ld l,e
	ld (hl),$0a
	jr @@animate

@subid1:
	ld a,(de)
	sub $0a
	rst_jumpTable
	.dw @@stateA
	.dw @subid0@stateB
	.dw @@stateC
	.dw @@stateD

@@stateA:
	ld h,d
	ld l,e
	inc (hl)
	ld l,Enemy.speed
	ld (hl),SPEED_2c0
	jp func_6326
	
@@stateC:
	call ecom_decCounter1
	jr z,+
	call func_62f3
	jr @@animate
+
	call func_62a8
	ld b,PART_3e
	call ecom_spawnProjectile
@@animate:
	jp enemyAnimate
	
@@stateD:
	call ecom_decCounter1
	jr nz,@@animate
	ld l,e
	ld (hl),$0b
	call func_6326
	jr @@animate

func_6257:
	ld e,Enemy.var30
	ld a,(de)
	cp $04
	ret c
	call ecom_decCounter1
	jr z,+
	pop hl
	jp enemyAnimate
+
	ld l,Enemy.var30
	ld (hl),$00
	ld l,Enemy.var32
	ld (hl),$5a
	ld a,SND_MAGIC_POWDER
	jp playSound

func_6273:
	ld h,d
	ld l,Enemy.var32
	ld a,(hl)
	or a
	ret z
	ld e,Enemy.invincibilityCounter
	ld a,(de)
	or a

seasonsFunc_0e_627d:
	jr z,+
	pop bc
	ret
+
	dec (hl)
	jr z,++
	pop bc
	ld a,(hl)
	and $03
	jr nz,+
	ld l,Enemy.oamFlagsBackup
	ld a,(hl)
	and $01
	inc a
	ldi (hl),a
	ld (hl),a
+
	jp enemyAnimate
++
	ld l,Enemy.subid
	ld a,(hl)
	inc a
	and $01
	ld (hl),a
	ld b,a
	ld a,$02
	sub b
	ld l,Enemy.oamFlagsBackup
	ldi (hl),a
	ld (hl),a
	ld l,Enemy.state
	ld (hl),$0a
	ld l,Enemy.collisionType
	set 7,(hl)
	ld l,Enemy.var30
	ld (hl),$00
	ret

func_62b1:
	ld h,d
	ld l,Enemy.var31
	dec (hl)
	ld a,(hl)
	and $0f
	ret nz
	ld a,(hl)
	and $30
	swap a
	ld hl,table_62c8
	rst_addAToHl
	ld a,(hl)
	ld h,d
	ld l,Enemy.zh
	ld (hl),a
	ret

table_62c8:
	.db -1
	.db -2
	.db -3
	.db -2

func_62cc:
	ld h,d
	ld l,Enemy.var34
	call ecom_readPositionVars
	sub c
	add $02
	cp $05
	ret nc
	ldh a,(<hFF8F)
	sub b
	add $02
	cp $05
	ret nc
	ld l,Enemy.state
	inc (hl)
	ld l,Enemy.counter1
	ld (hl),$28
	ret

func_62a8:
	ld (hl),$78
	inc l
	ld (hl),$96
	ld l,e
	inc (hl)
	ld l,Enemy.var30
	inc (hl)
	ret

func_62f3:
	ld a,(hl)
	and $03
	ld hl,table_6300
	rst_addAToHl
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld (de),a
	ret

table_6300:
	.db -1
	.db  1
	.db  1
	.db -1

func_6304:
	call objectGetAngleTowardEnemyTarget
	ld b,a
	call getRandomNumber
	cp $55
	ld a,b
	jr c,func_631a
	sub $02
	and $1f
	call func_631a
	ld a,b
	add $04
func_631a:
	push af
	ld b,PART_3d
	call ecom_spawnProjectile
	pop bc
	ret nz
	ld l,Part.angle
	ld (hl),b
	ret
	
func_6326:
	call getRandomNumber_noPreserveVars
	and $0e
	ld h,d
	ld l,Enemy.var33
	cp (hl)
	jr z,func_6326
	ld (hl),a
	ld hl,table_633e
	rst_addAToHl
	ld e,Enemy.var34
	ldi a,(hl)
	ld (de),a
	inc e
	ld a,(hl)
	ld (de),a
	ret

table_633e:
	.db $20 $78 $40 $38
	.db $78 $58 $58 $78
	.db $78 $98 $40 $b8
	.db $68 $38 $68 $b8
