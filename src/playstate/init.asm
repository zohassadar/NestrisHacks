
gameModeState_initGameBackground:
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi


.ifdef CNROM
                ; 85f6
        nop     ; padded out for GG codes & mods
        lda     #CNROM_BANK1
        ldy     #CNROM_BG1
        ldx     #CNROM_SPRITE1
        jsr     changeCHRBank0
        ; 8600
.else
        lda     #$03
        jsr     changeCHRBank0
        lda     #$03
        jsr     changeCHRBank1
.endif

        jsr     bulkCopyToPpu
        .addr   game_palette
.ifdef TRIPLEWIDE
        jsr     initTripleWide
        nop
        nop
.else
        jsr     bulkCopyToPpu
        .addr   game_nametable
.endif
        lda     #$20
        sta     PPUADDR
.ifdef TWELVE
        lda     #$81  ; "A" or "B" 2 tiles to the left
.elseif .defined(TRIPLEWIDE)
        lda     #$43
.else
        lda     #$83
.endif
        sta     PPUADDR
        lda     gameType
        bne     @typeB
        lda     #$0A
        sta     PPUDATA

; any unintended consequences of writing to CHR ROM?
.ifdef TRIPLEWIDE
        lda     #$00
        sta     PPUADDR
        lda     #$00
        sta     PPUADDR
.else
        lda     #$20
        sta     PPUADDR
        lda     #$B8
        sta     PPUADDR
.endif
        lda     highScoreScoresA
        jsr     twoDigsToPPU
        lda     highScoreScoresA+1
        jsr     twoDigsToPPU
        lda     highScoreScoresA+2
        jsr     twoDigsToPPU
.ifdef SPS
        jmp     drawSeedOnBackground
.else
        jmp     gameModeState_initGameBackground_finish
.endif

@typeB: lda     #$0B
        sta     PPUDATA
.ifdef TRIPLEWIDE
        lda     #$00
        sta     PPUADDR
        lda     #$00
        sta     PPUADDR
.else
        lda     #$20
        sta     PPUADDR
        lda     #$B8
        sta     PPUADDR
.endif
        lda     highScoreScoresB
        jsr     twoDigsToPPU
        lda     highScoreScoresB+1
        jsr     twoDigsToPPU
        lda     highScoreScoresB+2
        jsr     twoDigsToPPU
        ldx     #$00
@nextPpuAddress:
        lda     game_typeb_nametable_patch,x
        inx
        sta     PPUADDR
        lda     game_typeb_nametable_patch,x
        inx
        sta     PPUADDR
@nextPpuData:
        lda     game_typeb_nametable_patch,x
        inx
        cmp     #$FE
        beq     @nextPpuAddress
        cmp     #$FD
        beq     @endOfPpuPatching
        sta     PPUDATA
        jmp     @nextPpuData

@endOfPpuPatching:
.ifdef TRIPLEWIDE
        lda     #$20
        sta     PPUADDR
        lda     #$48
        sta     PPUADDR
.else
        lda     #$23
        sta     PPUADDR
        lda     #$3B
        sta     PPUADDR
.endif
        lda     startHeight
        and     #$0F
        sta     PPUDATA
        jmp     gameModeState_initGameBackground_finish

gameModeState_initGameBackground_finish:
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$01
        sta     player1_playState
        sta     player2_playState
        lda     player1_startLevel
        sta     player1_levelNumber
        lda     player2_startLevel
        sta     player2_levelNumber
        inc     gameModeState
        rts

game_typeb_nametable_patch:
        .byte   $22,$F7
.ifdef TRIPLEWIDE
        .byte   $FD  ; skip over this if triplewide
.else
        .byte   $38
.endif
        .byte   $39,$39,$39,$39,$39
        .byte   $39,$3A,$FE,$23,$17,$3B,$11,$0E
        .byte   $12,$10,$11,$1D,$3C,$FE,$23,$37
        .byte   $3B,$FF,$FF,$FF,$FF,$FF,$FF,$3C
        .byte   $FE,$23,$57,$3D,$3E,$3E,$3E,$3E
        .byte   $3E,$3E,$3F,$FD
gameModeState_initGameState:
        lda     #$EF
.ifdef TRIPLEWIDE
        ldx     #$03
        ldy     #$05
.else
        ldx     #$04
.ifdef PLAYFIELD_TOGGLE
        ldy     #$05
.else
        ldy     #$04
.endif
.endif
        jsr     memset_page
.ifdef TRIPLEWIDE
        ldx     #$A0
        lda     #$00
; blank vram render queue
@blankRenderQueue:
        sta     stack-1,x
        dex
        bne     @blankRenderQueue
.else
        ldx     #$0F
        lda     #$00
; statsByType
@initStatsByType:
        sta     statsByType-1,x
        dex
        bne     @initStatsByType
.endif
.ifdef WALLHACK2
        lda     #$08
.else
    .ifdef TWELVE
        lda     #$06
    .elseif .defined(TRIPLEWIDE)
        lda     #$0F
    .else
        lda     #$05
    .endif
