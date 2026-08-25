; ==================================================================================================
; INTERAC_CHILD
; ==================================================================================================

; For a summary of the child's behaviour, see:
; http://wiki.zeldahacking.net/oracle/Bipin_and_Blossom's_son

childScript00:
	scriptend

childScript_stage4_hyperactive:
	initcollisions
@loop:
	checkabutton
	showtext TX_4700
	scriptjump @loop

childScript_stage4_shy:
	initcollisions
@loop:
	checkabutton
	showtext TX_4200
	scriptjump @loop

childScript_stage4_curious:
	initcollisions
@loop:
	checkabutton
	showtext TX_4900
	scriptjump @loop


childScript_stage5_hyperactive:
	initcollisions
@loop:
	checkabutton
	showtext TX_4701
	asm15 {SCRIPTS_HELP}.setNextChildStage, $06
	scriptjump @loop

childScript_stage5_shy:
	initcollisions
@loop:
	checkabutton
	showtext TX_4201
	asm15 {SCRIPTS_HELP}.setNextChildStage, $06
	scriptjump @loop

childScript_stage5_curious:
	initcollisions
@loop:
	checkabutton
	showtext TX_4901
	asm15 {SCRIPTS_HELP}.setNextChildStage, $06
	scriptjump @loop


; Stage 6: the child asks a question. The question differs based on his personality, but
; the result is always the same: wChildStatus is incremented by 4 if you answer yes.

childScript_stage6_hyperactive:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $04
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4702
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $04
	asm15 {SCRIPTS_HELP}.setNextChildStage, $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4703
	asm15 {SCRIPTS_HELP}.child_addValueToChildStatus, $04
	enableinput
	scriptjump @alreadyAnswered

@answeredNo:
	wait 30
	showtext TX_4704
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4705
	scriptjump @alreadyAnswered


childScript_stage6_shy:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $04
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4202
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $04
	asm15 {SCRIPTS_HELP}.setNextChildStage, $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4203
	asm15 {SCRIPTS_HELP}.child_addValueToChildStatus, $04
	enableinput
	scriptjump @alreadyAnswered

@answeredNo:
	wait 30
	showtext TX_4204
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4205
	scriptjump @alreadyAnswered


childScript_stage6_curious:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $04
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4902
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $04
	asm15 {SCRIPTS_HELP}.setNextChildStage, $07
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredChicken
	.dw @answeredEgg

@answeredChicken:
	wait 30
	showtext TX_4903
	asm15 {SCRIPTS_HELP}.child_addValueToChildStatus, $04
	enableinput
	scriptjump @alreadyAnswered

@answeredEgg:
	wait 30
	showtext TX_4904
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4905
	scriptjump @alreadyAnswered


; Stage 7: just says some text.

childScript_stage7_slacker:
	initcollisions
@loop:
	checkabutton
	showtext TX_4b00
	asm15 {SCRIPTS_HELP}.setNextChildStage, $08
	scriptjump @loop

childScript_stage7_warrior:
	initcollisions
@loop:
	checkabutton
	showtext TX_4a00
	asm15 {SCRIPTS_HELP}.setNextChildStage, $08
	scriptjump @loop

childScript_stage7_arborist:
	initcollisions
@loop:
	checkabutton
	showtext TX_4800
	asm15 {SCRIPTS_HELP}.setNextChildStage, $08
	scriptjump @loop

childScript_stage7_singer:
	initcollisions
@loop:
	checkabutton
	showtext TX_4600
	asm15 {SCRIPTS_HELP}.setNextChildStage, $08
	scriptjump @loop


; Stage 8: asks a question or makes a request. This affects what he will do in stage 9.

childScript_stage8_slacker:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered

@loop:
	checkabutton
	disableinput
	showtext TX_4b01
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredYes
	.dw @answeredNo

@answeredYes:
	wait 30
	showtext TX_4b02
	jumptable_memoryaddress wSelectedTextOption
	.dw @answered100Rupees
	.dw @answered50Rupees
	.dw @answered10Rupees
	.dw @answered0Rupees

@answered100Rupees:
	asm15 {SCRIPTS_HELP}.child_checkHasRupees, RUPEEVAL_100
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_100
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $00
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	enableinput
@answered100Loop:
	showtext TX_4b04
	checkabutton
	scriptjump @answered100Loop

@answered50Rupees:
	asm15 {SCRIPTS_HELP}.child_checkHasRupees, RUPEEVAL_050
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_050
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $01
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	enableinput
@answered50Loop:
	showtext TX_4b05
	checkabutton
	scriptjump @answered50Loop

@answered10Rupees:
	asm15 {SCRIPTS_HELP}.child_checkHasRupees, RUPEEVAL_010
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_010
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $02
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	enableinput
@answered10Loop:
	showtext TX_4b06
	checkabutton
	scriptjump @answered10Loop

@answered0Rupees: ; He takes 1 rupee anyway...
	asm15 {SCRIPTS_HELP}.child_checkHasRupees, RUPEEVAL_001
	jumpifobjectbyteeq Interaction.var3c, $01, @notEnoughRupees
	asm15 removeRupeeValue, RUPEEVAL_001
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $03
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	enableinput
@answered0Loop:
	showtext TX_4b07
	checkabutton
	scriptjump @answered0Loop

@notEnoughRupees:
	wait 30
	showtext TX_4b08
	enableinput
	scriptjump @loop

@answeredNo:
	wait 30
	showtext TX_4b03
	enableinput
	scriptjump @loop

@alreadyAnswered:
	checkabutton
	showtext TX_4b09
	scriptjump @alreadyAnswered


