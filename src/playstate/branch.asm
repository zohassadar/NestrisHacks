

branchOnPlayStatePlayer1:
        lda     playState
        jsr     switch_s_plus_2a
        .addr   playState_unassignOrientationId
        .addr   playState_playerControlsActiveTetrimino
        .addr   playState_lockTetrimino
        .addr   playState_checkForCompletedRows
        .addr   playState_duringLineClear
        .addr   playState_updateLinesAndStatistics
        .addr   playState_bTypeGoalCheck
        .addr   playState_receiveGarbage
        .addr   playState_spawnNextTetrimino
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
        .addr   playState_noop
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


playState_duringLineClear:
        lda     rowY
        cmp     #$40
        beq     @clearPiece
        cmp     #$44
        bne     @ret
        jmp     copyPlayfieldToRenderRam    
@clearPiece:
        lda     #$13
        sta     currentPiece
        lda     #$00
        sta     tetriminoY
        jsr     clearEmptyQueue
@ret:   rts