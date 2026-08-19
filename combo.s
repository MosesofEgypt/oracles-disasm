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

	.include "code/bank0.s"

m_section_free Main_Scripts_test NAMESPACE mainScripts
script6f48:
	ret
.ends

m_section_free Bank_8_test NAMESPACE agesInteractionsBank08
shootingGallery_removeAllTargets:
shootingGallery_initializeGameRounds:
interactionOscillateXRandomly:
checkObjectIsCloseToPosition:
	ret
.ends

m_section_free Bank_9_test NAMESPACE agesInteractionsBank09
linkEnterPalaceSimulatedInput:
linkExitPalaceSimulatedInput:
checkNpcShouldExistAtGameStage_body:
	ret
.ends

m_section_free Bank_a_test NAMESPACE agesInteractionsBank0a
func_0a_7877:
	ret
.ends

m_section_free Bank_15_test NAMESPACE seasonsInteractionsBank15
checkGoldenBeastsKilled:
giveRedRing:
linkedHerosCaveOldMan_takeRupees:
linkedHerosCaveOldMan_spawnChests:
spawnRodOfSeasonsSparkles:
forceLinksDirection:
	ret
.ends

m_section_free Common_Interactions_2 NAMESPACE commonInteractions2
objectOscillateZ_body:
	ret
.ends

m_section_free Part_Code NAMESPACE partCode
createEnergySwirlGoingIn_body:
createEnergySwirlGoingOut_body:
	ret
.ends

m_section_free Seasons_Interactions_Bank08_Test NAMESPACE seasonsInteractionsBank08
checkHoronVillageNPCShouldBeSeen_body:
@main:
getSunkenCityNPCVisibleSubId:
@main:
	ret
.ends

m_section_free Seasons_Interactions_Bank0a_Test NAMESPACE seasonsInteractionsBank0a
checkGotMakuSeedDidNotSeeZeldaKidnapped_body:
moblinKeepScene_setLinkDirectionAndPositionAfterDestroyed:
moblinKeepScene_spawnKingMoblin:
moblinKeepScene_spawn2MoblinsAfterKeepDestroyed:
	ret
.ends

m_section_free Script_Help NAMESPACE scriptHelp
makuTree_setMapTextBasedOnStage:
	ret
.ends	; NOTE: TEMPORARY UNTIL MANY BANKS CAN BE MERGED


.BANK $01 SLOT 1
.ORG 0

	.include "code/bank1.s"


.BANK $02 SLOT 1
.ORG 0
	.include "code/bank2.s"
	.include "code/roomInitialization.s"


.BANK $03 SLOT 1
.ORG 0
	.include "code/bank3.s"


.BANK $04 SLOT 1
.ORG 0
	.include "code/bank4.s"
	 m_section_free Warp_Data NAMESPACE bank4
		.include {"{GAME_DATA_DIR}/warpDestinations.s"}
		.include {"{GAME_DATA_DIR}/warpSources.s"}
	.ends

.BANK $14 SLOT 1
.ORG 0

	 m_section_free Scripts2 NAMESPACE scripts2
;		.include "scripts/seasons/scripts2.s"
	.ends


.BANK $15 SLOT 1
.ORG 0

	.include "code/staticObjects.s"
	.include {"{GAME_DATA_DIR}/staticDungeonObjects.s"}

;	.include "scripts/common/scriptHelper.s"

	 m_section_free Bank_15_3 NAMESPACE scriptHelp
;		.include "scripts/ages/scriptHelper.s"
;		.include "scripts/seasons/scriptHelper.s"
	.ends


.BANK $1a SLOT 1
.ORG 0
; NOTE: links gfx must lie in bank $1a.
;       TODO: dehardcode this
m_section_free Gfx_1a ALIGN $20
	.include "data/gfxDataBank1a.s"
.ends


.BANK $1b SLOT 1
.ORG 0
; NOTE: companions gfx must lie in bank $1b.
;       TODO: dehardcode this
m_section_free Gfx_1b ALIGN $20
	.include "data/gfxDataBank1b.s"
.ends


.BANK $1c SLOT 1
.ORG 0

m_section_free Gfx_1c ALIGN $20
	.include "data/gfxDataBank1c.s"
.ends


; NOTE: These includes define their own .bank and .orga
.include {"{BUILD_DIR}/ages_textData.s"}
.include {"{BUILD_DIR}/seasons_textData.s"}


.BANK $2b SLOT 1
.ORG 0
	.REDEFINE DATA_ADDR $4000
	.REDEFINE DATA_BANK $2b
	.include {"{GAME_DATA_DIR}/roomLayoutData.s"}


.BANK $4a SLOT 1
.ORG 0
	.REDEFINE DATA_ADDR $4000
	.REDEFINE DATA_BANK $4a
	.include {"{GAME_DATA_DIR}/gfxDataMain.s"}


; HACK-BASE: Expanded tileset data
.include {"{GAME_DATA_DIR}/expandedTilesets.s"}


; #################################################################################
; NOTE: All sections below here are superfree
; #################################################################################


m_section_superfree Bank_5 NAMESPACE bank5
	.define SKIP_COMPANION_COMMON_CODE
	.include "code/specialObjects.s"
	.undefine SKIP_COMPANION_COMMON_CODE

	.include {"{GAME_DATA_DIR}/tile_properties/tileTypeMappings.s"}
	.include {"{GAME_DATA_DIR}/tile_properties/cliffTiles.s"}
