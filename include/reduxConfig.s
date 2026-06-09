;;
; NOTE: This file contains the config definitions for controlling various
;		aspects of the redux mod and things associated with it.
;;

.ifdef ENABLE_FULL_REDUX
	.ifndef ENABLE_REDUX_EXTRAS
		.define ENABLE_REDUX_EXTRAS			1
	.endif
	.ifndef ENABLE_RING_REDUX
		.define ENABLE_RING_REDUX			1
	.endif
	.ifndef RESIZE_RING_BOX
		.define RESIZE_RING_BOX				1
	.endif
	.ifndef EXTENDED_RING_BOX
		.define EXTENDED_RING_BOX			1
	.endif
.endif

.ifdef ENABLE_REDUX_EXTRAS
	.ifndef ENABLE_PUNCH_WITH_ITEM
		.define ENABLE_PUNCH_WITH_ITEM			1
	.endif
	.ifndef ONE_HANDED_BIGGORON_SWORD
;		.define ONE_HANDED_BIGGORON_SWORD		1 	; keeping here for documentation
	.endif
	.ifndef ENABLE_DOUBLE_HEART_CAP
		.define ENABLE_DOUBLE_HEART_CAP			1
	.endif
	.ifndef NEW_GAME_PLUS_NEEDS_COMPLETION
		.define NEW_GAME_PLUS_NEEDS_COMPLETION	1
	.endif
	.ifndef ENABLE_NEW_GAME_PLUS
		.define ENABLE_NEW_GAME_PLUS			1
	.endif
	.ifndef FILE_MENU_SHOW_CURRENT_HEARTS
		.define FILE_MENU_SHOW_CURRENT_HEARTS	1
	.endif
	.ifndef MORE_RUPEE_TYPES
		.define MORE_RUPEE_TYPES				1
	.endif
	.ifndef ENABLE_QUICK_ITEM_DROP
		.define ENABLE_QUICK_ITEM_DROP 			1
	.endif
	.ifndef ENABLE_PORTAL_RING_BOX
		.define ENABLE_PORTAL_RING_BOX			1
	.endif
	.ifndef INCREASE_WALLET_SIZE
		.define INCREASE_WALLET_SIZE			1
	.endif
	.ifndef REMAP_RING_LIST
		.define REMAP_RING_LIST					1
	.endif
	.ifndef PORTAL_RING_BOX_LEVEL
		; If your ring box is at least this level, you'll be able to open the
		; ring list without needing Vasu's Ring to be equipped. If you want
		; to stick with a 5-ring box, you could have level 3 be a portal box
		; NOTE: Setting to a value other than 0, 1, 2, or 3 won't do anything.
		.define PORTAL_RING_BOX_LEVEL			3
	.endif
	.ifndef UNRESTRICTED_TRANSFORMS
		; normally the transforms swap link with a different SpecialObject
		; which has a very limited set of actions it can perform, and is
		; prevented from using any items. we remove this restriction by
		; never swapping link out, and instead remapping his sprites on
		; a case-by-case basis for each action he may be performing.
		.define UNRESTRICTED_TRANSFORMS			1
	.endif
	.ifndef MAGNET_GLOVES_CAN_PUSH_ENEMIES
		; normally the magnet gloves are restricted to pulling enemies, but
		; being able to push them away is a nice feature sometimes.
		.define MAGNET_GLOVES_CAN_PUSH_ENEMIES	1
	.endif
.endif