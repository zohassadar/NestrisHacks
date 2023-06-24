#!/usr/bin/env bash

labels=(
    "@playStateNotDisplayLineClearingAnimation"
    "shift_tetrimino"
    "rotate_tetrimino"
    "drop_tetrimino"
    "isPositionValid"
    "gameModeState_initGameBackground"
    "playState_playerControlsActiveTetrimino"
    "render_mode_legal_and_title_screens"
    "render_mode_menu_screens"
    "render_mode_congratulations_screen"
    "pollControllerButtons"
    "nmi"
    "memset_page"
    "soundEffectSlot1_rotateTetrimino_ret"
    "unreferenced_data4"
)

IFS="|"
grep -E "${labels[*]}" tetris.lbl | sort
unset IFS