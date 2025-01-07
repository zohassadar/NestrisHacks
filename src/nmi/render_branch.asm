render: lda     renderMode
        jsr     switch_s_plus_2a
        .addr   render_mode_legal_and_title_screens
        .addr   render_mode_menu_screens
        .addr   render_mode_congratulations_screen
.if .defined(TRIPLEWIDE) .or .defined(BIGMODE30)
        .addr   render_mode_play_and_demo_or_dump
.else
        .addr   render_mode_play_and_demo
.endif
        .addr   render_mode_ending_animation
