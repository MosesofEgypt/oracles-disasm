.include "include/constants.s"
.include "include/rominfo.s"
.include "include/emptyfill.s"
.include "include/structs.s"
.include "include/wram.s"
.include "include/hram.s"
.include "include/macros.s"
.include "include/script_commands.s"
.include "include/simplescript_commands.s"
.include "include/movementscript_commands.s"

.include "objects/macros.s"
.include "include/gfxDataMacros.s"
.include "include/musicMacros.s"

.include {"{BUILD_DIR}/ages_textDefines.s"}
.include {"{BUILD_DIR}/seasons_textDefines.s"}


.BANK $00 SLOT 0
.ORG 0

;	.include "code/bank0.s"
; NOTE: temporary code until bank0 can be included
	.include "code/bank0Stub.s"
; NOTE: temporary code until bank0 can be included


.BANK $01 SLOT 1
.ORG 0

;	.include "code/bank1.s"

; NOTE: temporary code until bank1 can be included
	.include {"{BUILD_DIR}/paletteHeaders.s"}
	.include {"{GAME_DATA_DIR}/paletteTransitions.s"}
	.include {"{GAME_DATA_DIR}/uncmpGfxHeaders.s"}
	.include {"{GAME_DATA_DIR}/gfxHeaders.s"}
	.include "data/seasons/roomPackSeasonTable.s"
; NOTE: temporary code until bank1 can be included


; NOTE: temporary code until many banks can be included
m_section_free Bank_1_test NAMESPACE bank1
checkUpdateDungeonMinimap:
checkInitUnderwaterWaves:
checkSolidObjectAtWarpDestPos:
clearMemoryOnScreenReload:
checkDisableUnderwaterWaves:
calculateRoomEdge:
func_49c9:
setObjectsEnabledTo2:
findActiveRoomInDungeonLayoutWithPointlessBankSwitch:
	nop

.include {"{GAME_DATA_DIR}/dungeonData.s"}
.include "data/dungeonProperties.s"
.include {"{GAME_DATA_DIR}/dungeonLayouts.s"}
.include {"{GAME_DATA_DIR}/seedTreeRefillData.s"}
.include {"{GAME_DATA_DIR}/tile_properties/warpTiles.s"}

.ends

m_section_free Bank_2_test NAMESPACE bank2
fileSelect_redrawDecorationsAndSetWramBank4:
	nop
.ends

m_section_free Bank_3_test NAMESPACE bank3
generateGameTransferSecret:
	nop
.ends

m_section_free Bank_6_test NAMESPACE bank6
specialObjectLoadAnimationFrameToBuffer:
	nop
.ends

m_section_free Bank_8_test NAMESPACE agesInteractionsBank08
shootingGallery_removeAllTargets:
shootingGallery_initializeGameRounds:
interactionOscillateXRandomly:
	nop
.ends

m_section_free Bank_9_test NAMESPACE agesInteractionsBank09
linkEnterPalaceSimulatedInput:
linkExitPalaceSimulatedInput:
	nop
.ends

m_section_free Bank_a_test NAMESPACE agesInteractionsBank0a
func_0a_7877:
	nop
.ends

m_section_free Bank_15_test NAMESPACE seasonsInteractionsBank15
checkGoldenBeastsKilled:
giveRedRing:
linkedHerosCaveOldMan_takeRupees:
linkedHerosCaveOldMan_spawnChests:
spawnRodOfSeasonsSparkles:
forceLinksDirection:
	nop
.ends


; NOTE: temporary code until many banks can be included



.BANK $02 SLOT 1
.ORG 0

;	.include "code/bank2.s"
;	.include "code/roomInitialization.s"


.BANK $03 SLOT 1
.ORG 0

;	.include "code/bank3.s"

	; This section could probably be made superfree in Ages, but this isn't the case in Seasons,
	; so let's just play it safe and leave it as "free".
	 m_section_free Bank_3_Cutscenes NAMESPACE bank3Cutscenes
		.include "code/bank3Cutscenes.s"
		.include "code/ages/cutscenes/endgameCutscenes.s"
		.include "code/ages/cutscenes/miscCutscenes.s"
	.ends

.BANK $04 SLOT 1
.ORG 0

;	.include "code/bank4.s"

	 m_section_superfree RoomPacksAndMusicAssignments NAMESPACE bank4Data1
		; These 2 includes must be in the same bank
		.include {"{GAME_DATA_DIR}/roomPacks.s"}
		.include {"{GAME_DATA_DIR}/musicAssignments.s"}
	.ends

	 m_section_superfree RoomLayouts NAMESPACE roomLayouts
		.include {"{GAME_DATA_DIR}/roomLayoutGroupTable.s"}
	.ends

	; Must be in the same bank as "Tileset_Loading_2".
	 m_section_free Tileset_Loading_1 NAMESPACE tilesets
		.include {"{GAME_DATA_DIR}/tilesets.s"}
		.include {"{GAME_DATA_DIR}/tilesetAssignments.s"}
	.ends

	 m_section_superfree animationAndUniqueGfxData NAMESPACE animationAndUniqueGfxData
;		.include "code/animations.s"

		.include {"{GAME_DATA_DIR}/uniqueGfxHeaders.s"}
		.include {"{BUILD_DIR}/animationGroups.s"}
		.include {"{GAME_DATA_DIR}/animationGfxHeaders.s"}
		.include {"{BUILD_DIR}/animationData.s"}
	.ends

	 m_section_free roomTileChanges NAMESPACE roomTileChanges
;		.include "code/ages/tileSubstitutions.s"
;		.include {"{GAME_DATA_DIR}/singleTileChanges.s"}
;		.include "code/ages/roomSpecificTileChanges.s"
	.ends

	 m_section_free Tileset_Loading_2 NAMESPACE tilesets
		.include "code/loadTilesToRam.s"
		.include "code/ages/loadTilesetData.s"
	.ends

		; Must be in same bank as "code/bank4.s"
	 m_section_free Warp_Data NAMESPACE bank4
		.include {"{GAME_DATA_DIR}/warpDestinations.s"}
		.include {"{GAME_DATA_DIR}/warpSources.s"}
	.ends


