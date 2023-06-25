

showHighScores:
        lda     numberOfPlayers
        cmp     #$01
        beq     showHighScores_real
        jmp     showHighScores_ret

showHighScores_real:
        jsr     bulkCopyToPpu      ;not using @-label due to MMC1_Control in PAL
MMC1_Control    := * + 1
        .addr   high_scores_nametable
        lda     #$00
        sta     generalCounter2
        lda     gameType
        beq     @copyEntry
        lda     #$04
        sta     generalCounter2
@copyEntry:
        lda     generalCounter2
        and     #$03
        asl     a
        tax
        lda     highScorePpuAddrTable,x
        sta     PPUADDR
        lda     generalCounter2
        and     #$03
        asl     a
        tax
        inx
        lda     highScorePpuAddrTable,x
        sta     PPUADDR
        lda     generalCounter2
        asl     a
        sta     generalCounter
        asl     a
        clc
        adc     generalCounter
        tay
        ldx     #$06
@copyChar:
        lda     highScoreNames,y
        sty     generalCounter
        tay
        lda     highScoreCharToTile,y
        ldy     generalCounter
        sta     PPUDATA
        iny
        dex
        bne     @copyChar
        lda     #$FF
        sta     PPUDATA
        lda     generalCounter2
        sta     generalCounter
        asl     a
        clc
        adc     generalCounter
        tay
        lda     highScoreScoresA,y
        jsr     twoDigsToPPU
        iny
        lda     highScoreScoresA,y
        jsr     twoDigsToPPU
        iny
        lda     highScoreScoresA,y
        jsr     twoDigsToPPU
        lda     #$FF
        sta     PPUDATA
        ldy     generalCounter2
        lda     highScoreLevels,y
        tax
        lda     byteToBcdTable,x
        jsr     twoDigsToPPU
        inc     generalCounter2
        lda     generalCounter2
        cmp     #$03
        beq     showHighScores_ret
        cmp     #$07
        beq     showHighScores_ret
        jmp     @copyEntry

showHighScores_ret:  rts

highScorePpuAddrTable:
        .dbyt   $2289,$22C9,$2309
highScoreCharToTile:
        .byte   $24,$0A,$0B,$0C,$0D,$0E,$0F,$10
        .byte   $11,$12,$13,$14,$15,$16,$17,$18
        .byte   $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
        .byte   $21,$22,$23,$00,$01,$02,$03,$04
        .byte   $05,$06,$07,$08,$09,$25,$4F,$5E
        .byte   $5F,$6E,$6F,$FF
unreferenced_data7:
        .byte   $00,$00,$00,$00
; maxes out at 49
byteToBcdTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23
        .byte   $24,$25,$26,$27,$28,$29,$30,$31
        .byte   $32,$33,$34,$35,$36,$37,$38,$39
        .byte   $40,$41,$42,$43,$44,$45,$46,$47
        .byte   $48,$49
; Adjusts high score table and handles data entry, if necessary
handleHighScoreIfNecessary:
        lda     #$00
        sta     highScoreEntryRawPos
        lda     gameType
        beq     @compareWithPos
        lda     #$04
        sta     highScoreEntryRawPos
@compareWithPos:
        lda     highScoreEntryRawPos
        sta     generalCounter2
        asl     a
        clc
        adc     generalCounter2
        tay
        lda     highScoreScoresA,y
        cmp     player1_score+2
        beq     @checkHundredsByte
        bcs     @tooSmall
        bcc     adjustHighScores
@checkHundredsByte:
        iny
        lda     highScoreScoresA,y
        cmp     player1_score+1
        beq     @checkOnesByte
        bcs     @tooSmall
        bcc     adjustHighScores
; This breaks ties by prefering the new score
@checkOnesByte:
        iny
        lda     highScoreScoresA,y
        cmp     player1_score
        beq     adjustHighScores
        bcc     adjustHighScores
@tooSmall:
        inc     highScoreEntryRawPos
        lda     highScoreEntryRawPos
        cmp     #$03
        beq     @ret
        cmp     #$07
        beq     @ret
        jmp     @compareWithPos

