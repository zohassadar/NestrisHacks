        .setcpu "6502"


.include "constants.asm"
.include "charmap.asm"
.include "ram.asm"

.segment        "PRG_chunk1": absolute

.include "boot.asm"
.include "loop.asm"
.include "gamemode/branch.asm"
.include "playstate/branch.asm"
.include "gamemode/legal.asm"
.include "gamemode/title.asm"


render_mode_legal_and_title_screens:
        lda     currentPpuCtrl
        and     #$FC
        sta     currentPpuCtrl
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        rts

        lda     #$00
        sta     player1_levelNumber
        lda     #$00
        sta     gameType
        lda     #$04
        lda     gameMode
        rts

.include "gamemode/gametype_menu.asm"
.include "gamemode/level_menu.asm"

render_mode_menu_screens:
        lda     currentPpuCtrl
        and     #$FC
        sta     currentPpuCtrl
        sta     PPUCTRL
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        rts

.include "playstate/init.asm"


gameModeState_updateCountersAndNonPlayerState:
        lda     #$03
        jsr     changeCHRBank0
        lda     #$03
        jsr     changeCHRBank1
        lda     #$00
        sta     oamStagingLength
        inc     player1_fallTimer
        inc     player2_fallTimer
        lda     twoPlayerPieceDelayCounter
        beq     @checkSelectButtonPressed
        inc     twoPlayerPieceDelayCounter
@checkSelectButtonPressed:
        lda     newlyPressedButtons_player1
        and     #$20
        beq     @ret
        lda     displayNextPiece
        eor     #$01
        sta     displayNextPiece
@ret:   inc     gameModeState
        rts
.include "playstate/rotate.asm"
.include "playstate/drop.asm"
.include "playstate/shift.asm"


.include "sprites/current.asm"


orientationTable:
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$FF,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$00,$00,$7B,$01,$01,$7B,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$01,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$FF,$00,$7B,$00,$01,$7B,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$01,$7D
        .byte   $FF,$01,$7D,$00,$FF,$7D,$FF,$00
        .byte   $7D,$FF,$00,$7D,$00,$00,$7D,$01
        .byte   $FF,$7D,$00,$FF,$7D,$01,$00,$7D
        .byte   $00,$01,$7D,$00,$00,$7D,$FF,$00
        .byte   $7D,$00,$00,$7D,$01,$01,$7D,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$01,$7C
        .byte   $00,$01,$7C,$01,$FF,$7C,$01,$00
        .byte   $7C,$00,$00,$7C,$01,$01,$7C,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$01,$7B
        .byte   $FF,$01,$7B,$00,$00,$7D,$00,$00
        .byte   $7D,$01,$01,$7D,$FF,$01,$7D,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$00,$7D
        .byte   $01,$01,$7D,$01,$FF,$7C,$00,$00
        .byte   $7C,$00,$01,$7C,$00,$01,$7C,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$00,$7C
        .byte   $01,$01,$7C,$FF,$FF,$7C,$FF,$FF
        .byte   $7C,$00,$00,$7C,$00,$01,$7C,$00
        .byte   $FF,$7C,$01,$00,$7C,$FF,$00,$7C
        .byte   $00,$00,$7C,$01,$FE,$7B,$00,$FF
        .byte   $7B,$00,$00,$7B,$00,$01,$7B,$00
        .byte   $00,$7B,$FE,$00,$7B,$FF,$00,$7B
        .byte   $00,$00,$7B,$01,$00,$FF,$00,$00
        .byte   $FF,$00,$00,$FF,$00,$00,$FF,$00

.include "sprites/next.asm"

; Only cares about orientations selected by spawnTable
orientationToSpriteTable:
        .byte   $00,$00,$06,$00,$00,$00,$00,$09
        .byte   $08,$00,$0B,$07,$00,$00,$0A,$00
        .byte   $00,$00,$0C
; Same as orientationToSpriteTable except sprites have different offsets
unreferenced_orientationToSpriteTable:
        .byte   $00,$00,$0F,$00,$00,$00,$00,$12
        .byte   $11,$00,$14,$10,$00,$00,$13,$00
        .byte   $00,$00,$15
unreferenced_data2:
        .byte   $00,$FF,$FE,$FD,$FC,$FD,$FE,$FF
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$0A,$0B,$0C,$0D,$0E,$0F
        .byte   $10,$11,$12,$13

