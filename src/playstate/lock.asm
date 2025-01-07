.ifndef TWELVE
.ifndef TRIPLEWIDE
playState_lockTetrimino:
.endif
.endif
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
        lda     vramRow
        cmp     #$20
        bmi     @ret
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
.ifdef BIGMODE30
        asl
        asl
        asl
        asl
        sec
        sbc     tetriminoY
        clc
.else
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
.endif
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
.ifdef BIGMODE30
        asl
        asl
        asl
        asl
        sec
        sbc     orientationTable,x
.else
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        clc
        adc     generalCounter4
.endif
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
@ret:   rts

.ifdef TRIPLEWIDE
playState_updateGameOverCurtain_unused:
.else
playState_updateGameOverCurtain:
.endif
.ifndef ANYDAS
        lda     curtainRow
  .ifdef TALLER
        cmp     #$18
  .else
        cmp     #$14
  .endif
        beq     @curtainFinished
        lda     frameCounter
        and     #$03
.else
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        beq     @ret
        jmp     @endingAnimationCheck
        nop
.endif
        bne     @ret
        ldx     curtainRow
        bmi     @incrementCurtainRow
.ifdef TWELVE
        lda     multBy12Table,x
.else
        lda     multBy10Table,x
.endif
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
.ifdef TWELVE
        cmp     #$0C
.else
        cmp     #$0A
.endif
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
.ifdef ANYDAS
@endingAnimationCheck:
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     @startNotPressed
        lda     gameType
        bne     @bGameOrUnder30K
        lda     player1_score+2
        cmp     #$03
        bcc     @bGameOrUnder30K
        jsr     endingAnimation_maybe
@bGameOrUnder30K:
        jmp     @exitGame
@startNotPressed:  rts
        .byte $00,$00,$00,$00,$00,$00
.else
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
.endif
@exitGame:
        lda     #$00
        sta     playState
        sta     newlyPressedButtons_player1
@ret2:  rts

.ifndef TWELVE
.ifndef TRIPLEWIDE
playState_checkForCompletedRows:
.else
playstate_checkForCompletedRowsUnused:
.endif
.else
playstate_checkForCompletedRowsUnused:
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
.ifdef BIGMODE30
        asl
        asl
        asl
        asl
        sec
        sbc     generalCounter2
        nop
.else
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
.endif
        sta     generalCounter
        tay
.ifdef BIGMODE30
        ldx     #$0F
.else
        ldx     #$0A
.endif
@checkIfRowComplete:
        lda     (playfieldAddr),y
.ifdef BIGMODE30
        cmp     #$EA
.else
        cmp     #$EF
.endif
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
.ifdef BIGMODE30
        ldx     #$0F
.else
        ldx     #$0A
.endif
        stx     playfieldAddr
        sta     (playfieldAddr),y
        lda     #$00
        sta     playfieldAddr
        dey
        cpy     #$FF
        bne     @movePlayfieldDownOneRow
.ifdef BIGMODE30
        lda     #$EA
.else
        lda     #$EF
.endif
        ldy     #$00
@clearRowTopRow:
        sta     (playfieldAddr),y
        iny
.ifdef BIGMODE30
        cpy     #$0F
.else
        cpy     #$0A
.endif
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
