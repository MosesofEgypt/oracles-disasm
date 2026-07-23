musLadxSideviewStart:

musLadxSideviewChannel1:
	vibrato $00
	env $0 $00
.if defined(ROM_SEASONS) && !defined(ROM_COMBO)
	cmdf2
.endif
	duty $02
musicf8204:
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $08
	vol $2
	note f2  $04
	rest $48
	vol $c
	note c2  $02
	vol $5
	note c2  $04
	vol $2
	note c2  $02
	vol $c
	note c2  $04
	vol $5
	note c2  $08
	vol $2
	note c2  $04
	vol $c
	note fs2 $04
	vol $5
	note fs2 $08
	vol $2
	note fs2 $04
	vol $c
	note f2  $04
	vol $5
	note f2  $04
	vol $c
	note b2  $04
	vol $5
	note b2  $08
	vol $2
	note b2  $04
	rest $f8
	goto musicf8204
	cmdff

.if defined(ROM_SEASONS) && !defined(ROM_COMBO)
.ifdef BUILD_VANILLA
	cmdff
	cmdff
	cmdff
.endif
.endif

.define musLadxSideviewChannel0 MUSIC_CHANNEL_FALLBACK EXPORT
.define musLadxSideviewChannel4 MUSIC_CHANNEL_FALLBACK EXPORT
.define musLadxSideviewChannel6 MUSIC_CHANNEL_FALLBACK EXPORT
