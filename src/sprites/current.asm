
stageSpriteForCurrentPiece:
        lda     tetriminoX
        asl     a
        asl     a
        asl     a
        adc     #$60
        sta     generalCounter3 ; x position of center block
        lda     numberOfPlayers
        cmp     #$01
        beq     @calculateYPixel
.ifndef WALLHACK2
        ; omit bytes to account for the extra bytes below
        lda     generalCounter3
        sec
        sbc     #$40
        sta     generalCounter3 ; if 2 player mode, player 1's field is more to the left
        lda     activePlayer
        cmp     #$01
.endif
        beq     @calculateYPixel
        lda     generalCounter3
        adc     #$6F
        sta     generalCounter3 ; and player 2's field is more to the right
@calculateYPixel:
        clc
        lda     tetriminoY
        rol     a
        rol     a
        rol     a
        adc     #$2F
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
        sta     oamStaging,y ; stage y coordinate of mino
        sta     originalY
        inc     oamStagingLength
        iny
        inx
        lda     orientationTable,x
        sta     oamStaging,y ; stage block type of mino
        inc     oamStagingLength
        iny
        inx
        lda     #$02
        sta     oamStaging,y ; stage palette/front priority
        lda     originalY
        cmp     #$2F ; compares with smallest allowed y position on the screen, not the field
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
.ifdef WALLHACK2
        sty     generalCounter
        lda     orientationTable,x
        clc
        adc     tetriminoX
        tay
        lda     effectiveTetriminoXTable,y
        asl     a
        asl     a
        asl     a
        clc
        adc     #$60
        ldy     generalCounter
.else
        lda     orientationTable,x
        asl     a
        asl     a
        asl     a
        clc
        adc     generalCounter3
.endif
        sta     oamStaging,y ; stage actual x coordinate
@finishLoop:
        inc     oamStagingLength
        iny
        inx
        dec     generalCounter2
        bne     @stageMino
        rts