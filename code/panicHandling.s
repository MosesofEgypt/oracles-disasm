.define PANIC_PALETTE_BACKUP_OFFSET   VRAM_TILEMAP_0+$240
.define PANIC_UI_STATE_OFFSET         PANIC_PALETTE_BACKUP_OFFSET+$10

panicHandler:
	di
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
	.dw updatePanicInfo
	; these are here as a reminder that more states can be supported
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

	call panicDisableLcd
	; put the window overtop everything
	ld a,$07
	ldh (R_WX),a
	xor a
	ldh (R_WY),a

	call loadPanicPaletteData

	ld hl,panicGfxData
	call loadCompressedGfxData

	call panicEnableLcd

	m_SetPanicState 2	; move to runPanicLoop
	jr returnToPanicMainLoop

runPanicLoop:
	call checkPanicExitInputs
	jr nz,returnToPanicMainLoop

	m_SetPanicState 3	; move to exitPanicLoop
	jr returnToPanicMainLoop

updatePanicInfo:
	; call runPanicLoop to catch inputs to exit loop
	call checkPanicExitInputs
	jr nz,+
		m_SetPanicState 3	; move to exitPanicLoop
		jr returnToPanicMainLoop
	+

	call waitForVBlank

	jr returnToPanicMainLoop

exitPanicLoop:
	; wait till player is no longer pressing the combo
	call checkPanicExitInputs
	jr nz,returnToPanicMainLoop

	; if the B button is held when exiting, open
	; the panic info display instead of returning
	ld a,(wKeysPressed)
	and BTN_B
	jr z,+
		m_SetPanicState 4	; move to updatePanicInfo
		jr returnToPanicMainLoop
	+

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

	; move back to using the main stack
	ld sp,wMainStackTop

returnToPanicMainLoop:
	xor a
	ld (wKeysPressedLastFrame),a
	ld (wKeysJustPressed),a
	ld (wKeysPressed),a
	ei
	jp handlePanic@mainLoop

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
	ld a,(hPanicStackPointerOffset)
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

checkPanicExitInputs:
	; we want to catch the first frame that these keys
	; were held together, and ignore later frames.
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

	ld a,$30	; disable lcd, enable window, and make window use tiledata $8000-$8fff
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
	ld a,$05
	ldh (R_SVBK),a

	; copy the tile data
	ld b,$80
	ld hl,VRAM_TILEDATA_0
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
	ld hl,PANIC_PALETTE_BACKUP_OFFSET
	ldbc $00,$10
	-
		ld a,c
		ldh (R_BGPI),a
		ldh a,(R_BGPD)
		ldi (hl),a
		inc c
		ld a,c
		cp b
		jr nz,-
	ret

loadPanicPaletteData:
	ld hl,panicPaletteData
	jr +

restorePaletteData:
	ld hl,PANIC_PALETTE_BACKUP_OFFSET
	+
	ldbc $10,$00
	-
		ld a,c
		ldh (R_BGPI),a
		ldi a,(hl)
		ldh (R_BGPD),a
		inc c
		ld a,c
		cp b
		jr nz,-
	ret

waitForVBlank:
	ldh a,(R_LCDC)
	rlca
	ret nc
	-
		ldh a,(R_LY)
		cp 145	; scanline 145 and higher is VBlank
		ret nc
		jr -

panicGfxData:
	m_GfxHeader gfx_panic_shared, VRAM_0_TILEDATA_0
	m_GfxHeader gfx_panic_registers, VRAM_0_TILEDATA_0+$400
	m_GfxHeader map_panic_registers, VRAM_0_TILEMAP_0
	m_GfxHeader flg_panic_registers, VRAM_1_TILEMAP_0
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

panicPageDataOffsets:
	; ppu/cpu
	.dw @registerDataOffsets

	; wram
	.dw @wramDataOffsets

	; vram
	.dw @vramDataOffsets

	; sram
	.dw @sramDataOffsets

	; hram
	.dw @hramDataOffsets

	; oam
	.dw @oamDataOffsets

	; rom
	.dw @romDataOffsets

@registerDataOffsets:
	.db $00

@wramDataOffsets:
	.db $00

@vramDataOffsets:
	.db $00

@sramDataOffsets:
	.db $00

@hramDataOffsets:
	.db $00

@oamDataOffsets:
	.db $00

@romDataOffsets:
	.db $00