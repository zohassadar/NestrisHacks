
pollController_actualRead:
        ldx     joy1Location
        inx
        stx     JOY1
        dex
        stx     JOY1
        ldx     #$08
@readNextBit:
        lda     JOY1
        lsr     a
        rol     newlyPressedButtons_player1
        lsr     a
        rol     tmp1
        lda     JOY2_APUFC
        lsr     a
        rol     newlyPressedButtons_player2
        lsr     a
        rol     tmp2
        dex
        bne     @readNextBit
        rts

addExpansionPortInputAsControllerInput:
        lda     tmp1
        ora     newlyPressedButtons_player1
        sta     newlyPressedButtons_player1
        lda     tmp2
        ora     newlyPressedButtons_player2
        sta     newlyPressedButtons_player2
        rts

        jsr     pollController_actualRead
        beq     diffOldAndNewButtons
pollController:
        jsr     pollController_actualRead
        jsr     addExpansionPortInputAsControllerInput
        lda     newlyPressedButtons_player1
        sta     generalCounter2
        lda     newlyPressedButtons_player2
        sta     generalCounter3
        jsr     pollController_actualRead
        jsr     addExpansionPortInputAsControllerInput
        lda     newlyPressedButtons_player1
        and     generalCounter2
        sta     newlyPressedButtons_player1
        lda     newlyPressedButtons_player2
        and     generalCounter3
        sta     newlyPressedButtons_player2
diffOldAndNewButtons:
        ldx     #$01
@diffForPlayer:
        lda     newlyPressedButtons_player1,x
        tay
        eor     heldButtons_player1,x
        and     newlyPressedButtons_player1,x
        sta     newlyPressedButtons_player1,x
        sty     heldButtons_player1,x
        dex
        bpl     @diffForPlayer
        rts

unreferenced_func1:
        jsr     pollController_actualRead
LABD1:  ldy     newlyPressedButtons_player1
        lda     newlyPressedButtons_player2
        pha
        jsr     pollController_actualRead
        pla
        cmp     newlyPressedButtons_player2
        bne     LABD1
        cpy     newlyPressedButtons_player1
        bne     LABD1
        beq     diffOldAndNewButtons
        jsr     pollController_actualRead
        jsr     addExpansionPortInputAsControllerInput
LABEA:  ldy     newlyPressedButtons_player1
        lda     newlyPressedButtons_player2
        pha
        jsr     pollController_actualRead
        jsr     addExpansionPortInputAsControllerInput
        pla
        cmp     newlyPressedButtons_player2
        bne     LABEA
        cpy     newlyPressedButtons_player1
        bne     LABEA
        beq     diffOldAndNewButtons
        jsr     pollController_actualRead
        lda     tmp1
        sta     heldButtons_player1
        lda     tmp2
        sta     heldButtons_player2
        ldx     #$03
LAC0D:  lda     newlyPressedButtons_player1,x
        tay
        eor     $F1,x
        and     newlyPressedButtons_player1,x
        sta     newlyPressedButtons_player1,x
        sty     $F1,x
        dex
        bpl     LAC0D
        rts