.include "sprites/load.asm"
.include "sprites/sprites.asm"
.include "playstate/position.asm"
.include "nmi/play.asm"
.include "playstate/spawn.asm"
.include "playstate/lock.asm"

playState_receiveGarbage:
        lda     numberOfPlayers
        cmp     #$01
        beq     @ret
        ldy     pendingGarbage
        beq     @ret
        lda     vramRow
        cmp     #$20
        bmi     @delay
        lda     multBy10Table,y
        sta     generalCounter2
        lda     #$00
        sta     generalCounter
@shiftPlayfieldUp:
        ldy     generalCounter2
        lda     (playfieldAddr),y
        ldy     generalCounter
        sta     (playfieldAddr),y
        inc     generalCounter
        inc     generalCounter2
        lda     generalCounter2
        cmp     #$C8
        bne     @shiftPlayfieldUp
        iny
        ldx     #$00
@fillGarbage:
        cpx     garbageHole
        beq     @hole
        lda     #$78
        jmp     @set
@hole:
        lda     #$FF
@set:
        sta     (playfieldAddr),y
        inx
        cpx     #$0A
        bne     @inc
        ldx     #$00
@inc:   iny
        cpy     #$C8
        bne     @fillGarbage
        lda     #$00
        sta     pendingGarbage
        sta     vramRow
@ret:  inc     playState
@delay:  rts

garbageLines:
        .byte   $00,$00,$01,$02,$04


.include "playstate/score.asm"

updatePlayfield:
        ldx     tetriminoY
        dex
        dex
        txa
        bpl     @rowInRange
        lda     #$00
@rowInRange:
        cmp     vramRow
        bpl     @ret
        sta     vramRow
@ret:   rts

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
        ldy     #$05
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

updateMusicSpeed:
        ldx     #$05
        lda     multBy10Table,x
        tay
        ldx     #$0A
@checkForBlockInRow:
        lda     (playfieldAddr),y
        cmp     #$EF
        bne     @foundBlockInRow
        iny
        dex
        bne     @checkForBlockInRow
        lda     allegro
        beq     @ret
        lda     #$00
        sta     allegro
        ldx     musicType
        lda     musicSelectionTable,x
        jsr     setMusicTrack
        jmp     @ret

@foundBlockInRow:
        lda     allegro
        bne     @ret
        lda     #$FF
        sta     allegro
        lda     musicType
        clc
        adc     #$04
        tax
        lda     musicSelectionTable,x
        jsr     setMusicTrack
@ret:   rts

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

; canon is adjustMusicSpeed
setMusicTrack:
        sta     musicTrack
        lda     gameMode
        cmp     #$05
        bne     @ret
        lda     #$FF
        sta     musicTrack
@ret:   rts

; A+B+Select+Start
gameModeState_checkForResetKeyCombo:
        lda     heldButtons_player1
        cmp     #$F0
        beq     @reset
        inc     gameModeState
        rts

@reset: jsr     updateAudio2
        lda     #$00
        sta     gameMode
        rts

; It looks like the jsr _must_ do nothing, otherwise reg a != gameModeState in mainLoop and there would not be any waiting on vsync
gameModeState_vblankThenRunState2:
        lda     #$02
        sta     gameModeState
        jsr     noop_disabledVramRowIncr
        rts

playState_unassignOrientationId:
        lda     #$13
        sta     currentPiece
        rts

        inc     gameModeState
        rts

playState_incrementPlayState:
        inc     playState
playState_noop:
        rts

endingAnimation_maybe:
        lda     #$02
        sta     spriteIndexInOamContentLookup
        lda     #$04
        sta     renderMode
        lda     gameType
        bne     L9E49
        jmp     LA926

L9E49:  ldx     player1_levelNumber
        lda     levelDisplayTable,x
        and     #$0F
        sta     levelNumber
        lda     #$00
        sta     $DE
        sta     $DD
        sta     $DC
        lda     levelNumber
        asl     a
        asl     a
        asl     a
        asl     a
        sta     generalCounter4
        lda     player1_startHeight
        asl     a
        asl     a
        asl     a
        asl     a
        sta     generalCounter5
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
        lda     levelNumber
        cmp     #$09
        bne     L9E88
        lda     #$01
        jsr     changeCHRBank0
        lda     #$01
        jsr     changeCHRBank1
        jsr     bulkCopyToPpu
        .addr   type_b_lvl9_ending_nametable
        jmp     L9EA4

