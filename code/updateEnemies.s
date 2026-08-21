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
	jr z,@label_00_349

	rlca
	jr c,@label_00_348

	dec (hl)
	jr z,@label_00_349

	ld a,(wFrameCounter)
	bit 2,a
	jr nz,@label_00_349

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

@label_00_348:
	inc (hl)
@label_00_349:
	ld l,Enemy.oamFlagsBackup
	ldi a,(hl)
	ld (hl),a
@next:
	inc d
	ld a,d
	cp LAST_ENEMY_INDEX+1
	jr c,--
	ret

getEnemyCodeTable:
.if defined(ROM_COMBO)
	ld hl,enemyCodeTable_seasons
	call wIsSeasons
	ret c
	ld hl,enemyCodeTable_ages
.else
	ld hl,enemyCodeTable
.endif
	ret

;;
; @param	d	Enemy to update
updateEnemy:
	call enemyStandardUpdate

	ld e,Enemy.id
	ld a,(de)

.ifdef ENABLE_RING_REDUX
	call judoMasterComboActive
	jr nz,+
		call isValidTargetForJudo
		call nz,objectAddToGrabbableObjectBuffer
	+

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
	ld a,(de)
	call getEnemyCodeTable

.if defined(ENABLE_NEW_GAME_PLUS) || defined(ROM_COMBO)
	jp updateObjectCaller
.else
	.if defined(ROM_AGES)
		; Calculate bank number in 'b'
		ld b,$0f
		cp $70
		jr nc,+
		dec b
		cp $30
		jr nc,+
		dec b
		cp $08
		jr nc,+
		ld b,$10
		+
	.else ; ROM_SEASONS

		ld b,$0f
		cp $08
		jr c,+
		dec b
		cp $70
		jr nc,+
		dec b
		cp $30
		jr nc,+
		dec b
	.endif
	+

	; hl = enemyCodeTable + a*2
	rst_addDoubleIndex
	rst_derefHl

	ld a,b
	setrombank

	ld a,c
	or a
	jp jpHl
.endif
