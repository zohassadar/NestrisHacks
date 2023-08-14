twotrisOpcodeTable:
    .byte $69 ; adc #$42
    .byte $65 ; adc $42
    .byte $75 ; adc $42,x
    .byte $71 ; adc($42),y
    .byte $61 ; adc($42,x)
    .byte $29 ; and #$42
    .byte $25 ; and $42
    .byte $35 ; and $42,x
    .byte $31 ; and($42),y
    .byte $21 ; and($42,x)
    .byte $0a ; asl
    .byte $06 ; asl $42
    .byte $16 ; asl $42,x
    .byte $24 ; bit $42
    .byte $18 ; clc
    .byte $b8 ; clv
    .byte $c9 ; cmp #$42
    .byte $c5 ; cmp $42
    .byte $d5 ; cmp $42,x
    .byte $d1 ; cmp($42),y
    .byte $c1 ; cmp($42,x)
    .byte $e0 ; cpx #$42
    .byte $e4 ; cpx $42
    .byte $c0 ; cpy #$42
    .byte $c4 ; cpy $42
    .byte $c6 ; dec $42
    .byte $d6 ; dec $42,x
    .byte $ca ; dex
    .byte $88 ; dey
    .byte $49 ; eor #$42
    .byte $45 ; eor $42
    .byte $55 ; eor $42,x
    .byte $51 ; eor($42),y
    .byte $41 ; eor($42,x)
    .byte $e6 ; inc $42
    .byte $f6 ; inc $42,x
    .byte $e8 ; inx
    .byte $c8 ; iny
    .byte $a9 ; lda #$42
    .byte $a5 ; lda $42
    .byte $b5 ; lda $42,x
    .byte $b1 ; lda($42),y
    .byte $a1 ; lda($42,x)
    .byte $a2 ; ldx #$42
    .byte $a6 ; ldx $42
    .byte $b6 ; ldx $42,y
    .byte $a0 ; ldy #$42
    .byte $a4 ; ldy $42
    .byte $b4 ; ldy $42,x
    .byte $4a ; lsr
    .byte $46 ; lsr $42
    .byte $56 ; lsr $42,x
    .byte $ea ; nop
    .byte $09 ; ora #$42
    .byte $05 ; ora $42
    .byte $15 ; ora $42,x
    .byte $11 ; ora($42),y
    .byte $01 ; ora($42,x)
    .byte $2a ; rol
    .byte $26 ; rol $42
    .byte $36 ; rol $42,x
    .byte $6a ; ror
    .byte $66 ; ror $42
    .byte $76 ; ror $42,x
    .byte $e9 ; sbc #$42
    .byte $e5 ; sbc $42
    .byte $f5 ; sbc $42,x
    .byte $f1 ; sbc($42),y
    .byte $e1 ; sbc($42,x)
    .byte $38 ; sec
    .byte $85 ; sta $42
    .byte $95 ; sta $42,x
    .byte $91 ; sta($42),y
    .byte $81 ; sta($42,x)
    .byte $86 ; stx $42
    .byte $96 ; stx $42,y
    .byte $84 ; sty $42
    .byte $94 ; sty $42,x
    .byte $aa ; tax
    .byte $a8 ; tay
    .byte $ba ; tsx
    .byte $8a ; txa
    .byte $98 ; tya


