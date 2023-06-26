
shift_tetrimino:
        lda     tetriminoX
        sta     originalY
        lda     heldButtons
        and     #BUTTON_DOWN
        bne     @ret
        lda     newlyPressedButtons
        and     #BUTTON_RIGHT+BUTTON_LEFT
        bne     @resetAutorepeatX
        lda     heldButtons
        and     #BUTTON_RIGHT+BUTTON_LEFT
        beq     @ret
.ifdef ANYDAS
        dec     autorepeatX
        lda     autorepeatX
        cmp     #$01
        bpl     @ret
        lda     anydasARRValue
        sta     autorepeatX
.ifdef WARP7
        jmp     warp7ButtonHeldDown
.else
        jmp     @buttonHeldDown
.endif
@resetAutorepeatX:
        lda     anydasDASValue
.else
        inc     autorepeatX
        lda     autorepeatX
        cmp     #$10
        bmi     @ret
        lda     #$0A
        sta     autorepeatX
.ifdef WARP7
        jmp     warp7ButtonHeldDown
.else
        jmp     @buttonHeldDown
.endif

@resetAutorepeatX:
        lda     #$00
.endif
        sta     autorepeatX
@buttonHeldDown:
        lda     heldButtons
.ifdef UPSIDEDOWN
        and     #BUTTON_LEFT
.else           
        and     #BUTTON_RIGHT
.endif
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
.ifdef UPSIDEDOWN
        and     #BUTTON_RIGHT
.else           
        and     #BUTTON_LEFT
.endif     
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