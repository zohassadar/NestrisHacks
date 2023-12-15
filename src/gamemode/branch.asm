
gameMode_playAndEndingHighScore_jmp:
        jsr     gameMode_playAndEndingHighScore
        rts

branchOnGameMode:
        lda     gameMode
        jsr     switch_s_plus_2a
        .addr   gameMode_legalScreen
        .addr   gameMode_titleScreen
        .addr   gameMode_gameTypeMenu
        .addr   gameMode_levelMenu
        .addr   gameMode_playAndEndingHighScore_jmp
        .addr   gameMode_playAndEndingHighScore_jmp
        .addr   gameMode_startDemo
gameModeState_updatePlayer1:
        jsr     makePlayer1Active
        jsr     branchOnPlayStatePlayer1
        jsr     stageSpriteForCurrentPiece
        jsr     savePlayer1State
        jsr     stageSpriteForNextPiece
        pha
        jsr     setScrollSpeed
        pla
        inc     gameModeState
        rts

gameModeState_updatePlayer2:
        lda     numberOfPlayers
        cmp     #$02
        bne     @ret
        jsr     makePlayer2Active
        jsr     branchOnPlayStatePlayer2
        jsr     stageSpriteForCurrentPiece
        jsr     savePlayer2State
@ret:   inc     gameModeState
        rts

gameMode_playAndEndingHighScore:
        lda     gameModeState
        jsr     switch_s_plus_2a
        .addr   hehnop
        .addr   gameModeState_initGameBackground
        .addr   gameModeState_updateCountersAndNonPlayerState
        .addr   gameModeState_handleGameOver
        .addr   gameModeState_updatePlayer1
        .addr   gameModeState_updatePlayer2
        .addr   gameModeState_checkForResetKeyCombo
        .addr   gameModeState_startButtonHandling
        .addr   gameModeState_vblankThenRunState2


hehnop:
        inc gameModeState
        nop