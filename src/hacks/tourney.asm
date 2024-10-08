stageSpritesThenloadSprites:
        jsr loadSpriteIntoOamStaging
        jsr stageSpriteForCurrentPiece
        jmp stageSpriteForNextPiece

render_endingSkippable_A:
        jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        beq     render_endingSkippable_A
        rts

render_endingSkippable_B:
        ldy     player2_score
        bne     @ret
        sta     sleepCounter
@sleep:
        jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        bne     @skipped
        lda     sleepCounter
        bne     @sleep
        beq     @ret
@skipped:
        inc     player2_score
@ret:   rts

clearLineCounterThenUpdateAudio2:
        lda #$00
        sta player1_completedLines
        jmp updateAudio2
