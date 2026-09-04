.include "include/constants.s"
.include "include/macros.s"
.include "include/rominfo.s"
.include "include/musicMacros.s"

.enum 0 export
	MUS_SQUARE_1	db ; 0
	MUS_SQUARE_2	db ; 1
	SFX_SQUARE_1	db ; 2
	SFX_SQUARE_2	db ; 3
	MUS_WAVE		db ; 4
	SFX_WAVE		db ; 5
	MUS_NOISE		db ; 6
	SFX_NOISE		db ; 7
	CHANNEL_COUNT	db ; 8
.ende

.enum 0 export
	MUS_VOLUME_MUTE		db ; 0
	MUS_VOLUME_QUARTER	db ; 1
	MUS_VOLUME_HALF		db ; 2
	MUS_VOLUME_MAX		db ; 3
.ende

; An alias for each audio register
.define R_SQ1_SWEEP					R_NR10
.define R_SQ1_TIMER_AND_DUTY		R_NR11
.define R_SQ1_VOLUME_AND_ENVELOPE	R_NR12
.define R_SQ1_PERIOD_LOW			R_NR13
.define R_SQ1_PERIOD_HIGH_AND_CTRL	R_NR14

.define R_SQ2_TIMER_AND_DUTY		R_NR21
.define R_SQ2_VOLUME_AND_ENVELOPE	R_NR22
.define R_SQ2_PERIOD_LOW			R_NR23
.define R_SQ2_PERIOD_HIGH_AND_CTRL	R_NR24

.define R_WAVE_DAC_ENABLE			R_NR30
.define R_WAVE_TIMER				R_NR31
.define R_WAVE_OUTPUT_LEVEL			R_NR32
.define R_WAVE_PERIOD_LOW			R_NR33
.define R_WAVE_PERIOD_HIGH_AND_CTRL	R_NR34

.define R_NOISE_TIMER				R_NR41
.define R_NOISE_VOLUME_AND_ENVELOPE	R_NR42
.define R_NOISE_FREQUENCY_AND_RAND	R_NR43
.define R_NOISE_CTRL				R_NR44

.define R_MASTER_VOLUME_AND_PANNING	R_NR50
.define R_SOUND_PANNING				R_NR51
.define R_SOUND_ENABLE				R_NR52

.define SND_VOLUME_MAX	$77
.define SND_VOLUME_STEP	$11

.macro m_ReadDataFromHlPlusE
	ld d,$00
	ld hl,\1
	add hl,de
	ld a,(hl)
.endm

.macro m_ReadDataFromHlPlusA
	ld e,a
	m_ReadDataFromHlPlusE \1
.endm

.macro m_ReadChannelData
	.if NARGS == 2
		.if \2 == 0
			xor a
		.else
			ld a,\2
		.endif
		ld (wSoundChannel),a
	.else
		.assert NARGS == 1
		ld a,(wSoundChannel)
	.endif
	m_ReadDataFromHlPlusA \1
.endm

.macro m_ReadChannelDataFlag
	.if NARGS == 2
		m_ReadChannelData \1 \2
	.else
		.assert NARGS == 1
		m_ReadChannelData \1
	.endif
	or a
.endm

.macro m_WriteHlToFF00PlusA
	ld c,a
	ld a,l
	ld ($ff00+c),a
	inc c
	ld a,h
	ld ($ff00+c),a
	inc c
.endm

.macro m_WriteDataToHlPlusE
	ld d,$00
	ld hl,\1
	add hl,de
	ld (hl),a
.endm

.macro m_WriteDataToHlPlusA
	ld e,a
	m_WriteDataToHlPlusE \1
.endm

.macro m_WriteChannelData
	.if NARGS == 2
		.if \2 == 0
			xor a
		.else
			ld a,\2
		.endif
	.elif NARGS == 1
		.assert NARGS == 1
	.endif
	push af
	ld a,(wSoundChannel)
	ld e,a
	pop af
	m_WriteDataToHlPlusE \1
.endm

.macro m_ClearChannelData
	ld a,(wSoundTmp)
	ld e,a
	xor a
	ld d,a

	.rept NARGS
		ld hl,\1
		add hl,de
		ld (hl),a
		.shift
	.endr
.endm

.macro m_DisableChannels
	.define DISABLE_FUNC \1
	.shift

	.rept NARGS
		m_ReadChannelDataFlag wChannelsEnabled \1
		call nz,DISABLE_FUNC
		.shift
	.endr
	.undefine DISABLE_FUNC
.endm

; HACK-BASE: Bank of sound engine (and of data in "audio/{game}/soundChannelData.s") changed to
; allocate more space to the compressed data section (text, graphics, room layouts).
.BANK 1 SLOT 1
.ORG 0

m_section_superfree AudioCode NAMESPACE audio

;;
b39_initSound:
	jp initSound

;;
b39_updateSound:
	jp updateSound

;;
; @param	a	Sound to play
b39_playSound:
	jp playSound

;;
b39_stopSound:
	jp stopSound

;;
; @param	a	Volume (0-3)
b39_updateMusicVolume:
	jp updateMusicVolume

;;
initSound:
	call stopSound

	ld a,MUS_VOLUME_MAX
	ld (wMusicVolume),a

	ld a,SND_VOLUME_MAX
	ld (wSoundVolume),a
	ld ($ff00+R_MASTER_VOLUME_AND_PANNING),a

	xor a
	ld (wSoundFadeDirection),a
	ld (wSoundFadeCounter),a
	ld (wSoundDisabled),a
	ld (wMusicMuted),a
	ld a,$8f
	ld ($ff00+R_SOUND_ENABLE),a
	ld a,$ff
	ld ($ff00+R_SOUND_PANNING),a
	ld c,@readFunctionEnd-@readFunction
	ld hl,@readFunction
	ld de,wMusicReadFunction
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec c
	jr nz,-
	ret

