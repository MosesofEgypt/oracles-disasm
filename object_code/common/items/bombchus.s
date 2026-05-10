.ifdef ENABLE_RING_REDUX
;;
; ITEM_AZUCHU
itemCode10:
	; if link is disabled, don't process anything
	ld a,(wDisabledObjects)
	bit 0,a
	ret nz

	call itemCode0d@itemCode0d_noExplosion

	ld e,Item.substate
	ld a,(de)
	rst_jumpTable
	.dw @azuchuState0	; init
	.dw @azuchuState1	; follow link
	.dw @azuchuState2	; follow enemy

@azuchuState0	; init
	ld h,d
	ld l,Item.substate
	inc (hl)
	call @targetLink
	; make a poof effect for spawning azuchu
	ldbc INTERAC_PUFF,$80 ; don't make poof sound
	jp objectCreateInteraction

@azuchuState1	; follow link
	ld h,d
	ld l,Item.state
	ld a,(hl)
	or a
	ret z ; return if still in init phase

	call @isTopdown
	jr z,+
		; sidescroll
		add $01
	+

	; check if in the "target found" state
	cp $03
	jr c,+
		; target found
		ld l,Item.substate
		inc (hl)

		call @resetFocusTimer
		ret
	+

	call @updateFocus
	call @targetLink

	; still searching, so just happily hop around link
	ld a,(wFrameCounter)
	and $07
	jr nz,++
		call @isTopdown
		jr nz,+
			call bombchuUpdateAngle_topDown
			jr ++
		+
		; can't get this to work yet. azuchu just goes all over the place
		;call bombchuUpdateAngle_sidescrolling
	++
	; apply speed every frame to keep up with link
	call objectApplySpeed
	jr @hop

@azuchuState2	; follow enemy
	ld h,d
	; ensure azuchu is collidable
	ld l,Item.collisionType
	set 7,(hl)
	inc l
	inc l

	; set collision radius
	ld a,$06
	ldi (hl),a
	ld (hl),a

	; check if target is invalid
	xor a
	call objectGetRelatedObject2Var
	xor a
	or (hl)
	jr z,+
	; make sure the pointer is valid
	ld a,h
	or a
	jr z,+
		; target is valid. happily hop away
		call @updateFocus
		jr @hop
	+

	; target lost. move back to previous substate
	ld h,d
	ld l,Item.substate
	dec (hl)

	call @forceResetFocus 
	jr @targetLink

@resetFocusTimer
	; use counter2 as a timer to ensure azuchu 
	; doesn't stay focused on one target too long
	ld h,d
	ld l,Item.counter2
	ld (hl),$80 ; roughly 4 seconds
	ret

@updateFocus
	; if the counter hits 0, lose the target and try finding another
	ld h,d
	ld l,Item.counter2
	dec (hl)
	ret nz

@forceResetFocus
	call @isTopdown
	jr z,@tdResetFocus

@ssResetFocus
	; reset being on a ceiling
	xor a
	ld l,Item.var34
	ld (hl),a

	; reset angle and direction to upright
	ld l,Item.angle
	set 4,(hl)
	call bombchuSetAnimationFromAngle

@tdResetFocus
	ld h,d
	; disable collision
	ld l,Item.collisionType
	res 7,(hl)
	inc l
	inc l

	; set collision radius
	ld a,$18
	ldi (hl),a
	ld (hl),a

	; revert to slow speed
	ld a,SPEED_80
	.ifdef ROM_AGES
		; slower movement while deep underwater
		call isDeepUnderwater
		jr nz,+
			ld a,SPEED_40
		+
	.endif

	ld l,Item.speed
	ldi (hl),a
	ld  (hl),a

	; move back to searching for target
	ld l,Item.state
	ld (hl),$01

	; remove target
	xor a
	ld l,Item.relatedObj2
	ldi (hl),a
	ld  (hl),a
	xor a	; set z flag
	ret

@targetLink
	; change target to link
	ld l,Item.relatedObj2
	ld (hl),<w1Link
	inc hl
	ld (hl),>w1Link
	ret

@isTopdown
	push bc
	push af
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	pop bc
	ld a,b
	pop bc
	ret

