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


paletteTransitionSeasonData:
.if defined(ROM_COMBO)
	.dw paletteData49b0_seasons
	.dw paletteData49e0_seasons
	.dw paletteData4a10_seasons
	.dw paletteData4a40_seasons

	.dw paletteData4a70_seasons
	.dw paletteData4aa0_seasons
	.dw paletteData4ad0_seasons
	.dw paletteData4b00_seasons

	.dw paletteData4da0_seasons
	.dw paletteData4dd0_seasons
	.dw paletteData4e00_seasons
	.dw paletteData4e30_seasons

	.dw paletteData4f20_seasons
	.dw paletteData4f50_seasons
	.dw paletteData4f80_seasons
	.dw paletteData4fb0_seasons

	.dw paletteData50a0_seasons
	.dw paletteData50d0_seasons
	.dw paletteData5100_seasons
	.dw paletteData5130_seasons

	.dw paletteData5160_seasons
	.dw paletteData5190_seasons
	.dw paletteData51c0_seasons
	.dw paletteData51f0_seasons
.else
	; $00
	.dw paletteData49b0 ; SEASON_SPRING
	.dw paletteData49e0 ; SEASON_SUMMER
	.dw paletteData4a10 ; SEASON_AUTUMN
	.dw paletteData4a40 ; SEASON_WINTER

	; $01
	.dw paletteData4a70
	.dw paletteData4aa0
	.dw paletteData4ad0
	.dw paletteData4b00

	; $02
	.dw paletteData4da0
	.dw paletteData4dd0
	.dw paletteData4e00
	.dw paletteData4e30

	; $03
	.dw paletteData4f20
	.dw paletteData4f50
	.dw paletteData4f80
	.dw paletteData4fb0

	; $04
	.dw paletteData50a0
	.dw paletteData50d0
	.dw paletteData5100
	.dw paletteData5130

	; $05
	.dw paletteData5160
	.dw paletteData5190
	.dw paletteData51c0
	.dw paletteData51f0
.endif



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
