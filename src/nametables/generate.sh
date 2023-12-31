#!/usr/bin/env bash
set -e

python nametable_builder.py break \
    enter_high_score_nametable.bin \
    characters_title.txt \
    --output \
    enter_high_score_nametable.py 

python nametable_builder.py break \
    game_nametable.bin \
    characters_game.txt \
    --output \
    game_nametable.py 

python nametable_builder.py break \
    game_type_menu_nametable.bin \
    characters_title.txt \
    --output \
    game_type_menu_nametable.py 

python nametable_builder.py break \
    high_scores_nametable.bin \
    characters_title.txt \
    --output \
    high_scores_nametable.py --skip-attrs

python nametable_builder.py break \
    legal_screen_nametable.bin \
    characters_title.txt \
    --output \
    legal_screen_nametable.py 

python nametable_builder.py break \
    level_menu_nametable.bin \
    characters_title.txt \
    --output \
    level_menu_nametable.py 

python nametable_builder.py break \
    title_screen_nametable.bin \
    characters_title.txt \
    --output \
    title_screen_nametable.py 

python nametable_builder.py break \
    type_a_ending_nametable.bin \
    characters_ending.txt \
    --output \
    type_a_ending_nametable.py 

python nametable_builder.py break \
    type_b_ending_nametable.bin \
    characters_ending.txt \
    --output \
    type_b_ending_nametable.py 

python nametable_builder.py break \
    type_b_lvl9_ending_nametable.bin \
    characters_ending.txt \
    --output \
    type_b_lvl9_ending_nametable.py 