L9E88:  ldx     #$03
        lda     levelNumber
        cmp     #$02
        beq     L9E96
        cmp     #$06
        beq     L9E96
        ldx     #$02
L9E96:  txa
        jsr     changeCHRBank0
        lda     #$02
        jsr     changeCHRBank1
        jsr     bulkCopyToPpu
        .addr   type_b_ending_nametable
L9EA4:  jsr     bulkCopyToPpu
        .addr   ending_palette
        jsr     ending_initTypeBVars
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$04
        sta     renderMode
        lda     #$0A
        jsr     setMusicTrack
        lda     #$80
        jsr     render_endingUnskippable
        lda     player1_score
        sta     $DC
        lda     player1_score+1
        sta     $DD
        lda     player1_score+2
        sta     $DE
        lda     #$02
        sta     soundEffectSlot1Init
        lda     #$00
        sta     player1_score
        sta     player1_score+1
        sta     player1_score+2
        lda     #$40
        jsr     render_endingUnskippable
        lda     generalCounter4
        beq     L9F12
L9EE8:  dec     generalCounter4
        lda     generalCounter4
        and     #$0F
        cmp     #$0F
        bne     L9EFA
        lda     generalCounter4
        and     #$F0
        ora     #$09
        sta     generalCounter4
L9EFA:  lda     generalCounter4
        jsr     L9F62
        lda     #$01
        sta     soundEffectSlot1Init
        lda     #$02
        jsr     render_endingUnskippable
        lda     generalCounter4
        bne     L9EE8
        lda     #$40
        jsr     render_endingUnskippable
L9F12:  lda     generalCounter5
        beq     L9F45
L9F16:  dec     generalCounter5
        lda     generalCounter5
        and     #$0F
        cmp     #$0F
        bne     L9F28
        lda     generalCounter5
        and     #$F0
        ora     #$09
        sta     generalCounter5
L9F28:  lda     generalCounter5
        jsr     L9F62
        lda     #$01
        sta     soundEffectSlot1Init
        lda     #$02
        jsr     render_endingUnskippable
        lda     generalCounter5
        bne     L9F16
        lda     #$02
        sta     soundEffectSlot1Init
        lda     #$40
        jsr     render_endingUnskippable
L9F45:  jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     L9F45
        lda     player1_levelNumber
        sta     levelNumber
        lda     $DC
        sta     score
        lda     $DD
        sta     score+1
        lda     $DE
        sta     score+2
        rts

L9F62:  lda     #$01
        clc
        adc     $DD
        sta     $DD
        and     #$0F
        cmp     #$0A
        bcc     L9F76
        lda     $DD
        clc
        adc     #$06
        sta     $DD
L9F76:  and     #$F0
        cmp     #$A0
        bcc     L9F85
        lda     $DD
        clc
        adc     #$60
        sta     $DD
        inc     $DE
L9F85:  lda     $DE
        and     #$0F
        cmp     #$0A
        bcc     L9F94
        lda     $DE
        clc
        adc     #$06
        sta     $DE
L9F94:  rts

render_mode_ending_animation:
        lda     #$20
        sta     PPUADDR
        lda     #$8E
        sta     PPUADDR
        lda     player1_score+2
        jsr     twoDigsToPPU
        lda     player1_score+1
        jsr     twoDigsToPPU
        lda     player1_score
        jsr     twoDigsToPPU
        lda     gameType
        beq     L9FE9
        lda     #$20
        sta     PPUADDR
        lda     #$B0
        sta     PPUADDR
        lda     generalCounter4
        jsr     twoDigsToPPU
        lda     #$20
        sta     PPUADDR
        lda     #$D0
        sta     PPUADDR
        lda     generalCounter5
        jsr     twoDigsToPPU
        lda     #$21
        sta     PPUADDR
        lda     #$2E
        sta     PPUADDR
        lda     $DE
        jsr     twoDigsToPPU
        lda     $DD
        jsr     twoDigsToPPU
        lda     $DC
        jsr     twoDigsToPPU
