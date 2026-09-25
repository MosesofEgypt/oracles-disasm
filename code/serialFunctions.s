;;
; Processes sending and receiving data over the serial connection.
manageSerialConnection_body:
	ldh a,(<hSerialInterruptBehaviour)
	or a
	ret z

	ldh a,(<SVBK)
	push af
	ld a,SERIAL_WRAM_BANK
	ldh (<SVBK),a
	push de
	call processSerialMode
	pop de

	call refreshSerialInterruptControl
	pop af
	ldh (<SVBK),a
	ret

refreshSerialInterruptControl:
	; if there's currently a transfer going, we don't
	; need to consider updating the control register
	ld a,($ff00+R_SC)
	rlca
	ret c

	; no serial activity currently occurring(sending or receiving).
	; check if we intend to enable it.
	ldh a,(<hSerialInterruptBehaviour)
	cp PACKET_TYPE_DATA_GET
	jr z,+
		; not planning to receive data.
		; are we idly listening for a connection?
		ld a,(w4IsSerialInSleepMode)
		or a
		ret nz

		; toggle between sending and receiving every frame
		ld a,(w4SerialStateIdle)
		xor $01
		ld (w4SerialStateIdle),a
		ret z

		; the serial interrupt behavior is known to be non-zero
		; and not "receive data" at this point, so we can expect
		; that we're switching to a mode of transmitting data.
		ldh a,(<hSerialInterruptBehaviour)
	+

	; trigger the serial interrupt to send or receive data
	and SERIAL_MODE_PUT
	jp updateSerialInterruptControl


processSerialMode:
	ldh a,(<hSerialLinkMode)
	rst_jumpTable
	.dw serialLinkModeNone
	.dw serialLinkModeFortuneHost
	.dw serialLinkModeFortuneClient
	.dw serialLinkModeFileHost
	.dw serialLinkModeFileClient


awaitTransferSignalAndSendByte:
	call awaitTransferSignal
	cp SERIAL_CODE_TIMEOUT
	ret z


;;
; Send the byte [w4PacketBuffer+[w4PacketByteIndex]] over the link cable.
sendPacketByte:
	; prepare hl to point to the byte we're sending this frame
	ld a,(w4PacketByteIndex)
	ld hl,w4PacketBuffer
	rst_addAToHl

	; first byte sent is always the packet size.
	ld a,(w4PacketByteIndex)
	or a
	jr nz,++
		; determine if there's any data at all
		ld a,(hl)
		or a
		jr nz,+
			; size is zero(including the size byte itself), so nothing to send
			inc a	; put the serial connection to sleep
			jr @done
		+

		; setup the packet size and reset the checksum
		ld (w4NumPacketBytes),a
		xor a
		ld (w4PacketChecksum),a
	++

	; move to the next byte for the next iteration
	inc a
	ld (w4PacketByteIndex),a

	; decrement remaining bytes to send
	ld a,(w4NumPacketBytes)
	dec a
	ld (w4NumPacketBytes),a

	; get the next byte value to be sent
	ldi a,(hl)
	jr nz,+
		; last byte, which is always the checksum.
		; use the checksum we've calculated as we've been sending
		xor a
		ld (w4WaitingForNextByte),a
		ld a,(w4PacketChecksum)
	+

	ld ($ff00+R_SB),a

	; update the checksum
	ld hl,w4PacketChecksum
	add (hl)
	ld (hl),a
	xor a	; keep the serial connection awake
@done
	ld (w4IsSerialInSleepMode),a
	ret


serialIdleSnoozeLoop:
	ldh a,(<hReceivedSerialByte)
	or a
	ret z

	ld a,$01
	ld (w4IsSerialInSleepMode),a
	xor a
	ld ($ff00+R_SB),a
	ldh (<hReceivedSerialByte),a
	ret

awaitTransferSignalAndPrepareForNextPacket:
	call awaitTransferSignal
	cp SERIAL_CODE_TIMEOUT
	jp z,disableSerialPort
	jp prepareForNextPacket

;;
shutdownSerialOnAck:
	call awaitTransferSignal
	jp disableSerialPort


;;
; If available, receive another byte and write it to w4PacketBuffer+[w4PacketByteIndex].
receivePacketByte:
	xor a
	ld (w4IsSerialInSleepMode),a
	call awaitTransferSignal
	cp SERIAL_CODE_TIMEOUT
	ret z

	ld a,(w4PacketByteIndex)
	ld b,a
	or a
	jr nz,@gotPacketByte

	; Receiving first byte (length)
	ldh a,(<hSerialByte)
	cp $ff
	jr z,+
	or a
	jr nz,@gotPacketLength
