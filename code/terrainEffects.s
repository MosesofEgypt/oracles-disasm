;;
; This function is similar to @drawObject above, except it simply draws raw OAM
; data which isn't associated with a particular object. It has a rather
; specific purpose, hence the hard-coded bank number.
; @param hl Address of oam data
; @param hFF8C Y-position to draw at
; @param hFF8D X-position to draw at
func_0eda:
.if defined(ROM_COMBO)
	ldh a,(<hFF8E)
	ld l,a
	ldh a,(<hFF8F)
	ld h,a
func_0eda_fromWithinBank:
.else
	ld a,:terrainEffects.shadowAnimation
	setrombank
.endif

	; Get the end of used OAM, get how many sprites are to be drawn, check
	; if there's enough space
	ldh a,(<hOamTail)
	ld e,a
	ldi a,(hl)
	ld c,a
	add a
	add a
	add e
	cp <wOamEnd+1
	jr nc,@end
	ld d,>wOam

@nextSprite:
	; Y-position
	ldh a,(<hFF8C)
	add (hl)
	ld (de),a
	inc hl
	inc e

	; X-position
	ldh a,(<hFF8D)
	add (hl)
	ld (de),a
	inc hl
	inc e

	; Tile index
	ldi a,(hl)
	ld (de),a
	inc e

	; Flags
	ldi a,(hl)
	ld (de),a
	inc e

	dec c
	jr nz,@nextSprite

	ld a,e
	ldh (<hOamTail),a
@end:
	ret

;;
; Draw an object's shadow, or grass / puddle animation as necessary.
; @param	b	Value of hCameraY?
; @param	e	Object's Z position
; @param	hl	Pointer to object
; @param	[hFF8C]	Y-position
; @param	[hFF8D]	X-position
.if defined(ROM_COMBO)
drawObjectTerrainEffects:
	ldh a,(<hFF8E)
	ld l,a
	ldh a,(<hFF8F)
	ld h,a
	ld e,c
.else
_drawObjectTerrainEffects:
.endif
	ld a,(wTilesetFlags)
	and TILESETFLAG_SIDESCROLL
	ret nz

	ld a,b
	cp $97
	ret nc

	bit 7,e
	jr z,@onGround

@inAir:
	; Return every other frame (creates flickering effect)
	ld a,(wFrameCounter)
	xor h
	rrca
	ret nc

	; Add an entry to wTerrainEffectsBuffer to queue a shadow for drawing
	push hl
	ldh a,(<hTerrainEffectsBufferUsedSize)
	add <wTerrainEffectsBuffer
	ld l,a
	ld h,>wTerrainEffectsBuffer
	ldh a,(<hFF8C)
	ldi (hl),a
	ldh a,(<hFF8D)
	ldi (hl),a
	ld a,<terrainEffects.shadowAnimation
	ldi (hl),a
	ld a,>terrainEffects.shadowAnimation
	ldi (hl),a
	ld a,l
	sub <wTerrainEffectsBuffer
	ldh (<hTerrainEffectsBufferUsedSize),a
	pop hl
	ret

@onGround:
.ifdef ENABLE_TERRAIN_EFFECT_OPTIMIZATIONS
	ld a,(wOptimizationFlags)
	bit 2,a
	call z,calculateRoomHasTerrainEffectTiles
	bit 3,a
	ret z
.endif

	ld a,(wScrollMode)
	cp $08
	ret z
	push hl
	; get the object's current tile position in short yx format
	ld a,l
	and $c0
	add Object.yh
	ld l,a
	ldi a,(hl)
	ld b,a
	; round y-position up and use upper nibble(tile index)
	add $05
	and $f0
	ld c,a
	inc l
	ld l,(hl) ; get Object.xh upper nibble
	ld a,l
	xor b
	ld h,a
	ld a,l
	and $f0
	swap a
	or c
	ld c,a
	ld b,>wRoomLayout
	; determine what tile the object is on
	ld a,(bc)

.if defined(ROM_SEASONS) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	call wIsSeasons
	jr nc,+
.endif
	; CROSSITEMS: Cane of Somaria uses tile index $f9 indoors. It behaves like a grass tile, but
	; it's never used indoors, so disable the grass animation on that tile.
	; (Even though the somaria block is solid, the grass animation can be seen when item drops
	; land on top of it, so this disables that.)
	cp $f9
	jr nz,++
	ld b,a
	ld a,(wActiveGroup)
	or a
	ld a,b
	jr z,++
	jr @end
