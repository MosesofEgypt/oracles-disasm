.define PANIC_SHARED_GFX_OFFSET	VRAM_0_TILEDATA_2
.define PANIC_PANEL_GFX_OFFSET	VRAM_0_TILEDATA_2+$360

.macro m_ByteAToDecimalCharsDea
	ld de,$0000
	cp 100
	jr c,$05
		inc d
		sub 100
		jr -9

	cp 10
	jr c,$05
		inc e
		sub 10
		jr -9
.endm

.macro m_PanicByteValueMapInfo
	.define SHFT $00
	.define MASK $ff
	.if NARGS > 2
		.redefine SHFT \3
	.endif
	.if NARGS > 3
		.redefine MASK \4
	.endif

	.dw \2		; data address
	.db SHFT	; shift
	.db MASK	; mask
	.dw w5PanicVram0Tilemap + \1	; map offset
	.undefine SHFT
	.undefine MASK
.endm

.macro m_PanicWordValueMapInfo
	.assert NARGS == 2
	m_PanicByteValueMapInfo \1, (\2+1)
	m_PanicByteValueMapInfo (\1+2), \2
.endm

.macro m_PanicValueMapInfoTerminator
	m_PanicByteValueMapInfo $0000, $0000
.endm

.macro m_PanicPanelPageShape
	.assert NARGS == 3
	.define ptr w5PanicVram0Tilemap+\3
	.db (<(ptr + \1*2))&$1f	; map rightmost offset low
	.db \2					; height
	.dw ptr					; map start offset
	.undefine ptr
.endm

panicHandler:
	di
	; wait for the start of the drawing period
	; so the handler only runs once a frame
	-
		ldh a,(R_LY)
		or a
		jr nz,-

	ld hl,wFrameCounter
	inc (hl)

	ldh a,(<hPanicState)
	srl a
	swap a
	and $07
	add a
	ld hl,@table
	addAToHl
	derefHl
	jp hl
@table:
	.dw recordPanicData
	.dw initPanicLoop
	.dw runPanicLoop
	.dw exitPanicLoop
	; these are here as a reminder that more states can be supported
	.dw runPanicLoop
	.dw runPanicLoop
	.dw runPanicLoop
	.dw runPanicLoop

recordPanicData:
	; this state is typically entered via editing ram.
	jp handlePanic

initPanicLoop:
	; backup the interrupt enable flags
	ldh a,(R_IE)
	ldh (<hPanicState),a
	xor a
	ldh (R_IE),a

	call backupGfxData

	ld hl,w5PanicTemp
	ld bc,w5PanicEnd-w5PanicTemp
	call clearMemoryBc

	ld a,$f8	; set all changed bits and set to selecting panel
	ld (w5PanicSelectionMode),a

	call setupHighlightCoords

	call panicDisableLcd
	; put the window overtop everything
	ld a,$07
	ldh (R_WX),a
	xor a
	ldh (R_WY),a

	call loadPanicPaletteData

	ld hl,panicSharedTiledata
	call loadCompressedGfxData

	; update position and priority of all sprites to
	; prepare them for being displayed in the oam panel
	ld b,40
	ld hl,OAM_START
	-
		;ld a,72
		;ld a,136
		xor a
		ldi (hl),a
		ld a,157
		ldi (hl),a
		res 7,(hl)
		inc hl
		inc hl
		dec b
		jr nz,-

	call panicEnableLcd

	m_SetPanicState 2	; move to runPanicLoop
	jp returnToPanicMainLoop

runPanicLoop:
	call checkPanicInputs
	jr nz,+
		m_SetPanicState 3	; move to exitPanicLoop
		jp returnToPanicMainLoop
	+

	ld a,(w5PanicPanel)
	cp $07
	jr c,++
		ld a,$07
		ld (w5PanicPanel),a
	++

	; update the selected addresses
	call updateSelectedAddresses

	ld a,(w5PanicSelectionMode)
	and $80
	jr z,+
		ld a,(w5PanicPanel)
		ld hl,panicPanelGfxAndFlagHeaders
		add a
		addAToHl
		derefHl
		call panicDisableLcd
		call loadCompressedGfxData
		call panicEnableLcd

		ld hl,panicPanelMapHeaders
		ld a,(w5PanicPanel)
		add a
		addAToHl
		derefHl
		call loadCompressedGfxData
	+

	; update the displayed values if any selection was
	; changed, or start/select is held(live updating)
	ld a,(wKeysPressed)
	and (BTN_START | BTN_SELECT)
	ld hl,w5PanicSelectionMode
	jr z,+
		; set page changed flag
		set 5,(hl)
	+
	ld a,$f8
	and (hl)
	call nz,updatePanicDisplayMap

	ld hl,w5PanicSelectionMode
	ld a,(hl)
	ld c,a
	and $07
	ld (hl),a
	ld a,c
	and $f8
	jr z,+
		call waitForVBlank
		ld hl,panicPanelTilemap
		call loadUncompressedGfxData
	+

	ld hl,w5PanicHighlightPrev+1
	bit 7,(hl)
	jr z,+
		xor a
		jr ++
	+
		ld hl,w5PanicHighlightCurr+1
		bit 7,(hl)
		jr z,returnToPanicMainLoop
			ld a,(wFrameCounter)
			rrca
			and $07
			jr nz,returnToPanicMainLoop
				ld a,(wFrameCounter)
				bit 4,a
				ld a,$00
				jr z,++
					inc a
	++
	dec hl
	call highlightArea
	ld a,(w5PanicHighlightPrev+1)
	res 7,a
	ld (w5PanicHighlightPrev+1),a

