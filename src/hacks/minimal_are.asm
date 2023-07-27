playState_checkForCompletedRows:
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
        tax                       
        lda     slightlyBiggerMultBy10Table,x   
        sta     generalCounter
        tay
        ldx     #$0A
@checkIfRowComplete:
        lda     playfield,y   
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
        lda     playfield,y 
        sta     playfield+10,y
        dey
        cpy     #$FF
        bne     @movePlayfieldDownOneRow
        lda     #$EF
        ldy     #$00
@clearRowTopRow:
        sta     playfield,y  
        iny
        cpy     #$0A
        bne     @clearRowTopRow
        lda     #$13
        sta     currentPiece
        bne     @incrementLineIndex
@rowNotComplete:
        ldx     lineIndex
        lda     #$00
        sta     completedRow,x
@incrementLineIndex:
        inc     lineIndex
        lda     lineIndex
        cmp     #$04
        bmi     @updatePlayfieldComplete
        lda     #$00
        sta     vramRow
        sta     rowY
        lda     #$04
        cmp     completedLines              
        bne     @skipTetrisSoundEffect
        sta     soundEffectSlot1Init
@skipTetrisSoundEffect:
        inc     playState
        lda     completedLines
        bne     @ret
        inc     playState
        lda     #$07
        sta     soundEffectSlot1Init
@ret:   rts


playState_bTypeGoalCheck:
        lda     gameType
        beq     @ret
        lda     lines
        bne     @ret
        lda     #$02
        jsr     setMusicTrack
        ldy     #$46
        ldx     #$00
@copySuccessGraphic:
        lda     typebSuccessGraphic,x
        cmp     #$80
        beq     @graphicCopied
        sta     (playfieldAddr),y
        inx
        iny
        jmp     @copySuccessGraphic

@graphicCopied:  lda     #$00
        sta     player1_vramRow
        jsr     sleep_for_14_vblanks
        lda     #$00
        sta     renderMode
        lda     #$80
        jsr     sleep_for_a_vblanks
        jsr     endingAnimation_maybe
        lda     #$00
        sta     playState
        inc     gameModeState

; build flags left here to show what's diff from original
.ifdef MINIMAL_ARE
        jmp    playState_receiveGarbage
.else
        rts
.endif

@ret:  inc     playState
        rts


playState_updateLinesAndStatistics:
        jsr     updateMusicSpeed
        lda     completedLines
        bne     @linesCleared
        jmp     addHoldDownPointsInMinimal

@linesCleared:
        tax
        dex
        lda     lineClearStatsByType,x
        clc
        adc     #$01
        sta     lineClearStatsByType,x
        and     #$0F
        cmp     #$0A
        bmi     @noCarry
        lda     lineClearStatsByType,x
        clc
        adc     #$06
        sta     lineClearStatsByType,x
@noCarry:
        lda     outOfDateRenderFlags
        ora     #$01
        sta     outOfDateRenderFlags
        lda     gameType
        beq     @gameTypeA
        lda     completedLines
        sta     generalCounter
        lda     lines
        sec
        sbc     generalCounter
        sta     lines
        bpl     @checkForBorrow
        lda     #$00
        sta     lines
        jmp     addHoldDownPointsInMinimal

@checkForBorrow:
        and     #$0F
        cmp     #$0A
        bmi     addHoldDownPointsInMinimal
        lda     lines
        sec
        sbc     #$06
        sta     lines
        jmp     addHoldDownPointsInMinimal

@gameTypeA:
        ldx     completedLines
incrementLinesinMinimal:
        inc     lines
        lda     lines
        and     #$0F
        cmp     #$0A
        bmi     M9BC7
        lda     lines
        clc
        adc     #$06
        sta     lines
        and     #$F0
        cmp     #$A0
        bcc     M9BC7
        lda     lines
        and     #$0F
        sta     lines
        inc     lines+1
M9BC7:  lda     lines
        and     #$0F
        bne     M9BFB
        jmp     M9BD0

M9BD0:  lda     lines+1
        sta     generalCounter2
        lda     lines
        sta     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lsr     generalCounter2
        ror     generalCounter
        lda     levelNumber
        cmp     generalCounter
        bpl     M9BFB
        inc     levelNumber
        lda     #$06
        sta     soundEffectSlot1Init
        lda     outOfDateRenderFlags
        ora     #$02
        sta     outOfDateRenderFlags
M9BFB:  dex
        bne     incrementLinesinMinimal
addHoldDownPointsInMinimal:
        lda     holdDownPoints
        cmp     #$02
        bmi     addLineClearPointsinMinimal
        clc
        dec     score
        adc     score
        sta     score
        and     #$0F
        cmp     #$0A
        bcc     M9C18
        lda     score
        clc
        adc     #$06
        sta     score
M9C18:  lda     score
        and     #$F0
        cmp     #$A0
        bcc     M9C27
        clc
        adc     #$60
        sta     score
        inc     score+1
M9C27:  lda     outOfDateRenderFlags
        ora     #$04
        sta     outOfDateRenderFlags
addLineClearPointsinMinimal:
        lda     #$00
        sta     holdDownPoints
        lda     levelNumber
        sta     generalCounter
        inc     generalCounter
