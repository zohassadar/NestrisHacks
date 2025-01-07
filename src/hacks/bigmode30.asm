stageSpriteForCurrentPieceActual:
        lda     tetriminoX
        asl     a
        asl     a
        asl     a
        clc
        adc     #$04
        sta     generalCounter3 ; x position of center block
        clc
        lda     tetriminoY
        rol     a
        rol     a
        rol     a
        sta     generalCounter4 ; y position of center block
        lda     currentPiece
        sta     generalCounter5
        clc
        lda     generalCounter5
        rol     a
        rol     a
        sta     generalCounter
        rol     a
        adc     generalCounter
        tax ; x contains index into orientation table
        ldy     oamStagingLength
        lda     #$04
        sta     generalCounter2 ; iterate through all four minos
@stageMino:
        lda     orientationTable,x
        asl     a
        asl     a
        asl     a
        clc
        adc     generalCounter4
        asl
        clc
        adc     spriteY
        clc
        adc     #$27
        sta     oamStaging,y ; stage y coordinate of mino
        sta     originalY
        inc     oamStagingLength
        iny
        inx
        lda     orientationTable,x
        clc
        adc     tileOffset
        sta     oamStaging,y ; stage block type of mino
        inc     oamStagingLength
        iny
        inx
        lda     #$02
        sta     oamStaging,y ; stage palette/front priority
        lda     originalY
        cmp     #$27 ; compares with smallest allowed y position on the screen, not the field
        bcs     @validYCoordinate
        inc     oamStagingLength
        dey
        lda     #$FF
        sta     oamStaging,y ; make tile invisible
        iny
        iny
        lda     #$00
        sta     oamStaging,y ; make x coordinate 0 for some reason
        jmp     @finishLoop

@validYCoordinate:
        inc     oamStagingLength
        iny
        lda     orientationTable,x
        asl     a
        asl     a
        asl     a
        clc
        adc     generalCounter3
        asl
        clc
        adc     spriteX
        sta     oamStaging,y ; stage actual x coordinate
@finishLoop:
        inc     oamStagingLength
        iny
        inx
        dec     generalCounter2
        bne     @stageMino
        rts

multBy15Table:
    ;>>> print(','.join(f'${i&0xff:02x}' for i in range(0,15*20,15)))
    .byte $00,$0f,$1e,$2d,$3c,$4b,$5a,$69,$78,$87,$96,$a5,$b4,$c3,$d2,$e1,$f0,$ff,$0e,$1d

stageSpriteForCurrentPieceBigMode30:
        lda     #$00
        sta     spriteX
        sta     spriteY
        sta     tileOffset
        jsr     stageSpriteForCurrentPieceActual
        lda     #$08
        sta     spriteX
        lda     #$01
        sta     tileOffset
        jsr     stageSpriteForCurrentPieceActual
        lda     #$08
        sta     spriteY
        lda     #$11
        sta     tileOffset
        jsr     stageSpriteForCurrentPieceActual
        lda     #$00
        sta     spriteX
        lda     #$10
        sta     tileOffset
        jmp     stageSpriteForCurrentPieceActual


updateLineClearingAnimation:
        lda     frameCounter
        and     #$01
        bne     @ret
        lda     #$00
        sta     generalCounter3
@whileCounter3LessThan8:
        lda     generalCounter3
        and     #$01
        sta     generalCounter5
        lda     generalCounter3
        lsr
        tax
        lda     completedRow,x
        beq     @nextRow
        asl     a
        clc
        adc     generalCounter5
        asl     a
        tay
        lda     vramPlayfieldRows,y
        sta     generalCounter
        ; lda     generalCounter
        ; clc
        ; adc     #$06
        ; sta     generalCounter
        iny
        lda     vramPlayfieldRows,y
        sta     generalCounter2
        sta     PPUADDR
        ldx     rowY
        lda     leftColumns,x
        clc
        adc     generalCounter
        sta     PPUADDR
        lda     #$FF
        sta     PPUDATA
        lda     generalCounter2
        sta     PPUADDR
        ldx     rowY
        lda     rightColumns,x
        clc
        adc     generalCounter
        sta     PPUADDR
        lda     #$FF
        sta     PPUDATA
@nextRow:
        inc     generalCounter3
        lda     generalCounter3
        cmp     #$08
        bne     @whileCounter3LessThan8
        inc     rowY
        lda     rowY
        cmp     #$0F
        bmi     @ret
        inc     playState
@ret:   rts

leftColumns:
        .byte   $0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00
rightColumns:
        .byte   $0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d

vramPlayfieldRows:
        .word   $20a1,$20c1,$20e1
        .word   $2101,$2121,$2141,$2161
        .word   $2181,$21a1,$21c1,$21e1
        .word   $2201,$2221,$2241,$2261
        .word   $2281,$22a1,$22c1,$22e1
        .word   $2301,$2321,$2341,$2361
        .word   $2381
