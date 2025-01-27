.ifdef PLAYFIELD_TOGGLE
updateLineClearingAnimationActual:
.else
updateLineClearingAnimation:
.endif

        lda     frameCounter
.ifndef TRIPLEWIDE
        and     #$03
.else
        and     #$01
.endif
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
.ifdef TWELVE
        adc     #$04
.elseif .defined(TRIPLEWIDE)
        adc     #$00
.else
        adc     #$06
.endif
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
.ifdef TWELVE
        cmp     #$06
.elseif .defined(TRIPLEWIDE)
        cmp     #$0F
.else
        cmp     #$05
.endif
        bmi     @ret
        inc     playState
@ret:   rts

.ifndef TWELVE
.ifndef TRIPLEWIDE
leftColumns:
.endif
.endif
        .byte   $04,$03,$02,$01,$00
.ifndef TWELVE
.ifndef TRIPLEWIDE
rightColumns:
.endif
.endif
        .byte   $05,$06,$07,$08,$09

.ifdef UPSIDEDOWN
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
.endif
