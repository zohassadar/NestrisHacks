; this is bugged for TRIPLEWIDE.  fixed in the branch 30big

updateMusicSpeed:
.ifdef BIGMODEWIDE
        ldx     #$02
.else
        ldx     #$05
.endif
.ifdef TWELVE
        lda     multBy12Table,x
.elseif .defined(BIGMODEWIDE)
        lda     multBy15Table,x
.else
        lda     multBy10Table,x
.endif
        tay
.ifdef TWELVE
        ldx     #$0C
.elseif .defined(BIGMODEWIDE)
        ldx     #$0F
.else
        ldx     #$0A
.endif
@checkForBlockInRow:
        lda     (playfieldAddr),y
.ifdef BIGMODEWIDE
        cmp     #$EA
.else
        cmp     #$EF
.endif
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
