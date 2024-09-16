
playState_receiveGarbage:
        lda     numberOfPlayers
        cmp     #$01
        beq     @ret
        ldy     pendingGarbage
        beq     @ret
        lda     vramRow
        cmp     #$20
        bmi     @delay
.ifdef TWELVE
        lda     multBy12Table,y
.else
        lda     multBy10Table,y
.endif
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