.ends

m_section_superfree Bank_5_Ext NAMESPACE bank5Ext
	.define SKIP_LINK_COMMON_CODE
	.include "object_code/common/specialObjects/commonCode.s"
	.undefine SKIP_LINK_COMMON_CODE

	.include "object_code/common/specialObjects/maple.s"
	.include "object_code/common/specialObjects/ricky.s"
	.include "object_code/common/specialObjects/dimitri.s"
	.include "object_code/common/specialObjects/moosh.s"

	.include {"{GAME_DATA_DIR}/tile_properties/tileTypeMappings.s"}
	.include {"{GAME_DATA_DIR}/tile_properties/cliffTiles.s"}
.ends

m_section_superfree Bank_6 NAMESPACE bank6
	.include "code/interactableTiles.s"
	.include {"{GAME_DATA_DIR}/signText.s"}

	.include "code/specialObjectAnimationsAndDamage.s"

	.include {"{BUILD_DIR}/specialObjectAnimationData.s"}
	.include "object_code/ages/specialObjects/linkInCutscene.s"
	.include "object_code/seasons/specialObjects/linkInCutscene.s"

	.include "object_code/ages/specialObjects/timeWarp.s"
.ends

m_section_superfree Bank_6_Ext NAMESPACE bank6Ext
	.include "object_code/ages/specialObjects/companionCutscene.s"
	.include "object_code/seasons/specialObjects/companionCutscene.s"
	.include "object_code/common/specialObjects/minecart.s"
	.include "object_code/ages/specialObjects/raft.s"
	.include {"{BUILD_DIR}/specialObjectAnimationData.s"}
.ends

m_section_superfree Interaction_Code_Group1 NAMESPACE commonInteractions1
;	.include "object_code/common/interactions/treasure.s"
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

m_section_superfree Interaction_Code_Group2 NAMESPACE commonInteractions2
;	.include "object_code/common/interactions/shopkeeper.s"
;	.include "object_code/common/interactions/shopItem.s"
	.include "object_code/common/interactions/introSprites1.s"
;	.include "object_code/common/interactions/seasonsFairy.s"
;	.include "object_code/common/interactions/explosion.s"
.ends

m_section_superfree Interaction_Code_Group3 NAMESPACE commonInteractions3
;	.include "object_code/common/interactions/bombFlower.s"
;	.include "object_code/common/interactions/switchTileToggler.s"
;	.include "object_code/common/interactions/movingPlatform.s"
;	.include "object_code/common/interactions/roller.s"
;	.include "object_code/common/interactions/spinner.s"
;	.include "object_code/common/interactions/minibossPortal.s"
;	.include "object_code/common/interactions/essence.s"
.ends

m_section_superfree Interaction_Code_Group4 NAMESPACE commonInteractions4
;	.include "object_code/common/interactions/vasu.s"
;	.include "object_code/common/interactions/bubble.s"
.ends

m_section_superfree Interaction_Code_Group5 NAMESPACE commonInteractions5
;	.include "object_code/common/interactions/woodenTunnel.s"
	.include "object_code/common/interactions/exclamationMark.s"
;	.include "object_code/common/interactions/floatingImage.s"
	.include "object_code/common/interactions/bipinBlossomFamilySpawner.s"
;	.include "object_code/common/interactions/gashaSpot.s"
;	.include "object_code/common/interactions/kissHeart.s"
;	.include "object_code/common/interactions/banana.s"
;	.include "object_code/common/interactions/createObjectAtEachTileindex.s"
.ends

m_section_superfree Interaction_Code_Group6 NAMESPACE commonInteractions6
;	.include "object_code/common/interactions/businessScrub.s"
;	.include "object_code/common/interactions/cf.s"
;	.include "object_code/common/interactions/companionTutorial.s"
;	.include "object_code/common/interactions/gameCompleteDialog.s"
	.include "object_code/common/interactions/titlescreenClouds.s"
	.include "object_code/common/interactions/introBird.s"
;	.include "object_code/common/interactions/linkShip.s"
.ends

m_section_superfree Interaction_Code_Group7 NAMESPACE commonInteractions7
;	.include "object_code/common/interactions/faroreGiveItem.s"
;	.include "object_code/common/interactions/zeldaApproachTrigger.s"
.ends

m_section_superfree Interaction_Code_Group8 NAMESPACE commonInteractions8
;	.include "object_code/common/interactions/eraOrSeasonInfo.s"
;	.include "object_code/common/interactions/statueEyeball.s"
;	.include "object_code/common/interactions/ringHelpBook.s"
.ends

m_section_superfree Ages_Interactions_Bank8 NAMESPACE agesInteractionsBank08
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

m_section_superfree Ages_Interactions_Bank9 NAMESPACE agesInteractionsBank09
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

m_section_superfree Ages_Interactions_BankA NAMESPACE agesInteractionsBank0a
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
	.include "object_code/ages/interactions/introSprite.s"
;	.include "object_code/ages/interactions/makuGateOpening.s"
;	.include "object_code/ages/interactions/smallKeyOnEnemy.s"
;	.include "object_code/ages/interactions/stonePanel.s"
;	.include "object_code/ages/interactions/screenDistortion.s"
;	.include "object_code/ages/interactions/decoration.s"
;	.include "object_code/ages/interactions/tokayShopItem.s"
;	.include "object_code/ages/interactions/sarcophagus.s"
;	.include "object_code/ages/interactions/bombUpgradeFairy.s"
	.include "object_code/ages/interactions/sparkle.s"
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

