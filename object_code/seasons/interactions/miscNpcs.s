; ==================================================================================================
; INTERAC_MAYORS_HOUSE_NPC
; INTERAC_MRS_RUUL
; INTERAC_MR_WRITE
; INTERAC_FICKLE_LADY
; INTERAC_MALON
; INTERAC_BATHING_SUBROSIANS
; INTERAC_MASTER_DIVERS_SON
; INTERAC_FICKLE_MAN
; INTERAC_DUNGEON_WISE_OLD_MAN
; INTERAC_TREASURE_HUNTER
; INTERAC_3a (unused)
; INTERAC_OLD_LADY_FARMER
; INTERAC_FOUNTAIN_OLD_MAN
; INTERAC_TICK_TOCK
; ==================================================================================================
m_InteractionCode $24
m_InteractionCode $29
m_InteractionCode $2c
m_InteractionCode $2d
m_InteractionCode $2f
m_InteractionCode $33
m_InteractionCode $36
m_InteractionCode $37
m_InteractionCode $38
m_InteractionCode $39
m_InteractionCode $3a
m_InteractionCode $3c
m_InteractionCode $3d
m_InteractionCode $3f
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw miscNPC_state0
	.dw miscNPC_state1
miscNPC_state0:
	ld a,$01
	ld (de),a
	ld h,d
	ld l,$42
	ldi a,(hl)
	bit 7,a
	jr z,+
	; bit 7 in subid checked for in state1
	ldd (hl),a
	and $7f
	ld (hl),a
+
	call checkHoronVillageNPCShouldBeSeen
	jr nz,+
	jp nc,interactionDelete
	jr ++
+
	call getSunkenCityNPCVisibleSubId
	jr nz,+++
	ld e,$42
	ld a,(de)
	cp b
	jp nz,interactionDelete
++
	ld e,$42
	ld a,b
	ld (de),a
+++
	call interactionInitGraphics
	ld e,$41
	ld a,(de)
	cp INTERAC_MAYORS_HOUSE_NPC
	jr nz,+
	call checkMayorsHouseNPCshouldBeSeen
	jp z,interactionDelete
+
	sub $24
	ld hl,miscNPC_scriptTable
	rst_addDoubleIndex
	rst_derefHl
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	rst_derefHl
	call interactionSetScript
	ld e,$41
	ld a,(de)
	cp INTERAC_DUNGEON_WISE_OLD_MAN
	jp z,dungeonWiseOldMan_textLookup
	cp INTERAC_MR_WRITE
	jp z,mrWrite_spawnLightableTorch
	cp INTERAC_BATHING_SUBROSIANS
	call z,func_572c
	ld e,$41
	ld a,(de)
	cp INTERAC_MASTER_DIVERS_SON
	call z,func_572c
func_5723:
	xor a
	ld h,d
	ld l,$78
	ldi (hl),a
	ld (hl),a
	jp interactionAnimateAsNpc

func_572c:
	call interactionRunScript
	jp interactionRunScript

mrWrite_spawnLightableTorch:
	call getThisRoomFlags
	and $40
	jr z,+
	jp func_5723
+
	call getFreePartSlot
	jr nz,+
	ld (hl),PART_LIGHTABLE_TORCH
	ld l,$cb
	ld (hl),$38
	ld l,$cd
	ld (hl),$68
+
	jp func_5723

dungeonWiseOldMan_textLookup:
	ld e,$42
	ld a,(de)
	or a
	jr nz,@ret
	ld a,(wDungeonIndex)
	dec a
	bit 7,a
	jr z,+
	xor a
+
	ld hl,@textLookup
	rst_addAToHl
	ld e,$72
	ld a,(hl)
	ld (de),a
	inc e
	ld a,>TX_3300
	ld (de),a
@ret:
	jp func_5723
@textLookup:
	.db <TX_3300, $00, $00,      <TX_3301
	.db $00,      $00, $00,      $00
	.db $00,      $00, <TX_3302

;;
; @param[out]	zflag	set if NPC should not be seen
checkMayorsHouseNPCshouldBeSeen:
	; mayor disappears if unlinked game beat
	; or seen villagers, but not zelda kidnapped
	ld e,$42
	ld a,(de)
	ld b,a
	call checkIsLinkedGame
	jr z,@unlinked
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	jr z,@xor01IfMayorElsexorA
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	jr z,@xorARet
	jr @xor01IfMayorElsexorA
@unlinked:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	jr z,@xor01IfMayorElsexorA
	ld a,b
	cp $03
	jr nz,@xorARet
	; unlinked game beat - woman in mayor's house
	jr @xor01
