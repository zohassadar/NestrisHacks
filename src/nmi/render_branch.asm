render: lda     renderMode
        jsr     switch_s_plus_2a
        .addr   render_mode_legal_and_title_screens
        .addr   render_mode_menu_screens
        .addr   render_mode_congratulations_screen
.ifdef MINIMAL_ARE
        .addr   render_piece_then_render_mode_play_and_demo
.else
        .addr   render_mode_play_and_demo
.endif
        .addr   render_mode_ending_animation