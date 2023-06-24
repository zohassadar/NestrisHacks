
pollControllerButtons:
        lda     gameMode
        cmp     #$05
        beq     @demoGameMode
        jsr     pollController
        rts

@demoGameMode:
        lda     $D0
        cmp     #$FF
        beq     @recording
        jsr     pollController
        lda     newlyPressedButtons_player1
        cmp     #$10
        beq     @startButtonPressed
        lda     demo_repeats
        beq     @finishedMove
        dec     demo_repeats
        jmp     @moveInProgress

@finishedMove:
        ldx     #$00
        lda     (demoButtonsAddr,x)
        sta     generalCounter
        jsr     demoButtonsTable_indexIncr
        lda     demo_heldButtons
        eor     generalCounter
        and     generalCounter
        sta     newlyPressedButtons_player1
        lda     generalCounter
        sta     demo_heldButtons
        ldx     #$00
        lda     (demoButtonsAddr,x)
        sta     demo_repeats
        jsr     demoButtonsTable_indexIncr
        lda     demoButtonsAddr+1
        cmp     #>demoTetriminoTypeTable
        beq     @ret
        jmp     @holdButtons

@moveInProgress:
        lda     #$00
        sta     newlyPressedButtons_player1
@holdButtons:
        lda     demo_heldButtons
        sta     heldButtons_player1
@ret:   rts

@startButtonPressed:
        lda     #>demoButtonsTable
        sta     demoButtonsAddr+1
        lda     #$00
        sta     frameCounter+1
        lda     #$01
        sta     gameMode
        rts

@recording:
        jsr     pollController
        lda     gameMode
        cmp     #$05
        bne     @ret2
        lda     $D0
        cmp     #$FF
        bne     @ret2
        lda     heldButtons_player1
        cmp     demo_heldButtons
        beq     @buttonsNotChanged
        ldx     #$00
        lda     demo_heldButtons
        sta     (demoButtonsAddr,x)
        jsr     demoButtonsTable_indexIncr
        lda     demo_repeats
        sta     (demoButtonsAddr,x)
        jsr     demoButtonsTable_indexIncr
        lda     demoButtonsAddr+1
        cmp     #>demoTetriminoTypeTable
        beq     @ret2
        lda     heldButtons_player1
        sta     demo_heldButtons
        lda     #$00
        sta     demo_repeats
        rts

@buttonsNotChanged:
        inc     demo_repeats
        rts

@ret2:  rts

demoButtonsTable_indexIncr:
        lda     demoButtonsAddr
        clc
        adc     #$01
        sta     demoButtonsAddr
        lda     #$00
        adc     demoButtonsAddr+1
        sta     demoButtonsAddr+1
        rts

gameMode_startDemo:
        lda     #$00
        sta     gameType
        sta     player1_startLevel
        sta     gameModeState
        sta     player1_playState
        lda     #$05
        sta     gameMode
        jmp     gameMode_playAndEndingHighScore_jmp
        