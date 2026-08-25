; ==================================================================================================
; INTERAC_SYRUP
; ==================================================================================================
.if defined(ROM_SEASONS)
syrupScript_notTradedMushroomYet:
	checkabutton
	showtext TX_0b3e
	jumpiftradeitemeq $08, @haveMushroom
	scriptjump syrupScript_notTradedMushroomYet
@haveMushroom:
	setdisabledobjectsto91
	wait 30
-
	showtext TX_0b3f
	jumpiftextoptioneq $00, @tradingMushroom
	wait 30
	showtext TX_0b42
	enableallobjects
	checkabutton
	setdisabledobjectsto91
	scriptjump -
@tradingMushroom:
	wait 30
	disableinput
	giveitem TREASURE_TRADEITEM, $09
	wait 30
	showtext TX_0b40
	orroomflag $40
	enableinput
-
	checkabutton
	showtext TX_0b41
	scriptjump -
.endif

syrupScript_spawnShopItems:
	spawninteraction INTERAC_SHOP_ITEM, $0b, $28, $44
	spawninteraction INTERAC_SHOP_ITEM, $07, $28, $4c
	spawninteraction INTERAC_SHOP_ITEM, $08, $28, $74
	scriptend

syrupScript_showWelcomeText:
	showtext TX_0d00
	scriptend

; "We're closed"
syrupScript_showClosedText:
	showtext TX_0d0b
	scriptend

syrupScript_purchaseItem:
.if defined(ROM_AGES)
	jumptable_objectbyte Interaction.var37
.else
	jumptable_objectbyte Interaction.var38
.endif
	.dw @buyMagicPotion
	.dw @buyGashaSeed
	.dw @buyMagicPotion
	.dw @buyGashaSeed
	.dw @buyBombchus

@buyMagicPotion:
	showtextnonexitable TX_0d01
	scriptjump @checkAcceptPurchase

@buyGashaSeed:
	showtextnonexitable TX_0d05
	scriptjump @checkAcceptPurchase

@buyBombchus:
	showtextnonexitable TX_0d0a
.if defined(ROM_SEASONS) && !defined(ROM_COMBO)
	scriptjump @checkAcceptPurchase
.endif

@checkAcceptPurchase:
	jumpiftextoptioneq $00, @tryToPurchase

	; Said "no" when asked to purchase
.if defined(ROM_AGES)
	writeobjectbyte Interaction.var3a, $ff
.else
	writeobjectbyte Interaction.var3b, $ff
.endif
	writememory wcbad, $03
	writememory wTextIsActive, $01
	scriptend

@tryToPurchase:
.if defined(ROM_AGES)
	jumpifmemoryeq wShopHaveEnoughRupees, $00, @enoughRupees
	writeobjectbyte Interaction.var3a, $ff
.else
	jumptable_objectbyte Interaction.var39
	.dw @enoughRupees
	.dw @notEnoughRupees
@notEnoughRupees:
	writeobjectbyte Interaction.var3b, $ff
.endif
	writememory wcbad, $01
	writememory wTextIsActive, $01
	scriptend

@enoughRupees:
.if defined(ROM_AGES)
	jumptable_objectbyte Interaction.var38
	.dw @buy
	.dw shopkeeperCantBuy
@buy:
	writeobjectbyte Interaction.var3a, $01
.else
	jumptable_objectbyte Interaction.var3a
	.dw @buy
	.dw @shopkeeperCantBuy
@buy:
	writeobjectbyte Interaction.var3b, $01
.endif
	writememory wcbad, $00
	writememory wTextIsActive, $01
	scriptend
.if defined(ROM_SEASONS)
@shopkeeperCantBuy:
	writeobjectbyte Interaction.var3b, $ff
	writememory wcbad, $02
	writememory wTextIsActive, $01
	scriptend
.endif