+
	; Received $00 or $ff for "length" byte.
	ld a,(w4DisableLinkTimeout)
	or a
	ret nz
	ld hl,w4ReceivingPacketBytes
	inc (hl)
	ret nz
	ld a,SERIAL_CODE_INVALID_SIZE
	ldh (<hSerialTransferErrorCode),a
	xor a
	ld (w4WaitingForNextByte),a
	ret

@gotPacketLength:
	ld (w4NumPacketBytes),a

@gotPacketByte:
	ld hl,w4NumPacketBytes
	dec (hl)
	jr nz,@getNextByte

	ldh a,(<hSerialByte)
	ld hl,w4PacketChecksum
	cp (hl)
	jr z,+

	; Checksum failure
	ld a,SERIAL_CODE_INVALID_CRC
	ldh (<hSerialTransferErrorCode),a
+
	xor a
	ld (w4WaitingForNextByte),a
	ld (w4ReceivingPacketBytes),a
	ld ($ff00+R_SB),a
	ret

@getNextByte:
	ld a,b
	ld de,w4PacketBuffer
	call addAToDe
	ld a,b
	inc a
	ld (w4PacketByteIndex),a
	ldh a,(<hSerialByte)
	ld (de),a
	ld hl,w4PacketChecksum
	add (hl)
	ld (hl),a
	xor a
	ld ($ff00+R_SB),a
	ld (w4ReceivingPacketBytes),a
	ret


; requesting save files from the other game
; (in either ring link or game link mode)
serialLinkModeFileClient:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	; STAGE 0
	.dw receiveFile1
	; NOTE: a status packet was sent by receiveFile1
	.dw continueSendingPacketWithRetries

	.dw receiveFile2
	; NOTE: a status packet was sent by receiveFile2
	.dw continueSendingPacketWithRetries

	.dw receiveFile3
	; NOTE: a status packet was sent by receiveFile3
	.dw continueSendingPacketWithRetries

	; STAGE 1
	.dw receiveStatusPacket
	.dw serialIdleSnoozeLoop

	; STAGE 2-A
	; these states are for game transfers only
		.dw prepareShutdownPacket
		.dw continueSendingPacket
		.dw receiveStatusPacket

		; STAGE 3-A
		.dw shutdownSerialOnAck

	; STAGE 2-B
	; these states are for ring transfers only
		.dw prepareLoadFilePacket
		.dw continueSendingPacket
		.dw receiveStatusPacket

		; STAGE 3-B
		.dw receiveAndMergeRingsObtained
		; NOTE: a status packet was sent by receiveAndMergeRingsObtained
		.dw continueSendingPacketWithRetries

		.dw awaitTransferSignalAndPrepareForNextPacket

		; STAGE 4-B
		.dw sendMergedRingsObtainedPacket
		.dw continueSendingPacketWithRetries
		.dw receiveStatusPacket

		; STAGE 5-B
		.dw sendSuccessPacket
		.dw continueSendingPacketWithRetries

		.dw awaitTransferSignalAndPrepareForNextPacket

		.dw updateObtainedRings


; supplying save files to the other game
; (game is either on the titlescreen or earlier)
serialLinkModeFileHost:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	; STAGE 0
	.dw transmitFile1
	.dw continueSendingPacketWithRetries
	.dw receiveStatusPacket

	.dw transmitFile2
	.dw continueSendingPacketWithRetries
	.dw receiveStatusPacket

	.dw transmitFile3
	.dw continueSendingPacketWithRetries
	.dw receiveStatusPacket

	; STAGE 1
	.dw sendSuccessPacket
	.dw continueSendingPacketWithRetries

	; STAGE 2
	.dw receiveLoadFilePacket

	; STAGE 2-A
	; these states are for game transfers only
		; NOTE: a status packet was sent by receiveLoadFilePacket
		.dw continueSendingPacketWithRetries

		; STAGE 3-A
		.dw shutdownSerialOnAck

	; STAGE 2-B
	; these states are for ring transfers only
		; NOTE: a status packet was sent by receiveLoadFilePacket
		.dw continueSendingPacketWithRetries

		.dw awaitTransferSignalAndPrepareForNextPacket

		; STAGE 3-B
		.dw prepareRingsObtainedPacket
		.dw continueSendingPacketWithRetries
		.dw receiveStatusPacket

		; STAGE 4-B
		.dw receiveMergedRingsObtained
		.dw sendSuccessPacket
		.dw continueSendingPacketWithRetries

		; STAGE 5-B
		.dw receiveStatusPacket

		.dw updateObtainedRings


