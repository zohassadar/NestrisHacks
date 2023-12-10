nmi:    pha
        txa
        pha
        tya
        pha
        jsr     renderAnydasMenu
        jsr     incrementWallHackScroll
        jsr     restore_ppu_scroll
        lda     sleepCounter
        beq     @jumpOverDecrement
        dec     sleepCounter
@jumpOverDecrement:
        lda     #$00
        sta     OAMADDR
        lda     #$02
        sta     OAMDMA
        inc     frameCounter
        bne     :+
        inc     frameCounter+1
:
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        inc     verticalBlankingInterval
; cycle wait here and change scroll
        jsr     anydasControllerInput
        pla
        tay
        pla
        tax
        pla
irq:    rti