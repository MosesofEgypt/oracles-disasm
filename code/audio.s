.include "include/constants.s"
.include "include/macros.s"
.include "include/rominfo.s"
.include "include/musicMacros.s"

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
; Unused? (The address it jumps too doesn't seem like it would do anything useful...)
func_39_400c:
	pop af
	jp $4d3e

;;
; @param	a	Volume (0-3)
b39_updateMusicVolume:
	jp updateMusicVolume

;;
initSound:
	ldh (<hSoundDataBaseBank),a
	call stopSound
	ld a,$03
	ld (wMusicVolume),a
	xor a
	ld (wSoundFadeDirection),a
	ld (wSoundFadeCounter),a
	ld (wSoundDisabled),a
	ld (wc023),a
	ld a,$8f
	ld ($ff00+R_NR52),a
	ld a,$77
	ld (wSoundVolume),a
	ld ($ff00+R_NR50),a
	ld a,$ff
	ld ($ff00+R_NR51),a
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
	ldi a,(hl)
	ld c,a
	ld a,:initSound
	ld ($2222),a
	ld a,c
	ret
@readFunctionEnd:


;;
; @param	a	Volume (0-3)
;
updateMusicVolume:
	push bc
	push de
	push hl
	push af
	call @updateSquareChannelVolumes

	pop af
	ld (wMusicVolume),a
	or a
	ld a,$01
	jr z,+
	xor a
+
	ld (wc023),a
	pop hl
	pop de
	pop bc
	ret

;;
@updateSquareChannelVolumes:
	; Update square 1's volume
	xor a
	call _updateChannel

	; Update square 2's volume
	ld a,$01
	call _updateChannel
	ret

;;
stopSound:
	xor a
-
	ld (wSoundChannel),a
	call channelCmdff
	ld a,(wSoundChannel)
	inc a
	cp $08
	jr nz,-
	ret

;;
func_39_40b9:
	xor a
-
	ld (wSoundChannel),a
	call updateChannelStuff
	ld a,(wSoundChannel)
	inc a
	cp $08
	jr nz,-
	ret

;;
; Disable all sound effect channels
;
stopSfx:
	; Square 1
	ld a,$02
	call _disableChannel

	; Square 2
	ld a,$03
	call _disableChannel

	; Wave
	ld a,$05
	call _disableChannel

	; Noise
	ld a,$07
	call _disableChannel
	ret

_disableChannel:
	call _channelHelper
	ret z
	jp channelCmdff

_updateChannel:
	call _channelHelper
	ret z
	jp updateChannelStuff

_channelHelper:
	ld (wSoundChannel),a
	ld hl,wChannelsEnabled
	call readChannelDataFromHl
	or a
	ret

;;
updateSound:
	push bc
	push de
	push hl
	ld a,(wSoundDisabled)
	or a
	jr nz,@ret

	ld a,(wSoundVolume)
	ld ($ff00+R_NR50),a
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

	sub $11
	ld (wSoundVolume),a
	jp @updateChannels

@incVolume:
	ld a,(wSoundVolume)
	cp $77
	jr z,@clearFadeVariables

	add $11
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
	call _channelHelper
	jr z,@nextChannel

	ld hl,wChannelWaitCounters
	call readChannelDataFromHl
	or a
	jr nz,+

	call doNextChannelCommand
	jr @nextChannel
+
	call func_39_41c2
@nextChannel:
	ld a,(wSoundChannel)
	inc a
	cp $08
	jr nz,@channelLoop

	ld a,(wc023)
	cp $01
	jr nz,@ret

	ld a,$02
	ld (wc023),a

@ret:
	pop hl
	pop de
	pop bc
	ret

;;
func_39_41c2:
	ld hl,wChannelWaitCounters
	call readChannelDataFromHl
	dec a
	ld (hl),a
	ld a,(wSoundChannel)
	cp $06
	ret nc

	ld hl,wc039
	call readChannelDataFromHl
	and $40
	ret nz
	ld a,(wSoundChannel)
	cp $05
	call c,func_39_464c

;;
func_39_41f3:
	ld hl,wc03f
	call readChannelDataFromHl
	ld c,a
	and $7f
	jr z,label_39_024

	ld a,c
	and $80
	ld d,$00
	jr z,++
	ld d,$ff
++
	push de
	ld hl,wc03f
	call readChannelDataFromHl
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
	add <hSoundData3
	ld c,a
	ld a,l
	ld ($ff00+c),a
	inc c
	ld a,h
	ld ($ff00+c),a
	inc c
label_39_024:
	ld hl,wc045
	call readChannelDataFromHl
	and $10
	jr nz,label_39_026

	ld hl,wc051
	call readChannelDataFromHl
	or a
	jr z,label_39_025

	dec a
	ld hl,wc051
	call writeChannelDataToHl
	ld hl,$0000
	jp func_42d1

label_39_025:
	ld a,$10

	ld hl,wc045
	call writeChannelDataToHl
	xor a

	ld hl,wc051
	call writeChannelDataToHl

label_39_026:
	ld hl,wc051
	call readChannelDataFromHl
	cp $08
	jr nz,label_39_027
	xor a

	ld hl,wc051
	call writeChannelDataToHl
	xor a

label_39_027:
	ld hl,data_4b40
	rst_addDoubleIndex
	rst_derefHl

	push hl
	ld hl,wc051
	call readChannelDataFromHl
	inc a
	ld (hl),a

	ld hl,wChannelVibratos
	call readChannelDataFromHl
	and $0f
	pop hl

	or a

	jr nz,+
		ld h,a
		ld l,a
		jr func_42d1
	+
	ld e,l
	ld d,h
	-
		dec a
		jr z,func_42d1
		add hl,de
		jr -

;;
func_42d1:
	ld a,(wSoundChannel)
	sla a
	ld b,a
	ld a,b
	add $f2
	ld c,a
	ld a,($ff00+c)
	inc c
	ld e,a
	ld a,($ff00+c)
	inc c
	ld d,a
	add hl,de
	ld a,l
	ld (wSoundFrequencyL),a
	ld a,h
	ld (wSoundFrequencyH),a

;;
func_42ea:
	ld a,(wSoundChannel)
	cp $04
	jr nc,label_39_029

	cp $02
	jr nc,label_39_028

	inc a
	inc a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	or a
	jr z,label_39_028
	ret

label_39_028:
	ld a,(wSoundChannel)
	and $01
	ld b,a
	sla a
	sla a
	add b
	ld b,a

	add R_NR13
	ld c,a
	ld a,(wSoundFrequencyL)
	ld ($ff00+c),a
	inc c

	ld a,(wSoundCmdEnvelope)
	ld e,a
	ld a,(wSoundFrequencyH)
	or e
	ld ($ff00+c),a
	inc c

	ld hl,wChannelDutyCycles
	call readChannelDataFromHl
	push af
	ld a,$11
	add b
	ld c,a
	pop af
	ld ($ff00+c),a
	ret

label_39_029:
	call func_39_434b
	or a
	jr nz,label_39_030
	ld a,l
	ld ($ff00+R_NR33),a
	ld a,h
	ld ($ff00+R_NR34),a
	xor a
	ld ($ff00+R_NR31),a
label_39_030:
	ret

;;
; @param[out]	a	0 or 1 (something about whether wSoundChannel can be active?)
func_39_434b:
	ld a,(wSoundChannel)
	cp $05
	jr z,@zero

	ld a,(wChannelsEnabled+5)
	or a
	jr nz,@one

	ld a,(wc023)
	cp $02
	jr z,@one
@zero:
	xor a
	ret
@one:
	ld a,$01
	ret

;;
getNextChannelByte:
	push bc
	push hl
	ld a,(wSoundChannel)
	ld b,a

	add a
	ld hl,hSoundChannelAddresses
	rst_addAToHl
	rst_derefHl

	ld a,b
	add <hSoundChannelBanks
	ld c,a
	ld a,($ff00+c)

	call wMusicReadFunction
	push af

	; move to the next byte in the data
	ld a,b
	sla a
	add <hSoundChannelAddresses
	ld c,a
	ld a,l
	ld ($ff00+c),a
	inc c
	ld a,h
	ld ($ff00+c),a

	pop af
	pop hl
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
	ld hl,@table
	rst_jumpTable

@table:
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
;
channelCmdf9:
	ld a,(wSoundChannel)
	cp $06
	jr nc,++

	call getNextChannelByte
	ld hl,wChannelVibratos
	call writeChannelDataToHl
	jp doNextChannelCommand

;;
channelCmdf8:
	ld a,(wSoundChannel)
	cp $06
	jr nc,++

	call getNextChannelByte
	ld hl,wc03f
	call writeChannelDataToHl
	jp doNextChannelCommand

;;
channelCmdfd:
	ld a,(wSoundChannel)
	cp $06
	jr nc,++

	call getNextChannelByte
	ld hl,wChannelPitchShift
	call writeChannelDataToHl
	jp doNextChannelCommand
++
	call getNextChannelByte
	jp doNextChannelCommand

;;
cmde0Toef:
	and $07
	ld hl,wChannelEnvelopes
	call writeChannelDataToHl
	call getNextChannelByte

	and $07
	ld hl,wChannelEnvelopes2
	call writeChannelDataToHl
	jp doNextChannelCommand

;;
channelCmdf0:
	ld a,(wSoundChannel)
	cp $07
	jr z,label_39_038

	call getNextChannelByte
	push af
	and $3f
	jr z,label_39_037

	pop af
	ld hl,wChannelDutyCycles
	call writeChannelDataToHl
	ld a,$41
	ld hl,wc039
	call writeChannelDataToHl
	jp doNextChannelCommand
label_39_037:
	pop af
	and $c0
	ld hl,wChannelDutyCycles
	call writeChannelDataToHl

	ld a,$01
	ld hl,wc039
	call writeChannelDataToHl
	jp doNextChannelCommand

label_39_038:
	call getNextChannelByte
	ld ($ff00+R_NR42),a
	xor a
	ld ($ff00+R_NR41),a
	ld a,$80
	ld (wc01c),a
	jp doNextChannelCommand

; Command $d0 to $df
cmdVolume:
	push af
	ld a,(wSoundChannel)
	cp $04
	jr z,@next

	pop af
	and $0f
	ld hl,wChannelVolumes
	call writeChannelDataToHl
	jp doNextChannelCommand

@next:
	pop af
	jp doNextChannelCommand

;;
channelCmdf6:
	ld a,(wSoundChannel)
	cp $04
	jr z,@wave

	cp $05
	jr z,@wave

	call getNextChannelByte
	and $03
	swap a
	sla a
	sla a
	ld hl,wChannelDutyCycles
	call writeChannelDataToHl
	jp doNextChannelCommand

@wave:
	call getNextChannelByte
	ld hl,wChannelDutyCycles
	call writeChannelDataToHl
	ld (wWaveformIndex),a
	call setWaveform
	jp doNextChannelCommand

writeChannelDataToHl:
	push af
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	pop af
	ld (hl),a
	ret

readChannelDataFromHl:
	ld a,(wSoundChannel)
	ld e,a
	ld d,$00
	add hl,de
	ld a,(hl)
	ret

;;
standardSoundCmd:
	ld a,(wSoundChannel)
	ld hl,@table
	rst_jumpTable

@table:
	.dw @channel0To3
	.dw @channel0To3
	.dw @channel0To3
	.dw @channel0To3
	.dw standardCmdChannels4To5
	.dw standardCmdChannels4To5
	.dw standardCmdChannel6
	.dw standardCmdChannel7

@channel0To3:
	ld hl,wc039
	call readChannelDataFromHl
	or a
	jr z,+

	call getNextChannelByte
	ld l,a
	ld a,(wSoundCmd)
	ld h,a
	jp @cmdUnknown
+
	ld a,(wSoundCmd)
	cp $60
	jr z,@cmd60

	cp $61
	jr z,@cmd61

	jp @cmdFrequency

@cmd60:
	ld hl,wChannelEnvelopes2
	call readChannelDataFromHl
	or a
	jr nz,@cmd61

	ld a,$02
	ld hl,wc05d
	call writeChannelDataToHl
	call getChannelVolume
	sla a
	sla a
	sla a
	sla a
	ld c,$01
	or c
	ld (wSoundCmdEnvelope),a
	call updateChannelVolume
	call func_39_41f3
@cmd61:
	jp setChannelWaitCounter

@cmdFrequency:
	ld a,(wSoundCmd)
	sub $0c
	ld hl,soundFrequencyTable
	rst_addDoubleIndex
	rst_derefHl
@cmdUnknown:
	call setSoundFrequency
	xor a
	ld hl,wc05d
	call writeChannelDataToHl
	call func_39_464c
	xor a
	ld hl,wc045
	call writeChannelDataToHl
	xor a
	ld hl,wChannelVibratos
	call readChannelDataFromHl
	and $f0
	srl a
	srl a
	srl a
	ld hl,wc051
	call writeChannelDataToHl
	call func_42ea
;;
; Read a byte, set the channel wait counter to the value
setChannelWaitCounter:
	call getNextChannelByte
	dec a
	ld hl,wChannelWaitCounters
	call writeChannelDataToHl
	ret

;;
func_39_4609:
	ld hl,data_4ad0
	ld a,b
	sla a
	sla a
	sla a
	add c
	ld d,$00
	ld e,a
	add hl,de
	ld a,(hl)
	ret

;;
; Sends wSoundFrequency to given value plus value in table at wChannelPitchShift.
setSoundFrequency:
	push hl
	ld hl,wChannelPitchShift
	call readChannelDataFromHl
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
	add <hSoundData3
	ld c,a
	ld a,l
	ld ($ff00+c),a
	inc c
	ld a,h
	ld ($ff00+c),a
	inc c
	ld a,l
	ld (wSoundFrequencyL),a
	ld a,h
	ld (wSoundFrequencyH),a
	ret

;;
func_39_464c:
	ld a,(wSoundChannel)
	cp $04
	jp z,func_39_4766
	ld hl,wc05d
	call readChannelDataFromHl
	or a
	jr z,label_39_047

	cp $01
	jr z,label_39_048

	xor a
	ld (wSoundCmdEnvelope),a
	ret
label_39_047:
	ld hl,wChannelEnvelopes
	call readChannelDataFromHl
	or a
	jr z,label_39_049

	ld c,a
	or $18
	ld (wSoundCmdEnvelope),a
	push bc
	call getChannelVolume
	pop bc
	ld b,a
	call func_39_4609
	ld hl,wc061
	call writeChannelDataToHl
	ld a,$01
	ld hl,wc05d
	call writeChannelDataToHl
	jp updateChannelVolume

label_39_048:
	ld hl,wc061
	call readChannelDataFromHl
	or a
	jr z,label_39_049

	ld hl,wc061
	call readChannelDataFromHl
	dec a
	ld (hl),a
	xor a
	ld (wSoundCmdEnvelope),a
	ret

label_39_049:
	ld hl,wChannelEnvelopes2
	call readChannelDataFromHl
	or a
	jr nz,+

	ld a,$02
	jr ++
+
	ld a,$03
++
	ld hl,wc05d
	call writeChannelDataToHl
	call getChannelVolume
	sla a
	sla a
	sla a
	sla a
	ld (wSoundCmdEnvelope),a
	ld hl,wChannelEnvelopes2
	call readChannelDataFromHl
	ld c,a
	ld a,(wSoundCmdEnvelope)
	or c
	ld (wSoundCmdEnvelope),a
	jp updateChannelVolume

;;
updateChannelVolume:
	ld a,(wSoundChannel)
	cp $02
	jr nc,++

	ld a,(wMusicVolume)
	or a
	jr z,@ret

	ld a,(wSoundChannel)
	inc a
	inc a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	or a
	jr z,++
@ret:
	ret
++
	ld a,(wSoundChannel)
	and $01
	jr nz,+

	; Channel 1 only: sweep off
	ld a,$08
	ld ($ff00+R_NR10),a
+
	; Set channel volume
	ld a,(wSoundChannel)
	and $01
	ld b,a
	sla a
	sla a
	add b
	add R_NR12
	ld c,a
	ld a,(wSoundCmdEnvelope)
	ld ($ff00+c),a
	ld hl,wc039
	call readChannelDataFromHl
	and $40
	or $80
	ld (wSoundCmdEnvelope),a
	ret

;;
func_39_4766:
	call func_39_489e
	ld b,a
	ld a,(wc025+4)
	cp b
	ret z

	call func_39_489e
	ld (wc025+4),a
	call func_39_434b
	or a
	ret nz

	ld a,(wc025+4)
	ld ($ff00+R_NR32),a
	ret

;;
getChannelVolume:
	ld a,(wSoundChannel)
	cp $02
	jr nc,label_39_056
;;
func_39_478c:
	ld a,(wMusicVolume)
	or a
	jr z,label_39_059
	cp $01
	jr z,label_39_058
	cp $02
	jr z,label_39_057
label_39_056:
	ld hl,wChannelVolumes
	call readChannelDataFromHl
	ret
label_39_057:
	ld hl,wChannelVolumes
	call readChannelDataFromHl
	srl a
	ret
label_39_058:
	ld hl,wChannelVolumes
	call readChannelDataFromHl
	srl a
	srl a
	ret
label_39_059:
	xor a
	ret

standardCmdChannels4To5:
	ld hl,wc039
	call readChannelDataFromHl
	or a
	jr z,+

	call getNextChannelByte
	ld l,a
	ld a,(wSoundCmd)
	ld h,a
	jp @cmdUnknown
+
	ld a,(wSoundCmd)
	cp $60
	jr nz,@freqCommand
@cmd60:
	ld a,$01
	ld hl,wc02d
	call writeChannelDataToHl
	call func_39_489e
	ld hl,wc025
	call writeChannelDataToHl
	call func_39_434b
	or a
	jr nz,+

	ld hl,wc025
	call readChannelDataFromHl
	ld ($ff00+R_NR32),a
+
	jp setChannelWaitCounter
@freqCommand:
	xor a
	ld hl,wc02d
	call writeChannelDataToHl
	ld a,(wSoundCmd)
	ld hl,soundFrequencyTable
	rst_addDoubleIndex
	rst_derefHl
@cmdUnknown:
	call setSoundFrequency
	xor a
	ld hl,wc045
	call writeChannelDataToHl
	xor a
	ld hl,wChannelVibratos
	call readChannelDataFromHl
	and $f0
	srl a
	srl a
	srl a
	ld hl,wc051
	call writeChannelDataToHl
	call func_39_489e
	ld hl,wc025
	call writeChannelDataToHl
	call func_39_434b
	or a
	jr nz,+

	ld hl,wc025
	call readChannelDataFromHl
	ld ($ff00+R_NR32),a
	ld a,(wSoundFrequencyL)
	ld ($ff00+R_NR33),a
	ld a,(wSoundFrequencyH)
	ld ($ff00+R_NR34),a
+
	jp setChannelWaitCounter

;;
func_39_489e:
	ld hl,wc02d
	call readChannelDataFromHl
	or a
	jr nz,label_39_067
	ld a,(wSoundChannel)
	cp $05
	jr nc,label_39_064
	ld a,(wMusicVolume)
	or a
	jr z,label_39_067
	cp $01
	jr z,label_39_066
	cp $02
	jr z,label_39_065
label_39_064:
	ld a,$20
	ret
label_39_065:
	ld a,$40
	ret
label_39_066:
	ld a,$60
	ret
label_39_067:
	xor a
	ret

;;
standardCmdChannel6:
	ld a,(wSoundCmd)
	ld c,a
	ld de,noiseFrequencyTable
-
	ld a,(de)
	inc de
	cp $ff
	jr z,@end

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
	ld a,(wChannelsEnabled+$07)
	or a
	jr nz,@end

	push hl
	call func_39_478c
	pop hl
	sla a
	sla a
	sla a
	sla a
	or l
	ld ($ff00+R_NR42),a
	ld a,h
	ld ($ff00+R_NR43),a
	ld a,$80
	ld ($ff00+R_NR44),a
@end:
	jp setChannelWaitCounter

;;
standardCmdChannel7:
	ld a,(wSoundCmd)
	ld ($ff00+R_NR43),a
	xor a
	ld ($ff00+R_NR41),a
	ld a,(wc01c)
	or a
	jr z,+
	ld ($ff00+R_NR44),a
+
	xor a
	ld (wc01c),a
	jp setChannelWaitCounter

channelCmdff:
	xor a
	ld hl,wChannelsEnabled
	call writeChannelDataToHl
;;
; Checks whether to call updateChannelVolume on square channels, does some other things
; with the other types of channels...
;
updateChannelStuff:
	ld a,(wSoundChannel)
	ld hl,@table
	rst_jumpTable

@table:
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
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	or a
	jr z,+
	ret

@sfxSquareChannel:
	; Sfx always updates (but it still does this pointless check of the corresponding
	; music channel)
	ld a,(wSoundChannel)
	dec a
	dec a
	ld e,a
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
	or a
	jr z,+
+
	ld hl,wc05d
	call readChannelDataFromHl
	cp $03
	jr nz,+
	ret
+
	ld a,$08
	ld (wSoundCmdEnvelope),a
	call updateChannelVolume
	jp func_42ea

@musicWaveChannel:
	call func_39_434b
	or a
	ret nz

	xor a
	ld ($ff00+R_NR30),a
	ret

@sfxWaveChannel:
	ld a,(wChannelsEnabled+4)
	or a
	jr z,++

	ld de,$0004
	ld hl,wChannelDutyCycles
	add hl,de
	ld a,(hl)
	ld (wWaveformIndex),a
	call setWaveform
	ld a,(wc025+4)
	ld ($ff00+R_NR32),a
	ret
++
	xor a
	ld ($ff00+R_NR30),a
	ret

@noiseChannel:
	ld a,$08
	ld ($ff00+R_NR42),a
	ld a,$80
	ld ($ff00+R_NR44),a
	ret

;;
setWaveform:
	call func_39_434b
	or a
	ret nz

@waitLoop:
	; Wait for channel 3 to be on
	xor a
	ld ($ff00+R_NR30),a
	ld a,($ff00+R_NR52)
	and $04
	jr nz,@waitLoop

	; Copy waveform to $ff30
	ld a,(wWaveformIndex)
	ld hl,waveformTable
	rst_addDoubleIndex
	rst_derefHl
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
	ld ($ff00+R_NR30),a
	ld a,($ff00+R_NR30)
	and $80
	jr z,-

	; Restart channel 3
	ld a,$80
	ld ($ff00+R_NR34),a
	ret

channelCmdfe:
	call getNextChannelByte
	ld l,a
	call getNextChannelByte
	ld h,a
	ld a,(wSoundChannel)
	sla a
	add <hSoundChannelAddresses
	ld c,a
	ld a,l
	ld ($ff00+c),a
	inc c
	ld a,h
	ld ($ff00+c),a
	jp doNextChannelCommand

soundFrequencyTable:
	.dw $002d
	.dw $009d
	.dw $0108
	.dw $016c
	.dw $01cb
	.dw $0224
	.dw $0279
	.dw $02c8
	.dw $0313
	.dw $0358
	.dw $039b
	.dw $03db
	.dw $0416
	.dw $044f
	.dw $0484
	.dw $04b6
	.dw $04e5
	.dw $0512
	.dw $053c
	.dw $0564
	.dw $058a
	.dw $05ac
	.dw $05ce
	.dw $05ed
	.dw $060b
	.dw $0627
	.dw $0642
	.dw $065b
	.dw $0673
	.dw $0689
	.dw $069e
	.dw $06b2
	.dw $06c5
	.dw $06d6
	.dw $06e7
	.dw $06f7
	.dw $0706
	.dw $0714
	.dw $0721
	.dw $072e
	.dw $0739
	.dw $0745
	.dw $074f
	.dw $0759
	.dw $0762
	.dw $076b
	.dw $0773
	.dw $077b
	.dw $0783
	.dw $078a
	.dw $0790
	.dw $0797
	.dw $079d
	.dw $07a2
	.dw $07a8
	.dw $07ad
	.dw $07b1
	.dw $07b6
	.dw $07ba
	.dw $07be
	.dw $07c1
	.dw $07c5
	.dw $07c8
	.dw $07cb
	.dw $07ce
	.dw $07d1
	.dw $07d4
	.dw $07d6
	.dw $07d9
	.dw $07db
	.dw $07dd
	.dw $07df
	.dw $07e1
	.dw $07e2
	.dw $07e4
	.dw $07e6
	.dw $07e7
	.dw $07e9
	.dw $07ea
	.dw $07eb
	.dw $07ec
	.dw $07ed
	.dw $07ee
	.dw $07ef
	.dw $07f0
	.dw $07f1
	.dw $07f2

data_4ad0:
	.db $00 $01 $02 $03 $04 $05 $06 $07
	.db $00 $02 $04 $06 $07 $09 $0b $0d
	.db $00 $03 $06 $08 $0b $0e $11 $14
	.db $00 $04 $07 $0b $0f $13 $16 $1a
	.db $00 $05 $09 $0e $13 $17 $1c $21
	.db $00 $06 $0b $11 $16 $1c $22 $27
	.db $00 $07 $0d $14 $1a $21 $27 $2e
	.db $00 $07 $0f $16 $1e $25 $2d $34
	.db $00 $08 $11 $19 $22 $2a $32 $3b
	.db $00 $09 $13 $1c $25 $2f $38 $41
	.db $00 $0a $15 $1f $29 $33 $3e $48
	.db $00 $0b $16 $22 $2d $38 $43 $4e
	.db $00 $0c $18 $24 $31 $3d $49 $55
	.db $00 $0d $1a $27 $34 $41 $4e $5b
data_4b40:
	.db $00 $00 $01 $00 $02 $00 $01 $00
	.db $00 $00 $ff $ff $fe $ff $ff $ff

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
	call func_39_40b9
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
	ld a,$77
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

	ldi a,(hl)
	ld c,a
	ld h,(hl)
	ld l,c

@nextSoundChannel:
	ldh a,(<hSoundDataBaseBank)
	call wMusicReadFunction
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
	ld e,a
	push hl
	ld hl,wChannelsEnabled
	ld d,$00
	add hl,de
	ld a,(hl)
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
	ld d,$00

	ld a,(wSoundChannelValue)
	ld hl,wChannelsEnabled
	add hl,de
	ld (hl),a

	ld a,$08
	ld hl,wChannelVolumes
	add hl,de
	ld (hl),a

	xor a
	ld hl,wChannelWaitCounters
	add hl,de
	ld (hl),a

	ld a,(wSoundTmp)
	cp $06
	jr nc,++	; Noise channels

	rst_jumpTable
	.dw @squareChannel
	.dw @squareChannel
	.dw @squareChannel
	.dw @squareChannel
	.dw @waveChannel
	.dw @waveChannel

@waveChannel:
	ld a,(wSoundTmp)
	ld e,a
	xor a
	ld d,a

	ld hl,wChannelVibratos
	add hl,de
	ld (hl),a

	ld hl,wc03f
	add hl,de
	ld (hl),a

	ld hl,wChannelPitchShift
	add hl,de
	ld (hl),a

	ld hl,wc039
	add hl,de
	ld (hl),a
	jr ++

@squareChannel:
	ld a,(wSoundTmp)
	ld e,a
	xor a
	ld d,a

	; Clear a bunch of variables
	ld hl,wChannelEnvelopes
	add hl,de
	ld (hl),a

	ld hl,wChannelEnvelopes2
	add hl,de
	ld (hl),a

	ld hl,wChannelDutyCycles
	add hl,de
	ld (hl),a

	ld hl,wChannelVibratos
	add hl,de
	ld (hl),a

	ld hl,wc03f
	add hl,de
	ld (hl),a

	ld hl,wChannelPitchShift
	add hl,de
	ld (hl),a

	ld hl,wc039
	add hl,de
	ld (hl),a
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
	ld a,$77
	ld (wSoundVolume),a
@playSoundEnd:
	pop hl
	pop de
	pop bc
	ret

noiseFrequencyTable:
	.db $24 $01 $47
	.db $22 $00 $47
	.db $23 $02 $46
	.db $26 $02 $26
	.db $28 $00 $35
	.db $27 $02 $14
	.db $2a $01 $14
	.db $2e $06 $07
	.db $52 $03 $17
	.db $32 $02 $37
	.db $2f $02 $45
	.db $29 $02 $47
	.db $30 $00 $07
	.db $ff

waveformTable:
	.dw @waveform00
	.dw @waveform01
	.dw @waveform02
	.dw @waveform03
	.dw @waveform04
	.dw @waveform05
	.dw @waveform06
	.dw @waveform07
	.dw @waveform08
	.dw @waveform09
	.dw @waveform0a
	.dw @waveform0b
	.dw @waveform0c
	.dw @waveform0d
	.dw @waveform0e
	.dw @waveform0f
	.dw @waveform10
	.dw @waveform11
	.dw @waveform12
	.dw @waveform13
	.dw @waveform14
	.dw @waveform15
	.dw @waveform16
	.dw @waveform17
	.dw @waveform18
	.dw @waveform19
	.dw @waveform1a
	.dw @waveform1b
	.dw @waveform1c
	.dw @waveform1d
	.dw @waveform1e
	.dw @waveform1f
	.dw @waveform20
	.dw @waveform21
	.dw @waveform22
	.dw @waveform23
	.dw @waveform24
	.dw @waveform25
	.dw @waveform26
	.dw @waveform27
	.dw @waveform28
	.dw @waveform29
	.dw @waveform2a
	.dw @waveform2b
	.dw @waveform2c
	.dw @waveform2d

@waveformUnused0:
	.db $00 $00 $00 $00 $66 $77 $88 $88 $88 $88 $88 $88 $88 $77 $66 $55

@waveform04:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $99 $aa $aa $aa $aa $99 $88

@waveform0e:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88

@waveform28:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $55 $66 $66 $66 $66 $55 $44

@waveform06:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $44 $55 $55 $55 $55 $44 $33

@waveform07:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $55 $66 $66 $66 $66 $55 $44

@waveform26:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $11 $22 $33 $33 $22 $11 $00

@waveform09:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $55 $55 $33 $33 $00

@waveform16:
	.db $01 $23 $45 $67 $89 $ab $cd $ef $ed $cb $a9 $87 $65 $43 $21 $00

@waveform20:
	.db $00 $01 $23 $45 $67 $89 $ab $cd $cb $a9 $87 $65 $43 $21 $00 $00

@waveformUnused1:
	.db $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88

@waveform0a:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $cc $cc $cc $cc $cc $cc $cc $cc

@waveform1e:
	.db $ff $ee $dd $cc $bb $aa $99 $88 $77 $66 $55 $44 $33 $22 $11 $00

@waveform21:
	.db $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77 $ff $ff $ff $ff

@waveformUnused2:
	.db $ff $ee $cc $bb $99 $88 $66 $55 $cc $aa $99 $77 $66 $44 $22 $00

@waveform23:
	.db $77 $77 $66 $66 $55 $55 $44 $44 $cc $bb $ba $aa $a9 $99 $88 $88

@waveformUnused3:
	.db $88 $aa $cc $ee $ff $ee $dd $cc $bb $aa $99 $88 $66 $44 $22 $00

@waveform22:
	.db $6c $6c $6c $6c $6b $6a $69 $68 $77 $66 $55 $44 $33 $22 $11 $00

@waveform1f:
	.db $11 $ff $33 $dd $55 $bb $77 $99 $88 $88 $77 $99 $55 $bb $33 $dd

@waveform24:
	.db $80 $ae $db $f6 $ff $f6 $db $ae $80 $4f $25 $0a $00 $0a $25 $4f

@waveformUnused4:
	.db $ff $f6 $db $ae $80 $4f $25 $0a $00 $0a $25 $4f $80 $ae $db $f6

@waveform25:
	.db $c0 $d2 $db $d2 $c0 $a3 $80 $5c $40 $2d $25 $2d $40 $5c $80 $a3

@waveformUnused5:
	.db $c0 $db $c0 $80 $40 $25 $40 $80 $c0 $db $c0 $80 $40 $25 $40 $80

@waveform1a:
	.db $80 $db $ff $db $80 $25 $00 $25 $80 $db $ff $db $80 $25 $00 $25

@waveform1b:
	.db $40 $6e $80 $6e $40 $13 $00 $13 $40 $6e $80 $6e $40 $13 $00 $13

@waveformUnused6:
	.db $20 $37 $40 $37 $20 $0a $00 $0a $20 $37 $40 $37 $20 $0a $00 $0a

@waveform27:
	.db $00 $00 $00 $00 $99 $bb $dd $ee $ff $ff $ee $dd $bb $99 $00 $00

@waveform01:
	.db $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88 $88

@waveform02:
	.db $00 $00 $00 $00 $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff $ff

@waveform1c:
	.db $ff $bb $00 $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb $bb

@waveform1d:
	.db $77 $66 $55 $44 $33 $22 $11 $00 $77 $66 $55 $44 $33 $22 $11 $00

@waveform14:
	.db $30 $00 $00 $00 $00 $00 $00 $00 $03 $34 $45 $55 $55 $55 $54 $43

@waveform13:
	.db $00 $00 $00 $07 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77

@waveform15:
	.db $50 $00 $00 $00 $00 $00 $00 $00 $05 $46 $67 $77 $77 $77 $76 $65

@waveform12:
	.db $00 $00 $00 $09 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99 $99

@waveformUnused7:
	.db $01 $23 $45 $67 $89 $ab $cd $ef $fe $dc $ba $98 $76 $54 $32 $10

@waveform0c:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $11 $11 $11 $11 $11 $11 $11 $11

@waveform0d:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33

@waveform0f:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33

@waveform10:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77

@waveform11:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $88 $88 $88 $88 $88 $88 $88 $88

@waveform17:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $55 $55 $55 $55 $55 $55 $55 $55

@waveform18:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $99 $99 $99 $99 $99 $99 $99 $99

@waveform19:
	.db $00 $00 $00 $00 $00 $00 $77 $77 $77 $77 $77 $77 $77 $77 $77 $77

@waveform08:
	.db $00 $00 $11 $12 $22 $33 $34 $44 $44 $43 $33 $22 $21 $11 $00 $00

@waveform00:
	.db $11 $22 $33 $44 $55 $66 $78 $9a $a9 $88 $77 $66 $55 $44 $33 $22

@waveform05:
	.db $11 $22 $33 $44 $55 $66 $78 $9a $a9 $88 $77 $66 $55 $44 $33 $22

@waveform03:
	.db $11 $33 $55 $77 $99 $bb $dd $ff $ff $dd $bb $99 $77 $55 $33 $11

@waveform0b:
	.db $00 $0d $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd $dd

@waveform2b:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $44 $44 $44 $44 $44 $44 $44 $44

@waveform2c:
	.db $00 $00 $00 $00 $00 $00 $00 $00 $22 $22 $22 $22 $22 $22 $22 $22

@waveform29:
	.db $00 $00 $00 $00 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22 $22

@waveform2a:
	.db $00 $00 $00 $00 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33 $33

@waveform2d:
	.db $9b $df $ff $fe $dc $ba $98 $76 $21 $00 $01 $23 $22 $22 $23 $23



	.include {"audio/{GAME}/soundChannelPointers.s"}
	.include {"audio/{GAME}/soundPointers.s"}

.ends ; End of section AudioCode


.include {"audio/{GAME}/soundChannelData.s"}
