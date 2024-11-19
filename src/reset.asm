reset:  cld
        sei
        ldx     #$00
        stx     PPUCTRL
        stx     PPUMASK
@vsyncWait1:
        lda     PPUSTATUS
        bpl     @vsyncWait1
        ; reset ram here
@vsyncWait2:
        lda     PPUSTATUS
        bpl     @vsyncWait2
        dex
        txs
        initMMC3
        jsr     loadMMC3Bank6
        jmp     initRam     ;ff2d

loadMMC3Bank0:
    setMMC3Banks 0
loadMMC3Bank1:
    setMMC3Banks 1
loadMMC3Bank2:
    setMMC3Banks 2
loadMMC3Bank3:
    setMMC3Banks 3
loadMMC3Bank4:
    setMMC3Banks 4
loadMMC3Bank5:
    setMMC3Banks 5
loadMMC3Bank6:
    setMMC3Banks 6
