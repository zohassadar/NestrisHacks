stageSpriteForNextPiece:
        lda     displayNextPiece
        bne     retInNextStaging
        lda     #$CC
        ldx     nextPiece
        clc
        adc     orientationToNextOffsetTableX,x
        sta     generalCounter3
        lda     #$78
        clc
        adc     orientationToNextOffsetTableY,x
        sta     generalCounter4
        txa
        asl     a
        asl     a
        sta     generalCounter
        asl     a       
        clc
        adc     generalCounter
        tax ; x contains index into orientation table
        ldy     oamStagingLength
        lda     #$04
        sta     generalCounter2 ; iterate through all four minos
stageMinoInNextStaging:
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
.ifdef UPSIDEDOWN
        sta     generalCounter5
        lda     #$98
        jmp     unreferenced_orientationToSpriteTable
; This ugliness keeps this table lined up
orientationToSpriteTable:
        .byte   $00,$00,$06,$00,$00,$00,$00,$09
        .byte   $08,$00,$0B,$07,$00,$00,$0A,$00
        .byte   $00,$00,$0C
unreferenced_orientationToSpriteTable:
        sec
        sbc generalCounter5
.endif
        sta     oamStaging,y ; stage actual x coordinate
@finishLoop:
        iny
        inx
        dec     generalCounter2
        bne     stageMinoInNextStaging
        sty     oamStagingLength
retInNextStaging:   
        rts
        nop
        nop
.ifdef UPSIDEDOWN
        nop
        nop
.endif