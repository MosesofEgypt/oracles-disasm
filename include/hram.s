.enum $ff80 export
	hOamFunc			dsb 6	; $ff80

	hFlickerStartObjectOffset	db	; $ff86

	; More general-purpose variables added by
	; reducing complexity of the OAM function
	hFlickerFirstObjectIndex	.db	; $ff87
	hFF87						db	; $ff87

	hFlickerLastObjectIndex		.db	; $ff88
	hFF88						db	; $ff88

	hFlickerNumObjects			.db	; $ff89
	hLastMusicAsmResult			db	; $ff89

	; General-purpose variables
	hFF8A				db	; $ff8a
	hFF8B				db	; $ff8b
	hFF8C				db	; $ff8c
	hFF8D				db	; $ff8d
	hFF8E				db	; $ff8e
	hFF8F				db	; $ff8f
	hFF90				db	; $ff90
	hFF91				db	; $ff91
	hFF92				db	; $ff92
	hFF93				db	; $ff93

	hRng1				db	; $ff94
	hRng2				db	; $ff95

	; $00 for classic gb, $01 for gbc, $ff for gba
	hGameboyType			db	; $ff96

	hRomBank			db	; $ff97

	hScriptAddressL			db	; $ff98
	hScriptAddressH			db	; $ff99

	; When gameboy is initialized, hram is cleared from here to "hramEnd".


	hActiveFileSlot			db	; $ff9a

	; 0: set SCX based on values in wBigBuffer at each hblank
	; 1: set SCY based on values in wBigBuffer at each hblank
	; 2+: ?
	; 5: used for ring menu
	hLcdInterruptBehaviour		db	; $ff9b

	; This is a counter for how many times the LCD interrupt has been triggered this
	; frame (used when hLcdInterruptBehaviour is 2 or higher).
	hLcdInterruptCounter		db	; $ff9c

	; Copied to hLcdInterruptBehaviour at vblank, to avoid anomolies mid-frame.
	hNextLcdInterruptBehaviour	db	; $ff9d

	hActiveThread			db	; $ff9e

	; Where to put the next OAM object (low byte for wOam)
	hOamTail			db	; $ff9f

	; Keeps track of how many bytes in wTerrainEffectsBuffer are used.
	hTerrainEffectsBufferUsedSize	db	; $ffa0

	; These counters keep track of how many objects of each "priority" are
	; displayed. Each caps at $10. The lower the priority, the more objects
	; it's displayed on top of.
	hObjectPriority0Counter		db	; $ffa1
	hObjectPriority1Counter		db	; $ffa2
	hObjectPriority2Counter		db	; $ffa3
	hObjectPriority3Counter		db	; $ffa4

	hVBlankFunctionQueueTail	db	; $ffa5
	hDirtyBgPalettes		db	; $ffa6
	hDirtySprPalettes		db	; $ffa7

	; If a bit is set here, the corresponding palette is loaded from
	; w2FadingBgPalettes or w2FadingSprPalettes; otherwise, it's loaded from
	; w2TilesetBgPalettes or w2TilesetSprPalettes.
	hBgPaletteSources		db	; $ffa8
	hSprPaletteSources		db	; $ffa9

	; These are each 16 bits? (not subpixel format)
	hCameraY			dw	; $ffaa
	hCameraX			dw	; $ffac

	; Either $00, $40, $80, or $c0
	hActiveObjectType		db	; $ffae
	; Number from $d0 to $df
	hActiveObject			db	; $ffaf

	; The position enemies try to attack. Unaffected by scent seeds?
	hEnemyTargetY			db	; $ffb0
	hEnemyTargetX			db	; $ffb1

	; $ffb2/b3: Y/X values, also relating to enemies. This is either Link's or the
	; scent seed's position.
	hFFB2				db	; $ffb2
	hFFB3				db	; $ffb3

	hMusicQueueHead			db	; $ffb4
	hMusicQueueTail			db	; $ffb5

	; 0-3; when bit 7 is set, volume needs updating.
	hMusicVolume			db	; $ffb6

	; ffb7: if bit 7 is set, the game is currently doing vBlank gfx updates
	;       if bit 3 is set, playSound doesn't do anything.
	;       if bit 0 is set, the audio update thread is locked(running or not)
	hFFB7				db	; $ffb7

	; Used in timer interrupt
	hFFB8				db	; $ffb8

	; This is 0 until the capcom screen is over
	hIntroInputsEnabled		db	; $ffb9

	; If this is nonzero then this gameboy uses an external clock (is the "slave").
	; In JP region, this is $d0 or $d1; in the US region, it's $e0 or $e1.
	hSerialInterruptBehaviour	db	; $ffba

	; Serial interrupt sets this to 1 if a byte has been read
	hReceivedSerialByte		db	; $ffbb

	; Value of byte from R_SB
	hSerialByte			db	; $ffbc

	; 0 if no errors occurred
	hSerialTransferErrorCode				db	; $ffbd

	; This variable is the link "mode" (what it's doing right now).
	; $01: serving as the host that receives the fortune
	; $02: serving as the client that initiates the fortune
	; $03: serving as the host that receives a file transfer request
	;      (this is seen on the titlescreen or "can't run on DMG" screen)
	; $04: serving as the client that initiates a file transfer request
	hSerialLinkMode				db	; $ffbe

	; This keeps track of the "state" corresponding to the above link mode.
	hSerialLinkState		db	; $ffbf

	; NOTE: Avoid using these during interrupts, as that could
	;       be in use by a main thread that's currently paused
	hActiveCollisionsTable	.dw ; $ffc0
	hTempVal0				db ; $ffc0

	hGfxCompressionMode		.db	; $ffc1
	hTempVal1				db ; $ffc1

	hItemCollisionBomb		.db ; $ffc2
	hTempVal2				db ; $ffc2
	hTempVal3			 	db ; $ffc3

	hGdmaDelayedCount			db ; $ffc4
	hGdmaChunksCopiedThisFrame	db ; $ffc5

	; instances of BoundingBoxStruct
	hLinkBoundingBox			dsb $04 ; $ffc6
	hEnemyBoundingBox			dsb $04 ; $ffca

	hPanicRegisterAf			dw ; $ffce
	hPanicRegisterBc			dw ; $ffd0
	hPanicRegisterDe			dw ; $ffd2
	hPanicRegisterHl			dw ; $ffd4
	hPanicInstructionPointer	dw ; $ffd6
	hPanicRomBank				db ; $ffd8
	hPanicStackPointerLow		db ; $ffd9

	; Marker for end of "normal" hram (memory gets cleared up to here upon game initialization)
	hramEnd			 			.db	; $ffda
.ende

.enum $ffda export
	; =====================================================================
	; Music stuff
	; =====================================================================

	; Each of these are buffers taking wSoundChannel as an index.
	; This one is 8 bytes (1 byte for each index)
	hSoundChannelBanks			dsb 8	; $ffda
	; This one is 16 bytes (1 word for each index)
	hSoundChannelAddresses		dsw 8	; $ffe2

	; This one is 12 bytes (1 word for each non-wave index)
	hSoundData3					dsw 6	; $fff2

	; Bits 0-4: Interrupt flags at the time of panic
	; Bits 5-7: Panic display state
	; $00 == no panic; nothing recorded
	; $0* == need to start a panic
	; $2* == panic data recorded, but not displayed
	; $4* == panic info displayed
	; $6* == waiting to close panic display
	hPanicState				db ; $fffe
.ende