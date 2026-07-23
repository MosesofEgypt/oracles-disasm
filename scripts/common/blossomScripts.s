; ==================================================================================================
; INTERAC_BLOSSOM
; ==================================================================================================

; Blossom asking you to name her child
blossomScript0:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $00
	jumpifobjectbyteeq Interaction.var3b, $01, @nameAlreadyGiven
@loop:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4400

@askForName:
	asm15 scriptHelp.blossom_openNameEntryMenu
	wait 30
	jumptable_memoryaddress wTextInputResult
	.dw @validName
	.dw @invalidName

@invalidName:
	showtextlowindex <TX_440a
.if defined(REGION_JP) && defined(ROM_AGES)
	enableallobjects
.else
	enableinput
.endif
	scriptjump @loop

@validName:
	showtextlowindex <TX_4407
.if !defined(REGION_JP) && defined(ROM_AGES)
	disableinput
.endif
	jumptable_memoryaddress wSelectedTextOption
	.dw @nameConfirmed
	.dw @askForName

@nameConfirmed:
	asm15 scriptHelp.blossom_decideInitialChildStatus
	asm15 scriptHelp.setc6e2Bit, $00
	asm15 scriptHelp.setNextChildStage, $01
	wait 30
	showtextlowindex <TX_4408
.if defined(REGION_JP) && defined(ROM_AGES)
	enableallobjects
.else
	enableinput
.endif

@nameAlreadyGiven:
	checkabutton
	showtextlowindex <TX_4409
	scriptjump @nameAlreadyGiven


; Blossom asking for money to see a doctor
blossomScript1:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $01
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveMoney
@loop:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_440b
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes
	.dw @selectedNo
@selectedYes:
	wait 30
	showtextlowindex <TX_440c
	jumptable_memoryaddress wSelectedTextOption
	.dw @give150Rupees
	.dw @give50Rupees
	.dw @give10Rupees
	.dw @give1Rupee

@give150Rupees:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_150
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_150
	asm15 scriptHelp.blossom_addValueToChildStatus, $08
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave150RupeesLoop:
	showtextlowindex <TX_440d
	checkabutton
	scriptjump @gave150RupeesLoop

@give50Rupees:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_050
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_050
	asm15 scriptHelp.blossom_addValueToChildStatus, $05
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave50RupeesLoop:
	showtextlowindex <TX_440e
	checkabutton
	scriptjump @gave50RupeesLoop

@give10Rupees:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_010
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_010
	asm15 scriptHelp.blossom_addValueToChildStatus, $02
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave10RupeesLoop:
	showtextlowindex <TX_440f
	checkabutton
	scriptjump @gave10RupeesLoop

@give1Rupee:
	asm15 scriptHelp.blossom_checkHasRupees, RUPEEVAL_001
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_001
	asm15 scriptHelp.setc6e2Bit, $01
	asm15 scriptHelp.setNextChildStage, $02
	enableallobjects
@gave1RupeeLoop:
	showtextlowindex <TX_4410
	checkabutton
	scriptjump @gave1RupeeLoop

@notEnoughRupees:
	wait 30
	showtextlowindex <TX_4432
	enableallobjects
	scriptjump @loop

@selectedNo:
	wait 30
	showtextlowindex <TX_4411
	enableallobjects
	scriptjump @loop

@alreadyGaveMoney:
	checkabutton
	showtextlowindex <TX_4431
	scriptjump @alreadyGaveMoney


; Blossom tells you that the baby has gotten better
blossomScript2:
	initcollisions
script4e08:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4412
	asm15 scriptHelp.setNextChildStage, $03
	enableallobjects
	scriptjump script4e08


; Blossom asks you how to get the baby to sleep
blossomScript3:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $02
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveAdvice
	checkabutton

	setdisabledobjectsto91
	showtextlowindex <TX_4413

	asm15 scriptHelp.setc6e2Bit, $02
	asm15 scriptHelp.setNextChildStage, $04

	jumptable_memoryaddress wSelectedTextOption
	.dw @sing
	.dw @play

@sing:
	wait 30
	showtextlowindex <TX_4414
	enableallobjects
	scriptjump @alreadyGaveAdvice
@play:
	wait 30
	showtextlowindex <TX_4415
	asm15 scriptHelp.blossom_addValueToChildStatus, $0a
	enableallobjects

@alreadyGaveAdvice:
	checkabutton
	showtextlowindex <TX_4416
	scriptjump @alreadyGaveAdvice


; Blossom tells you that the child has grown
blossomScript4:
	rungenericnpclowindex <TX_4417


