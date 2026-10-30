.enum $0
	c1: db
	cs1: db
	d1: db
	ds1: db
	e1: db
	f1: db
	fs1: db
	g1: db
	gs1: db
	a1: db
	as1: db
	b1: db
	c2: db
	cs2: db
	d2: db
	ds2: db
	e2: db
	f2: db
	fs2: db
	g2: db
	gs2: db
	a2: db
	as2: db
	b2: db
	c3: db
	cs3: db
	d3: db
	ds3: db
	e3: db
	f3: db
	fs3: db
	g3: db
	gs3: db
	a3: db
	as3: db
	b3: db
	c4: db
	cs4: db
	d4: db
	ds4: db
	e4: db
	f4: db
	fs4: db
	g4: db
	gs4: db
	a4: db
	as4: db
	b4: db
	c5: db
	cs5: db
	d5: db
	ds5: db
	e5: db
	f5: db
	fs5: db
	g5: db
	gs5: db
	a5: db
	as5: db
	b5: db
	c6: db
	cs6: db
	d6: db
	ds6: db
	e6: db
	f6: db
	fs6: db
	g6: db
	gs6: db
	a6: db
	as6: db
	b6: db
	c7: db
	cs7: db
	d7: db
	ds7: db
	e7: db
	f7: db
	fs7: db
	g7: db
	gs7: db
	a7: db
	as7: db
	b7: db
	c8: db
	cs8: db
	d8: db
	ds8: db
	e8: db
	f8: db
	fs8: db
	g8: db
	gs8: db
	a8: db
	as8: db
	b8: db
.ende

; Other values that can be use within note/beat macros
.redefine od (-1) ; octave down
.redefine ou (-2) ; octave up
.redefine r (-3)  ; rest

; Define relative notes names within a given octave
.macro octave
	.redefine OCTAVE \1
	.redefine OFFSET (-$c)

	.redefine c 12*\1+0 + OFFSET
	.redefine cs 12*\1+1 + OFFSET
	.redefine d 12*\1+2 + OFFSET
	.redefine ds 12*\1+3 + OFFSET
	.redefine e 12*\1+4 + OFFSET
	.redefine f 12*\1+5 + OFFSET
	.redefine fs 12*\1+6 + OFFSET
	.redefine g 12*\1+7 + OFFSET
	.redefine gs 12*\1+8 + OFFSET
	.redefine a 12*\1+9 + OFFSET
	.redefine as 12*\1+10 + OFFSET
	.redefine b 12*\1+11 + OFFSET
.endm

.macro octaved
	octave OCTAVE-1
.endm
.macro octaveu
	octave OCTAVE+1
.endm

.macro m_soundPointer
	.ifdef I_LIKE_BIG_ROMS_AND_I_CANNOT_LIE_SND
		.db (:\1Start)&$ff ; Bank number
	.else
		.db :\1Start ; Bank number
	.endif
	.dw \1 ; Pointer
.endm

; Byte 1: frequency
; Byte 2: length
;
; Frequencies for noise:
; 22,23,24,26,27,28,29,2a,2e,2f,30,32,52
.macro note
	.redefine offset 0
	.rept NARGS
	.if NARGS >= 1
		.if \1 == od
			octaved
			.redefine offset offset-12
			.shift
		.else
		.if \1 == ou
			octaveu
			.redefine offset offset+12
			.shift
		.endif
		.endif
	.endif

	.if NARGS >= 2
	.if \1 == r
		rest \2
		.shift
		.shift
	.else
	.if \1 >= 0
		.db \1+offset
		.db \2

		.shift
		.shift
	.endif
	.endif
	.endif
	.endr
.endm

