
;;
; Run the secret list menu from farore's book.
runSecretListMenu:
	call clearOam
	ld a,TEXT_BANK
	ld ($ff00+R_SVBK),a
	call @runState
	jp secretListMenu_drawCursorSprite

@runState:
	ld a,(wSecretListMenu.state)
	rst_jumpTable
	.dw secretListMenu_state0
	.dw secretListMenu_state1
	.dw secretListMenu_state2

;;
; State 0: initialization
secretListMenu_state0:
	call disableLcd
	call stopTextThread

	ld a,$01
	ld (wSecretListMenu.state),a
	call @clearVramBank
	xor a
	call @clearVramBank

	ld a,GFXH_SECRET_LIST_MENU
	call loadGfxHeader
.ifdef ROM_COMBO
	call wIsSeasons
	ld a,PALH_SECRET_LIST_MENU_SEASONS
	jr c,+
		ld a,PALH_SECRET_LIST_MENU_AGES
	+
.else
	ld a,PALH_SECRET_LIST_MENU
.endif
	call loadPaletteHeader
	call secretListMenu_loadAllSecretNames
	ld a,$ff
	call secretListMenu_printSecret
	call fastFadeinFromWhite
	ld a,$16
	jp loadGfxRegisterStateIndex

;;
; @param	a	Vram bank to fill with $ff
@clearVramBank:
	ld ($ff00+R_VBK),a
	ld hl,$8000
	ld bc,$0100
	ld a,$ff
	jp fillMemoryBc16ByteBlocks

;;
; State 1: processing input
secretListMenu_state1:
	ld a,(wPaletteThread_mode)
	or a
	ret nz

	ld a,(wKeysJustPressed)
	and (BTN_START|BTN_SELECT|BTN_B)
	jp nz,closeMenu

	call getInputWithAutofire
	ld c,a
	ld hl,wSecretListMenu.numEntries
	ldi a,(hl)
	ld b,a
	ld a,$ff

	bit BTN_BIT_UP,c
	jr nz,@upOrDown
	bit BTN_BIT_DOWN,c
	jr z,@end
	ld a,$01
@upOrDown:
	; Try to move cursor, stop if we're at the maximum
	add (hl) ; hl = wSecretListMenu.cursorIndex
	cp b
	jr nc,@end

	ldi (hl),a
	sub (hl) ; hl = wSecretListMenu.scroll
	cp $01
	jr c,@scrollUp
	cp $03
	jr c,@playSound

@scrollDown:
	ldi a,(hl) ; hl = wSecretListMenu.scroll
	sub b
	cp $fc
	jr nc,@playSound
	ld a,$02
	jr ++

@scrollUp:
	ldi a,(hl)
	or a
	jr z,@playSound
	ld a,$fe
++
	ld (wSecretListMenu.scrollSpeed),a
	ld l,<wSecretListMenu.state
	inc (hl) ; Go to state 2 (scrolling)

@playSound:
	ld a,SND_MENU_MOVE
	call playSound

@end:
	ld a,(wSaveQuitMenu.delayCounter)
	jr secretListMenu_printSecret

;;
; State 2: scrolling
secretListMenu_state2:
	ld hl,wSecretListMenu.scrollSpeed
	ld a,(wGfxRegs2.SCY)
	add (hl)
	ld (wGfxRegs2.SCY),a
	and $0f
	ret nz

	; Done scrolling
	ld a,(hl)
	sra a
	ld l,<wSecretListMenu.scroll
	add (hl)
	ld (hl),a
	ld l,<wSecretListMenu.state
	dec (hl) ; Go to state 1
	ret

;;
secretListMenu_drawCursorSprite:
	ld a,(wGfxRegs2.SCY)
	ld b,a
	ld a,(wSecretListMenu.cursorIndex)
	swap a
	sub b
	ld b,a
	ld c,$00
	ld hl,@cursor
	jp addSpritesToOam_withOffset

@cursor;
	.db $01
	.db $5a $14 $0c $24

