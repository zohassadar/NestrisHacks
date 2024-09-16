
; A+B+Select+Start
gameModeState_checkForResetKeyCombo:
        lda     heldButtons_player1
        cmp     #$F0
        beq     @reset
        inc     gameModeState
        rts
.ifdef TOURNAMENT
@reset: jsr     clearLineCounterThenUpdateAudio2
.else
@reset: jsr     updateAudio2
.endif
        lda     #$00
        sta     gameMode
        rts
