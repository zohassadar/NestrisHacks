playState_checkForCompletedRows:
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
        tax                       
        lda     slightlyBiggerMultBy10Table,x   
        sta     generalCounter
        tay
        ldx     #$0A
@checkIfRowComplete:
        lda     playfield,y   
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
        lda     playfield,y 
        sta     playfield+10,y
        dey
        cpy     #$FF
        bne     @movePlayfieldDownOneRow
        lda     #$EF
        ldy     #$00
@clearRowTopRow:
        sta     playfield,y  
        iny
        cpy     #$0A
        bne     @clearRowTopRow
        lda     #$13
        sta     currentPiece
        bne     @incrementLineIndex
@rowNotComplete:
        ldx     lineIndex
        lda     #$00
        sta     completedRow,x
@incrementLineIndex:
        inc     lineIndex
        lda     lineIndex
        cmp     #$04
        bmi     @updatePlayfieldComplete
        lda     #$00
        sta     vramRow
        sta     rowY
        lda     #$04
        cmp     completedLines              
        bne     @skipTetrisSoundEffect
        sta     soundEffectSlot1Init
@skipTetrisSoundEffect:
        inc     playState
        lda     completedLines
        bne     @ret
        inc     playState
        lda     #$07
        sta     soundEffectSlot1Init
@ret:   rts

gameModeState_updatePlayer1:
        jsr     makePlayer1Active
        jsr     branchOnPlayStatePlayer1
        lda     playState
        cmp     #$02
        bne     @skipAhead1
        jsr     branchOnPlayStatePlayer1
        jsr     branchOnPlayStatePlayer1
@skipAhead1:
        lda     playState
        cmp     #$06
        beq     @skipAhead2
        lda     playState
        cmp     #$05
        bne     @skipAhead3
        jsr     branchOnPlayStatePlayer1
@skipAhead2:
        jsr     branchOnPlayStatePlayer1
        jsr     branchOnPlayStatePlayer1
        jsr     branchOnPlayStatePlayer1
@skipAhead3:
        jsr     stageSpriteForCurrentPiece
        jsr     savePlayer1State
        jsr     stageSpriteForNextPiece
        inc     gameModeState
        rts

slightlyBiggerMultBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE,$C8

stageCurrentPieceForPPU:
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter
        asl     a
        adc     generalCounter
        tax ; x contains index into orientation table
        lda     #$04
        sta     generalCounter2 ; iterate through all four minos
@stageMino:
        lda     tetriminoX
        clc
        adc     orientationTable+2,x
        sta     generalCounter
        lda     tetriminoY
        clc
        adc     orientationTable,x
        asl
        tay
        bmi     @negativeRow
        lda     vramPlayfieldRows+1,y
        bne     @pastNegative
@negativeRow:
        lda     #$00
@pastNegative:
        pha
        lda     vramPlayfieldRows,y
        clc
        adc     generalCounter
        adc     #$06
        pha
        lda     orientationTable+1,x
        pha
        inx
        inx
        inx
        dec     generalCounter2
        bne     @stageMino
        ldx     #$0B
@popAndPush:
        pla
        sta     minimalAreStaging,x
        dex
        bpl     @popAndPush
        inc     minimalAreToggle
        rts

render_locked_piece:
        lda     minimalAreToggle
        beq     @ret
        ldx     #$00
@pieceRenderLoop:
        lda     minimalAreStaging,x
        beq     @noRender
        sta     PPUADDR
        lda     minimalAreStaging+1,x
        sta     PPUADDR
        lda     minimalAreStaging+2,x
        sta     PPUDATA
@noRender:
        inx
        inx
        inx
        cpx     #$0C
        bne     @pieceRenderLoop
@ret:   
        lda     #$00
        sta     minimalAreToggle
        rts

render_piece_then_render_mode_play_and_demo:
        jsr   render_locked_piece
        jmp   render_mode_play_and_demo
