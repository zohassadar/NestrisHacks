

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

; condition for next next piece based on controller input
    ldx bigChance
    cpx #$04
    beq @nextBig

    lda controllerEntropy
    cmp bigChanceTable,x
    bcs @nextNotBig

@nextBig:
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
        .byte $00,$30,$70,$B0 ; 4th index never used

; a bit faster than memset_page to give breathing room to 0arr
customOAMClear:
        lda #$FF
        sta oamStaging+0
        sta oamStaging+4
        sta oamStaging+8
        sta oamStaging+12
        sta oamStaging+16
        sta oamStaging+20
        sta oamStaging+24
        sta oamStaging+28
        sta oamStaging+32
        sta oamStaging+36
        sta oamStaging+40
        sta oamStaging+44
        sta oamStaging+48
        sta oamStaging+52
        sta oamStaging+56
        sta oamStaging+60
        sta oamStaging+64
        sta oamStaging+68
        sta oamStaging+72
        sta oamStaging+76
        sta oamStaging+80
        sta oamStaging+84
        sta oamStaging+88
        sta oamStaging+92
        sta oamStaging+96
        sta oamStaging+100
        sta oamStaging+104
        sta oamStaging+108
        sta oamStaging+112
        sta oamStaging+116
        sta oamStaging+120
        sta oamStaging+124
        sta oamStaging+128
        sta oamStaging+132
        sta oamStaging+136
        sta oamStaging+140
        sta oamStaging+144
        sta oamStaging+148
        sta oamStaging+152
        sta oamStaging+156
        sta oamStaging+160
        sta oamStaging+164
        sta oamStaging+168
        sta oamStaging+172
        sta oamStaging+176
        sta oamStaging+180
        sta oamStaging+184
        sta oamStaging+188
        sta oamStaging+192
        sta oamStaging+196
        sta oamStaging+200
        sta oamStaging+204
        sta oamStaging+208
        sta oamStaging+212
        sta oamStaging+216
        sta oamStaging+220
        sta oamStaging+224
        sta oamStaging+228
        sta oamStaging+232
        sta oamStaging+236
        sta oamStaging+240
        sta oamStaging+244
        sta oamStaging+248
        sta oamStaging+252
        rts



copyHighScoresToSram:
        ldx #0
@copyHighScores:
        lda highScores,x
        sta sramHighScores,x
        inx
        cpx #HIGHSCORES_LENGTH
        bne @copyHighScores
        rts

longerByteToBCDTable: ; original goes to 49
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23
        .byte   $24,$25,$26,$27,$28,$29,$30,$31
        .byte   $32,$33,$34,$35,$36,$37,$38,$39
        .byte   $40,$41,$42,$43,$44,$45,$46,$47
        .byte   $48,$49
        ; 50 extra bytes is shorter than a conversion routine (and super fast)
        ; (used in renderByteBCD)
        .byte   $50,$51,$52,$53,$54,$55,$56,$57
        .byte   $58,$59,$60,$61,$62,$63,$64,$65
        .byte   $66,$67,$68,$69,$70,$71,$72,$73
        .byte   $74,$75,$76,$77,$78,$79,$80,$81
        .byte   $82,$83,$84,$85,$86,$87,$88,$89
        .byte   $90,$91,$92,$93,$94,$95,$96,$97
        .byte   $98,$99
