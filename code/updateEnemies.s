.include "code/standardEnemyUpdate.s"

;;
; Update all enemies with 'state' variables equal to 0.
_updateEnemiesIfStateIsZero:
	ld d,FIRST_ENEMY_INDEX
	ld a,d

--
	ldh (<hActiveObject),a
	ld e,Enemy.enabled
	ld a,(de)
	or a
	jr z,@next
		ld h,d
		ld l,Enemy.state
		ldi a,(hl)
		or (hl)
		call z,updateEnemy

		; restore the oam flags each frame
		ld e,Enemy.oamFlagsBackup
		ld a,(de)
		inc e
		ld (de),a
@next:
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,--
	ret

;;
; Update all enemies by calling their enemy-specific code and doing other common enemy
; stuff.
;
updateEnemies:
	ld a,Enemy.start
	ldh (<hActiveObjectType),a

	ld a,(wScrollMode)
	and $0e
	jr nz,_updateEnemiesIfStateIsZero

	ld a,(wTextIsActive)
	or a
	jr nz,_updateEnemiesIfStateIsZero

	ld a,(wDisabledObjects)
	and $84
	jr nz,_updateEnemiesIfStateIsZero

	ld a,(wPaletteThread_mode)
	or a
	jr nz,_updateEnemiesIfStateIsZero

	ld d,FIRST_ENEMY_INDEX
	ld a,d

--
	ldh (<hActiveObject),a

	ld e,Enemy.enabled
	ld a,(de)
	or a
	jr z,@next

	call updateEnemy

	; Reset bit 7 of var2a to indicate that, if any collision has occurred, it's no
	; longer the first frame of the collision.
	ld h,d
	ld l,Enemy.var2a
	res 7,(hl)

	; Increment/decrement invincibilityCounter if applicable, update palette
	inc l
	ld a,(hl) ; a = [enemy.invincibilityCounter]
	or a
	jr z,@restoreOamFlags

	rlca
	jr c,@tickDowninvincibilityWithoutFlash

	dec (hl)
	jr z,@restoreOamFlags

	ld a,(wFrameCounter)
	bit 2,a
	jr nz,@restoreOamFlags

	ld a,(wPaletteMappedObject)
	or a
	jr z,+
		; object might have its palette remapped. check if it matches
		ld l,Enemy.id
		cp (hl)
		jr nz,+
			; object matches. remap palette for flashing
			ld l,Enemy.oamFlags
			set 4,(hl)
			jr @next
	+

	ld b,$05
	ld l,Enemy.oamFlagsBackup
	ldi a,(hl)
	and $07
	cp b
	jr nz,+
		ld b,$02
	+
	ld a,(hl)
	and $f8
	or b
	ld (hl),a
	jr @next

@tickDowninvincibilityWithoutFlash:
	inc (hl)
@restoreOamFlags:
	ld l,Enemy.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
@next:
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,--
	ret

;;
; @param	d	Enemy to update
updateEnemy:
	call enemyStandardUpdate

.ifdef ENABLE_RING_REDUX
	isRingComboActive RING_COMBO_BIT_JUDO_MASTER
	jr z,+
		; NOTE: since we're doing some overriding of the ENEMYSTATUS, we
		;       want to make sure to only do it on enemies we can throw.
		ld e,Enemy.id
		ld a,(de)
		call isValidTargetForJudo
		call nz,objectAddToGrabbableObjectBuffer

		ld a,c
		or a
		jr z,+
			; if enemy is in held state, treat it like it's normal
			ld e,Enemy.state
			ld a,(de)
			cp a,ENEMYSTATE_GRABBED
			jr nz,+
				ld c,ENEMYSTATUS_NORMAL
	+
.endif
	ld e,Enemy.id
	ld a,(de)
.if defined(ROM_COMBO)
	ld hl,enemyCodeTable_seasons
	call wIsSeasons
	jr c,+
		ld hl,enemyCodeTable_ages
	+
.else
	ld hl,enemyCodeTable
.endif

	jp updateObjectCaller


.ifdef ENABLE_RING_REDUX
; @param	a	Enemy id to check
; @param[out]	zflag set if the enemy CANNOT be picked up/thrown
isValidTargetForJudo:
	push hl
	ld hl,@judoTargets
	push bc
	ld (hTempVal2),a
	call checkFlagOptimized
	ld a,(hTempVal2)
	pop bc
	pop hl
	ret

; these are bitmasks for which enemies can be picked up with a ring combo
@judoTargets:
	; 0x00-0x07: OCTOROK, BOOMERANG_MOBLIN, ARROW_MOBLIN
	; 0x08-0x0f:
	; 0x10-0x17: ROPE, GIBDO
	; 0x18-0x1f: BUZZBLOB, SAND_CRAB, SPINY_BEETLE, IRON_MASK, ARMOS, PIRANHA
	; 0x20-0x27: MASKED_MOBLIN, ARROW_DARKNUT, ARROW_SHROUDED_STALFOS, POLS_VOICE, LIKE_LIKE, GOPONGA_FLOWER
	; 0x28-0x2f: WALLMASTER
	; 0x30-0x37: TEKTITE, STALFOS, KEESE, ZOL, FLOORMASTER, BUTTERFLY
	; 0x38-0x3f: FIRE_KEESE, WATER_TEKTITE, PEAHAT, SWORD_MOBLIN
	; 0x40-0x47: WIZZROBE, CROW, GEL
	; 0x48-0x4f: SWORD_DARKNUT, SWORD_SHROUDED_STALFOS, SWORD_MASKED_MOBLIN, BALL_AND_CHAIN_SOLDIER, BLUE_CROW, HARDHAT_BEETLE, ARM_MIMIC
	; 0x50-0x57: BEETLE, FLYING_TILE
	dbrev %00000000 %01101000 ; 0x00-0x0f
	dbrev %10100000 %10111110 ; 0x10-0x1f
	dbrev %11111100 %10000000 ; 0x20-0x2f
	dbrev %11101101 %01100110 ; 0x30-0x3f
	dbrev %11010000 %11111110 ; 0x40-0x4f
	dbrev %01100000 %00000000 ; 0x50-0x5f
.endif