; Unlike "itemCodeXX", "itemCodeXXPost" functions run after all other objects have updated and
; aren't subject to certain conditions that would otherwise disable updating of items.
;
; This file starts with some helper functions but see below for the "itemCodeXXPost" functions.


;;
; Used for sword, cane of somaria, rod of seasons. Updates animation, deals with
; destroying tiles?
;
updateSwingableItemAnimation:
	ld l,Item.animParameter

	; jump if the object isn't a sword, and thus can't break tiles
	cp ITEM_CANE_OF_SOMARIA
	jr z,@updatePosAndAnim
	cp ITEM_ROD_OF_SEASONS
	jr z,@updatePosAndAnim

	; check if we hit the point in the anim that does the tile break
	bit 6,(hl)
	jr z,@updatePosAndAnim
		res 6,(hl)
		ld a,(hl)
		and $1f
		cp $10
		jr nc,+
			ld a,(w1Link.direction)
			add a
		+
		and $07
		push hl
		call tryBreakTileWithSword_calculateLevel
		pop hl

@updatePosAndAnim:
	; if animParameter is higher than $10, this is a spin attack
	ld c,$10
	ld a,(hl)
	and $1f
	ld l,Item.var2f
	bit 1,(hl)
	jr z,+
		; this is a plunging attack
		and $07
		add $30
		jr ++
	+
	cp c
	jr nc,+
		; this is a regular slash
		++
		srl a
		ld c,a
		ld a,(w1Link.direction)
		add a
		add a
		add c
		ld c,$00
	+
	ld hl,@data
	addAToHl
	ld a,(hl)
	and $f0
	swap a
	add c
	ld e,Item.var30
	ld (de),a

	ld a,(hl)
	and $0f
	jp itemSetAnimation


; For each byte:
;  Bits 4-7: index for swordArcData(multiply by 5 for offset)
;  Bits 0-3: Animation frame index
@data:
	; slashing upward
	.db $02 $41 $80 $c0

	; slashing rightward
.ifdef SWORD_SLASH_FULL_COVERAGE
	.db $14 $53 $92 $d2
.else
	.db $10 $51 $92 $d2
.endif

	; slashing downward
	.db $26 $65 $a4 $e4

	; slashing leftward
	.db $30 $77 $b6 $f6

	; spin attack anim(frame0 points upward)
	.db $00 $11 $22 $33 $44 $55 $66 $77

	; plunging facing upward
	.db $08 $48 $88 $88

	; plunging facing rightward
	.db $19 $59 $99 $99

	; plunging facing downward
	.db $2a $6a $aa $aa

	; plunging facing leftward
	.db $3b $7b $bb $bb

;;
; Analagous to updateSwingableItemAnimation, but specifically for biggoron's sword
;
updateBiggoronSwordAnimation:
	ld b,$00
	ld l,Item.animParameter
	bit 6,(hl)
	jr z,+
	res 6,(hl)
	inc b
+
	ld a,(hl)
	and $0e
	rrca
	ld c,a
	ld a,(w1Link.direction)
	cp $01
	jr nz,+
	ld a,c
	jr ++
+
	inc a
	add a
	sub c
++
	and $07
	bit 0,b
	jr z,++

	push af
	ld c,a
	ld a,BREAKABLETILESOURCE_SWORD_L2
	call tryBreakTileWithSword
	pop af
++
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEM_MAGNET_GLOVES
;
itemCode08Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,w1Link.yh
	call objectTakePosition
	ld a,(wFrameCounter)
	rrca
	rrca
	ld a,(w1Link.direction)
	adc a
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEM_SLINGSHOT
;
itemCode13Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld hl,w1Link.yh
	call objectTakePosition
	ld a,(w1Link.direction)
	ld e,Item.var30
	ld (de),a
	jp itemSetAnimation

