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
	.dw @dungeonA
	.dw @dungeonB

@dungeon0:
	.dw {SCRIPTS_1}.dungeonScript_end
	.dw {SCRIPTS_1}.dungeonScript_checkActiveTriggersEq01

@dungeon1:
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_checkActiveTriggersEq01
	.dw {SCRIPTS_1}.dungeonScript_checkActiveTriggersEq01
	.dw {SCRIPTS_1}.dungeonScript_bossDeath

@dungeon2:
	.dw {SCRIPTS_1}.snakesRemainsScript_timerForChestDisappearing
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.snakesRemainsScript_bossDeath

@dungeon3:
	.dw {SCRIPTS_1}.poisonMothsLairScript_hallwayTrapRoom
	.dw {SCRIPTS_1}.poisonMothsLairScript_checkStatuePuzzle
	.dw {SCRIPTS_1}.poisonMothsLairScript_minibossDeath
	.dw {SCRIPTS_1}.poisonMothsLairScript_bossDeath
	.dw {SCRIPTS_1}.poisonMothsLairScript_openEssenceDoorIfBossBeat

@dungeon4:
	.dw {SCRIPTS_1}.dancingDragonScript_spawnStairsToB1
	.dw {SCRIPTS_1}.dancingDragonScript_torchesHallway
	.dw {SCRIPTS_1}.dancingDragonScript_torchesHallway
	.dw {SCRIPTS_1}.dancingDragonScript_spawnBossKey
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dancingDragonScript_pushingPotsRoom
	.dw {SCRIPTS_1}.dancingDragonScript_bridgeInB2

@dungeon5:
	.dw {SCRIPTS_1}.unicornsCaveScript_spawnBossKey
	.dw {SCRIPTS_1}.unicornsCaveScript_dropMagnetBallAfterDarknutKill
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath

@dungeon6:
	.dw {SCRIPTS_1}.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw {SCRIPTS_1}.ancientRuinsScript_spawnStaircaseUp1FTopLeftRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_spawnStaircaseUp1FTopMiddleRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_4c50
	.dw {SCRIPTS_1}.ancientRuinsScript_5TorchesMovingPlatformsRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_roomWithJustRopesSpawningButton
	.dw {SCRIPTS_1}.ancientRuinsScript_UShapePitToMagicBoomerangOrb
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.ancientRuinsScript_randomButtonRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_4F3OrbsRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_spawnStairsLeadingToBoss
	.dw {SCRIPTS_1}.ancientRuinsScript_spawnHeartContainerAndStairsUp
	.dw {SCRIPTS_1}.ancientRuinsScript_1FTopRightTrapButtonRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_crystalTrapRoom
	.dw {SCRIPTS_1}.ancientRuinsScript_spawnChestAfterCrystalTrapRoom

@dungeon7:
	.dw {SCRIPTS_1}.explorersCryptScript_4OrbTrampoline
	.dw {SCRIPTS_1}.explorersCryptScript_magunesuTrampoline
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.explorersCryptScript_4d05
	.dw {SCRIPTS_1}.explorersCryptScript_randomlyPlaceNonEnemyArmos
	.dw {SCRIPTS_1}.dungeonScript_checkIfMagnetBallOnButton
	.dw {SCRIPTS_1}.explorersCryptScript_1stPoeSisterRoom
	.dw {SCRIPTS_1}.explorersCryptScript_2ndPoeSisterRoom
	.dw {SCRIPTS_1}.explorersCryptScript_4FiresRoom_1
	.dw {SCRIPTS_1}.explorersCryptScript_4FiresRoom_2
	.dw {SCRIPTS_1}.explorersCryptScript_darknutBridge
	.dw {SCRIPTS_1}.explorersCryptScript_roomLeftOfRandomArmosRoom
	.dw {SCRIPTS_1}.explorersCryptScript_dropKeyDownAFloor
	.dw {SCRIPTS_1}.explorersCryptScript_keyDroppedFromAbove

@dungeon8:
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_verticalBridgeUnlockedByOrb
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_verticalBridgeInLava
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_armosBlockingStairs
	.dw {SCRIPTS_1}.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_7torchesAfterMiniboss
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_spawnFireKeeseAtLavaHoles
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_pushableIceBlocks
	.dw {SCRIPTS_1}.dungeonScript_minibossDeath
	.dw {SCRIPTS_1}.dungeonScript_bossDeath
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_horizontalBridgeByMoldorms
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_tripleEyesByMiniboss
	.dw {SCRIPTS_1}.swordAndShieldMazeScript_tripleEyesNearStart

@dungeon9:
	.dw {SCRIPTS_1}.onoxsCastleScript_setFlagOnAllEnemiesDefeated
	.dw {SCRIPTS_1}.onoxsCastleScript_resetRoomFlagsOnDungeonStart

@dungeonA:
@dungeonB:
	.dw {SCRIPTS_1}.dungeonScript_spawnKeyOnMagnetBallToButton
	.dw {SCRIPTS_1}.dungeonScript_checkActiveTriggersEq01
	.dw {SCRIPTS_1}.herosCaveScript_spawnChestOnTorchLit
	.dw {SCRIPTS_1}.dungeonScript_checkIfMagnetBallOnButton
	.dw {SCRIPTS_1}.herosCaveScript_check6OrbsHit
	.dw {SCRIPTS_1}.herosCaveScript_allButtonsPressedAndEnemiesDefeated
	.dw {SCRIPTS_1}.herosCaveScript_spawnChestOn2TorchesLit
