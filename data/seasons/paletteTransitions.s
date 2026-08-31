; This file deals with "smooth palette transitions" between rooms, ie. at the entrance to
; the graveyard.
;
; Data format: (differs in ages)
; b0: direction (or $ff to end)
; b1: room index
; b2: source palette index for "paletteTransitionSeasonData"
; b3: destination palette index for "paletteTransitionSeasonData"
;
; Note: Byte 0 is the direction Link MOVES INTO the room, not where he ENTERS FROM.


.MACRO m_PaletteTransitionData_seasons
	.assert NARGS == 1
	.if defined(ROM_COMBO)
		.dw \1_seasons
	.else
		.dw \1
	.endif
.ENDM

paletteTransitionSeasonData:
	; $00
	m_PaletteTransitionData_seasons paletteData49b0 ; SEASON_SPRING
	m_PaletteTransitionData_seasons paletteData49e0 ; SEASON_SUMMER
	m_PaletteTransitionData_seasons paletteData4a10 ; SEASON_AUTUMN
	m_PaletteTransitionData_seasons paletteData4a40 ; SEASON_WINTER

	; $01
	m_PaletteTransitionData_seasons paletteData4a70
	m_PaletteTransitionData_seasons paletteData4aa0
	m_PaletteTransitionData_seasons paletteData4ad0
	m_PaletteTransitionData_seasons paletteData4b00

	; $02
	m_PaletteTransitionData_seasons paletteData4da0
	m_PaletteTransitionData_seasons paletteData4dd0
	m_PaletteTransitionData_seasons paletteData4e00
	m_PaletteTransitionData_seasons paletteData4e30

	; $03
	m_PaletteTransitionData_seasons paletteData4f20
	m_PaletteTransitionData_seasons paletteData4f50
	m_PaletteTransitionData_seasons paletteData4f80
	m_PaletteTransitionData_seasons paletteData4fb0

	; $04
	m_PaletteTransitionData_seasons paletteData50a0
	m_PaletteTransitionData_seasons paletteData50d0
	m_PaletteTransitionData_seasons paletteData5100
	m_PaletteTransitionData_seasons paletteData5130

	; $05
	m_PaletteTransitionData_seasons paletteData5160
	m_PaletteTransitionData_seasons paletteData5190
	m_PaletteTransitionData_seasons paletteData51c0
	m_PaletteTransitionData_seasons paletteData51f0



paletteTransitionIndexData:
	.dw paletteTransitionGroupOverworld
	.dw paletteTransitionGroupSubrosia

paletteTransitionGroupOverworld:
	.db $e0 DIR_UP   $00 $03 ; Graveyard
	.db $f0 DIR_DOWN $03 $00
	.db $63 DIR_UP   $01 $02 ; Tarm ruins (unused due to fadeout transition)
	.db $73 DIR_DOWN $02 $01
	.db $83 DIR_UP   $00 $01 ; Holodrum plain <-> spool swamp (unused)
	.db $93 DIR_DOWN $01 $00
	.db $23 DIR_UP   $04 $05 ; Onox's castle entrance
	.db $33 DIR_DOWN $05 $04
	.db $00 $ff

paletteTransitionGroupSubrosia:
	.db $00 $ff
