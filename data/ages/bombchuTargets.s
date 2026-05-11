; Bitset of valid targets for bombchus. Each bit corresponds to one enemy ID.
bombchuTargets:
	.db $00 $bf $97 $fd $3f $30 $37 $fc
	.db $ad $ef $32 $40 $10 $00 $00 $00
.ifdef ENABLE_RING_REDUX
	; azuchu targets
	; removed:
	;	spiked beetle
	;	armos
	;	pols voice
	;	eyesoar child
	;	ambi guard
	;	enemy candle
	; added:
	;	wallmaster
	;	cucco
	;	crow
	;	blue crow
	;	flying tile
	;	seeds on tree
	;	harmless hardhat beetle
	.db $00 $bf $85 $dd $37 $31 $77 $ff
	.db $af $ff $06 $68 $10 $00 $00 $00
.endif