; This is NOT used by the base game; it's an attempt to provide a more sane way to define music
; (multiple notes per line). Each pair of arguments is a note followed by a length. Can define
; "NOTE_END_WAIT" to set a certain amount of a note to be "rest" instead of being actually played.
.macro beat
	.redefine offset 0
	.rept NARGS
	.if NARGS >= 1
		.if \1 == od
			octaved
			.redefine offset offset-12
			.shift
		.else
		.if \1 == ou
			octaveu
			.redefine offset offset+12
			.shift
		.endif
		.endif
	.endif

	.if NARGS >= 2
	.if \1 == r
		rest \2*BEAT
		.shift
		.shift
	.else
	.if \1 >= 0
		.db \1+offset

		.ifndef NOTE_END_WAIT
			.define NOTE_END_WAIT 0
		.endif

		.if NOTE_END_WAIT != 0
			.db \2*BEAT - NOTE_END_WAIT
			rest NOTE_END_WAIT
		.else
			.db \2*BEAT
		.endif

		.shift
		.shift
	.endif
	.endif
	.endif
	.endr
.endm

; 60: rest, stops playing the previous note and sets wait counter
.macro rest
	.db $60 \1
.endm

; 61: wait without changing the previous note or rest, can be used to extend a note or rest (for channels 0-3)
.macro rest2 ; Unused?
	.db $61 \1
.endm

; d0-df: set volume (for channels 0-3, 6 and 7)
.macro vol
	.if \1 > $f
		.fail
	.endif
	.db $d0 | \1
.endm

; e0-e7: set envelopes (for channels 0-3)
.macro env
	.if \1 > $7
		.fail
	.endif
	.db $e0 | \1
	.db \2
.endm

; e8-ef: same as e0-e7

; f0: does various things for channels 0-5, sets volume and envelope for channel 7, see audio.s for details
; Sometimes sets wChannelFrequencyModeAndLengthTimerEnabled
.macro cmdf0
	.db $f0 \1
.endm

; Run custom assembly
.macro asm_call
	.assert (NARGS > 0) && (NARGS < 4)
	.db $f1
	.dw \1
	.if NARGS == 3
		.db \2
		.dw \3
	.elif NARGS == 2
		.db :\1
		.dw \2
	.else
		.db :\1
		.dw $0000
	.endif
.endm

; f2: Play a music snippit
.macro mus_call
	.ifdef IN_AUDIO_FUNC
		.fail "ERROR: Nested music snippits are not supported.\n"
	.endif

	.db $f2
	dwbe \1_start
.endm

; f2: Defines the start of a music snippit(i.e. a reusable piece of music)
.macro mus_func
	.assert NARGS == 1
	.ifdef IN_AUDIO_FUNC
		.fail "ERROR: Nested music snippits are not supported.\n"
	.endif
	.define IN_AUDIO_FUNC
	\1_start:
.endm

; f2: Defines the end of a music snippit
.macro mus_ret
	.assert NARGS == 0
	.ifdef IN_AUDIO_FUNC
		.undefine IN_AUDIO_FUNC
	.else
		.fail "ERROR: Music snippit return detected without call.\n"
	.endif

	.db $f2, $00 ; indicates end of call
.endm

;;
; Loops X times between this location and the first loop_end encountered.
; If X is >= $8000, its treated as a RAM pointer to the counter variable.
; If X is >= $100 and X < $8000, its treated as a function pointer to
; call to determine the initial loop count.
; Otherwise its treated as a literal number of times to loop.
; NOTES: Always loops at least once
;        Does nothing for SFX channels
.macro loop_count
	.assert NARGS == 1
	asm_call audio.setLoopsRemaining, \1
	loop_helper audio.getAndDecrementLoopsRemaining
.endm

;;
; Loops endlessly between this location and the first loop_end encountered.
.macro loop_forever
	loop_while 1
.endm

