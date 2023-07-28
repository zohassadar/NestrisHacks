

branchOnPlayStatePlayer1:
        lda     playState
        jsr     switch_s_plus_2a
        .addr   playState_unassignOrientationId
        .addr   playState_playerControlsActiveTetrimino  ; sets vramRow based on height.
        .addr   playState_lockTetrimino                  ; 0-4 frame vramRow delay.  1 frame.  sets vramRow based on height.
        .addr   playState_checkForCompletedRows          ; 0-4 frame vramRow delay.  4 frames. sets vramRow to 0
        .addr   playState_noop
        .addr   playState_updateLinesAndStatistics       ; 1 frame
        .addr   playState_bTypeGoalCheck                 ; 1 frame
        .addr   playState_receiveGarbage                 ; 1 frame
        .addr   playState_spawnNextTetrimino             ; 1 frame vramRow delay. 1 frame
        .addr   playState_noop
        .addr   playState_updateGameOverCurtain
        .addr   playState_incrementPlayState
playState_playerControlsActiveTetrimino:
        jsr     shift_tetrimino
        jsr     rotate_tetrimino
        jsr     drop_tetrimino
        rts

branchOnPlayStatePlayer2:
        lda     playState
        jsr     switch_s_plus_2a
        .addr   playState_unassignOrientationId
        .addr   playState_player2ControlsActiveTetrimino
        .addr   playState_lockTetrimino
        .addr   playState_checkForCompletedRows
        .addr   playState_noop
        .addr   playState_updateLinesAndStatistics
        .addr   playState_bTypeGoalCheck
        .addr   playState_receiveGarbage
        .addr   playState_spawnNextTetrimino
        .addr   playState_noop
        .addr   playState_updateGameOverCurtain
        .addr   playState_incrementPlayState
playState_player2ControlsActiveTetrimino:
        jsr     shift_tetrimino
        jsr     rotate_tetrimino
        jsr     drop_tetrimino
        rts