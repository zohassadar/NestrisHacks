stageSpriteForNextPiece:
        lda     displayNextPiece
        bne     @ret
        lda     #$CC
        ldx     nextPiece
        clc
        adc     orientationToNextOffsetTableX,x
        sta     generalCounter3
        lda     #$78
        clc
        adc     orientationToNextOffsetTableY,x
        sta     generalCounter4
        clc
        txa
        rol     a
        rol     a
        sta     generalCounter
        rol     a
        clc
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
        sta     oamStaging,y ; stage y coordinate of mino
        iny
        inx
        lda     orientationTable,x
        sta     oamStaging,y ; stage block type of mino
        iny
        inx
        lda     #$02
        sta     oamStaging,y ; stage palette/front priority
        iny
        lda     orientationTable,x
        asl     a
        asl     a
        asl     a
        clc
        adc     generalCounter3
        sta     oamStaging,y ; stage actual x coordinate
@finishLoop:
        iny
        inx
        dec     generalCounter2
        bne     @stageMino
        tya
        sta     oamStagingLength
@ret:   rts

