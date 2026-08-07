;;
; CUTSCENE_S_ONOX_FINAL_FORM
; Falling into final battle with onox (in the sidescrolling area)
cutscene13:
	ld a,(wCutsceneState)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (wCutsceneState),a
	ld hl,wTmpcfc0+$8
	ld b,$18
	call clearMemory
	ld a,>ROOM_SEASONS_7ff
	ld (wActiveGroup),a
	ld a,<ROOM_SEASONS_7ff
	ld (wActiveRoom),a
	ld a,$77
	ld (wDungeonMapPosition),a
	ld a,TILESETFLAG_SIDESCROLL | TILESETFLAG_DUNGEON
	ld (wTilesetFlags),a

	ld a,:w2DungeonLayout
	ld ($ff00+R_SVBK),a
	ld hl,w2DungeonLayout+$3f
	ld (hl),$ff
	xor a
	ld ($ff00+R_SVBK),a

	ld a,$04
	jp fadeoutToWhiteWithDelay

@state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz
	ld a,$02
	ld (wCutsceneState),a

@state2:
	call func_1613
	call updateMenus
	ret nz
	ld a,(wWarpTransition2)
	or a
	jp nz,applyWarpTransition2

	call seasonsFunc_331b
	call seasonsFunc_34a0
	call updateStatusBar
	ld a,(wCutsceneTrigger)
	or a
	jp z,checkEnemyAndPartCollisionsIfTextInactive
	jp setCutsceneIndexIfCutsceneTriggerSet