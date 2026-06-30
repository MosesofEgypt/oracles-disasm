; See data/ages/treasureDisplayData.s for documentation.

treasureDisplayData1:
	.db TREASURE_SEED_SATCHEL,  <wSatchelSelectedSeeds,  $01
	.db TREASURE_SWORD,         <wSwordLevel,            $04
	.db TREASURE_SHIELD,        <wShieldLevel,           $05
	.db TREASURE_TRADEITEM,     <wTradeItem,             $08
	.db TREASURE_FLUTE,         <wFluteIcon,             $0b
	.db TREASURE_SLINGSHOT,     <wSlingshotSelectedSeeds,$02
	.db TREASURE_SLINGSHOT,     <wSlingshotSelectedSeeds,$03
	.db TREASURE_SHOOTER,       <wShooterSelectedSeeds,  $0e
	.db TREASURE_FEATHER,       <wFeatherLevel,          $06
	.db TREASURE_BOOMERANG,     <wBoomerangLevel,        $07
	.db TREASURE_PIRATES_BELL,  <wPirateBellState,       $09
	.db TREASURE_MAGNET_GLOVES, <wMagnetGlovePolarity,   $0a
	.db TREASURE_BRACELET,      <wBraceletLevel,         $0c
	.db TREASURE_SWITCH_HOOK,   <wSwitchHookLevel,       $0d
	.db TREASURE_HARP,          <wSelectedHarpSong,      $0f
	.db $00,                    $00,                     $00

treasureDisplayData2:
	.dw treasureDisplayData_standard
	.dw treasureDisplayData_satchel
	.dw treasureDisplayData_slingshot
	.dw treasureDisplayData_hyperSlingshot
	.dw treasureDisplayData_sword     - 7
	.dw treasureDisplayData_shield    - 7
	.dw treasureDisplayData_feather   - 7
	.dw treasureDisplayData_boomerang - 7
	.dw treasureDisplayData_tradeItem
	.dw treasureDisplayData_pirateBell
	.dw treasureDisplayData_magnetGlove
	.dw treasureDisplayData_flute
	.dw treasureDisplayData_bracelet   - 7
	.dw treasureDisplayData_switchHook - 7
	.dw treasureDisplayData_shooter
	.dw treasureDisplayData_harp

	.dw treasureDisplayData_sword

treasureDisplayData_standard:
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_NONE
	.db $00,                         $07, $00, $00, $00, $00, <TX_0900 ; X TREASURE_SHIELD
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_PUNCH
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_BOMBS,              $9a, $04, $9b, $04, $07, <TX_0926 ; TREASURE_BOMBS (0x03)
	.db $00,                         $9e, $05, $9f, $05, $ff, <TX_09_CANE ; TREASURE_CANE_OF_SOMARIA (0x04)
.else
	.db TREASURE_BOMBS,              $9e, $04, $00, $00, $01, <TX_0926 ; TREASURE_BOMBS
	.db $00,                         $9d, $02, $00, $00, $ff, <TX_09_CANE ; TREASURE_CANE_OF_SOMARIA
.endif
	.db $00,                         $07, $00, $07, $00, $00, <TX_0900 ; X TREASURE_SWORD
	.db $06,                         $07, $00, $07, $00, $00, <TX_0900 ; X TREASURE_BOOMERANG
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_ROD_OF_SEASONS,     $ad, $03, $ae, $01, $82, <TX_0941 ; TREASURE_ROD_OF_SEASONS (0x07)
.else
	.db TREASURE_ROD_OF_SEASONS,     $98, $02, $00, $00, $02, <TX_0941 ; TREASURE_ROD_OF_SEASONS
.endif
	.db $00,                         $07, $00, $07, $00, $03, <TX_0900 ; X TREASURE_MAGNET_GLOVES
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_SWITCH_HOOK_HELPER
	.db TREASURE_SWITCH_HOOK,        $9f, $04, $00, $00, $00, <TX_0900 ; TREASURE_SWITCH_HOOK
	.db $00,                         $00, $02, $00, $00, $ff, <TX_0900 ; TREASURE_SWITCH_HOOK_CHAIN
