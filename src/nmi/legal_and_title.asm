render_mode_legal_and_title_screens:
        lda     currentPpuCtrl
        and     #$FC
        sta     currentPpuCtrl
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        rts

        lda     #$00
        sta     player1_levelNumber
        lda     #$00
        sta     gameType
        lda     #$04
        lda     gameMode
        rts