;;
; ITEM_FOOLS_ORE
;
itemCode1ePost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	ld l,Item.animParameter
	ld a,(hl)
	and $06
	add a
	ld b,a
	ld a,(w1Link.direction)
	add b
	ld e,Item.var30
	ld (de),a
	ld hl,swordArcData
	jp itemSetPositionInSwordArc

;;
; ITEM_PUNCH
;
itemCode00Post:
itemCode02Post:
	ld a,(w1Link.direction)
	add $18
	ld hl,swordArcData
.ifdef ENABLE_BUGFIXES
	jr itemSetPositionInSwordArc_punch
.else
	jr itemSetPositionInSwordArc
.endif

;;
; ITEM_BIGGORON_SWORD
;
itemCode0cPost:
	call cpRelatedObject1ID
	jp nz,itemDelete

	call updateBiggoronSwordAnimation
	ld e,Item.var30
	ld a,(de)
	ld hl,biggoronSwordArcData
	call itemSetPositionInSwordArc
.ifdef WIDE_INVENTORY_SPRITES
	call itemCode0cPost_loadBiggoronBladeTiles
.endif
	jp itemCalculateSwordDamage

.ifdef WIDE_INVENTORY_SPRITES
itemCode0cPost_reloadBiggoronBladeTiles:
	ld h,d
	ld l,Item.counter2
	ld (hl),$ff

itemCode0cPost_loadBiggoronBladeTiles:
	; we need to repurpose part of the biggoron sword sprite
	; tiles, so instead we dynamically load them when needed
	ld h,d
	ld l,Item.var30
	ld a,(hl)
	rra
	and $01
	add UNCMP_GFXH_BIGGORON_SWORD_VERTICAL

	ld l,Item.counter2
	cp (hl)
	ld (hl),a
	ret z
	push de
	call loadUncompressedGfxHeader
	pop de
	ret
.endif

;;
; ITEM_SWORD
;
itemCode05Post:
	call itemCode04Post

	; for a plunging attack with the harmless collision type
	; we increase the size to cover a large area around link
	; to act as a shockwave for knocking away nearby enemies
	ld a,(w1WeaponItem.state)
	cp $08
	ret nz

	ld a,$18
	ld (w1WeaponItem.collisionRadiusX),a
	ld (w1WeaponItem.collisionRadiusY),a
	ret

;;
; ITEM_CANE_OF_SOMARIA
; ITEM_ROD_OF_SEASONS
;
itemCode04Post:
itemCode07Post:
	call cpRelatedObject1ID
	jp nz,itemDelete

	push hl
	call updateSwingableItemAnimation

	ld e,Item.var30
	ld a,(de)
	pop hl

	ld l,Item.var2f
	bit 1,(hl)
	ld hl,swordArcData
	jr z,+
		ld hl,plungingAttackArcData
	+
	call itemSetPositionInSwordArc

	jp itemCalculateSwordDamage

.ifdef ENABLE_BUGFIXES
; The vanilla game's code tries to increase the punch object's radius
; if wearing EXPERTS_RING, but this code was resetting it each frame.
; This bugfix allows the size increase to persist.
itemSetPositionInSwordArc_punch:
	ld e,a
	add a
	add a
	add e
	addAToHl
	inc hl
	inc hl
	jr itemInitializePositionFromLinkPosition
.endif

;;
; @param	a	Index for table 'hl'
; @param	hl	Usually points to swordArcData
itemSetPositionInSwordArc:
	ld e,a
	add a
	add a
	add e
	addAToHl

;;
; Copy Link's position (accounting for raised floors, with Z position 2 higher than Link)
;
; @param	hl	Pointer to data for collision radii and position offsets
itemInitializeFromLinkPosition:
	ld e,Item.collisionRadiusY
	ldi a,(hl)
	ld (de),a
	inc e
	ldi a,(hl)
	ld (de),a

itemInitializePositionFromLinkPosition:
	; Y
.if defined(ROM_AGES) || defined(ROM_COMBO)
	ld a,(wLinkRaisedFloorOffset)
	ld b,a
	ld a,(w1Link.yh)
	add b