.endif
        sta     player1_tetriminoX
.ifdef PLAYFIELD_TOGGLE
        sta     playfieldAddr+1
.else
        sta     player2_tetriminoX
.endif
        lda     #$00
        sta     player1_tetriminoY
        sta     player2_tetriminoY
.ifdef TWELVE
        lda     #$13
        sta     player1_vramRow
        lda     #$00
        sta     player1_fallTimer
.else
        sta     player1_vramRow
        sta     player2_vramRow
        sta     player1_fallTimer
        sta     player2_fallTimer
.endif
        sta     pendingGarbage
        sta     pendingGarbageInactivePlayer
        sta     player1_score
        sta     player1_score+1
        sta     player1_score+2
        sta     player2_score
        sta     player2_score+1
        sta     player2_score+2
        sta     player1_lines
        sta     player1_lines+1
        sta     player2_lines
        sta     player2_lines+1
        sta     twoPlayerPieceDelayCounter
        sta     lineClearStatsByType
        sta     lineClearStatsByType+1
        sta     lineClearStatsByType+2
        sta     lineClearStatsByType+3
        sta     allegro
        sta     demo_heldButtons
        sta     demo_repeats
        sta     demoIndex
        sta     demoButtonsAddr
        sta     spawnID
        lda     #>demoButtonsTable
        sta     demoButtonsAddr+1
        lda     #$03
        sta     renderMode
        lda     #$A0
        sta     player1_autorepeatY
        sta     player2_autorepeatY
.ifdef SPS
        jsr     resetSetSeedandChooseNextTetrimino
.elseif .defined(RANDO)
        jsr     chooseNextAndRandomizeOrientation
.else
        jsr     chooseNextTetrimino
.endif
        sta     player1_currentPiece
        sta     player2_currentPiece
        jsr     incrementPieceStat
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
.ifdef RANDO
        jsr     chooseNextAndRandomizeOrientation
.else
.ifdef SOMETIMES_WRONG_NEXTBOX
        jsr     pickNextAndPossiblyDisplayWrongNext
.else
        jsr     chooseNextTetrimino
.endif

.endif
        sta     nextPiece
        sta     twoPlayerPieceDelayPiece
        lda     gameType
        beq     @skipTypeBInit
.ifdef B_TYPE_DEBUG
        lda     #$00
.else
        lda     #$25
.endif
        sta     player1_lines
        sta     player2_lines
@skipTypeBInit:
        lda     #$47
        sta     outOfDateRenderFlags
        jsr     updateAudioWaitForNmiAndResetOamStaging
.ifdef SPS
        jsr     resetBSeed
.else
.ifndef TRIPLEWIDE
        jsr     initPlayfieldIfTypeB
.else
        jsr     initTripleWideTypeB
.endif
.endif
        ldx     musicType
        lda     musicSelectionTable,x
        jsr     setMusicTrack
        inc     gameModeState
        rts

; Copies $60 to $40
makePlayer1Active:
        lda     #$01
        sta     activePlayer
.ifdef PLAYFIELD_TOGGLE
        lda     playfieldAddr+1
.else
        lda     #$04
.endif
        sta     playfieldAddr+1
        lda     newlyPressedButtons_player1
        sta     newlyPressedButtons
        lda     heldButtons_player1
        sta     heldButtons
        ldx     #$1F
@copyByteFromMirror:
        lda     player1_tetriminoX,x
        sta     tetriminoX,x
        dex
        cpx     #$FF
        bne     @copyByteFromMirror
.ifdef HALF
        ldx     tetriminoY
        cpx     unused_0E
        beq     @dontToggleDropSpeed
        lda     dropSpeed
        eor     #$02
        sta     dropSpeed
@dontToggleDropSpeed:
        stx     unused_0E
makePlayer2Active:
        rts
.else
        rts
; Copies $80 to $40
makePlayer2Active:
        lda     #$02
        sta     activePlayer
.ifdef PLAYFIELD_TOGGLE
        lda     playfieldAddr+1
.else
        lda     #$05
.endif
        sta     playfieldAddr+1
        lda     newlyPressedButtons_player2
        sta     newlyPressedButtons
        lda     heldButtons_player2
.endif
        sta     heldButtons
        ldx     #$1F
@whileXNotNeg1:
        lda     player2_tetriminoX,x
        sta     tetriminoX,x
        dex
        cpx     #$FF
        bne     @whileXNotNeg1
        rts

; Copies $40 to $60
savePlayer1State:
        ldx     #$1F
@copyByteToMirror:
        lda     tetriminoX,x
        sta     player1_tetriminoX,x
        dex
        cpx     #$FF
        bne     @copyByteToMirror
        lda     numberOfPlayers
        cmp     #$01
        beq     @ret
        ldx     pendingGarbage
        lda     pendingGarbageInactivePlayer
        sta     pendingGarbage
        stx     pendingGarbageInactivePlayer
@ret:   rts

; Copies $40 to $80
savePlayer2State:
        ldx     #$1F
