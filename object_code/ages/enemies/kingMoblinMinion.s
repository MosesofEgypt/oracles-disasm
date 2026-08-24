; ==================================================================================================
; ENEMY_KING_MOBLIN_MINION
; ==================================================================================================
m_EnemyCode $56
.if defined(ROM_COMBO)
	jpab enemyCodeAges3.enemyCode56_body
.else
	jpab enemyCode4.enemyCode56_body
.endif