L9FE9:  ldy     #$00
        sty     PPUSCROLL
        sty     PPUSCROLL
        rts

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
        inc     initRam
        lda     #$10
        jsr     setMMC1Control
        lda     #$09
        jsr     setMusicTrack
        lda     #$02
        sta     renderMode
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
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
render_mode_congratulations_screen:
        lda     outOfDateRenderFlags
        and     #$80
        beq     @ret
        lda     highScoreEntryRawPos
        and     #$03
        asl     a
        tax
        lda     highScorePpuAddrTable,x
        sta     PPUADDR
        lda     highScoreEntryRawPos
        and     #$03
        asl     a
        tax
        inx
        lda     highScorePpuAddrTable,x
        sta     generalCounter
        clc
        adc     highScoreEntryNameOffsetForLetter
        sta     PPUADDR
        ldx     highScoreEntryCurrentLetter
        lda     highScoreCharToTile,x
        sta     PPUDATA
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        sta     outOfDateRenderFlags
@ret:   rts

; Handles pausing and exiting demo
gameModeState_startButtonHandling:
        lda     gameMode
        cmp     #$05
        bne     @checkIfInGame
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     @checkIfInGame
        lda     #$01
        sta     gameMode
        jmp     @ret

@checkIfInGame:
        lda     renderMode
        cmp     #$03
        bne     @ret
        lda     newlyPressedButtons_player1
        and     #$10
        bne     @startPressed
        jmp     @ret

; Do nothing if curtain is being lowered
@startPressed:
        lda     player1_playState
        cmp     #$0A
        bne     @pause
        jmp     @ret

@pause: lda     #$05
        sta     musicStagingNoiseHi
        lda     #$00
        sta     renderMode
        jsr     updateAudioAndWaitForNmi
        lda     #$16
        sta     PPUMASK
        lda     #$FF
        ldx     #$02
        ldy     #$02
        jsr     memset_page
@pauseLoop:
        lda     #$70
        sta     spriteXOffset
        lda     #$77
        sta     spriteYOffset
        lda     #$05
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
        lda     newlyPressedButtons_player1
        cmp     #$10
        beq     @resume
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jmp     @pauseLoop

@resume:lda     #$1E
        sta     PPUMASK
        lda     #$00
        sta     musicStagingNoiseHi
        sta     player1_vramRow
        lda     #$03
        sta     renderMode
@ret:   inc     gameModeState
        rts

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
        rts

@ret:  inc     playState
        rts

typebSuccessGraphic:
        .byte   $38,$39,$39,$39,$39,$39,$39,$39
        .byte   $39,$3A,$3B,$1C,$1E,$0C,$0C,$0E
        .byte   $1C,$1C,$28,$3C,$3D,$3E,$3E,$3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3F,$80
sleep_for_14_vblanks:
        lda     #$14
        sta     sleepCounter
@loop:  jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     sleepCounter
        bne     @loop
        rts

sleep_for_a_vblanks:
        sta     sleepCounter
@loop:  jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     sleepCounter
        bne     @loop
        rts

.include "ending.asm"

; canon is waitForVerticalBlankingInterval
updateAudioWaitForNmiAndResetOamStaging:
        jsr     updateAudio_jmp
        lda     #$00
        sta     verticalBlankingInterval
        nop
@checkForNmi:
        lda     verticalBlankingInterval
        beq     @checkForNmi
        lda     #$FF
        ldx     #$02
        ldy     #$02
        jsr     memset_page
        rts

updateAudioAndWaitForNmi:
        jsr     updateAudio_jmp
        lda     #$00
        sta     verticalBlankingInterval
        nop
@checkForNmi:
        lda     verticalBlankingInterval
        beq     @checkForNmi
        rts

updateAudioWaitForNmiAndDisablePpuRendering:
        jsr     updateAudioAndWaitForNmi
        lda     currentPpuMask
        and     #$E1
_updatePpuMask:
        sta     PPUMASK
        sta     currentPpuMask
        rts

updateAudioWaitForNmiAndEnablePpuRendering:
        jsr     updateAudioAndWaitForNmi
        jsr     copyCurrentScrollAndCtrlToPPU
        lda     currentPpuMask
        ora     #$1E
        bne     _updatePpuMask
waitForVBlankAndEnableNmi:
        lda     PPUSTATUS
        and     #$80
        bne     waitForVBlankAndEnableNmi
        lda     currentPpuCtrl
        ora     #$80
        bne     _updatePpuCtrl
disableNmi:
        lda     currentPpuCtrl
        and     #$7F
_updatePpuCtrl:
        sta     PPUCTRL
        sta     currentPpuCtrl
        rts

