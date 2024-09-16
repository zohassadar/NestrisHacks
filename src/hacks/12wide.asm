

isPositionValid:
.ifdef WALLHACK2
        jmp     @skipOverWallhack2Padding
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00
@skipOverWallhack2Padding:
        ldy     currentPiece
        ldx     multBy12Table,y
        lda     #$04
        sta     generalCounter3
; Checks one square within the tetrimino
@checkSquare:
        lda     orientationTable,x
        clc
        adc     tetriminoY
        tay
        clc
        adc     #$02
        cmp     #$16
        bcs     @invalid
        tya
        asl
        sta     generalCounter4
        asl
        asl
        clc
        adc     generalCounter4
        sta     generalCounter4
        inx
        inx
        lda     tetriminoX
        clc
        adc     orientationTable,x
        tay
        lda     effectiveTetriminoXTable,y
        lda     generalCounter4
        clc
        adc     effectiveTetriminoXTable,y
        tay
        lda     playfield,y
        bpl     @invalid
.else
        lda     tetriminoY
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        clc                      ; mod
        adc     generalCounter   ; mod
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
; Checks one square within the tetrimino
@checkSquare:

    ; reset check to zero
        lda    #$00
        sta    topRowValidityCheck

        lda     orientationTable,x
        clc
        adc     tetriminoY
; modified start
        tay
; Set 1 if tetriminoY with offset is negative -1 or negative -2
        cmp     #$FE
        bcc     @yOffsetIsNotNegative

        lda     topRowValidityCheck
        ora     #$01
        sta     topRowValidityCheck
        @yOffsetIsNotNegative:
        tya
        clc
; modified end
        adc     #$02
.ifdef TALLER
        cmp     #$1A
.else
        cmp     #$16
.endif
        bcs     @invalid
        lda     orientationTable,x
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        clc
        adc     generalCounter4
        clc                     ; mod
        adc     generalCounter4 ; mod
        clc
        adc     generalCounter
        sta     selectingLevelOrHeight
        inx
        inx
        lda     orientationTable,x
        clc
        adc     selectingLevelOrHeight
        tay
        lda     (playfieldAddr),y
        cmp     #$EF
        ; bcc     @invalid          ; mod
        bcc     @invalidByCollision ; mod
@possiblyNotInvalid:                ; mod
        lda     orientationTable,x
        clc
        adc     tetriminoX
        cmp     #$0C                ; mod
        bcs     @invalid
.endif
        inx
        dec     generalCounter3
        bne     @checkSquare
        lda     #$00
        sta     generalCounter
        rts

@invalidByCollision:
        ; Set 2 if invalid due to collision (x is between 0 and 29 and Y is negative)
        lda     topRowValidityCheck
        ora     #$02
        cmp     #$03
        beq     @possiblyNotInvalid

@invalid:
        lda     #$FF
        sta     generalCounter
        rts

playState_lockTetrimino:
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
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        clc                     ; mod
        adc     generalCounter  ; mod
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
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        clc
        adc     generalCounter4
        clc                         ; mod
        adc     generalCounter4     ; mod
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


multBy12Table:
        .byte   $00,$0C,$18,$24,$30,$3C,$48,$54
        .byte   $60,$6C,$78,$84,$90,$9C,$A8,$B4
        .byte   $C0,$CC,$D8,$E4

leftColumns:
        .byte   $05,$04,$03,$02,$01,$00
rightColumns:
        .byte   $06,$07,$08,$09,$0A,$0B

playState_checkForCompletedRows:
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
        asl     a
        sta     generalCounter
        asl     a
        asl     a
        clc
        adc     generalCounter
        clc                         ; mod
        adc     generalCounter      ; mod
        sta     generalCounter
        tay
        ldx     #$0C   ; mod
@checkIfRowComplete:
        lda     (playfieldAddr),y
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
        lda     (playfieldAddr),y
        ldx     #$0C                    ; mod
        stx     playfieldAddr
        sta     (playfieldAddr),y
        lda     #$00
        sta     playfieldAddr
        dey
        cpy     #$FF
        bne     @movePlayfieldDownOneRow
        lda     #$EF
        ldy     #$00
@clearRowTopRow:
        sta     (playfieldAddr),y
        iny
        cpy     #$0C                    ; mod
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