@xor01IfMayorElsexorA:
	ld a,b
	cp $03
	jr z,@xorARet
@xor01:
	ld e,$41
	ld a,(de)
	xor $01
	ret
@xorARet:
	xor a
	ret

miscNPC_state1:
	call interactionRunScript
	ld e,$43
	ld a,(de)
	and $80
	jp nz,interactionAnimateAsNpc
	jp npcFaceLinkAndAnimate

checkHoronVillageNPCShouldBeSeen:
	ld e,$41
	ld a,(de)
	ld b,$00
	cp INTERAC_FICKLE_LADY
	jr z,checkHoronVillageNPCShouldBeSeen_body@main
	inc b
	cp INTERAC_FICKLE_MAN
	jr nz,checkHoronVillageNPCShouldBeSeen_body
	ld e,$42
	ld a,(de)
	cp $06
	jr nz,checkHoronVillageNPCShouldBeSeen_body@main
	ld b,$0b
	jr checkHoronVillageNPCShouldBeSeen_body@scf

;;
; @param[out]	cflag	set if NPC is conditional and should be seen at current stage of the game
; @param[out]	zflag	unset if NPC is non-conditional
checkHoronVillageNPCShouldBeSeen_body:
	; non interactioncode2d/37 - b = $01
	inc b
	cp $3c
	jr z,@main
	inc b
	cp $3d
	ret nz

; This label is used directly in a number of places.
@main:
	; interactioncode2d - b = $00
	; interactioncode37 (except in advance shop) - b = $01
	; interactioncode3c - b = $02
	; interactioncode3d - b = $03
	; from interactioncode3e - b = $04/$05/$06
	; from interactioncode80 - b = $07
	ld a,b
	ld hl,conditionalHoronNPCLookupTable
	rst_addDoubleIndex
	rst_derefHl
	push hl
	call checkNPCStage
	pop hl
	ld e,$42
	ld a,(de)
	rst_addDoubleIndex
	rst_derefHl
-
	ldi a,(hl)
	or a
	ret z
	dec a
	cp b
	jr nz,-
@scf:
	; interactioncode37 in advance shop - b = $0b
	scf
	ret

;;
; @param[out]	b	$0a if game finished
;			$09 if at least 2nd essence gotten, less than 5 essences gotten, and not saved Zelda from Vire
;			$08 if zelda kidnapped
;			$07 if got maku seed
;			$06 if zelda villagers seen
;			$05 if 8th essence gotten
;			$04 if 5 essences gotten
;			$03 if at least 2nd essence gotten, and saved Zelda from Vire if linked
;			$02 if at least 1st essence gotten
;			$01 if no essences, but met maku tree
;			$00 if no essences, and not met maku tree
checkNPCStage:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld b,$0a
	jr nz,+
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	jr c,@essenceGotten
	ld a,GLOBALFLAG_GNARLED_KEY_GIVEN
	call checkGlobalFlag
	ld b,$01
	jr nz,+
	ld b,$00
+
	xor a
	ret
@essenceGotten:
	ld c,a
	call getNumSetBits
	ldh (<hFF8B),a
	ld a,c
	call getHighestSetBit
	ld c,a
	call checkIsLinkedGame
	jr nz,@linkedGameCheck
@regularCheck:
	ld a,c
	ld b,$05
	cp $07
	ret nc
	dec b
	ldh a,(<hFF8B)
	cp $05
	ret nc
	ld a,c
	dec b
	cp $01
	ret nc
	dec b
	ret
@linkedGameCheck:
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	ld b,$08
	ret nz
	ld a,GLOBALFLAG_GOT_MAKU_SEED
	call checkGlobalFlag
	ld b,$07
	ret nz
	ld a,GLOBALFLAG_ZELDA_VILLAGERS_SEEN
	call checkGlobalFlag
	ld b,$06
	ret nz

	ld a,c
	cp $00
	jr z,@regularCheck
	ldh a,(<hFF8B)
	cp $05
	jr nc,@regularCheck
	ld b,$09
	ld a,GLOBALFLAG_ZELDA_SAVED_FROM_VIRE
	call checkGlobalFlag
	ret z
	ld b,$03
	ret

;;
; @param[out]	zflag	nz if not interactioncode36/39
; @param[out]	b	$04 if game finished
;			$03 if zelda kidnapped seen
;			$02 if 8th essence gotten
;			$01 if 4th essence gotten
;			$00 if none of the above
;			$ff if not interaction $36 or $39
getSunkenCityNPCVisibleSubId:
	ld e,$41
	ld a,(de)
	cp INTERAC_MASTER_DIVERS_SON
	jr z,@main
	cp INTERAC_TREASURE_HUNTER
	jr z,@main
	ld a,$ff
	ret

