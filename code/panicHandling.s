panicHandler:
	di
	ldh a,(<hPanicState)
	srl a
	swap a
	and $07
	rst_jumpTable
	.dw recordPanicData
	.dw displayPanicScreen
	.dw updatePanicScreen
	.dw closePanicScreen
	; these are here as a reminder that 4 more states are supported
	.dw closePanicScreen
	.dw closePanicScreen
	.dw closePanicScreen
	.dw closePanicScreen

recordPanicData:
	; this state is typically entered via editing ram.
	jp handlePanic

displayPanicScreen:
	; backup the interrupt enable flags
	ldh a,(R_IE)
	or 2<<5		; move to updatePanicScreen
	ldh (<hPanicState),a

	ld a,$10	; enable only joypad interrupt
	ldh (R_IE),a
	jr returnFromPanic

updatePanicScreen:
	ld a,(wKeysPressed)
	sub (BTN_A | BTN_B | BTN_START | BTN_SELECT)
	jr nz,+
		; disable panic screen.
		ldh a,(<hPanicState)
		and $1f
		or 3<<5		; move to closePanicScreen
		ldh (<hPanicState),a
	+
	jr returnFromPanic

closePanicScreen:
	; wait till player is no longer pressing the combo
	ld a,(wKeysPressed)
	sub (BTN_A | BTN_B | BTN_START | BTN_SELECT)
	jr z,+
		; restore the interrupt enable flags
		ldh a,(<hPanicState)
		and $1f
		ldh (R_IE),a

		xor a
		ldh (<hPanicState),a
	+

returnFromPanic:
	ei
	jp handlePanic@mainLoop