transmitFile1:
	xor a
	jr ++

transmitFile2:
	ld a,$01
	jr ++

transmitFile3:
	ld a,$02
++
	ldh (<hActiveFileSlot),a
	call loadFile
	ldh (<hFF8B),a

;;
; Sends the "header" of the currently loaded file.
; When used in game link, a requested file is loaded first.
sendFileHeader:
	call prepareForNextPacket
	ld hl,w4FileHeaderPacket
	ld a,_sizeof_w4FileHeaderPacket
	ldi (hl),a		; w4FileHeaderPacket.packetLen
	ld c,a			; checksum of data
	ldh a,(<hFF8B)	; file load result(anything but 0 is a failure)
	ldi (hl),a		; w4FileHeaderPacket.fileLoadResult
	ldi (hl),a		; w4FileHeaderPacket.fileLoadResult2
	add a
	add c
	ld c,a
	ld a,(wLinkMaxHealth)
.if defined(ENABLE_DOUBLE_HEART_CAP)
	; limit transferred heart count to 16
	; to make compatible with original games
	cp $40
	jr c,+
		ld a,$40
	+
.endif
	ldi (hl),a		; w4FileHeaderPacket.linkMaxHealth
	ldi (hl),a		; w4FileHeaderPacket.linkMaxHealth2
	add a
	add c
	ld c,a
	ld a,(wDeathCounter)
	ldi (hl),a		; w4FileHeaderPacket.deathCounter
	add c
	ld c,a
	ld a,(wDeathCounter+1)
	ldi (hl),a		; w4FileHeaderPacket.deathCounter+1
	add c
	ld c,a
	ld a,(wFileIsLinkedGame)
	ldi (hl),a		; w4FileHeaderPacket.isLinked
	add c
	ld c,a
	ld a,(wFileIsHeroGame)
	and $01
	add a
	ld e,a
	ld a,(wFileIsCompleted)
.if defined(ROM_COMBO)
	and $31
.else
	and $01
.endif
	or e
	ldi (hl),a		; w4FileHeaderPacket.completionType
	add c
	ld c,a
	ld de,wGameID
	ld b,$16
--
	ld a,(de)
	ldi (hl),a		; w4FileHeaderPacket.gameID
	add c
	ld c,a
	inc e
	dec b
	jr nz,--

.ifdef ROM_COMBO
	call wIsSeasons
	ld a,PACKET_TYPE_HEADER_SEASONS
	jr c,+
		ld a,PACKET_TYPE_HEADER_AGES
	+
.elif defined(ROM_AGES)
	ld a,PACKET_TYPE_HEADER_AGES
.else
	ld a,PACKET_TYPE_HEADER_SEASONS
.endif
	ldi (hl),a		; w4FileHeaderPacket.packetType
	add c
	ldi (hl),a		; w4FileHeaderPacket.checksum
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp sendPacketByte

;;
; Returns from caller if no new byte has been read from the serial port.
;
; @param[out]	a	SERIAL_CODE_TIMEOUT if timeout occurred.
awaitTransferSignal:
	ldh a,(<hReceivedSerialByte)
	or a
	jr nz,@byteReceived
	ld a,(w4DisableLinkTimeout)
	or a
	jr nz,+
	ld hl,w4FileLinkTimer
	call decHlRef16WithCap
	jr z,@timeout
+
	pop af
	ret

@timeout:
	xor a
	ld (w4WaitingForNextByte),a
	ld a,SERIAL_CODE_TIMEOUT
	ldh (<hSerialTransferErrorCode),a
	ret

@byteReceived:
	ld (w4WaitingForNextByte),a
	xor a
	ldh (<hReceivedSerialByte),a
	ldh (<hSerialTransferErrorCode),a

setLinkTimerTo180:
	; 180 frames(2 or 4? seconds) of timeout
	ld a,180
	ld (w4FileLinkTimer),a
	ld a,$00
	ld (w4FileLinkTimer+1),a
	ret

; this should really be a stubbed out mode that doesn't do anything
serialLinkModeNone:

