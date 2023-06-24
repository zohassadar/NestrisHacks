
render_mode_menu_screens:
        lda     currentPpuCtrl
        and     #$FC
        sta     currentPpuCtrl
        sta     PPUCTRL
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        rts
