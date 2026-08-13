; NOTE: the code that calls these functions will break if the count goes over $80.
;       in NG+ it'll break if it goes over $55, so be careful about adding more.
.define NUM_PARTS $54

partCodeTable:
	.repeat NUM_PARTS index COUNT
		.if defined(ROM_COMBO)
			; NOTE: TEMPORARY UNTIL PARTS ARE MERGED IN
				.dw partCodeNil
		.elif defined(ENABLE_NEW_GAME_PLUS)
			.ifdef partCode{%.2x{COUNT}}
				3BytePointer partCode{%.2x{COUNT}}
			.else
				3BytePointer partCodeExt.partCode{%.2x{COUNT}}
			.endif
		.else
			.ifdef partCode{%.2x{COUNT}}
				.dw partCode{%.2x{COUNT}}
			.else
				.dw partCodeExt.partCode{%.2x{COUNT}}
			.endif
		.endif
	.endr

.ifdef ROM_AGES
partCode0a:
partCode0d:
.else
partCode34:
partCode35:
partCode36:
partCode37:
.endif
;;
partCodeNil:
	ret

;;
partCode00:
	jp partDelete