.BANK $05 SLOT 1
.ORG 0

	 m_section_free Bank_5 NAMESPACE bank5
;		.include "code/specialObjects.s"

		.include {"{GAME_DATA_DIR}/tile_properties/tileTypeMappings.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/cliffTiles.s"}
	.ends


.BANK $06 SLOT 1
.ORG 0


m_section_free Bank_6 NAMESPACE bank6

;	.include "code/interactableTiles.s"
;	.include "code/specialObjectAnimationsAndDamage.s"

; NOTE: temporary code until specialObjectAnimationsAndDamage can be included
	.include {"{BUILD_DIR}/specialObjectAnimationPointers.s"}
; NOTE: temporary code until specialObjectAnimationsAndDamage can be included

;	.include "code/parentItemUsage.s"

;	.include "object_code/common/itemParents/shieldParent.s"
;	.include "object_code/common/itemParents/otherSwordsParent.s"
;	.include "object_code/common/itemParents/switchHookParent.s"
;	.include "object_code/common/itemParents/caneOfSomariaParent.s"
;	.include "object_code/common/itemParents/swordParent.s"
;	.include "object_code/common/itemParents/harpFluteParent.s"
;	.include "object_code/common/itemParents/seedsParent.s"
;	.include "object_code/common/itemParents/shovelParent.s"
;	.include "object_code/common/itemParents/boomerangParent.s"
;	.include "object_code/common/itemParents/bombsBraceletParent.s"
;	.include "object_code/common/itemParents/featherParent.s"
;	.include "object_code/common/itemParents/magnetGloveParent.s"
;	.include "object_code/common/itemParents/lifeVialParent.s"

;	.include "object_code/common/itemParents/commonCode.s"

	.include {"{GAME_DATA_DIR}/itemUsageTables.s"}

;	.include "object_code/common/specialObjects/minecart.s"
;	.include "object_code/ages/specialObjects/raft.s"

	.include {"{BUILD_DIR}/specialObjectAnimationData.s"}
;	.include "object_code/ages/specialObjects/companionCutscene.s"
;	.include "object_code/ages/specialObjects/linkInCutscene.s"
	.include {"{GAME_DATA_DIR}/signText.s"}

;	.include "object_code/ages/specialObjects/timeWarp.s"

.ends


.BANK $07 SLOT 1
.ORG 0

	 m_section_superfree File_Management namespace fileManagement
;		.include "code/fileManagement.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Bank_7_Data".
	 m_section_free Enemy_Part_Collisions namespace bank7
;		.include "code/collisionEffects.s"
	.ends

	 m_section_superfree Item_Code namespace itemCode
;		.include "code/updateItems.s"
;		.include "object_code/common/items/commonCode1.s"

		.include {"{GAME_DATA_DIR}/tile_properties/conveyorItemTiles.s"}
		.include {"{GAME_DATA_DIR}/tile_properties/itemPassableTiles.s"}

;		.include "object_code/common/items/seeds.s"
;		.include "object_code/common/items/dimitriMouth.s"
;		.include "object_code/common/items/bombchus.s"
;		.include "object_code/common/items/bombs.s"
;		.include "object_code/common/items/boomerang.s"
;		.include "object_code/common/items/switchHook.s"
;		.include "object_code/common/items/rickyTornado.s"
;		.include "object_code/common/items/magnetBall.s"
;		.include "object_code/common/items/seedShooter.s"
;		.include "object_code/common/items/rickyMooshAttack.s"
;		.include "object_code/common/items/shovel.s"
;		.include "object_code/common/items/caneOfSomaria.s"
;		.include "object_code/common/items/minecartCollision.s"
;		.include "object_code/common/items/slingshot.s"
;		.include "object_code/common/items/foolsOre.s"
;		.include "object_code/common/items/biggoronSword.s"
;		.include "object_code/common/items/sword.s"
;		.include "object_code/common/items/punch.s"
;		.include "object_code/common/items/swordBeam.s"
;		.include "object_code/common/items/postUpdate.s"
;		.include "object_code/common/items/commonCode2.s"
;		.include "object_code/common/items/bracelet.s"
;		.include "object_code/common/items/commonBombAndBraceletCode.s"
;		.include "object_code/common/items/dust.s"

		; CROSSITEMS
;		.include "object_code/common/items/magnetGloves.s"
;		.include "object_code/common/items/rodOfSeasons.s"

		.include {"{GAME_DATA_DIR}/itemAttributes.s"}
		.include "data/itemAnimations.s"
	.ends

	 ; This section can't be superfree, since it must be in the same bank as section
	 ; "Enemy_Part_Collisions".
	 m_section_free Bank_7_Data namespace bank7
		.include {"{GAME_DATA_DIR}/enemyActiveCollisions.s"}
		.include {"{GAME_DATA_DIR}/partActiveCollisions.s"}
		.include {"{BUILD_DIR}/objectCollisionTable.s"}
	.ends


.BANK $08 SLOT 1
.ORG 0

m_section_free Interaction_Code_Group1 NAMESPACE commonInteractions1
;	.include "object_code/common/interactions/breakTileDebris.s"
;	.include "object_code/common/interactions/fallDownHole.s"
;	.include "object_code/common/interactions/farore.s"
;	.include "object_code/common/interactions/faroreMakeChest.s"
;	.include "object_code/common/interactions/dungeonStuff.s"
;	.include "object_code/common/interactions/pushblockTrigger.s"
;	.include "object_code/common/interactions/pushblock.s"
;	.include "object_code/common/interactions/minecart.s"
;	.include "object_code/common/interactions/dungeonKeySprite.s"
;	.include "object_code/common/interactions/overworldKeySprite.s"
;	.include "object_code/common/interactions/faroresMemory.s"
;	.include "object_code/common/interactions/doorController.s"
.ends