.else
	ld a,(w1Link.yh)
.endif
	add (hl)
	ld e,Item.yh
	ld (de),a

	; X
	inc hl
	ld e,Item.xh
	ld a,(w1Link.xh)
	add (hl)
	ld (de),a

	; Z
	inc hl
	ld a,(w1Link.zh)
	add (hl)
	ld e,Item.zh
	sub $02
	ld (de),a
	ret


; Each row corresponds to part of a sword's arc (Also used by punches.)
; b0/b1:    collisionRadiusY/X
; b2/b3/b4: Y/X/Z offsets relative to Link
swordArcData:
	; slash frame 0
	.db $09 $06 $fe $10 $00 ; right
.ifdef SWORD_SLASH_FULL_COVERAGE
	.db $06 $09 $12 $03 $00 ; down
.else
	.db $06 $09 $f2 $00 $00 ; up
.endif
	.db $09 $06 $00 $f1 $00 ; left
	.db $06 $09 $f2 $00 $00 ; up

	; slash frame 1
	.db $07 $07 $f5 $0d $00 ; up-right
.ifdef SWORD_SLASH_FULL_COVERAGE
	.db $07 $07 $12 $10 $00 ; down-right
.else
	.db $07 $07 $f5 $0d $00 ; up-right
.endif
	.db $07 $07 $11 $f3 $00 ; down-left
	.db $07 $07 $f5 $f3 $00 ; up-left

	; slash frame 2
	.db $09 $06 $ef $fc $00 ; up
	.db $06 $09 $02 $13 $00 ; right
	.db $09 $06 $15 $03 $00 ; down
	.db $06 $09 $02 $ed $00 ; left

	; slash frame 3
	.db $09 $06 $f6 $fc $00 ; up
	.db $04 $09 $02 $0c $00 ; right
	.db $09 $06 $10 $03 $00 ; down
	.db $06 $09 $02 $f4 $00 ; left

	; spin-attack values
	.db $09 $09 $ef $fc $00 ; up
	.db $09 $09 $f2 $10 $00 ; up-right
	.db $09 $09 $02 $13 $00 ; right
	.db $09 $09 $12 $10 $00 ; down-right
	.db $09 $09 $15 $03 $00 ; down
	.db $09 $09 $11 $f3 $00 ; down-left
	.db $09 $09 $02 $ed $00 ; left
	.db $09 $09 $f5 $f3 $00 ; up-left

	; punch values
	.db $05 $05 $f4 $fd $00 ; up
	.db $05 $05 $00 $0c $00 ; right
	.db $05 $05 $0c $03 $00 ; down
	.db $05 $05 $00 $f4 $00 ; left

plungingAttackArcData:
	; plunging attack frame 0
	.db $09 $04 $fc $00 $03 ; up
	.db $09 $04 $00 $07 $03 ; right
	.db $09 $04 $04 $00 $03 ; down
	.db $09 $04 $00 $f9 $03 ; left

	; plunging attack frame 1
	.db $09 $04 $fc $00 $06 ; up
	.db $09 $04 $00 $07 $06 ; right
	.db $09 $04 $04 $00 $06 ; down
	.db $09 $04 $00 $f9 $06 ; left

	; plunging attack frame 2
	.db $09 $04 $fc $00 $09 ; up
	.db $09 $04 $00 $04 $09 ; right
	.db $09 $04 $04 $00 $09 ; down
	.db $09 $04 $00 $fc $09 ; left

biggoronSwordArcData:
	.db $0b $0b $ef $fe $00 ; up
	.db $09 $0c $f2 $10 $00 ; up-right
	.db $0b $0b $02 $13 $00 ; right
	.db $0c $09 $12 $10 $00 ; down-right
	.db $0b $0b $15 $01 $00 ; down
	.db $09 $0c $11 $f3 $00 ; down-left
	.db $0b $0b $02 $ed $00 ; left
	.db $0c $09 $f5 $f3 $00 ; up-left
