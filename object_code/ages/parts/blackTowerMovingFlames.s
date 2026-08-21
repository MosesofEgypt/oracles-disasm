; ==================================================================================================
; PART_BLACK_TOWER_MOVING_FLAMES
;
; Variables:
;   var30: next yh to move to
;   var31: next xh to move to
; ==================================================================================================
m_PartCode $59
	ld e,$c4
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2
	.dw @state3
	.dw @state4
	.dw @state5

@state0:
	ld h,d
	ld l,e
	inc (hl)
	ld l,$d0
	ld (hl),$14
	ld l,$c2
	ld a,(hl)
	ld hl,@table_7ebd
	rst_addAToHl
	ld e,$c6
	ld a,(hl)
	ld (de),a
	ret

@table_7ebd:
	.db $01 $14 $28 $3c
	
@state1:
	call partCommon_decCounter1IfNonzero
	ret nz
	ld l,e
	inc (hl)
	ld l,$c2
	ld a,(hl)
	xor $03
	ld hl,@table_7ebd
	rst_addAToHl
	ld e,$c6
	ld a,(hl)
	ld (de),a
	ld a,SND_LIGHTTORCH
	call playSound
	jp objectSetVisible83
	
@state2:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	ld (hl),$14
	ld l,e
	inc (hl)
	jr @animate
	
@state3:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	call getMovingFlamesNextTileCoords
	ld h,d
	ld l,$c4
	inc (hl)
	ld a,b
	or a
	jr nz,@animate
	inc (hl)
	ld l,$c6
	ld (hl),$10
	jr @animate
	
@state4:
	ld h,d
	ld l,$f0
	ldi a,(hl)
	ld b,a
	ld c,(hl)
	ld l,$cb
	ldi a,(hl)
	ldh (<hFF8F),a
	inc l
	ld a,(hl)
	ldh (<hFF8E),a
	cp c
	jr nz,@moveToBC
	ldh a,(<hFF8F)
	cp b
	jr nz,@moveToBC
	ld l,e
	dec (hl)
	ld l,$c6
	ld (hl),$10
	inc l
	inc (hl)
	jr @animate
	
@moveToBC:
	call objectGetRelativeAngleWithTempVars
	ld e,$c9
	ld (de),a
	call objectApplySpeed
@animate:
	jp partAnimate
	
@state5:
	call partCommon_decCounter1IfNonzero
	jr nz,@animate
	call objectCreatePuff
	jp partDelete

getMovingFlamesNextTileCoords:
	ld e,$c2
	ld a,(de)
	ld hl,@table
	rst_addDoubleIndex
	rst_derefHl
	ld e,$c7
	ld a,(de)
	rst_addAToHl
	ld b,(hl)
	ld a,b
	and $f0
	add $08
	ld e,$f0
	ld (de),a
	inc e
	ld a,b
	and $0f
	swap a
	add $08
	ld (de),a
	ret

@table:
	.dw @leftFlame
	.dw @topFlame
	.dw @rightFlame
	.dw @bottomFlame

@leftFlame:
	.db $51 $91 $93 $13 $19 $39 $3d $9d
	.db $97 $77 $7a $8a $00

@topFlame:
	.db $17 $13 $73 $7d $3d $39 $99 $91
	.db $61 $62 $00

@rightFlame:
	.db $5d $9d $95 $55 $51 $11 $1b $3b
	.db $35 $25 $26 $00

@bottomFlame:
	.db $97 $99 $79 $7d $9d $9b $3b $3d
	.db $1d $1b $3b $35 $55 $53 $93 $98
	.db $88 $00
