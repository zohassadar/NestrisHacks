

setupBackups:
    lda tetriminoX
    sta backupX
    lda tetriminoY
    sta backupY
    lda currentPiece
    sta backupPiece
    asl
    asl
    sta generalCounter
    asl
    adc generalCounter ; carry already clear
    sta orientIndex
    tax
    lda orientationTable+1,x
    sta currentTile
    lda orientationTable,x
    asl
    clc
    adc backupY
    sta tetriminoY
    lda orientationTable+2,x
    asl
    clc
    adc backupX
    sta tetriminoX
    lda #$A
    sta currentPiece
    rts

setSecond:
    ldx orientIndex
    lda orientationTable+3,x
    asl
    clc
    adc backupY
    sta tetriminoY
    lda orientationTable+5,x
    asl
    clc
    adc backupX
    sta tetriminoX
    rts

setThird:
    ldx orientIndex
    lda orientationTable+6,x
    asl
    clc
    adc backupY
    sta tetriminoY
    lda orientationTable+8,x
    asl
    clc
    adc backupX
    sta tetriminoX
    rts

setFourth:
    ldx orientIndex
    lda orientationTable+9,x
    asl
    clc
    adc backupY
    sta tetriminoY
    lda orientationTable+11,x
    asl
    clc
    adc backupX
    sta tetriminoX
    rts

restoreBackups:
    ; php/plp for isPositionValid flags
    php
    lda backupY
    sta tetriminoY
    lda backupX
    sta tetriminoX
    lda backupPiece
    sta currentPiece
    plp
    rts

bigOrRegularLockCheck:
    lda bigFlag
    bne @big
    jsr actualLock
    jmp @endLock
@big:
    jsr setupBackups
    jsr actualLock
    jsr setSecond
    jsr actualLock
    jsr setThird
    jsr actualLock
    jsr setFourth
    jsr actualLock
@endLock:
    lda #$00
    sta lineIndex
    jsr updatePlayfield
    jsr updateMusicSpeed
    inc playState
    jmp restoreBackups

stageSpriteForCurrentPiece:
    lda bigFlag
    bne @big

; very inefficient but will do for now to make sure currentTile is properly set
    jsr setupBackups
    jsr restoreBackups

    jmp stageSpriteForCurrentPieceActual
@big:
    ;lda currentPiece
    ;cmp #$13
    ;beq @hidden
    jsr setupBackups
    jsr stageSpriteForCurrentPieceActual
    jsr setSecond
    jsr stageSpriteForCurrentPieceActual
    jsr setThird
    jsr stageSpriteForCurrentPieceActual
    jsr setFourth
;@hidden:
    jsr stageSpriteForCurrentPieceActual
    jmp restoreBackups


isPositionValid:
    lda bigFlag
    bne @big
    jmp isPositionValidActual
@big:
    jsr setupBackups
    jsr isPositionValidActual
    bne @ret
    jsr setSecond
    jsr isPositionValidActual
    bne @ret
    jsr setThird
    jsr isPositionValidActual
    bne @ret
    jsr setFourth
    jsr isPositionValidActual
@ret:
    jmp restoreBackups



chooseNextTetrimino:

; move flag over
    lda nextBigFlag
    sta bigFlag

; default not big for next piece
    lda #$00
    sta nextBigFlag
    lda #<orientationToSpriteTableRegular
    sta orientationToSpriteTable
    lda #>orientationToSpriteTableRegular
    sta orientationToSpriteTable+1

; condition for next next piece
    ldx bigChance
    lda rng_seed+1
    eor frameCounter
    eor spawnCount
    lsr
    lsr   ; shift right to ignore line clear animation framerule
    and #$0F
    cmp bigChanceTable,x
    bcs @nextNotBig

; big vars for next piece
    lda #$80 ; use negative flag so bit can be used
    sta nextBigFlag
    lda #<orientationToSpriteTableBig
    sta orientationToSpriteTable
    lda #>orientationToSpriteTableBig
    sta orientationToSpriteTable+1

@nextNotBig:

; default for current piece
    lda #$04
    sta tetrisSound
    lda #<pointsTableRegular
    sta pointsTable
    lda #>pointsTableRegular
    sta pointsTable+1

; check flag
    lda bigFlag
    beq @notBig

; big vars for current piece
    lda #$08
    sta tetrisSound
    lda #$10
    sta tetriminoX
    sta player1_tetriminoX
    lda #<pointsTableBig
    sta pointsTable
    lda #>pointsTableBig
    sta pointsTable+1

@notBig:
    jmp chooseNextTetriminoActual


draw_big_chance_then_finish:
    lda #$20
    sta PPUADDR
    lda #$41
    sta PPUADDR
    lda bigChance
    sta PPUDATA
    jmp gameModeState_initGameBackground_finish

pointsTableRegular:
        .word   $0000,$0040,$0100,$0300
        .word   $1200

pointsTableBig:
        .word   $0000,$0020,$0050,$0150
        .word   $0600,$1200,$2000,$3000
        .word   $6000

bigChanceTable:
        ; theoretically 0/16, 3/16, 7/16, 11/16 & 16/16 (can guarantee the first and last!)
        .byte $00,$03,$07,$0B,$10
