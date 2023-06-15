        
loadSpriteIntoOamStaging:
        clc
        lda     spriteIndexInOamContentLookup
        rol     a
        tax
        lda     oamContentLookup,x
        sta     generalCounter
        inx
        lda     oamContentLookup,x
        sta     generalCounter2
        ldx     oamStagingLength
        ldy     #$00
@whileNotFF:
        lda     (generalCounter),y
        cmp     #$FF
        beq     @ret
        clc
        adc     spriteYOffset
        sta     oamStaging,x
        inx
        iny
        lda     (generalCounter),y
        sta     oamStaging,x
        inx
        iny
        lda     (generalCounter),y
        sta     oamStaging,x
        inx
        iny
        lda     (generalCounter),y
        clc
        adc     spriteXOffset
        sta     oamStaging,x
        inx
        iny
        lda     #$04
        clc
        adc     oamStagingLength
        sta     oamStagingLength
        jmp     @whileNotFF

@ret:   rts
