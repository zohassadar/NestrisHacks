
stageSpriteForCurrentPiece:
        lda     tetriminoX
        asl     a
        asl     a
        asl     a
.ifdef TWELVE
        adc     #$50
.else
        adc     #$60
.endif
        sta     generalCounter3 ; x position of center block
.ifdef UPSIDEDOWN
        bne     @calculateYPixel
.else
        lda     numberOfPlayers
        cmp     #$01
        beq     @calculateYPixel
.endif
.ifndef WALLHACK2
        ; omit bytes to account for the extra bytes below
        lda     generalCounter3
        sec
        sbc     #$40
        sta     generalCounter3 ; if 2 player mode, player 1's field is more to the left
        lda     activePlayer
        cmp     #$01
.endif
.ifndef UPSIDEDOWN
        beq     @calculateYPixel
        lda     generalCounter3
        adc     #$6F
        sta     generalCounter3 ; and player 2's field is more to the right
.endif
@calculateYPixel:
        clc
        lda     tetriminoY
        rol     a
        rol     a
        rol     a
.ifdef TALLER
        adc     #$1F
.else
        adc     #$2F
.endif
        sta     generalCounter4 ; y position of center block
        lda     currentPiece
.ifndef UPSIDEDOWN
        sta     generalCounter5
        clc
        lda     generalCounter5
.else
        nop
        nop
        clc
.endif
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
.ifdef UPSIDEDOWN
        sta     generalCounter5
        lda     #$F6
        sec
        sbc     generalCounter5
.endif
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
.ifdef UPSIDEDOWN
        cmp #$C8 ; Maximum value in upside down mode
        bcc @validYCoordinate
.else

.ifdef TALLER
        cmp     #$1F
.else
        cmp     #$2F
.endif
        bcs     @validYCoordinate
.endif
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
.ifdef UPSIDEDOWN
        sta     generalCounter5
        lda     #$08
        sec
        sbc     generalCounter5
.endif
        sta     oamStaging,y ; stage actual x coordinate
@finishLoop:
        inc     oamStagingLength
        iny
        inx
        dec     generalCounter2
        bne     @stageMino
        rts
