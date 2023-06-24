
shift_tetrimino:
        lda     tetriminoX
        sta     originalY
        lda     heldButtons
        and     #$04
        bne     @ret
        lda     newlyPressedButtons
        and     #$03
        bne     @resetAutorepeatX
        lda     heldButtons
        and     #$03
        beq     @ret
        inc     autorepeatX
        lda     autorepeatX
        cmp     #$10
        bmi     @ret
        lda     #$0A
        sta     autorepeatX
        jmp     @buttonHeldDown

@resetAutorepeatX:
        lda     #$00
        sta     autorepeatX
@buttonHeldDown:
        lda     heldButtons
        and     #$01
        beq     @notPressingRight
        inc     tetriminoX
        jsr     isPositionValid
        bne     @restoreX
        lda     #$03
        sta     soundEffectSlot1Init
        jmp     @ret

@notPressingRight:
        lda     heldButtons
        and     #$02
        beq     @ret
        dec     tetriminoX
        jsr     isPositionValid
        bne     @restoreX
        lda     #$03
        sta     soundEffectSlot1Init
        jmp     @ret

@restoreX:
        lda     originalY
        sta     tetriminoX
        lda     #$10
        sta     autorepeatX
@ret:   rts