; This function is copied to wMusicReadFunction and executed there.
; NOTE: THIS CODE SHOULD ONLY EVER BE CALLED BY
;       CODE IN THIS BANK, OR CODE IN BANK 0
@readFunction:
	ld ($2222),a
.ifdef I_LIKE_BIG_ROMS_AND_I_CANNOT_LIE_SND
	ld a,$01
	ld ($3333),a
.endif
	ldi a,(hl)
	ld c,a
	ld a,:initSound
	ld ($2222),a
.ifdef I_LIKE_BIG_ROMS_AND_I_CANNOT_LIE_SND
	xor a
	ld ($3333),a
.endif
	ld a,c
	ret
@readFunctionEnd:


;;
; Updates wMusicVolume and wMusicMuted and silences channels 0 and 1
; @param	a	Volume (0-3)
updateMusicVolume:
	push bc
	push de
	push hl
	push af
	call silenceSquareMusicChannels

	pop af
	ld (wMusicVolume),a
	or a
	ld a,$01
	jr z,+
		xor a
	+
	ld (wMusicMuted),a
	pop hl
	pop de
	pop bc
	ret

;;
stopSound:
	xor a
-
	ld (wSoundChannel),a
	call channelCmdff
	ld a,(wSoundChannel)
	inc a
	cp CHANNEL_COUNT
	jr nz,-
	ret

;;
silenceAllChannels:
	xor a
-
	ld (wSoundChannel),a
	call silencePlayedSound
	ld a,(wSoundChannel)
	inc a
	cp CHANNEL_COUNT
	jr nz,-
	ret

;;
; Silences channels 0 and 1 if enabled
silenceSquareMusicChannels:
	m_DisableChannels silencePlayedSound MUS_SQUARE_1 MUS_SQUARE_2
	ret

;;
; Disable all sound effect channels
stopSfx:
	m_DisableChannels channelCmdff SFX_SQUARE_1 SFX_SQUARE_2 \
	                               SFX_WAVE     SFX_NOISE
	ret

;;
updateSound:
	push bc
	push de
	push hl
	ld a,(wSoundDisabled)
	or a
	jp nz,@ret

	ld a,(wSoundVolume)
	ld ($ff00+R_MASTER_VOLUME_AND_PANNING),a
	ld a,(wSoundFadeDirection)
	or a
	jr z,@updateChannels

	ld a,(wSoundFadeSpeed)
	ld b,a
	ld a,(wSoundFadeCounter)
	inc a
	ld (wSoundFadeCounter),a
	and b
	cp b
	jr nz,@updateChannels

	ld a,(wSoundFadeDirection)
	cp $0a
	jr z,@incVolume

@decVolume:
	ld a,(wSoundVolume)
	or a
	jr z,@stopSound

	sub SND_VOLUME_STEP
	jr +

@incVolume:
	ld a,(wSoundVolume)
	cp SND_VOLUME_MAX
	jr z,@clearFadeVariables

	add SND_VOLUME_STEP
+
	ld (wSoundVolume),a
	jp @updateChannels

@stopSound:
	call stopSound

@clearFadeVariables:
	xor a
	ld (wSoundFadeCounter),a
	ld (wSoundFadeDirection),a

@updateChannels:
	xor a
@channelLoop:
	ld (wSoundChannel),a
	m_ReadChannelDataFlag wChannelsEnabled
	jr z,@nextChannel

	m_ReadChannelDataFlag wChannelWaitCounters
	jr nz,@continueSound

	call doNextChannelCommand
	jr @nextChannel

@continueSound:
	call continuePlayingSound
@nextChannel:
	ld a,(wSoundChannel)
	inc a
	cp CHANNEL_COUNT
	jr nz,@channelLoop

	ld a,(wMusicMuted)
	cp $01
	jr nz,@ret

	ld a,$02
	ld (wMusicMuted),a

@ret:
	pop hl
	pop de
	pop bc
	ret

;;
; Keep playing the current sound
continuePlayingSound:
	; Decrement wait counter
	m_ReadChannelData wChannelWaitCounters
	dec a
	ld (hl),a

	; Return if noise channel
	ld a,(wSoundChannel)
	cp MUS_NOISE
	ret nc

	; Return if channel uses length timer
	m_ReadChannelData wChannelFrequencyModeAndLengthTimerEnabled
	and $40
	ret nz

	ld a,(wSoundChannel)
	cp SFX_WAVE
	call c,handleEnvelopes

;;
; Copies the channel's frequency value from hSoundData3 to wSoundFrequencyL,H after applying sweep and vibrato
updateSoundFrequencyAndPlay:
	; Handle sweep
	m_ReadChannelData wChannelSweep
	ld c,a
	and $7f
	jr z,@handleVibrato

	ld a,c
	and $80
	ld d,$00
	jr z,++
	ld d,$ff
++
	push de
	m_ReadChannelData wChannelSweep
	pop de
	ld e,a
	ld a,(wSoundChannel)
	sla a
	add <hSoundData3
	ld c,a
	ld a,($ff00+c)
	inc c
	ld l,a
	ld a,($ff00+c)
	inc c
	ld h,a
	add hl,de
	ld a,(wSoundChannel)
	sla a
	;add <hSoundData3
	;m_WriteHlToFF00PlusA
	ld b,a
	ld a,l
	ld c,<hSoundData3
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c

