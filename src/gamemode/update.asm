gameModeState_updateCountersAndNonPlayerState:
        lda     #$03
        jsr     changeCHRBank0
        lda     #$03
        jsr     changeCHRBank1
        lda     #$00
        sta     oamStagingLength
        inc     player1_fallTimer
        inc     player2_fallTimer
        lda     twoPlayerPieceDelayCounter
        beq     @checkSelectButtonPressed
        inc     twoPlayerPieceDelayCounter
@checkSelectButtonPressed:
        lda     newlyPressedButtons_player1
        and     #$20
        beq     @ret
        lda     displayNextPiece
        eor     #$01
        sta     displayNextPiece
@ret:   inc     gameModeState
        rts
