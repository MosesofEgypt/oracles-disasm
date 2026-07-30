; Data format:
;   b0: object gfx header to use (see data/objectGfxHeaders.s)
;   b1: Value for Enemy.enemyCollisionMode (bit 7 must be set for collisions to work)
;   b2: Bits 0-6 are an index for the extraEnemyData table below.
;   b3: bits 4-7: palette + bank bit
;       bits 0-3: oamTileIndexBase/2
;
;   Or, parameters 2/3 can be replaced with a pointer to subid data (see below).

enemyData_ages:
	/* 0x00 */ m_EnemyData $00 $00 $00 $00
	/* 0x01 */ m_EnemyData $db $08 $34 $00
	/* 0x02 */ m_EnemyData $d7 $d5 $30 $60
	/* 0x03 */ m_EnemyData $33 $89 $33 $00
	/* 0x04 */ m_EnemyData $16 $8a $35 $10
	/* 0x05 */ m_EnemyData $cf $dc $02 $60
	/* 0x06 */ m_EnemyData $d4 $dd $2f $10
	/* 0x07 */ m_EnemyData $ce $de $2b $60
	/* 0x08 */ m_EnemyData $8f $0b $0c $2d
	/* 0x09 */ m_EnemyData $8f $8c enemy09SubidData
	/* 0x0a */ m_EnemyData $91 $8d enemy0aSubidData
	/* 0x0b */ m_EnemyData $8f $0c enemy0bSubidData
	/* 0x0c */ m_EnemyData $91 $8d enemy0cSubidData
	/* 0x0d */ m_EnemyData $95 $8e enemy0dSubidData
	/* 0x0e */ m_EnemyData $9e $8f enemy0eSubidData
	/* 0x0f */ m_EnemyData $d3 $0c $0e $75
	/* 0x10 */ m_EnemyData $9b $4b $0a $06
	/* 0x11 */ m_EnemyData $c4 $df $2d $39
	/* 0x12 */ m_EnemyData $9b $90 $17 $20
	/* 0x13 */ m_EnemyData $9b $91 $03 $0a
	/* 0x14 */ m_EnemyData $8c $92 $0a $14
	/* 0x15 */ m_EnemyData $9b $93 $01 $2b
	/* 0x16 */ m_EnemyData $8c $00 $00 $18
	/* 0x17 */ m_EnemyData $90 $94 enemy17SubidData_ages
	/* 0x18 */ m_EnemyData $93 $95 $0a $08
	/* 0x19 */ m_EnemyData $9b $96 $03 $09
	/* 0x1a */ m_EnemyData $94 $8c $0a $30
	/* 0x1b */ m_EnemyData $94 $8c $0a $2c
	/* 0x1c */ m_EnemyData $a0 $97 $0a $20
	/* 0x1d */ m_EnemyData $92 $82 $40 $09
	/* 0x1e */ m_EnemyData $94 $84 $0c $32
	/* 0x1f */ m_EnemyData $da $a2 $0e $68
	/* 0x20 */ m_EnemyData $90 $8d enemy20SubidData
	/* 0x21 */ m_EnemyData $98 $99 enemy21SubidData
	/* 0x22 */ m_EnemyData $9c $b4 $0e $00
	/* 0x23 */ m_EnemyData $8c $9a $0c $30
	/* 0x24 */ m_EnemyData $99 $1b $11 $36
	/* 0x25 */ m_EnemyData $94 $9c $0a $28
	/* 0x26 */ m_EnemyData $a5 $e7 $02 $28
	/* 0x27 */ m_EnemyData $8d $80 $3b $50
	/* 0x28 */ m_EnemyData $a0 $1d $11 $2c
	/* 0x29 */ m_EnemyData $a4 $04 $03 $20
	/* 0x2a */ m_EnemyData $9e $9e enemy2aSubidData
	/* 0x2b */ m_EnemyData $00 $00 $00 $00
	/* 0x2c */ m_EnemyData $a4 $cb $0a $33
	/* 0x2d */ m_EnemyData $a4 $0b $11 $50
	/* 0x2e */ m_EnemyData $a3 $9f $03 $1d
	/* 0x2f */ m_EnemyData $a3 $a0 $3c $40
	/* 0x30 */ m_EnemyData $8f $8d enemy30SubidData
	/* 0x31 */ m_EnemyData $9b $a1 enemy31SubidData
	/* 0x32 */ m_EnemyData $9d $a2 $07 $00
	/* 0x33 */ m_EnemyData $4c $00 $01 $37
	/* 0x34 */ m_EnemyData $97 $23 enemy34SubidData
	/* 0x35 */ m_EnemyData $a2 $1d $11 $10
	/* 0x36 */ m_EnemyData $4c $a4 $41 $20
	/* 0x37 */ m_EnemyData $4a $00 $00 $14
	/* 0x38 */ m_EnemyData $4b $00 $00 $20
	/* 0x39 */ m_EnemyData $9d $a5 $09 $50
	/* 0x3a */ m_EnemyData $97 $cb $0c $05
	/* 0x3b */ m_EnemyData $9a $a6 $3e $20
	/* 0x3c */ m_EnemyData $a1 $e2 enemy3cSubidData
	/* 0x3d */ m_EnemyData $91 $8d enemy3dSubidData
	/* 0x3e */ m_EnemyData $97 $c0 $0c $23
	/* 0x3f */ m_EnemyData $ad $e9 $44 $50
	/* 0x40 */ m_EnemyData $9f $28 enemy40SubidData
	/* 0x41 */ m_EnemyData $93 $29 $3d $30
	/* 0x42 */ m_EnemyData $c3 $ea $08 $2a
	/* 0x43 */ m_EnemyData $97 $aa $06 $20
	/* 0x44 */ m_EnemyData $a5 $00 $00 $10
	/* 0x45 */ m_EnemyData $92 $2b $11 $20
	/* 0x46 */ m_EnemyData $00 $00 $00 $00
	/* 0x47 */ m_EnemyData $97 $d9 $06 $2e
	/* 0x48 */ m_EnemyData $98 $99 enemy48SubidData
	/* 0x49 */ m_EnemyData $9c $b4 $0e $00
	/* 0x4a */ m_EnemyData $90 $ad enemy4aSubidData
	/* 0x4b */ m_EnemyData $99 $ae $16 $20
	/* 0x4c */ m_EnemyData $93 $29 $11 $14
	/* 0x4d */ m_EnemyData $8c $af $0e $32
	/* 0x4e */ m_EnemyData $a1 $b0 $13 $30
	/* 0x4f */ m_EnemyData $97 $b1 $16 $07
	/* 0x50 */ m_EnemyData $00 $00 $00 $00
	/* 0x51 */ m_EnemyData $9b $32 $07 $0d
	/* 0x52 */ m_EnemyData $9c $33 $0a $5b
	/* 0x53 */ m_EnemyData $4a $00 $00 $26
	/* 0x54 */ m_EnemyData $4d $f5 $1a $00
	/* 0x55 */ m_EnemyData $9c $e0 $17 $1d
	/* 0x56 */ m_EnemyData $90 $00 $00 $30
	/* 0x57 */ m_EnemyData $00 $35 $00 $00
	/* 0x58 */ m_EnemyData $00 $b6 $0a $00
	/* 0x59 */ m_EnemyData $00 $00 $00 $88
	/* 0x5a */ m_EnemyData $00 $00 $01 $00
	/* 0x5b */ m_EnemyData $00 $00 $00 $00
	/* 0x5c */ m_EnemyData $00 $00 $00 $00
	/* 0x5d */ m_EnemyData $de $de $0a $16
	/* 0x5e */ m_EnemyData $9d $b7 $42 $20
	/* 0x5f */ m_EnemyData $8c $e3 $0e $62
	/* 0x60 */ m_EnemyData $a7 $00 $00 $02
	/* 0x61 */ m_EnemyData $d0 $64 $2e $60
	/* 0x62 */ m_EnemyData $6b $8c $2c $09
	/* 0x63 */ m_EnemyData $78 $82 $01 $46
	/* 0x64 */ m_EnemyData $d5 $b0 $1b $66
	/* 0x65 */ m_EnemyData $00 $00 $00 $00
	/* 0x66 */ m_EnemyData $00 $00 $00 $00
	/* 0x67 */ m_EnemyData $00 $00 $00 $00
	/* 0x68 */ m_EnemyData $00 $00 $00 $00
	/* 0x69 */ m_EnemyData $00 $00 $00 $00
	/* 0x6a */ m_EnemyData $00 $00 $00 $00
	/* 0x6b */ m_EnemyData $00 $00 $00 $00
	/* 0x6c */ m_EnemyData $00 $00 $00 $00
	/* 0x6d */ m_EnemyData $00 $00 $00 $00
	/* 0x6e */ m_EnemyData $00 $00 $00 $00
	/* 0x6f */ m_EnemyData $00 $00 $00 $00
	/* 0x70 */ m_EnemyData $ad $d1 $1c $50
	/* 0x71 */ m_EnemyData $af $e5 $1d $20
	/* 0x72 */ m_EnemyData $b1 $e5 $1e $10
	/* 0x73 */ m_EnemyData $b4 $e5 enemy73SubidData
	/* 0x74 */ m_EnemyData $b7 $e6 $20 $30
	/* 0x75 */ m_EnemyData $3c $38 $21 $20
	/* 0x76 */ m_EnemyData $b8 $ff $22 $10
	/* 0x77 */ m_EnemyData $b9 $eb $23 $10
	/* 0x78 */ m_EnemyData $bc $ec $24 $30
	/* 0x79 */ m_EnemyData $bf $ed $25 $00
	/* 0x7a */ m_EnemyData $c2 $6e $26 $30
	/* 0x7b */ m_EnemyData $c4 $d8 $27 $10
	/* 0x7c */ m_EnemyData $c5 $f0 $28 $30
	/* 0x7d */ m_EnemyData $c8 $f1 $29 $20
	/* 0x7e */ m_EnemyData $cb $72 $2a $10
	/* 0x7f */ m_EnemyData $a9 $f3 $36 $00

