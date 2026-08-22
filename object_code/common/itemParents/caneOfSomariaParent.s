;;
; ITEM_CANE_OF_SOMARIA ($04)
parentItemCode_caneOfSomaria:
	ld e,Item.state
	ld a,(de)
	rst_jumpTable
	.dw @state0
	.dw @state1

@state0:
	call updateLinkDirectionFromAngle
	call parentItemLoadAnimationAndIncState
	jp itemCreateChild

@state1:
	; Delete self when animation is finished
	ld e,Item.animParameter
	ld a,(de)
	rlca
	; i have no idea why, but switching to specialObjectAnimate in bank0 causes
	; the animation to completely bork up. i'd have to trace things out to figure
	; out the root cause, but my guess is an unrelated bug is having a side-effect
	jp nc,specialObjectAnimate_optimized
	jp clearParentItem
