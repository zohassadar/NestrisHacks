nmi:    pha
        txa
        pha
        tya
        pha
.ifdef ANYDAS
        jmp     renderAnydasMenu
returnFromAnydasRender:
        nop
.else
        lda     #$00
        sta     oamStagingLength
.endif
.ifdef SPS
        jsr     renderSeedIfNecessary
.else
        jsr     render
.endif
        dec     sleepCounter
        lda     sleepCounter
        cmp     #$FF
        bne     @jumpOverIncrement
        inc     sleepCounter
@jumpOverIncrement:
        jsr     copyOamStagingToOam
        lda     frameCounter
        clc
        adc     #$01
        sta     frameCounter
        lda     #$00
        adc     frameCounter+1
        sta     frameCounter+1
.ifdef BIGMODE30
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
.else
        ldx     #$17
        ldy     #$02
    .ifdef SPS
            jsr     generateNextPseudoAndAlsoBSeed
    .else
            jsr     generateNextPseudorandomNumber
    .endif
.endif
.ifdef SCROLLTRIS
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        jsr     incrementScroll
.else

.ifdef BIGMODE30
        ldx     #$17
        ldy     #$02
        jsr generateNextPseudorandomNumber
.else
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
.endif
.endif
        lda     #$01
        sta     verticalBlankingInterval
.ifdef ANYDAS
        jsr     anydasControllerInput
.else
        jsr     pollControllerButtons
.endif
        pla
        tay
        pla
        tax
        pla
irq:    rti
