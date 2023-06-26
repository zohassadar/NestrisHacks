render_mode_legal_and_title_screens:
        lda     currentPpuCtrl
        and     #$FC
        sta     currentPpuCtrl
        lda     #$00
.ifdef SCROLLTRIS
        lda     ppuScrollX
        sta     PPUSCROLL
        lda     ppuScrollY
        sta     PPUSCROLL
.else
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
.endif
        rts

        lda     #$00
        sta     player1_levelNumber
        lda     #$00
        sta     gameType
        lda     #$04
        lda     gameMode
        rts
