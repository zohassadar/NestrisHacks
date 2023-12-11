
; A+B+Select+Start
gameModeState_checkForResetKeyCombo:
        lda     heldButtons_player1
        cmp     #$F0
        beq     @reset
        inc     gameModeState
        rts

@reset: jsr     updateAudio2
        lda     #$00
        sta     sprite0State
        sta     gameMode
        rts