.ifdef MINIMAL_ARE
unusedPlayState_updateLinesAndStatistics:
.else
playState_updateLinesAndStatistics:
.endif
        jsr     updateMusicSpeed
        lda     completedLines
        bne     @linesCleared
        jmp     addHoldDownPoints

@linesCleared:
        tax
        dex
        lda     lineClearStatsByType,x
        clc
        adc     #$01
        sta     lineClearStatsByType,x
        and     #$0F
        cmp     #$0A
        bmi     @noCarry
        lda     lineClearStatsByType,x
        clc
        adc     #$06
        sta     lineClearStatsByType,x
@noCarry:
        lda     outOfDateRenderFlags
        ora     #$01
        sta     outOfDateRenderFlags
        lda     gameType
        beq     @gameTypeA
        lda     completedLines
        sta     generalCounter
        lda     lines
        sec
        sbc     generalCounter
        sta     lines
        bpl     @checkForBorrow
        lda     #$00
        sta     lines
        jmp     addHoldDownPoints

@checkForBorrow:
        and     #$0F
        cmp     #$0A
        bmi     addHoldDownPoints
        lda     lines
        sec
        sbc     #$06
        sta     lines
        jmp     addHoldDownPoints

@gameTypeA:
        ldx     completedLines
incrementLines:
        inc     lines
        lda     lines
        and     #$0F
        cmp     #$0A
        bmi     L9BC7
        lda     lines
        clc
        adc     #$06
        sta     lines
        and     #$F0
        cmp     #$A0
        bcc     L9BC7
        lda     lines
        and     #$0F
        sta     lines
        inc     lines+1
L9BC7:  lda     lines
        and     #$0F
        bne     L9BFB
        jmp     L9BD0

L9BD0:  lda     lines+1
        sta     generalCounter2
        lda     lines
        sta     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lda     levelNumber
        cmp     generalCounter
        bpl     L9BFB
        inc     levelNumber
        lda     #$06
        sta     soundEffectSlot1Init
        lda     outOfDateRenderFlags
        ora     #$02
        sta     outOfDateRenderFlags
L9BFB:  dex
        bne     incrementLines
addHoldDownPoints:
        lda     holdDownPoints
        cmp     #$02
        bmi     addLineClearPoints
        clc
        dec     score
        adc     score
        sta     score
        and     #$0F
        cmp     #$0A
        bcc     L9C18
        lda     score
        clc
        adc     #$06
        sta     score
L9C18:  lda     score
        and     #$F0
        cmp     #$A0
        bcc     L9C27
        clc
        adc     #$60
        sta     score
        inc     score+1
L9C27:  lda     outOfDateRenderFlags
        ora     #$04
        sta     outOfDateRenderFlags
addLineClearPoints:
        lda     #$00
        sta     holdDownPoints
        lda     levelNumber
        sta     generalCounter
        inc     generalCounter
L9C37:  lda     completedLines
        asl     a
        tax
        lda     pointsTable,x
        clc
        adc     score
        sta     score
        cmp     #$A0
        bcc     L9C4E
        clc
        adc     #$60
        sta     score
        inc     score+1
L9C4E:  inx
        lda     pointsTable,x
        clc
        adc     score+1
        sta     score+1
        and     #$0F
        cmp     #$0A
        bcc     L9C64
        lda     score+1
        clc
        adc     #$06
        sta     score+1
L9C64:  lda     score+1
        and     #$F0
        cmp     #$A0
        bcc     L9C75
        lda     score+1
        clc
        adc     #$60
        sta     score+1
        inc     score+2
L9C75:  lda     score+2
        and     #$0F
        cmp     #$0A
        bcc     L9C84
        lda     score+2
        clc
        adc     #$06
        sta     score+2
L9C84:  lda     score+2
        and     #$F0
        cmp     #$A0
        bcc     L9C94
        lda     #$99
        sta     score
        sta     score+1
        sta     score+2
L9C94:  dec     generalCounter
        bne     L9C37
        lda     outOfDateRenderFlags
        ora     #$04
        sta     outOfDateRenderFlags
        lda     #$00
        sta     completedLines
        inc     playState
        rts

pointsTable:
        .word   $0000,$0040,$0100,$0300
        .word   $1200