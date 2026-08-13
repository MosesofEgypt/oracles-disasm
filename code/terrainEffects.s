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
	rst_setrombank
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
	ld a,(wScrollMode)
	cp $08
	ret z
	push hl
	ld a,l
	and $c0
	add $0b
	ld l,a
	ldi a,(hl)
	ld b,a
	add $05
	and $f0
	ld c,a
	inc l
	ld l,(hl)
	ld a,l
	xor b
	ld h,a
	ld a,l
	and $f0
	swap a
	or c
	ld c,a
	ld b,>wRoomLayout
	ld a,(bc)

.if defined(ROM_SEASONS) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	call hIsSeasons
	jr nc,+
.endif
	; CROSSITEMS: Cane of Somaria uses tile index $f9 indoors. It behaves like a grass tile, but
	; it's never used indoors, so disable the grass animation on that tile.
	; (Even though the somaria block is solid, the grass animation can be seen when item drops
	; land on top of it, so this disables that.)
	cp $f9
	jr nz,+
	ld b,a
	ld a,(wActiveGroup)
	or a
	ld a,b
	jr z,+
	jr @end
+
.endif

.if defined(ROM_AGES) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	call hIsSeasons
	jr c,+
.endif
	cp TILEINDEX_GRASS
	jr z,@walkingInGrass
	cp TILEINDEX_PUDDLE
	jr nz,@end
.if defined(ROM_COMBO)
	jr @walkingInPuddle
	+
.endif
.endif

.if defined(ROM_SEASONS) || defined(ROM_COMBO)
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
	ldi a,(hl)
	ld h,(hl)
	ld l,a
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
