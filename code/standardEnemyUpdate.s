;
; This function is called for every enemy before calling their regular code.
;
; Knockback and stun counters are updated, and various values are returned in 'c' based on
; the enemy's current status.
;
; The returned value of 'c' from here is moved to 'a' before the enemy-specific code is
; called, so that code can check the return value of this function.
;
; @param[out]	c	"Enemy status" (see constants/common/enemyStates.s).
;			$00 normally
;			$02 if stunned
;			$03 if health is 0
;			$04 if something hit the enemy?
;			$05 if the enemy is experiencing knockback
enemyStandardUpdate:
	ld h,d
	ld l,Enemy.state
	ld a,(hl)
	or a
	jr z,@uninitialized

	ld l,Enemy.var2a
	bit 7,(hl)
	jr nz,@ret04

	ld e,Enemy.knockbackCounter
	ld a,(de)
	and $7f
	jr nz,@knockback

	; Enemy.health
	dec l
	ld a,(hl)
	or a
	jr z,@healthZero

	; Enemy.stunCounter
	inc e
	ld a,(de)
	or a
	jr nz,@stunned

@ret00:
	ld c,$00
	ret

@uninitialized:
.if defined(ROM_COMBO)
	callab gfxLoading.enemyLoadGraphicsAndProperties
.else
	callab dataLoading.enemyLoadGraphicsAndProperties
.endif
	call getRandomNumber_noPreserveVars
	ld e,Enemy.var3d
	ld (de),a
	inc e
	ld a,$01
	ld (de),a
	jr @ret00

@ret04:
	ld c,$04
	ret

@knockback:
	ld l,e
	dec (hl)
	ld c,$05
	ret

@healthZero:
	ld l,Enemy.var3f
	bit 1,(hl)
	jr nz,@ret00
	ld c,$03
	ret

@stunned:
	ld a,(wFrameCounter)
	rrca
	jr nc,++

	; Decrement Enemy.stunCounter
	ld l,e
	dec (hl)

	; With 30 frames before being unstunned, make the enemy shake back and forth
	ld a,(hl)
	cp 30
	jr nc,++
	rrca
	jr nc,++

	ld l,Enemy.xh
	ld a,(hl)
	xor $01
	ld (hl),a
++
	; Have the enemy fall down to the ground and bounce

	ld l,Enemy.state
	ld a,(hl)
.ifdef ENABLE_RING_REDUX
	cp $02
	jr z,@ret02
.endif
	cp $08
	jr c,@reachedGround

	ld l,Enemy.zh
	ld a,(hl)
	dec a
	cp $08
	jr c,@reachedGround

	ld c,$20
	call objectUpdateSpeedZAndBounce
	jr nc,@ret02

	ld h,d

@reachedGround:
	ld l,Enemy.speedZ
	xor a
	ldi (hl),a
	ld (hl),a

@ret02:
	ld c,$02
	ret