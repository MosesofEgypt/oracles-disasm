;;
; NOTE: This file contains the config definitions for controlling various
;		aspects of the ring redux mod, and things associated with it.
;		Most changes here will require editing the related text strings.
;;

.ifdef ENABLE_REDUX_EXTRAS
	.ifndef ENABLE_GASHA_REBALANCE
		.define ENABLE_GASHA_REBALANCE		1
	.endif
	.ifndef ENABLE_SECRET_GASHA_RINGS
;		.define ENABLE_SECRET_GASHA_RINGS 	1 	; keeping here for documentation
	.endif
	.ifndef ENABLE_PUNCH_WITH_ITEM
		.define ENABLE_PUNCH_WITH_ITEM 		1
	.endif
	.ifndef ENABLE_QUICK_ITEM_DROP
		.define ENABLE_QUICK_ITEM_DROP 		1
	.endif
	.ifndef ENABLE_PORTAL_RING_BOX
		.define ENABLE_PORTAL_RING_BOX		1
	.endif
	.ifndef INCREASE_WALLET_SIZE
		.define INCREASE_WALLET_SIZE		1
	.endif
	.ifndef REMAP_RING_LIST
		.define REMAP_RING_LIST				1
	.endif
	.ifndef UNRESTRICTED_TRANSFORMS
		.define UNRESTRICTED_TRANSFORMS		1
	.endif
.endif

.ifdef ENABLE_RING_REDUX
	; NOTE: these values are in 1/8 heart increments, so 8 == 1 heart
		.define RED_RING_ATK_MOD			8
		.define GREEN_RING_ATK_MOD			6
		.define GOLD_RING_ATK_MOD			4
		.define CURSE_POWER_RING_ATK_MOD	8
		.define MAX_RING_ATK_MOD			(8*5)

	; NOTE: these values are 1/8 increments, so 3 = 37.5% damage reduction
		.define BLUE_RING_DEF_MOD			4
		.define GREEN_RING_DEF_MOD			3
		.define GOLD_RING_DEF_MOD			2
		.define CURSE_POWER_RING_DEF_MOD	0
		.define HOLY_RING_DEF_MOD			2
		.define MAX_RING_DEF_MOD			3

	; NOTE: this is the chance in 127 to not take damage, so 38 == 30%
		; Each luck ring gives a separate chance to reduce all damage
		; taken to nothing. the probabilities for this to occur while
		; wearing 1 / 2 / 3 rings are the following:
		;   if each ring == 25% chance  ->  25% / 44% / 58%
		;   if each ring == 30% chance  ->  30% / 51% / 66%
		;   if each ring == 33% chance  ->  33% / 55% / 70%
		;   if each ring == 38% chance  ->  38% / 60% / 76%
		;   if each ring == 50% chance  ->  50% / 75% / 88%
		.define LUCK_RING_CHANCE			38

	; NOTE: these values are in 1/4 heart increments, so 4 == 1 heart
		.define GOLD_RING_HEART_CUTOFF		(4*4)
		.define CURSE_RING_HEART_CAP		(4*4)

		; this is how much to reduce/increase damage dealt
		.define POWER_RING_L1_ATK_MOD		-1
		.define POWER_RING_L2_ATK_MOD		-2
		.define POWER_RING_L3_ATK_MOD		-3
		.define ARMOR_RING_L1_ATK_MOD		1
		.define ARMOR_RING_L2_ATK_MOD		1
		.define ARMOR_RING_L3_ATK_MOD		1

	; NOTE: these values are in 1/8 heart increments, so 8 == 1 heart
		.define LIGHT_RING_L1_CUTOFF		(8*3)
		.define LIGHT_RING_L2_CUTOFF		(8*6)

		.define SPIN_SWING_COUNTER			(4*15 + 1)	; one startup frame, and 4 per spin
		.define SWORD_BEAM_LIMIT			2			; number of beams onscreen at once
		.define SUPER_BEAM_DELAY			60			; frames

		; this is how much to reduce/increase damage taken
		.define POWER_RING_L1_DEF_MOD		-2
		.define POWER_RING_L2_DEF_MOD		-4
		.define POWER_RING_L3_DEF_MOD		-6
		.define ARMOR_RING_L1_DEF_MOD		2
		.define ARMOR_RING_L2_DEF_MOD		4
		.define ARMOR_RING_L3_DEF_MOD		6

	.define ALCHEMY_SEED_COST 			RUPEEVAL_002
	.define ALCHEMY_BOMB_COST 			RUPEEVAL_005
	.define ALCHEMY_BOMBCHU_COST 		RUPEEVAL_050

	; NOTE: if this is defined, the hurricane spin lasts until you release the button
;	.define INDEFINITE_HURRICANE_SPIN	1
.endif