@handleVibrato:
	m_ReadChannelData wChannelVibratoActive
	and $10
	jr nz,@useVibrato

	; Check vibrato wait counter
	m_ReadChannelDataFlag wChannelVibratoCounters
	jr z,@endVibratoWait

	; Still waiting, no vibrato applied yet
	dec a
	m_WriteChannelData wChannelVibratoCounters
	ld hl,$0000
	jp @updateSoundFrequencyWithOffset

@endVibratoWait:
	m_WriteChannelData wChannelVibratoActive, $10
	m_WriteChannelData wChannelVibratoCounters, $00

@useVibrato:
	m_ReadChannelData wChannelVibratoCounters
	cp $08
	jr c,+
		; clip to size of table
		and $07
		m_WriteChannelData wChannelVibratoCounters
	+

	; Get next raw offset (-2, -1, 0, 1 or 2)
	ld hl,vibratoOffsetTable
	call readWordFromTable

	; Increment index
	push hl
	m_ReadChannelData wChannelVibratoCounters
	inc a
	ld (hl),a

	; Get vibrato intensity (0 if disabled for the channel)
	m_ReadChannelData wChannelVibratos
	and $0f
	pop hl

	; Get final offset by multiplying raw offset with intensity
	;jr nz,+
	;	ld h,a
	;	ld l,a
	;	jr @updateSoundFrequencyWithOffset
	;+
	;ld e,l
	;ld d,h
	;-
	;	dec a
	;	jr z,@updateSoundFrequencyWithOffset
	;	add hl,de
	;	jr -
	call multiplyHlByA

;;
@updateSoundFrequencyWithOffset:
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,b
	add <hSoundData3
	ld c,a
	ld a,($ff00+c)
	inc c
	ld e,a
	ld a,($ff00+c)
	inc c
	ld d,a
	add hl,de

	call setFrequencyToHl

;;
; When used for wave channel, hl is expected to contain wSoundFrequencyL,H and is written to NR33 and NR34
updatePlayedFrequency:
	ld a,(wSoundChannel)
	cp MUS_WAVE
	jr nc,@wave

	cp SFX_SQUARE_1
	jr nc,@square

	; For music, check if channel is free
	inc a
	inc a
	m_ReadDataFromHlPlusA wChannelsEnabled
	or a
	ret nz

@square:
	ld a,(wSoundChannel)
	and $01
	ld b,a
	sla a
	sla a
	add b
	ld b,a

	;add R_SQ1_PERIOD_LOW
	;ld c,a
	;ld a,(wSoundFrequencyL)
	;ld ($ff00+c),a
	;inc c

	push bc
	ld a,(wSoundFrequencyL)
	ld c,R_SQ1_PERIOD_LOW
	call writeIndexedHighRamAndIncrement

	ld a,(wSoundCmdEnvelope)
	ld e,a
	ld a,(wSoundFrequencyH)
	or e
	ld ($ff00+c),a
	inc c

	;ld a,R_SQ1_TIMER_AND_DUTY
	;add b
	;ld c,a
	;m_ReadChannelData wChannelDutyCycles
	;ld ($ff00+c),a
	;ret

	pop bc
	push bc
	ld hl,wChannelDutyCycles
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	pop bc
	ld c,R_SQ1_TIMER_AND_DUTY
	call writeIndexedHighRamAndIncrement
	ret

@wave:
	call isWaveChannelUnavailable
	ret nz
	ld a,l
	ld ($ff00+R_WAVE_PERIOD_LOW),a
	ld a,h
	ld ($ff00+R_WAVE_PERIOD_HIGH_AND_CTRL),a
	xor a
	ld ($ff00+R_WAVE_TIMER),a
label_39_030:
	ret

;;
; Sounds can always play, music can only play if wave channel is free and music has not been muted since previous updateSound call
; @param[out]	a	Whether wave channel registers may be written to (0 or 1)
isWaveChannelUnavailable:
	ld a,(wSoundChannel)
	cp SFX_WAVE
	jr z,@available

	ld a,(wChannelsEnabled+SFX_WAVE)
	or a
	jr nz,@unavailable

	ld a,(wMusicMuted)
	cp $02
	jr z,@unavailable
@available:
	xor a
	ret
@unavailable:
	xor a
	inc a
	ret

;;
getNextChannelByte:
	push bc
	push de
	push hl
	ld a,(wSoundChannel)
	ld b,a

	sla a
	add <hSoundChannelAddresses
	ld c,a
	ld a,($ff00+c)
	inc c
	ld l,a
	ld a,($ff00+c)
	ld h,a

	;add a
	;ld hl,hSoundChannelAddresses
	;rst_addAToHl
	;rst_derefHl

	ld a,b
	add <hSoundChannelBanks
	ld c,a
	ld a,($ff00+c)
	inc c

	call wMusicReadFunction
	push af

	; move to the next byte in the data
	ld a,b
	;add a
	;add <hSoundChannelAddresses
	;m_WriteHlToFF00PlusA
	sla a
	ld b,a
	ld a,l
	ld c,<hSoundChannelAddresses
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c

	pop af
	pop hl
	pop de
	pop bc
	ret

;;
doNextChannelCommand:
	call getNextChannelByte
	cp $f0
	jr nc,@cmdf0Toff

	cp $e0
	jp nc,cmde0Toef

	cp $d0
	jp nc,cmdVolume

	ld (wSoundCmd),a
	jp standardSoundCmd

