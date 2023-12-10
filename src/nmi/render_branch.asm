render: lda     renderMode
        jsr     switch_s_plus_2a
        .addr   render_mode_legal_and_title_screens
        .addr   render_mode_menu_screens
        .addr   render_mode_congratulations_screen
        .addr   render_mode_play_and_demo
        .addr   render_mode_ending_animation
        .addr   render_mode_nop


restore_ppu_scroll:
        lda     ppuScrollX
        sta     PPUSCROLL
        lda     ppuScrollY
        sta     PPUSCROLL
        lda     currentPpuCtrl
        sta     PPUCTRL
        rts