@hop
	; jump every few frames if on ground
	ld a,(wFrameCounter)
	and $1f
	ret nz

	call @isTopdown
	jr z,@tdHop

@ssHop
	; sidescroll needs different check for being on ground
	ld h,d

	; check that we're not on a ceiling
	ld l,Item.var34
	ld a,(hl)
	or a
	ret nz

	; check if the y-position is the same as last frame.
	ld l,Item.yh
	ld a,(hl)

	; if the y values match, then we're on the ground and can hop
	; we store the previous frame's yH in var03 in side-scroll
	ld l,Item.var03
	cp (hl)
	ld (hl),a
	ret nz

	; unset bit indicating we're on a wall
	ld l,Item.var32
	res 0,(hl)

	; reset angle and direction to upright
	ld l,Item.angle
	set 3,(hl)
	call bombchuSetAnimationFromAngle

	; jump higher in sidescroll areas
	ld l,Item.speedZ+1
	ld (hl),$fe
	dec l
	ld (hl),$00
	ret

@tdHop
	ld h,d
	ld l,Item.zh
	bit 7,(hl)
	ret nz

	ld l,Item.speedZ+1
	ld (hl),$fe
	dec l
	ld (hl),$80
	ret

.endif

;;
; ITEM_BOMBCHUS
itemCode0d:
	call bombchuCountdownToExplosion

	; If state is $ff, it's exploding
	ld e,Item.state
	ld a,(de)
	cp $ff
	jp nc,itemUpdateExplosion
.ifdef ENABLE_RING_REDUX
@itemCode0d_noExplosion
.endif

	call objectCheckWithinRoomBoundary
	jp nc,itemDelete

	call objectSetPriorityRelativeToLink_withTerrainEffects

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr nz,@sidescroll

	; This call will return if the bombchu falls into a hole/water/lava.
	ld c,$20
	call itemUpdateSpeedZAndCheckHazards

	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @tdState0
	.dw @tdState1
	.dw @tdState2
	.dw @tdState3
	.dw @tdState4

@sidescroll:
	ld e,Item.var32
	ld a,(de)
	or a
	jr nz,+

	ld c,$18
	call itemUpdateThrowingVerticallyAndCheckHazards
	jp c,itemDelete
+
	ld e,Item.state
	ld a,(de)
	rst_jumpTable

	.dw @ssState0
	.dw @ssState1
	.dw @ssState2
	.dw @ssState3


@tdState0:
	call itemLoadAttributesAndGraphics
.ifdef ENABLE_RING_REDUX
	call isAzuchu
	call nz,decNumBombchus
.else
	call decNumBombchus
.endif

	ld h,d
	ld l,Item.state
	inc (hl)

	; var30 used to cycle through possible targets
	ld l,Item.var30
	ld (hl),FIRST_ENEMY_INDEX

	ld l,Item.speedTmp
	ld (hl),SPEED_80

	.ifdef ROM_AGES
	.ifdef ENABLE_RING_REDUX
		; slower movement while deep underwater
		call isDeepUnderwater
		jr nz,+
			ld (hl),SPEED_40
		+
	.endif
	.endif

	ld l,Item.counter1
	ld (hl),$10

	; Explosion countdown
	inc l
	ld (hl),$b4

	; Collision radius is used as vision radius before a target is found
	ld l,Item.collisionRadiusY
	ld a,$18
	ldi (hl),a
	ld (hl),a

	; Default "direction to turn" on encountering a hole
	ld l,Item.var31
	ld (hl),$08

	; Initialize angle based on link's facing direction
	ld l,Item.angle
	ld a,(w1Link.direction)
	swap a
	rrca
	ld (hl),a
	ld l,Item.direction
	ld (hl),$ff

	call bombchuSetAnimationFromAngle
.ifdef ENABLE_RING_REDUX
	call isAzuchu
	ret z
.endif
	jp bombchuSetPositionInFrontOfLink


; State 1: waiting to reach the ground (if dropped from midair)
@tdState1:
	ld h,d
	ld l,Item.zh
	bit 7,(hl)
	jr nz,++

	; Increment state if on the ground
	ld l,e
	inc (hl)