m_section_free Ages_Interactions_Bank8 NAMESPACE agesInteractionsBank08
;	.include "object_code/ages/interactions/toggleFloor.s"
;	.include "object_code/ages/interactions/coloredCube.s"
;	.include "object_code/ages/interactions/coloredCubeFlame.s"
;	.include "object_code/ages/interactions/minecartGate.s"
;	.include "object_code/ages/interactions/specialWarp.s"
;	.include "object_code/ages/interactions/dungeonScript.s"
;	.include "object_code/ages/interactions/dungeonEvents.s"
;	.include "object_code/ages/interactions/floorColorChanger.s"
;	.include "object_code/ages/interactions/extendableBridge.s"
;	.include "object_code/ages/interactions/triggerTranslator.s"
;	.include "object_code/ages/interactions/tileFiller.s"
;	.include "object_code/common/interactions/bipin.s"
;	.include "object_code/ages/interactions/adlar.s"
;	.include "object_code/ages/interactions/librarian.s"
;	.include "object_code/common/interactions/blossom.s"
;	.include "object_code/ages/interactions/veranCutsceneWallmaster.s"
;	.include "object_code/ages/interactions/veranCutsceneFace.s"
;	.include "object_code/ages/interactions/oldManWithRupees.s"
;	.include "object_code/ages/interactions/playNayruMusic.s"
;	.include "object_code/ages/interactions/shootingGallery.s"
;	.include "object_code/ages/interactions/impaInCutscene.s"
;	.include "object_code/ages/interactions/fakeOctorok.s"
;	.include "object_code/ages/interactions/smogBoss.s"
;	.include "object_code/ages/interactions/triforceStone.s"
;	.include "object_code/common/interactions/child.s"
;	.include "object_code/ages/interactions/nayru.s"
;	.include "object_code/ages/interactions/ralph.s"
;	.include "object_code/ages/interactions/pastGirl.s"
;	.include "object_code/ages/interactions/monkey.s"
;	.include "object_code/ages/interactions/villager.s"
;	.include "object_code/ages/interactions/femaleVillager.s"
;	.include "object_code/ages/interactions/boy.s"
;	.include "object_code/ages/interactions/oldLady.s"
.ends


.BANK $09 SLOT 1
.ORG 0

m_section_free Interaction_Code_Group2 NAMESPACE commonInteractions2
;	.include "object_code/common/interactions/shopkeeper.s"
;	.include "object_code/common/interactions/shopItem.s"
;	.include "object_code/common/interactions/introSprites1.s"
;	.include "object_code/common/interactions/seasonsFairy.s"
;	.include "object_code/common/interactions/explosion.s"
.ends

;	.include "object_code/common/interactions/treasure.s"

m_section_free Ages_Interactions_Bank9 NAMESPACE agesInteractionsBank09
;	.include "object_code/ages/interactions/ghostVeran.s"
;	.include "object_code/ages/interactions/boy2.s"
;	.include "object_code/ages/interactions/soldier.s"
;	.include "object_code/ages/interactions/miscMan.s"
;	.include "object_code/ages/interactions/mustacheMan.s"
;	.include "object_code/ages/interactions/pastGuy.s"
;	.include "object_code/ages/interactions/miscMan2.s"
;	.include "object_code/ages/interactions/pastOldLady.s"
;	.include "object_code/ages/interactions/tokay.s"
;	.include "object_code/ages/interactions/forestFairy.s"
;	.include "object_code/ages/interactions/rabbit.s"
;	.include "object_code/ages/interactions/bird.s"
;	.include "object_code/ages/interactions/ambi.s"
;	.include "object_code/ages/interactions/subrosian.s"
;	.include "object_code/ages/interactions/impaNpc.s"
;	.include "object_code/ages/interactions/dumbellMan.s"
;	.include "object_code/ages/interactions/oldMan.s"
;	.include "object_code/ages/interactions/mamamuYan.s"
;	.include "object_code/ages/interactions/mamamuDog.s"
;	.include "object_code/ages/interactions/postman.s"
;	.include "object_code/ages/interactions/pickaxeWorker.s"
;	.include "object_code/ages/interactions/hardhatWorker.s"
;	.include "object_code/ages/interactions/poe.s"
;	.include "object_code/ages/interactions/oldZora.s"
;	.include "object_code/ages/interactions/toiletHand.s"
;	.include "object_code/ages/interactions/maskSalesman.s"
;	.include "object_code/ages/interactions/bear.s"
;	.include "object_code/ages/interactions/sword.s"
;	.include "object_code/common/interactions/syrup.s"
;	.include "object_code/ages/interactions/lever.s"
;	.include "object_code/ages/interactions/makuConfetti.s"
;	.include "object_code/ages/interactions/accessory.s"
;	.include "object_code/ages/interactions/raftwreckCutsceneHelper.s"
;	.include "object_code/ages/interactions/comedian.s"
;	.include "object_code/ages/interactions/goron.s"
.ends


.BANK $0a SLOT 1
.ORG 0

m_section_free Interaction_Code_Group3 NAMESPACE commonInteractions3
;	.include "object_code/common/interactions/bombFlower.s"
;	.include "object_code/common/interactions/switchTileToggler.s"
;	.include "object_code/common/interactions/movingPlatform.s"
;	.include "object_code/common/interactions/roller.s"
;	.include "object_code/common/interactions/spinner.s"
;	.include "object_code/common/interactions/minibossPortal.s"
;	.include "object_code/common/interactions/essence.s"
.ends

m_section_free Interaction_Code_Group4 NAMESPACE commonInteractions4
;	.include "object_code/common/interactions/vasu.s"
;	.include "object_code/common/interactions/bubble.s"
.ends

