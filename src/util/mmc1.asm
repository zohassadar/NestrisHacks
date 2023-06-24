setMMC1Control:
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        lsr     a
        sta     MMC1_Control
        rts

changeCHRBank0:
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        lsr     a
        sta     MMC1_CHR0
        rts

changeCHRBank1:
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        lsr     a
        sta     MMC1_CHR1
        rts

changePRGBank:
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        lsr     a
        sta     MMC1_PRG
        rts
