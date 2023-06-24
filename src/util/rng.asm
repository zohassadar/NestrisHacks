;reg x: zeropage addr of seed; reg y: size of seed
generateNextPseudorandomNumber:
        lda     tmp1,x
        and     #$02
        sta     tmp1
        lda     tmp2,x
        and     #$02
        eor     tmp1
        clc
        beq     @updateNextByteInSeed
        sec
@updateNextByteInSeed:
        ror     tmp1,x
        inx
        dey
        bne     @updateNextByteInSeed
        rts