m_section_free Ages_Interactions_BankA NAMESPACE agesInteractionsBank0a
;	.include "object_code/common/interactions/companionSpawner.s"
;	.include "object_code/ages/interactions/rosa.s"
;	.include "object_code/ages/interactions/rafton.s"
;	.include "object_code/ages/interactions/cheval.s"
;	.include "object_code/ages/interactions/miscellaneous1.s"
;	.include "object_code/ages/interactions/fairyHidingMinigame.s"
;	.include "object_code/ages/interactions/possessedNayru.s"
;	.include "object_code/ages/interactions/nayruSavedCutscene.s"
;	.include "object_code/ages/interactions/wildTokayController.s"
;	.include "object_code/ages/interactions/companionScripts.s"
;	.include "object_code/ages/interactions/kingMoblinDefeated.s"
;	.include "object_code/ages/interactions/ghiniHarassingMoosh.s"
;	.include "object_code/ages/interactions/rickysGloveSpawner.s"
;	.include "object_code/ages/interactions/introSprite.s"
;	.include "object_code/ages/interactions/makuGateOpening.s"
;	.include "object_code/ages/interactions/smallKeyOnEnemy.s"
;	.include "object_code/ages/interactions/stonePanel.s"
;	.include "object_code/ages/interactions/screenDistortion.s"
;	.include "object_code/ages/interactions/decoration.s"
;	.include "object_code/ages/interactions/tokayShopItem.s"
;	.include "object_code/ages/interactions/sarcophagus.s"
;	.include "object_code/ages/interactions/bombUpgradeFairy.s"
;	.include "object_code/ages/interactions/sparkle.s"
;	.include "object_code/ages/interactions/makuFlower.s"
;	.include "object_code/ages/interactions/makuTree.s"
;	.include "object_code/ages/interactions/makuSprout.s"
;	.include "object_code/ages/interactions/remoteMakuCutscene.s"
;	.include "object_code/ages/interactions/goronElder.s"
;	.include "object_code/ages/interactions/tokayMeat.s"
;	.include "object_code/ages/interactions/cloakedTwinrova.s"
;	.include "object_code/ages/interactions/octogonSplash.s"
;	.include "object_code/ages/interactions/tokayCutsceneEmberSeed.s"
;	.include "object_code/ages/interactions/miscPuzzles.s"
;	.include "object_code/ages/interactions/fallingRock.s"
;	.include "object_code/ages/interactions/twinrova.s"
;	.include "object_code/ages/interactions/patch.s"
;	.include "object_code/ages/interactions/ball.s"
;	.include "object_code/ages/interactions/moblin.s"
;	.include "object_code/ages/interactions/97.s"
.ends


.BANK $0b SLOT 1
.ORG 0

m_section_free Interaction_Code_Group5 NAMESPACE commonInteractions5
;	.include "object_code/common/interactions/woodenTunnel.s"
;	.include "object_code/common/interactions/exclamationMark.s"
;	.include "object_code/common/interactions/floatingImage.s"
;	.include "object_code/common/interactions/bipinBlossomFamilySpawner.s"
;	.include "object_code/common/interactions/gashaSpot.s"
;	.include "object_code/common/interactions/kissHeart.s"
;	.include "object_code/common/interactions/banana.s"
;	.include "object_code/common/interactions/createObjectAtEachTileindex.s"
.ends

m_section_free Interaction_Code_Group6 NAMESPACE commonInteractions6
;	.include "object_code/common/interactions/businessScrub.s"
;	.include "object_code/common/interactions/cf.s"
;	.include "object_code/common/interactions/companionTutorial.s"
;	.include "object_code/common/interactions/gameCompleteDialog.s"
;	.include "object_code/common/interactions/titlescreenClouds.s"
;	.include "object_code/common/interactions/introBird.s"
;	.include "object_code/common/interactions/linkShip.s"
.ends

m_section_free Interaction_Code_Group7 NAMESPACE commonInteractions7
;	.include "object_code/common/interactions/faroreGiveItem.s"
;	.include "object_code/common/interactions/zeldaApproachTrigger.s"
.ends

m_section_free Ages_Interactions_Bank0b NAMESPACE agesInteractionsBank0b
;	.include "object_code/ages/interactions/explosionWithDebris.s"
;	.include "object_code/ages/interactions/carpenter.s"
;	.include "object_code/ages/interactions/raftwreckCutscene.s"
;	.include "object_code/ages/interactions/kingZora.s"
;	.include "object_code/ages/interactions/tokkey.s"
;	.include "object_code/ages/interactions/waterPushblock.s"
;	.include "object_code/common/interactions/movingSidescrollPlatform.s"
;	.include "object_code/common/interactions/movingSidescrollConveyor.s"
;	.include "object_code/ages/interactions/disappearingSidescrollPlatform.s"
;	.include "object_code/ages/interactions/circularSidescrollPlatform.s"
;	.include "object_code/ages/interactions/touchingBook.s"
;	.include "object_code/ages/interactions/makuSeed.s"
;	.include "object_code/common/interactions/endgameCutsceneBipsomFamily.s"
;	.include "object_code/ages/interactions/a8.s"
;	.include "object_code/common/interactions/twinrovaFlame.s"
;	.include "object_code/ages/interactions/din.s"
;	.include "object_code/ages/interactions/zora.s"
;	.include "object_code/ages/interactions/zelda.s"
;	.include "object_code/common/interactions/creditsTextHorizontal.s"
;	.include "object_code/common/interactions/creditsTextVertical.s"
;	.include "object_code/ages/interactions/twinrovaInCutscene.s"
;	.include "object_code/ages/interactions/tuniNut.s"
;	.include "object_code/ages/interactions/volcanoHandler.s"
;	.include "object_code/ages/interactions/harpOfAgesSpawner.s"
;	.include "object_code/ages/interactions/bookOfSealsPodium.s"
;	.include "object_code/common/interactions/finalDungeonEnergy.s"
;	.include "object_code/ages/interactions/vire.s"
;	.include "object_code/common/interactions/horonDogCredits.s"
;	.include "object_code/ages/interactions/childJabu.s"
;	.include "object_code/ages/interactions/humanVeran.s"
;	.include "object_code/ages/interactions/twinrova3.s"
;	.include "object_code/ages/interactions/pushblockSynchronizer.s"
;	.include "object_code/ages/interactions/ambisPalaceButton.s"
;	.include "object_code/ages/interactions/symmetryNpc.s"
;	.include "object_code/common/interactions/c1.s"
;	.include "object_code/ages/interactions/pirateShip.s"
;	.include "object_code/ages/interactions/pirateCaptain.s"
;	.include "object_code/ages/interactions/pirate.s"
;	.include "object_code/ages/interactions/playHarpSong.s"
;	.include "object_code/ages/interactions/blackTowerDoorHandler.s"
;	.include "object_code/ages/interactions/tingle.s"
;	.include "object_code/common/interactions/syrupCucco.s"
;	.include "object_code/ages/interactions/troy.s"
;	.include "object_code/ages/interactions/linkedGameGhini.s"
;	.include "object_code/ages/interactions/plen.s"
;	.include "object_code/ages/interactions/masterDiver.s"
;	.include "object_code/ages/interactions/greatFairy.s"
;	.include "object_code/ages/interactions/dekuScrub.s"
;	.include "object_code/ages/interactions/makuSeedAndEssences.s"
;	.include "object_code/ages/interactions/leverLavaFiller.s"
;	.include "object_code/ages/interactions/slateSlot.s"
.ends