enemyData_seasons:
	/* 0x00 */ m_EnemyData $00 $00 $00 $00
	/* 0x01 */ m_EnemyData $c2 $08 $34 $00
	/* 0x02 */ m_EnemyData $bd $cf $31 $60
	/* 0x03 */ m_EnemyData $24 $89 $33 $00
	/* 0x04 */ m_EnemyData $16 $8a $35 $10
	/* 0x05 */ m_EnemyData $c0 $50 $32 $60
	/* 0x06 */ m_EnemyData $b8 $d1 $2f $60
	/* 0x07 */ m_EnemyData $91 $d2 $36 $00
	/* 0x08 */ m_EnemyData $74 $0b $0c $2d
	/* 0x09 */ m_EnemyData $74 $8c enemy09SubidData
	/* 0x0a */ m_EnemyData $76 $8d enemy0aSubidData
	/* 0x0b */ m_EnemyData $74 $0c enemy0bSubidData
	/* 0x0c */ m_EnemyData $76 $8d enemy0cSubidData
	/* 0x0d */ m_EnemyData $7a $8e enemy0dSubidData
	/* 0x0e */ m_EnemyData $85 $8f enemy0eSubidData
	/* 0x0f */ m_EnemyData $88 $8f $03 $18
	/* 0x10 */ m_EnemyData $82 $4b $0a $06
	/* 0x11 */ m_EnemyData $77 $d3 $11 $07
	/* 0x12 */ m_EnemyData $82 $90 $17 $20
	/* 0x13 */ m_EnemyData $82 $91 $03 $0a
	/* 0x14 */ m_EnemyData $72 $92 $0a $14
	/* 0x15 */ m_EnemyData $82 $93 $01 $2b
	/* 0x16 */ m_EnemyData $72 $00 $00 $18
	/* 0x17 */ m_EnemyData $75 $94 enemy17SubidData_seasons
	/* 0x18 */ m_EnemyData $78 $95 $0a $08
	/* 0x19 */ m_EnemyData $82 $96 $03 $09
	/* 0x1a */ m_EnemyData $79 $8c $0a $30
	/* 0x1b */ m_EnemyData $79 $8c $0a $2c
	/* 0x1c */ m_EnemyData $87 $97 $0a $20
	/* 0x1d */ m_EnemyData $77 $82 $40 $09
	/* 0x1e */ m_EnemyData $79 $84 $0c $32
	/* 0x1f */ m_EnemyData $00 $00 $00 $00
	/* 0x20 */ m_EnemyData $75 $8d enemy20SubidData
	/* 0x21 */ m_EnemyData $7e $99 enemy21SubidData
	/* 0x22 */ m_EnemyData $83 $b4 $0e $00
	/* 0x23 */ m_EnemyData $72 $9a $0c $30
	/* 0x24 */ m_EnemyData $7f $1b $11 $36
	/* 0x25 */ m_EnemyData $79 $9c $0a $28
	/* 0x26 */ m_EnemyData $00 $00 $00 $00
	/* 0x27 */ m_EnemyData $71 $80 $3b $50
	/* 0x28 */ m_EnemyData $87 $1d $11 $2c
	/* 0x29 */ m_EnemyData $8d $04 $03 $20
	/* 0x2a */ m_EnemyData $85 $9e enemy2aSubidData
	/* 0x2b */ m_EnemyData $00 $84 $03 $a5
	/* 0x2c */ m_EnemyData $8d $8b $0a $33
	/* 0x2d */ m_EnemyData $8d $0b $11 $50
	/* 0x2e */ m_EnemyData $8c $9f $03 $1d
	/* 0x2f */ m_EnemyData $8c $a0 $3c $40
	/* 0x30 */ m_EnemyData $74 $8d enemy30SubidData
	/* 0x31 */ m_EnemyData $82 $a1 enemy31SubidData
	/* 0x32 */ m_EnemyData $84 $a2 $07 $00
	/* 0x33 */ m_EnemyData $3f $00 $01 $37
	/* 0x34 */ m_EnemyData $7d $23 enemy34SubidData
	/* 0x35 */ m_EnemyData $89 $1d $11 $10
	/* 0x36 */ m_EnemyData $3f $a4 $41 $20
	/* 0x37 */ m_EnemyData $3d $00 $00 $14
	/* 0x38 */ m_EnemyData $3e $00 $00 $20
	/* 0x39 */ m_EnemyData $84 $a5 $09 $50
	/* 0x3a */ m_EnemyData $7d $cb $0c $05
	/* 0x3b */ m_EnemyData $81 $a6 $3e $20
	/* 0x3c */ m_EnemyData $8b $d4 $0e $00
	/* 0x3d */ m_EnemyData $76 $8d enemy3dSubidData
	/* 0x3e */ m_EnemyData $7d $c0 $0c $23
	/* 0x3f */ m_EnemyData $7b $00 $00 $50
	/* 0x40 */ m_EnemyData $86 $28 enemy40SubidData
	/* 0x41 */ m_EnemyData $78 $29 $3d $30
	/* 0x42 */ m_EnemyData $79 $00 $00 $2c
	/* 0x43 */ m_EnemyData $7d $aa $06 $20
	/* 0x44 */ m_EnemyData $00 $00 $00 $00
	/* 0x45 */ m_EnemyData $77 $2b $11 $20
	/* 0x46 */ m_EnemyData $b1 $ac enemy46SubidData
	/* 0x47 */ m_EnemyData $af $22 $0a $30
	/* 0x48 */ m_EnemyData $7e $99 enemy48SubidData
	/* 0x49 */ m_EnemyData $83 $b4 $0e $00
	/* 0x4a */ m_EnemyData $75 $ad enemy4aSubidData
	/* 0x4b */ m_EnemyData $7f $ae $16 $20
	/* 0x4c */ m_EnemyData $78 $29 $0c $14
	/* 0x4d */ m_EnemyData $72 $af $0e $32
	/* 0x4e */ m_EnemyData $88 $b0 $13 $30
	/* 0x4f */ m_EnemyData $7d $b1 $16 $07
	/* 0x50 */ m_EnemyData $00 $00 $00 $00
	/* 0x51 */ m_EnemyData $82 $32 $07 $0d
	/* 0x52 */ m_EnemyData $83 $33 $0a $5b
	/* 0x53 */ m_EnemyData $3d $02 $00 $26
	/* 0x54 */ m_EnemyData $80 $d5 $01 $10
	/* 0x55 */ m_EnemyData $b5 $d6 $16 $67
	/* 0x56 */ m_EnemyData $05 $82 $3a $35
	/* 0x57 */ m_EnemyData $7c $35 $39 $10
	/* 0x58 */ m_EnemyData $00 $b6 $0a $00
	/* 0x59 */ m_EnemyData $00 $00 $00 $88
	/* 0x5a */ m_EnemyData $00 $01 $01 $00
	/* 0x5b */ m_EnemyData $4f $00 $00 $68
	/* 0x5c */ m_EnemyData $00 $00 $00 $00
	/* 0x5d */ m_EnemyData $c5 $df $0a $16
	/* 0x5e */ m_EnemyData $84 $b7 $42 $20
	/* 0x5f */ m_EnemyData $80 $d7 $41 $58
	/* 0x60 */ m_EnemyData $8f $00 $00 $02
	/* 0x61 */ m_EnemyData $00 $00 $00 $00
	/* 0x62 */ m_EnemyData $00 $00 $00 $00
	/* 0x63 */ m_EnemyData $00 $00 $00 $00
	/* 0x64 */ m_EnemyData $00 $00 $00 $00
	/* 0x65 */ m_EnemyData $00 $00 $00 $00
	/* 0x66 */ m_EnemyData $00 $00 $00 $00
	/* 0x67 */ m_EnemyData $00 $00 $00 $00
	/* 0x68 */ m_EnemyData $00 $00 $00 $00
	/* 0x69 */ m_EnemyData $00 $00 $00 $00
	/* 0x6a */ m_EnemyData $00 $00 $00 $00
	/* 0x6b */ m_EnemyData $00 $00 $00 $00
	/* 0x6c */ m_EnemyData $00 $00 $00 $00
	/* 0x6d */ m_EnemyData $00 $00 $00 $00
	/* 0x6e */ m_EnemyData $00 $00 $00 $00
	/* 0x6f */ m_EnemyData $00 $00 $00 $00
	/* 0x70 */ m_EnemyData $95 $58 enemy70SubidData
	/* 0x71 */ m_EnemyData $8a $0b $1d $10
	/* 0x72 */ m_EnemyData $96 $59 $1e $10
	/* 0x73 */ m_EnemyData $98 $5a $1f $20
	/* 0x74 */ m_EnemyData $9b $db $20 $30
	/* 0x75 */ m_EnemyData $30 $38 $21 $20
	/* 0x76 */ m_EnemyData $9e $5c $22 $20
	/* 0x77 */ m_EnemyData $a0 $5d $23 $20
	/* 0x78 */ m_EnemyData $a3 $de $24 $00
	/* 0x79 */ m_EnemyData $a8 $df $25 $60
	/* 0x7a */ m_EnemyData $ad $e0 $26 $60
	/* 0x7b */ m_EnemyData $b0 $e1 enemy7bSubidData
	/* 0x7c */ m_EnemyData $b3 $89 enemy7cSubidData
	/* 0x7d */ m_EnemyData $b6 $ef enemy7dSubidData
	/* 0x7e */ m_EnemyData $9e $5c $22 $30
	/* 0x7f */ m_EnemyData $ba $63 $30 $00

