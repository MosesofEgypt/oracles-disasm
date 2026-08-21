; ==================================================================================================
; INTERAC_TRADE_ITEM
; ==================================================================================================
m_InteractionCode $5d
	ld e,$44
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1
@state0:
	call interactionInitGraphics
	ld a,$06
	call objectSetCollideRadius
	ld l,$44
	inc (hl)
	jp objectSetVisiblec0
@state1:
	ld e,$42
	ld a,(de)
	ld hl,wTmpcfc0.genericCutscene.cfde
	call checkFlag
	jp nz,interactionDelete
	jp objectPreventLinkFromPassing