;;
; Loops between this location and the first loop_end encountered.
; If the specified address is in RAM, its treated as a variable pointer.
; If the specified address is in ROM, its treated as a function pointer.
; Stops looping if the variable is zero, or the function returns the zflag set.
; NOTES: Always loops at least once
;        Does nothing for SFX channels
.macro loop_while
	.assert NARGS == 1
	.if (\1 > $8000) || (\1 < $100)
		; this is a variable or a literal value, so wrap it in a call.
		; NOTE: if a literal non-zero value below $100 is provided,
		;       this will effectively create an infinite loop.
		asm_call audio.setLoopsRemaining, \1
		loop_helper audio.getLoopsRemaining
	.else
		loop_helper \1
	.endif
.endm

.macro loop_helper
	.assert NARGS == 1

	.ifdef IN_AUDIO_LOOP
		.fail "ERROR: Nested music loops are not supported.\n"
	.endif
	.define IN_AUDIO_LOOP

	.db $f3
	; the bank numbers upper byte is also used to indicate
	; the start of the loop. we ensure it's non-zero as
	; zero is reserved for indicating the end of the loop.
	.ifdef I_LIKE_BIG_ROMS_AND_I_CANNOT_LIE_SND
		.db 1+(((:\1)>>8) & $01)
	.else
		.db $01
	.endif
	.db (:\1)&$ff
	.dw \1
.endm

.macro loop_end
	.ifdef IN_AUDIO_LOOP
		.undefine IN_AUDIO_LOOP
	.else
		.fail "ERROR: Music loop end detected without beginning.\n"
	.endif
	.db $f3, $00 ; indicates end of loop
.endm

; f4-f5: duplicates of ff
.macro cmdf4
	.db $f4
.endm
.macro cmdf5
	.db $f5
.endm

; f6: sets wChannelDutyCycles (for channels 0-5)
.macro duty
	.db $f6 \1
.endm

; f7: duplicate of ff

; f8: sets wChannelSweep (for channels 0-5)
.macro cmdf8
	.db $f8 \1
.endm

; f9: sets wChannelVibratos (for channels 0-5)
; Upper nibble is time to wait until vibrato starts.
; Lower nibble is intensity of vibrato.
.macro vibrato
	.db $f9 \1
.endm

; fa-fc: duplicates of ff

; fd: sets wChannelPitchShift (for channels 0-5)
; Shifts pitch
.macro cmdfd
	.db $fd \1
.endm

; fe: jump to the given address
;     NOTE: Jump address CANNOT be in bank0
.macro goto
	.assert NARGS == 1
	goto_helper \1 0 0 0
.endm

; fe: jump to the first address if the byte at
;     the second address equals the given value
;     NOTE: Jump address CANNOT be in bank0
.macro goto_if_eq
	goto_helper \1 \2 \3 1
.endm

; fe: jump to the first address if the byte at the
;     second address is less than the given value
;     NOTE: Jump address CANNOT be in bank0
.macro goto_if_lt
	goto_helper \1 \2 \3 2
.endm

; fe: jump to the first address if the byte at the
;     second address is greater than the given value
;     NOTE: Jump address CANNOT be in bank0
.macro goto_if_gt
	goto_helper \1 \2 \3 3
.endm

.macro goto_helper
	.assert NARGS == 4
	.assert (\4 >= 0) && (\4 < 4)

	.db $fe
	.db (\1&$ff)
	.if   \4 == 3
		; jump if greater than
		.db ((\1>>8)&$3f)|$c0
	.elif \4 == 2
		; jump if less than
		.db ((\1>>8)&$3f)|$80
	.elif \4 == 1
		; jump if equal
		.db ((\1>>8)&$3f)|$40
	.else
		; regular jump
		.db ((\1>>8)&$3f)
	.endif

	.if \4 > 0
		.dw \2
		.db \3
	.endif
.endm

; ff: disables the channel
.macro cmdff
	.db $ff
.endm

; Parameters:
;   \1: Index
;   \2: Name
.macro m_waveform
	.DEFINE \2, \1 EXPORT
	@waveform{%.2x{\1}}:
.endm