@cmdf0Toff:
	add $10
	rst_jumpTable
	.dw channelCmdf0
	.dw channelCmdf1
	.dw channelCmdf2
	.dw channelCmdf3
	.dw channelCmdff
	.dw channelCmdff
	.dw channelCmdf6
	.dw channelCmdff
	.dw channelCmdf8
	.dw channelCmdf9
	.dw channelCmdff
	.dw channelCmdff
	.dw channelCmdff
	.dw channelCmdfd
	.dw channelCmdfe
	.dw channelCmdff

;;
channelCmdf1:
	jp doNextChannelCommand
;;
channelCmdf2:
	jp doNextChannelCommand
;;
channelCmdf3:
	jp doNextChannelCommand

;;
; Vibrato
; Sets vibrato to the argument value, does nothing for noise channels
channelCmdf9:
	ld a,(wSoundChannel)
	cp MUS_NOISE
	jr nc,++

	call getNextChannelByte
	m_WriteChannelData wChannelVibratos
	jp doNextChannelCommand

;;
; Sets sweep to the argument value, does nothing for noise channels
channelCmdf8:
	ld a,(wSoundChannel)
	cp MUS_NOISE
	jr nc,++

	call getNextChannelByte
	m_WriteChannelData wChannelSweep
	jp doNextChannelCommand

;;
; Sets pitch shift to the argument value, does nothing for noise channels
channelCmdfd:
	ld a,(wSoundChannel)
	cp MUS_NOISE
	jr nc,++

	call getNextChannelByte
	m_WriteChannelData wChannelPitchShift
	jp doNextChannelCommand
++
	call getNextChannelByte
	jp doNextChannelCommand

;;
; Sets the channel envelopes to the lower 3 bits of the command value (note start) and the argument value (note end)
; Should not be used with wave or noise channels or else wChannelEnvelopes2 and wChannelsEnabled get messed up for square channels
cmde0Toef:
	and $07
	m_WriteChannelData wChannelEnvelopes
	call getNextChannelByte

	and $07
	m_WriteChannelData wChannelEnvelopes2
	jp doNextChannelCommand

;;
; Command $f0 takes the next byte as argument and
; can do various things depending on the channel:
;
; Square/Wave channels:
;   Enables a mode where standard commands are changed, and 
;   the note and beat macros stop working for the channel.
;   Commands for playing a sound or rest must instead be of the
;   form ".db $06 $0b $02" where, from left to right, the bytes
;   correspond to the high byte of the frequency value, the low byte,
;   and the sound length. There is no command for disabling this mode.
;   The argument is written straight to wChannelDutyCycles.
;
; Square channels:
;   Additionally, if bits 0-5 of the argument are not all cleared, 
;   the length timer gets enabled for the channel, and those 6 bits
;   determine the initial value for each played sound.
;   Otherwise, the length timer gets disabled.
;   Sweep and vibrato are ignored with length timer.
;   Envelopes with increasing volume should not be used with length timer
;   as sounds would keep increasing to volume $f if played long enough.
;
; Sfx noise channel:
;   Sets volume and envelope (argument gets written straight to NR42).
;   Should not be used with channel 6 or else wChannelSweep
;   and wChannelEnvelopeStates get messed up for channel 0
channelCmdf0:
	ld a,(wSoundChannel)
	cp SFX_NOISE
	jr z,@sfxNoiseChannel

	call getNextChannelByte
	push af
	and $3f
	; Initial length timer value of 0 is treated as wanting to
	; disable the length timer. Command $fd can be used afterwards 
	; to set the initial length timer value to 0 without disabling it
	jr z,@disableLengthTimer

	pop af
	m_WriteChannelData wChannelDutyCycles
	; Enable both arbitrary frequency mode and length timer
	m_WriteChannelData wChannelFrequencyModeAndLengthTimerEnabled, $41
	jp doNextChannelCommand

@disableLengthTimer:
	pop af
	m_WriteChannelData wChannelDutyCycles
	; Enable arbitrary frequency mode and disable length timer
	m_WriteChannelData wChannelFrequencyModeAndLengthTimerEnabled, $01
	jp doNextChannelCommand

@sfxNoiseChannel:
	call getNextChannelByte
	ld ($ff00+R_NOISE_VOLUME_AND_ENVELOPE),a
	xor a
	ld (R_NOISE_TIMER),a
	ld a,$80
	ld (wTriggerSfxNoiseChannelOnNextSound),a
	jp doNextChannelCommand

; Command $d0 to $df
; Sets volume to the lower 3 bits of the command value, does nothing for channel 4 (and is also useless for channel 5)
cmdVolume:
	push af
	ld a,(wSoundChannel)
	cp MUS_WAVE
	jr z,@next

	pop af
	and $0f
	m_WriteChannelData wChannelVolumes
	jp doNextChannelCommand

@next:
	pop af
	jp doNextChannelCommand

;;
; For square channels, sets wChannelDutyCycles to the argument value shifted 6 bits to the left
; For wave channels, sets wChannelDutyCycles to the argument value and updates the waveform based on that index
; Should not be used with noise channels or else wChannelEnvelopeStates gets messed up for channel 0 or 1
channelCmdf6:
	ld a,(wSoundChannel)
	cp MUS_WAVE
	jr z,@wave

	cp SFX_WAVE
	jr z,@wave

	call getNextChannelByte
	and $03
	swap a
	sla a
	sla a
	m_WriteChannelData wChannelDutyCycles
	jp doNextChannelCommand