.ifdef WIDE_INVENTORY_SPRITES
	.db $00,                         $94, $03, $95, $03, $bf, <TX_0928 ; TREASURE_BIGGORON_SWORD (0x0c)
	.db TREASURE_BOMBCHUS,           $9c, $01, $9d, $05, $07, <TX_0929 ; TREASURE_BOMBCHUS (0x0d)
.else
	.db $00,                         $a1, $03, $a2, $03, $ff, <TX_0928 ; TREASURE_BIGGORON_SWORD
	.db TREASURE_BOMBCHUS,           $a0, $05, $00, $00, $01, <TX_0929 ; TREASURE_BOMBCHUS
.endif
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_FLUTE
	.db $00,                         $88, $00, $00, $00, $ff, <TX_0900 ; TREASURE_SHOOTER
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_10
	.db $00,                         $00, $00, $00, $00, $00, <TX_0900 ; TREASURE_HARP
.ifdef ENABLE_NEW_GAME_PLUS
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_LIFE_VIAL,          $b9, $01, $b9, $21, $07, <TX_09_LIFE_VIAL ; TREASURE_LIFE_VIAL
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_SLINGSHOT
	.db TREASURE_LIFE_VIAL_CHARGE,   $b9, $01, $b9, $21, $ff, <TX_0900 ; TREASURE_LIFE_VIAL
.else
	.db TREASURE_LIFE_VIAL,          $b9, $01, $00, $00, $01, <TX_09_LIFE_VIAL ; TREASURE_LIFE_VIAL
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_SLINGSHOT
	.db TREASURE_LIFE_VIAL_CHARGE,   $b9, $01, $00, $00, $ff, <TX_0900 ; TREASURE_LIFE_VIAL
.endif
.else
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_12
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_SLINGSHOT
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_14
.endif
.ifdef WIDE_INVENTORY_SPRITES
	.db $00,                         $a0, $04, $a1, $03, $ff, <TX_092a ; TREASURE_SHOVEL (0x15)
.else
	.db $00,                         $9b, $04, $00, $00, $ff, <TX_092a ; TREASURE_SHOVEL
.endif
	.db $00,                         $99, $05, $00, $00, $ff, <TX_092b ; X TREASURE_BRACELET
	.db $00,                         $07, $00, $07, $00, $00, <TX_0900 ; X TREASURE_FEATHER
	.db $00,                         $00, $03, $00, $00, $ff, <TX_0900 ; TREASURE_18
	.db $00,                         $07, $00, $07, $00, $01, <TX_0900 ; X TREASURE_SEED_SATCHEL
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_1a
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_1b
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_1c
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_MINECART_COLLISION
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_FOOLS_ORE,          $01, $00, $97, $00, $ff, <TX_093f ; TREASURE_FOOLS_ORE (0x1e)
.else
	.db TREASURE_FOOLS_ORE,          $9a, $00, $00, $00, $ff, <TX_093f ; TREASURE_FOOLS_ORE
.endif
	.db $00,                         $9a, $00, $9a, $00, $ff, <TX_0900 ; TREASURE_1f
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_EMBER_SEEDS,        $80, $00, $83, $00, $ff, <TX_0932 ; TREASURE_EMBER_SEEDS (0x20)
	.db TREASURE_SCENT_SEEDS,        $80, $00, $84, $00, $ff, <TX_0933 ; TREASURE_SCENT_SEEDS (0x21)
	.db TREASURE_PEGASUS_SEEDS,      $80, $00, $85, $00, $ff, <TX_0934 ; TREASURE_PEGASUS_SEEDS (0x22)
	.db TREASURE_GALE_SEEDS,         $80, $00, $86, $00, $ff, <TX_0935 ; TREASURE_GALE_SEEDS (0x23)
	.db TREASURE_MYSTERY_SEEDS,      $80, $00, $87, $00, $ff, <TX_0936 ; TREASURE_MYSTERY_SEEDS (0x24)
	.db $00,                         $3a, $00, $3b, $00, $ff, <TX_09_ECHOES ; TREASURE_TUNE_OF_ECHOES (0x25)
	.db $00,                         $3c, $00, $3d, $00, $ff, <TX_09_CURRENTS ; TREASURE_TUNE_OF_CURRENTS (0x26)
	.db $00,                         $3e, $00, $3f, $00, $ff, <TX_09_AGES ; TREASURE_TUNE_OF_AGES (0x27)
