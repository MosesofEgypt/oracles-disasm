;;
; NOTE: This file contains the config definitions for controlling various
;		aspects of the ring redux mod, and things associated with it.
;		Most changes here will require editing the related text strings.
;;

.ifdef ENABLE_REDUX_EXTRAS
	.define ENABLE_GASHA_REBALANCE		1
;	.define ENABLE_SECRET_GASHA_RINGS 	1 	; keeping here for documentation
	.define ENABLE_PUNCH_WITH_ITEM 		1
	.define ENABLE_PORTAL_RING_BOX		1
	.define INCREASE_WALLET_SIZE		1
	.define REMAP_RING_LIST				1
.endif

.ifdef ENABLE_RING_REDUX
	; NOTE: these values are in 1/8 heart increments, so 8 == 1 heart
	.define RED_RING_ATK_MOD		8
	.define GREEN_RING_ATK_MOD		6
	.define GOLD_RING_ATK_MOD		4
	.define CURSE_RING_ATK_MOD		8
	.define MAX_ATK_MOD				(8*5)

	; NOTE: these values are 1/8 increments, so 3 = 37.5% damage reduction
	.define BLUE_RING_DEF_MOD		4
	.define GREEN_RING_DEF_MOD		3
	.define GOLD_RING_DEF_MOD		2
	.define CURSE_RING_DEF_MOD		0
	.define HOLY_RING_DEF_MOD		2
	.define MAX_DEF_MOD				3

	; NOTE: these values are in 1/4 heart increments, so 4 == 1 heart
	.define GOLD_RING_HEART_MAX		(4*4)
	.define CURSE_RING_HEART_CAP	(4*4)

	; NOTE: this is the chance in 127 to not take damage, so 38 == 30%
	.define LUCK_RING_CHANCE		38

	; NOTE: these values are in 1/8 heart increments, so 8 == 1 heart
	.define LIGHT_RING_L1_CUTOFF	(8*3)
	.define LIGHT_RING_L2_CUTOFF	(8*6)

	.define SPIN_SWING_COUNTER		(4*15 + 1)	; one startup frame, and 4 per spin
	.define SWORD_BEAM_LIMIT		3			; number of beams onscreen at once
	.define SUPER_BEAM_DELAY		50			; frames
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
.endif


; NOTE: Code below here is not meant to be treated as configuration.
.ifdef ENABLE_RING_REDUX
.ifndef ENABLE_PORTAL_RING_BOX
	; If we want the redux, but don't want a portal box, we at least
	; allow Vasu's Ring to work as a portal to the ring list.
	.define ENABLE_PORTAL_RING_BOX		1
.endif
.endif