twotrisAddressingTable:
    .byte $01 ; adc #$42
    .byte $02 ; adc $42
    .byte $03 ; adc $42,x
    .byte $04 ; adc($42),y
    .byte $05 ; adc($42,x)
    .byte $01 ; and #$42
    .byte $02 ; and $42
    .byte $03 ; and $42,x
    .byte $04 ; and($42),y
    .byte $05 ; and($42,x)
    .byte $00 ; asl
    .byte $02 ; asl $42
    .byte $03 ; asl $42,x
    .byte $02 ; bit $42
    .byte $00 ; clc
    .byte $00 ; clv
    .byte $01 ; cmp #$42
    .byte $02 ; cmp $42
    .byte $03 ; cmp $42,x
    .byte $04 ; cmp($42),y
    .byte $05 ; cmp($42,x)
    .byte $01 ; cpx #$42
    .byte $02 ; cpx $42
    .byte $01 ; cpy #$42
    .byte $02 ; cpy $42
    .byte $02 ; dec $42
    .byte $03 ; dec $42,x
    .byte $00 ; dex
    .byte $00 ; dey
    .byte $01 ; eor #$42
    .byte $02 ; eor $42
    .byte $03 ; eor $42,x
    .byte $04 ; eor($42),y
    .byte $05 ; eor($42,x)
    .byte $02 ; inc $42
    .byte $03 ; inc $42,x
    .byte $00 ; inx
    .byte $00 ; iny
    .byte $01 ; lda #$42
    .byte $02 ; lda $42
    .byte $03 ; lda $42,x
    .byte $04 ; lda($42),y
    .byte $05 ; lda($42,x)
    .byte $01 ; ldx #$42
    .byte $02 ; ldx $42
    .byte $06 ; ldx $42,y
    .byte $01 ; ldy #$42
    .byte $02 ; ldy $42
    .byte $03 ; ldy $42,x
    .byte $00 ; lsr
    .byte $02 ; lsr $42
    .byte $03 ; lsr $42,x
    .byte $00 ; nop
    .byte $01 ; ora #$42
    .byte $02 ; ora $42
    .byte $03 ; ora $42,x
    .byte $04 ; ora($42),y
    .byte $05 ; ora($42,x)
    .byte $00 ; rol
    .byte $02 ; rol $42
    .byte $03 ; rol $42,x
    .byte $00 ; ror
    .byte $02 ; ror $42
    .byte $03 ; ror $42,x
    .byte $01 ; sbc #$42
    .byte $02 ; sbc $42
    .byte $03 ; sbc $42,x
    .byte $04 ; sbc($42),y
    .byte $05 ; sbc($42,x)
    .byte $00 ; sec
    .byte $02 ; sta $42
    .byte $03 ; sta $42,x
    .byte $04 ; sta($42),y
    .byte $05 ; sta($42,x)
    .byte $02 ; stx $42
    .byte $06 ; stx $42,y
    .byte $02 ; sty $42
    .byte $03 ; sty $42,x
    .byte $00 ; tax
    .byte $00 ; tay
    .byte $00 ; tsx
    .byte $00 ; txa
    .byte $00 ; tya


twotrisInstructionGroups:
    .byte $00 ; adc #$42
    .byte $00 ; adc $42
    .byte $00 ; adc $42,x
    .byte $00 ; adc($42),y
    .byte $00 ; adc($42,x)
    .byte $01 ; and #$42
    .byte $01 ; and $42
    .byte $01 ; and $42,x
    .byte $01 ; and($42),y
    .byte $01 ; and($42,x)
    .byte $02 ; asl
    .byte $02 ; asl $42
    .byte $02 ; asl $42,x
    .byte $03 ; bit $42
    .byte $04 ; clc
    .byte $05 ; clv
    .byte $06 ; cmp #$42
    .byte $06 ; cmp $42
    .byte $06 ; cmp $42,x
    .byte $06 ; cmp($42),y
    .byte $06 ; cmp($42,x)
    .byte $07 ; cpx #$42
    .byte $07 ; cpx $42
    .byte $08 ; cpy #$42
    .byte $08 ; cpy $42
    .byte $09 ; dec $42
    .byte $09 ; dec $42,x
    .byte $0a ; dex
    .byte $0b ; dey
    .byte $0c ; eor #$42
    .byte $0c ; eor $42
    .byte $0c ; eor $42,x
    .byte $0c ; eor($42),y
    .byte $0c ; eor($42,x)
    .byte $0d ; inc $42
    .byte $0d ; inc $42,x
    .byte $0e ; inx
    .byte $0f ; iny
    .byte $10 ; lda #$42
    .byte $10 ; lda $42
    .byte $10 ; lda $42,x
    .byte $10 ; lda($42),y
    .byte $10 ; lda($42,x)
    .byte $11 ; ldx #$42
    .byte $11 ; ldx $42
    .byte $11 ; ldx $42,y
    .byte $12 ; ldy #$42
    .byte $12 ; ldy $42
    .byte $12 ; ldy $42,x
    .byte $13 ; lsr
    .byte $13 ; lsr $42
    .byte $13 ; lsr $42,x
    .byte $14 ; nop
    .byte $15 ; ora #$42
    .byte $15 ; ora $42
    .byte $15 ; ora $42,x
    .byte $15 ; ora($42),y
    .byte $15 ; ora($42,x)
    .byte $16 ; rol
    .byte $16 ; rol $42
    .byte $16 ; rol $42,x
    .byte $17 ; ror
    .byte $17 ; ror $42
    .byte $17 ; ror $42,x
    .byte $18 ; sbc #$42
    .byte $18 ; sbc $42
    .byte $18 ; sbc $42,x
    .byte $18 ; sbc($42),y
    .byte $18 ; sbc($42,x)
    .byte $19 ; sec
    .byte $1a ; sta $42
    .byte $1a ; sta $42,x
    .byte $1a ; sta($42),y
    .byte $1a ; sta($42,x)
    .byte $1b ; stx $42
    .byte $1b ; stx $42,y
    .byte $1c ; sty $42
    .byte $1c ; sty $42,x
    .byte $1d ; tax
    .byte $1e ; tay
    .byte $1f ; tsx
    .byte $20 ; txa
    .byte $21 ; tya