@whileXNotNeg1:
        lda     tetriminoX,x
        sta     player2_tetriminoX,x
        dex
        cpx     #$FF
        bne     @whileXNotNeg1
        ldx     pendingGarbage
        lda     pendingGarbageInactivePlayer
        sta     pendingGarbage
        stx     pendingGarbageInactivePlayer
        rts

initPlayfieldIfTypeB:
        lda     gameType
.ifdef SPS
        bpl     initPlayfieldForTypeB
.else
        bne     initPlayfieldForTypeB
.endif
        jmp     endTypeBInit

initPlayfieldForTypeB:
        lda     #$0C
        sta     generalCounter  ; decrements

typeBRows:
        lda     generalCounter
        beq     initCopyPlayfieldToPlayer2
.ifdef TALLER
        lda     #$18
.elseif .defined(TRIPLEWIDE)
        lda     #$19
.else
        lda     #$14
.endif
        sec
        sbc     generalCounter
        sta     generalCounter2  ; row (20 - generalCounter)
        lda     #$00
        sta     player1_vramRow
        sta     player2_vramRow
.ifdef TWELVE
        lda     #$0B
.else
        lda     #$09
.endif
        sta     generalCounter3 ; column

typeBGarbageInRow:
.ifdef SPS
        ldx     bSeedSource
.else
        ldx     #$17
.endif
        ldy     #$02
.ifdef SPS
        jsr     generateNextPseudoAndAlsoCopy
        lda     bseedCopy
.else
        jsr     generateNextPseudorandomNumber
        lda     rng_seed
.endif
        and     #$07
        tay
        lda     rngTable,y
        sta     generalCounter4 ; random square or blank
        ldx     generalCounter2
.ifdef TWELVE
        lda     multBy12Table,x
.else
        lda     multBy10Table,x
.endif
        clc
        adc     generalCounter3
        tay
        lda     generalCounter4
.ifndef TRIPLEWIDE
        sta     playfield,y
.else
        sta     (playfieldAddr),y
        nop
.endif
        lda     generalCounter3
        beq     typeBGuaranteeBlank
        dec     generalCounter3
        jmp     typeBGarbageInRow

typeBGuaranteeBlank:
.ifdef SPS
        ldx     bSeedSource
.else
        ldx     #$17
.endif
        ldy     #$02
.ifdef SPS
        jsr     generateNextPseudoAndAlsoCopy
        lda     bseedCopy
.else
        jsr     generateNextPseudorandomNumber
        lda     rng_seed
.endif
        and     #$0F
.ifdef TWELVE
        cmp     #$0C
.else
        cmp     #$0A
.endif
        bpl     typeBGuaranteeBlank

        sta     generalCounter5 ; blanked column
        ldx     generalCounter2
.ifdef TWELVE
        lda     multBy12Table,x
.else
        lda     multBy10Table,x
.endif
        clc
        adc     generalCounter5
        tay
        lda     #$EF
.ifndef TRIPLEWIDE
        sta     playfield,y
.else
        sta     (playfieldAddr),y
        nop
.endif
        .ifndef TRIPLEWIDE
        jsr     updateAudioWaitForNmiAndResetOamStaging
        .else
        nop
        nop
        nop
        .endif
        dec     generalCounter
        bne     typeBRows

initCopyPlayfieldToPlayer2:
.ifndef TRIPLEWIDE
        ldx     #$C8
copyPlayfieldToPlayer2:
        lda     playfield,x
        sta     playfieldForSecondPlayer,x
        dex
        bne     copyPlayfieldToPlayer2
.else
.repeat 11
        nop
.endrepeat
.endif


; Player1 Blank Lines
        ldx     player1_startHeight
        lda     typeBBlankInitCountByHeightTable,x
        tay
        lda     #$EF

typeBBlankInitPlayer1:
.ifndef TRIPLEWIDE
        sta     playfield,y
.else
        sta     (playfieldAddr),y
        nop
.endif
        dey
        cpy     #$FF
        bne     typeBBlankInitPlayer1

; Player2 Blank Lines
.ifndef TRIPLEWIDE
        ldx     player2_startHeight
        lda     typeBBlankInitCountByHeightTable,x
        tay
        lda     #$EF
typeBBlankInitPlayer2:
        sta     playfieldForSecondPlayer,y
        dey
        cpy     #$FF
        bne     typeBBlankInitPlayer2
.else
.repeat 16
        nop
.endrepeat
.endif
endTypeBInit:
        rts

typeBBlankInitCountByHeightTable:
.ifdef TALLER
        .byte   $F0,$D2,$BE,$A0,$8C,$78
.else
    .ifdef TWELVE
        .byte   $F0,$CC,$B4,$90,$78,$60
    .elseif .defined(TRIPLEWIDE)
        .byte   $fa,$dc,$c8,$aa,$96,$82
    .else
        .byte   $C8,$AA,$96,$78,$64,$50
    .endif
.endif
rngTable:
        .byte   $EF,$7B,$EF,$7C,$7D,$7D,$EF
        .byte   $EF
