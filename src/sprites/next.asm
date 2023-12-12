        
; This is unused code
        lda     spriteIndexInOamContentLookup
        asl     a
        asl     a
        sta     generalCounter
        asl     a
        clc
        adc     generalCounter
        tay
        ldx     oamStagingLength
        lda     #$04
        sta     generalCounter2
L8B9D:  lda     orientationTable,y
        clc
        asl     a
        asl     a
        asl     a
        adc     spriteYOffset
        sta     oamStaging,x
        inx
        iny
        lda     orientationTable,y
        sta     oamStaging,x
        inx
        iny
        lda     #$02
        sta     oamStaging,x
        inx
        lda     orientationTable,y
        clc
        asl     a
        asl     a
        asl     a
        adc     spriteXOffset
        sta     oamStaging,x
        inx
        iny
        dec     generalCounter2
        bne     L8B9D
        stx     oamStagingLength
        rts

; end unused code




stageSpriteForNextPiece:
;       ; effort could go into making sure this gets hidden during rocket & high score screens
        lda     #$CF
        sta     sprite0Staging+0
        lda     #$36
        sta     sprite0Staging+1
        lda     #$43
        sta     sprite0Staging+2
        lda     #$00
        sta     sprite0Staging+3
        sec
        rol     sprite0State
        lda     sprite0State
        and     #$03
        sta     sprite0State

        
        lda     displayNextPiece
        bne     @ret
        lda     #$2A
        sec
        sbc     topPartPPUScrollX
        sta     spriteXOffset
        lda     #$10
        sta     spriteYOffset
        ldx     nextPiece
        lda     orientationToSpriteTable,x
        sta     spriteIndexInOamContentLookup
        jmp     loadSpriteIntoOamStaging

@ret:   rts
