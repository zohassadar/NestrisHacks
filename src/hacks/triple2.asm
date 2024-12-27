
playState_lockTetrimino:
        jsr     isPositionValid
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
        bmi     lockRet
        jmp     bigOrRegularLockCheck

actualLock:
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter2
        asl     a
        clc
        adc     generalCounter2
        tax
        lda     #$04
        sta     generalCounter3
@newlocksquare:
        clc
        lda     tetriminoY
        adc     orientationTable,x

; don't put pieces above the visible playfield!
        bpl     @lock
        inx
        bne     @noLock
@lock:
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        ; sta     generalCounter
        inx
        inx
        sta     generalCounter
        lda     tetriminoX
        clc
        adc     orientationTable,x
        tay
        lda     tetriminoXPlayfieldTable,y
        sta     playfieldAddr+1
        lda     effectiveTetriminoXTable,y
        clc
        adc     generalCounter

        tay
        dex
        bit     bigFlag
        bmi     @loadAlternateTile
        lda     orientationTable,x
        bne     @storeTile
@loadAlternateTile:
        lda     currentTile
@storeTile:
        sta     (playfieldAddr),y
@noLock:
        inx
        inx
        dec     generalCounter3
        bne     @newlocksquare
;        lda     #$00
;        sta     lineIndex
;        jsr     updatePlayfield
;        jsr     updateMusicSpeed
;        inc     playState
lockRet:
        rts


vramPlayfieldRows:
        .word   $2081,$20a1,$20c1,$20e1
        .word   $2101,$2121,$2141,$2161
        .word   $2181,$21a1,$21c1,$21e1
        .word   $2201,$2221,$2241,$2261
        .word   $2281,$22a1,$22c1,$22e1
        .word   $2301,$2321,$2341,$2361
        .word   $2381

leftColumns:
        .byte   $0e,$0d,$0c,$0b,$0a,$09,$08,$07,$06,$05,$04,$03,$02,$01,$00
rightColumns:
        .byte   $0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d



playState_checkForCompletedRows:
        lda     vramRow
        cmp     #$20
        bpl     @updatePlayfieldComplete
        jmp     @ret

@updatePlayfieldComplete:
        lda     tetriminoY
        sec
        sbc     #$04
        bpl     @yInRange
        lda     #$00
@yInRange:
        clc
        adc     lineIndex
    ; todo - potential bug here maybe.  exit if below bottom row??
    ; probably not possible to manifest
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
        lda     centerPlayfield,y
        cmp     #$EF
        beq     @rowNotComplete
        lda     leftPlayfield,y
        cmp     #$EF
        beq     @rowNotComplete
        lda     rightPlayfield,y
        cmp     #$EF
        beq     @rowNotComplete
        iny
        dex
        bne     @checkIfRowComplete
        ; inc     playState
        lda     #$0A
        sta     soundEffectSlot1Init
        inc     completedLines
        ldx     lineIndex
        lda     generalCounter2
        sta     completedRow,x
        ldy     generalCounter
        dey
@movePlayfieldDownOneRow:

        lda     leftPlayfield,y
        sta     leftPlayfield+10,y
        lda     centerPlayfield,y
        sta     centerPlayfield+10,y
        lda     rightPlayfield,y
        sta     rightPlayfield+10,y

        dey
        cpy     #$FF
        bne     @movePlayfieldDownOneRow
        lda     #$EF
        ldy     #$00
@clearRowTopRow:
        sta     leftPlayfield,y
        sta     centerPlayfield,y
        sta     rightPlayfield,y
        iny
        cpy     #$0A
        bne     @clearRowTopRow
        lda     #$13
        sta     currentPiece
        jmp     @incrementLineIndex
        ; dec     playState

@rowNotComplete:
        ldx     lineIndex
        lda     #$00
        sta     completedRow,x
@incrementLineIndex:
        inc     lineIndex
        lda     lineIndex
        cmp     #$08
        beq     @finished
        lsr
        bcc     @ret
        jmp     @updatePlayfieldComplete

@finished:
        lda     #$00
        sta     vramRow
        sta     rowY
        lda     completedLines
        cmp     tetrisSound
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

playState_updateGameOverCurtain:
.ifndef ANYDAS
        lda     curtainRow
        cmp     #$1A
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
        lda     curtainRow
        bmi     @incrementCurtainRow
        asl
        sta     generalCounter
        asl
        asl
        adc     generalCounter
        tay
        lda     #$00
        sta     generalCounter3
        lda     #$13
        sta     currentPiece
@drawCurtainRow:
        lda     #$4F
        sta     leftPlayfield,y
        sta     centerPlayfield,y
        sta     rightPlayfield,y
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


initTripleWideTypeB:
    lda #$03
    sta playfieldAddr+1
    jsr initPlayfieldIfTypeB
    jsr updateAudioWaitForNmiAndResetOamStaging
    lda #$04
    sta playfieldAddr+1
    jsr initPlayfieldIfTypeB
    jsr updateAudioWaitForNmiAndResetOamStaging
    lda #$05
    sta playfieldAddr+1
    jsr initPlayfieldIfTypeB
    jsr updateAudioWaitForNmiAndResetOamStaging
    lda #$04
    sta playfieldAddr+1
    rts


multBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE,$C8,$D2,$DC,$E6
        .byte   $F0

sleep_for_14_vblanks_alt:
        lda     #$0E
sleep_for_a_vblanks_alt:
        sta     sleepCounter
@sleepALoop:
        jsr     stageVramRows
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        bne     @sleepAReturn
        lda     sleepCounter
        bne     @sleepALoop
@sleepAReturn:
        rts

updatePlayfield:
        ldx     tetriminoY
        dex
        dex
        bit     bigFlag  ; keep timing the same for normal pieces
        bpl     @notBig
        dex
        dex
        dex
        dex
@notBig:
        txa
        bpl     @rowInRange
        lda     #$00
@rowInRange:
        cmp     vramRow
        bpl     @ret
        sta     vramRow
@ret:   rts
