; Could there be over 0x80 enemies? Things that would need to be changed:
; - enemyGetObjectGfxIndex
; - itemDropTables

.define NUM_ENEMIES $80

.if defined(ROM_COMBO)
	enemyCodeTable_ages:
		m_GenerateCodeTable NUM_ENEMIES enemyCodeNil "ENEMY" "enemyCode" "AGES" "Ages"

	enemyCodeTable_seasons:
		m_GenerateCodeTable NUM_ENEMIES enemyCodeNil "ENEMY" "enemyCode" "SEASONS" "Seasons"
.else
	enemyCodeTable:
		m_GenerateCodeTable NUM_ENEMIES enemyCodeNil "ENEMY" "enemyCode"
.endif

enemyCodeNil:
	ret