; Blossom says "we meet again" (linked file?)
blossomScript5:
	rungenericnpclowindex <TX_4418


; Blossom asks Link what he was like when he was a kid. (var03 is set to the child's
; current personality.)
blossomScript6:
	initcollisions
	asm15 scriptHelp.checkc6e2BitSet, $03
	jumptable_objectbyte Interaction.var03
	.dw @hyperactive
	.dw @shy
	.dw @curious

@hyperactive:
	jumpifobjectbyteeq Interaction.var3b, $01, @hyperactiveResponseReceived

@hyperactiveLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_4419
	callscript @askAboutLinksBehaviour
	enableallobjects
	jumpifobjectbyteeq Interaction.var3a, $00, @hyperactiveLoop1

@hyperactiveResponseReceived:
	checkabutton
	showtextlowindex <TX_4422
	scriptjump @hyperactiveResponseReceived


@shy:
	jumpifobjectbyteeq Interaction.var3b, $01, @shyReponseReceived

@shyLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_441a
	callscript @askAboutLinksBehaviour
	enableallobjects
	jumpifobjectbyteeq Interaction.var3a, $00, @shyLoop1

@shyReponseReceived:
	checkabutton
	showtextlowindex <TX_4423
	scriptjump @shyReponseReceived


@curious:
	jumpifobjectbyteeq Interaction.var3b, $01, @curiousResponseReceived

@curiousLoop1:
	checkabutton
	setdisabledobjectsto91
	showtextlowindex <TX_441b
	callscript @askAboutLinksBehaviour
	enableallobjects
	jumpifobjectbyteeq Interaction.var3a, $00, @curiousLoop1

@curiousResponseReceived:
	checkabutton
	showtextlowindex <TX_4424
	scriptjump @curiousResponseReceived


; Blossom asks about how Link was as a child. She asks a few things before giving up.
; If Link said yes to something, var3a will be set to 1, indicating to the script that she
; got a response.
@askAboutLinksBehaviour:
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes_1
	.dw @selectedNo_1

@selectedYes_1:
	wait 30
	showtextlowindex <TX_441c
	asm15 scriptHelp.setc6e2Bit, $03
	writeobjectbyte Interaction.var3a, $01
	asm15 scriptHelp.blossom_addValueToChildStatus, $08
	retscript

@selectedNo_1: ; Quiet, perhaps?
	wait 30
	showtextlowindex <TX_441d
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes_2
	.dw @selectedNo_2

@selectedYes_2:
	wait 30
	showtextlowindex <TX_441e
	asm15 scriptHelp.setc6e2Bit, $03
	writeobjectbyte Interaction.var3a, $01
	asm15 scriptHelp.blossom_addValueToChildStatus, $05
	retscript

@selectedNo_2: ; Were you weird?
	wait 30
	showtextlowindex <TX_441f
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes_3
	.dw @selectedNo_3

@selectedYes_3:
	wait 30
	showtextlowindex <TX_4420
	asm15 scriptHelp.setc6e2Bit, $03
	writeobjectbyte Interaction.var3a, $01
	asm15 scriptHelp.blossom_addValueToChildStatus, $01
	retscript

@selectedNo_3: ; She gives up asking (but she'll ask again next time you talk)
	wait 30
	showtextlowindex <TX_4421
	wait 30
	retscript


; Blossom tells you about how her son's grown?
blossomScript7:
	jumptable_objectbyte Interaction.var03
	.dw @slacker
	.dw @warrior
	.dw @arborist
	.dw @singer
@slacker:
	rungenericnpclowindex <TX_4425
@warrior:
	rungenericnpclowindex <TX_4426
@arborist:
	rungenericnpclowindex <TX_4427
@singer:
	rungenericnpclowindex <TX_4428


; Blossom tells you more specifically about her son's ambitions?
blossomScript8:
	jumptable_objectbyte Interaction.var03
	.dw @slacker
	.dw @warrior
	.dw @arborist
	.dw @singer
@slacker:
	rungenericnpclowindex <TX_4429
@warrior:
	rungenericnpclowindex <TX_442a
@arborist:
	rungenericnpclowindex <TX_442b
@singer:
	rungenericnpclowindex <TX_442c


; Blossom tells you about what her son has accomplished?
blossomScript9:
	jumptable_objectbyte Interaction.var03
	.dw @slacker
	.dw @warrior
	.dw @arborist
	.dw @singer
@slacker:
	rungenericnpclowindex <TX_442d
@warrior:
	rungenericnpclowindex <TX_442e
@arborist:
	rungenericnpclowindex <TX_442f
@singer:
	rungenericnpclowindex <TX_4430