@wave:
	call getNextChannelByte
	m_WriteChannelData wChannelDutyCycles
	ld (wWaveformIndex),a
	call setWaveform
	jp doNextChannelCommand

;;
standardSoundCmd:
	ld a,(wSoundChannel)
	rst_jumpTable
	.dw standardCmdMusicSquareChannel1
	.dw standardCmdMusicSquareChannel2
	.dw standardCmdSfxSquareChannel1
	.dw standardCmdSfxSquareChannel2
	.dw standardCmdMusicWaveChannel
	.dw standardCmdSfxWaveChannel
	.dw standardCmdMusicNoiseChannel
	.dw standardCmdSfxNoiseChannel

standardCmdMusicSquareChannel1:
standardCmdMusicSquareChannel2:
standardCmdSfxSquareChannel1:
standardCmdSfxSquareChannel2:
	m_ReadChannelDataFlag wChannelFrequencyModeAndLengthTimerEnabled
	jr z,+

	call getNextChannelByte
	ld l,a
	ld a,(wSoundCmd)
	ld h,a
	jp @arbitraryFrequency
+
	ld a,(wSoundCmd)
	cp $60
	jr z,@cmd60

	cp $61
	jr z,@cmd61

	jp @cmdFrequency

@cmd60:
	; If notes are set to end with an envelope, do nothing even if the last note is still audible
	m_ReadChannelDataFlag wChannelEnvelopes2
	jr nz,@cmd61

	; Apply envelope to make the volume quickly decrease to 0
	m_WriteChannelData wChannelEnvelopeStates, $02
	call getChannelVolume
	sla a
	sla a
	sla a
	sla a
	ld c,$01
	or c
	ld (wSoundCmdEnvelope),a
	call updateSquareChannelVolume
	call updateSoundFrequencyAndPlay
@cmd61:
	jp setChannelWaitCounter

@cmdFrequency:
	ld a,(wSoundCmd)
	sub $0c
	ld hl,soundFrequencyTable
	call readWordFromTable
@arbitraryFrequency:
	call setSoundFrequency
	m_WriteChannelData wChannelEnvelopeStates, $00
	call handleEnvelopes
	m_WriteChannelData wChannelVibratoActive, $00
	m_ReadChannelData wChannelVibratos
	and $f0
	srl a
	srl a
	srl a
	m_WriteChannelData wChannelVibratoCounters
	call updatePlayedFrequency
;;
; Read a byte, set the channel wait counter to the value
setChannelWaitCounter:
	call getNextChannelByte
	dec a
	m_WriteChannelData wChannelWaitCounters
	ret

;;
; Determines the time to wait until the envelope with sweep
; pace c is expected to have reached the volume level in b
; @param[out]	a	Number of ticks to wait for the envelope
getWaitTimeForEnvelope:
	ld a,b
	sla a
	sla a
	sla a
	add c
	m_ReadDataFromHlPlusA envelopeWaitTable
	ret

;;
; Sends wSoundFrequency to given value plus value in table at wChannelPitchShift.
setSoundFrequency:
	push hl
	m_ReadChannelData wChannelPitchShift
	ld d,a
	sla d
	ld d,$00
	jr nc,+
		dec d
	+
	ld e,a
	pop hl
	add hl,de

	ld a,(wSoundChannel)
	sla a
	;add <hSoundData3
	;m_WriteHlToFF00PlusA
	ld b,a
	ld a,l
	ld c,<hSoundData3
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c

setFrequencyToHl:
	ld a,l
	ld (wSoundFrequencyL),a
	ld a,h
	ld (wSoundFrequencyH),a
	ret

;;
; Handles envelopes for square channels, and redirects channel 4 to updateWaveChannelVolume
handleEnvelopes:
	ld a,(wSoundChannel)
	cp MUS_WAVE
	jp z,updateWaveChannelVolume

	m_ReadChannelDataFlag, wChannelEnvelopeStates
	jr z,@checkEnvelopeRequested

	cp $01
	jr z,@waitForNoteStartEnvelope

	xor a
	ld (wSoundCmdEnvelope),a
	ret

@checkEnvelopeRequested:
	m_ReadChannelDataFlag wChannelEnvelopes
	jr z,@checkAndStartNoteEndEnvelope

	; Start envelope for starting the note
	ld c,a
	; Initial volume 1 and increase over time
	or $18
	ld (wSoundCmdEnvelope),a
	push bc
	call getChannelVolume
	pop bc
	ld b,a
	call getWaitTimeForEnvelope
	m_WriteChannelData wChannelEnvelopeWaitCounters
	m_WriteChannelData wChannelEnvelopeStates,$01
	jp updateSquareChannelVolume

@waitForNoteStartEnvelope:
	m_ReadChannelDataFlag wChannelEnvelopeWaitCounters
	jr z,@checkAndStartNoteEndEnvelope

	dec a
	ld (hl),a
	xor a
	ld (wSoundCmdEnvelope),a
	ret

@checkAndStartNoteEndEnvelope:
	m_ReadChannelDataFlag wChannelEnvelopes2
	ld a,$03
	jr nz,+
		dec a
	+
	m_WriteChannelData wChannelEnvelopeStates
	call getChannelVolume
	sla a
	sla a
	sla a
	sla a
	ld (wSoundCmdEnvelope),a
	m_ReadChannelData wChannelEnvelopes2
	ld c,a
	ld a,(wSoundCmdEnvelope)
	or c
	ld (wSoundCmdEnvelope),a

