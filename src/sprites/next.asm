        
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

        ; test out sprite 0 someday
        ; lda     #$04
        ; sta     oamStagingLength
        ; lda     #$A0
        ; sta     oamStaging+0
        ; lda     #$00
        ; sta     oamStaging+1
        ; lda     #$00
        ; sta     oamStaging+2
        ; lda     #$02
        ; sta     oamStaging+3
        
        lda     displayNextPiece
        bne     @ret
        lda     #$2A
        sec
        sbc     ppuScrollX
        sta     spriteXOffset
        lda     #$10
        sta     spriteYOffset
        ldx     nextPiece
        lda     orientationToSpriteTable,x
        sta     spriteIndexInOamContentLookup
        jmp     loadSpriteIntoOamStaging

@ret:   rts