enemy09SubidData:
	m_EnemySubidData $08 $20
	m_EnemySubidData $08 $20
	m_EnemySubidData $0c $10
	m_EnemySubidData $0c $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy0aSubidData:
	m_EnemySubidData $0c $20
	m_EnemySubidData $11 $10
	m_EnemySubidDataEnd

enemy0bSubidData:
	m_EnemySubidData $0c $27
	m_EnemySubidData $0e $17
	m_EnemySubidData $0c $37
	m_EnemySubidDataEnd

enemy0cSubidData:
	m_EnemySubidData $0c $20
	m_EnemySubidData $11 $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy0dSubidData:
	m_EnemySubidData $17 $20
	m_EnemySubidData $1b $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy0eSubidData:
	m_EnemySubidData $02 $20
	m_EnemySubidData $02 $10
	m_EnemySubidData $02 $30
	m_EnemySubidData $02 $00
	m_EnemySubidData $02 $00
	m_EnemySubidData $02 $00
	m_EnemySubidDataEnd

enemy17SubidData_ages:
	m_EnemySubidData $1a $2b
	m_EnemySubidData $14 $2b
	m_EnemySubidData $16 $2b
	m_EnemySubidDataEnd

enemy17SubidData_seasons:
	m_EnemySubidData $1a $2b
	m_EnemySubidData $14 $2b
	m_EnemySubidDataEnd