@ret:   rts

adjustHighScores:
        lda     highScoreEntryRawPos
        and     #$03
        cmp     #$02
        bpl     @doneMovingOldScores
        lda     #$06
        jsr     copyHighScoreNameToNextIndex
        lda     #$03
        jsr     copyHighScoreScoreToNextIndex
        lda     #$01
        jsr     copyHighScoreLevelToNextIndex
        lda     highScoreEntryRawPos
        and     #$03
        bne     @doneMovingOldScores
        lda     #$00
        jsr     copyHighScoreNameToNextIndex
        lda     #$00
        jsr     copyHighScoreScoreToNextIndex
        lda     #$00
        jsr     copyHighScoreLevelToNextIndex
@doneMovingOldScores:
        ldx     highScoreEntryRawPos
        lda     highScoreIndexToHighScoreNamesOffset,x
        tax
        ldy     #$06
        lda     #$00
@clearNameLetter:
        sta     highScoreNames,x
        inx
        dey
        bne     @clearNameLetter
        ldx     highScoreEntryRawPos
        lda     highScoreIndexToHighScoreScoresOffset,x
        tax
        lda     player1_score+2
        sta     highScoreScoresA,x
        inx
        lda     player1_score+1
        sta     highScoreScoresA,x
        inx
        lda     player1_score
        sta     highScoreScoresA,x
        ldx     highScoreEntryRawPos
        lda     player1_levelNumber
        sta     highScoreLevels,x
        jmp     highScoreEntryScreen

; reg a: start byte to copy
copyHighScoreNameToNextIndex:
        sta     generalCounter
        lda     gameType
        beq     @offsetAdjustedForGameType
        lda     #$18
        clc
        adc     generalCounter
        sta     generalCounter
@offsetAdjustedForGameType:
        lda     #$05
        sta     generalCounter2
@copyLetter:
        lda     generalCounter
        clc
        adc     generalCounter2
        tax
        lda     highScoreNames,x
        sta     generalCounter3
        txa
        clc
        adc     #$06
        tax
        lda     generalCounter3
        sta     highScoreNames,x
        dec     generalCounter2
        lda     generalCounter2
        cmp     #$FF
        bne     @copyLetter
        rts

; reg a: start byte to copy
copyHighScoreScoreToNextIndex:
        tax
        lda     gameType
        beq     @xAdjustedForGameType
        txa
        clc
        adc     #$0C
        tax
@xAdjustedForGameType:
        lda     highScoreScoresA,x
        sta     highScoreScoresA+3,x
        inx
        lda     highScoreScoresA,x
        sta     highScoreScoresA+3,x
        inx
        lda     highScoreScoresA,x
        sta     highScoreScoresA+3,x
        rts

; reg a: start byte to copy
copyHighScoreLevelToNextIndex:
        tax
        lda     gameType
        beq     @xAdjustedForGameType
        txa
        clc
        adc     #$04
        tax
@xAdjustedForGameType:
        lda     highScoreLevels,x
        sta     highScoreLevels+1,x
        rts

highScoreIndexToHighScoreNamesOffset:
        .byte   $00,$06,$0C,$12,$18,$1E,$24,$2A
highScoreIndexToHighScoreScoresOffset:
        .byte   $00,$03,$06,$09,$0C,$0F,$12,$15
highScoreEntryScreen:
.ifdef CNROM
        ; a201
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        ; a209
.else
        inc     initRam
        lda     #$10
        jsr     setMMC1Control
.endif
        lda     #$09
        jsr     setMusicTrack
        lda     #$02
        sta     renderMode
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
.ifdef CNROM
        nop     ; padded out for GG codes & mods
        lda     #CNROM_BANK0
        ldy     #CNROM_BG0
        ldx     #CNROM_SPRITE0
        jsr     changeCHRBank0