LAA82:  ldx     #$FF
        ldy     #$00
        jsr     memset_ppu_page_and_more
        rts

copyCurrentScrollAndCtrlToPPU:
        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     currentPpuCtrl
        sta     PPUCTRL
        rts


.include "bulkcopy.asm"

;reg x: zeropage addr of seed; reg y: size of seed
generateNextPseudorandomNumber:
        lda     tmp1,x
        and     #$02
        sta     tmp1
        lda     tmp2,x
        and     #$02
        eor     tmp1
        clc
        beq     @updateNextByteInSeed
        sec
@updateNextByteInSeed:
        ror     tmp1,x
        inx
        dey
        bne     @updateNextByteInSeed
        rts

; canon is initializeOAM
copyOamStagingToOam:
        lda     #$00
        sta     OAMADDR
        lda     #$02
        sta     OAMDMA
        rts

.include "nmi/poll_controller.asm"

memset_ppu_page_and_more:
        sta     tmp1
        stx     tmp2
        sty     tmp3
        lda     PPUSTATUS
        lda     currentPpuCtrl
        and     #$FB
        sta     PPUCTRL
        sta     currentPpuCtrl
        lda     tmp1
        sta     PPUADDR
        ldy     #$00
        sty     PPUADDR
        ldx     #$04
        cmp     #$20
        bcs     LAC40
        ldx     tmp3
LAC40:  ldy     #$00
        lda     tmp2
LAC44:  sta     PPUDATA
        dey
        bne     LAC44
        dex
        bne     LAC44
        ldy     tmp3
        lda     tmp1
        cmp     #$20
        bcc     LAC67
        adc     #$02
        sta     PPUADDR
        lda     #$C0
        sta     PPUADDR
        ldx     #$40
LAC61:  sty     PPUDATA
        dex
        bne     LAC61
LAC67:  ldx     tmp2
        rts

; reg a: value; reg x: start page; reg y: end page (inclusive)
memset_page:
        pha
        txa
        sty     tmp2
        clc
        sbc     tmp2
        tax
        pla
        ldy     #$00
        sty     tmp1
@setByte:
        sta     (tmp1),y
        dey
        bne     @setByte
        dec     tmp2
        inx
        bne     @setByte
        rts

switch_s_plus_2a:
        asl     a
        tay
        iny
        pla
        sta     tmp1
        pla
        sta     tmp2
        lda     (tmp1),y
        tax
        iny
        lda     (tmp1),y
        sta     tmp2
        stx     tmp1
        jmp     (tmp1)

        sei
        inc     initRam
        lda     #$1A
        jsr     setMMC1Control
        rts

        rts

setMMC1Control:
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        rts

changeCHRBank0:
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        rts

changeCHRBank1:
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        rts

changePRGBank:
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        rts

game_palette:
        .byte   $3F,$00,$20,$0F,$30,$12,$16,$0F
        .byte   $20,$12,$18,$0F,$2C,$16,$29,$0F
        .byte   $3C,$00,$30,$0F,$35,$15,$22,$0F
        .byte   $35,$29,$26,$0F,$2C,$16,$29,$0F
        .byte   $3C,$00,$30,$FF
legal_screen_palette:
        .byte   $3F,$00,$10,$0F,$27,$2A,$2B,$0F
        .byte   $3C,$2A,$22,$0F,$27,$2C,$29,$0F
        .byte   $30,$3A,$15,$FF
menu_palette:
        .byte   $3F,$00,$14,$0F,$30,$38,$00,$0F
        .byte   $30,$16,$00,$0F,$30,$21,$00,$0F
        .byte   $16,$2A,$28,$0F,$30,$29,$27,$FF
ending_palette:
        .byte   $3F,$00,$20,$12,$0F,$29,$37,$12
        .byte   $0F,$30,$27,$12,$0F,$17,$27,$12
        .byte   $0F,$15,$37,$12,$0F,$29,$37,$12
        .byte   $0F,$30,$27,$12,$0F,$17,$27,$12
        .byte   $0F,$15,$37,$FF



        ;are the following zeros unused entries for each high score table?