.else
	.db TREASURE_EMBER_SEEDS,        $80, $00, $83, $00, $ff, <TX_0932 ; TREASURE_EMBER_SEEDS
	.db TREASURE_SCENT_SEEDS,        $80, $00, $84, $00, $ff, <TX_0933 ; TREASURE_SCENT_SEEDS
	.db TREASURE_PEGASUS_SEEDS,      $80, $00, $85, $00, $ff, <TX_0934 ; TREASURE_PEGASUS_SEEDS
	.db TREASURE_GALE_SEEDS,         $80, $00, $86, $00, $ff, <TX_0935 ; TREASURE_GALE_SEEDS
	.db TREASURE_MYSTERY_SEEDS,      $80, $00, $87, $00, $ff, <TX_0936 ; TREASURE_MYSTERY_SEEDS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_09_ECHOES ; TREASURE_TUNE_OF_ECHOES
	.db $00,                         $00, $00, $00, $00, $ff, <TX_09_CURRENTS ; TREASURE_TUNE_OF_CURRENTS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_09_AGES ; TREASURE_TUNE_OF_AGES
.endif
	.db TREASURE_RUPEES,             $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_RUPEES
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_HEART_REFILL
	.db TREASURE_HEART_CONTAINER,    $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_HEART_CONTAINER
	.db TREASURE_HEART_PIECE,        $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_HEART_PIECE
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_RING_BOX
	.db TREASURE_RING,               $24, $00, $00, $00, $01, <TX_0917 ; TREASURE_RING
	.db TREASURE_FLIPPERS,           $22, $05, $23, $05, $ff, <TX_0918 ; TREASURE_FLIPPERS
	.db TREASURE_POTION,             $20, $02, $21, $02, $ff, <TX_0919 ; TREASURE_POTION
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_SMALL_KEY
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_BOSS_KEY
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_COMPASS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_MAP
	.db TREASURE_GASHA_SEED,         $25, $01, $00, $00, $01, <TX_0916 ; TREASURE_GASHA_SEED
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_35
	.db TREASURE_MAKU_SEED,          $00, $00, $00, $00, $ff, <TX_0915 ; TREASURE_MAKU_SEED
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_ORE_CHUNKS
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_38
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_39
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3a
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3b
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3c
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3d
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3e
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_3f
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; TREASURE_ESSENCE
	.db TREASURE_TRADEITEM,          $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_TRADEITEM
	.db TREASURE_GNARLED_KEY,        $37, $05, $00, $00, $ff, <TX_0944 ; TREASURE_GNARLED_KEY
	.db TREASURE_FLOODGATE_KEY,      $38, $04, $00, $00, $ff, <TX_0945 ; TREASURE_FLOODGATE_KEY
	.db TREASURE_DRAGON_KEY,         $39, $01, $00, $00, $ff, <TX_0946 ; TREASURE_DRAGON_KEY
	.db TREASURE_STAR_ORE,           $f0, $03, $f1, $03, $ff, <TX_094c ; TREASURE_STAR_ORE
	.db TREASURE_RIBBON,             $e6, $02, $e7, $02, $ff, <TX_094d ; TREASURE_RIBBON
	.db TREASURE_SPRING_BANANA,      $e8, $03, $e9, $03, $ff, <TX_0947 ; TREASURE_SPRING_BANANA
	.db TREASURE_RICKY_GLOVES,       $de, $05, $df, $05, $ff, <TX_091b ; TREASURE_RICKY_GLOVES
	.db TREASURE_BOMB_FLOWER,        $f5, $05, $f5, $25, $ff, <TX_091a ; TREASURE_BOMB_FLOWER
	.db $00,                         $07, $00, $07, $00, $ff, <TX_0900 ; X TREASURE_PIRATES_BELL
	.db TREASURE_TREASURE_MAP,       $ea, $03, $eb, $03, $ff, <TX_094a ; TREASURE_TREASURE_MAP
	.db TREASURE_ROUND_JEWEL,        $e2, $00, $00, $00, $ff, <TX_094b ; TREASURE_ROUND_JEWEL
	.db TREASURE_PYRAMID_JEWEL,      $e3, $02, $00, $00, $ff, <TX_094b ; TREASURE_PYRAMID_JEWEL
	.db TREASURE_SQUARE_JEWEL,       $e4, $01, $00, $00, $ff, <TX_094b ; TREASURE_SQUARE_JEWEL
	.db TREASURE_X_SHAPED_JEWEL,     $e5, $03, $00, $00, $ff, <TX_094b ; TREASURE_X_SHAPED_JEWEL
	.db TREASURE_RED_ORE,            $f2, $02, $00, $00, $ff, <TX_094e ; TREASURE_RED_ORE
	.db TREASURE_BLUE_ORE,           $f2, $01, $00, $00, $ff, <TX_094f ; TREASURE_BLUE_ORE
	.db TREASURE_HARD_ORE,           $f3, $00, $f4, $00, $ff, <TX_0950 ; TREASURE_HARD_ORE
	.db TREASURE_MEMBERS_CARD,       $26, $01, $27, $01, $ff, <TX_091c ; TREASURE_MEMBERS_CARD
	.db TREASURE_MASTERS_PLAQUE,     $26, $03, $27, $03, $ff, <TX_0943 ; TREASURE_MASTERS_PLAQUE
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_55
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_56
	.db $00,                         $00, $00, $00, $00, $ff, <TX_0900 ; TREASURE_57
	.db TREASURE_BOMB_FLOWER,        $f7, $04, $f8, $04, $ff, <TX_091a ; TREASURE_BOMB_FLOWER_LOWER_HALF
	.db TREASURE_MERMAID_SUIT,       $2b, $04, $2c, $04, $ff, <TX_09_MERMAIDSUIT ; TREASURE_MERMAID_SUIT

