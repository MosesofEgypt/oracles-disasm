; Data sent over link cable is slightly different depending on region?
.ifdef REGION_JP
	.define PACKET_TYPE_BASE $00
.else
	.define PACKET_TYPE_BASE $10
.endif

.define SERIAL_RETRY_COUNT			$05

.define SERIAL_CLOCK_EXTERNAL 		$00
.define SERIAL_CLOCK_INTERNAL 		$01
.define SERIAL_TRANSFER_ENABLED		$80

; NOTE: The designation between GET and PUT here is a bit of a misnomer.
;       The byte currently in R_SB is transmitted to the other gameboy
;       while the other gameboy sends us it's R_SB contents.
;       This happens regardless of whether we're in a GET or PUT state.
;       The distinction is useful however, as it indicates which device
;       is expected to be sending or receiving the data.

; $80/$81
.define SERIAL_MODE_GET				SERIAL_TRANSFER_ENABLED | SERIAL_CLOCK_EXTERNAL
.define SERIAL_MODE_PUT				SERIAL_TRANSFER_ENABLED | SERIAL_CLOCK_INTERNAL

.define PACKET_TYPE_HEADER			$10 + PACKET_TYPE_BASE
.define PACKET_TYPE_STATUS			$20 + PACKET_TYPE_BASE
.define PACKET_TYPE_LOAD_FILE		$30 + PACKET_TYPE_BASE
.define PACKET_TYPE_SHUTDOWN		$40 + PACKET_TYPE_BASE
.define PACKET_TYPE_DATA			$50 + PACKET_TYPE_BASE

; $90/$91
.define PACKET_TYPE_HEADER_SEASONS		SERIAL_MODE_GET | PACKET_TYPE_HEADER | $00
.define PACKET_TYPE_HEADER_AGES			SERIAL_MODE_GET | PACKET_TYPE_HEADER | $01

; $a0/$a1
.define PACKET_TYPE_STATUS_SUCCESS		SERIAL_MODE_GET | PACKET_TYPE_STATUS
.define PACKET_TYPE_STATUS_FAILURE		SERIAL_MODE_PUT | PACKET_TYPE_STATUS

; $b0
.define PACKET_TYPE_LOAD_FILE_GET		SERIAL_MODE_GET  | PACKET_TYPE_LOAD_FILE

; $c0
.define PACKET_TYPE_SHUTDOWN_GET		SERIAL_MODE_GET  | PACKET_TYPE_SHUTDOWN

; $d0/$d1
.define PACKET_TYPE_DATA_GET			SERIAL_MODE_GET | PACKET_TYPE_DATA
.define PACKET_TYPE_DATA_PUT			SERIAL_MODE_PUT | PACKET_TYPE_DATA

.enum $00
	; not directly used. here for documentation
	SERIAL_CODE_OK					db ; $00
.ende

.enum $80
	SERIAL_CODE_TIMEOUT				db ; $80
	SERIAL_CODE_INVALID_CRC			db ; $81
	SERIAL_CODE_RETRY_LIMIT_HIT		db ; $82
	SERIAL_CODE_UNKNOWN_3			db ; $83   doesn't seem to be an error? treated
	;                                          the same as SERIAL_CODE_OK when the
	;                                          game link screen is waiting on files
	SERIAL_CODE_SAME_FILE			db ; $84
	SERIAL_CODE_NO_VALID_FILES		db ; $85
	SERIAL_CODE_INVALID_SIZE		db ; $86
.ende

; codes $87-$8e appear to be unused, but there could
; be some weird edge case where they actually are.

.enum $8f
	SERIAL_CODE_CLIENT_DISCONNECT	db ; $8f
.ende

.enum $00
	SERIAL_LINK_MODE_NONE			db ; $00
	SERIAL_LINK_MODE_FORTUNE_HOST	db ; $01
	SERIAL_LINK_MODE_FORTUNE_CLIENT	db ; $02
	SERIAL_LINK_MODE_FILE_HOST		db ; $03
	SERIAL_LINK_MODE_FILE_CLIENT	db ; $04
.ende