
playState_spawnNextTetrimino:
        lda     vramRow
        cmp     #$20
        bmi     @ret
        lda     numberOfPlayers
        cmp     #$01
        beq     @spawnPiece
        lda     twoPlayerPieceDelayCounter
        cmp     #$00
        bne     @twoPlayerWaiting
        inc     twoPlayerPieceDelayCounter
        lda     activePlayer
        sta     twoPlayerPieceDelayPlayer
        jsr     chooseNextTetrimino
        sta     twoPlayerPieceDelayPiece
        jmp     @ret

@twoPlayerWaiting:
        lda     twoPlayerPieceDelayPlayer
        cmp     activePlayer
        bne     @ret
        lda     twoPlayerPieceDelayCounter
        cmp     #$1C
        bne     @ret
@spawnPiece:
        lda     #$00
        sta     twoPlayerPieceDelayCounter
        sta     fallTimer
        sta     tetriminoY
        lda     #$01
        sta     playState
        lda     #$05
        sta     tetriminoX
        ldx     nextPiece
        lda     spawnOrientationFromOrientation,x
        sta     currentPiece
        jsr     incrementPieceStat
        lda     numberOfPlayers
        cmp     #$01
        beq     @onePlayerPieceSelection
        lda     twoPlayerPieceDelayPiece
        sta     nextPiece
        jmp     @resetDownHold

@onePlayerPieceSelection:
        jsr     chooseNextTetrimino
        sta     nextPiece
@resetDownHold:
        lda     #$00
        sta     autorepeatY
@ret:   rts

chooseNextTetrimino:
        lda     gameMode
        cmp     #$05
        bne     pickRandomTetrimino
        ldx     demoIndex
        inc     demoIndex
        lda     demoTetriminoTypeTable,x
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        and     #$07
        tax
        lda     spawnTable,x
        rts

pickRandomTetrimino:
        jsr     @realStart
        rts

@realStart:
        inc     spawnCount
        lda     rng_seed
        clc
        adc     spawnCount
        and     #$07
        cmp     #$07
        beq     @invalidIndex
        tax
        lda     spawnTable,x
        cmp     spawnID
        bne     useNewSpawnID
@invalidIndex:
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        lda     rng_seed
        and     #$07
        clc
        adc     spawnID
L992A:  cmp     #$07
        bcc     L9934
        sec
        sbc     #$07
        jmp     L992A

L9934:  tax
        lda     spawnTable,x
useNewSpawnID:
        sta     spawnID
        rts

tetriminoTypeFromOrientation:
        .byte   $00,$00,$00,$00,$01,$01,$01,$01
        .byte   $02,$02,$03,$04,$04,$05,$05,$05
        .byte   $05,$06,$06
spawnTable:
        .byte   $02,$07,$08,$0A,$0B,$0E,$12
        .byte   $02
spawnOrientationFromOrientation:
        .byte   $02,$02,$02,$02,$07,$07,$07,$07
        .byte   $08,$08,$0A,$0B,$0B,$0E,$0E,$0E
        .byte   $0E,$12,$12
incrementPieceStat:
        tax
        lda     tetriminoTypeFromOrientation,x
        asl     a
        tax
        lda     statsByType,x
        clc
        adc     #$01
        sta     generalCounter
        and     #$0F
        cmp     #$0A
        bmi     L9996
        lda     generalCounter
        clc
        adc     #$06
        sta     generalCounter
        cmp     #$A0
        bcc     L9996
        clc
        adc     #$60
        sta     generalCounter
        lda     statsByType+1,x
        clc
        adc     #$01
        sta     statsByType+1,x
L9996:  lda     generalCounter
        sta     statsByType,x
        lda     outOfDateRenderFlags
        ora     #$40
        sta     outOfDateRenderFlags
        rts