.memorymap
	SLOTSIZE $4000
	DEFAULTSLOT 1
	SLOT 0 $0000
	SLOT 1 $4000

	SLOTSIZE $1000
	SLOT 2 $c000
	SLOT 3 $d000
.endme

.banksize $4000
.ramsize $02 ; 1 RAM bank

; HACK-BASE: Ages is expanded to 2MB, Seasons to 4MB to accommodate expanded tilesets.
; Seasons takes more space due to the extra deduplication from each of the season tilesets.
.if defined(ROM_COMBO)

	.define ROM_BANKS 256
	.define ROM_SIZE  07

.elif defined(ROM_AGES)

	.define ROM_BANKS 128
	.define ROM_SIZE  06

.else ; ROM_SEASONS

	.define ROM_BANKS 128
	.define ROM_SIZE  06

.endif

; these are used for calculating allowed banks in sections
.define MIN_BANK_NUM	$01
.define MAX_BANK_NUM	ROM_BANKS-1

; for when you want as much space for audio(and maybe gfx?) as possible
.ifdef I_LIKE_BIG_ROMS_AND_I_CANNOT_LIE
	.redefine ROM_BANKS 512
	.redefine ROM_SIZE  08
	.define MIN_RAWDATA_BANK_NUM	MAX_BANK_NUM+1
	.define MAX_RAWDATA_BANK_NUM	ROM_BANKS-1
.endif

.rombanks ROM_BANKS
.romsize ROM_SIZE

.nintendologo
.romgbconly
.licenseecodenew "01"
.cartridgetype $1b

.ifdef REGION_JP
	.countrycode 0
.else
	.countrycode 1
.endif

.computegbcomplementcheck
.computegbchecksum


; Oracles use almost standard ascii
.ASCIITABLE
	MAP "~" = $5c
.ENDA
