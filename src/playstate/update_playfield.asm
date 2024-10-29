updatePlayfieldUnused:
        ldx     tetriminoY
        dex
        dex
        txa
        bpl     @rowInRange
        lda     #$00
@rowInRange:
        cmp     vramRow
        bpl     @ret
        sta     vramRow
@ret:   rts
