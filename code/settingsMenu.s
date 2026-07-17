.define SETTINGS_COUNT      $08
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
        call getSelectedSettingIndex
		add a
		add a
        ld hl,optionValuesAndOffsets
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

optionValuesAndOffsets:
	.db $02, 1<<6
	.dw wMiscSettings

	.db $02, 1<<4
	.dw wMiscSettings

	.db $02, 1<<5
	.dw wMiscSettings

	.db $02, 1<<3
	.dw wMiscSettings

	.db $02, 1<<6
	.dw wMiscSettings+1

	.db $02, 1<<7
	.dw wMiscSettings+1

	.db $02, 1<<7
	.dw wMiscSettings

	.db $08, $00
	.dw wMiscSettings

	.db $00, $00
	.dw $0000

inventorySubmenu3SelectOption:
	ld a,(wInventory.itemSubmenuIndex)
	ld b,a
	call getSelectedSettingIndex
	add a
	add a
	ld hl,optionValuesAndOffsets
	rst_addAToHl
	inc hl
	ld c,(hl)
	inc hl
	rst_derefHl
	ld a,c

	or a
	jr z,+
		; there's a bitmask, so treat as binary option
		cpl
		and (hl)
		bit 0,b
		jr z,++
			or c
		jr ++
	+
		; no bitmask. message speed selected
		ld a,b
		and $07
		ld b,a
		ld a,(hl)
		and $f8
		or b
	++

	ld (hl),a
	ret

inventorySubmenu3InitSelection:
	call getSelectedSettingIndex
	add a
	add a
	ld hl,optionValuesAndOffsets
	rst_addAToHl
	inc hl
	ld c,(hl)
	inc hl
	rst_derefHl
	ld a,c

	or a
	jr z,+
		; there's a bitmask, so treat as binary option
		and (hl)
		ld a,$00
		jr z,++
			inc a
		jr ++
	+
		; no bitmask. message speed selected
		ld a,(hl)
		and $07
	++

	ld (wInventory.itemSubmenuIndex),a
	ret

inventorySubmenu3_drawCursors:
	ld a,(wFrameCounter)
	bit 3,a
	jr z,+
		call getCurrentPage

		ld hl,@arrowUpSpritesBlue
		push af

		cp $00
		call nz,addSpritesToOam
		pop af

		ld hl,@arrowDownSpritesRed
		cp $02
		call c,addSpritesToOam
	+

	call getSelectedSettingIndex
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

	call getSelectedSettingIndex
	ld b,a
	ld a,(wInventory.itemSubmenuIndex)
	ld c,a

	push bc
	; draw each setting's cursor where it should be
	call getCurrentPage
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

@arrowUpSpritesBlue
	.db $02
	.db $27 $12 $0e $04
	.db $27 $97 $0e $04

@arrowDownSpritesRed
	.db $02
	.db $71 $12 $0e $45
	.db $71 $97 $0e $45

@drawSettingCursor:
	call getSelectedSettingIndex
	rst_jumpTable
	.dw @drawCursorQuickSwap
	.dw @drawCursorContextSensitiveItems
	.dw @drawCursorContextSensitiveButton

	.dw @drawCursorPassiveShield
	.dw @drawCursorBraceletPunch
	.dw @drawCursorDungeonAutosaving

	.dw @drawCursorLowHeartWarning
	.dw @drawCursorMessageSpeed
	.dw $0000

@drawCursorQuickSwap:
@drawCursorPassiveShield:
@drawCursorLowHeartWarning:
	ld b,$38
	jr @drawCursor2

@drawCursorContextSensitiveItems:
@drawCursorBraceletPunch:
	ld b,$50
	jr @drawCursor2

@drawCursorContextSensitiveButton:
@drawCursorDungeonAutosaving:
	ld b,$68
	jr @drawCursor2

@drawCursorMessageSpeed:
	ld hl,@cursorOffsets8
	ld b,$51
	jr @drawCursor

@drawCursor2:
	ld hl,@cursorOffsets2
@drawCursor:
	ld a,(wInventory.itemSubmenuIndex)
	rst_addAToHl
	ld c,(hl)

	ld hl,@arrowSprite
	call addSpritesToOam_withOffset
	ret

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

	call inventorySubmenu3InitSelection

    call getCurrentPage
	jr inventorySubscreen3_forceReloadGfx

inventorySubscreen3_fixupTiles:
	call getPageForSetting
	ld b,a

	call getCurrentPage
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

getCurrentPage:
	call getSelectedSettingIndex

getPageForSetting:
	or a
	ld c,a
	ld a,$00
	ret z
	-
		; x settings per page. determine the page
		.rept SETTINGS_PER_PAGE-1
			dec c
			ret z
		.endr

		inc a
		dec c
		jr nz,-
	ret

getSelectedSettingIndex:
    ld a,(wInventorySubmenu3CursorPos)
	and $7f
	cp SETTINGS_COUNT
	ret c
	xor a
	ret

itemSubmenu3TextIndices:
	.db <TX_09_QUICK_SWAP
	.db <TX_09_CONTEXT_SENSITIVE_ITEMS
	.db <TX_09_CONTEXT_SENSITIVE_BUTTON
	.db <TX_09_PASSIVE_SHIELD
	.db <TX_09_BRACELET_PUNCH
	.db <TX_09_DUNGEON_AUTOSAVE
	.db <TX_09_LOW_HEART_WARNING
	.db <TX_09_MESSAGE_SPEED
	.db $00

.undefine SETTINGS_COUNT
.undefine SETTINGS_PER_PAGE