treasureDisplayData_satchel:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_EMBER_SEEDS,        $88, $03, $89, $02, $08, <TX_092d ; Ember seeds
	.db TREASURE_SCENT_SEEDS,        $88, $03, $89, $03, $18, <TX_092d ; Scent seeds
	.db TREASURE_PEGASUS_SEEDS,      $88, $03, $89, $01, $28, <TX_092d ; Pegasus seeds
	.db TREASURE_GALE_SEEDS,         $88, $03, $89, $01, $38, <TX_092d ; Gale seeds
	.db TREASURE_MYSTERY_SEEDS,      $88, $03, $89, $00, $48, <TX_092d ; Mystery seeds
.else
	.db TREASURE_EMBER_SEEDS,        $80, $05, $83, $02, $01, <TX_092d ; Ember seeds
	.db TREASURE_SCENT_SEEDS,        $80, $05, $84, $03, $01, <TX_092d ; Scent seeds
	.db TREASURE_PEGASUS_SEEDS,      $80, $05, $85, $01, $01, <TX_092d ; Pegasus seeds
	.db TREASURE_GALE_SEEDS,         $80, $05, $86, $01, $01, <TX_092d ; Gale seeds
	.db TREASURE_MYSTERY_SEEDS,      $80, $05, $87, $00, $01, <TX_092d ; Mystery seeds
.endif

