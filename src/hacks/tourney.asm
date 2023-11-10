stageSpritesThenloadSprites:
        jsr loadSpriteIntoOamStaging
        jsr stageSpriteForCurrentPiece
        jmp stageSpriteForNextPiece

render_endingSkippable_A:
        sta     sleepCounter
@loop:
        jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        bne     @ret
        lda     sleepCounter
        bne     @loop
        lda     ending_customVars
        bne     @loop
@ret:   rts

