
switch_s_plus_2a:
        asl     a
        tay
        iny
        pla
        sta     tmp1
        pla
        sta     tmp2
        lda     (tmp1),y
        tax
        iny
        lda     (tmp1),y
        sta     tmp2
        stx     tmp1
        jmp     (tmp1)

        sei
        inc     initRam
        lda     #$1A
        jsr     setMMC1Control
        rts

        rts