m_section_superfree Ages_Interactions_Bank0b NAMESPACE agesInteractionsBank0b
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

m_section_superfree Ages_Interactions_Bank10 NAMESPACE agesInteractionsBank10
;	.include "object_code/ages/interactions/miscellaneous2.s"
;	.include "object_code/ages/interactions/timewarp.s"
;	.include "object_code/ages/interactions/timeportal.s"
;	.include "object_code/common/interactions/nayruRalphCredits.s"
;	.include "object_code/ages/interactions/timeportalSpawner.s"
;	.include "object_code/ages/interactions/knowItAllBird.s"
;	.include "object_code/ages/interactions/raft.s"
.ends

m_section_superfree Ages_Interactions_Bank11 NAMESPACE agesInteractionsBank11
;	.include "object_code/ages/interactions/tuniNutMain.s"
;	.include "object_code/ages/interactions/monkeyMain.s"
;	.include "object_code/ages/interactions/rabbitMain.s"
.ends

m_section_superfree Seasons_Interactions_Bank08 NAMESPACE seasonsInteractionsBank08
;	.include "object_code/seasons/interactions/usedRodOfSeasons.s"
;	.include "object_code/seasons/interactions/specialWarp.s"
;	.include "object_code/seasons/interactions/dungeonScript.s"
;	.include "object_code/seasons/interactions/gnarledKeyhole.s"
;	.include "object_code/seasons/interactions/makuCutscenes.s"
;	.include "object_code/seasons/interactions/seasonSpiritsScripts.s"
;	.include "object_code/seasons/interactions/miscNpcs.s"
;	.include "object_code/seasons/interactions/mittensAndOwner.s"
;	.include "object_code/seasons/interactions/sokra.s"
;	.include "object_code/common/interactions/bipin.s"
;	.include "object_code/seasons/interactions/bird.s"
;	.include "object_code/common/interactions/blossom.s"
;	.include "object_code/seasons/interactions/fickleGirl.s"
;	.include "object_code/seasons/interactions/subrosian.s"
;	.include "object_code/seasons/interactions/datingRosaEvent.s"
;	.include "object_code/seasons/interactions/subrosianWithBuckets.s"
;	.include "object_code/seasons/interactions/subrosianSmiths.s"
;	.include "object_code/common/interactions/child.s"
;	.include "object_code/seasons/interactions/goron.s"
;	.include "object_code/seasons/interactions/miscBoyNpcs.s"
;	.include "object_code/seasons/interactions/piratian.s"
;	.include "object_code/seasons/interactions/pirateHouseSubrosian.s"
;	.include "object_code/common/interactions/syrup.s"
;	.include "object_code/seasons/interactions/zelda.s"
;	.include "object_code/seasons/interactions/talon.s"
;	.include "object_code/seasons/interactions/makuLeaf.s"
;	.include "object_code/common/interactions/syrupCucco.s"
;	.include "object_code/seasons/interactions/d1RisingStones.s"
;	.include "object_code/seasons/interactions/miscStatusObjects.s"
;	.include "object_code/seasons/interactions/pirateSkull.s"
;	.include "object_code/seasons/interactions/dinDancingEvent.s"
;	.include "object_code/seasons/interactions/dinImprisonedEvent.s"
;	.include "object_code/seasons/interactions/smallVolcano.s"
;	.include "object_code/seasons/interactions/biggoron.s"
;	.include "object_code/seasons/interactions/headSmelter.s"
;	.include "object_code/seasons/interactions/subrosianAtD8Items.s"
;	.include "object_code/seasons/interactions/subrosianAtD8.s"
;	.include "object_code/seasons/interactions/ingo.s"
;	.include "object_code/seasons/interactions/guruguru.s"
;	.include "object_code/seasons/interactions/lostWoodsSword.s"
;	.include "object_code/seasons/interactions/blainoScript.s"
;	.include "object_code/seasons/interactions/lostWoodsDekuScrub.s"
;	.include "object_code/seasons/interactions/lavaSoupSubrosian.s"
;	.include "object_code/seasons/interactions/tradeItem.s"
.ends

m_section_superfree Seasons_Interactions_Bank09 NAMESPACE seasonsInteractionsBank09
;	.include "object_code/seasons/interactions/quicksand.s"
;	.include "object_code/common/interactions/companionSpawner.s"
;	.include "object_code/seasons/interactions/unicornsCave4ChestPuzzle.s"
;	.include "object_code/seasons/interactions/unicornsCaveReverseMovingArmos.s"
;	.include "object_code/seasons/interactions/unicornsCaveFallingMagnetBall.s"
	.include "object_code/seasons/interactions/65.s"
;	.include "object_code/seasons/interactions/explorersCrypt4ArmosButtonPuzzle.s"
;	.include "object_code/seasons/interactions/swordShieldMazeArmosPatternPuzzle.s"
;	.include "object_code/seasons/interactions/swordShieldMazeGrabbableIce.s"
;	.include "object_code/seasons/interactions/swordShieldMazeFreezingLavaEvent.s"
;	.include "object_code/seasons/interactions/danceHallMinigame.s"
;	.include "object_code/seasons/interactions/miscellaneous1.s"
;	.include "object_code/seasons/interactions/subrosiansHiding.s"
;	.include "object_code/seasons/interactions/stealingFeather.s"
;	.include "object_code/seasons/interactions/holly.s"
;	.include "object_code/seasons/interactions/companionScripts.s"
;	.include "object_code/seasons/interactions/blaino.s"
;	.include "object_code/seasons/interactions/animalMoblinBullies.s"
	.include "object_code/seasons/interactions/74.s"
	.include "object_code/seasons/interactions/75.s"
