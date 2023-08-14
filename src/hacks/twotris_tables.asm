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


twotrisInstructionWeightTable:
    .byte  $0f,$19,$1e,$20,$2a,$2b,$2e,$31
    .byte  $34,$3e,$48,$52,$57,$5c,$61,$66
    .byte  $75,$84,$93,$98,$99,$9e,$a3,$a8
    .byte  $b7,$bc,$c1,$d0,$df,$ee,$f3,$f6
    .byte  $fb


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


CompressedRotation:
    .byte $41 ; adc #$42
    .byte $f1 ; adc $42
    .byte $f1 ; adc $42,x
    .byte $f1 ; adc($42),y
    .byte $fc ; adc($42,x)
    .byte $41 ; and #$42
    .byte $f1 ; and $42
    .byte $f1 ; and $42,x
    .byte $f1 ; and($42),y
    .byte $fc ; and($42,x)
    .byte $21 ; asl
    .byte $f1 ; asl $42
    .byte $fe ; asl $42,x
    .byte $00 ; bit $42
    .byte $00 ; clc
    .byte $00 ; clv
    .byte $41 ; cmp #$42
    .byte $f1 ; cmp $42
    .byte $f1 ; cmp $42,x
    .byte $f1 ; cmp($42),y
    .byte $fc ; cmp($42,x)
    .byte $11 ; cpx #$42
    .byte $ff ; cpx $42
    .byte $11 ; cpy #$42
    .byte $ff ; cpy $42
    .byte $11 ; dec $42
    .byte $ff ; dec $42,x
    .byte $00 ; dex
    .byte $00 ; dey
    .byte $41 ; eor #$42
    .byte $f1 ; eor $42
    .byte $f1 ; eor $42,x
    .byte $f1 ; eor($42),y
    .byte $fc ; eor($42,x)
    .byte $11 ; inc $42
    .byte $ff ; inc $42,x
    .byte $00 ; inx
    .byte $00 ; iny
    .byte $41 ; lda #$42
    .byte $f1 ; lda $42
    .byte $f1 ; lda $42,x
    .byte $f1 ; lda($42),y
    .byte $fc ; lda($42,x)
    .byte $21 ; ldx #$42
    .byte $f1 ; ldx $42
    .byte $fe ; ldx $42,y
    .byte $21 ; ldy #$42
    .byte $f1 ; ldy $42
    .byte $fe ; ldy $42,x
    .byte $21 ; lsr
    .byte $f1 ; lsr $42
    .byte $fe ; lsr $42,x
    .byte $00 ; nop
    .byte $41 ; ora #$42
    .byte $f1 ; ora $42
    .byte $f1 ; ora $42,x
    .byte $f1 ; ora($42),y
    .byte $fc ; ora($42,x)
    .byte $21 ; rol
    .byte $f1 ; rol $42
    .byte $fe ; rol $42,x
    .byte $21 ; ror
    .byte $f1 ; ror $42
    .byte $fe ; ror $42,x
    .byte $41 ; sbc #$42
    .byte $f1 ; sbc $42
    .byte $f1 ; sbc $42,x
    .byte $f1 ; sbc($42),y
    .byte $fc ; sbc($42,x)
    .byte $00 ; sec
    .byte $31 ; sta $42
    .byte $f1 ; sta $42,x
    .byte $f1 ; sta($42),y
    .byte $fd ; sta($42,x)
    .byte $11 ; stx $42
    .byte $ff ; stx $42,y
    .byte $11 ; sty $42
    .byte $ff ; sty $42,x
    .byte $00 ; tax
    .byte $00 ; tay
    .byte $00 ; tsx
    .byte $00 ; txa
    .byte $00 ; tya


spawnInstructions:
    .byte $00 ; adc #$42
    .byte $05 ; and #$42
    .byte $0a ; asl
    .byte $0d ; bit $42
    .byte $0e ; clc
    .byte $0f ; clv
    .byte $10 ; cmp #$42
    .byte $15 ; cpx #$42
    .byte $17 ; cpy #$42
    .byte $19 ; dec $42
    .byte $1b ; dex
    .byte $1c ; dey
    .byte $1d ; eor #$42
    .byte $22 ; inc $42
    .byte $24 ; inx
    .byte $25 ; iny
    .byte $26 ; lda #$42
    .byte $2b ; ldx #$42
    .byte $2e ; ldy #$42
    .byte $31 ; lsr
    .byte $34 ; nop
    .byte $35 ; ora #$42
    .byte $3a ; rol
    .byte $3d ; ror
    .byte $40 ; sbc #$42
    .byte $45 ; sec
    .byte $46 ; sta $42
    .byte $4a ; stx $42
    .byte $4c ; sty $42
    .byte $4e ; tax
    .byte $4f ; tay
    .byte $50 ; tsx
    .byte $51 ; txa
    .byte $52 ; tya


fourBitTo8Bit:
    .byte    $00,$01,$02,$03,$04,$05,$06,$07,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff


twotrisInstructionStrings:
    .byte $0a,$0d,$0c ; adc
    .byte $0a,$17,$0d ; and
    .byte $0a,$1c,$15 ; asl
    .byte $0b,$12,$1d ; bit
    .byte $0c,$15,$0c ; clc
    .byte $0c,$15,$1f ; clv
    .byte $0c,$16,$19 ; cmp
    .byte $0c,$19,$21 ; cpx
    .byte $0c,$19,$22 ; cpy
    .byte $0d,$0e,$0c ; dec
    .byte $0d,$0e,$21 ; dex
    .byte $0d,$0e,$22 ; dey
    .byte $0e,$18,$1b ; eor
    .byte $12,$17,$0c ; inc
    .byte $12,$17,$21 ; inx
    .byte $12,$17,$22 ; iny
    .byte $15,$0d,$0a ; lda
    .byte $15,$0d,$21 ; ldx
    .byte $15,$0d,$22 ; ldy
    .byte $15,$1c,$1b ; lsr
    .byte $17,$18,$19 ; nop
    .byte $18,$1b,$0a ; ora
    .byte $1b,$18,$15 ; rol
    .byte $1b,$18,$1b ; ror
    .byte $1c,$0b,$0c ; sbc
    .byte $1c,$0e,$0c ; sec
    .byte $1c,$1d,$0a ; sta
    .byte $1c,$1d,$21 ; stx
    .byte $1c,$1d,$22 ; sty
    .byte $1d,$0a,$21 ; tax
    .byte $1d,$0a,$22 ; tay
    .byte $1d,$1c,$21 ; tsx
    .byte $1d,$21,$0a ; txa
    .byte $1d,$22,$0a ; tya


padding:
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00
    .byte $00