.BANK $0c SLOT 1
.ORG 0

	; TODO: "SIMPLE_SCRIPT_BANK" define should be tied to this section somehow
	 m_section_free Scripts namespace mainScripts
;		.include "code/scripting.s"
;		.include {"{BUILD_DIR}/scripts.s"}
	.ends


.BANK $0d SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0d NAMESPACE bank0d

;	.include "object_code/common/enemies/commonCode.s"

;	.include "object_code/common/enemies/riverZora.s"
;	.include "object_code/common/enemies/octorok.s"
;	.include "object_code/common/enemies/boomerangMoblin.s"
;	.include "object_code/common/enemies/leever.s"
;	.include "object_code/common/enemies/moblinsAndShroudedStalfos.s"
;	.include "object_code/common/enemies/arrowDarknut.s"
;	.include "object_code/common/enemies/lynel.s"
;	.include "object_code/common/enemies/bladeAndFlameTrap.s"
;	.include "object_code/common/enemies/rope.s"
;	.include "object_code/common/enemies/gibdo.s"
;	.include "object_code/common/enemies/spark.s"
;	.include "object_code/common/enemies/whisp.s"
;	.include "object_code/common/enemies/spikedBeetle.s"
;	.include "object_code/common/enemies/bubble.s"
;	.include "object_code/common/enemies/beamos.s"
;	.include "object_code/common/enemies/ghini.s"
;	.include "object_code/common/enemies/buzzblob.s"
;	.include "object_code/common/enemies/sandCrab.s"
;	.include "object_code/common/enemies/spinyBeetle.s"
;	.include "object_code/common/enemies/armos.s"
;	.include "object_code/common/enemies/piranha.s"

;	.include "object_code/ages/enemies/veranSpider.s"
;	.include "object_code/ages/enemies/eyesoarChild.s"
;	.include "object_code/common/enemies/ironMask.s"
;	.include "object_code/ages/enemies/veranChildBee.s"
;	.include "object_code/ages/enemies/enableSidescrollDownTransition.s"

.ends

m_section_superfree Enemy_Animations
	.include {"{BUILD_DIR}/enemyAnimations.s"}
.ends


.BANK $0e SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0e NAMESPACE bank0e

;	.include "object_code/common/enemies/commonCode.s"

;	.include "object_code/common/enemies/swordEnemies.s"
;	.include "object_code/common/enemies/peahat.s"
;	.include "object_code/common/enemies/wizzrobe.s"
;	.include "object_code/common/enemies/crows.s"
;	.include "object_code/common/enemies/gel.s"
;	.include "object_code/common/enemies/pincer.s"
;	.include "object_code/common/enemies/ballAndChainSoldier.s"
;	.include "object_code/common/enemies/hardhatBeetle.s"
;	.include "object_code/ages/enemies/linkMimic.s"
;	.include "object_code/common/enemies/armMimic.s"
;	.include "object_code/common/enemies/moldorm.s"
;	.include "object_code/common/enemies/fireballShooter.s"
;	.include "object_code/common/enemies/beetle.s"
;	.include "object_code/common/enemies/flyingTile.s"
;	.include "object_code/common/enemies/dragonfly.s"
;	.include "object_code/common/enemies/bushOrRock.s"
;	.include "object_code/common/enemies/itemDropProducer.s"
;	.include "object_code/common/enemies/seedsOnTree.s"
;	.include "object_code/common/enemies/twinrovaIce.s"
;	.include "object_code/common/enemies/twinrovaBat.s"
;	.include "object_code/common/enemies/ganonRevivalCutscene.s"

	.include {"{GAME_DATA_DIR}/orbMovementScript.s"}
	.include "code/objectMovementScript.s"

;	.include "object_code/ages/enemies/bari.s"
;	.include "object_code/ages/enemies/giantGhiniChild.s"
;	.include "object_code/ages/enemies/shadowHagBug.s"
;	.include "object_code/ages/enemies/colorChangingGel.s"
;	.include "object_code/ages/enemies/ambiGuard.s"
;	.include "object_code/ages/enemies/candle.s"
;	.include "object_code/ages/enemies/kingMoblinMinion.s"
;	.include "object_code/ages/enemies/veranPossessionBoss.s"
;	.include "object_code/ages/enemies/vineSprout.s"
;	.include "object_code/ages/enemies/targetCartCrystal.s"

	.include {"{GAME_DATA_DIR}/movingSidescrollPlatform.s"}