treasureDisplayData_slingshot:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_EMBER_SEEDS,        $8a, $01, $8b, $02, $0a, <TX_093c
	.db TREASURE_SCENT_SEEDS,        $8a, $01, $8b, $03, $1a, <TX_093c
	.db TREASURE_PEGASUS_SEEDS,      $8a, $01, $8b, $01, $2a, <TX_093c
	.db TREASURE_GALE_SEEDS,         $8a, $01, $8b, $01, $3a, <TX_093c
	.db TREASURE_MYSTERY_SEEDS,      $8a, $01, $8b, $00, $4a, <TX_093c
.else
	.db TREASURE_EMBER_SEEDS,        $81, $04, $83, $02, $01, <TX_093c
	.db TREASURE_SCENT_SEEDS,        $81, $04, $84, $03, $01, <TX_093c
	.db TREASURE_PEGASUS_SEEDS,      $81, $04, $85, $01, $01, <TX_093c
	.db TREASURE_GALE_SEEDS,         $81, $04, $86, $01, $01, <TX_093c
	.db TREASURE_MYSTERY_SEEDS,      $81, $04, $87, $00, $01, <TX_093c
.endif

treasureDisplayData_hyperSlingshot:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_EMBER_SEEDS,        $8c, $00, $8d, $02, $0b, <TX_093d
	.db TREASURE_SCENT_SEEDS,        $8c, $00, $8d, $03, $1b, <TX_093d
	.db TREASURE_PEGASUS_SEEDS,      $8c, $00, $8d, $01, $2b, <TX_093d
	.db TREASURE_GALE_SEEDS,         $8c, $00, $8d, $01, $3b, <TX_093d
	.db TREASURE_MYSTERY_SEEDS,      $8c, $00, $8d, $00, $4b, <TX_093d
.else
	.db TREASURE_EMBER_SEEDS,        $81, $05, $83, $02, $01, <TX_093d
	.db TREASURE_SCENT_SEEDS,        $81, $05, $84, $03, $01, <TX_093d
	.db TREASURE_PEGASUS_SEEDS,      $81, $05, $85, $01, $01, <TX_093d
	.db TREASURE_GALE_SEEDS,         $81, $05, $86, $01, $01, <TX_093d
	.db TREASURE_MYSTERY_SEEDS,      $81, $05, $87, $00, $01, <TX_093d
.endif

treasureDisplayData_sword:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_SWORD,              $80, $00, $81, $00, $06, <TX_0923 ; L1
	.db TREASURE_SWORD,              $80, $05, $81, $02, $06, <TX_0924 ; L2
	.db TREASURE_SWORD,              $80, $04, $81, $01, $06, <TX_0925 ; L3
	.ifdef ENABLE_NEW_GAME_PLUS
		.db TREASURE_SWORD, $80, $14, $81, $13, $06, <TX_09_BUTTER_SWORD
	.endif
.else
	.db TREASURE_SWORD,              $90, $00, $00, $00, $00, <TX_0923
	.db TREASURE_SWORD,              $91, $05, $00, $00, $00, <TX_0924
	.db TREASURE_SWORD,              $92, $04, $00, $00, $00, <TX_0925
	.ifdef ENABLE_NEW_GAME_PLUS
		.db TREASURE_SWORD, $48, $03, $00, $00, $00, <TX_09_BUTTER_SWORD
	.endif
.endif

treasureDisplayData_shield:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_SHIELD,             $82, $00, $83, $00, $06, <TX_0920 ; L1
	.db TREASURE_SHIELD,             $82, $05, $83, $05, $06, <TX_0921 ; L2
	.db TREASURE_SHIELD,             $82, $04, $83, $04, $06, <TX_0922 ; L3
	.ifdef ENABLE_NEW_GAME_PLUS
		.db TREASURE_SHIELD, $82, $13, $83, $15, $06, <TX_09_BUTTER_SHIELD
	.endif
