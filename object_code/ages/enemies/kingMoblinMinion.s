; ==================================================================================================
; ENEMY_KING_MOBLIN_MINION
; ==================================================================================================
m_EnemyCode $56
.if defined(ROM_COMBO)
	jpab enemyCodeAgesExt2.enemyCode56_body
.else
	jpab enemyCodeExt3.enemyCode56_body
.endif