defaultHighScoresTable:
        .byte  "HOWARD" ;$08,$0F,$17,$01,$12,$04
        .byte  "OTASAN" ;$0F,$14,$01,$13,$01,$0E
        .byte  "LANCE " ;$0C,$01,$0E,$03,$05,$2B
        .byte  $00,$00,$00,$00,$00,$00 ;unused fourth name
        .byte  "ALEX  " ;$01,$0C,$05,$18,$2B,$2B
        .byte  "TONY  " ;$14,$0F,$0E,$19,$2B,$2B
        .byte  "NINTEN" ;$0E,$09,$0E,$14,$05,$0E
        .byte   $00,$00,$00,$00,$00,$00 ;unused fourth name
        ;High Scores are stored in BCD
        .byte   $01,$00,$00 ;Game A 1st Entry Score, 10000
        .byte   $00,$75,$00 ;Game A 2nd Entry Score, 7500
        .byte   $00,$50,$00 ;Game A 3rd Entry Score, 5000
        .byte   $00,$00,$00 ;unused fourth score
        .byte   $00,$20,$00 ;Game B 1st Entry Score, 2000
        .byte   $00,$10,$00 ;Game B 2nd Entry Score, 1000
        .byte   $00,$05,$00 ;Game B 3rd Entry Score, 500
        .byte   $00,$00,$00 ;unused fourth score
        .byte   $09 ;Game A 1st Entry Level
        .byte   $05 ;Game A 2nd Entry Level
        .byte   $00 ;Game A 3nd Entry Level
        .byte   $00 ;unused fourth level
        .byte   $09 ;Game B 1st Entry Level
        .byte   $05 ;Game B 2nd Entry Level
        .byte   $00 ;Game B 3rd Entry Level
        .byte   $00 ;unused fourth level
        .byte   $FF

;.segment        "legal_screen_nametable": absolute

legal_screen_nametable:
        .incbin "gfx/nametables/legal_screen_nametable.bin"
title_screen_nametable:
        .incbin "gfx/nametables/title_screen_nametable.bin"
game_type_menu_nametable:
        .incbin "gfx/nametables/game_type_menu_nametable.bin"
level_menu_nametable:
        .incbin "gfx/nametables/level_menu_nametable.bin"
game_nametable:
        .incbin "gfx/nametables/game_nametable.bin"
enter_high_score_nametable:
        .incbin "gfx/nametables/enter_high_score_nametable.bin"
high_scores_nametable:
        .incbin "gfx/nametables/high_scores_nametable.bin"
height_menu_nametablepalette_patch:
        .byte   $3F,$0A,$01,$16,$20,$6D,$01,$0A
        .byte   $20,$F3,$48,$FF,$21,$13,$48,$FF
        .byte   $21,$33,$48,$FF,$21,$53,$47,$FF
        .byte   $21,$73,$47,$FF,$21,$93,$47,$FF
        .byte   $21,$B3,$47,$FF,$21,$D3,$47,$FF
        .byte   $22,$33,$48,$FF,$22,$53,$48,$FF
        .byte   $22,$73,$48,$FF,$22,$93,$47,$FF
        .byte   $22,$B3,$47,$FF,$22,$D3,$47,$FF
        .byte   $22,$F3,$47,$FF,$23,$13,$47,$FF
        .byte   $FF
type_b_lvl9_ending_nametable:
        .incbin "gfx/nametables/type_b_lvl9_ending_nametable.bin"
type_b_ending_nametable:
        .incbin "gfx/nametables/type_b_ending_nametable.bin"
type_a_ending_nametable:
        .incbin "gfx/nametables/type_a_ending_nametable.bin"

; End of "PRG_chunk1" segment
.code


.segment        "unreferenced_data1": absolute

unreferenced_data1:
        .incbin "data/unreferenced_data1.bin"

; End of "unreferenced_data1" segment
.code


.segment        "PRG_chunk2": absolute

.include "data/demo_data.asm"
.include "sound.asm"

; End of "PRG_chunk2" segment
.code


.segment        "unreferenced_data4": absolute

.include "data/unreferenced_data4.asm"

; End of "unreferenced_data4" segment
.code


.segment        "PRG_chunk3": absolute

; incremented to reset MMC1 reg
.include "reset.asm"

.include "data/unreferenced_data5.asm"
MMC1_PRG:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
        .byte   $00

; End of "PRG_chunk3" segment
.code


.segment        "VECTORS": absolute

        .addr   nmi
        .addr   reset
LFFFF           := * + 1
        .addr   irq

; End of "VECTORS" segment
.code