; State 2: searching for target
@tdState2:
	call bombchuCheckForEnemyTarget
	ret z
++
	call bombchuUpdateSpeed
	call itemUpdateConveyorBelt

@animate:
	jp itemAnimate


; State 3: target found
@tdState3:
	ld h,d
	ld l,Item.counter1
	dec (hl)
	jp nz,itemUpdateConveyorBelt

	; Set counter
	ld (hl),$0a

	; Increment state
	ld l,e
	inc (hl)


; State 4: Dashing toward target
@tdState4:
	call bombchuCheckCollidedWithTarget
.ifdef ENABLE_RING_REDUX
	jr nc,+
		call isAzuchu
		jp nz,bombchuClearCounter2AndInitializeExplosion
	+
.else
	jp c,bombchuClearCounter2AndInitializeExplosion
.endif

	call bombchuUpdateVelocity
	call itemUpdateConveyorBelt
	jr @animate


; Sidescrolling states

@ssState0:
	; Do the same initialization as top-down areas
	call @tdState0

	; Force the bombchu to face left or right
	ld e,Item.angle
	ld a,(de)
	bit 3,a
	ret nz

	add $08
	ld (de),a
	jp bombchuSetAnimationFromAngle

; State 1: searching for target
@ssState1:
	ld e,Item.speed
	ld a,SPEED_80
	ld (de),a
	call bombchuCheckForEnemyTarget
	ret z

	; Target not found yet

	call bombchuCheckWallsAndApplySpeed

@ssAnimate:
	jp itemAnimate


; State 2: Target found, wait for a few frames
@ssState2:
	call itemDecCounter1
	ret nz

	ld (hl),$0a

	; Increment state
	ld l,e
	inc (hl)

; State 3: Chase after target
@ssState3:
call bombchuCheckCollidedWithTarget
.ifdef ENABLE_RING_REDUX
	jr nc,+
		call isAzuchu
		jp nz,bombchuClearCounter2AndInitializeExplosion
	+
.else
	jp c,bombchuClearCounter2AndInitializeExplosion
.endif
	call bombchuUpdateVelocityAndClimbing_sidescroll
	jr @ssAnimate


;;
; Updates bombchu's position & speed every frame, and the angle every 8 frames.
;
bombchuUpdateVelocity:
	ld a,(wFrameCounter)
	and $07
	call z,bombchuUpdateAngle_topDown

;;
bombchuUpdateSpeed:
	call @updateSpeed

	; Note: this will actually update the Z position for a second time in the frame?
	; (due to earlier call to itemUpdateSpeedZAndCheckHazards)
	ld c,$18
	call objectUpdateSpeedZ_paramC

	jp objectApplySpeed


; Update the speed based on what kind of tile it's on
@updateSpeed:
	ld e,Item.angle
	call bombchuGetTileCollisions

	cp SPECIALCOLLISION_HOLE
	jr z,@impassableTile

	cp SPECIALCOLLISION_15
	jr z,@impassableTile

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a
	jr z,@impassableTile

	; Set the bombchu's speed (halve it if it's on a solid tile)
	dec a
	ld e,Item.speedTmp
	ld a,(de)
	jr z,+

	ld e,a
	ld hl,bounceSpeedReductionMapping
	call lookupKey
+
	; If new speed < old speed, trigger a jump. (Happens when a bombchu starts
	; climbing a wall)
	ld h,d
	ld l,Item.speed
	cp (hl)
	ld (hl),a
	ret nc

	ld l,Item.speedZ
	ld a,$80
	ldi (hl),a
	ld (hl),$ff
	ret

; Bombchus can pass most tiles, even walls, but not holes (perhaps a few other things).
@impassableTile:
	; Item.var31 holds the direction the bombchu should turn to continue moving closer
	; to the target.
	ld h,d
	ld l,Item.var31
	ld a,(hl)
	ld l,Item.angle
	add (hl)
	and $18
	ld (hl),a
	jp bombchuSetAnimationFromAngle