;;
updateSquareChannelVolume:
	ld a,(wSoundChannel)
	cp SFX_SQUARE_1
	jr nc,++
		ld a,(wMusicVolume)
		or a
		ret z

		ld a,(wSoundChannel)
		inc a
		inc a
		m_ReadDataFromHlPlusA wChannelsEnabled
		or a
		ret nz
	++

	ld a,(wSoundChannel)
	and $01
	jr nz,+
		; Channel 1 only: sweep off
		ld a,$08
		ld ($ff00+R_SQ1_SWEEP),a
	+

	; Set channel volume
	ld a,(wSoundChannel)
	and $01
	ld b,a
	sla a
	sla a
	add b
	ld b,a
	add R_SQ1_VOLUME_AND_ENVELOPE
	ld c,a
	ld a,(wSoundCmdEnvelope)
	ld ($ff00+c),a
	inc c
	m_ReadChannelData wChannelFrequencyModeAndLengthTimerEnabled

	; Length enable
	and $40

	; Trigger
	or $80
	ld (wSoundCmdEnvelope),a
	ret

;;
; Updates wWaveChannelVolume[MUS_WAVE] and, if changed, writes to R_WAVE_OUTPUT_LEVEL if possible
updateWaveChannelVolume:
	call getWaveChannelVolume
	ld b,a
	ld a,(wWaveChannelVolume+MUS_WAVE)
	cp b
	ret z

	ld a,b
	ld (wWaveChannelVolume+MUS_WAVE),a
	call isWaveChannelUnavailable
	ret nz

	ld a,(wWaveChannelVolume+MUS_WAVE)
	ld ($ff00+R_WAVE_OUTPUT_LEVEL),a
	ret

;;
; Intended for use with square and noise channels, but not used by channel 7
; @param[out]	a	Final volume of channel wSoundChannel after possible modification with wMusicVolume ($0-$f)
getChannelVolume:
	m_ReadChannelData wChannelVolumes
	push af
	ld a,(wSoundChannel)
	cp SFX_SQUARE_1
	jr nc,@fullVolume

@affectedByMusicVolume:
	ld a,(wMusicVolume)
	and $03
	rst_jumpTable
	.dw @muted
	.dw @quarterVolume
	.dw @halfVolume
	.dw @fullVolume

@muted:
	pop af
	xor a
	ret

@fullVolume:
	pop af
	or a
	ret

@halfVolume:
	pop af
	srl a
	ret

@quarterVolume:
	pop af
	srl a
	srl a
	ret

standardCmdMusicWaveChannel:
standardCmdSfxWaveChannel:
	m_ReadChannelDataFlag wChannelFrequencyModeAndLengthTimerEnabled
	jr z,+

	call getNextChannelByte
	ld l,a
	ld a,(wSoundCmd)
	ld h,a
	jp @arbitraryFrequency
+
	ld a,(wSoundCmd)
	cp $60
	jr nz,@freqCommand
@cmd60:
	m_WriteChannelData wChannelIsPlayingRest,$01

	xor a ; volume guaranteed to be 0 because we just set rest to 1
	m_WriteChannelData wWaveChannelVolume
	call isWaveChannelUnavailable
	jr nz,+
		ld ($ff00+R_WAVE_OUTPUT_LEVEL),a
	+

	jp setChannelWaitCounter
@freqCommand:
	m_WriteChannelData wChannelIsPlayingRest,$00
	ld a,(wSoundCmd)
	ld hl,soundFrequencyTable
	call readWordFromTable
@arbitraryFrequency:
	call setSoundFrequency
	m_WriteChannelData wChannelVibratoActive,$00
	m_ReadChannelData wChannelVibratos
	and $f0
	srl a
	srl a
	srl a
	m_WriteChannelData wChannelVibratoCounters
	call getWaveChannelVolume
	m_WriteChannelData wWaveChannelVolume
	call isWaveChannelUnavailable
	jr nz,+

	m_ReadChannelData wWaveChannelVolume
	ld ($ff00+R_WAVE_OUTPUT_LEVEL),a
	ld a,(wSoundFrequencyL)
	ld ($ff00+R_WAVE_PERIOD_LOW),a
	ld a,(wSoundFrequencyH)
	ld ($ff00+R_WAVE_PERIOD_HIGH_AND_CTRL),a
+
	jp setChannelWaitCounter

;;
; @param[out]	a	Volume of channel wSoundChannel dependent of wMusicVolume, in a form that can be written to NR32
getWaveChannelVolume:
	m_ReadChannelDataFlag wChannelIsPlayingRest
	jr nz,@mute
	ld a,(wSoundChannel)
	cp SFX_WAVE
	jr nc,@fullVolume

	ld a,(wMusicVolume)
	and $03
	rst_jumpTable
	.dw @mute
	.dw @quarterVolume
	.dw @halfVolume
	.dw @fullVolume

@mute:
	xor a
	ret
@fullVolume:
	ld a,$20
	ret
@halfVolume:
	ld a,$40
	ret
@quarterVolume:
	ld a,$60
	ret

;;
standardCmdMusicNoiseChannel:
	ld a,(wSoundCmd)
	ld c,a
	ld de,noiseFrequencyTable
-
	ld a,(de)
	inc de
	cp $ff
	jr z,@wait

	cp c
	jr z,+

	inc de
	inc de
	jr -
