sleep_for_14_vblanks:
        lda     #$14
.ifndef TOURNAMENT
        sta     sleepCounter
sleep14loop:  
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     sleepCounter
        bne     sleep14loop
        rts
.endif
sleep_for_a_vblanks:
        sta     sleepCounter
sleepALoop:  
        jsr     updateAudioWaitForNmiAndResetOamStaging
.ifdef TOURNAMENT
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        bne     sleepAReturn
        nop
        nop
        nop
        nop
.endif
        lda     sleepCounter
        bne     sleepALoop
sleepAReturn:
        rts