; This label is used directly in a number of places.
@main:
	ld a,GLOBALFLAG_FINISHEDGAME
	call checkGlobalFlag
	ld b,$04
	jr nz,@xorARet
	ld a,GLOBALFLAG_ZELDA_KIDNAPPED_SEEN
	call checkGlobalFlag
	ld b,$03
	jr nz,@xorARet
	ld a,TREASURE_ESSENCE
	call checkTreasureObtained
	ld b,$00
	jr nc,@xorARet
	ld c,a
	call checkIsLinkedGame
	jr z,+
+
	ld a,c
	call getHighestSetBit
	ld b,$02
	cp $07
	ret nc
	dec b
	ld a,c
	and $08
	jr nz,@xorARet
	dec b
@xorARet:
	xor a
	ret

conditionalHoronNPCLookupTable:
	.dw @fickleLady
	.dw @fickleMan
	.dw @oldLadyFarmer
	.dw @fountainOldMan
	.dw @boyWithDog
	.dw @horonVillageBoy
	.dw @boyPlaysWithSpringBloomFlower
	.dw @otherOldMan

@fickleLady:
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
	.dw @@subid6
@@subid0:
	.db $01 $00
@@subid1:
	.db $02 $03 $04 $0a $00
@@subid2:
	.db $05 $00
@@subid3:
	.db $06 $00
@@subid4:
	.db $07 $08 $00
@@subid5:
	.db $09 $00
@@subid6:
	.db $0b $00

@fickleMan:
	.dw @@subid0
	.dw @@subid1
	.dw @@subid2
	.dw @@subid3
	.dw @@subid4
	.dw @@subid5
@@subid0:
	.db $01 $02 $0b $00
@@subid1:
	.db $03 $00
@@subid2:
	.db $04 $00
@@subid3:
	.db $0a $00
@@subid4:
	.db $05 $00
@@subid5:
	.db $06 $07 $08 $09 $00

@oldLadyFarmer:
@fountainOldMan:
@boyPlaysWithSpringBloomFlower:
	.dw @@subid0

@@subid0:
	.db $01 $02 $03 $04 $0a $05 $06 $07
	.db $08 $09 $0b $00

@horonVillageBoy:
	.dw @@table_590a
	.dw @@table_590d
	.dw @@table_5914
	.dw @@table_5917

@@table_590a:
	.db $01 $02 $00

@@table_590d:
	.db $03 $04 $0a $05 $06 $0b $00

@@table_5914:
	.db $07 $08 $00

@@table_5917:
	.db $09 $00

@boyWithDog:
	.dw @@table_5923
	.dw @@table_5927
	.dw @@table_5929
	.dw @@table_592b
	.dw @@table_592f

@@table_5923:
	.db $01 $02 $03 $00

@@table_5927:
	.db $04 $00

@@table_5929:
	.db $0a $00

@@table_592b:
	.db $05 $06 $0b $00

@@table_592f:
	.db $07 $08 $09 $00

@otherOldMan:
	.dw @@table_593b
	.dw @@table_5941
	.dw @@table_5943
	.dw @@table_5948

@@table_593b:
	.db $01 $02 $03 $04 $0a $00

@@table_5941:
	.db $05 $00

@@table_5943:
	.db $06 $07 $08 $09 $00

@@table_5948:
	.db $0b $00

miscNPC_scriptTable:
	.dw @mayorsHouseScripts
	.dw @stub
	.dw @stub
	.dw @stub
	.dw @stub
	.dw @mrsRuulScripts
	.dw @stub
	.dw @stub
	.dw @mrWriteScripts
	.dw @fickleLadyScripts
	.dw @stub
	.dw @malonScripts
	.dw @stub
	.dw @stub
	.dw @stub
	.dw @bathingSubrosiansScripts
	.dw @stub
	.dw @stub
	.dw @masterDiversSonScripts
	.dw @fickleManScripts
	.dw @dungeonWiseOldManScripts
	.dw @sunkenCityTreasureHunterScripts
	.dw @stub
	.dw @stub
	.dw @villageFarmerScripts
	.dw @villageFountainManScripts
	.dw @stub
	.dw @tickTockScripts
	
@mayorsHouseScripts:
@stub:
	.dw {SCRIPTS_1}.mayorsScript
	.dw {SCRIPTS_1}.mayorsScript
	.dw {SCRIPTS_1}.mayorsScript
	.dw {SCRIPTS_1}.mayorsHouseLadyScript