enemy20SubidData:
enemy4aSubidData:
	m_EnemySubidData $0a $20
	m_EnemySubidData $0c $10
	m_EnemySubidDataEnd

enemy21SubidData:
enemy48SubidData:
	m_EnemySubidData $14 $20
	m_EnemySubidData $19 $10
	m_EnemySubidData $3f $30
	m_EnemySubidDataEnd

enemy2aSubidData:
	m_EnemySubidData $38 $08
	m_EnemySubidData $38 $18
	m_EnemySubidData $38 $28
	m_EnemySubidData $38 $38
	m_EnemySubidDataEnd

enemy30SubidData:
	m_EnemySubidData $0a $3b
	m_EnemySubidData $0c $1b
	m_EnemySubidDataEnd

enemy31SubidData:
	m_EnemySubidData $0a $12
	m_EnemySubidData $0c $22
	m_EnemySubidData $0e $32
	m_EnemySubidData $0e $02
	m_EnemySubidDataEnd

enemy34SubidData:
	m_EnemySubidData $0a $00
	m_EnemySubidData $0c $20
	m_EnemySubidDataEnd

; Unused data?
	m_EnemySubidData $00 $1b
	m_EnemySubidData $00 $1b
	m_EnemySubidDataEnd

enemy3cSubidData:
	m_EnemySubidData $0e $1c
	m_EnemySubidData $43 $1c
	m_EnemySubidDataEnd

