
render_mode_ending_animation:
        lda     #$20
        sta     PPUADDR
        lda     #$8E
        sta     PPUADDR
        lda     player1_score+2
        jsr     twoDigsToPPU
        lda     player1_score+1
        jsr     twoDigsToPPU
        lda     player1_score
        jsr     twoDigsToPPU
        lda     gameType
        beq     L9FE9
        lda     #$20
        sta     PPUADDR
        lda     #$B0
        sta     PPUADDR
        lda     generalCounter4
        jsr     twoDigsToPPU
        lda     #$20
        sta     PPUADDR
        lda     #$D0
        sta     PPUADDR
        lda     generalCounter5
        jsr     twoDigsToPPU
        lda     #$21
        sta     PPUADDR
        lda     #$2E
        sta     PPUADDR
        lda     $DE
        jsr     twoDigsToPPU
        lda     $DD
        jsr     twoDigsToPPU
        lda     $DC
        jsr     twoDigsToPPU
L9FE9:  ldy     #$00
        sty     PPUSCROLL
        sty     PPUSCROLL
        rts
    