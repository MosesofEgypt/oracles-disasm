.define NUM_PARTS $5b

.if defined(ROM_COMBO)
	partCodeTable_ages:
		m_GenerateCodeTable NUM_PARTS partCodeNil "PART" "partCode" "AGES" "Ages"

	partCodeTable_seasons:
		m_GenerateCodeTable NUM_PARTS partCodeNil "PART" "partCode" "SEASONS" "Seasons"
.else
	partCodeTable:
		m_GenerateCodeTable NUM_PARTS partCodeNil "PART" "partCode"
.endif


partCodeNil:
	ret