.else
	.db TREASURE_SHIELD,             $93, $00, $00, $00, $00, <TX_0920
	.db TREASURE_SHIELD,             $94, $05, $00, $00, $00, <TX_0921
	.db TREASURE_SHIELD,             $95, $04, $00, $00, $00, <TX_0922
	.ifdef ENABLE_NEW_GAME_PLUS
		.db TREASURE_SHIELD, $49, $03, $00, $00, $00, <TX_09_BUTTER_SHIELD
	.endif
.endif

treasureDisplayData_feather:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_FEATHER,            $84, $03, $85, $01, $06, <TX_092c
	.db TREASURE_FEATHER,            $84, $04, $85, $04, $06, <TX_093e
.else
	.db TREASURE_FEATHER,            $96, $04, $00, $00, $00, <TX_092c
	.db TREASURE_FEATHER,            $97, $05, $00, $00, $00, <TX_093e
.endif

treasureDisplayData_boomerang:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_BOOMERANG,          $92, $03, $93, $05, $06, <TX_0927
	.db TREASURE_BOOMERANG,          $92, $04, $93, $04, $06, <TX_0940
.else
	.db TREASURE_BOOMERANG,          $9c, $05, $00, $00, $00, <TX_0927
	.db TREASURE_BOOMERANG,          $9c, $04, $00, $00, $00, <TX_0940
.endif

treasureDisplayData_tradeItem:
	.db TREASURE_TRADEITEM,          $c0, $00, $c1, $00, $ff, <TX_0909
	.db TREASURE_TRADEITEM,          $c2, $03, $c2, $23, $ff, <TX_090a
	.db TREASURE_TRADEITEM,          $c3, $00, $c4, $00, $ff, <TX_090b
	.db TREASURE_TRADEITEM,          $c5, $04, $c6, $04, $ff, <TX_090c
	.db TREASURE_TRADEITEM,          $da, $05, $db, $05, $ff, <TX_090d
	.db TREASURE_TRADEITEM,          $c7, $05, $c8, $05, $ff, <TX_090e
	.db TREASURE_TRADEITEM,          $c9, $01, $ca, $01, $ff, <TX_090f
	.db TREASURE_TRADEITEM,          $d0, $01, $d1, $01, $ff, <TX_0910
	.db TREASURE_TRADEITEM,          $d2, $05, $d3, $05, $ff, <TX_0911
	.db TREASURE_TRADEITEM,          $d4, $03, $d5, $03, $ff, <TX_0912
	.db TREASURE_TRADEITEM,          $d6, $01, $d7, $01, $ff, <TX_0913
	.db TREASURE_TRADEITEM,          $d8, $00, $d9, $00, $ff, <TX_0914

treasureDisplayData_pirateBell:
	.db TREASURE_PIRATES_BELL,       $ec, $02, $ed, $02, $ff, <TX_0948
	.db TREASURE_PIRATES_BELL,       $ee, $01, $ef, $01, $ff, <TX_0949

treasureDisplayData_magnetGlove:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_MAGNET_GLOVES,      $98, $04, $99, $04, $ff, <TX_0942
	.db TREASURE_MAGNET_GLOVES,      $98, $05, $99, $05, $ff, <TX_0942
.else
	.db TREASURE_MAGNET_GLOVES,      $88, $01, $89, $00, $03, <TX_0942
	.db TREASURE_MAGNET_GLOVES,      $88, $02, $89, $00, $03, <TX_0942
.endif

treasureDisplayData_flute:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_FLUTE,              $a2, $00, $a3, $00, $ff, <TX_092e ; Strange flute
	.db TREASURE_FLUTE,              $a2, $03, $a3, $03, $ff, <TX_092f ; Ricky's flute
	.db TREASURE_FLUTE,              $a2, $02, $a3, $02, $ff, <TX_0930 ; Dimitri's flute
	.db TREASURE_FLUTE,              $a2, $01, $a3, $01, $ff, <TX_0931 ; Moosh's flute
