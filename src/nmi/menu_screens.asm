
render_mode_menu_screens:
        lda     currentPpuCtrl
        and     #$FC
        sta     currentPpuCtrl
        sta     PPUCTRL
        lda     #$00
.ifdef SCROLLTRIS
        lda     ppuScrollX
        sta     PPUSCROLL
        lda     ppuScrollY
        sta     PPUSCROLL
.else
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
.endif
        rts
