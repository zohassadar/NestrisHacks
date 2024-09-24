.ifndef TWELVE
.ifndef TRIPLEWIDE
isPositionValid:
.endif
.endif
.ifdef WALLHACK2
        jmp     @skipOverWallhack2Padding
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00
@skipOverWallhack2Padding:
        ldy     currentPiece
        ldx     multBy12Table,y
        lda     #$04
        sta     generalCounter3
; Checks one square within the tetrimino
@checkSquare:
        lda     orientationTable,x
        clc
        adc     tetriminoY
        tay
        clc
        adc     #$02
        cmp     #$16
        bcs     @invalid
        tya
        asl
        sta     generalCounter4
        asl
        asl
        clc
        adc     generalCounter4
        sta     generalCounter4
        inx
        inx
        lda     tetriminoX
        clc
        adc     orientationTable,x
        tay
        lda     effectiveTetriminoXTable,y
        lda     generalCounter4
        clc
        adc     effectiveTetriminoXTable,y
        tay
        lda     playfield,y
        bpl     @invalid
.else
        lda     tetriminoY
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        adc     tetriminoX
        sta     generalCounter
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter2
        asl     a
        clc
        adc     generalCounter2
        tax
        ldy     #$00
        lda     #$04
        sta     generalCounter3
; Checks one square within the tetrimino
@checkSquare:
        lda     orientationTable,x
        clc
        adc     tetriminoY
        adc     #$02
.ifdef TALLER
        cmp     #$1A
.else
        cmp     #$16
.endif
        bcs     @invalid
        lda     orientationTable,x
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        clc
        adc     generalCounter4
        clc
        adc     generalCounter
        sta     selectingLevelOrHeight
        inx
        inx
        lda     orientationTable,x
        clc
        adc     selectingLevelOrHeight
        tay
        lda     (playfieldAddr),y
        cmp     #$EF
        bcc     @invalid
        lda     orientationTable,x
        clc
        adc     tetriminoX
        cmp     #$0A
        bcs     @invalid
.endif
        inx
        dec     generalCounter3
        bne     @checkSquare
        lda     #$00
        sta     generalCounter
        rts

@invalid:
        lda     #$FF
        sta     generalCounter
        rts
