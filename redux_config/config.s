;;
; NOTE: This file contains the config definitions for controlling various
;		aspects of the redux mod and things associated with it.
; NOTE: Disabling a feature is done by commenting out a line with ';'.
;		Setting the define value to '0' or something won't disable it.
;;

.ifdef ENABLE_FULL_REDUX
	; if ENABLE_FULL_REDUX is enabled, the options below will
	; be enabled. This is the easiest way to enable everything.
	.ifndef RESIZE_RING_BOX
		; determines whether to update the ring box sizes with
		; the values under the RESIZE_RING_BOX define below.
		.define RESIZE_RING_BOX				1
	.endif
	.ifndef EXTENDED_RING_BOX
		; determines whether the set of "extended" values
		; will be used when RESIZE_RING_BOX is defined
		.define EXTENDED_RING_BOX			1
	.endif
	.ifndef ENABLE_REDUX_EXTRAS
		; whether to enable all the extra redux features below
		.define ENABLE_REDUX_EXTRAS			1
	.endif
.endif

.ifdef ENABLE_REDUX_EXTRAS
	; if ENABLE_REDUX_EXTRAS is enabled, the options below will
	; be enabled(except the commented-out ones starting with ';')
	.ifndef ENABLE_PUNCH_WITH_ITEM
		; determines whether the Fist/Expert's Ring requires
		; only one empty hand to punch instead of both
		.define ENABLE_PUNCH_WITH_ITEM			1
	.endif
	.ifndef ONE_HANDED_BIGGORON_SWORD
		; determines whether the Biggoron's Sword occupies 1 hand instead of 2
;		.define ONE_HANDED_BIGGORON_SWORD		1 	; keeping here for documentation
	.endif
	.ifndef ENABLE_DOUBLE_HEART_CAP
		; determines whether link's max heart count is doubled to 32.
		.define ENABLE_DOUBLE_HEART_CAP			1
	.endif
	.ifndef ADVANCE_SHOP_ALWAYS_OPEN
		; determines whether the advance shop is open even on GBC
		.define ADVANCE_SHOP_ALWAYS_OPEN			1
	.endif
	.ifndef NEW_GAME_PLUS_NEEDS_COMPLETION
		; determines whether a NG+ file can only be started from a completed file.
		.define NEW_GAME_PLUS_NEEDS_COMPLETION	1
	.endif
	.ifndef WIDE_INVENTORY_SPRITES
		; determines whether the inventory items are 2 or 3 tiles wide
		.define WIDE_INVENTORY_SPRITES			1
	.endif
	.ifndef FILE_MENU_SHOW_CURRENT_HEARTS
		; determines whether the save menu shows the number of
		; hearts link actually has full instead of the default
		; behavior of showing them all full
		.define FILE_MENU_SHOW_CURRENT_HEARTS	1
	.endif
	.ifndef ENABLE_MULTI_RING
		; determines whether you can equip multiple rings at once
		.define ENABLE_MULTI_RING	1
	.endif
	.ifndef MORE_RUPEE_TYPES
		; determines whether a 10 rupee and 30 rupee are added to the drop tables.
		.define MORE_RUPEE_TYPES				1
	.endif
	.ifndef ENABLE_QUICK_ITEM_DROP
		; determines whether holding the item button after pulling out a
		; bomb or picking something up causes link to instantly drop it.
		; if the ring redux is also enabled, this effect is limited to
		; only occuring if the Haste Ring is equipped
		.define ENABLE_QUICK_ITEM_DROP 			1
	.endif
	.ifndef ENABLE_PORTAL_RING_BOX
		; determines whether to allow entering the ring list from
		; the inventory by clicking the ring box. if the ring redux
		; is enabled, this is on by default, as Vasu's Ring does this.
		.define ENABLE_PORTAL_RING_BOX			1
	.endif
	.ifndef INCREASE_WALLET_SIZE
		; determines whether or not the wallet size gets increased from
		; 999 rupees/ore chunks to the MAX_WALLET_SIZE amount defined below
		.define INCREASE_WALLET_SIZE			1
	.endif
	.ifndef REMAP_RING_LIST
		; determines whether or not the ring list gets updated to
		; use a more aesthetically pleasing and logical arrangement
		.define REMAP_RING_LIST					1
	.endif
	.ifndef PORTAL_RING_BOX_LEVEL
		; determines what ring box level will allow you to open the ring
		; list without needing Vasu's Ring to be equipped. If you want
		; to stick with a 5-ring box, you could have level 3 be a portal box
		; NOTE: Setting to a value other than 0, 1, 2, or 3 is unsupported.
		.define PORTAL_RING_BOX_LEVEL			3
	.endif
	.ifndef UNRESTRICTED_TRANSFORMS
		; normally the transforms swap link with a different SpecialObject
		; which has a very limited set of actions it can perform, and is
		; prevented from using any items. we remove this restriction by
		; never swapping link out, and instead remapping his sprites on
		; a case-by-case basis for each action he may be performing.
		; determines whether to enable this or now
		.define UNRESTRICTED_TRANSFORMS			1
	.endif
	.ifndef MAGNET_GLOVES_CAN_PUSH_ENEMIES
		; normally the magnet gloves are restricted to pulling enemies, but
		; being able to push them away is a nice feature sometimes.
		.define MAGNET_GLOVES_CAN_PUSH_ENEMIES	1
	.endif
.endif

.ifdef RESIZE_RING_BOX
	; NOTE: These are the sizes of each level of ring box.
	;		Do not go over 5 rings for non-extended box
	;		sizes, nor 10 rings for extended box sizes.
	.ifdef EXTENDED_RING_BOX
		.define RING_BOX_L1_SIZE		3
		.define RING_BOX_L2_SIZE		5
		.define RING_BOX_L3_SIZE		10
	.else
		.define RING_BOX_L1_SIZE		2
		.define RING_BOX_L2_SIZE		4
		.define RING_BOX_L3_SIZE		5
	.endif
.endif

.ifdef INCREASE_WALLET_SIZE
	; NOTE: do not go over $9999
	.define MAX_WALLET_SIZE 			$9999
.endif


;--------------------------------------------------------------------
;  WARNING: DO NOT TOUCH ANYTHING BELOW THIS LINE
;			Code below here is not meant to be configued.
;			We're simply setting up dependent defines.
;--------------------------------------------------------------------


.ifdef ENABLE_FULL_REDUX
.ifndef ENABLE_RING_REDUX
	.define ENABLE_RING_REDUX			1
.endif
.endif
