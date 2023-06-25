reset:  cld
        sei
        ldx     #$00
        stx     PPUCTRL
        stx     PPUMASK
@vsyncWait1:
        lda     PPUSTATUS
        bpl     @vsyncWait1
@vsyncWait2:
        lda     PPUSTATUS
        bpl     @vsyncWait2
        dex
        txs
        inc     reset
.ifdef CNROM
        ; ff19
        lda     #CNROM_BANK0
        ldy     #CNROM_BG0
        ldx     #CNROM_SPRITE0
        jsr     changeCHRBank0
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
.else
        lda     #$10
        jsr     setMMC1Control
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
        lda     #$00
        jsr     changePRGBank
.endif
        jmp     initRam     ;ff2d