+
	ld a,(de)
	ld l,a
	inc de
	ld a,(de)
	ld h,a
	ld a,(wChannelsEnabled+SFX_NOISE)
	or a
	jr nz,@wait

	push hl
	call getChannelVolume
	pop hl
	sla a
	sla a
	sla a
	sla a
	or l
	ld ($ff00+R_NOISE_VOLUME_AND_ENVELOPE),a
	ld a,h
	ld ($ff00+R_NOISE_FREQUENCY_AND_RAND),a
	ld a,$80
	ld ($ff00+R_NOISE_CTRL),a
@wait:
	jp setChannelWaitCounter

;;
standardCmdSfxNoiseChannel:
	ld a,(wSoundCmd)
	ld ($ff00+R_NOISE_FREQUENCY_AND_RAND),a
	xor a
	ld ($ff00+R_NOISE_TIMER),a
	ld a,(wTriggerSfxNoiseChannelOnNextSound)
	or a
	jr z,+
	ld ($ff00+R_NOISE_CTRL),a
+
	xor a
	ld (wTriggerSfxNoiseChannelOnNextSound),a
	jp setChannelWaitCounter

;;
; Disables and silences the current channel
channelCmdff:
	m_WriteChannelData wChannelsEnabled, $00
;;
; Ensures no sound is audible on the current channel by setting the volume to $0 or turning off the wave channel DAC
silencePlayedSound:
	ld a,(wSoundChannel)
	rst_jumpTable
	.dw @musicSquareChannel
	.dw @musicSquareChannel
	.dw @sfxSquareChannel
	.dw @sfxSquareChannel
	.dw @musicWaveChannel
	.dw @sfxWaveChannel
	.dw @noiseChannel
	.dw @noiseChannel

@musicSquareChannel:
	; Only update if the corresponding sfx channel is not enabled
	ld a,(wSoundChannel)
	inc a
	inc a
	m_ReadDataFromHlPlusA wChannelsEnabled
	or a
	ret nz

@sfxSquareChannel:
	; Sfx always updates

	; If an envelope is active that decreases volume 
	; over time, allow the sound to keep playing
	m_ReadChannelData wChannelEnvelopeStates
	cp $03
	ret z

	; Set volume to $0 and trigger channel
	ld a,$08
	ld (wSoundCmdEnvelope),a
	call updateSquareChannelVolume
	jp updatePlayedFrequency

@musicWaveChannel:
	call isWaveChannelUnavailable
	ret nz

	; Disable DAC
	xor a
	ld ($ff00+R_WAVE_DAC_ENABLE),a
	ret

@sfxWaveChannel:
	ld a,(wChannelsEnabled+MUS_WAVE)
	or a
	jr z,++

	; Music channel is enabled
	ld e,MUS_WAVE
	m_ReadDataFromHlPlusE wChannelDutyCycles
	ld (wWaveformIndex),a
	call setWaveform
	ld a,(wWaveChannelVolume+MUS_WAVE)
	ld ($ff00+R_WAVE_OUTPUT_LEVEL),a
	ret
++

	; Disable DAC
	xor a
	ld ($ff00+R_WAVE_DAC_ENABLE),a
	ret

@noiseChannel:
	; Set volume to $0 and trigger channel
	ld a,$08
	ld ($ff00+R_NOISE_VOLUME_AND_ENVELOPE),a
	ld a,$80
	ld ($ff00+R_NOISE_CTRL),a
	ret

;;
setWaveform:
	call isWaveChannelUnavailable
	ret nz

@waitLoop:
	; Wait for channel 3 to be on
	xor a
	ld ($ff00+R_WAVE_DAC_ENABLE),a
	ld a,($ff00+R_SOUND_ENABLE)
	and $04
	jr nz,@waitLoop

	; Copy waveform to $ff30
	ld a,(wWaveformIndex)
	ld hl,waveformTable
	call readWordFromTable
	ld c,$10
	ld de,$ff30
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec c
	jr nz,-

-	; Enable channel 3
	ld a,$80
	ld ($ff00+R_WAVE_DAC_ENABLE),a
	ld a,($ff00+R_WAVE_DAC_ENABLE)
	and $80
	jr z,-

	; Restart channel 3 (but trashes lower frequency bits?)
	ld a,$80
	ld ($ff00+R_WAVE_PERIOD_HIGH_AND_CTRL),a
	ret

;;
; Jump to word from argument
channelCmdfe:
	call getNextChannelByte
	ld l,a
	call getNextChannelByte
	ld h,a
	ld a,(wSoundChannel)
	;add a
	;add <hSoundChannelAddresses
	;m_WriteHlToFF00PlusA

	sla a
	ld b,a
	ld a,l
	ld c,<hSoundChannelAddresses
	call writeIndexedHighRamAndIncrement
	ld a,h
	ld ($ff00+c),a
	inc c

	jp doNextChannelCommand

multiplyHlByA:
	or a
	jr nz,+
	ld hl,$0000
	ret
+
	ld e,l
	ld d,h
--
	dec a
	jr z,+

	add hl,de
	jp --
+
	ret

.include "audio/common/frequency.s"
.include "audio/common/envelope.s"
.include "audio/common/vibrato.s"

;;
; @param a The sound to play.
playSound:
	push bc
	push de
	push hl
	ld (wSoundTmp),a
	or a
	jp z,@playSoundEnd
	sub $f0
	jr c,@normalSound
	rst_jumpTable
	.dw @sndf0
	.dw @sndf1
	.dw @sndf2
	.dw @sndf3
	.dw @sndf4
	.dw @sndf5
	.dw @sndf6
	.dw @sndf7
	.dw @sndf8
	.dw @sndf9
	.dw @sndfa
	.dw @sndfb
	.dw @sndfc
	.dw @sndfd
	.dw @sndfe
	.dw @normalSound