;;
; Get tile collisions at the front end of the bombchu.
;
; @param	e	Angle address (object variable)
; @param[out]	a	Collision value
; @param[out]	hl	Address of collision data
; @param[out]	zflag	Set if there is no collision.
bombchuGetTileCollisions:
	ld h,d
	ld l,Item.yh
	ld b,(hl)
	ld l,Item.xh
	ld c,(hl)

	ld a,(de)
	rrca
	rrca
	ld hl,@offsets
	rst_addAToHl
	ldi a,(hl)
	add b
	ld b,a
	ld a,(hl)
	add c
	ld c,a
	jp getTileCollisionsAtPosition

@offsets:
	.db $fc $00 ; DIR_UP
	.db $02 $03 ; DIR_RIGHT
	.db $06 $00 ; DIR_DOWN
	.db $02 $fc ; DIR_LEFT

;;
bombchuUpdateVelocityAndClimbing_sidescroll:
	ld a,(wFrameCounter)
	and $07
	call z,bombchuUpdateAngle_sidescrolling

;;
; In sidescrolling areas, this updates the bombchu's "climbing wall" state.
;
bombchuCheckWallsAndApplySpeed:
	call @updateWallClimbing
	jp objectApplySpeed

;;
@updateWallClimbing:
	ld e,Item.var32
	ld a,(de)
	or a
	jr nz,@climbingWall

	; Return if it hasn't collided with a wall
	ld e,Item.angle
	call bombchuGetTileCollisions
	ret z

	; Check for SPECIALCOLLISION_SCREEN_BOUNDARY
	inc a
	jr nz,+

	; Reverse direction if it runs into such a tile
	ld e,Item.angle
	ld a,(de)
	xor $10
	ld (de),a
	jp bombchuSetAnimationFromAngle
+
	; Tell it to start climbing the wall
	ld h,d
	ld l,Item.angle
	ld a,(hl)
	ld (hl),$00
	ld l,Item.var33
	ld (hl),a
	ld l,Item.var32
	ld (hl),$01
	jp bombchuSetAnimationFromAngle

@climbingWall:
	; Check if the bombchu is still touching the wall it's supposed to be climbing
	ld e,Item.var33
	call bombchuGetTileCollisions
	jr nz,@@touchingWall

	; Bombchu is no longer touching the wall it's climbing. It will now "uncling"; the
	; following code figures out which direction to make it face.
	; The direction will be the "former angle" (var33) unless it's on the ceiling, in
	; which case, it will just continue in its current direction.

	ld h,d
	ld l,Item.angle
	ld e,Item.var33
	ld a,(de)
	or a
	jr nz,+

	ld a,(hl)
	ld e,Item.var33
	ld (de),a
+
	; Revert to former angle and uncling
	ld a,(de)
	ld (hl),a
	ld l,Item.var32
	xor a
	ldi (hl),a
	inc l
	ld (hl),a

	; Clear vertical speed
	ld l,Item.speedZ
	ldi (hl),a
	ldi (hl),a

	ld l,Item.direction
	ld (hl),$ff
	jp bombchuSetAnimationFromAngle

@@touchingWall:
	; Check if it hits a wall
	ld e,Item.angle
	call bombchuGetTileCollisions
	ret z

	; If so, try to cling to it
	ld h,d
	ld l,Item.angle
	ld b,(hl)
	ld e,Item.var33
	ld a,(de)
	xor $10
	ld (hl),a

	; If both the new and old angles are horizontal, stop clinging to the wall?
	bit 3,a
	jr z,+
	bit 3,b
	jr z,+

	ld l,Item.var32
	ld (hl),$00
+
	; Set var33
	ld a,b
	ld (de),a

	; If a==0 (old angle was "up"), the bombchu will cling to the ceiling (var34 will
	; be nonzero).
	or a
	ld l,Item.var34
	ld (hl),$00
	jr nz,bombchuSetAnimationFromAngle
	inc (hl)
	jr bombchuSetAnimationFromAngle

;;
; Sets the bombchu's angle relative to its target.
;
bombchuUpdateAngle_topDown:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
.ifdef ENABLE_RING_REDUX
	inc l
	inc l
.else
	ld l,Enemy.xh
