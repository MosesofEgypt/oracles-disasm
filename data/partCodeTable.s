.define NUM_PARTS $5b

.if defined(ROM_COMBO)
	partCodeTable_ages:
		.repeat NUM_PARTS index COUNT
			.redefine partid {"{%.2x{COUNT}}"}

			.if defined(PART_{partid}_IN_EXT_AGES)
				3BytePointer partCodeAges.partCode{partid}

			.elif defined(PART_{partid}_EXISTS)
				3BytePointer partCode.partCode{partid}

			.else
				3BytePointer partCodeNil
				.print {"FAIL TO FIND PART_{partid} for AGES\n"}

			.endif
		.endr

	partCodeTable_seasons:
		.repeat NUM_PARTS index COUNT
			.redefine partid {"{%.2x{COUNT}}"}

			.if defined(PART_{partid}_IN_EXT_SEASONS)
				3BytePointer partCodeSeasons.partCode{partid}

			.elif defined(PART_{partid}_EXISTS)
				3BytePointer partCode.partCode{partid}

			.else
				3BytePointer partCodeNil
				.print {"FAIL TO FIND PART_{partid} for SEASONS\n"}

			.endif
		.endr

.else
	partCodeTable:
		.repeat NUM_PARTS index COUNT
			.redefine partid {"{%.2x{COUNT}}"}

			.if defined(ENABLE_NEW_GAME_PLUS)

				.if !defined(PART_{partid}_IN_EXT)
					.if defined(PART_{partid}_EXISTS)
						3BytePointer partCode{partid}
					.else
						3BytePointer partCodeNil
						;.print {"FAIL TO FIND PART_{partid}\n"}
					.endif

				.elif PART_{partid}_IN_EXT == 1
					3BytePointer partCodeExt.partCode{partid}

				.elif PART_{partid}_IN_EXT == 2
					3BytePointer partCodeExt2.partCode{partid}

				.elif PART_{partid}_IN_EXT == 3
					3BytePointer partCodeExt3.partCode{partid}

				.else
					.fail "Unknown part bank extension."

				.endif

			.elif defined(PART_{partid}_IN_EXT)
				.dw partCodeExt.partCode{partid}

			.elif defined(PART_{partid}_EXISTS)
				.dw partCode{partid}

			.else
				.dw partCodeNil
				;.print {"FAIL TO FIND PART_{partid}\n"}

			.endif
		.endr
.endif

.undefine partid

partCodeNil:
	ret
