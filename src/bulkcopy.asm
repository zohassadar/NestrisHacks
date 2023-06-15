
bulkCopyToPpu:
        jsr     copyAddrAtReturnAddressToTmp_incrReturnAddrBy2
        jmp     copyToPpu

LAA9E:  pha
        sta     PPUADDR
        iny
        lda     (tmp1),y
        sta     PPUADDR
        iny
        lda     (tmp1),y
        asl     a
        pha
        lda     currentPpuCtrl
        ora     #$04
        bcs     LAAB5
        and     #$FB
LAAB5:  sta     PPUCTRL
        sta     currentPpuCtrl
        pla
        asl     a
        php
        bcc     LAAC2
        ora     #$02
        iny
LAAC2:  plp
        clc
        bne     LAAC7
        sec
LAAC7:  ror     a
        lsr     a
        tax
LAACA:  bcs     LAACD
        iny
LAACD:  lda     (tmp1),y
        sta     PPUDATA
        dex
        bne     LAACA
        pla
        cmp     #$3F
        bne     LAAE6
        sta     PPUADDR
        stx     PPUADDR
        stx     PPUADDR
        stx     PPUADDR
LAAE6:  sec
        tya
        adc     tmp1
        sta     tmp1
        lda     #$00
        adc     tmp2
        sta     tmp2
; Address to read from stored in tmp1/2
copyToPpu:
        ldx     PPUSTATUS
        ldy     #$00
        lda     (tmp1),y
        bpl     LAAFC
        rts

LAAFC:  cmp     #$60
        bne     LAB0A
        pla
        sta     tmp2
        pla
        sta     tmp1
        ldy     #$02
        bne     LAAE6
LAB0A:  cmp     #$4C
        bne     LAA9E
        lda     tmp1
        pha
        lda     tmp2
        pha
        iny
        lda     (tmp1),y
        tax
        iny
        lda     (tmp1),y
        sta     tmp2
        stx     tmp1
        bcs     copyToPpu
copyAddrAtReturnAddressToTmp_incrReturnAddrBy2:
        tsx
        lda     stack+3,x
        sta     tmpBulkCopyToPpuReturnAddr
        lda     stack+4,x
        sta     tmpBulkCopyToPpuReturnAddr+1
        ldy     #$01
        lda     (tmpBulkCopyToPpuReturnAddr),y
        sta     tmp1
        iny
        lda     (tmpBulkCopyToPpuReturnAddr),y
        sta     tmp2
        clc
        lda     #$02
        adc     tmpBulkCopyToPpuReturnAddr
        sta     stack+3,x
        lda     #$00
        adc     tmpBulkCopyToPpuReturnAddr+1
        sta     stack+4,x
        rts
