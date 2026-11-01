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
	.dw showPanicInfo
	.dw updatePanicInfo
	; these are here as a reminder that more states can be supported
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

	m_SetPanicState 2	; move to runPanicLoop
	jr returnToPanicMainLoop

runPanicLoop:
	call checkPanicExitInputs
	jr nz,returnToPanicMainLoop

	m_SetPanicState 3	; move to exitPanicLoop
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
		m_SetPanicState 4	; move to showPanicInfo
		jr returnToPanicMainLoop
	+

	; restore the interrupt enable flags
	ldh a,(<hPanicState)
	and $1f
	ldh (R_IE),a

	; exit panic state
	m_SetPanicState -1

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
	jp restoreToPanicCallsite

showPanicInfo:
	; only move to the loop state once the inputs are released
	call checkPanicExitInputs
	jr z,returnToPanicMainLoop

	m_SetPanicState 5	; move to updatePanicInfo
	jr returnToPanicMainLoop

updatePanicInfo:
	; call runPanicLoop to catch inputs to exit loop
	call checkPanicExitInputs
	jr nz,returnToPanicMainLoop

	m_SetPanicState 3	; move to exitPanicLoop
	jr returnToPanicMainLoop

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