; Asks Link what will make him mightiest.
childScript_stage8_warrior:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered
	checkabutton
	disableinput
	showtext TX_4a01
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredDailyTraining
	.dw @answeredNo_1

@answeredNo_1:
	wait 30
	showtext TX_4a02
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredNaturalTalent
	.dw @answeredNo_2

@answeredNo_2:
	wait 30
	showtext TX_4a03
	jumptable_memoryaddress wSelectedTextOption
	.dw @answeredCaringHeart
	.dw @answeredNo_3

@answeredNo_3: ; He gives up asking
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $03
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	showtext TX_4a04
	enableinput
	wait 30
	scriptjump @alreadyAnswered

@answeredDailyTraining:
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $00
	scriptjump @gaveResponse

@answeredNaturalTalent:
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $01
	scriptjump @gaveResponse

@answeredCaringHeart:
	asm15 {SCRIPTS_HELP}.child_setStage8Response, $02

@gaveResponse:
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	showtext TX_4a05
	wait 30
	enableinput

@alreadyAnswered:
	checkabutton
	showtext TX_4a08
	scriptjump @alreadyAnswered


; Gives Link a gasha seed.
childScript_stage8_arborist:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveSeed

	checkabutton
	disableinput
	showtext TX_4801
	giveitem TREASURE_GASHA_SEED, $03
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	showtext TX_4802
	wait 30
	enableinput

@alreadyGaveSeed:
	checkabutton
	showtext TX_4803
	scriptjump @alreadyGaveSeed


; Asks link what's more important, love or courage.
childScript_stage8_singer:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $05
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyAnswered

	checkabutton
	disableinput
	showtext TX_4601
	asm15 {SCRIPTS_HELP}.child_setStage8ResponseToSelectedTextOption, $00
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $05
	asm15 {SCRIPTS_HELP}.setNextChildStage, $09
	wait 30
	enableinput
	scriptjump @showResponseText

@alreadyAnswered:
	checkabutton
@showResponseText:
	showtext TX_4602
	scriptjump @alreadyAnswered


; Stage 9: the child gives a reward based on your response in stage 8.

childScript_stage9_slacker:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $06
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveReward
	checkabutton
	disableinput
	showtext TX_4b0a
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $06
	wait 30
	jumptable_memoryaddress wChildStage8Response
	.dw @fillSatchel
	.dw @give200Rupees
	.dw @giveGashaSeed
	.dw @give10Bombs

@fillSatchel:
	asm15 refillSeedSatchel
	showtext TX_0052
	scriptjump @justGaveReward

@give200Rupees:
	asm15 {SCRIPTS_HELP}.child_giveRupees, RUPEEVAL_200
	showtext TX_0009
	scriptjump @justGaveReward

@giveGashaSeed:
	giveitem TREASURE_GASHA_SEED, $03
	scriptjump @justGaveReward

@give10Bombs:
	giveitem TREASURE_BOMBS, $02

@justGaveReward:
	wait 30
	enableinput
	scriptjump @showTextAfterGiving

@alreadyGaveReward:
	checkabutton
@showTextAfterGiving:
	showtext TX_4b0b
	scriptjump @alreadyGaveReward


childScript_stage9_warrior:
	initcollisions
	asm15 {SCRIPTS_HELP}.checkc6e2BitSet, $06
	jumpifobjectbyteeq Interaction.var3b, $01, @alreadyGaveReward
	checkabutton
	disableinput
	showtext TX_4a06
	wait 30
	showtext TX_4a07
	asm15 {SCRIPTS_HELP}.setc6e2Bit, $06
	wait 30
	jumptable_memoryaddress wChildStage8Response
	.dw @give100Rupees
	.dw @give1Heart
	.dw @restoreHealth
	.dw @give1Rupee

@give100Rupees:
	asm15 {SCRIPTS_HELP}.child_giveRupees, RUPEEVAL_100
	showtext TX_0007
	scriptjump @justGaveReward

@give1Heart:
	asm15 {SCRIPTS_HELP}.child_giveOneHeart, $01
	showtext TX_0051
	scriptjump @justGaveReward

@restoreHealth:
	asm15 {SCRIPTS_HELP}.child_giveHeartRefill
	showtext TX_0053
	scriptjump @justGaveReward

@give1Rupee:
	asm15 {SCRIPTS_HELP}.child_giveRupees, RUPEEVAL_001
	showtext TX_0001

@justGaveReward:
	wait 30
	enableinput
	scriptjump @showTextAfterGiving

@alreadyGaveReward:
	checkabutton
@showTextAfterGiving:
	showtext TX_4a08
	scriptjump @alreadyGaveReward


childScript_stage9_arborist:
	initcollisions
@loop:
	checkabutton
	disableinput
	showtext TX_4804
	wait 30
	callscript @showTip
	enableinput
	scriptjump @loop

@showTip:
	writeobjectbyte Interaction.textID+1, >TX_4800
	getrandombits   Interaction.textID,   $07
	addobjectbyte   Interaction.textID,   <TX_4805
	showloadedtext
	retscript


childScript_stage9_singer:
	initcollisions
@loop:
	checkabutton
	disableinput
	showtext TX_4603
	jumptable_memoryaddress wSelectedTextOption
	.dw @selectedYes
	.dw @selectedNo

@selectedYes:
	asm15 {SCRIPTS_HELP}.child_playMusic
	asm15 {SCRIPTS_HELP}.child_giveHeartRefill
	wait 30
	enableinput

@singingLoop:
	showtext TX_4604
	checkabutton
	scriptjump @singingLoop

@selectedNo:
	wait 30
	showtext TX_4605
	enableinput
	scriptjump @loop

