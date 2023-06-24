sleep_for_14_vblanks:
        lda     #$14
        sta     sleepCounter
@loop:  jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     sleepCounter
        bne     @loop
        rts

sleep_for_a_vblanks:
        sta     sleepCounter
@loop:  jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     sleepCounter
        bne     @loop
        rts
