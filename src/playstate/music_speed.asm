
updateMusicSpeed:
        ldx     #$05
        lda     multBy10Table,x
        tay
        ldx     #$0A
@checkForBlockInRow:
        lda     (playfieldAddr),y
        cmp     #$EF
        bne     @foundBlockInRow
        iny
        dex
        bne     @checkForBlockInRow
        lda     allegro
        beq     @ret
        lda     #$00
        sta     allegro
        ldx     musicType
        lda     musicSelectionTable,x
        jsr     setMusicTrack
        jmp     @ret

@foundBlockInRow:
        lda     allegro
        bne     @ret
        lda     #$FF
        sta     allegro
        lda     musicType
        clc
        adc     #$04
        tax
        lda     musicSelectionTable,x
        jsr     setMusicTrack
@ret:   rts