.else
	.db TREASURE_FLUTE,              $8b, $00, $8c, $00, $ff, <TX_092e
	.db TREASURE_FLUTE,              $8b, $03, $8d, $03, $ff, <TX_092f
	.db TREASURE_FLUTE,              $8b, $02, $8e, $02, $ff, <TX_0930
	.db TREASURE_FLUTE,              $8b, $01, $8f, $01, $ff, <TX_0931
.endif

treasureDisplayData_bracelet:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_BRACELET,           $86, $05, $87, $05, $06, <TX_092b ; L1
	.db TREASURE_BRACELET,           $86, $03, $87, $02, $06, <TX_09_POWERGLOVE ;
.else
	.db TREASURE_BRACELET,           $99, $05, $00, $00, $00, <TX_092b, ; L1
	.db TREASURE_BRACELET,           $af, $05, $00, $00, $00, <TX_09_POWERGLOVE, ; L2
.endif

treasureDisplayData_switchHook:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_SWITCH_HOOK,        $90, $05, $91, $04, $06, <TX_09_SWITCHHOOK ; L1
	.db TREASURE_SWITCH_HOOK,        $90, $05, $91, $04, $06, <TX_09_LONGHOOK ; L2
.else
	.db TREASURE_SWITCH_HOOK,        $9f, $04, $00, $00, $00, <TX_09_SWITCHHOOK, ; L1
	.db TREASURE_SWITCH_HOOK,        $9f, $04, $00, $00, $00, <TX_09_LONGHOOK,   ; L2
.endif

treasureDisplayData_shooter:
.ifdef WIDE_INVENTORY_SPRITES
	.db TREASURE_EMBER_SEEDS,        $8e, $02, $8f, $02, $09, <TX_09_SEED_SHOOTER
	.db TREASURE_SCENT_SEEDS,        $8e, $02, $8f, $03, $19, <TX_09_SEED_SHOOTER
	.db TREASURE_PEGASUS_SEEDS,      $8e, $02, $8f, $01, $29, <TX_09_SEED_SHOOTER
	.db TREASURE_GALE_SEEDS,         $8e, $02, $8f, $01, $39, <TX_09_SEED_SHOOTER
	.db TREASURE_MYSTERY_SEEDS,      $8e, $02, $8f, $00, $49, <TX_09_SEED_SHOOTER
.else
	.db TREASURE_EMBER_SEEDS,        $8a, $05, $83, $02, $01, <TX_09_SEED_SHOOTER,
	.db TREASURE_SCENT_SEEDS,        $8a, $05, $84, $03, $01, <TX_09_SEED_SHOOTER,
	.db TREASURE_PEGASUS_SEEDS,      $8a, $05, $85, $01, $01, <TX_09_SEED_SHOOTER,
	.db TREASURE_GALE_SEEDS,         $8a, $05, $86, $01, $01, <TX_09_SEED_SHOOTER,
	.db TREASURE_MYSTERY_SEEDS,      $8a, $05, $87, $00, $01, <TX_09_SEED_SHOOTER,
.endif

treasureDisplayData_harp:
.ifdef WIDE_INVENTORY_SPRITES
	.db $00, $aa, $02, $ab, $01, $95, <TX_09_HARP ; No song?
	.db $00, $aa, $02, $ab, $01, $85, <TX_09_HARP ; Tune of echoes
	.db $00, $aa, $02, $ab, $01, $b5, <TX_09_HARP ; Tune of currents
	.db $00, $aa, $02, $ab, $01, $95, <TX_09_HARP ; Tune of ages
.else
	.db $00, $02, $04, $02, $00, $05, <TX_09_HARP ; No song?
	.db $00, $a3, $00, $a4, $00, $05, <TX_09_HARP ; Tune of echoes
	.db $00, $a7, $03, $a8, $03, $05, <TX_09_HARP ; Tune of currents
	.db $00, $ab, $01, $ac, $01, $05, <TX_09_HARP ; Tune of ages
.endif
