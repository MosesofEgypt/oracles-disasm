; Bitset of valid targets for bombchus. Each bit corresponds to one enemy ID.
bombchuTargets:
	.db $00 $3f $97 $7d $3f $30 $37 $7c
	.db $e9 $ef $02 $40 $00 $00 $03 $00
.ifdef ENABLE_RING_REDUX
	; azuchu targets
	; removed:
	;	spiked beetle
	;	armos
	;	pols voice
	;	boss facade
	; added:
	;	wallmaster
	;	cucco
	;	crow
	;	blue crow
	;	flying tile
	;	seeds on tree
	.db $00 $3f $87 $5d $37 $31 $77 $7f
	.db $eb $ff $06 $60 $00 $00 $01 $00
.endif