

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
