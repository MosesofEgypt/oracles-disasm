.include "constants/common/version.s"

.include "redux_config/config.s"

.include "constants/common/breakableTileSources.s"
.include "constants/common/directions.s"
.include "constants/common/collisionEffects.s"
.include "constants/common/cutsceneIndices.s"
.include "constants/common/dungeonRoomProperties.s"
.if defined(ROM_COMBO)
	.include {"{BUILD_DIR}/enemyCollisionModes.s"}
.else
    .include "constants/common/enemyCollisionModes.s"
.endif
.include "constants/common/enemyStates.s"
.include "constants/common/enemies.s"
.include "constants/common/globalFlags.s"
.include "constants/common/hardware.s"
.include "constants/common/interactions.s"
.include "constants/common/itemCollisionTypes.s"
.include "constants/common/itemDrops.s"
.include "constants/common/items.s"
.include "constants/common/linkAnimations.s"
.include "constants/common/linkStates.s"
.include "constants/common/music.s"
.include "constants/common/objectGfxHeaders.s"
.include "constants/common/objectSpeeds.s"
.include "constants/common/other.s"
.include "constants/common/parts.s"
.include "constants/common/rings.s"
.include "constants/common/roomFlags.s"
.include "constants/common/rooms.s"
.include "constants/common/rupeeValues.s"
.include "constants/common/specialCollisionValues.s"
.include "constants/common/specialObjects.s"
.include "constants/common/staticObjectTypes.s"
.include "constants/common/secrets.s"
.include "constants/common/textboxFlags.s"
.include "constants/common/tileIndices.s"
.include "constants/common/tilesetFlags.s"
.include "constants/common/tileTypes.s"
.include "constants/common/tradeitems.s"
.include "constants/common/transitions.s"
.include "constants/common/treasure.s"
.include "constants/common/treasureSpawnModes.s"
.include "constants/common/treeGfxHeaders.s"
.include "constants/common/uncmpGfxHeaders.s"

.if defined(ROM_AGES) || defined(ROM_COMBO)

.include "constants/ages/interactions.s"
.include "constants/ages/enemies.s"
.include "constants/ages/parts.s"
.endif

.if defined(ROM_SEASONS) || defined(ROM_COMBO)

.include "constants/seasons/interactions.s"
.include "constants/seasons/enemies.s"
.include "constants/seasons/parts.s"

.include "constants/seasons/seasons.s"
.endif

.include "redux_config/ringConfig.s"
