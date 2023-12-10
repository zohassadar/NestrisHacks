
gameModeState_handleGameOver:
        lda     #$05
        sta     generalCounter2
        lda     player1_playState
        cmp     #$00
        beq     @gameOver
        lda     numberOfPlayers
        cmp     #$01
        beq     @ret
        lda     #$04
        sta     generalCounter2
        lda     player2_playState
        cmp     #$00
        bne     @ret
@gameOver:
        lda     numberOfPlayers
        cmp     #$01
        beq     @onePlayerGameOver
        lda     #$09
        sta     gameModeState
        rts

@onePlayerGameOver:
        lda     #$03
        sta     renderMode
        lda     numberOfPlayers
        cmp     #$01
        bne     @resetGameState
        jsr     handleHighScoreIfNecessary
@resetGameState:
        lda     #$01
        sta     player1_playState
        sta     player2_playState
        lda     #$EF
        ldx     #$04
        ldy     #$04
        jsr     memset_page
        lda     #$00
        sta     player1_vramRow
        sta     player2_vramRow
        lda     #$01
        sta     player1_playState
        sta     player2_playState
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$03
        sta     gameMode
        rts

@ret:   inc     gameModeState
        rts
