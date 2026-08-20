; NOTE: the code that calls these functions will break if the count goes over $80.
;       in NG+ it'll break if it goes over $55, so be careful about adding more.
.define NUM_PARTS $54

partCodeTable:
	.repeat NUM_PARTS index COUNT
		.if defined(ROM_COMBO)
			; NOTE: TEMPORARY UNTIL PARTS ARE MERGED IN
			3BytePointer partCodeNil
		.elif defined(ROM_COMBO) || defined(ENABLE_NEW_GAME_PLUS)
			.ifndef PART_{%.2x{COUNT}}_IN_EXT
				3BytePointer partCode{%.2x{COUNT}}
			.elif PART_{%.2x{COUNT}}_IN_EXT == 1
				3BytePointer partCodeExt.partCode{%.2x{COUNT}}
			.elif PART_{%.2x{COUNT}}_IN_EXT == 2
				3BytePointer partCodeExt2.partCode{%.2x{COUNT}}
			.elif PART_{%.2x{COUNT}}_IN_EXT == 3
				3BytePointer partCodeExt3.partCode{%.2x{COUNT}}
			.elif PART_{%.2x{COUNT}}_IN_EXT == 1
				3BytePointer partCodeExt.partCode{%.2x{COUNT}}
			.else
				fail "Unknown part bank extension."
			.endif
		.else
			.ifndef PART_{%.2x{COUNT}}_IN_EXT
				.dw partCode{%.2x{COUNT}}
			.else
				.dw partCodeExt.partCode{%.2x{COUNT}}
			.endif
		.endif
	.endr

.if defined(ROM_AGES)
m_PartCode $0a
m_PartCode $0d
.elif defined(ROM_SEASONS)
m_PartCode $34
m_PartCode $35
m_PartCode $36
m_PartCode $37
.endif
;;
partCodeNil:
	ret

;;
m_PartCode $00
	jp partDelete
