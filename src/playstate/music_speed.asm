; this is bugged for TRIPLEWIDE.  fixed in the branch 30big

updateMusicSpeed:
        ldx     #$05
.ifdef TWELVE
        lda     multBy12Table,x
.else
        lda     multBy10Table,x
.endif
        tay
.ifdef TWELVE
        ldx     #$0C
.else
        ldx     #$0A
.endif
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
