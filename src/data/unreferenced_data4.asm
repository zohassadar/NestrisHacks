unreferenced_data4:

.ifdef SOMETIMES_WRONG_NEXTBOX
pickNextAndPossiblyDisplayWrongNext:
        jsr chooseNextTetrimino
        sta nextPiece
        lda rng_seed
        and #$07
        bne @showCorrectPiece
        lda rng_seed
        pha
        lda rng_seed+1
        pha
        lda frameCounter
        and #$0F
        clc
        adc #$01
        sta generalCounter
@rollLoop:
        ldx #$17
        ldy #$02
        jsr generateNextPseudorandomNumber
        dec generalCounter
        bne @rollLoop
        jsr chooseNextTetrimino
        sta displayedNextPiece
        pla
        sta rng_seed+1
        pla
        sta rng_seed
        jmp @putRealNextInA
@showCorrectPiece:
        lda nextPiece
        sta displayedNextPiece
@putRealNextInA:
        lda nextPiece
        rts
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$FF
.else
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FD,$FE,$F7,$FF,$FF,$BF,$FF,$DF
        .byte   $FF,$FF,$BF,$FF,$FF,$FF,$FD,$DF
        .byte   $FF,$BF,$FF,$FF,$FF,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
.endif

.ifdef WARP7
warp7ButtonHeldDown:
        lda     #$07
        sta     generalCounter5
        lda     heldButtons
.ifdef UPSIDEDOWN
        and     #BUTTON_LEFT
.else           
        and     #BUTTON_RIGHT                      
.endif
        beq     rightNotPressed                      
rightLoop:
        lda     tetriminoX
        sta     tmp3
        inc     tetriminoX
.ifdef WALLHACK2
        jsr     testRightShiftAndValidate
.else
        jsr     isPositionValid                 
.endif
        bne     restoreTetriminoX                           
        lda     #$03                      
        sta     soundEffectSlot1Init
        dec     generalCounter5
        bne     rightLoop
        jmp     resetAutorepeatX
rightNotPressed:
        lda     heldButtons                     
.ifdef UPSIDEDOWN
        and     #BUTTON_RIGHT                      
.else           
        and     #BUTTON_LEFT
.endif                 
        beq     leftNotPressed                           
leftLoop:
        lda     tetriminoX
        sta     tmp3
        dec     tetriminoX                      
.ifdef WALLHACK2
        jsr     testLeftShiftAndValidate
.else
        jsr     isPositionValid                 
.endif               
        bne     restoreTetriminoX                      
        lda     #$03                            
        sta     soundEffectSlot1Init            
        dec     generalCounter5
        bne     leftLoop
        jmp     resetAutorepeatX
restoreTetriminoX:
        lda     tmp3
        sta     tetriminoX
resetAutorepeatX:            
.ifdef ANYDAS
        lda     #$01
.else
        lda     #$10
.endif                       
        sta     autorepeatX                     
leftNotPressed:
        rts                                     
        nop
        nop
        nop
        nop
        nop
        nop
.else
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$FF,$BF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00
        .byte   $00
.endif