returnToPanicMainLoop:
	call runVBlankFunctions
	ei
	jp handlePanic@mainLoop

highlightArea:
	push af
	ld b,(hl)
	inc hl
	ld a,(hl)
	and $1f
	ld c,a
	ld a,b
	and $1f

	ld hl,VRAM_TILEMAP_0
	addAToHl

	swap b
	ld a,b
	rrca
	and $07
	ld b,a

	ld de,$0020
	ld a,c
	-
	or a
	jr z,+
		add hl,de
		dec a
		jr -
	+

	inc b
	ld a,$01
	ldh (R_VBK),a
	pop af

	ld c,a
	-
		call waitForVBlankLoose
		ld a,(hl)
		and $f8
		or c
		ldi (hl),a
		dec b
		jr nz,-
	ret

exitPanicLoop:
	; wait till player is no longer pressing the combo
	ld hl,wKeysPressedLastFrame
	ldi a,(hl)
	or (hl)
	and (BTN_START | BTN_SELECT)
	cp (BTN_START | BTN_SELECT)
	jr z,returnToPanicMainLoop

	; restore the interrupt enable flags
	ldh a,(<hPanicState)
	and $1f
	ldh (R_IE),a

	; exit panic state
	m_SetPanicState -1

	call restoreGfxData

	; if the A button is held when exiting, return
	; to the panic callsite instead of the mainLoop
	ld a,(wKeysPressed)
	and BTN_A
	jr nz,returnToPanicSite

	; reset to the default wram bank
	ld a,$01
	ldh (R_SVBK),a

	; move back to using the main stack
	ld sp,wMainStackTop
	ld hl,handlePanic@mainLoop
	push hl
	reti

returnToPanicSite:
	; reset these so we don't end up in a loop
	xor a
	ld (wKeysJustPressed),a
	ld (wKeysPressed),a

	; push af, bc, and de to the stack for later popping
	; we're going in this order so af is on the stack bottom.
	; hl is ignored so we can use the register for moving data.
	ld hl,hPanicRegisterAf
	ld b,$03
	-
		ldi a,(hl)
		ld e,a
		ldi a,(hl)
		ld d,a
		push de
		dec b
		jr nz,-

	; calculate the stack pointer to reload
	xor a	; clear carry flag
	ld d,a
	ld a,(hPanicStackPointerLow)
	rla
	ld e,a
	ld a,d
	adc d
	ld d,a
	ld hl,wMainStack
	add hl,de

	; restore the registers and stack pointer
	call panicDisableLcd
	jp restoreToPanicCallsite

checkPanicInputs:
	ld hl,w5PanicSelectionMode
	ld a,(hl)
	and $07
	cp 5
	jr c,+
		xor a
	+
	ld c,a
	ld a,(hl)
	and $f8
	or c
	ld (hl),a

	; check if backing out of selection level
	ld a,(wKeysJustPressed)
	and BTN_B
	jr nz,++

	ld a,(w5PanicPanel)
	or a
	jr z,++
	ld a,(w5PanicHoldTimer)
	and $60
	jr nz,+
		++
		; update selecting of panel/subpanel/page
		ld a,(wKeysJustPressed)
		and (BTN_UP | BTN_DOWN | BTN_LEFT | BTN_RIGHT | BTN_A)
		jp z,checkPanicExitInputs
	+

	ld a,(wKeysJustPressed)
	and BTN_UP
	jr z,+
		++
		ld a,(hl)
		dec a
		jr ++
	+

	ld a,(wKeysJustPressed)
	and (BTN_DOWN | BTN_A)
	jr z,+
		ld a,(hl)
		inc a
		++
		cp $ff
		jr nz,++
			xor a
		++
		cp $06
		jr nz,++
			ld a,$06
		++
		ld (hl),a
		set 3,(hl)
		jp setupHighlightCoords
	+

	ld a,(hl)
	and $07
	jr nz,+
		; changing panel
		set 7,(hl)
		ld hl,w5PanicPanel
		dec (hl)
		ld a,(wKeysJustPressed)
		and BTN_RIGHT
		jr z,++
			inc (hl)
			inc (hl)
		++
		ld a,(hl)
		cp $ff
		jr nz,++
			ld (hl),$00
			jp checkPanicExitInputsAndUnsetSelectionChanged
		++
		ld b,$06
		cp b
		ld a,(hl)
		jp c,setupHighlightCoords
		jp z,setupHighlightCoords
		ld (hl),b
		jp checkPanicExitInputsAndUnsetSelectionChanged
	+

	; changing subpanel
	set 6,(hl)
	ld hl,panicPanelSelectionInfo
	ld a,(w5PanicPanel)
	add a
	addAToHl
	derefHl

	; exit if there are no selection modes
	ld a,(hl)
	or a
	jp z,checkPanicExitInputsAndUnsetSelectionChanged

	ld a,(w5PanicSelectionMode)
	dec a
	and $07
	cp (hl)
	jr c,+
		ld a,(hl)
		or a
		jp z,checkPanicExitInputsAndUnsetSelectionChanged
		dec a
	+
	inc hl
	add a
	add a
	addAToHl

	; get the max value
	ldi a,(hl)
	ld b,a
	inc hl

	; get the selection control variable
	derefHl

	ld a,(w5PanicHoldTimer)
	bit 5,a
	jr z,+
		bit 7,a
		jr z,++
		jr +++
	+
	ld a,(wKeysJustPressed)
	and BTN_LEFT
	jr z,+++
		++
		ld a,(hl)
		or a
		; check if selection would go below 0
		jp z,checkPanicExitInputsAndUnsetSelectionChanged
		dec (hl)
		jr setupHighlightCoords
	+++
		ld a,(hl)
		cp b
		; check if selection would go above max
		jp z,checkPanicExitInputsAndUnsetSelectionChanged
		inc (hl)