; supplies the file header to the other game BEFORE
; requesting the other game's header for itself.
serialLinkModeFortuneHost:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	; STAGE 0
	.dw sendFileHeader
	.dw continueSendingPacketWithRetries
	.dw receiveStatusPacket

	; STAGE 1
	.dw receiveRingFortuneSeed
	; NOTE: a status packet was sent by receiveRingFortuneSeed
	.dw continueSendingPacketWithRetries

	.dw awaitTransferSignalAndPrepareForNextPacket

	; STAGE 2
	.dw determineRingFortuneRing

; supplies the file header to the other game AFTER
; requesting the other game's header for itself.
serialLinkModeFortuneClient:
	ldh a,(<hSerialLinkState)
	rst_jumpTable
	; STAGE 0
	.dw receiveRingFortuneSeed
	; NOTE: a status packet was sent by receiveRingFortuneSeed
	.dw continueSendingPacketWithRetries

	.dw awaitTransferSignalAndPrepareForNextPacket

	; STAGE 1
	.dw sendFileHeader
	.dw continueSendingPacketWithRetries
	.dw receiveStatusPacket

	; STAGE 2
	.dw determineRingFortuneRing


;;
determineRingFortuneRing:
	call disableSerialPort
	xor a
	ldh (<hSerialTransferErrorCode),a

	; Can't do ring fortune if name & GameID of files are the same?
	call compareFileHeader
	jr z,@sameFileLineage

	; Add high bytes of GameIDs together to determine which set of rings to pull from?
	ld hl,wGameID
	ld a,(w4SerialDataBuffer)
	add (hl)
	and $7f
	ld b,$00
	and $7c
	jr z,+
	inc b
	and $60
	jr z,+
	inc b
+
	inc l
	ld c,(hl)
	ld a,b
	ld hl,ringFortuneTable
	rst_addAToHl
	ld a,(hl)
	rst_addAToHl

	; Use the low byte of the other file's GameID to determine which of the rings to get from
	; the set?
	ld a,(w4SerialDataBuffer+1)
	add c
	and $07
	rst_addAToHl
	ld a,(hl)
	ld (w4SerialDataBuffer),a
	ret

@sameFileLineage:
	ld a,SERIAL_CODE_SAME_FILE
	ldh (<hSerialTransferErrorCode),a
	ret


;;
; Increment hSerialLinkState, clear various variables in preparation for a new packet?
prepareForNextPacket:
	ldh a,(<hSerialLinkState)
	inc a
	ldh (<hSerialLinkState),a
prepareForPacket:
	xor a
	ld (w4PacketByteIndex),a
	ldh (<hSerialTransferErrorCode),a
	ld (w4PacketChecksum),a
	ld (w4ReceivingPacketBytes),a
	inc a
	ld (w4WaitingForNextByte),a
	jr setLinkTimerTo180


;;
continueSendingPacketWithRetries:
	call awaitTransferSignalAndSendByte
	call returnIfPacketNotComplete

	; check if something happened that requires we retry 
	ld a,(w4LinkRetryCounter)
	or a
	jr z,prepareForNextPacket

	; retry requested. bump down to the previous
	; serialLinkState so it can be retried
	ldh a,(<hSerialLinkState)
	dec a
	ldh (<hSerialLinkState),a
	jr prepareForPacket


;;
; Waits for a 16 byte file header to be received, and copies its
; gameId and linkName to w4FileHeaderPacket.gameId and w4FileHeaderPacket.linkName
receiveRingFortuneSeed:
	call receivePacketByte
	call returnIfPacketNotComplete
	ld hl,w4SerialDataBuffer
	ld de,w4FileHeaderPacket.gameID
	ld b,$07
	call copyMemoryReverse
	jp sendSuccessPacket


;;
receiveLoadFilePacket:
	ld a,(w4PacketByteIndex)
	or a
	ld a,$00
	jr nz,+
		inc a
	+
	; disable timeouts if w4PacketByteIndex is zero
	ld (w4DisableLinkTimeout),a
	call receivePacketByte
	ld a,(w4WaitingForNextByte)
	or a
	ret nz

	ld a,(w4TransferStatusPacket.packetType)
	cp PACKET_TYPE_SHUTDOWN_GET
	jp z,sendSuccessPacket

	cp PACKET_TYPE_LOAD_FILE_GET
	jp nz,sendRetryPacket

	; requested that we load a specific file
	ld a,(w4LoadFilePacket.fileIndex)
	ldh (<hActiveFileSlot),a

	; load the specified file if it's within the file count
	cp $03
	jp nc,disableSerialPort
	call loadFile

	; move to state "shutdownSerialOnAck"
	ld a,$0d
	ldh (<hSerialLinkState),a
	jp sendSuccessPacket


