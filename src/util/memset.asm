memset_ppu_page_and_more:
        sta     tmp1
        stx     tmp2
        sty     tmp3
        lda     PPUSTATUS
        lda     currentPpuCtrl
        and     #$FB
        sta     PPUCTRL
        sta     currentPpuCtrl
        lda     tmp1
        sta     PPUADDR
        ldy     #$00
        sty     PPUADDR
        ldx     #$04
        cmp     #$20
        bcs     LAC40
        ldx     tmp3
LAC40:  ldy     #$00
        lda     tmp2
LAC44:  sta     PPUDATA
        dey
        bne     LAC44
        dex
        bne     LAC44
        ldy     tmp3
        lda     tmp1
        cmp     #$20
        bcc     LAC67
        adc     #$02
        sta     PPUADDR
        lda     #$C0
        sta     PPUADDR
        ldx     #$40
LAC61:  sty     PPUDATA
        dex
        bne     LAC61
LAC67:  ldx     tmp2
        rts

; reg a: value; reg x: start page; reg y: end page (inclusive)
memset_page:
        pha
        txa
        sty     tmp2
        clc
        sbc     tmp2
        tax
        pla
        ldy     #$00
        sty     tmp1
@setByte:
        sta     (tmp1),y
        dey
        bne     @setByte
        dec     tmp2
        inx
        bne     @setByte
        rts