.endif
	ld c,(hl)
	call objectGetRelativeAngle

	; Turn the angle into a cardinal direction, set that to the bombchu's angle
	ld b,a
	add $04
	and $18
	ld e,Item.angle
	ld (de),a

	; Write $08 or $f8 to Item.var31, depending on which "side" the bombchu will need
	; to turn towards later?
	sub b
	and $1f
	cp $10
	ld a,$08
	jr nc,+
	ld a,$f8
+
	ld e,Item.var31
	ld (de),a

;;
; If [Item.angle] != [Item.direction], this updates the item's animation. The animation
; index is 0-3 depending on the item's angle (or sometimes it's 4-5 if var34 is set).
;
; Note: this sets the direction to equal the angle value, which is non-standard (usually
; the direction is a value from 0-3, not from $00-$1f).
;
; Also, this assumes that the item's angle is a cardinal direction?
;
bombchuSetAnimationFromAngle:
	ld h,d
	ld l,Item.direction
	ld e,Item.angle
	ld a,(de)
	cp (hl)
	ret z

	; Update Item.direction
	ld (hl),a

	; Convert angle to a value from 0-3. (Assumes that the angle is a cardinal
	; direction?)
	swap a
	rlca

	ld l,Item.var34
	bit 0,(hl)
	jr z,+
	dec a
	ld a,$04
	jr z,+
	inc a
+
	jp itemSetAnimation

;;
; Sets up a bombchu's angle toward its target such that it will only move along its
; current axis; so if it's moving along the X axis, it will chase on the X axis, and
; vice-versa.
;
bombchuUpdateAngle_sidescrolling:
	ld a,Object.yh
	call objectGetRelatedObject2Var
	ld b,(hl)
.ifdef ENABLE_RING_REDUX
	inc l
	inc l
.else
	ld l,Enemy.xh
.endif
	ld c,(hl)
	call objectGetRelativeAngle

	ld b,a
	ld e,Item.angle
	ld a,(de)
	bit 3,a
	ld a,b
	jr nz,@leftOrRight

; Bombchu facing up or down

	sub $08
	and $1f
	cp $10
	ld a,$00
	jr c,@setAngle
	ld a,$10
	jr @setAngle

; Bombchu facing left or right
@leftOrRight:
	cp $10
	ld a,$08
	jr c,@setAngle
	ld a,$18

@setAngle:
	ld e,Item.angle
	ld (de),a
	jr bombchuSetAnimationFromAngle

;;
; Set a bombchu's position to be slightly in front of Link, based on his direction. If it
; would put the item in a wall, it will default to Link's exact position instead.
;
; @param[out]	zflag	Set if the item defaulted to Link's exact position due to a wall
bombchuSetPositionInFrontOfLink:
	ld hl,w1Link.yh
	ld b,(hl)
	ld l,<w1Link.xh
	ld c,(hl)

	ld a,(wActiveGroup)
	cp FIRST_SIDESCROLL_GROUP
	ld l,<w1Link.direction
	ld a,(hl)

	ld hl,@normalOffsets
	jr c,+
	ld hl,@sidescrollOffsets
+
	; Set the item's position to [Link's position] + [Offset from table]
	rst_addDoubleIndex
	ld e,Item.yh
	ldi a,(hl)
	add b
	ld (de),a
	ld e,Item.xh
	ld a,(hl)
	add c
	ld (de),a

	; Check if it's in a wall
	push bc
	call objectGetTileCollisions
	pop bc
	cp $0f
	ret nz

	; If the item would end up on a solid tile, put it directly on Link instead
	; (ignore the offset from the table)
	ld a,c
	ld (de),a
	ld e,Item.yh
	ld a,b
	ld (de),a
	ret

; Offsets relative to Link where items will appear

@normalOffsets:
	.db $f4 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $0c $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT

@sidescrollOffsets:
	.db $00 $00 ; DIR_UP
	.db $02 $0c ; DIR_RIGHT
	.db $00 $00 ; DIR_DOWN
	.db $02 $f4 ; DIR_LEFT


;;
; Bombchus call this every frame.
;
bombchuCountdownToExplosion:
	call itemDecCounter2
	ret nz

;;
bombchuClearCounter2AndInitializeExplosion:
	ld e,Item.counter2
	xor a
	ld (de),a
	jp itemInitializeBombExplosion