;;
; @param	a	Index of secret to print (or $ff for nothing)
secretListMenu_printSecret:
	ld hl,wTmpcbb9
	cp (hl)
	ret z

	ld (hl),a
	push af

	ld hl,w7d800
	ld bc,$0030
	call clearMemoryBc16ByteBlocks

	ld hl,w7SecretText1
	ld b,$c*2
	call clearMemory

	pop af
	cp $ff
	jr z,@end

	call secretListMenu_getSecretData
	ldi a,(hl)
	rlca
	rlca
	and $03
	ld b,a
	ldi a,(hl)
	ld c,(hl)
	call checkGlobalFlag
	ld a,$ff
	ld (wFileSelect.fontXor),a
	jr z,secretListMenu_printSecret

	call @getSecretText
	ld hl,w7SecretText1
	ld de,w7d800
	ld b,$c*2
	call copyTextCharactersFromHl
@end:
	ld a,UNCMP_GFXH_35
	jp loadUncompressedGfxHeader

@getSecretText:
	ld a,b
	rst_jumpTable
	.dw @val0
	.dw @val1
	.dw @val2
	.dw @val3

@val0: ; game-transfer secret
@val1:
	jpab bank3.generateGameTransferSecret

@val2: ; ring secret
	ldbc $00,$02
	jp secretFunctionCaller

@val3: ; 5-letter secret
	ld a,c
	ld (wShortSecretIndex),a
	ld c,b
	ld b,$00
	jp secretFunctionCaller

;;
; Loads gfx for all secret names directly to vram starting at $8a00.
secretListMenu_loadAllSecretNames:
	xor a
	ld ($ff00+R_VBK),a

	ld de,$8a00
	ld b,$00
@nextSecret:
	ld a,b
	call secretListMenu_getSecretData
	ldi a,(hl)
	or a
	jr z,@end

	push bc
	ld c,a
	ldi a,(hl)
	call checkGlobalFlag
	ld a,$01 ; If we don't have this secret, show a dashed line
	jr z,++

	ld a,c
	and $3f
	call copyTextCharactersFromSecretTextTable
	ld a,$02 ; Put " Secret" after every string
++
	call copyTextCharactersFromSecretTextTable
	pop bc

	; Adjust de to point to next row
	dec de
	ld e,$00
	ld a,d
	and $fe
	add $02

	; If we've reached address 0:9000, loop around to 1:8000.
	cp $90
	jr c,++
	ld a,$01
	ld ($ff00+R_VBK),a
	ld a,$80
++
	ld d,a
	inc b
	jr @nextSecret

@end:
	ld a,b
	ld (wSecretListMenu.numEntries),a
	ret

;;
; @param	a	Index
secretListMenu_getSecretData:
	ld hl,wFileIsLinkedGame
	bit 0,(hl)
.if defined(ROM_COMBO)
	call wIsSeasons
	jr c,++
		ld hl,@unlinked_ages
		jr z,+
		ld hl,@linked_ages
		jr +
	++
		ld hl,@unlinked_seasons
		jr z,+
		ld hl,@linked_seasons
	+
.else
	ld hl,@unlinked
	jr z,+
	ld hl,@linked
+
.endif
	push bc

	ld c,a ; a *= 3
	add a
	add c

	rst_addAToHl
	pop bc
	ret


; The following data is the list of secrets to be displayed on farore's secret list.
;   b0: bits 0-5: Index for name from secretTextTable
;       bits 6-7: secret "mode" (0/1=game-transfer, 2=ring secret, 3=other)
;   b1: global flag which, if set, means the secret is unlocked
;   b2: Index of secret data?

.if defined(ROM_AGES) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	@unlinked_ages:
.else
	@unlinked:
