.define SETTINGS_COUNT      $05
.define SETTINGS_PER_PAGE   $03

updateSettingsMenu:
	ld a,(wKeysJustPressed)
	and BTN_A
	jr z,+
		; update settings with selected option
		call inventorySubmenu3SelectOption

		ld a,SND_SELECTITEM
		jr ++++
	+

	ld a,(wKeysJustPressed)
	and BTN_LEFT|BTN_RIGHT
	jr z,+
		; select different option value
		and BTN_LEFT
		ld a,(wInventory.itemSubmenuIndex)
		jr z,++
			dec a
			dec a
		++
		inc a

		; went below 0. do nothing
		bit 7,a
		ret nz

        push af
        ld a,(wInventorySubmenu3CursorPos)
        ld hl,@optionCounts
        rst_addAToHl
        pop af

        ; went above max. do nothing
        cp (hl)
        ret nc

        ld (wInventory.itemSubmenuIndex),a
        jr +++++
	+
		ld a,(wKeysJustPressed)
		and BTN_UP|BTN_DOWN
		jr z,+
			and BTN_UP
			ld hl,wInventorySubmenu3CursorPos
			ld a,(hl)
			push af
			jr z,++
				dec a
				dec a
			++
			inc a
            cp $ff
            jr nz,++
                ld a,SETTINGS_COUNT-1
            ++
			and $7f
			cp SETTINGS_COUNT
			jr c,++
				xor a
			++
			ld (hl),a

			call inventorySubmenu3InitSelection

			; maybe redraw page
			pop af
			call inventorySubscreen3_fixupTiles

			+++++
			ld a,SND_MENU_MOVE
			++++
			call playSound
		+
	+++
	ret
	

@optionCounts:
	.db $02 $02 $02 $02 $08

inventorySubmenu3SelectOption:
	ld a,(wInventory.itemSubmenuIndex)
	ld b,a
	ld hl,wMiscSettings
	ld a,(wInventorySubmenu3CursorPos)
	and $7f
	cp SETTINGS_COUNT
	jr c,+
		xor a
	+
	inc a
	dec a
	jr nz,+
		; quick-swap selected
		ld c,1<<6
		jr +++
	+

	dec a
	jr nz,+
		; context sensitive items selected
		ld c,1<<4
		jr +++
	+

	dec a
	jr nz,+
		; context sensitive button selected
		ld c,1<<5
		jr +++
	+

	dec a
	jr nz,+
		; passive shield selected
		ld c,1<<3
		+++
		ld a,c
		cpl
		and (hl)
		bit 0,b
		jr z,++
			or c
		jr ++
	+

	; message speed selected
	ld a,(hl)
	and $f8
	or b

	++
	ld (hl),a
	ret

inventorySubmenu3InitSelection:
	ld a,(wInventorySubmenu3CursorPos)
	and $7f
	cp SETTINGS_COUNT
	jr c,+
		xor a
	+
	inc a
	dec a
	ld hl,wMiscSettings
	jr nz,+
		; quick-swap selected
		bit 6,(hl)
		jr +++
	+

	dec a
	jr nz,+
		; context sensitive items selected
		bit 4,(hl)
		jr +++
	+

	dec a
	jr nz,+
		; context sensitive button selected
		bit 5,(hl)
		jr +++
	+

	dec a
	jr nz,+
		; passive shield selected
		bit 3,(hl)
		+++
		ld a,$00
		jr z,++
			inc a
		jr ++
	+

	; message speed selected
	ld a,(hl)
	and $07

	++
	ld (wInventory.itemSubmenuIndex),a
	ret

