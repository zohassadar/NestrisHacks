updateLineClearingAnimation:
        lda     frameCounter
        and     #$03
        bne     @ret
        lda     #$00
        sta     generalCounter3
@whileCounter3LessThan4:
        ldx     generalCounter3
        lda     completedRow,x
        beq     @nextRow
.ifdef UPSIDEDOWN
        lda     #$13
        sec
        sbc     completedRow,x
.endif
        asl     a
        tay
        lda     vramPlayfieldRows,y
.ifndef UPSIDEDOWN
        sta     generalCounter
        lda     numberOfPlayers
        cmp     #$01
        bne     @twoPlayers
        lda     generalCounter
.endif
        clc
        adc     #$06
        sta     generalCounter
        jmp     @updateVRAM
@twoPlayers:
        lda     playfieldAddr+1
        cmp     #$04
        bne     @player2
.ifndef UPSIDEDOWN
        lda     generalCounter
        sec
        sbc     #$02
.endif
        sta     generalCounter
        jmp     @updateVRAM
@player2:
        lda     generalCounter
        clc
        adc     #$0C
        sta     generalCounter
@updateVRAM:
        iny
        lda     vramPlayfieldRows,y
        sta     generalCounter2
        sta     PPUADDR
        ldx     rowY
        lda     leftColumns,x
        clc
        adc     generalCounter
        sta     PPUADDR
        lda     #$FF
        sta     PPUDATA
        lda     generalCounter2
        sta     PPUADDR
        ldx     rowY
        lda     rightColumns,x
        clc
        adc     generalCounter
        sta     PPUADDR
        lda     #$FF
        sta     PPUDATA
@nextRow:
        inc     generalCounter3
        lda     generalCounter3
        cmp     #$04
        bne     @whileCounter3LessThan4
        inc     rowY
        lda     rowY
        cmp     #$05
        bmi     @ret
        inc     playState
@ret:   rts

leftColumns:
        .byte   $04,$03,$02,$01,$00
rightColumns:
        .byte   $05,$06,$07,$08,$09

.ifdef UPSIDEDOWN
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
.endif