@mrsRuulScripts:
	.dw {SCRIPTS_1}.mrsRuulScript

@mrWriteScripts:
	.dw {SCRIPTS_1}.mrWriteScript

@fickleLadyScripts:
	.dw {SCRIPTS_1}.fickleLadyScript_text1
	.dw {SCRIPTS_1}.fickleLadyScript_text2
	.dw {SCRIPTS_1}.fickleLadyScript_text2
	.dw {SCRIPTS_1}.fickleLadyScript_text2
	.dw {SCRIPTS_1}.fickleLadyScript_text3
	.dw {SCRIPTS_1}.fickleLadyScript_text4
	.dw {SCRIPTS_1}.fickleLadyScript_text5
	.dw {SCRIPTS_1}.fickleLadyScript_text5
	.dw {SCRIPTS_1}.fickleLadyScript_text6
	.dw {SCRIPTS_1}.fickleLadyScript_text2
	.dw {SCRIPTS_1}.fickleLadyScript_text7

@malonScripts:
	.dw {SCRIPTS_1}.malonScript

@bathingSubrosiansScripts:
	.dw {SCRIPTS_1}.bathingSubrosianScript_text1
	.dw {SCRIPTS_1}.bathingSubrosianScript_stub
	.dw {SCRIPTS_1}.bathingSubrosianScript_2
	.dw {SCRIPTS_1}.bathingSubrosianScript_text3
	.dw {SCRIPTS_1}.bathingSubrosianScript_stub
	.dw {SCRIPTS_1}.bathingSubrosianScript_stub

@masterDiversSonScripts:
	.dw {SCRIPTS_1}.masterDiversSonScript
	.dw {SCRIPTS_1}.masterDiversSonScript_4thEssenceGotten
	.dw {SCRIPTS_1}.masterDiversSonScript_8thEssenceGotten
	.dw {SCRIPTS_1}.masterDiversSonScript_ZeldaKidnapped
	.dw {SCRIPTS_1}.masterDiversSonScript_gameFinished

@fickleManScripts:
	.dw {SCRIPTS_1}.ficklManScript_text1
	.dw {SCRIPTS_1}.ficklManScript_text1
	.dw {SCRIPTS_1}.ficklManScript_text2
	.dw {SCRIPTS_1}.ficklManScript_text4
	.dw {SCRIPTS_1}.ficklManScript_text5
	.dw {SCRIPTS_1}.ficklManScript_text6
	.dw {SCRIPTS_1}.ficklManScript_text7
	.dw {SCRIPTS_1}.ficklManScript_text7
	.dw {SCRIPTS_1}.ficklManScript_text8
	.dw {SCRIPTS_1}.ficklManScript_text3
	.dw {SCRIPTS_1}.ficklManScript_text9
	.dw {SCRIPTS_1}.ficklManScript_textA

@dungeonWiseOldManScripts:
	.dw {SCRIPTS_1}.dungeonWiseOldManScript

@sunkenCityTreasureHunterScripts:
	.dw {SCRIPTS_1}.treasureHunterScript_text1
	.dw {SCRIPTS_1}.treasureHunterScript_text2
	.dw {SCRIPTS_1}.treasureHunterScript_text3
	.dw {SCRIPTS_1}.treasureHunterScript_text4
	.dw {SCRIPTS_1}.treasureHunterScript_text3

@villageFarmerScripts:
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text1
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text1
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text2
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text2
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text3
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text4
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text5
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text5
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text6
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text2
	.dw {SCRIPTS_1}.oldLadyFarmerScript_text7

@villageFountainManScripts:
	.dw {SCRIPTS_1}.fountainOldManScript_text1
	.dw {SCRIPTS_1}.fountainOldManScript_text2
	.dw {SCRIPTS_1}.fountainOldManScript_text3
	.dw {SCRIPTS_1}.fountainOldManScript_text4
	.dw {SCRIPTS_1}.fountainOldManScript_text6
	.dw {SCRIPTS_1}.fountainOldManScript_text7
	.dw {SCRIPTS_1}.fountainOldManScript_text8
	.dw {SCRIPTS_1}.fountainOldManScript_text8
	.dw {SCRIPTS_1}.fountainOldManScript_text9
	.dw {SCRIPTS_1}.fountainOldManScript_text5
	.dw {SCRIPTS_1}.fountainOldManScript_textA

@tickTockScripts:
	.dw {SCRIPTS_1}.tickTockScript
