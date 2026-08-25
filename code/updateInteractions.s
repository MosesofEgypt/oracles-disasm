;;
_updateInteractionsIfStateIsZero:
	ld a,Interaction.start
	ldh (<hActiveObjectType),a
	ld a,FIRST_INTERACTION_INDEX

	call getInteractionCodeTable
--
	ldh (<hActiveObject),a
	ld d,a
	ld e,Interaction.enabled
	ld a,(de)
	or a
	jr z,@next

	rlca
	jr c,+
		ld e,Interaction.state
		ld a,(de)
		or a
		jr nz,@next
	+
	push hl
	call updateInteraction
	pop hl
@next:
	ldh a,(<hActiveObject)
	inc a
	cp LAST_INTERACTION_INDEX+1
	jr c,--
	ret

;;
updateInteractions:
	ld a,(wScrollMode)
	cp $08
	jr z,_updateInteractionsIfStateIsZero

	ld a,(wDisabledObjects)
	and $02
	jr nz,_updateInteractionsIfStateIsZero

	ld a,(wTextIsActive)
	or a
	jr nz,_updateInteractionsIfStateIsZero

	ld a,Interaction.start
	ldh (<hActiveObjectType),a
	ld a,FIRST_INTERACTION_INDEX

	call getInteractionCodeTable
-
	ldh (<hActiveObject),a
	ld d,a
	ld e,Interaction.enabled
	ld a,(de)
	or a

	push hl
	call nz,updateInteraction
	pop hl
	ldh a,(<hActiveObject)
	inc a
	cp LAST_INTERACTION_INDEX+1
	jr c,-
	ret

getInteractionCodeTable:
.if defined(ROM_COMBO)
	ld hl,interactionCodeTable_seasons
	call wIsSeasons
	ret c
	ld hl,interactionCodeTable_ages
.else
	ld hl,interactionCodeTable
.endif
	ret

;;
; Run once per frame for each interaction.
;
; @param	d	Interaction to update
updateInteraction:
	ld e,Interaction.id
	ld a,(de)

.if defined(ENABLE_NEW_GAME_PLUS) || defined(ROM_COMBO)
	jp updateObjectCaller

.else
	.if defined(ROM_AGES)
		; Get the bank number in 'b'
		ld b,$08
		cp $3e
		jr c,+
		inc b
		cp $67
		jr c,+
		inc b
		cp $98
		jr c,+
		inc b
		cp $dc
		jr c,+
		ld b,$10

	.else ; ROM_SEASONS
		ld b,$08
		cp $5e
		jr c,+
		inc b
		cp $89
		jr c,+
		inc b
		cp $c8
		jr c,+
		ld b,$0f
		cp $d8
		jr c,+
		ld b,$15
	.endif

+
	ld a,b
	rst_setrombank
	ld a,(de)
	rst_addDoubleIndex
	rst_derefHl
	jp hl
.endif