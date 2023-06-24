
endingAnimation_maybe:
        lda     #$02
        sta     spriteIndexInOamContentLookup
        lda     #$04
        sta     renderMode
        lda     gameType
        bne     L9E49
        jmp     LA926

L9E49:  ldx     player1_levelNumber
        lda     levelDisplayTable,x
        and     #$0F
        sta     levelNumber
        lda     #$00
        sta     $DE
        sta     $DD
        sta     $DC
        lda     levelNumber
        asl     a
        asl     a
        asl     a
        asl     a
        sta     generalCounter4
        lda     player1_startHeight
        asl     a
        asl     a
        asl     a
        asl     a
        sta     generalCounter5
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
        lda     levelNumber
        cmp     #$09
        bne     L9E88
        lda     #$01
        jsr     changeCHRBank0
        lda     #$01
        jsr     changeCHRBank1
        jsr     bulkCopyToPpu
        .addr   type_b_lvl9_ending_nametable
        jmp     L9EA4

L9E88:  ldx     #$03
        lda     levelNumber
        cmp     #$02
        beq     L9E96
        cmp     #$06
        beq     L9E96
        ldx     #$02
L9E96:  txa
        jsr     changeCHRBank0
        lda     #$02
        jsr     changeCHRBank1
        jsr     bulkCopyToPpu
        .addr   type_b_ending_nametable
L9EA4:  jsr     bulkCopyToPpu
        .addr   ending_palette
        jsr     ending_initTypeBVars
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$04
        sta     renderMode
        lda     #$0A
        jsr     setMusicTrack
        lda     #$80
        jsr     render_endingUnskippable
        lda     player1_score
        sta     $DC
        lda     player1_score+1
        sta     $DD
        lda     player1_score+2
        sta     $DE
        lda     #$02
        sta     soundEffectSlot1Init
        lda     #$00
        sta     player1_score
        sta     player1_score+1
        sta     player1_score+2
        lda     #$40
        jsr     render_endingUnskippable
        lda     generalCounter4
        beq     L9F12
L9EE8:  dec     generalCounter4
        lda     generalCounter4
        and     #$0F
        cmp     #$0F
        bne     L9EFA
        lda     generalCounter4
        and     #$F0
        ora     #$09
        sta     generalCounter4
L9EFA:  lda     generalCounter4
        jsr     L9F62
        lda     #$01
        sta     soundEffectSlot1Init
        lda     #$02
        jsr     render_endingUnskippable
        lda     generalCounter4
        bne     L9EE8
        lda     #$40
        jsr     render_endingUnskippable
L9F12:  lda     generalCounter5
        beq     L9F45
L9F16:  dec     generalCounter5
        lda     generalCounter5
        and     #$0F
        cmp     #$0F
        bne     L9F28
        lda     generalCounter5
        and     #$F0
        ora     #$09
        sta     generalCounter5
L9F28:  lda     generalCounter5
        jsr     L9F62
        lda     #$01
        sta     soundEffectSlot1Init
        lda     #$02
        jsr     render_endingUnskippable
        lda     generalCounter5
        bne     L9F16
        lda     #$02
        sta     soundEffectSlot1Init
        lda     #$40
        jsr     render_endingUnskippable
L9F45:  jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     L9F45
        lda     player1_levelNumber
        sta     levelNumber
        lda     $DC
        sta     score
        lda     $DD
        sta     score+1
        lda     $DE
        sta     score+2
        rts

L9F62:  lda     #$01
        clc
        adc     $DD
        sta     $DD
        and     #$0F
        cmp     #$0A
        bcc     L9F76
        lda     $DD
        clc
        adc     #$06
        sta     $DD
L9F76:  and     #$F0
        cmp     #$A0
        bcc     L9F85
        lda     $DD
        clc
        adc     #$60
        sta     $DD
        inc     $DE
L9F85:  lda     $DE
        and     #$0F
        cmp     #$0A
        bcc     L9F94
        lda     $DE
        clc
        adc     #$06
        sta     $DE
L9F94:  rts
