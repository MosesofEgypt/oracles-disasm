; ==================================================================================================
; ENEMY_SEEDS_ON_TREE
;
; Variables:
;   var03: Child "PART_SEED_ON_TREE" objects write here when Link touches them?
; ==================================================================================================
m_EnemyCode $5a
	ld e,Enemy.state
	ld a,(de)
	or a
	jp nz,@state1


; Initialization
@state0:
	ld a,$01
	ld (de),a ; [state]

.ifdef ENABLE_RING_REDUX
	; make tree visible(so azuchu can see it), but have it use
	; a blank tile so it doesn't actually look like anything.
	ld e,Enemy.visible
	ld a,$80
	ld (de),a
	swap a
	ld e,Enemy.oamDataAddress
	ld (de),a
	xor a
	inc e
	ld (de),a
.endif

.if defined(ROM_AGES) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	call wIsSeasons
	jr c,++
.endif
	; Locate tree
	ld a,TILEINDEX_MYSTICAL_TREE_TL
	call findTileInRoom
	jp nz,enemyDelete

	; Move to that position
	ld c,l
	ld h,d
	ld l,Enemy.yh
	call setShortPosition_paramC
	ld bc,$0808
	call objectCopyPositionWithOffset

	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,wSeedTreeRefilledBitset
	call checkFlag
	jp z,enemyDelete

	ld a,(de)
	swap a
	and $0f
	ldh (<hFF8B),a
.if defined(ROM_COMBO)
	jr +
	++
.endif
.endif

.if defined(ROM_SEASONS) || defined(ROM_COMBO)
	ld e,Enemy.subid
	ld a,(de)
	ld b,a
	add a
	add b
	ld hl,@treeDataTable
	rst_addAToHl
	ldi a,(hl)
	ldh (<hFF8B),a
	ldi a,(hl)
	ld b,a
	ld a,(wRoomStateModifier)
	cp b
	jp nz,enemyDelete
	ld a,(hl)
	cpl
	ld e,Enemy.direction
	ld (de),a
	ld a,(wSeedTreeRefilledBitset)
	and (hl)
	jp z,enemyDelete
	+
.endif

	; Spawn the 3 seed objects
	xor a
	call @addSeed
	ld a,$01
	call @addSeed
	ld a,$02
@addSeed:
	ld hl,@positionOffsets
	rst_addDoubleIndex
	ld e,Enemy.yh
	ld a,(de)
	add (hl)
	inc hl
	ld b,a
	ld e,Enemy.xh
	ld a,(de)
	add (hl)
	ld c,a

	call getFreePartSlot
	ld (hl),PART_SEED_ON_TREE
	inc l
	ldh a,(<hFF8B)
	ld (hl),a ; [subid]

	ld l,Part.yh
	ld (hl),b
	ld l,Part.xh
	ld (hl),c

	ld l,Part.relatedObj2
	ld (hl),Enemy.start
	inc l
	ld (hl),d
	ret

@positionOffsets:
	.db $f8 $00
	.db $00 $f8
	.db $00 $08

.if defined(ROM_SEASONS) || defined(ROM_COMBO)

; Data:
; - Seed type
; - Required season to grow
; - Bitmask checked against wSeedTreeRefilledBitset
@treeDataTable:
	.db $00, SEASON_WINTER, $80
	.db $04, SEASON_SUMMER, $40
	.db $01, SEASON_SPRING, $20
	.db $02, SEASON_AUTUMN, $10
	.db $03, SEASON_SUMMER, $08
	.db $03, SEASON_SUMMER, $04
.endif


@state1:
	; Waiting for one of the PART_SEED_ON_TREE objects to write to var03, indicating
	; that they were grabbed
	ld e,Enemy.var03
	ld a,(de)
	or a
	ret z

	; Mark seeds as taken
.if defined(ROM_AGES) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	call wIsSeasons
	jr c,+
.endif
	ld e,Enemy.subid
	ld a,(de)
	and $0f
	ld hl,wSeedTreeRefilledBitset
	call unsetFlag
	jp enemyDelete
	+
.endif

.if defined(ROM_SEASONS) || defined(ROM_COMBO)
	ld e,Enemy.direction
	ld a,(de)
	ld hl,wSeedTreeRefilledBitset
	and (hl)
	ld (hl),a
	jp enemyDelete
.endif