enemy3dSubidData:
	m_EnemySubidData $0d $20
	m_EnemySubidData $12 $10
	m_EnemySubidDataEnd

enemy40SubidData:
	m_EnemySubidData $0e $00
	m_EnemySubidData $11 $20
	m_EnemySubidData $15 $10
	m_EnemySubidDataEnd

enemy46SubidData:
	m_EnemySubidData $43 $0e
	m_EnemySubidData $43 $1e
	m_EnemySubidData $43 $2e
	m_EnemySubidData $43 $3e
	m_EnemySubidDataEnd

enemy70SubidData:
	m_EnemySubidData $1c $10
	m_EnemySubidData $1c $20
	m_EnemySubidDataEnd

enemy73SubidData:
	m_EnemySubidData $1a $10
	m_EnemySubidData $1a $10
	m_EnemySubidData $31 $20
	m_EnemySubidData $32 $30
	m_EnemySubidDataEnd

enemy7bSubidData:
	m_EnemySubidData $00 $00
	m_EnemySubidData $27 $10
	m_EnemySubidData $28 $10
	m_EnemySubidData $29 $10
	m_EnemySubidDataEnd

enemy7cSubidData:
	m_EnemySubidData $00 $60
	m_EnemySubidData $3b $10
	m_EnemySubidData $2b $60
	m_EnemySubidDataEnd