setupHighlightCoords:
	ld hl,panicPanelSelectionInfo
	ld a,(w5PanicPanel)
	add a
	addAToHl
	derefHl

	ld a,(w5PanicSelectionMode)
	and $07
	jr nz,+
		; clear highlight coords if panel names selected
		ld a,(w5PanicHighlightCurr)
		ld (w5PanicHighlightPrev),a
		ld a,(w5PanicHighlightCurr+1)
		ld (w5PanicHighlightPrev+1),a

		xor a
		ld (w5PanicHighlightCurr),a
		ld (w5PanicHighlightCurr+1),a
		jr checkPanicExitInputs
	+
	dec a
	cp (hl)
	jr z,++
	jr c,+
		++
		; constrain selection mode to how many modes exist for this panel
		ld a,(w5PanicSelectionMode)
		and $f8
		ld (w5PanicSelectionMode),a
		ld d,a
		ld a,(hl)
		or a
		jr z,checkPanicExitInputs
		or d
		ld (w5PanicSelectionMode),a
		jr checkPanicExitInputsAndUnsetSelectionChanged
	+
	inc hl
	add a
	add a
	addAToHl

	; reset highlighting
	ld a,(w5PanicHighlightCurr)
	ld (w5PanicHighlightPrev),a
	ld a,(w5PanicHighlightCurr+1)
	ld (w5PanicHighlightPrev+1),a

	; clear highlight coords if selection was changed
	ld a,(w5PanicSelectionMode)
	and $88
	jr z,+
		xor a
		ld (w5PanicHighlightCurr),a
		ld (w5PanicHighlightCurr+1),a
	+

	; get the max selector value
	ldi a,(hl)
	ld b,a

	; setup the y-coordinate of the tiles to highlight
	ld a,(hl)
	or a
	res 7,a
	; if the value is $00, it means to not flash
	jr z,+
		; set flag indicating to flash
		set 7,a
	+

	and $8f
	ld (w5PanicHighlightCurr+1),a
	ldi a,(hl)
	swap a
	and $0f
	ld d,a
	ld e,$04 ; width

	; get the selection control variable
	derefHl

	; if the x-coord is $0f, this is highlighting the address
	; all the way on the right, so use different logic for it
	ld a,d
	cp $0f
	jr z,++
		; setup the width and x-coordinate of the tiles to highlight
		ld a,(hl)
		or a
		ld e,$02 ; width
		jr z,+
			; if non-zero, highlight decrement arrow as well
			dec d
			inc e
		+
		cp b
		jr nc,+
			; if less than max, highlight increment arrow as well
			inc e
		+
	++
	ld a,e
	swap a
	sla a
	or d
	ld (w5PanicHighlightCurr),a
	jr checkPanicExitInputs

checkPanicExitInputsAndUnsetSelectionChanged:
	ld hl,w5PanicSelectionMode
	res 6,(hl)
	res 7,(hl)