.ifdef RESIZE_RING_BOX
	; NOTE: These are the sizes of each level of ring box. Level 5 should be
	;		at least 5 rings, as the UI code expects to clear all the tiles
	;		for it. Also, do not go over 10 rings for extended box sizes, nor
	;		5 rings for non-extended box sizes.
	.ifdef EXTENDED_RING_BOX
		.define RING_BOX_L1_SIZE		3
		.define RING_BOX_L2_SIZE		5
		.define RING_BOX_L3_SIZE		10
	.else
		.define RING_BOX_L1_SIZE		2
		.define RING_BOX_L2_SIZE		4
		.define RING_BOX_L3_SIZE		5
	.endif

	; NOTE: These value should be the same as the sizes above, but they
	;		MUST be clipped to be 5 or less. They're used to determine
	;		how many tiles to clear in the inventory, so any higher and
	;		you'll start to get graphical bugs.
	.ifdef EXTENDED_RING_BOX
		.define RING_BOX_L1_WIDTH		3
		.define RING_BOX_L2_WIDTH		5
	.else
		.define RING_BOX_L1_WIDTH		2
		.define RING_BOX_L2_WIDTH		4
	.endif
.endif

.ifdef INCREASE_WALLET_SIZE
	; NOTE: do not go over 9999
	.define MAX_WALLET_SIZE 			$9999
.endif

.ifdef ENABLE_PORTAL_RING_BOX
	; If your ring box is at least this level, you'll be able to open the
	; ring list without needing Vasu's Ring to be equipped. If you want
	; to stick with a 5-ring box, you could have level 3 be a portal box
	.define PORTAL_RING_BOX_LEVEL		3
.endif

.ifdef ENABLE_GASHA_REBALANCE
	; NOTE: See notes/gasha_rebalance_mechanics.txt for info on what these do
	.define RING_TIER_3_MAX_KILLS		70
	.define RING_TIER_2_MAX_KILLS		90
	.define RING_TIER_1_MAX_KILLS		110
	.define RING_TIER_2_MIN_KILLS		45
	.define RING_TIER_1_MIN_KILLS		50
	.define RING_TIER_0_MIN_KILLS		55

	; The following are the rings that drop per tier, followed by 
	; cutoffs for the chance to drop. the comment after the cutoff
	; is the weight that the above cutoffs were derived from.

	; tier0: high-buff/good-utility
	.macro TIER0_RINGS_AND_CUTOFFS
		.db ENERGY_RING			12	; 1
		.db QUICKSWAP_RING		51	; 3
		.db GREEN_LUCK_RING		76	; 2
		.db RED_LUCK_RING		102	; 2
		.db BLUE_LUCK_RING		127	; 2
		.db ALCHEMY_RING		140	; 1
		.db MYSTIC_SEED_RING	178	; 3
		.db LIGHT_RING_L2		191	; 1
		.db GOLD_JOY_RING		204	; 1
		.db HEART_RING_L2		217	; 1
		.db EXPERTS_RING		255	; 3
	.endm

	; tier1: mod-buff/high-utility
	.macro TIER1_RINGS_AND_CUTOFFS
		.db POWER_RING_L2		20	; 2
		.db BLAST_RING			30	; 1
		.db RANG_RING_L2		81	; 5
		.db ARMOR_RING_L2		102	; 2
		.db GREEN_HOLY_RING		122	; 2
		.db BLUE_HOLY_RING		143	; 2
		.db RED_HOLY_RING		163	; 2
		.db ROCS_RING			204	; 4
		.db HEART_RING_L1		214	; 1
		.db HASTE_RING			245	; 3
		.db LIGHT_RING_L1		255	; 1
	.endm

	; tier2: bad-buff/mod-utility
	.macro TIER2_RINGS_AND_CUTOFFS
		.db CURSE_POWER_RING	42	; 5
		.db RANG_RING_L1		76	; 4
		.db ARMOR_RING_L1		93	; 2
		.db CURSE_ARMOR_RING	136	; 5
		.db BOMBERS_RING		144	; 1
		.db BOMBPROOF_RING		153	; 1
		.db ZORA_RING			178	; 3
		.db HIKERS_RING			187	; 1
		.db FAIRYS_RING			221	; 4
		.db RED_JOY_RING		229	; 1
		.db BLUE_JOY_RING		255	; 3
	.endm

	; tier3: cosmetic/low-utility
	.macro TIER3_RINGS_AND_CUTOFFS
		.db OCTO_RING			32	; 5
		.db LIKE_LIKE_RING		65	; 5
		.db MOBLIN_RING			98	; 5
		.db SUBROSIAN_RING		131	; 5
		.db FIRST_GEN_RING		144	; 2
		.db GBOY_COLOR_RING		170	; 4
		.db PEACE_RING			176	; 1
		.db FIST_RING			209	; 5
		.db TOSS_RING			242	; 5
		.db STEADFAST_RING		248	; 1
		.db GREEN_JOY_RING		255	; 1
	.endm

	; tier4: best-buff/best-utility
	; NOTE: only available if every other tiered ring was obtained
	.macro TIER4_RINGS_AND_CUTOFFS
		.ifdef ENABLE_SECRET_GASHA_RINGS
		.db GREEN_RING			76	; 3
		.db GOLD_RING			153	; 3
		; these rings are normally obtained with secrets, but
		; we'll allow them to be obtained via gasha nut if the
		; player was diligent enough to get every tier 1-4 ring
		; ages secret
		.db SPIN_RING			178	; 1
		.db FARMERS_RING		204	; 1
		; seasons secret
		.db CHARGE_RING			229	; 1
		.db SWIMMERS_RING		255	; 1
		.else
		.db GREEN_RING			127	; 1
		.db GOLD_RING			255	; 1
		.endif
		.db $ff						; terminator
	.endm

