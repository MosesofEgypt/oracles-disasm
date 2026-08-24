; texchnically there's 1 less interaction in ages, but w/e
.define NUM_INTERACTIONS $e8

.if defined(ROM_COMBO)
	interactionCodeTable_ages:
		m_GenerateCodeTable NUM_INTERACTIONS interactionDelete "INTERACTION" "interactionCode" "AGES" "Ages"

	interactionCodeTable_seasons:
		m_GenerateCodeTable NUM_INTERACTIONS interactionDelete "INTERACTION" "interactionCode" "SEASONS" "Seasons"
.elif defined(ROM_AGES)
	interactionCodeTable:
		m_GenerateCodeTable NUM_INTERACTIONS interactionDelete "INTERACTION" "interactionCode" "AGES" "Ages"
.else
	interactionCodeTable:
		m_GenerateCodeTable NUM_INTERACTIONS interactionDelete "INTERACTION" "interactionCode" "SEASONS" "Seasons"
.endif