; Stop music
@sndf0:
	ld a,SNDCTRL_DE
	ld (wSoundTmp),a
	jr @normalSound

; Stop sound effects
@sndf1:
	call stopSfx
	jp @playSoundEnd

; Disable sound
@sndf5:
	call silenceAllChannels
	ld a,$01
	ld (wSoundDisabled),a
	jp @setVolumeAndEnd

; Enable sound
@sndf6:
	xor a
	ld (wSoundDisabled),a
	jp @setVolumeAndEnd

; Fast fadeout
@sndfa:
	ld a,$07
	jr +

; Medium fadeout
@sndfb:
	ld a,$0f
	jr +

; Slow fadeout
@sndfc:
	ld a,$1f
+
	ld (wSoundFadeSpeed),a
	xor a
	ld (wSoundFadeCounter),a
	inc a
	ld (wSoundFadeDirection),a
	ld a,SND_VOLUME_MAX
	ld (wSoundVolume),a
	jp @playSoundEnd

; Fast fadein
@sndf7:
	ld a,$03
	jr +

; Medium fadein
@sndf8:
	ld a,$07
	jr +

; Slow fadein
@sndf9:
	ld a,$0f
+
	ld (wSoundFadeSpeed),a
	ld a,$0a
	ld (wSoundFadeDirection),a
	xor a
	ld (wSoundVolume),a
	ld (wSoundFadeCounter),a
	jp @playSoundEnd

; these aren't coded to do anything special, and as
; a result they default to the normalSound behavior
@sndf2:
@sndf3:
@sndf4:
@sndfd:
@sndfe:

@normalSound:
.ifdef ROM_COMBO
	call wIsSeasons
	ld hl,soundPointers_seasons
	jr c,+
		ld hl,soundPointers_ages
	+
.else
	ld hl,soundPointers
.endif

	ld a,(wSoundTmp)
	ld e,a
	xor a
	ld d,a
	ld (wSoundFadeDirection),a

	; add a*3 to hl
	add hl,de
	add hl,de
	add hl,de

	ldi a,(hl)
	ld (wLoadingSoundBank),a

	rst_derefHl

@nextSoundChannel:
	ldi a,(hl)
	cp $ff
	jr nz,+
	jp @setVolumeAndEnd
+
	ld (wSoundTmp),a
	and $f0
	swap a
	inc a
	ld (wSoundChannelValue),a
	ld a,(wSoundTmp)
	and $0f
	ld (wSoundTmp),a
	push hl

	m_ReadDataFromHlPlusA wChannelsEnabled
	pop hl
	ld c,a
	ld a,(wSoundChannelValue)
	cp c
	jr nc,+
		inc hl
		inc hl
		jp @nextSoundChannel
	+
	push hl
	ld a,(wSoundTmp)
	ld e,a

	ld a,(wSoundChannelValue)
	m_WriteDataToHlPlusE wChannelsEnabled

	ld a,$08
	m_WriteDataToHlPlusE wChannelVolumes

	xor a
	m_WriteDataToHlPlusE wChannelWaitCounters

	ld a,(wSoundTmp)
	cp MUS_NOISE
	jr nc,++	; Noise channels

	rst_jumpTable
	.dw @squareChannel
	.dw @squareChannel
	.dw @squareChannel
	.dw @squareChannel
	.dw @waveChannel
	.dw @waveChannel

@waveChannel:
	; Clear a bunch of variables
	m_ClearChannelData wChannelVibratos wChannelSweep wChannelPitchShift \
	                   wChannelFrequencyModeAndLengthTimerEnabled
	jr ++

@squareChannel:
	; Clear a bunch of variables
	m_ClearChannelData wChannelEnvelopes wChannelEnvelopes2 wChannelDutyCycles \
	                   wChannelVibratos wChannelSweep wChannelPitchShift \
					   wChannelFrequencyModeAndLengthTimerEnabled
	++
	; Write the bank for this sound channel into hSoundChannelBanks
	pop hl
	ld a,(wSoundTmp)
	ld b,a

	add <hSoundChannelBanks
	ld c,a
	ld a,(wLoadingSoundBank)
	ld ($ff00+c),a

	; Write the address for this sound channel into hSoundChannelAddresses
	ld a,b
	add a
	add <hSoundChannelAddresses
	ld c,a

	ldi a,(hl)
	ld ($ff00+c),a
	inc c

	ldi a,(hl)
	ld ($ff00+c),a
	jp @nextSoundChannel

@setVolumeAndEnd:
	ld a,SND_VOLUME_MAX
	ld (wSoundVolume),a
@playSoundEnd:
	pop hl
	pop de
	pop bc
	ret

;;
; Reads a word at hl+a*2 into de and hl. Index can't be higher than $7f.
readWordFromTable:
	sla a
	ld d,$00
	ld e,a
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld h,d
	ld l,e
	ret

;;
; Adds b to c, writes a to ($ff00+c), increments c.
writeIndexedHighRamAndIncrement:
	push af
	ld a,b
	add c
	ld c,a
	pop af
	ld ($ff00+c),a
	inc c
	ret

.include "audio/common/noise.s"
.include "audio/common/waveforms.s"
.include {"audio/{GAME}/soundChannelPointers.s"}
.include {"audio/{GAME}/soundPointers.s"}

.ends ; End of section AudioCode


.include {"audio/{GAME}/soundChannelData.s"}