enemy7dSubidData:
	m_EnemySubidData $00 $00
	m_EnemySubidData $2c $60
	m_EnemySubidData $2d $60
	m_EnemySubidData $2e $60
	m_EnemySubidDataEnd


; Data format:
;   b0: value for Enemy.collisionRadiusY
;   b1: value for Enemy.collisionRadiusX
;   b2: value for Enemy.damage (how much damage it deals)
;   b3: value for Enemy.health
extraEnemyData_ages:
	.db $00 $00 $00 $7f ; 0x00
	.db $06 $06 $00 $7f ; 0x01
	.db $04 $04 $fc $7f ; 0x02
	.db $06 $06 $fc $7f ; 0x03
	.db $04 $04 $f8 $7f ; 0x04
	.db $06 $06 $f8 $7f ; 0x05
	.db $02 $02 $fc $01 ; 0x06
	.db $04 $06 $fc $01 ; 0x07
	.db $06 $06 $fe $02 ; 0x08
	.db $04 $06 $fc $02 ; 0x09
	.db $06 $06 $fc $02 ; 0x0a
	.db $04 $06 $fc $03 ; 0x0b
	.db $06 $06 $fc $03 ; 0x0c
	.db $06 $06 $fa $03 ; 0x0d
	.db $06 $06 $fc $04 ; 0x0e
	.db $06 $06 $f8 $04 ; 0x0f
	.db $04 $04 $fc $05 ; 0x10
	.db $06 $06 $fc $05 ; 0x11
	.db $06 $06 $fa $05 ; 0x12
	.db $06 $06 $f8 $05 ; 0x13
	.db $06 $06 $fc $06 ; 0x14
	.db $06 $06 $fc $07 ; 0x15
	.db $06 $06 $fc $08 ; 0x16
	.db $06 $06 $f8 $08 ; 0x17
	.db $06 $06 $fa $09 ; 0x18
	.db $06 $06 $f8 $09 ; 0x19
	.db $06 $06 $fc $0a ; 0x1a
	.db $06 $06 $f8 $0c ; 0x1b
	.db $0a $0a $fe $0c ; 0x1c
	.db $0a $0a $fc $14 ; 0x1d
	.db $06 $06 $fc $14 ; 0x1e
	.db $08 $0a $fc $0c ; 0x1f
	.db $06 $06 $fc $05 ; 0x20
	.db $06 $06 $fe $12 ; 0x21
	.db $0c $0c $fc $1e ; 0x22
	.db $08 $08 $fa $12 ; 0x23
	.db $06 $0c $fc $08 ; 0x24
	.db $12 $0f $fc $04 ; 0x25
	.db $09 $09 $fa $0c ; 0x26
	.db $06 $06 $f8 $14 ; 0x27
	.db $0a $0a $fc $06 ; 0x28
	.db $06 $06 $fa $14 ; 0x29
	.db $0a $08 $fc $07 ; 0x2a
	.db $04 $0a $fc $04 ; 0x2b
	.db $06 $06 $00 $80 ; 0x2c
	.db $04 $04 $fe $04 ; 0x2d
	.db $08 $06 $f8 $80 ; 0x2e
	.db $0c $06 $f8 $27 ; 0x2f
	.db $08 $0a $f8 $18 ; 0x30
	.db $0c $06 $fc $03 ; 0x31
	.db $00 $00 $fc $7f ; 0x32
	.db $06 $06 $fc $03 ; 0x33
	.db $0e $07 $f8 $14 ; 0x34
	.db $12 $12 $f4 $64 ; 0x35
	.db $0a $0c $00 $06 ; 0x36
	.db $03 $02 $00 $01 ; 0x37
	.db $0d $0d $f8 $7f ; 0x38
	.db $06 $06 $fc $14 ; 0x39
	.db $04 $04 $00 $01 ; 0x3a
	.db $08 $08 $fc $7f ; 0x3b
	.db $0f $0c $f8 $7f ; 0x3c
	.db $06 $06 $fc $01 ; 0x3d
	.db $07 $0c $fc $02 ; 0x3e
	.db $06 $06 $f8 $34 ; 0x3f
	.db $07 $07 $f8 $04 ; 0x40
	.db $06 $06 $00 $20 ; 0x41
	.db $04 $06 $f8 $06 ; 0x42
	.db $04 $02 $fc $01 ; 0x43
	.db $02 $02 $00 $02 ; 0x44