checkPanicExitInputs:
	ld a,(wKeysPressed)
	and (BTN_LEFT | BTN_RIGHT)
	jr nz,+
		; reset
		xor a
		ld (w5PanicHoldTimer),a
	+

	and BTN_LEFT
	jr z,+
		ld a,(w5PanicHoldTimer)
		bit 5,a
		jr nz,+
			bit 7,a
			jr nz,+
				inc a
				ld (w5PanicHoldTimer),a
	+
	ld a,(wKeysPressed)
	and BTN_RIGHT
	jr z,+
		ld a,(w5PanicHoldTimer)
		bit 5,a
		jr nz,+
			bit 7,a
			jr z,+
				inc a
				ld (w5PanicHoldTimer),a
	+

	ld a,(wKeysPressed)
	and BTN_LEFT
	ld a,(w5PanicHoldTimer)
	res 7,a
	jr nz,+
		set 7,a
	+
	ld (w5PanicHoldTimer),a

	; we want to catch the first frame that these keys
	; were held together and ignore later frames.
	; this ensures they're only detected as held for one frame
	ld a,(wKeysPressedLastFrame)
	and (BTN_START | BTN_SELECT)
	cp (BTN_START | BTN_SELECT)
	jr nz,+
		inc a
		ret
	+

	ld a,(wKeysPressed)
	and (BTN_START | BTN_SELECT)
	cp (BTN_START | BTN_SELECT)
	ret

panicEnableLcd:
	; reenable lcd
	push af
	ldh a,(R_LCDC)
	or $80
	ldh (R_LCDC),a
	pop af
	ret

panicDisableLcd:
	; disable lcd to get immediate and full access to vram
	push af
	call waitForVBlank

	ld a,$26  ; disable lcd, enable sprites/window, and
	;           make window use tiledata $8800-$97ff
	ldh (R_LCDC),a
	pop af
	ret

backupGfxData:
	call panicDisableLcd
	call backupPaletteData
	scf
	ccf
	jr +

restoreGfxData:
	call panicDisableLcd
	call restorePaletteData
	scf
+

	ld a,$00
	ldh (R_VBK),a

	; copy the tile data
	ld b,$80
	ld hl,PANIC_SHARED_GFX_OFFSET
	ld de,w5PanicVram0Tiledata0Backup
	call copyVramBackupData

	; copy the tilemaps
	ld b,$24
	ld hl,VRAM_TILEMAP_0
	ld de,w5PanicVram0Tilemap0Backup
	call copyVramBackupData

	ld a,$01
	ldh (R_VBK),a

	ld b,$24
	ld hl,VRAM_TILEMAP_0
	ld de,w5PanicVram1Tilemap0Backup
	call copyVramBackupData

	; and finally the OAM data
	ld b,$10
	ld hl,OAM_START
	ld de,w5PanicOamBackup
	call copyVramBackupData

	; move the window off into the ether
	ld a,$c7
	ldh (R_WY),a
	ldh (R_WX),a

	jp panicEnableLcd

copyVramBackupData:
	push af
	jr nc,+
		; swap src and dest if cflag set
		push hl
		push de
		pop hl
		pop de
	+

	-
		.rept $10
			ldi a,(hl)
			ld (de),a
			inc de
		.endr
		dec b
		jr nz,-
	pop af
	ret

backupPaletteData:
	ld hl,w5PanicPaletteBackup
	ldbc $10,$00
	jr ++

loadPanicPaletteData:
	ld hl,panicPaletteData
	jr +

restorePaletteData:
	ld hl,w5PanicPaletteBackup
	+
	ldbc $90,$00
	++
	ld a,$05
	ldh (R_SVBK),a
	-
		ld a,c
		ldh (R_BGPI),a
		bit 7,b
		jr z,++
			; restore/load
			ldi a,(hl)
			ldh (R_BGPD),a
			jr +
		++
			; backup
			ldh a,(R_BGPD)
			ldi (hl),a
			+
		inc c
		ld a,b
		res 7,a
		cp c
		jr nz,-
	ret

waitForVBlank:
	ldh a,(R_LCDC)
	rlca
	ret nc
	-
		ldh a,(R_LY)
		cp 145	; scanline 145 and higher is VBlank
		ret z
		jr -

waitForVBlankLoose:
	ldh a,(R_LCDC)
	rlca
	ret nc
	-
		ldh a,(R_LY)
		cp 145	; scanline 145 and higher is VBlank
		ret z
		jr -

readPanelByteDe:
	; if this panel is in a banked region, we need to change
	; the bank temporarily. otherwise we can read as-is
	ld a,(w5PanicPanel)
	push de
	cp $05
	jr nz,+
		push hl
		ld h,d
		ld l,e
		ld a,(w5PanicSelectedRomBank)
		ld e,a
		ld d,$00
		call readByteFromHlAcrossBanks
		pop hl
		jr ++
	+
		cp $04
		jr nz,+
			; vram, so we must wait for the memory to be accessible
			--
				ldh a,(R_STAT)
				and $03
				cp $03
				jr z,--
		+
		ld a,(de)
	++
	pop de
	ret