.ends

.BANK $0f SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank0f NAMESPACE bank0f

;	.include "object_code/common/enemies/commonCode.s"
;	.include "object_code/common/enemies/commonBossCode.s"
;	.include "object_code/ages/enemies/giantGhini.s"
;	.include "object_code/ages/enemies/swoop.s"
;	.include "object_code/ages/enemies/subterror.s"
;	.include "object_code/ages/enemies/armosWarrior.s"
;	.include "object_code/ages/enemies/smasher.s"
;	.include "object_code/common/enemies/vire.s"
;	.include "object_code/ages/enemies/anglerFish.s"
;	.include "object_code/ages/enemies/blueStalfos.s"

.ends

.BANK $10 SLOT 1
.ORG 0

m_section_free Enemy_Code_Bank10 NAMESPACE bank10

;	.include "object_code/common/enemies/commonCode.s"
;	.include "object_code/common/enemies/commonBossCode.s"
;
;	.include "object_code/common/enemies/mergedTwinrova.s"
;	.include "object_code/common/enemies/twinrova.s"
;	.include "object_code/common/enemies/ganon.s"
;	.include "object_code/common/enemies/none.s"

;	.include "object_code/ages/enemies/veranFinalForm.s"
;	.include "object_code/ages/enemies/ramrockArms.s"
;	.include "object_code/ages/enemies/veranFairy.s"
;	.include "object_code/ages/enemies/ramrock.s"
;	.include "object_code/ages/enemies/kingMoblinMinionMain.s"

.ends

m_section_free Interaction_Code_Group8 NAMESPACE commonInteractions8
;	.include "object_code/common/interactions/eraOrSeasonInfo.s"
;	.include "object_code/common/interactions/statueEyeball.s"
;	.include "object_code/common/interactions/ringHelpBook.s"
.ends

	.include "code/ages/cutscenes/bank10.s"

m_section_free Ages_Interactions_Bank10 NAMESPACE agesInteractionsBank10
;	.include "object_code/ages/interactions/miscellaneous2.s"
;	.include "object_code/ages/interactions/timewarp.s"
;	.include "object_code/ages/interactions/timeportal.s"
;	.include "object_code/common/interactions/nayruRalphCredits.s"
;	.include "object_code/ages/interactions/timeportalSpawner.s"
;	.include "object_code/ages/interactions/knowItAllBird.s"
;	.include "object_code/ages/interactions/raft.s"
.ends


.BANK $11 SLOT 1
.ORG 0

	.define PART_BANK $11
	.export PART_BANK

m_section_free Bank_11 NAMESPACE partCode
;	.include "object_code/common/parts/commonCode.s"

;	.include "object_code/common/parts/itemDrop.s"
;	.include "object_code/common/parts/enemyDestroyed.s"
;	.include "object_code/common/parts/orb.s"
;	.include "object_code/common/parts/bossDeathExplosion.s"
;	.include "object_code/common/parts/switch.s"
;	.include "object_code/common/parts/lightableTorch.s"
;	.include "object_code/common/parts/shadow.s"
;	.include "object_code/common/parts/darkRoomHandler.s"
;	.include "object_code/common/parts/button.s"
;	.include "object_code/common/parts/movingOrb.s"
;	.include "object_code/common/parts/bridgeSpawner.s"
;	.include "object_code/common/parts/detectionHelper.s"
;	.include "object_code/common/parts/respawnableBush.s"
;	.include "object_code/common/parts/seedOnTree.s"
;	.include "object_code/common/parts/volcanoRock.s"
;	.include "object_code/common/parts/flame.s"
;	.include "object_code/common/parts/owlStatue.s"
;	.include "object_code/common/parts/itemFromMaple.s"
;	.include "object_code/common/parts/gashaTree.s"
;	.include "object_code/common/parts/octorokProjectile.s"
;	.include "object_code/common/parts/fireProjectiles.s"
;	.include "object_code/common/parts/enemyArrow.s"
;	.include "object_code/common/parts/lynelBeam.s"
;	.include "object_code/common/parts/stalfosBone.s"
;	.include "object_code/common/parts/enemySword.s"
;	.include "object_code/common/parts/dekuScrubProjectile.s"
;	.include "object_code/common/parts/wizzrobeProjectile.s"
;	.include "object_code/common/parts/fire.s"
;	.include "object_code/common/parts/moblinBoomerang.s"
;	.include "object_code/common/parts/cuccoAttacker.s"
;	.include "object_code/common/parts/fallingFire.s"
;	.include "object_code/common/parts/lighting.s"
;	.include "object_code/common/parts/smallFairy.s"
;	.include "object_code/common/parts/beam.s"
;	.include "object_code/common/parts/spikedBall.s"
;	.include "object_code/common/parts/greatFairyHeart.s"
;	.include "object_code/common/parts/twinrovaProjectile.s"
;	.include "object_code/common/parts/twinrovaFlame.s"
;	.include "object_code/common/parts/twinrovaSnowball.s"
;	.include "object_code/common/parts/ganonTrident.s"
;	.include "object_code/common/parts/51.s"
;	.include "object_code/common/parts/52.s"
;	.include "object_code/common/parts/blueEnergyBead.s"

;	.include "code/updateParts.s"
	.include "data/partCodeTable.s"
.ends


.BANK $12 SLOT 1
.ORG 0

m_section_superfree Underwater_Surface_Data namespace underwaterSurfacing
	.include "code/ages/underwaterSurfacing.s"
	.include "data/ages/underwaterSurfaceData.s"
.ENDS

m_section_superfree Room_Code namespace roomSpecificCode
;	.include "code/ages/roomSpecificCode.s"
.ends


