shiftTetriminoAndPopulateDasValues:
    jsr shift_tetrimino
    lda #$10
    sec
    sbc autorepeatX
    sta dasValue
    lda #$FE
    sta dasMeterTile
    lda autorepeatX
    cmp #$0A
    bcs @ret
    dec dasMeterTile
    dec dasMeterTile
@ret:
    rts

render_mode_play_and_demo_then_dasmeter:
    lda #$23
    sta PPUADDR
    lda #$89
    sta PPUADDR
    ldx autorepeatX
    beq @ret
    lda dasMeterTile
@drawDas:
    sta PPUDATA
    dex
    bne @drawDas
    ldx dasValue
    beq @ret
    lda #$FF
@drawNonDas:
    sta PPUDATA
    dex
    bne @drawNonDas
@ret:
    jsr render_mode_play_and_demo
    rts