;	.include "object_code/seasons/interactions/sunkenCityBullies.s"
	.include "object_code/seasons/interactions/77.s"
;	.include "object_code/seasons/interactions/magnetSpinner.s"
;	.include "object_code/seasons/interactions/trampoline.s"
;	.include "object_code/seasons/interactions/fickleOldMan.s"
;	.include "object_code/seasons/interactions/subrosianShop.s"
;	.include "object_code/seasons/interactions/horonDog.s"
;	.include "object_code/seasons/interactions/ballThrownToDog.s"
	.include "object_code/seasons/interactions/sparkle.s"
;	.include "object_code/seasons/interactions/introSceneMusic.s"
;	.include "object_code/seasons/interactions/templeSinkingExplosion.s"
;	.include "object_code/seasons/interactions/makuTree.s"
;	.include "object_code/seasons/interactions/88.s"

makuTree_setAppropriateStage:
	ret
.ends

m_section_superfree Seasons_Interactions_Bank0a NAMESPACE seasonsInteractionsBank0a
;	.include "object_code/seasons/interactions/sunkenCityNpcs.s"
;	.include "object_code/seasons/interactions/flyingRooster.s"
;	.include "object_code/seasons/interactions/8e.s"
;	.include "object_code/seasons/interactions/oldManWithJewel.s"
;	.include "object_code/seasons/interactions/jewelHelper.s"
;	.include "object_code/seasons/interactions/jewel.s"
;	.include "object_code/seasons/interactions/makuSeed.s"
;	.include "object_code/seasons/interactions/ghastlyDoll.s"
;	.include "object_code/seasons/interactions/kingMoblin.s"
;	.include "object_code/seasons/interactions/moblin.s"
;	.include "object_code/seasons/interactions/97.s"
;	.include "object_code/seasons/interactions/oldManWithRupees.s"
;	.include "object_code/seasons/interactions/9a.s"
;	.include "object_code/seasons/interactions/9b.s"
;	.include "object_code/seasons/interactions/springBloomFlower.s"
;	.include "object_code/seasons/interactions/impa.s"
;	.include "object_code/seasons/interactions/samasaDesertGate.s"
;	.include "object_code/common/interactions/movingSidescrollPlatform.s"
;	.include "object_code/common/interactions/movingSidescrollConveyor.s"
;	.include "object_code/seasons/interactions/disappearingSidescrollPlatform.s"
;	.include "object_code/seasons/interactions/subrosianSmithy.s"
;	.include "object_code/seasons/interactions/din.s"
;	.include "object_code/seasons/interactions/dinsCrystalFading.s"
;	.include "object_code/common/interactions/endgameCutsceneBipsomFamily.s"
;	.include "object_code/seasons/interactions/a8.s"
;	.include "object_code/seasons/interactions/a9.s"
;	.include "object_code/seasons/interactions/aa.s"
;	.include "object_code/seasons/interactions/moblinKeepScenes.s"
;	.include "object_code/seasons/interactions/ad.s"
;	.include "object_code/common/interactions/creditsTextHorizontal.s"
;	.include "object_code/common/interactions/creditsTextVertical.s"
;	.include "object_code/common/interactions/twinrovaFlame.s"
;	.include "object_code/seasons/interactions/shipPiratian.s"
;	.include "object_code/seasons/interactions/linkedCutscene.s"
;	.include "object_code/seasons/interactions/b4.s"
;	.include "object_code/common/interactions/finalDungeonEnergy.s"
;	.include "object_code/seasons/interactions/ambi.s"
;	.include "object_code/common/interactions/horonDogCredits.s"
;	.include "object_code/seasons/interactions/ba.s"
;	.include "object_code/seasons/interactions/bb.s"
;	.include "object_code/seasons/interactions/bc_bd_be.s"
;	.include "object_code/seasons/interactions/bf.s"
;	.include "object_code/common/interactions/c1.s"
;	.include "object_code/seasons/interactions/mayorsHouseUnlinkedGirl.s"
;	.include "object_code/seasons/interactions/zeldaKidnappedRoom.s"
;	.include "object_code/seasons/interactions/zeldaVillagersRoom.s"
;	.include "object_code/seasons/interactions/d4HolesFloortrapRoom.s"
;	.include "object_code/seasons/interactions/herosCaveSwordChest.s"
.ends

m_section_superfree Seasons_Interactions_Bank0f NAMESPACE seasonsInteractionsBank0f
;	.include "object_code/seasons/interactions/boomerangSubrosian.s"
;	.include "object_code/seasons/interactions/boomerang.s"
;	.include "object_code/seasons/interactions/troy.s"
;	.include "object_code/seasons/interactions/linkedGameGhini.s"
;	.include "object_code/seasons/interactions/goldenCaveSubrosian.s"
;	.include "object_code/seasons/interactions/linkedMasterDiver.s"
;	.include "object_code/seasons/interactions/greatFairy.s"
;	.include "object_code/seasons/interactions/dekuScrub.s"
;	.include "object_code/seasons/interactions/d7.s"
.ends

