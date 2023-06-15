
drop_tetrimino:
        lda     autorepeatY
        bpl     @notBeginningOfGame
        lda     newlyPressedButtons
        and     #$04
        beq     @incrementAutorepeatY
        lda     #$00
        sta     autorepeatY
@notBeginningOfGame:
        bne     @autorepeating
@playing:
        lda     heldButtons
        and     #$03
        bne     @lookupDropSpeed
        lda     newlyPressedButtons
        and     #$0F
        cmp     #$04
        bne     @lookupDropSpeed
        lda     #$01
        sta     autorepeatY
        jmp     @lookupDropSpeed

@autorepeating:
        lda     heldButtons
        and     #$0F
        cmp     #$04
        beq     @downPressed
        lda     #$00
        sta     autorepeatY
        sta     holdDownPoints
        jmp     @lookupDropSpeed

@downPressed:
        inc     autorepeatY
        lda     autorepeatY
        cmp     #$03
        bcc     @lookupDropSpeed
        lda     #$01
        sta     autorepeatY
        inc     holdDownPoints
@drop:  lda     #$00
        sta     fallTimer
        lda     tetriminoY
        sta     originalY
        inc     tetriminoY
        jsr     isPositionValid
        beq     @ret
        lda     originalY
        sta     tetriminoY
        lda     #$02
        sta     playState
        jsr     updatePlayfield
@ret:   rts

@lookupDropSpeed:
        lda     #$01
        ldx     levelNumber
        cpx     #$1D
        bcs     @noTableLookup
        lda     framesPerDropTable,x
@noTableLookup:
        sta     dropSpeed
        lda     fallTimer
        cmp     dropSpeed
        bpl     @drop
        jmp     @ret

@incrementAutorepeatY:
        inc     autorepeatY
        jmp     @ret

framesPerDropTable:
        .byte   $30,$2B,$26,$21,$1C,$17,$12,$0D
        .byte   $08,$06,$05,$05,$05,$04,$04,$04
        .byte   $03,$03,$03,$02,$02,$02,$02,$02
        .byte   $02,$02,$02,$02,$02,$01
unreferenced_framesPerDropTable:
        .byte   $01,$01