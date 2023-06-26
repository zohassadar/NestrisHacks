
render_mode_congratulations_screen:
        lda     outOfDateRenderFlags
        and     #$80
        beq     @ret
        lda     highScoreEntryRawPos
        and     #$03
        asl     a
        tax
        lda     highScorePpuAddrTable,x
        sta     PPUADDR
        lda     highScoreEntryRawPos
        and     #$03
        asl     a
        tax
        inx
        lda     highScorePpuAddrTable,x
        sta     generalCounter
        clc
        adc     highScoreEntryNameOffsetForLetter
        sta     PPUADDR
        ldx     highScoreEntryCurrentLetter
        lda     highScoreCharToTile,x
        sta     PPUDATA
        lda     #$00
.ifdef SCROLLTRIS
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
.else
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
.endif
        sta     outOfDateRenderFlags
@ret:   rts