updatePanicDisplayMap:
	ld a,$05
	ldh (R_SVBK),a

	ld a,(w5PanicSelectedVramBank)
	ldh (R_VBK),a

	ld a,(w5PanicPanel)
	cp $07
	jr c,+
		ld a,$07
	+
	cp $06
	jr z,++
	cp $05
	jr nz,+
		ld a,(w5PanicSelectionMode)
		bit 7,a
		jr z,+
			++
			; update position and priority of all sprites to
			; prepare them for being displayed in the oam panel
			ld b,40
			ld hl,OAM_START
			-
				call waitForVBlankLoose
				xor a
				ldi (hl),a
				ld a,l
				add $03
				ld l,a
				dec b
				jr nz,-
	+

	; enable sram
	ld a,(w5PanicPanel)
	cp $03
	jr nz,+
		ld a,$0a
		ld ($1111),a
		ld a,(w5PanicSelectedSramBank)
		ld ($4444),a
	+

	; update the selected value(unless this is panel 0)
	ld a,(w5PanicSelectedCharAddress)
	ld l,a
	ld a,(w5PanicSelectedCharAddress+1)
	ld h,a
	ld a,(w5PanicSelectedWramBank)
	ldh (R_SVBK),a

	ld e,(hl)
	ld a,$05
	ldh (R_SVBK),a
	ld a,e
	ld (w5PanicSelectedValue),a

	ld a,(w5PanicPanel)
	cp $06
	jp nz,+
		; oam is handled slightly differently, which
		; requires that we manually calculate the page
		; offset based on the selected oam row
		ld hl,w5PanicOamBackup
		ld a,(w5PanicSelectedOamRow)
		add a
		add a
		; cap the displayed row to prevent viewing out-of-bounds
		cp $60
		jr c,++
			ld a,$60
		++
		ld d,$00
		ld e,a
		ld c,a
		add hl,de
		ld e,l
		ld d,h

		ld a,l
		ld (w5PanicSelectedPageAddress),a
		ld a,h
		ld (w5PanicSelectedPageAddress+1),a

		; update the left-hand address tiles
		ld b,$00
		push de
		-
			; multiply by 32
			ld h,$00
			ld l,b
			add hl,hl
			add hl,hl
			add hl,hl
			add hl,hl
			add hl,hl

			ld de,w5PanicVram0Tilemap+$43
			add hl,de

			; convert to hex chars in de
			ld d,c
			ld e,c
			swap d
			ld a,$0f
			and d
			ld d,a
			ld a,$0f
			and e
			ld e,a

			; write to the map
			ld a,(hl)
			and $10
			or d
			ldi (hl),a

			ld a,(hl)
			and $10
			or e
			ldi (hl),a

			; update counters
			ld a,c
			add $04
			ld c,a
			inc b
			ld a,b
			cp $10
			jr nz,-
		pop de

		; update the sprites info tiles
		ld hl,w5PanicVram0Tilemap
		ld a,(w5PanicSelectedOamRow)
		and $3f
		ld b,a
		-
			; update sprite position
			ld a,b
			add a
			add a
			ld e,a
			ld d,>OAM_START
			ld a,(w5PanicSelectedOamRow)
			cp b
			ld c,72
			jr z,++
				ld c,136
			++
			call waitForVBlankLoose
			ld a,c
			ld (de),a

			ld a,b
			push hl
			; update the id
			m_ByteAToDecimalCharsDea
			ld c,e
			ld de,$0052
			add hl,de

			; write to the map
			ld (hl),c
			inc hl
			ld (hl),a

			; get the offset of the oam data
			ld a,b
			add a
			add a
			add  <w5PanicOamBackup
			ld e,a
			ld d,>w5PanicOamBackup
			jr nc,++
				inc d
			++

			; update the priority flag
			inc de
			inc de
			inc de
			ld bc,$00b2-$0053
			add hl,bc
			ld a,(de)
			bit 7,a
			ld a,$6f
			jr z,++
				inc a ; checked
			++
			ld (hl),a

			; update the x-flip flag
			ld bc,$00ef-$00b2
			add hl,bc
			ld a,(de)
			bit 5,a
			ld a,$6f
			jr z,++
				inc a ; checked
			++
			ld (hl),a

			; update the y-flip flag
			ld bc,$010f-$00ef
			add hl,bc
			ld a,(de)
			bit 6,a
			ld a,$6f
			jr z,++
				inc a ; checked
			++
			ld (hl),a

			; update the coords
			ld bc,$008f-$010f
			add hl,bc
			dec de
			dec de
			ld a,(de)
			ld c,a
			dec de
			ld a,(de)
			; update y coord
			sub 16
			m_ByteAToDecimalCharsDea

			; write to the map
			ld (hl),d
			inc hl
			ld (hl),e
			inc hl
			ld (hl),a

			ld a,c
			ld bc,$006f-$0091
			add hl,bc
			; update x coord
			sub 8
			m_ByteAToDecimalCharsDea
			ld (hl),d
			inc hl
			ld (hl),e
			inc hl
			ld (hl),a

			pop hl

			; update counter and pointer
			ld de,$0100
			add hl,de
			ld a,(w5PanicSelectedOamRow)
			inc a
			ld b,a
			ld a,h
			cp >(w5PanicVram0Tilemap+$200)
			jp nz,-
	+

	; get the data offset in de
	ld a,(w5PanicPanel)
	ld hl,w5PanicSelectedPageAddress
	ld e,(hl)
	inc hl
	ld d,(hl)

	ld a,(w5PanicPanel)
	ld hl,panicPanelPageDataShape
	add a
	add a
	addAToHl

	; get the x-end address and height
	ld c,(hl)
	inc hl
	ld b,(hl)
	inc hl

	; get the map address
	derefHl
	push hl
	-
		; if this panel is in a banked region, we need to change
		; the bank temporarily. otherwise we can read as-is
		ld a,(w5PanicPanel)
		cp $01
		jr nz,+
			push de
			ld a,(w5PanicSelectedWramBank)
			ldh (R_SVBK),a
			ld a,(de)
			ld d,a
			ld a,$05
			ldh (R_SVBK),a
			ld a,d
			pop de
			jr ++
		+
			call readPanelByteDe
		++
		inc de

		; convert to hex chars in de
		push de
		ld d,a
		ld e,a
		swap d
		ld a,$0f
		and d
		ld d,a
		ld a,$0f
		and e
		ld e,a

		; write to the map
		ld a,(hl)
		and $10
		or d
		ldi (hl),a

		ld a,(hl)
		and $10
		or e
		ldi (hl),a
		pop de

		ld a,l
		and $1f
		cp c
		jr nz,-
			; hit the row end. jump to the next row down
			pop hl
			ld a,l
			add $20
			ld l,a
			ld a,h
			adc $00
			ld h,a
			push hl

			; decrement height and see if we have more rows
			dec b
			jr nz,-

	pop hl

	ld hl,panicPanelDataValueInfos
	ld a,(w5PanicPanel)
	add a
	addAToHl
	derefHl
	-
		ld e,(hl)
		inc hl
		ld d,(hl)
		ld a,e
		or d
		jr z,++
			; valid address to read from
			inc hl

			; value to display in b
			call readPanelByteDe
			ld b,a

			ldi a,(hl)	; shift
			or a
			--
				jr z,+++
				srl b
				dec a
				jr --
			+++

			; move value to display into a and mask it
			ld a,b
			and (hl)	; mask
			inc hl

			; get the map address
			ld c,(hl)
			inc hl
			ld b,(hl)
			inc hl

			; convert to hex chars in de
			ld d,a
			ld e,a
			swap d
			ld a,$0f
			and d
			ld d,a
			ld a,$0f
			and e
			ld e,a

			; write to the map
			ld a,(bc)
			and $50
			or d
			ld (bc),a
			inc bc
			ld a,(bc)
			and $50
			or e
			ld (bc),a
			jr -
		++

	; disable sram
	xor a
	ld ($1111),a
	ret