.else
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
.endif
        jsr     bulkCopyToPpu
        .addr   menu_palette
        jsr     bulkCopyToPpu
        .addr   enter_high_score_nametable
        lda     #$20
        sta     PPUADDR
        lda     #$6D
        sta     PPUADDR
        lda     #$0A
        clc
        adc     gameType
        sta     PPUDATA
        jsr     showHighScores
        lda     #$02
        sta     renderMode
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     highScoreEntryRawPos
        asl     a
        sta     generalCounter
        asl     a
        clc
        adc     generalCounter
        sta     highScoreEntryNameOffsetForRow
        lda     #$00
        sta     highScoreEntryNameOffsetForLetter
        sta     oamStaging
        lda     highScoreEntryRawPos
        and     #$03
        tax
        lda     highScorePosToY,x
        sta     spriteYOffset
@renderFrame:
        lda     #$00
        sta     oamStaging
        ldx     highScoreEntryNameOffsetForLetter
        lda     highScoreNamePosToX,x
        sta     spriteXOffset
        lda     #$0E
        sta     spriteIndexInOamContentLookup
        lda     frameCounter
        and     #$03
        bne     @flickerStateSelected_checkForStartPressed
        lda     #$02
        sta     spriteIndexInOamContentLookup
@flickerStateSelected_checkForStartPressed:
        jsr     loadSpriteIntoOamStaging
        lda     newlyPressedButtons_player1
        and     #$10
        beq     @checkForAOrRightPressed
        lda     #$02
        sta     soundEffectSlot1Init
        jmp     @ret

@checkForAOrRightPressed:
        lda     newlyPressedButtons_player1
        and     #$81
        beq     @checkForBOrLeftPressed
        lda     #$01
        sta     soundEffectSlot1Init
        inc     highScoreEntryNameOffsetForLetter
        lda     highScoreEntryNameOffsetForLetter
        cmp     #$06
        bmi     @checkForBOrLeftPressed
        lda     #$00
        sta     highScoreEntryNameOffsetForLetter
@checkForBOrLeftPressed:
        lda     newlyPressedButtons_player1
        and     #$42
        beq     @checkForDownPressed
        lda     #$01
        sta     soundEffectSlot1Init
        dec     highScoreEntryNameOffsetForLetter
        lda     highScoreEntryNameOffsetForLetter
        bpl     @checkForDownPressed
        lda     #$05
        sta     highScoreEntryNameOffsetForLetter
@checkForDownPressed:
        lda     heldButtons_player1
        and     #$04
        beq     @checkForUpPressed
        lda     frameCounter
        and     #$07
        bne     @checkForUpPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     highScoreEntryNameOffsetForRow
        sta     generalCounter
        clc
        adc     highScoreEntryNameOffsetForLetter
        tax
        lda     highScoreNames,x
        sta     generalCounter
        dec     generalCounter
        lda     generalCounter
        bpl     @letterDoesNotUnderflow
        clc
        adc     #$2C
        sta     generalCounter
@letterDoesNotUnderflow:
        lda     generalCounter
        sta     highScoreNames,x
@checkForUpPressed:
        lda     heldButtons_player1
        and     #$08
        beq     @waitForVBlank
        lda     frameCounter
        and     #$07
        bne     @waitForVBlank
        lda     #$01
        sta     soundEffectSlot1Init
        lda     highScoreEntryNameOffsetForRow
        sta     generalCounter
        clc
        adc     highScoreEntryNameOffsetForLetter
        tax
        lda     highScoreNames,x
        sta     generalCounter
        inc     generalCounter
        lda     generalCounter
        cmp     #$2C
        bmi     @letterDoesNotOverflow
        sec
        sbc     #$2C
        sta     generalCounter
@letterDoesNotOverflow:
        lda     generalCounter
        sta     highScoreNames,x
@waitForVBlank:
        lda     highScoreEntryNameOffsetForRow
        clc
        adc     highScoreEntryNameOffsetForLetter
        tax
        lda     highScoreNames,x
        sta     highScoreEntryCurrentLetter
        lda     #$80
        sta     outOfDateRenderFlags
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jmp     @renderFrame

@ret:   jsr     updateAudioWaitForNmiAndResetOamStaging
        rts

highScorePosToY:
        .byte   $9F,$AF,$BF
highScoreNamePosToX:
        .byte   $48,$50,$58,$60,$68,$70