inventorySubmenu3_drawCursors:
	ld a,(wInventorySubmenu3CursorPos)
    add SETTINGS_PER_PAGE
    -
        sub SETTINGS_PER_PAGE
        cp SETTINGS_PER_PAGE
        jr nc,-

	ld hl,@bracketOffsets
	rst_addAToHl
	ldi a,(hl)
	ld b,a
	ld c,$00
	ld hl,@bracketSprites
	call addSpritesToOam_withOffset

	ld a,(wInventorySubmenu3CursorPos)
	and $7f
	cp SETTINGS_COUNT
	jr c,+
		xor a
	+
	ld b,a
	ld a,(wInventory.itemSubmenuIndex)
	ld c,a

	push bc
	; draw each setting's cursor where it should be
	ld a,(wInventorySubmenu3CursorPos)
	call determinePageForSetting
	ld l,a
	add l
	add l
	ld l,SETTINGS_PER_PAGE
	-
		ld (wInventorySubmenu3CursorPos),a
		pop bc
		push bc
		cp b
		push af
		ld a,c
		ld (wInventory.itemSubmenuIndex),a
        push hl
		jr z,+
			call inventorySubmenu3InitSelection
		+
		call @drawSettingCursor
        pop hl
		pop af
		inc a
		dec l
		jr z,+
			cp SETTINGS_COUNT
			jr c,-
	    +
	; restore
	pop bc
	ld a,b
	ld (wInventorySubmenu3CursorPos),a
	ld a,c
	ld (wInventory.itemSubmenuIndex),a
	ret

@drawSettingCursor:
	ld a,(wInventorySubmenu3CursorPos)
	rst_jumpTable
	.dw @drawCursorQuickSwap
	.dw @drawCursorContextSensitiveItems
	.dw @drawCursorContextSensitiveButton
	.dw @drawCursorPassiveShield
	.dw @drawCursorMessageSpeed

@drawCursorQuickSwap:
	ld b,$38
	jr @drawCursor2

@drawCursorContextSensitiveItems:
	ld b,$50
	jr @drawCursor2

@drawCursorContextSensitiveButton:
	ld b,$68

@drawCursor2:
	ld hl,@cursorOffsets2
@drawCursor:
	ld a,(wInventory.itemSubmenuIndex)
	rst_addAToHl
	ld c,(hl)

	ld hl,@arrowSprite
	call addSpritesToOam_withOffset
	ret

@drawCursorPassiveShield:
	ld b,$38
	jr @drawCursor2

@drawCursorMessageSpeed:
	ld hl,@cursorOffsets8
	ld b,$51
	jr @drawCursor

@cursorOffsets2:
	.db $18
	.db $58

@cursorOffsets8:
	.db $18
	.db $28
	.db $38
	.db $48
	.db $58
	.db $68
	.db $78
	.db $88

@bracketOffsets:
	.db $2f
	.db $47
	.db $5f

@bracketSprites:
	.db $02
	.db $00 $0e $0c $22
	.db $00 $9a $0c $02

@arrowSprite:
	.db $01
	.db $00 $00 $de $03

inventorySubscreen3_draw:
	ld hl,itemSubmenu3TextIndices
	ld de,w4SubscreenTextIndices
	ld b,SETTINGS_COUNT
	call copyMemory

    ld a,(wInventorySubmenu3CursorPos)
	and $7f
	cp SETTINGS_COUNT
	jr c,+
		xor a
	+
    ld (wInventorySubmenu3CursorPos),a

	call inventorySubmenu3InitSelection

    ld a,(wInventorySubmenu3CursorPos)
	call determinePageForSetting
	jr inventorySubscreen3_forceReloadGfx

inventorySubscreen3_fixupTiles:
	call determinePageForSetting
	ld b,a

	ld a,(wInventorySubmenu3CursorPos)
	call determinePageForSetting
	cp b
	; don't reload page if already loaded
	ret z

inventorySubscreen3_forceReloadGfx:
	push af
	add GFXH_INVENTORY_SUBSCREEN_4_PAGE_0
	call loadGfxHeader
	pop af

	add GFXH_INVENTORY_SUBSCREEN_4_PAGE_0_GFX
	call loadUncompressedGfxHeader

	ld a,(wInventory.cbba)
	and $01
	add UNCMP_GFXH_04
	jp loadUncompressedGfxHeader

determinePageForSetting:
	or a
	ld c,a
	ld a,$00
	ret z
	-
		; only 3 settings per page. determine the page
		dec c
		ret z
		dec c
		ret z
		inc a
		dec c
		jr nz,-
	ret

itemSubmenu3TextIndices:
	.db <TX_09_QUICK_SWAP
	.db <TX_09_CONTEXT_SENSITIVE_ITEMS
	.db <TX_09_CONTEXT_SENSITIVE_BUTTON
	.db <TX_09_PASSIVE_SHIELD
	.db <TX_09_MESSAGE_SPEED

.undefine SETTINGS_COUNT
.undefine SETTINGS_PER_PAGE