m_section_superfree Seasons_Interactions_Bank15 NAMESPACE seasonsInteractionsBank15
;	.include "object_code/seasons/interactions/linkedFountainLady.s"
;	.include "object_code/seasons/interactions/linkedSecredGivers.s"
;	.include "object_code/seasons/interactions/miscPuzzles.s"
;	.include "object_code/seasons/interactions/goldenBeastOldMan.s"
;	.include "object_code/seasons/interactions/makuSeedAndEssences.s"
;	.include "object_code/common/interactions/nayruRalphCredits.s"
;	.include "object_code/seasons/interactions/portalSpawner.s"
;	.include "object_code/seasons/interactions/vire.s"
;	.include "object_code/seasons/interactions/linkedHerosCaveOldMan.s"
;	.include "object_code/seasons/interactions/getRodOfSeasons.s"
;	.include "object_code/seasons/interactions/loneZora.s"
.ends

m_section_superfree Enemy_Code_Bank_1 NAMESPACE enemyCode1
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

;	.include "object_code/seasons/enemies/magunesu.s"
;	.include "object_code/seasons/enemies/unusedTemplate.s"
;	.include "object_code/seasons/enemies/gohmaGel.s"
;	.include "object_code/seasons/enemies/mothulaChild.s"
;	.include "object_code/seasons/enemies/blaino.s"
;	.include "object_code/seasons/enemies/miniDigdogger.s"
;	.include "object_code/seasons/enemies/makuTreeBubble.s"
;	.include "object_code/seasons/enemies/sandPuff.s"
;	.include "object_code/seasons/enemies/wallFlameShooter.s"
;	.include "object_code/seasons/enemies/blainosGloves.s"

.ends

m_section_superfree Enemy_Code_Bank_2 NAMESPACE enemyCode2
	.include "object_code/common/enemies/commonCode.s"

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

m_section_superfree enemyCode_Bank3e NAMESPACE bank3e
	.include "object_code/common/enemies/commonCode.s"

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
.ends

m_section_superfree Boss_Code_Bank_1 NAMESPACE bossCode1
	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

;	.include "object_code/ages/enemies/giantGhini.s"
;	.include "object_code/ages/enemies/swoop.s"
;	.include "object_code/ages/enemies/subterror.s"
;	.include "object_code/ages/enemies/armosWarrior.s"
;	.include "object_code/ages/enemies/smasher.s"
;	.include "object_code/common/enemies/vire.s"
;	.include "object_code/ages/enemies/anglerFish.s"
;	.include "object_code/ages/enemies/blueStalfos.s"

.ends

m_section_superfree Boss_Code_Bank_2 NAMESPACE bossCode2
	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

;	.include "object_code/seasons/enemies/brotherGoriyas.s"
;	.include "object_code/seasons/enemies/facade.s"
;	.include "object_code/seasons/enemies/omuai.s"
;	.include "object_code/seasons/enemies/agunima.s"
;	.include "object_code/seasons/enemies/syger.s"
;	.include "object_code/common/enemies/vire.s"
;	.include "object_code/seasons/enemies/poeSister2.s"
;	.include "object_code/seasons/enemies/poeSister1.s"
;	.include "object_code/seasons/enemies/frypolar.s"
;	.include "object_code/seasons/enemies/aquamentus.s"
;	.include "object_code/seasons/enemies/dodongo.s"
;	.include "object_code/seasons/enemies/mothula.s"
;	.include "object_code/seasons/enemies/gohma.s"
;	.include "object_code/seasons/enemies/digdogger.s"
;	.include "object_code/seasons/enemies/manhandla.s"
;	.include "object_code/seasons/enemies/medusaHead.s"

.ends

m_section_superfree Boss_Code_Bank_3 NAMESPACE bossCode3
	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

;	.include "object_code/ages/enemies/pumpkinHead.s"
;	.include "object_code/ages/enemies/headThwomp.s"
;	.include "object_code/ages/enemies/shadowHag.s"
;	.include "object_code/ages/enemies/eyesoar.s"
;	.include "object_code/ages/enemies/smog.s"
;	.include "object_code/ages/enemies/octogon.s"
;	.include "object_code/ages/enemies/plasmarine.s"
;	.include "object_code/ages/enemies/kingMoblin.s"
.ends

m_section_superfree Boss_Code_Bank_4 NAMESPACE bossCode4
	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"
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

m_section_superfree Boss_Code_Bank_5 NAMESPACE bossCode5
	.include "object_code/common/enemies/commonCode.s"
	.include "object_code/common/enemies/commonBossCode.s"

;	.include "object_code/seasons/enemies/generalOnox.s"
;	.include "object_code/seasons/enemies/dragonOnox.s"
;	.include "object_code/seasons/enemies/gleeok.s"
;	.include "object_code/seasons/enemies/kingMoblin.s"
.ends

m_section_superfree Part_Code_Bank_1 NAMESPACE partCode1
	.include "object_code/common/parts/commonCode.s"

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
.ends

m_section_superfree Part_Code_Bank_2 NAMESPACE partCode2
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

m_section_superfree Part_Code_Bank_3 NAMESPACE partCode3
	.include "object_code/common/parts/commonCode.s"

