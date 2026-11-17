; NOTE: We're changing the emptyfill from $00 to $c7 to increase
;       the chance that unintended random jumps will trigger the
;       panic handler($c7 is the opcode for rst $00, i.e. panic)
.emptyfill $c7