prepareRingsObtainedPacket:
	call prepareForNextPacket
	ld hl,w4SerialDataBuffer
	ld de,wRingsObtained
	ld b,$08
	call copyMemoryReverse
	jr sendRingsObtainedPacket


prepareShutdownPacket:
	ld hl,continuePacket
	call setPacketBuffer
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp sendPacketByte

continueSendingPacket:
	call awaitTransferSignalAndSendByte
	call returnIfPacketNotComplete
	jp prepareForNextPacket


receiveMergedRingsObtained:
	call receivePacketByte
	call returnIfPacketNotComplete

	; Check if previous packet's checksum failed
	ldh a,(<hSerialTransferErrorCode)
	cp SERIAL_CODE_INVALID_CRC
	jp z,prepareForNextPacket

	ld hl,w4SerialDataBuffer
	ld de,w4RingDataPacket.ringsObtained
	ld b,$08
	call copyMemoryReverse
	jp prepareForNextPacket


receiveAndMergeRingsObtained:
	call receivePacketByte
	call returnIfPacketNotComplete
	ld hl,wRingsObtained
	ld de,w4RingDataPacket.ringsObtained
	ld b,$08
-
	ld a,(de)
	or (hl)
	ld (de),a
	inc hl
	inc de
	dec b
	jr nz,-
	ld hl,w4SerialDataBuffer
	ld de,w4RingDataPacket.ringsObtained
	ld b,$08
	call copyMemoryReverse
	jp sendSuccessPacket


sendMergedRingsObtainedPacket:
	; NOTE: this is unnecessary, as the previous state already did this
	call prepareForNextPacket
sendRingsObtainedPacket:
	ld a,_sizeof_w4RingDataPacket
	ld c,a
	ld (w4RingDataPacket.packetLen),a
	ld de,w4RingDataPacket.ringsObtained
	ld hl,w4SerialDataBuffer
	ld b,$08
-
	ldi a,(hl)
	ld (de),a
	inc de
	add c
	ld c,a
	dec b
	jr nz,-
	ld a,c
	ld (de),a
	ld a,$01
	ld (w4WaitingForNextByte),a
	jp sendPacketByte


updateObtainedRings:
	call disableSerialPort
	ldh (<hSerialTransferErrorCode),a
	ld de,w4SerialDataBuffer
	ld hl,wRingsObtained
	ld b,$08
	call copyMemoryReverse

.if defined(ROM_COMBO)
	; in the ring-transfer file-select page, the value of wIsSeasons
	; will constantly change. we need to revert that before we save.
	ld a,(wWhichGame)
	inc a
	rrca
	call setIsSeasons
.endif
	jp saveFile

receiveStatusPacket:
	call @handleReceiving
	call returnIfPacketNotComplete
	call prepareForNextPacket
	jp processSerialMode

@handleReceiving:
	call receivePacketByte
	ld a,(w4WaitingForNextByte)
	or a
	ret nz
	ldh a,(<hSerialTransferErrorCode)
	or a
	jr z,@handleRetries
	pop af
	jp disableSerialPort


@handleRetries:
	ld a,(w4TransferStatusPacket.packetType)
	cp PACKET_TYPE_STATUS_FAILURE
	jr nz,+
		; received a request to retransmit the last packet
		xor a
		ld (w4LinkRetryCounter),a
		; move state back to the previous one
		ldh a,(<hSerialLinkState)
		sub $02
		ldh (<hSerialLinkState),a
		ret
	+
	; ran through all the retries, or succeeded sending the packet.
	; treat as an error if we aren't being requested to receive data.
	cp PACKET_TYPE_STATUS_SUCCESS
	ret z

	ld a,SERIAL_CODE_RETRY_LIMIT_HIT
	ldh (<hSerialTransferErrorCode),a
	ret


prepareLoadFilePacket:
	ld hl,fileSelectPacket
	call setPacketBuffer
	dec hl
	dec hl
	ld a,(wFileSelect.cursorPos)
	ldi (hl),a	; overwrite the file index byte
	add (hl)	; add it to the checksum
	ldi (hl),a	; fix the checksum

	ld a,$01
	ld (w4WaitingForNextByte),a
	jp sendPacketByte