;	.include "object_code/seasons/parts/holesFloortrap.s"
;	.include "object_code/seasons/parts/slingshotEyeStatue.s"
;	.include "object_code/seasons/parts/16.s"
;	.include "object_code/seasons/parts/shootingDragonHead.s"
;	.include "object_code/seasons/parts/arrowShooter.s"
;	.include "object_code/seasons/parts/wallFlameShooterFlames.s"
;	.include "object_code/seasons/parts/buriedMoldorm.s"
;	.include "object_code/seasons/parts/kingMoblinsCannons.s"
;	.include "object_code/seasons/parts/2e.s"
;	.include "object_code/seasons/parts/2f.s"
;	.include "object_code/seasons/parts/poppableBubble.s"
;	.include "object_code/seasons/parts/33.s"
;	.include "object_code/seasons/parts/38.s"
;	.include "object_code/seasons/parts/39.s"
;	.include "object_code/seasons/parts/3b.s"
;	.include "object_code/seasons/parts/poeSisterFlame.s"
;	.include "object_code/seasons/parts/3d.s"
;	.include "object_code/seasons/parts/3e.s"
;	.include "object_code/seasons/parts/kingMoblinBomb.s"
;	.include "object_code/seasons/parts/aquamentusProjectile.s"
;	.include "object_code/seasons/parts/dodongoFireball.s"
;	.include "object_code/seasons/parts/mothulaProjectile2.s"
;	.include "object_code/seasons/parts/43.s"
;	.include "object_code/seasons/parts/44.s"
;	.include "object_code/seasons/parts/45.s"
;	.include "object_code/seasons/parts/46.s"
;	.include "object_code/seasons/parts/47.s"
;	.include "object_code/seasons/parts/48.s"
;	.include "object_code/seasons/parts/49.s"
;	.include "object_code/seasons/parts/4a.s"
;	.include "object_code/seasons/parts/dinCrystal.s"
.ends

m_section_superfree Terrain_Effects NAMESPACE terrainEffects
	.include "data/terrainEffects.s"
	.include "code/terrainEffects.s"
.ends

m_section_superfree Object_Movement namespace objectMovement
	.include {"{GAME_DATA_DIR}/orbMovementScript.s"}
	.include "code/objectMovementScript.s"
.ends

m_section_superfree Bank16_2 NAMESPACE bank16
	.include "code/ages/d6FloorUpdateCode.s"
.ends

m_section_superfree Underwater_Surface_Data namespace underwaterSurfacing
	.include "code/ages/underwaterSurfacing.s"
	.include "data/ages/underwaterSurfaceData.s"
.ENDS

m_section_superfree Room_Code namespace roomSpecificCode
	.include "code/ages/roomSpecificCode.s"
.ends

m_section_superfree bank19Code NAMESPACE bank19
	.include {"{GAME_DATA_DIR}/treasureCollectionBehaviours.s"}
	.include {"{GAME_DATA_DIR}/treasureDisplayData.s"}
	.include "code/treasureAndDrops.s"
	.include "code/textbox.s"
.ends

m_section_superfree roomGfxChanges NAMESPACE roomGfxChanges
	.include "code/roomGfxChanges.s"
	.include "code/ages/roomGfxChanges.s"
	.include "code/seasons/roomGfxChanges.s"
.ends

m_section_superfree Menu_Code_2 NAMESPACE menuCode2
	.include "code/menu_code/ringMenu.s"
	.include "code/menu_code/fakeResetMenu.s"
	.include "code/menu_code/saveAndQuitMenu.s"
	.ifdef ENABLE_SETTINGS_MENU
		.include "code/menu_code/settingsMenu.s"
	.endif
.ends

m_section_superfree File_Management namespace fileManagement
	.include "code/fileManagement.s"
.ends

m_section_superfree Bank_7_Data namespace bank7
	.include "code/collisionEffects.s"
	.include {"{GAME_DATA_DIR}/enemyActiveCollisions.s"}
	.include {"{GAME_DATA_DIR}/partActiveCollisions.s"}
	.include {"{BUILD_DIR}/objectCollisionTable.s"}
.ends

m_section_superfree Update_Interactions NAMESPACE objectUpdating
	.include "code/combo/updateInteractions.s"

	.include "code/standardPartUpdate.s"
	.include "code/updateParts.s"
	.include "data/partCodeTable.s"
.ends

m_section_superfree Bank_3_Cutscenes NAMESPACE bank3Cutscenes
	.include "code/bank3Cutscenes.s"
	.include "code/ages/cutscenes/bank10.s"
	.include "code/ages/cutscenes/endgameCutscenes.s"
	.include "code/seasons/cutscenes/endgameCutscenes.s"
	.include {"{GAME_DATA_DIR}/endgameCutsceneOamData.s"}
.ends

m_section_superfree Bank_3_Cutscenes_2 NAMESPACE bank3Cutscenes_2
	.include "code/seasons/cutscenes/pirateShipDeparting.s"
	.include "code/seasons/cutscenes/volcanoErupting.s"
	.include "code/seasons/cutscenes/linkedGameCutscenes.s"
	.include "code/seasons/cutscenes/introCutscenes.s"
	.include "code/combo/bank3CutscenesUtil.s"
.ends

m_section_superfree Bank_3_Cutscenes_3 NAMESPACE bank3Cutscenes_3
	.include "code/ages/cutscenes/miscCutscenes.s"
	.include "code/combo/bank3CutscenesUtil.s"
.ends

m_section_superfree Bank_3_Cutscenes_ages NAMESPACE bank3Cutscenes_ages
	.include "code/ages/cutscenes.s"
	.include "code/ages/cutscenes2.s"
	.include "code/ages/cutscenes/miscCutscenes2.s"
	.include "code/ages/cutscenes/blackTowerEscapeAttempt.s"