.BANK $13 SLOT 1
.ORG 0

	.define BASE_OAM_DATA_BANK $13
	.export BASE_OAM_DATA_BANK

	.include "data/itemOamData.s"
	.include {"{BUILD_DIR}/enemyOamData_ages.s"}
	.include {"{BUILD_DIR}/specialObjectOamData.s"}


.BANK $14 SLOT 1
.ORG 0
	.include {"{BUILD_DIR}/enemyOamData_seasons.s"}
	.include {"{GAME_DATA_DIR}/data_4556.s"}

	; TODO: "SIMPLE_SCRIPT_BANK" define should be tied to this section somehow
	 m_section_free Scripts2 NAMESPACE scripts2
;		.include "scripts/seasons/scripts2.s"
	.ends


.BANK $15 SLOT 1
.ORG 0

;	.include "code/serialFunctions.s"

;	.include "code/staticObjects.s"
	.include {"{GAME_DATA_DIR}/staticDungeonObjects.s"}

;	.include "scripts/common/scriptHelper.s"
	.include {"{GAME_DATA_DIR}/chestData.s"}
	.include {"{GAME_DATA_DIR}/treasureObjectData.s"}

	 m_section_free Bank_15_3 NAMESPACE scriptHelp
;		.include "scripts/ages/scriptHelper.s"
;		.include "scripts/seasons/scriptHelper.s"
	.ends

	.include {"{BUILD_DIR}/partAnimations.s"}

	m_section_superfree Terrain_Effects NAMESPACE terrainEffects
		.include "data/terrainEffects.s"
	.ends


.BANK $16 SLOT 1
.ORG 0
	.include {"{BUILD_DIR}/partOamData.s"}

	.include {"{BUILD_DIR}/interactionOamData_seasons.s"}

	m_section_superfree Bank16 NAMESPACE bank16
		.include {"{GAME_DATA_DIR}/endgameCutsceneOamData.s"}
	.ends

	m_section_superfree Bank16_2 NAMESPACE bank16
		.include "code/ages/d6FloorUpdateCode.s"
	.ends


.BANK $17 SLOT 1
.ORG 0
	.include {"{BUILD_DIR}/paletteData.s"}


.BANK $18 SLOT 1
.ORG 0
	.include {"{BUILD_DIR}/interactionAnimations.s"}


.BANK $19 SLOT 1
.ORG 0
	.include {"{BUILD_DIR}/interactionOamData_ages.s"}


.BANK $1a SLOT 1
.ORG 0

m_section_free Gfx_1a ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0

m_section_free Gfx_1b ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0
	.include "data/gfxDataBank1c.s"

	.include {"{GAME_DATA_DIR}/smallRoomLayoutTables.s"}
	.include {"{GAME_DATA_DIR}/largeRoomLayoutTables.s"}

	.include {"{BUILD_DIR}/ages_textData.s"}
	.include {"{BUILD_DIR}/seasons_textData.s"}

.BANK $2b SLOT 1
.ORG 0
	.REDEFINE DATA_ADDR $4000
	.REDEFINE DATA_BANK $2b
	.include {"{GAME_DATA_DIR}/roomLayoutData.s"}

.BANK $42 SLOT 1
.ORG 0
m_section_free Enemy_Code_Bank42 NAMESPACE bank42
;	.include "object_code/common/enemies/commonCode.s"
;	.include "object_code/common/enemies/commonBossCode.s"
;	.include "object_code/ages/enemies/pumpkinHead.s"
;	.include "object_code/ages/enemies/headThwomp.s"
;	.include "object_code/ages/enemies/shadowHag.s"
;	.include "object_code/ages/enemies/eyesoar.s"
;	.include "object_code/ages/enemies/smog.s"
;	.include "object_code/ages/enemies/octogon.s"
;	.include "object_code/ages/enemies/plasmarine.s"
;	.include "object_code/ages/enemies/kingMoblin.s"
.ends


m_section_free Part_Code_2 NAMESPACE partCode
;	.include "object_code/ages/parts/jabuJabusBubbles.s"
;	.include "object_code/ages/parts/grottoCrystal.s"
;	.include "object_code/ages/parts/wallArrowShooter.s"
;	.include "object_code/ages/parts/sparkle.s"
;	.include "object_code/ages/parts/timewarpAnimation.s"
;	.include "object_code/ages/parts/donkeyKongFlame.s"
;	.include "object_code/ages/parts/veranFairyProjectile.s"
;	.include "object_code/ages/parts/seaEffects.s"
;	.include "object_code/ages/parts/babyBall.s"
;	.include "object_code/ages/parts/subterrorDirt.s"
;	.include "object_code/ages/parts/rotatableSeedThing.s"
;	.include "object_code/ages/parts/ramrockSeedFormLaser.s"
;	.include "object_code/ages/parts/ramrockGloveFormArm.s"
;	.include "object_code/ages/parts/candleFlame.s"
;	.include "object_code/ages/parts/veranProjectile.s"
;	.include "object_code/ages/parts/ball.s"
;	.include "object_code/ages/parts/headThwompFireball.s"
;	.include "object_code/common/parts/vireProjectile.s"
;	.include "object_code/ages/parts/3b.s"
;	.include "object_code/ages/parts/headThwompCircularProjectile.s"
;	.include "object_code/ages/parts/blueStalfosProjectile.s"
;	.include "object_code/ages/parts/3e.s"
;	.include "object_code/ages/parts/kingMoblinBomb.s"
;	.include "object_code/ages/parts/headThwompBombDropper.s"
;	.include "object_code/ages/parts/shadowHagShadow.s"
;	.include "object_code/ages/parts/pumpkinHeadProjectile.s"
;	.include "object_code/ages/parts/plasmarineProjectile.s"
;	.include "object_code/ages/parts/tingleBalloon.s"
;	.include "object_code/ages/parts/fallingBoulderSpawner.s"
;	.include "object_code/ages/parts/seedShooterEyeStatue.s"
;	.include "object_code/ages/parts/bomb.s"
;	.include "object_code/ages/parts/octogonDepthCharge.s"
;	.include "object_code/ages/parts/bigBangBombSpawner.s"
;	.include "object_code/ages/parts/smogProjectile.s"
;	.include "object_code/ages/parts/ramrockSeedFormOrb.s"
;	.include "object_code/ages/parts/roomOfRitesFallingBoulder.s"
;	.include "object_code/ages/parts/octogonBubble.s"
;	.include "object_code/ages/parts/veranSpiderweb.s"
;	.include "object_code/ages/parts/veranAcidPool.s"
;	.include "object_code/ages/parts/veranBeeProjectile.s"
;	.include "object_code/ages/parts/blackTowerMovingFlames.s"
;	.include "object_code/ages/parts/triforceStone.s"
.ends

