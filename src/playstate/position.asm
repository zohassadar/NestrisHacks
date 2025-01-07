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
.ifdef BIGMODE30
        asl
        asl
        asl
        asl
        sec
        sbc     tetriminoY
        clc
.else
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
.endif
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
.elseif .defined(BIGMODE30)
        cmp     #$0E
.else
        cmp     #$16
.endif
        bcs     @invalid
        lda     orientationTable,x
.ifdef BIGMODE30
        asl
        asl
        asl
        asl
        sec
        sbc     orientationTable,x
.else
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        clc
        adc     generalCounter4
.endif
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
.ifdef BIGMODE30
        cmp     #$EA
.else
        cmp     #$EF
.endif
        bcc     @invalid
        lda     orientationTable,x
        clc
        adc     tetriminoX
.ifdef BIGMODE30
        cmp     #$0F
.else
        cmp     #$0A
.endif
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