.endif

.ifdef REMAP_RING_LIST
	; NOTE: If you want to rearrange where the rings show up in the list, do so here.
	;		HOWEVER, make sure you do not mess with the structure. These defines MUST
	;		contain at 64 items, MUST NOT contain duplicates, and there MUST be a
	;		define for each quadrant of each page(so, 16 defines in total).
	.define RING_LIST_PG1_UP_LEFT		POWER_RING_L1		POWER_RING_L2		POWER_RING_L3		RED_RING
	.define RING_LIST_PG1_UP_RIGHT		GREEN_RING			GREEN_HOLY_RING		RED_HOLY_RING		BLUE_HOLY_RING
	.define RING_LIST_PG1_DOWN_LEFT		ARMOR_RING_L1		ARMOR_RING_L2		ARMOR_RING_L3		BLUE_RING
	.define RING_LIST_PG1_DOWN_RIGHT	GOLD_RING			GREEN_LUCK_RING		RED_LUCK_RING		BLUE_LUCK_RING

	.define RING_LIST_PG2_UP_LEFT		HEART_RING_L1		RANG_RING_L1		FIST_RING			LIGHT_RING_L1
	.define RING_LIST_PG2_UP_RIGHT		ENERGY_RING			SPIN_RING			CHARGE_RING			VICTORY_RING
	.define RING_LIST_PG2_DOWN_LEFT		HEART_RING_L2		RANG_RING_L2		EXPERTS_RING		LIGHT_RING_L2
	.define RING_LIST_PG2_DOWN_RIGHT	BLAST_RING			PEACE_RING			BOMBPROOF_RING		BOMBERS_RING

	.define RING_LIST_PG3_UP_LEFT		HASTE_RING			ZORA_RING			SWIMMERS_RING		ALCHEMY_RING
	.define RING_LIST_PG3_UP_RIGHT		GREEN_JOY_RING		RED_JOY_RING		BLUE_JOY_RING		GOLD_JOY_RING
	.define RING_LIST_PG3_DOWN_LEFT		HIKERS_RING			QUICKSWAP_RING		DISCOVERY_RING		FARMERS_RING
	.define RING_LIST_PG3_DOWN_RIGHT	STEADFAST_RING		MYSTIC_SEED_RING	TOSS_RING			ROCS_RING

	.define RING_LIST_PG4_UP_LEFT		GREEN_COLOR_RING	RED_COLOR_RING		BLUE_COLOR_RING		GOLD_COLOR_RING
	.define RING_LIST_PG4_UP_RIGHT		GBOY_COLOR_RING		GBA_NATURE_RING		CURSE_POWER_RING	FAIRYS_RING
	.define RING_LIST_PG4_DOWN_LEFT		OCTO_RING			LIKE_LIKE_RING		MOBLIN_RING			SUBROSIAN_RING
	.define RING_LIST_PG4_DOWN_RIGHT	FIRST_GEN_RING		GBA_TIME_RING		CURSE_ARMOR_RING	VASUS_RING
.endif

; NOTE: Code below here is not meant to be treated as configuration.
;		We're simply setting up any dependent defines.

.ifdef ENABLE_RING_REDUX
	.define SEED_SHOOTER_BASE_ID		$40
.endif

.ifdef ENABLE_RING_REDUX
	.ifndef ENABLE_PORTAL_RING_BOX
		; If we want the redux, but don't want a portal box, we at least
		; allow Vasu's Ring to work as a portal to the ring list.
		.define ENABLE_PORTAL_RING_BOX	1
	.endif

	.ifndef REDUX_UTIL_FUNCS
		; necessary for basically all ring combos
		.define REDUX_UTIL_FUNCS		1
	.endif
.endif

.ifdef ENABLE_MULTI_RING
	.ifndef UNRESTRICTED_TRANSFORMS
		; necessary if all rings can be equipped at once
		.define UNRESTRICTED_TRANSFORMS	1
	.endif
.endif

.ifdef UNRESTRICTED_TRANSFORMS
	.ifndef REDUX_UTIL_FUNCS
		; necessary for transform rework
		.define REDUX_UTIL_FUNCS		1
	.endif
.endif