.endif

.if defined(ROM_COMBO)
	+
	; ages
	cp TILEINDEX_GRASS
	jr z,@walkingInGrass
	cp TILEINDEX_PUDDLE_AGES
	jr nz,@end
	jr @walkingInPuddle
	++

	; Seasons has multiple grass and shallow water tiles, so this checks ranges
	; instead of exact values
	cp TILEINDEX_GRASS
	jr c,@end
	cp TILEINDEX_WATER_SEASONS
	jr nc,@end
	cp TILEINDEX_PUDDLE_SEASONS
	jr c,@walkingInGrass

.elif defined(ROM_AGES)
	cp TILEINDEX_GRASS
	jr z,@walkingInGrass
	cp TILEINDEX_PUDDLE
	jr nz,@end

.elif defined(ROM_SEASONS)
	++
	; Seasons has multiple grass and shallow water tiles, so this checks ranges
	; instead of exact values
	cp TILEINDEX_GRASS
	jr c,@end
	cp TILEINDEX_WATER
	jr nc,@end
	cp TILEINDEX_PUDDLE
	jr c,@walkingInGrass
.endif

@walkingInPuddle:
	inc e
	ld hl,wPuddleAnimationPointer
	derefHl
	jr @grassOrWater

@walkingInGrass:
	bit 2,h
	ld a,(wGrassAnimationModifier)
	jr z,+
	add $24
+
	ld c,a
	ld b,$00
	ld hl,terrainEffects.greenGrassAnimationFrame0
	add hl,bc

@grassOrWater:
	push de
.if defined(ROM_COMBO)
	call func_0eda_fromWithinBank
.else
	call func_0eda
.endif
	pop de

@end:
	pop hl
	ret

.ifdef ENABLE_TERRAIN_EFFECT_OPTIMIZATIONS
getIsTerrainEffectTile:
	push hl
	ld hl,calculateRoomHasTerrainEffectTiles@terrainEffectTiles
.if defined(ROM_COMBO)
	call wIsSeasons
	jr nc,+
		ld hl,calculateRoomHasTerrainEffectTiles@terrainEffectTiles_seasons
	+
.endif
	ld a,(hl)
	-
		cp b
		jr nz,++
			; found a match
			or $01
			jr +
		++

		ldi a,(hl)
		or a
		jr nz,-
	+
	pop hl
	ret

calculateRoomHasTerrainEffectTiles:
	push de
	push hl
	push bc
	ld hl,@terrainEffectTiles
.if defined(ROM_COMBO)
	call wIsSeasons
	jr nc,+
		ld hl,@terrainEffectTiles_seasons
	+
.endif
	-
		ld bc,wRoomLayout
		--
			ld a,(bc)
			cp (hl)
			jr nz,++
				; found a match
				or a
				jr +
			++
			inc bc
			ld a,c
			cp <wRoomLayout+$b0
			jr c,--

		ldi a,(hl)
		or a
		jr nz,-
	+

	ld a,(wOptimizationFlags)
	set 2,a
	res 3,a
	jr z,+
		set 3,a
	+
	ld (wOptimizationFlags),a
	pop bc
	pop hl
	pop de
	ret

@terrainEffectTiles:
.if defined(ROM_COMBO)
	.db TILEINDEX_GRASS
	.db TILEINDEX_PUDDLE_AGES
	.db $00

@terrainEffectTiles_seasons:
	.db TILEINDEX_GRASS
	.db TILEINDEX_GRASS+1
	.db TILEINDEX_PUDDLE_SEASONS
	.db TILEINDEX_PUDDLE_SEASONS+1
	.db TILEINDEX_PUDDLE_SEASONS+2
	.db $00

.elif defined(ROM_SEASONS)
	.db TILEINDEX_GRASS
	.db TILEINDEX_PUDDLE
	.db $00
.else
	; For seasons, $f8-$f9 count as grass, $fa-$fc count as puddles
	.db TILEINDEX_GRASS
	.db TILEINDEX_GRASS+1
	.db TILEINDEX_PUDDLE
	.db TILEINDEX_PUDDLE+1
	.db TILEINDEX_PUDDLE+2
	.db $00
.endif
.endif