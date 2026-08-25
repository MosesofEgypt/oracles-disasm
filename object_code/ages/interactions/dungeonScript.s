; ==================================================================================================
; INTERAC_DUNGEON_SCRIPT
; ==================================================================================================
m_InteractionCode $20
	call interactionDeleteAndRetIfEnabled02
	ld e,Interaction.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
	.dw @state2

@state0:
	ld a,$01
	ld (de),a

	xor a
	ld (wTmpcfc0.normal.doorControllerState),a
	ld (wTmpcfc0.normal.doorControllerState+$01),a

	ld a,(wDungeonIndex)
	cp $ff
	jp z,interactionDelete

	ld hl,@scriptTable
	rst_addDoubleIndex
	rst_derefHl
	ld e,Interaction.subid
	ld a,(de)
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	jp interactionRunScript

@state2:
	call objectPreventLinkFromPassing

@state1:
	call interactionRunScript
	ret nc
	jp interactionDelete

@scriptTable:
	.dw @dungeon0
	.dw @dungeon1
	.dw @dungeon2
	.dw @dungeon3
	.dw @dungeon4
	.dw @dungeon5
	.dw @dungeon6
	.dw @dungeon7
	.dw @dungeon8
	.dw @dungeon9
	.dw @dungeona
	.dw @dungeonb
	.dw @dungeonc
	.dw @dungeond

@dungeon0:
@dungeond:
	.dw {SCRIPTS_1}.makuPathScript_spawnChestWhenActiveTriggersEq01
	.dw {SCRIPTS_1}.makuPathScript_spawnDownStairsWhenEnemiesKilled
	.dw {SCRIPTS_1}.makuPathScript_spawn30Rupees
	.dw {SCRIPTS_1}.makuPathScript_keyFallsFromCeilingWhen1TorchLit
	.dw {SCRIPTS_1}.makuPathScript_spawnUpStairsWhen2TorchesLit
@dungeon1:
	.dw {SCRIPTS_1}.dungeonScript_spawnChestOnTriggerBit0
	.dw {SCRIPTS_1}.spiritsGraveScript_spawnBracelet
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.spiritsGraveScript_stairsToBraceletRoom
	.dw {SCRIPTS_1}.spiritsGraveScript_spawnMovingPlatform
@dungeon2:
	.dw {SCRIPTS_1}.wingDungeonScript_spawnFeather
	.dw {SCRIPTS_1}.wingDungeonScript_spawn30Rupees
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.wingDungeonScript_bossDeath
@dungeon3:
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.moonlitGrottoScript_spawnChestWhen2TorchesLit
@dungeon4:
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.skullDungeonScript_spawnChestWhenOrb0Hit
	.dw {SCRIPTS_1}.skullDungeonScript_spawnChestWhenOrb1Hit
@dungeon5:
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.crownDungeonScript_spawnChestWhen3TriggersActive
@dungeon6:
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
@dungeon7:
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
@dungeon8:
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.ancientTombScript_spawnSouthStairsWhenTrigger0Active
	.dw {SCRIPTS_1}.ancientTombScript_spawnNorthStairsWhenTrigger0Active
	.dw {SCRIPTS_1}.ancientTombScript_retractWallWhenTrigger0Active
	.dw {SCRIPTS_1}.ancientTombScript_spawnDownStairsWhenEnemiesKilled
	.dw {SCRIPTS_1}.ancientTombScript_spawnVerticalBridgeWhenTorchLit
@dungeon9:
@dungeona:
@dungeonb:
	.dw {SCRIPTS_1}.dungeonScript_spawnChestOnTriggerBit0
	.dw {SCRIPTS_1}.herosCaveScript_spawnChestWhen4TriggersActive
	.dw {SCRIPTS_1}.herosCaveScript_spawnBridgeWhenTriggerPressed
	.dw {SCRIPTS_1}.herosCaveScript_spawnNorthStairsWhenEnemiesKilled
@dungeonc:
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.mermaidsCaveScript_spawnBridgeWhenOrbHit
	.dw {SCRIPTS_1}.mermaidsCaveScript_updateTrigger2BasedOnTriggers0And1