twotrisRotationPrevious:
    .byte $04 ; adc #$42
    .byte $00 ; adc $42
    .byte $01 ; adc $42,x
    .byte $02 ; adc($42),y
    .byte $03 ; adc($42,x)
    .byte $09 ; and #$42
    .byte $05 ; and $42
    .byte $06 ; and $42,x
    .byte $07 ; and($42),y
    .byte $08 ; and($42,x)
    .byte $0c ; asl
    .byte $0a ; asl $42
    .byte $0b ; asl $42,x
    .byte $0d ; bit $42
    .byte $0e ; clc
    .byte $0f ; clv
    .byte $14 ; cmp #$42
    .byte $10 ; cmp $42
    .byte $11 ; cmp $42,x
    .byte $12 ; cmp($42),y
    .byte $13 ; cmp($42,x)
    .byte $16 ; cpx #$42
    .byte $15 ; cpx $42
    .byte $18 ; cpy #$42
    .byte $17 ; cpy $42
    .byte $1a ; dec $42
    .byte $19 ; dec $42,x
    .byte $1b ; dex
    .byte $1c ; dey
    .byte $21 ; eor #$42
    .byte $1d ; eor $42
    .byte $1e ; eor $42,x
    .byte $1f ; eor($42),y
    .byte $20 ; eor($42,x)
    .byte $23 ; inc $42
    .byte $22 ; inc $42,x
    .byte $24 ; inx
    .byte $25 ; iny
    .byte $2a ; lda #$42
    .byte $26 ; lda $42
    .byte $27 ; lda $42,x
    .byte $28 ; lda($42),y
    .byte $29 ; lda($42,x)
    .byte $2d ; ldx #$42
    .byte $2b ; ldx $42
    .byte $2c ; ldx $42,y
    .byte $30 ; ldy #$42
    .byte $2e ; ldy $42
    .byte $2f ; ldy $42,x
    .byte $33 ; lsr
    .byte $31 ; lsr $42
    .byte $32 ; lsr $42,x
    .byte $34 ; nop
    .byte $39 ; ora #$42
    .byte $35 ; ora $42
    .byte $36 ; ora $42,x
    .byte $37 ; ora($42),y
    .byte $38 ; ora($42,x)
    .byte $3c ; rol
    .byte $3a ; rol $42
    .byte $3b ; rol $42,x
    .byte $3f ; ror
    .byte $3d ; ror $42
    .byte $3e ; ror $42,x
    .byte $44 ; sbc #$42
    .byte $40 ; sbc $42
    .byte $41 ; sbc $42,x
    .byte $42 ; sbc($42),y
    .byte $43 ; sbc($42,x)
    .byte $45 ; sec
    .byte $49 ; sta $42
    .byte $46 ; sta $42,x
    .byte $47 ; sta($42),y
    .byte $48 ; sta($42,x)
    .byte $4b ; stx $42
    .byte $4a ; stx $42,y
    .byte $4d ; sty $42
    .byte $4c ; sty $42,x
    .byte $4e ; tax
    .byte $4f ; tay
    .byte $50 ; tsx
    .byte $51 ; txa
    .byte $52 ; tya


