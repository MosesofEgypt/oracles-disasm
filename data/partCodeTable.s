; NOTE: the code that calls these functions will break if the count goes over $80.
;       in NG+ it'll break if it goes over $55, so be careful about adding more.
.define NUM_PARTS $54

.macro m_PartCodeRef
	.ifdef ENABLE_NEW_GAME_PLUS
		.db :\1
	.endif
	.dw \1
.endm

partCodeTable:
	.repeat NUM_PARTS index COUNT
		.ifdef partCode{%.2x{COUNT}}
			m_PartCodeRef partCode{%.2x{COUNT}}
		.else
			m_PartCodeRef partCodeNil
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