;;
; @param[out]	cflag	Set on collision or if the enemy has died
bombchuCheckCollidedWithTarget:
	ld a,Object.health
	call objectGetRelatedObject2Var
	ld a,(hl)
	or a
	scf
	ret z
	jp checkObjectsCollided

;;
; Each time this is called, it checks one enemy and sets it as the target if it meets all
; the conditions (close enough, valid target, etc).
;
; Each time it loops through all enemies, the bombchu's vision radius increases.
;
; @param[out]	zflag	Set if a valid target is found
bombchuCheckForEnemyTarget:
	; Check if the target enemy is enabled
	ld e,Item.var30
	ld a,(de)
	ld h,a
.ifdef ENABLE_RING_REDUX
	call isAzuchu
	jr nz,+
		; Check it's visible
		ld l,Part.visible
		bit 7,(hl)
		jr z,+
			; check parts next to see if there's an item to grab
			ld l,Part.enabled
			ldi a,(hl)
			or a
			jr z,+
				; check it's an item drop
				ld a,(hl)
				cp PART_ITEM_DROP
				jr z,@foundTarget

				; check it's an item drop from maple
				cp PART_ITEM_FROM_MAPLE
				jr z,@foundTarget

				; check it's an item drop from maple
				cp PART_ITEM_FROM_MAPLE_2
				jr z,@foundTarget
	+
.endif
	ld l,Enemy.enabled
	ld a,(hl)
	or a
	jr z,@nextTarget

	; Check it's visible
	ld l,Enemy.visible
	bit 7,(hl)
	jr z,@nextTarget

	; Check it's a valid target (see data/bombchuTargets.s)
	ld l,Enemy.id
	ld a,(hl)
	push hl
	ld hl,bombchuTargets
	call checkFlag
	pop hl
	jr z,@nextTarget

	; Check if it's within the bombchu's "collision radius" (actually used as vision
	; radius)
	call checkObjectsCollided
	jr nc,@nextTarget

	; Valid target established; set relatedObj2 to the target
.ifdef ENABLE_RING_REDUX
@foundTarget
	ld a,h
	ld h,d
	push bc
	ld b,l
	ld l,Item.relatedObj2+1
	ldd (hl),a
	ld a,b
	pop bc
	and $c0
	ld (hl),a
.else
	ld a,h
	ld h,d
	ld l,Item.relatedObj2+1
	ldd (hl),a
	ld (hl),Enemy.enabled
.endif

	; Stop using collision radius as vision radius
	ld l,Item.collisionRadiusY
	ld a,$06
	ldi (hl),a
	ld (hl),a

	; Set counter1, speedTmp
	ld l,Item.counter1
	ld (hl),$0c
	ld l,Item.speedTmp
	ld (hl),SPEED_1c0
	; slower movement while deep underwater
	call isDeepUnderwater
	jr nz,+
		ld (hl),SPEED_100
	+

	; Increment state
	ld l,Item.state
	inc (hl)

	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	jr nz,+

	call bombchuUpdateAngle_topDown
	xor a
	ret
+
	call bombchuUpdateAngle_sidescrolling
	xor a
	ret

@nextTarget:
	; Increment target enemy index by one
	inc h
	ld a,h
	cp LAST_ENEMY_INDEX+1
	jr c,+

	; Looped through all enemies
	call @incVisionRadius
	ld a,FIRST_ENEMY_INDEX
+
	ld e,Item.var30
	ld (de),a
	or d
	ret

@incVisionRadius:
	; Increase collisionRadiusY/X by increments of $10, but keep it below $70. (these
	; act as the bombchu's vision radius)
	ld e,Item.collisionRadiusY
	ld a,(de)
	add $10
	cp $60
	jr c,+
	ld a,$18
+
	ld (de),a
	inc e
	ld (de),a
	ret

.include {"{GAME_DATA_DIR}/bombchuTargets.s"}

.ifdef ENABLE_RING_REDUX
isAzuchu:
	push de
	push af
	ld e,Item.id
	ld a,(de)
	cp $10
	pop de
	ld a,d
	pop de
	ret
.endif