.BANK $43 SLOT 1
.ORG 0

m_section_free enemyCode_Bank43 NAMESPACE bank43
	.define BANK_43 $43

;	.include "object_code/common/enemies/commonCode.s"

;	.include "object_code/common/enemies/polsVoice.s"
;	.include "object_code/common/enemies/likelike.s"
;	.include "object_code/common/enemies/gopongaFlower.s"
;	.include "object_code/common/enemies/dekuScrub.s"
;	.include "object_code/common/enemies/wallmaster.s"
;	.include "object_code/common/enemies/podoboo.s"
;	.include "object_code/common/enemies/giantBladeTrap.s"
;	.include "object_code/common/enemies/cheepcheep.s"
;	.include "object_code/common/enemies/podobooTower.s"
;	.include "object_code/common/enemies/thwimp.s"
;	.include "object_code/common/enemies/thwomp.s"

;	.include "object_code/common/enemies/tektite.s"
;	.include "object_code/common/enemies/stalfos.s"
;	.include "object_code/common/enemies/keese.s"
;	.include "object_code/common/enemies/babyCucco.s"
;	.include "object_code/common/enemies/zol.s"
;	.include "object_code/common/enemies/floormaster.s"
;	.include "object_code/common/enemies/cucco.s"
;	.include "object_code/common/enemies/giantCucco.s"
;	.include "object_code/common/enemies/butterfly.s"
;	.include "object_code/common/enemies/greatFairy.s"
;	.include "object_code/common/enemies/fireKeese.s"
;	.include "object_code/common/enemies/waterTektite.s"

;	.include "object_code/ages/enemies/anglerFishBubble.s"

;	.include "code/breakableTiles.s"
	.include {"{GAME_DATA_DIR}/tile_properties/breakableTiles.s"}
.ends

m_section_free roomGfxChanges NAMESPACE roomGfxChanges
	.include "code/ages/roomGfxChanges.s"
.ends

;.include "object_code/ages/interactions/tuniNutMain.s"
;.include "object_code/ages/interactions/monkeyMain.s"
;.include "object_code/ages/interactions/rabbitMain.s"


.BANK $44 SLOT 1
.ORG 0

m_section_free Bank44 NAMESPACE bank44
.define BANK_44 $44

.include "code/loadGraphics.s"

.include "data/gfxDataIntro/triforceMovementData.s"
.include "data/gfxDataIntro/makuSeed.s"
.include "data/gfxDataIntro/pressStart.s"
.include "data/gfxDataIntro/linkOnHorse1.s"
.include "data/gfxDataIntro/linkOnHorse2.s"
.include "data/gfxDataIntro/linkOnHorse3.s"
.include "data/gfxDataIntro/templeTouchUp.s"


.include {"{GAME_DATA_DIR}/objectGfxHeaders.s"}
.include {"{GAME_DATA_DIR}/treeGfxHeaders.s"}

.include {"{BUILD_DIR}/enemyData.s"}
.include {"{BUILD_DIR}/partData.s"}
.include {"{BUILD_DIR}/interactionData.s"}
.include {"{GAME_DATA_DIR}/itemData.s"}

.include "data/ages/blackTowerOamData.s"
.include "data/ages/nayruSingingOamData.s"

.ends

.BANK $45 SLOT 1
.ORG 0

m_section_superfree bank19Code NAMESPACE bank19
	.include {"{GAME_DATA_DIR}/treasureCollectionBehaviours.s"}
	.include {"{GAME_DATA_DIR}/treasureDisplayData.s"}
	.include "code/treasureAndDrops.s"
	.include "code/textbox.s"
	.ifdef ENABLE_SETTINGS_MENU
;		.include "code/settingsMenu.s"
	.endif
;	.include "code/bank0Ext.s"
.ends


.BANK $46 SLOT 1
.ORG 0
m_section_free Object_Pointers namespace objectData
	.include "objects/ages/pointers.s"
.ends

m_section_free Object_Pointers_seasons namespace objectData_seasons
	.include "objects/seasons/pointers.s"
.ends


.BANK $48 SLOT 1
.ORG 0

m_section_free Objects_2 namespace objectData
	.include "code/objectLoading.s"
	.include "objects/ages/mainData.s"
	.include "objects/ages/enemyData.s"
	.include "objects/ages/extraData1.s"
	.include "objects/ages/extraData2.s"
	.include "objects/ages/extraData3.s"
	.include "objects/ages/extraData4.s"
.ends

.BANK $49 SLOT 1
.ORG 0
m_section_free Objects_3 namespace objectData_seasons
	.define ROM_SEASONS
	.include "code/objectLoading.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/enemyData.s"
	.include "objects/seasons/extraData1.s"
	.include "objects/seasons/extraData2.s"
	.include "objects/seasons/extraData3.s"
	.undefine ROM_SEASONS
.ends

.BANK $4a SLOT 1
.ORG 0
	.REDEFINE DATA_ADDR $4000
	.REDEFINE DATA_BANK $4a
	.include {"{GAME_DATA_DIR}/gfxDataMain.s"}


; HACK-BASE: Expanded tileset data
.include {"{GAME_DATA_DIR}/expandedTilesets.s"}