updateSelectedAddresses:
	ld a,(w5PanicPanel)
	or a
	ld bc,$0000	; base/bank pointer
	ld hl,$0000	; page offset
	ld de,$0000	; char offset
	jr nz,+
		; cpu/ppu panel
		ld bc,wMainStack
		ld a,(hPanicStackPointerLow)
		sub $10
		ld l,a
		bit 7,a
		jr z,++
			ld h,$ff
		++
		add hl,hl
		ld e,$20
		jp @done
	+

	dec a
	jr nz,+
		; wram panel
		ld a,(w5PanicSelectedWramBank)
		or a
		ld b,$c0
		jr z,++
			ld b,$d0
		++
		ld a,(w5PanicSelectedWramPage)
		ld l,a
		; multiply by 64
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl

		ld a,(w5PanicSelectedWramChar)
		ld e,a
		jr @done
	+

	dec a
	jr nz,+
		; hram panel
		ld b,$ff
		ld a,(w5PanicSelectedHramPage)
		ld l,a
		; multiply by 64
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl

		ld a,(w5PanicSelectedHramChar)
		ld e,a
		jr @done
	+

	dec a
	jr nz,+
		; sram panel
		ld b,$a0
		ld a,(w5PanicSelectedSramPage)
		ld l,a
		; multiply by 64
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl

		ld a,(w5PanicSelectedSramChar)
		ld e,a
		jr @done
	+

	dec a
	jr nz,+
		; vram panel
		ld b,$80
		ld a,(w5PanicSelectedVramPage)
		ld l,a
		; multiply by 64
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl

		ld a,(w5PanicSelectedVramChar)
		ld e,a
		jr @done
	+

	dec a
	jr nz,+
		; rom panel
		ld a,(w5PanicSelectedRomBank)
		or a
		jr z,++
			ld b,$40
		++
		ld a,(w5PanicSelectedRomPage)
		ld l,a
		; multiply by 128
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl
		add hl,hl

		jr @done
	+

	; oam panel
	ld bc,w5PanicOamBackup
	ld a,(w5PanicSelectedOamRow)
	add a
	add a
	ld e,a

@done
	; update the addresses
	ld a,c
	ld (w5PanicSelectedBankAddress),a
	ld a,b
	ld (w5PanicSelectedBankAddress+1),a

	add hl,bc
	ld a,l
	ld (w5PanicSelectedPageAddress),a
	ld a,h
	ld (w5PanicSelectedPageAddress+1),a

	add hl,de
	ld a,l
	ld (w5PanicSelectedCharAddress),a
	ld a,h
	ld (w5PanicSelectedCharAddress+1),a

	ld a,(hl)
	ld (w5PanicSelectedValue),a
	ret

