
; ==================================================================================================
; INTERAC_BIPIN
; ==================================================================================================

; Running around when baby just born
bipinScript0:
	setcollisionradii $06, $06
	makeabuttonsensitive
@loop:
	checkabutton
	jumpifmemoryeq wChildStatus, $00, @stillUnnamed
	showtext TX_4301
	scriptjump @loop
@stillUnnamed:
	showtext TX_4300
	scriptjump @loop


; Bipin gives you a random tip
bipinScript1:
	initcollisions
@loop:
	checkabutton
	setdisabledobjectsto91
	setanimation $02
	asm15 {SCRIPTS_HELP}.bipin_showText_subid1To9
	wait 30
	callscript bipinSayRandomTip
	enableallobjects
	scriptjump @loop


; Bipin just moved to Labrynna/Holodrum?
bipinScript2:
	initcollisions
@loop:
	checkabutton
	setdisabledobjectsto91
	asm15 {SCRIPTS_HELP}.bipin_showText_subid1To9
	enableallobjects
	scriptjump @loop

bipinSayRandomTip:
	; Show a random text index from TX_4309-TX_4310
	writeobjectbyte  Interaction.textID+1, >TX_4300
	getrandombits    Interaction.textID,   $07
	addobjectbyte    Interaction.textID,   <TX_4309
	showloadedtext

	setanimation $03
	retscript


.if defined(ROM_AGES)
; "Past" version of Bipin who gives you a gasha seed
bipinScript3:
	loadscript {SCRIPTS_HELP}.bipinScript3
.endif