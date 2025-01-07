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