.ends

m_section_superfree Bank_3_Cutscenes_seasons NAMESPACE bank3Cutscenes_seasons
	.include "code/seasons/cutscenes.s"
	.include "code/seasons/onoxCastleEssenceCutscene.s"
	.include "code/seasons/cutscenes/fallIntoDragonOnoxArena.s"
	.include "code/seasons/cutscenes/transitionToDragonOnox.s"
.ends

m_section_superfree Gfx_Loading_Bank NAMESPACE gfxLoading
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

m_section_superfree Objects_2 namespace objectData
	.include "code/objectLoading.s"
	.include "objects/ages/mainData.s"
	.include "objects/ages/enemyData.s"
	.include "objects/ages/extraData1.s"
	.include "objects/ages/extraData2.s"
	.include "objects/ages/extraData3.s"
	.include "objects/ages/extraData4.s"
.ends

m_section_superfree Objects_3 namespace objectData_seasons
	.define ROM_SEASONS
	.include "code/objectLoading.s"
	.include "objects/seasons/mainData.s"
	.include "objects/seasons/enemyData.s"
	.include "objects/seasons/extraData1.s"
	.include "objects/seasons/extraData2.s"
	.include "objects/seasons/extraData3.s"
	.undefine ROM_SEASONS
.ends

m_section_superfree Item_OAM_Data
	_sectionStart:
	.define AGES_ITEM_OAM_DATA_BANK			:_sectionStart EXPORT
	.define SEASONS_ITEM_OAM_DATA_BANK		:_sectionStart EXPORT
	.include "data/itemOamData.s"
.ends

m_section_superfree Part_OAM_Data
	_sectionStart:
	.define AGES_PART_OAM_DATA_BANK			:_sectionStart EXPORT
	.define SEASONS_PART_OAM_DATA_BANK		:_sectionStart EXPORT
	.include {"{BUILD_DIR}/partOamData.s"}
.ends

m_section_superfree Special_Object_OAM_Data
	_sectionStart:
	.define AGES_SPEC_OBJ_OAM_DATA_BANK		:_sectionStart EXPORT
	.define SEASONS_SPEC_OBJ_OAM_DATA_BANK	:_sectionStart EXPORT
	.include {"{BUILD_DIR}/specialObjectOamData.s"}
.ends

m_section_superfree Enemy_OAM_Data_Ages
	_sectionStart:
	.define AGES_ENEMY_OAM_DATA_BANK		:_sectionStart EXPORT
	.include {"{BUILD_DIR}/enemyOamData_ages.s"}
.ends

m_section_superfree Enemy_OAM_Data_Seasons
	_sectionStart:
	.define SEASONS_ENEMY_OAM_DATA_BANK		:_sectionStart EXPORT
	.include {"{BUILD_DIR}/enemyOamData_seasons.s"}
.ends

m_section_superfree Interaction_OAM_Data_Ages
	_sectionStart:
	.define AGES_INTERAC_OAM_DATA_BANK		:_sectionStart EXPORT
	.include {"{BUILD_DIR}/interactionOamData_ages.s"}
.ends

m_section_superfree Interaction_OAM_Data_Seasons
	_sectionStart:
	.define SEASONS_INTERAC_OAM_DATA_BANK	:_sectionStart EXPORT
	.include {"{BUILD_DIR}/interactionOamData_seasons.s"}
.ends

m_section_superfree Enemy_Animations
	.include {"{BUILD_DIR}/enemyAnimations.s"}
.ends

m_section_superfree Interaction_Animations
	.include {"{BUILD_DIR}/interactionAnimations.s"}
.ends

m_section_superfree Part_Animations
	.include {"{BUILD_DIR}/partAnimations.s"}
.ends

m_section_superfree Palette_Data
	.include {"{BUILD_DIR}/paletteData.s"}
.ends

m_section_superfree RoomPacksAndMusicAssignments NAMESPACE bank4Data1
	; These 2 includes must be in the same bank
	.include {"{GAME_DATA_DIR}/roomPacks.s"}
	.include {"{GAME_DATA_DIR}/musicAssignments.s"}
.ends

m_section_superfree RoomLayouts NAMESPACE roomLayouts
	.include {"{GAME_DATA_DIR}/roomLayoutGroupTable.s"}
.ends

m_section_superfree animationAndUniqueGfxData NAMESPACE animationAndUniqueGfxData
	.include "code/animations.s"

	.include {"{GAME_DATA_DIR}/uniqueGfxHeaders.s"}
	.include {"{BUILD_DIR}/animationGroups.s"}
	.include {"{GAME_DATA_DIR}/animationGfxHeaders.s"}
	.include {"{BUILD_DIR}/animationData.s"}
.ends

m_section_superfree roomTileChanges NAMESPACE roomTileChanges
	.include "code/combo/tileSubstitutions.s"
	.include {"{GAME_DATA_DIR}/singleTileChanges.s"}
	.include "code/combo/roomSpecificTileChanges.s"
.ends

m_section_superfree Tileset_Loading NAMESPACE tilesets
	.include {"{GAME_DATA_DIR}/tilesets.s"}
	.include {"{GAME_DATA_DIR}/tilesetAssignments.s"}
	.include "code/loadTilesToRam.s"
	.include "code/ages/loadTilesetData.s"
	.include "code/seasons/loadTilesetData.s"
.ends