extraEnemyData_seasons:
	.db $00 $00 $00 $7f ; 0x00
	.db $06 $06 $00 $7f ; 0x01
	.db $04 $04 $fc $7f ; 0x02
	.db $06 $06 $fc $7f ; 0x03
	.db $04 $04 $f8 $7f ; 0x04
	.db $06 $06 $f8 $7f ; 0x05
	.db $02 $02 $fc $01 ; 0x06
	.db $04 $06 $fc $01 ; 0x07
	.db $06 $06 $fe $02 ; 0x08
	.db $04 $06 $fc $02 ; 0x09
	.db $06 $06 $fc $02 ; 0x0a
	.db $04 $06 $fc $03 ; 0x0b
	.db $06 $06 $fc $03 ; 0x0c
	.db $06 $06 $fa $03 ; 0x0d
	.db $06 $06 $fc $04 ; 0x0e
	.db $06 $06 $f8 $04 ; 0x0f
	.db $04 $04 $fc $05 ; 0x10
	.db $06 $06 $fc $05 ; 0x11
	.db $06 $06 $fa $05 ; 0x12
	.db $06 $06 $f8 $05 ; 0x13
	.db $06 $06 $fc $06 ; 0x14
	.db $06 $06 $fc $07 ; 0x15
	.db $06 $06 $fc $08 ; 0x16
	.db $06 $06 $f8 $08 ; 0x17
	.db $06 $06 $fa $09 ; 0x18
	.db $06 $06 $f8 $09 ; 0x19
	.db $06 $06 $fc $0a ; 0x1a
	.db $06 $06 $f8 $0c ; 0x1b
	.db $06 $06 $fc $10 ; 0x1c
	.db $06 $06 $00 $14 ; 0x1d
	.db $06 $06 $fc $08 ; 0x1e
	.db $09 $04 $fe $0e ; 0x1f
	.db $06 $06 $fc $10 ; 0x20
	.db $06 $06 $fe $12 ; 0x21
	.db $06 $06 $fe $0c ; 0x22
	.db $0a $0a $f8 $0f ; 0x23
	.db $04 $04 $fc $14 ; 0x24
	.db $0c $0c $fc $7f ; 0x25
	.db $09 $09 $fa $1a ; 0x26
	.db $06 $03 $fa $1e ; 0x27
	.db $06 $11 $fa $7f ; 0x28
	.db $06 $06 $fa $14 ; 0x29
	.db $03 $03 $fc $02 ; 0x2a
	.db $0a $0a $fc $04 ; 0x2b
	.db $0c $06 $f8 $7f ; 0x2c
	.db $04 $04 $fc $02 ; 0x2d
	.db $06 $06 $f8 $06 ; 0x2e
	.db $06 $03 $f8 $19 ; 0x2f
	.db $0a $0a $f8 $30 ; 0x30
	.db $0c $0c $f8 $50 ; 0x31
	.db $04 $03 $00 $30 ; 0x32
	.db $06 $06 $fc $03 ; 0x33
	.db $0e $07 $f8 $14 ; 0x34
	.db $12 $12 $f4 $64 ; 0x35
	.db $0c $0c $00 $05 ; 0x36
	.db $03 $02 $00 $01 ; 0x37
	.db $0d $0d $f8 $7f ; 0x38
	.db $06 $06 $fc $14 ; 0x39
	.db $04 $04 $00 $01 ; 0x3a
	.db $08 $08 $fc $7f ; 0x3b
	.db $0f $0c $f8 $7f ; 0x3c
	.db $06 $06 $fc $01 ; 0x3d
	.db $07 $0c $fc $40 ; 0x3e
	.db $06 $06 $f8 $34 ; 0x3f
	.db $07 $07 $f8 $04 ; 0x40
	.db $06 $06 $00 $20 ; 0x41
	.db $04 $06 $f8 $06 ; 0x42
	.db $02 $02 $fc $02 ; 0x43