;;
; This seems to be used when something fails and the game tries again?
sendRetryPacket:
	ld hl,retryPacket
	ld a,(w4LinkRetryCounter)
	inc a
	ld (w4LinkRetryCounter),a
	cp SERIAL_RETRY_COUNT
	jr c,setPacketBufferAndSendPacket
	ld a,SERIAL_CODE_TIMEOUT
	ldh (<hSerialTransferErrorCode),a
	jp disableSerialPort


;;
sendSuccessPacket:
	xor a
	ld (w4LinkRetryCounter),a
	ld hl,successPacket
setPacketBufferAndSendPacket:
	call setPacketBuffer
	jp sendPacketByte

;;
; @param	hl	Packet data to send (copied to w4PacketBuffer; 1st byte is size)
setPacketBuffer:
	call prepareForNextPacket
	ld a,(hl)
	ld b,a
	ld de,w4PacketBuffer
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-
	ret


receiveFile1:
	ld a,$00
	jr ++

receiveFile2:
	ld a,$01
	jr ++

receiveFile3:
	ld a,$02
++
	ldh (<hFF8B),a ; File index
	call receivePacketByte
	call returnIfPacketNotComplete

	jr nz,sendRetryPacket

	; ensure these constants are actually constant
	ld hl,(w4FileHeaderPacket.constZero)
	xor a
	ldi (hl),a
	inc a
	ldi (hl),a

	; ensure kid's name is null terminated
	xor a
	ld hl,(w4FileHeaderPacket.kidName+5)
	ld (hl),a

	; Copy file display variables to w4FileDisplayVariables + fileIndex * 8
	ldh a,(<hFF8B) ; File index
	swap a
	rrca
	ld hl,w4FileDisplayVariables
	rst_addAToHl
	ld de,w4FileHeaderPacket.fileLoadResult
	ld b,$08
	-
		ld a,(de)
		ldi (hl),a
		inc de
		dec b
		jr nz,-

	; Copy name of file to w4NameBuffer + fileIndex * 6
	ldh a,(<hFF8B)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld de,w4FileHeaderPacket.linkName
	ld b,$06
	call copyMemoryReverse

	; Copy the first $16 bytes of the file data ($c600-$c615) to another buffer
	ldh a,(<hFF8B)
	inc a
	ld hl,w4SerialDataBuffer
	ld bc,$0016
	; calculate an offset into the w4SerialDataBuffer to
	; load this file header into(each is $16 bytes long)
	-
		dec a
		jr z,++
		add hl,bc
		jr -
	++
	ld b,w4FileHeaderPacket.isCompleted - w4FileHeaderPacket.gameID
	ld de,w4FileHeaderPacket.gameID
	call copyMemoryReverse

	; Decide whether to display the file
	ld a,(wOpenedMenuType)
	cp MENU_RING_LINK
	jr nz,@gameLink

; Ignore file (mark as "blank") if the gameIDs don't match, or if it's not completed, not linked,
; and not a hero game
@ringLink:
	ld de,w4FileHeaderPacket.gameID
	call compareFileIDsAndNames
	jr nz,markFileAsBlank
	ld hl,w4FileHeaderPacket.isLinkedGame
	ldi a,(hl)
	or (hl) ; w4FileHeaderPacket.isHeroGame
	inc l
	or (hl) ; w4FileHeaderPacket.isCompleted
	jr z,markFileAsBlank
	jp sendSuccessPacket


; Ignore file (mark as "blank") if wrong game, or if not completed
@gameLink:
	; we don't care about this in the combo
	.if !defined(ROM_COMBO)
		ld a,(w4FileHeaderPacket.packetType)
		.if defined(ROM_AGES)
			cp PACKET_TYPE_HEADER_SEASONS
		.else
			cp PACKET_TYPE_HEADER_AGES
		.endif
		jr nz,markFileAsBlank
	.endif
	ld a,(w4FileHeaderPacket.isCompleted)
	or a
	jr z,markFileAsBlank
	jp sendSuccessPacket