twotrisRotationNext:
    .byte $01 ; adc #$42
    .byte $02 ; adc $42
    .byte $03 ; adc $42,x
    .byte $04 ; adc($42),y
    .byte $00 ; adc($42,x)
    .byte $06 ; and #$42
    .byte $07 ; and $42
    .byte $08 ; and $42,x
    .byte $09 ; and($42),y
    .byte $05 ; and($42,x)
    .byte $0b ; asl
    .byte $0c ; asl $42
    .byte $0a ; asl $42,x
    .byte $0d ; bit $42
    .byte $0e ; clc
    .byte $0f ; clv
    .byte $11 ; cmp #$42
    .byte $12 ; cmp $42
    .byte $13 ; cmp $42,x
    .byte $14 ; cmp($42),y
    .byte $10 ; cmp($42,x)
    .byte $16 ; cpx #$42
    .byte $15 ; cpx $42
    .byte $18 ; cpy #$42
    .byte $17 ; cpy $42
    .byte $1a ; dec $42
    .byte $19 ; dec $42,x
    .byte $1b ; dex
    .byte $1c ; dey
    .byte $1e ; eor #$42
    .byte $1f ; eor $42
    .byte $20 ; eor $42,x
    .byte $21 ; eor($42),y
    .byte $1d ; eor($42,x)
    .byte $23 ; inc $42
    .byte $22 ; inc $42,x
    .byte $24 ; inx
    .byte $25 ; iny
    .byte $27 ; lda #$42
    .byte $28 ; lda $42
    .byte $29 ; lda $42,x
    .byte $2a ; lda($42),y
    .byte $26 ; lda($42,x)
    .byte $2c ; ldx #$42
    .byte $2d ; ldx $42
    .byte $2b ; ldx $42,y
    .byte $2f ; ldy #$42
    .byte $30 ; ldy $42
    .byte $2e ; ldy $42,x
    .byte $32 ; lsr
    .byte $33 ; lsr $42
    .byte $31 ; lsr $42,x
    .byte $34 ; nop
    .byte $36 ; ora #$42
    .byte $37 ; ora $42
    .byte $38 ; ora $42,x
    .byte $39 ; ora($42),y
    .byte $35 ; ora($42,x)
    .byte $3b ; rol
    .byte $3c ; rol $42
    .byte $3a ; rol $42,x
    .byte $3e ; ror
    .byte $3f ; ror $42
    .byte $3d ; ror $42,x
    .byte $41 ; sbc #$42
    .byte $42 ; sbc $42
    .byte $43 ; sbc $42,x
    .byte $44 ; sbc($42),y
    .byte $40 ; sbc($42,x)
    .byte $45 ; sec
    .byte $47 ; sta $42
    .byte $48 ; sta $42,x
    .byte $49 ; sta($42),y
    .byte $46 ; sta($42,x)
    .byte $4b ; stx $42
    .byte $4a ; stx $42,y
    .byte $4d ; sty $42
    .byte $4c ; sty $42,x
    .byte $4e ; tax
    .byte $4f ; tay
    .byte $50 ; tsx
    .byte $51 ; txa
    .byte $52 ; tya


twotrisInstructionStrings:
    .byte "adc"
    .byte "and"
    .byte "asl"
    .byte "bit"
    .byte "clc"
    .byte "clv"
    .byte "cmp"
    .byte "cpx"
    .byte "cpy"
    .byte "dec"
    .byte "dex"
    .byte "dey"
    .byte "eor"
    .byte "inc"
    .byte "inx"
    .byte "iny"
    .byte "lda"
    .byte "ldx"
    .byte "ldy"
    .byte "lsr"
    .byte "nop"
    .byte "ora"
    .byte "rol"
    .byte "ror"
    .byte "sbc"
    .byte "sec"
    .byte "sta"
    .byte "stx"
    .byte "sty"
    .byte "tax"
    .byte "tay"
    .byte "tsx"
    .byte "txa"
    .byte "tya"