panicPanelPageDataShape:
	; cpu
	m_PanicPanelPageShape 8, 8, $144
	; wram
	m_PanicPanelPageShape 8, 8, $144
	; hram
	m_PanicPanelPageShape 8, 8, $144
	; sram
	m_PanicPanelPageShape 8, 8, $144
	; vram
	m_PanicPanelPageShape 8, 8, $144
	; rom
	m_PanicPanelPageShape 8, 16, $044
	; oam
	m_PanicPanelPageShape 4, 16, $045

panelNameHighlightXCoords:
	.db $40 ; cpu
	.db $43 ; wram
	.db $46 ; hram
	.db $49 ; sram
	.db $4c ; vram
	.db $4f ; rom
	.db $32 ; oam

panicPanelSelectionInfo:
	.dw @cpuSubpanels
	.dw @wramSubpanels
	.dw @hramSubpanels
	.dw @sramSubpanels
	.dw @vramSubpanels
	.dw @romSubpanels
	.dw @oamSubpanels

	@cpuSubpanels:
		; no subpanels
		.db $00

	@wramSubpanels:
		.db $03	; selection levels

		.db $07, $61
		.dw w5PanicSelectedWramBank

		.db ($1000/$40 - 1), $62
		.dw w5PanicSelectedWramPage

		.db $3f, $63
		.dw w5PanicSelectedWramChar

		;.db $ff, $64
		;.dw w5PanicSelectedValue

	@hramSubpanels:
		.db $02	; selection levels

		.db ($100/$40 - 1), $62
		.dw w5PanicSelectedHramPage

		.db $3f, $63
		.dw w5PanicSelectedHramChar

		;.db $ff, $64
		;.dw w5PanicSelectedValue

	@sramSubpanels:
		.db $03	; selection levels

		.db SRAM_BANKS-1, $61		; max value/y-coord|(x-coord<<4)
		.dw w5PanicSelectedSramBank	; variable

		.db ($2000/$40 - 1), $62
		.dw w5PanicSelectedSramPage

		.db $3f, $63
		.dw w5PanicSelectedSramChar

		;.db $ff, $64
		;.dw w5PanicSelectedValue

	@vramSubpanels:
		.db $03	; selection levels

		.db $01, $61
		.dw w5PanicSelectedVramBank

		.db ($2000/$40 - 1), $62
		.dw w5PanicSelectedVramPage

		.db $3f, $63
		.dw w5PanicSelectedVramChar

		;.db $ff, $64
		;.dw w5PanicSelectedValue

	@romSubpanels:
		.db $02	; selection levels

		.db (ROM_BANKS&$ff)-1, $61
		.dw w5PanicSelectedRomBank

		.db ($4000/$80)-1, $f1
		.dw w5PanicSelectedRomPage

	@oamSubpanels:
		.db $01	; selection levels

		; NOTE: this is 1 lower than max since 2 sprites
		;       are displayed in the oam panel at once
		.db 38, $00 ; $00 indicates that nothing should flash
		.dw w5PanicSelectedOamRow

panicSharedTiledata:
	m_GfxHeader gfx_panic_shared, PANIC_SHARED_GFX_OFFSET
	m_GfxHeaderEnd

panicPanelTilemap:
	m_GfxHeaderRam w5PanicVram0Tilemap, VRAM_0_TILEMAP_0, $24
	m_GfxHeaderEnd

panicPanelGfxAndFlagHeaders:
	.dw @cpuPaneldata
	.dw @wramPaneldata
	.dw @hramPaneldata
	.dw @sramPaneldata
	.dw @vramPaneldata
	.dw @romPaneldata
	.dw @oamPaneldata

	@cpuPaneldata:
		m_GfxHeader gfx_panic_cpu, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_cpu, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

	@wramPaneldata:
		m_GfxHeader gfx_panic_wram, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_wram, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

	@hramPaneldata:
		m_GfxHeader gfx_panic_hram, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_hram, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

	@sramPaneldata:
		m_GfxHeader gfx_panic_sram, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_sram, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

	@vramPaneldata:
		m_GfxHeader gfx_panic_vram, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_vram, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

	@romPaneldata:
		m_GfxHeader gfx_panic_rom, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_rom, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

	@oamPaneldata:
		m_GfxHeader gfx_panic_oam, PANIC_PANEL_GFX_OFFSET
		m_GfxHeader flg_panic_oam, VRAM_1_TILEMAP_0
		m_GfxHeaderEnd

