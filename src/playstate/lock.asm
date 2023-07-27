
playState_lockTetrimino:
.ifdef AEPPOZ
        jsr     checkPositionAndMaybeEndGame
.else
        jsr     isPositionValid
.endif
        beq     @notGameOver
        lda     #$02
        sta     soundEffectSlot0Init
        lda     #$0A
        sta     playState
        lda     #$F0
        sta     curtainRow
        jsr     updateAudio2
        rts

@notGameOver:
.ifdef MINIMAL_ARE
        nop
        nop
        nop
        nop
.else
        lda     vramRow
        cmp     #$20
        bmi     @ret
.endif
.ifdef WALLHACK2
        jmp     @skipOverWallhack2Padding
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00

@skipOverWallhack2Padding:
        ldy     currentPiece
        ldx     multBy12Table,y
        lda     #$04
        sta     generalCounter3 ; Decrement for all 4 minos
@lockSquare:
        lda     tetriminoY
        clc
        adc     orientationTable,x
        asl
        sta     generalCounter
        asl
        asl
        clc
        adc     generalCounter
        sta     generalCounter
        inx
        inx
        lda     tetriminoX
        clc
        adc     orientationTable,x
        tay
        lda     effectiveTetriminoXTable,y
        clc
        adc     generalCounter
        tay
        dex
        lda     orientationTable,x
        sta     playfield,y
        dec     generalCounter2
        inx
.else
        lda     tetriminoY
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        adc     tetriminoX
        sta     generalCounter
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter2
        asl     a
        clc
        adc     generalCounter2
        tax
        ldy     #$00
        lda     #$04
        sta     generalCounter3
; Copies a single square of the tetrimino to the playfield
@lockSquare:
        lda     orientationTable,x
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        clc
        adc     generalCounter4
        clc
        adc     generalCounter
        sta     selectingLevelOrHeight
        inx
        lda     orientationTable,x
        sta     generalCounter5
        inx
        lda     orientationTable,x
        clc
        adc     selectingLevelOrHeight
        tay
        lda     generalCounter5
        sta     (playfieldAddr),y
.endif
        inx
        dec     generalCounter3
        bne     @lockSquare
        lda     #$00
        sta     lineIndex
        jsr     updatePlayfield
        jsr     updateMusicSpeed
        inc     playState
.ifdef MINIMAL_ARE
@ret:   
        jmp      stageCurrentPieceForPPU
        ; jsr     branchOnPlayStatePlayer1
.else
@ret:   rts
.endif

playState_updateGameOverCurtain:
        lda     curtainRow
        cmp     #$14
        beq     @curtainFinished
        lda     frameCounter
        and     #$03
        bne     @ret
        ldx     curtainRow
        bmi     @incrementCurtainRow
        lda     multBy10Table,x
        tay
        lda     #$00
        sta     generalCounter3
        lda     #$13
        sta     currentPiece
@drawCurtainRow:
        lda     #$4F
        sta     (playfieldAddr),y
        iny
        inc     generalCounter3
        lda     generalCounter3
        cmp     #$0A
        bne     @drawCurtainRow
        lda     curtainRow
        sta     vramRow
@incrementCurtainRow:
        inc     curtainRow
        lda     curtainRow
        cmp     #$14
        bne     @ret
@ret:   rts

@curtainFinished:
        lda     numberOfPlayers
        cmp     #$02
        beq     @exitGame
        lda     player1_score+2
        cmp     #$03
        bcc     @checkForStartButton
        lda     #$80
        jsr     sleep_for_a_vblanks
        jsr     endingAnimation_maybe
        jmp     @exitGame

@checkForStartButton:
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     @ret2
@exitGame:
        lda     #$00
        sta     playState
        sta     newlyPressedButtons_player1
@ret2:  rts

.ifdef MINIMAL_ARE
unusedPlaystate_checkForCompletedRows:
.else
playState_checkForCompletedRows:
.endif
        lda     vramRow
        cmp     #$20
        bpl     @updatePlayfieldComplete
        jmp     @ret

@updatePlayfieldComplete:
        lda     tetriminoY
        sec
        sbc     #$02
        bpl     @yInRange
        lda     #$00
@yInRange:
        clc
        adc     lineIndex
        sta     generalCounter2
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        sta     generalCounter
        tay
        ldx     #$0A
@checkIfRowComplete:
        lda     (playfieldAddr),y
        cmp     #$EF
.ifdef AEPPOZ
        beq     @keepGoingAnyway
@keepGoingAnyway:
.else
        beq     @rowNotComplete
.endif
        iny
        dex
        bne     @checkIfRowComplete
        lda     #$0A
        sta     soundEffectSlot1Init
        inc     completedLines
        ldx     lineIndex
        lda     generalCounter2
        sta     completedRow,x
        ldy     generalCounter
        dey
@movePlayfieldDownOneRow:
        lda     (playfieldAddr),y
        ldx     #$0A
        stx     playfieldAddr
        sta     (playfieldAddr),y
        lda     #$00
        sta     playfieldAddr
        dey
        cpy     #$FF
        bne     @movePlayfieldDownOneRow
        lda     #$EF
        ldy     #$00
@clearRowTopRow:
        sta     (playfieldAddr),y
        iny
        cpy     #$0A
        bne     @clearRowTopRow
        lda     #$13
        sta     currentPiece
        jmp     @incrementLineIndex

@rowNotComplete:
        ldx     lineIndex
        lda     #$00
        sta     completedRow,x
@incrementLineIndex:
        inc     lineIndex
        lda     lineIndex
        cmp     #$04
        bmi     @ret
        ldy     completedLines
        lda     garbageLines,y
        clc
        adc     pendingGarbageInactivePlayer
.ifndef PENGUIN
        ; removes 2 bytes to account for additional 2 bytes below
        sta     pendingGarbageInactivePlayer
.endif
        lda     #$00
        sta     vramRow
.ifdef PENGUIN
        lda     #$14
.endif
        sta     rowY
        lda     completedLines
        cmp     #$04
        bne     @skipTetrisSoundEffect
        lda     #$04
        sta     soundEffectSlot1Init
@skipTetrisSoundEffect:
        inc     playState
        lda     completedLines
        bne     @ret
        inc     playState
        lda     #$07
        sta     soundEffectSlot1Init
@ret:   rts