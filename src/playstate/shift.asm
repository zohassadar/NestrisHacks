
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
.ifdef ANYDAS
        dec     autorepeatX
        lda     autorepeatX
        cmp     #$01
        bpl     @ret
        lda     anydasARRValue
        sta     autorepeatX
        jmp     @buttonHeldDown
@resetAutorepeatX:
        lda     anydasDASValue
.else
        inc     autorepeatX
        lda     autorepeatX
        cmp     #$10
        bmi     @ret
        lda     #$0A
        sta     autorepeatX
        jmp     @buttonHeldDown

@resetAutorepeatX:
        lda     #$00
.endif
        sta     autorepeatX
@buttonHeldDown:
        lda     heldButtons
        and     #$01
        beq     @notPressingRight
        inc     tetriminoX
.ifdef WALLHACK2
        jsr     testRightShiftAndValidate
.else
        jsr     isPositionValid
.endif
        bne     @restoreX
        lda     #$03
        sta     soundEffectSlot1Init
        jmp     @ret

@notPressingRight:
        lda     heldButtons
        and     #$02
        beq     @ret
        dec     tetriminoX
.ifdef WALLHACK2
        jsr     testLeftShiftAndValidate
.else
        jsr     isPositionValid
.endif
        bne     @restoreX
        lda     #$03
        sta     soundEffectSlot1Init
        jmp     @ret

@restoreX:
        lda     originalY
        sta     tetriminoX
.ifdef ANYDAS
        lda     #$01
.else
        lda     #$10
.endif
        sta     autorepeatX
@ret:   rts