panicPanelMapHeaders:
	.dw @cpuPaneldata
	.dw @wramPaneldata
	.dw @hramPaneldata
	.dw @sramPaneldata
	.dw @vramPaneldata
	.dw @romPaneldata
	.dw @oamPaneldata

	@cpuPaneldata:
		m_GfxHeader map_panic_cpu, w5PanicVram0Tilemap
		m_GfxHeaderEnd

	@wramPaneldata:
		m_GfxHeader map_panic_wram, w5PanicVram0Tilemap
		m_GfxHeaderEnd

	@hramPaneldata:
		m_GfxHeader map_panic_hram, w5PanicVram0Tilemap
		m_GfxHeaderEnd

	@sramPaneldata:
		m_GfxHeader map_panic_sram, w5PanicVram0Tilemap
		m_GfxHeaderEnd

	@vramPaneldata:
		m_GfxHeader map_panic_vram, w5PanicVram0Tilemap
		m_GfxHeaderEnd

	@romPaneldata:
		m_GfxHeader map_panic_rom, w5PanicVram0Tilemap
		m_GfxHeaderEnd

	@oamPaneldata:
		m_GfxHeader map_panic_oam, w5PanicVram0Tilemap
		m_GfxHeaderEnd

panicPaletteData:
	m_RGB16 $0d $01 $05
	m_RGB16 $00 $00 $00
	m_RGB16 $1f $1a $11
	m_RGB16 $00 $00 $00

	m_RGB16 $1d $01 $03
	m_RGB16 $1d $01 $03
	m_RGB16 $1f $1a $11
	m_RGB16 $00 $00 $00

panicPanelDataValueInfos:
	.dw @cpuInfo
	.dw @wramInfo
	.dw @hramInfo
	.dw @sramInfo
	.dw @vramInfo
	.dw @romInfo
	.dw @oamInfo

	@cpuInfo:
		m_PanicByteValueMapInfo $006a, hPanicRomBank
		m_PanicByteValueMapInfo $0088, hPanicWramVramBanks, $00, $07
		m_PanicByteValueMapInfo $00a8, hPanicWramVramBanks, $03, $01
		m_PanicByteValueMapInfo $00c8, hPanicLcdc
		m_PanicByteValueMapInfo $00e8, hPanicState, $00, $1f

		m_PanicWordValueMapInfo $0070, hPanicRegisterAf
		m_PanicWordValueMapInfo $0090, hPanicRegisterBc
		m_PanicWordValueMapInfo $00b0, hPanicRegisterDe
		m_PanicWordValueMapInfo $00d0, hPanicRegisterHl
		m_PanicWordValueMapInfo $00f0, hPanicInstructionPointer
		m_PanicWordValueMapInfo $0110, w5PanicSelectedCharAddress
		m_PanicValueMapInfoTerminator

	@wramInfo:
		m_PanicByteValueMapInfo $0027, w5PanicSelectedWramBank
		m_PanicByteValueMapInfo $0047, w5PanicSelectedWramPage
		m_PanicByteValueMapInfo $0067, w5PanicSelectedWramChar
		m_PanicByteValueMapInfo $0087, w5PanicSelectedValue

		m_PanicWordValueMapInfo $0030, w5PanicSelectedBankAddress
		m_PanicWordValueMapInfo $0050, w5PanicSelectedPageAddress
		m_PanicWordValueMapInfo $0070, w5PanicSelectedCharAddress
		m_PanicValueMapInfoTerminator

	@hramInfo:
		m_PanicByteValueMapInfo $0047, w5PanicSelectedHramPage
		m_PanicByteValueMapInfo $0067, w5PanicSelectedHramChar
		m_PanicByteValueMapInfo $0087, w5PanicSelectedValue

		m_PanicWordValueMapInfo $0050, w5PanicSelectedPageAddress
		m_PanicWordValueMapInfo $0070, w5PanicSelectedCharAddress
		m_PanicValueMapInfoTerminator

	@sramInfo:
		m_PanicByteValueMapInfo $0027, w5PanicSelectedSramBank
		m_PanicByteValueMapInfo $0047, w5PanicSelectedSramPage
		m_PanicByteValueMapInfo $0067, w5PanicSelectedSramChar
		m_PanicByteValueMapInfo $0087, w5PanicSelectedValue

		m_PanicWordValueMapInfo $0030, w5PanicSelectedBankAddress
		m_PanicWordValueMapInfo $0050, w5PanicSelectedPageAddress
		m_PanicWordValueMapInfo $0070, w5PanicSelectedCharAddress
		m_PanicValueMapInfoTerminator

	@vramInfo:
		m_PanicByteValueMapInfo $0027, w5PanicSelectedVramBank
		m_PanicByteValueMapInfo $0047, w5PanicSelectedVramPage
		m_PanicByteValueMapInfo $0067, w5PanicSelectedVramChar
		m_PanicByteValueMapInfo $0087, w5PanicSelectedValue

		m_PanicWordValueMapInfo $0030, w5PanicSelectedBankAddress
		m_PanicWordValueMapInfo $0050, w5PanicSelectedPageAddress
		m_PanicWordValueMapInfo $0070, w5PanicSelectedCharAddress
		m_PanicValueMapInfoTerminator

	@romInfo:
		m_PanicByteValueMapInfo $0027, w5PanicSelectedRomBank
		m_PanicWordValueMapInfo $0030, w5PanicSelectedPageAddress
	@oamInfo:
		m_PanicValueMapInfoTerminator