.endif
		.db $03, GLOBALFLAG_FINISHEDGAME,		$00
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $d0, GLOBALFLAG_DONE_KING_ZORA_SECRET,	$10
		.db $d4, GLOBALFLAG_DONE_LIBRARY_SECRET,	$14
		.db $d5, GLOBALFLAG_DONE_TROY_SECRET,		$12
		.db $d7, GLOBALFLAG_DONE_TINGLE_SECRET,		$17
		.db $d9, GLOBALFLAG_DONE_SYMMETRY_SECRET,	$19
		.db $d1, GLOBALFLAG_DONE_FAIRY_SECRET,		$11
		.db $d8, GLOBALFLAG_DONE_ELDER_SECRET,		$18
		.db $d2, GLOBALFLAG_DONE_TOKAY_SECRET,		$15
		; Don't display plen secret or mamamu secret, since rings can be exchanged
		; through vasu instead.
		.db $00

.if defined(ROM_COMBO)
	@linked_ages:
.else
	@linked:
.endif
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $c6, GLOBALFLAG_BEGAN_CLOCK_SHOP_SECRET, 	$20
		.db $ca, GLOBALFLAG_BEGAN_SMITH_SECRET, 	$24
		.db $cb, GLOBALFLAG_BEGAN_PIRATE_SECRET, 	$25
		.db $cd, GLOBALFLAG_BEGAN_DEKU_SECRET, 		$27
		.db $cf, GLOBALFLAG_BEGAN_RUUL_SECRET,	 	$29
		.db $c7, GLOBALFLAG_BEGAN_GRAVEYARD_SECRET, 	$21
		.db $ce, GLOBALFLAG_BEGAN_BIGGORON_SECRET, 	$28
		.db $c8, GLOBALFLAG_BEGAN_SUBROSIAN_SECRET, 	$22
		.db $c9, GLOBALFLAG_BEGAN_DIVER_SECRET, 	$23
		.db $cc, GLOBALFLAG_BEGAN_TEMPLE_SECRET, 	$26
		.db $00
.endif

.if defined(ROM_SEASONS) || defined(ROM_COMBO)
.if defined(ROM_COMBO)
	@unlinked_seasons:
.else
	@unlinked:
.endif
		.db $04, GLOBALFLAG_FINISHEDGAME,		$00
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $c6, GLOBALFLAG_DONE_CLOCK_SHOP_SECRET,	$30
		.db $ca, GLOBALFLAG_DONE_SMITH_SECRET,		$34
		.db $cb, GLOBALFLAG_DONE_PIRATE_SECRET,		$35
		.db $cd, GLOBALFLAG_DONE_DEKU_SECRET,		$37
		.db $cf, GLOBALFLAG_DONE_RUUL_SECRET,		$39
		.db $c7, GLOBALFLAG_DONE_GRAVEYARD_SECRET,	$31
		.db $ce, GLOBALFLAG_DONE_BIGGORON_SECRET,	$38
		.db $c8, GLOBALFLAG_DONE_SUBROSIAN_SECRET,	$32
		.db $00

.if defined(ROM_COMBO)
	@linked_seasons:
.else
	@linked:
.endif
		.db $85, GLOBALFLAG_RING_SECRET_GENERATED,	$02
		.db $d0, GLOBALFLAG_BEGAN_KING_ZORA_SECRET,	$00
		.db $d4, GLOBALFLAG_BEGAN_LIBRARY_SECRET,	$04
		.db $d5, GLOBALFLAG_BEGAN_TROY_SECRET,		$02
		.db $d7, GLOBALFLAG_BEGAN_TINGLE_SECRET,	$07
		.db $d9, GLOBALFLAG_BEGAN_SYMMETRY_SECRET,	$09
		.db $d1, GLOBALFLAG_BEGAN_FAIRY_SECRET,		$01
		.db $d8, GLOBALFLAG_BEGAN_ELDER_SECRET,		$08
		.db $d2, GLOBALFLAG_BEGAN_TOKAY_SECRET,		$05
		.db $d3, GLOBALFLAG_BEGAN_PLEN_SECRET,		$03
		.db $d6, GLOBALFLAG_BEGAN_MAMAMU_SECRET,	$06
		.db $00

.endif