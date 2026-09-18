;;
specialObjectLoadAnimationFrameToBuffer:
	ld hl,w1Companion.visible
	bit 7,(hl)
	ret z

	ld l,<w1Companion.var32
	ld a,(hl)
	call getSpecialObjectGraphicsFrame
	ret z

	ld a,l
	and $f0
	ld l,a
	ld de,w6SpecialObjectGfxBuffer
	ld a,:w6SpecialObjectGfxBuffer
	ld b,$00
	jp copyGfxDataFromBank