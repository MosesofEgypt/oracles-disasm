; The number of audio ticks (close to the number of frames) until the envelope reaches volume V when it
; starts from 1 and has sweep pace S can be approximated with the formula (V-1)*S*8192/(137+1/7)/64
; (8192 is the timer frequency, 137 the number of timer ticks between timer interrupts, the timer is
; decremented once every 7th timer interrupt, and 64 is the envelope tick frequency). The table does fit
; this formula with V as the row index and S as the column index (with rounding to the nearest integer),
; but strangely, in the way it is indexed, it is offset by two rows. For example, the second row is indexed by
; a target volume of 1 (the same as the starting volume), so you would expect no wait, but the game using the
; second row of the table causes it to wait until the volume reaches level 3 and then jump back to volume 1.
envelopeWaitTable:
	.db $00 $01 $02 $03 $04 $05 $06 $07
	.db $00 $02 $04 $06 $07 $09 $0b $0d
	.db $00 $03 $06 $08 $0b $0e $11 $14
	.db $00 $04 $07 $0b $0f $13 $16 $1a
	.db $00 $05 $09 $0e $13 $17 $1c $21
	.db $00 $06 $0b $11 $16 $1c $22 $27
	.db $00 $07 $0d $14 $1a $21 $27 $2e
	.db $00 $07 $0f $16 $1e $25 $2d $34
	.db $00 $08 $11 $19 $22 $2a $32 $3b
	.db $00 $09 $13 $1c $25 $2f $38 $41
	.db $00 $0a $15 $1f $29 $33 $3e $48
	.db $00 $0b $16 $22 $2d $38 $43 $4e
	.db $00 $0c $18 $24 $31 $3d $49 $55
	.db $00 $0d $1a $27 $34 $41 $4e $5b
.ifdef ENABLE_BUGFIXES
	; NOTE: extra 2 rows have been calculated from above
	;       formula to prevent indexing out of table range
	.db $00 $0e $1c $2a $38 $46 $54 $62
	.db $00 $0f $1e $2d $3c $4b $5a $69
.endif