m_section_superfree Treasure_Data NAMESPACE treasureData
	.include "code/loadTreasureData.s"
	.include {"{GAME_DATA_DIR}/treasureObjectData.s"}
.ends

m_section_superfree chestData NAMESPACE chestData
	.include {"{GAME_DATA_DIR}/chestData.s"}
.ends

m_section_superfree serialCode NAMESPACE serialCode
	.include "code/serialFunctions.s"
.ends

m_section_superfree Scripts namespace mainScripts
	.include "code/scripting.s"
;	.include {"{BUILD_DIR}/scripts.s"}

; NOTE: TEMPORARY CODE UNTIL ALL SCRIPTS CAN BE INCLUDED
	stubScript:
	genericNpcScript:
		scriptend
; NOTE: TEMPORARY CODE UNTIL ALL SCRIPTS CAN BE INCLUDED
.ends

m_section_superfree Breakable_Tiles NAMESPACE breakableTiles
	.include "code/breakableTiles.s"
	.include {"{GAME_DATA_DIR}/tile_properties/breakableTiles.s"}
.ends

m_section_superfree Object_Pointers namespace objectData
	.include "code/ages/objectData.s"
	.include "objects/ages/pointers.s"
.ends

m_section_superfree Object_Pointers_seasons namespace objectData_seasons
	.include "code/ages/objectData.s"
	.include "objects/seasons/pointers.s"
.ends

m_section_superfree Room_Layout_Tables
	.include {"{GAME_DATA_DIR}/smallRoomLayoutTables.s"}
	.include {"{GAME_DATA_DIR}/largeRoomLayoutTables.s"}
.ends

m_section_superfree Data_4556
	.include {"{GAME_DATA_DIR}/data_4556.s"}
.ends

m_section_superfree Item_Parents NAMESPACE itemParents
	; NOTE: these are needed in here as well due to them relying
	;       on several animation related function for link in here
	.include "code/specialObjectAnimationsAndDamage.s"
	.include {"{BUILD_DIR}/specialObjectAnimationData.s"}

	.include "code/parentItemUsage.s"

	.include "object_code/common/itemParents/shieldParent.s"
	.include "object_code/common/itemParents/otherSwordsParent.s"
	.include "object_code/common/itemParents/switchHookParent.s"
	.include "object_code/common/itemParents/caneOfSomariaParent.s"
	.include "object_code/common/itemParents/swordParent.s"
	.include "object_code/common/itemParents/seedsParent.s"
	.include "object_code/common/itemParents/boomerangParent.s"
	.include "object_code/common/itemParents/bombsBraceletParent.s"
	.include "object_code/common/itemParents/featherParent.s"
	.include "object_code/common/itemParents/magnetGloveParent.s"
	.include "object_code/common/itemParents/lifeVialParent.s"

	.include "object_code/common/itemParents/commonCode.s"

	.include {"{GAME_DATA_DIR}/itemUsageTables.s"}
.ends

m_section_superfree Item_Parents_2 NAMESPACE itemParentsExt
	; NOTE: these are needed in here as well due to them relying
	;       on several animation related functions for link in here
	.include "code/specialObjectAnimationsAndDamage.s"
	.include {"{BUILD_DIR}/specialObjectAnimationData.s"}

	.include "object_code/common/itemParents/harpFluteParent.s"
	.include "object_code/common/itemParents/shovelParent.s"

	.include "object_code/common/itemParents/commonCode.s"

	.include {"{GAME_DATA_DIR}/itemUsageTables.s"}
.ends

m_section_superfree Item_Code namespace itemCode
	.include "code/updateItems.s"
	.include "object_code/common/items/commonCode1.s"

	.include {"{GAME_DATA_DIR}/tile_properties/conveyorItemTiles.s"}
	.include {"{GAME_DATA_DIR}/tile_properties/itemPassableTiles.s"}

	.include "object_code/common/items/seeds.s"
	.include "object_code/common/items/dimitriMouth.s"
	.include "object_code/common/items/bombchus.s"
	.include "object_code/common/items/bombs.s"
	.include "object_code/common/items/boomerang.s"
	.include "object_code/common/items/switchHook.s"
	.include "object_code/common/items/rickyTornado.s"
	.include "object_code/common/items/magnetBall.s"
	.include "object_code/common/items/seedShooter.s"
	.include "object_code/common/items/rickyMooshAttack.s"
	.include "object_code/common/items/shovel.s"
	.include "object_code/common/items/caneOfSomaria.s"
	.include "object_code/common/items/minecartCollision.s"
	.include "object_code/common/items/slingshot.s"
	.include "object_code/common/items/foolsOre.s"
	.include "object_code/common/items/biggoronSword.s"
	.include "object_code/common/items/sword.s"
	.include "object_code/common/items/punch.s"
	.include "object_code/common/items/swordBeam.s"
	.include "object_code/common/items/postUpdate.s"
	.include "object_code/common/items/commonCode2.s"
	.include "object_code/common/items/bracelet.s"
	.include "object_code/common/items/commonBombAndBraceletCode.s"
	.include "object_code/common/items/dust.s"
	.include "object_code/common/items/magnetGloves.s"
	.include "object_code/common/items/rodOfSeasons.s"

	.include {"{GAME_DATA_DIR}/itemAttributes.s"}
	.include "data/itemAnimations.s"
.ends

m_section_superfree bank_0_Ext NAMESPACE bank0Ext
	.include "code/bank0Ext.s"
.ends