;;
; This is used when the game chooses to ignore a file, ie. because it's not completed or the GameID
; is wrong.
markFileAsBlank:
	ldh a,(<hFF8B)
	ld d,FileDisplayStruct.fileLoadResult
	swap a
	rrca
	add d
	ld hl,w4FileDisplayVariables
	rst_addAToHl
	set 7,(hl) ; Mark as "blank file"
	ldh a,(<hFF8B)
	add a
	ld e,a
	add a
	add e
	ld hl,w4NameBuffer
	rst_addAToHl
	ld b,$06
	call clearMemory
	jp sendSuccessPacket

;;
; Called upon selecting "Game Link" in file select, and other things. "Initializes" linking?
initializeSerialConnection_body:
	ldh a,(<SVBK)
	push af
	ld a,SERIAL_WRAM_BANK
	ldh (<SVBK),a

	; initialize the transfer control variables
	xor a
	ld hl,w4d980
	ldi (hl),a ; w4d980
	ldi (hl),a ; w4PacketByteIndex
	ldi (hl),a ; w4PacketChecksum
	ldi (hl),a ; w4SerialStateIdle
	ldi (hl),a ; w4ReceivingPacketBytes
	ldi (hl),a ; w4DisableLinkTimeout
	ldi (hl),a ; w4LinkRetryCounter
	ldh (<hSerialLinkMode),a
	ldh (<hSerialLinkState),a
	ldh (<hSerialTransferErrorCode),a
	call setLinkTimerTo180

	; send a packet to the other gameboy telling it to begin
	; sending data, and switch ourselves to receiving data
	ld a,PACKET_TYPE_DATA_PUT
	ldh (<R_SB),a
	ld a,SERIAL_MODE_GET
	ld (w4WaitingForNextByte),a
	call updateSerialInterruptControl

	pop af
	ldh (<SVBK),a
	ret


;;
; This returns from the caller until a packet has been fully received, or there was an error?
;
; @param[out]	zflag	z on success; nz if there was a problem receiving the data.
returnIfPacketNotComplete:
	ld a,(w4WaitingForNextByte)
	or a
	jr z,++
	pop af
	ret
++
	ldh a,(<hSerialTransferErrorCode)
	or a
	ret z

	; Check if previous packet's checksum failed
	cp SERIAL_CODE_INVALID_CRC
	jp z,sendRetryPacket

	pop af
	jp disableSerialPort


;;
compareFileHeader:
	ld de,w4SerialDataBuffer

;;
; @param	de	Pointer to first 7 bytes of some file data
;
; @param[out]	zflag	z if it matches the current file
compareFileIDsAndNames:
	ld hl,wGameID
	ld b,$07
-
	ld a,(de)
	cp (hl)
	ret nz
	inc de
	inc l
	dec b
	jr nz,-
	ret


fileSelectPacket:
	.db $04									; packetLen
	.db PACKET_TYPE_LOAD_FILE_GET			; packetType
	.db $00									; fileIndex
	.db PACKET_TYPE_LOAD_FILE_GET + $04		; checksum (sum of previous bytes)

continuePacket:
	.db $03									; packetLen
	.db PACKET_TYPE_SHUTDOWN_GET			; packetType
	.db PACKET_TYPE_SHUTDOWN_GET + $03		; checksum (sum of previous bytes)

successPacket:
	.db $03									; packetLen
	.db PACKET_TYPE_STATUS_SUCCESS			; packetType
	.db PACKET_TYPE_STATUS_SUCCESS + $03	; checksum (sum of previous bytes)

retryPacket:
	.db $03									; packetLen
	.db PACKET_TYPE_STATUS_FAILURE			; packetType
	.db PACKET_TYPE_STATUS_FAILURE + $03	; checksum (sum of previous bytes)

ringFortuneTable:
	dbrel @rings0
	dbrel @rings1
	dbrel @rings2

; Good rings
@rings0:
	.db MAPLES_RING, FIRST_GEN_RING, FIRST_GEN_RING, BOMBPROOF_RING
	.db ENERGY_RING, DBL_EDGED_RING, MAPLES_RING,    RED_LUCK_RING

; OK rings
@rings1:
	.db PEACE_RING, HEART_RING_L2, RED_JOY_RING, RED_JOY_RING
	.db GASHA_RING, PEACE_RING,    TOSS_RING,    ZORA_RING

; Bad rings
@rings2:
	.db CURSED_RING,    GREEN_LUCK_RING,  BLUE_LUCK_RING, GREEN_HOLY_RING
	.db BLUE_HOLY_RING, RED_HOLY_RING,    CURSED_RING,    WHISP_RING