M9C37:  lda     completedLines
        asl     a
        tax
        lda     pointsTable,x
        clc
        adc     score
        sta     score
        cmp     #$A0
        bcc     M9C4E
        clc
        adc     #$60
        sta     score
        inc     score+1
M9C4E:  inx
        lda     pointsTable,x
        clc
        adc     score+1
        sta     score+1
        and     #$0F
        cmp     #$0A
        bcc     M9C64
        lda     score+1
        clc
        adc     #$06
        sta     score+1
M9C64:  lda     score+1
        and     #$F0
        cmp     #$A0
        bcc     M9C75
        lda     score+1
        clc
        adc     #$60
        sta     score+1
        inc     score+2
M9C75:  lda     score+2
        and     #$0F
        cmp     #$0A
        bcc     M9C84
        lda     score+2
        clc
        adc     #$06
        sta     score+2
M9C84:  lda     score+2
        and     #$F0
        cmp     #$A0
        bcc     M9C94
        lda     #$99
        sta     score
        sta     score+1
        sta     score+2
M9C94:  dec     generalCounter
        bne     M9C37
        lda     outOfDateRenderFlags
        ora     #$04
        sta     outOfDateRenderFlags
        lda     #$00
        sta     completedLines
        inc     playState

; build flags left here to show what's diff from original
.ifdef MINIMAL_ARE
        jmp     playState_bTypeGoalCheck
.else
        rts
.endif


gameModeState_updatePlayer1:
        jsr     makePlayer1Active
        jsr     branchOnPlayStatePlayer1
        lda     playState
        cmp     #$02
        bne     @skipAhead1
        jsr     branchOnPlayStatePlayer1
@skipAhead1:
        lda     playState
        cmp     #$03
        bne     @skipAhead2
        jsr     branchOnPlayStatePlayer1
@skipAhead2:
        jsr     stageSpriteForCurrentPiece
        jsr     savePlayer1State
        jsr     stageSpriteForNextPiece
        inc     gameModeState
        rts

player1VramHigh:
        .byte   $20,$20,$21,$21
        .byte   $21,$21,$21,$21
        .byte   $21,$21,$22,$22
        .byte   $22,$22,$22,$22
        .byte   $22,$22,$23,$23

player1VramLow:
        .byte   $CC,$EC,$0C,$2C
        .byte   $4C,$6C,$8C,$AC
        .byte   $CC,$EC,$0C,$2C
        .byte   $4C,$6C,$8C,$AC
        .byte   $CC,$EC,$0C,$2C

efficientCopyPlayfieldRow:
        lda     #$06
        sta     generalCounter5
@vramLoop:
        ldx     vramRow
        cpx     #$15
        bpl     @ret
        lda     multBy10Table,x
        tay
        lda     player1VramHigh,x
        sta     PPUADDR
        lda     player1VramLow,x
        sta     PPUADDR
        ldx     #$0A
@copyByte:
        lda     playfield,y
        sta     PPUDATA
        iny
        dex
        bne     @copyByte
        inc     vramRow
        dec     generalCounter5
        bpl     @vramLoop
        lda     vramRow
        cmp     #$14
        bmi     @ret
        lda     #$20
        sta     vramRow
@ret:   rts

stageCurrentPieceForPPU:
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter
        asl     a
        adc     generalCounter
        tax ; x contains index into orientation table
        lda     #$04
        sta     generalCounter2 ; iterate through all four minos
@stageMino:
        lda     tetriminoX
        clc
        adc     orientationTable+2,x
        sta     generalCounter
        lda     tetriminoY
        clc
        adc     orientationTable,x
        tay
        bmi     @negativeRow
        lda     player1VramHigh,y
        bne     @pastNegative
@negativeRow:
        lda     #$00
@pastNegative:
        pha
        lda     player1VramLow,y
        clc
        adc     generalCounter
        pha
        lda     orientationTable+1,x
        pha
        inx
        inx
        inx
        dec     generalCounter2
        bne     @stageMino
        ldx     #$0B
@popAndPush:
        pla
        sta     minimalAreStaging,x
        dex
        bpl     @popAndPush
        inc     minimalAreToggle
        rts


renderLockedPiece:
        lda     minimalAreToggle
        beq     @ret
        lda     minimalAreStaging
        beq     @piece2
        sta     PPUADDR
        lda     minimalAreStaging+1
        sta     PPUADDR
        lda     minimalAreStaging+2
        sta     PPUDATA
@piece2:
        lda     minimalAreStaging+3
        beq     @piece3
        sta     PPUADDR
        lda     minimalAreStaging+4
        sta     PPUADDR
        lda     minimalAreStaging+5
        sta     PPUDATA
@piece3:
        lda     minimalAreStaging+6
        beq     @piece4
        sta     PPUADDR
        lda     minimalAreStaging+7
        sta     PPUADDR
        lda     minimalAreStaging+8
        sta     PPUDATA
@piece4:
        lda     minimalAreStaging+9
        beq     @ret
        sta     PPUADDR
        lda     minimalAreStaging+10
        sta     PPUADDR
        lda     minimalAreStaging+11
        sta     PPUDATA
@ret:   
        lda     #$00
        sta     minimalAreToggle
        rts


renderPieceThenDoRegularRender:
        jsr   renderLockedPiece
        jmp   render_mode_play_and_demo