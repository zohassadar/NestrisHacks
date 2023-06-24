
; A+B+Select+Start
gameModeState_checkForResetKeyCombo:
        lda     heldButtons_player1
        cmp     #$F0
        beq     @reset
        inc     gameModeState
        rts

@reset: jsr     updateAudio2
.ifdef ANYDAS
        lda     #$01
.else
        lda     #$00
.endif
        sta     gameMode
        rts