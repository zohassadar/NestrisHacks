#!/usr/bin/env bash

BUILDFLAGS=""
OUTPUT=UnnamedHack

echo building nametables
# modified nametables will throw warnings
python src/nametables/enter_high_score_nametable.py
python src/nametables/game_nametable.py
python src/nametables/game_type_menu_nametable.py
python src/nametables/high_scores_nametable.py
python src/nametables/legal_screen_nametable.py
python src/nametables/level_menu_nametable.py $BUILDFLAGS
python src/nametables/taller_game_nametable.py
python src/nametables/title_screen_nametable.py $BUILDFLAGS
python src/nametables/type_a_ending_nametable.py
python src/nametables/type_b_ending_nametable.py
python src/nametables/type_b_lvl9_ending_nametable.py

echo building tilesets
python tools/nes-util/nes_chr_encode.py src/gfx/game_tileset.png src/gfx/game_tileset.chr
python tools/nes-util/nes_chr_encode.py src/gfx/taller_game_tileset.png src/gfx/taller_game_tileset.chr
python tools/nes-util/nes_chr_encode.py src/gfx/title_menu_tileset.png src/gfx/title_menu_tileset.chr
python tools/nes-util/nes_chr_encode.py src/gfx/typeA_ending_tileset.png src/gfx/typeA_ending_tileset.chr
python tools/nes-util/nes_chr_encode.py src/gfx/typeB_ending_tileset.png src/gfx/typeB_ending_tileset.chr

echo assembling
ca65 $BUILDFLAGS -l ${OUTPUT}.lst -g src/mmc3.asm -o mmc3.o

echo linking
ld65 -m ${OUTPUT}.map \
    -Ln ${OUTPUT}.lbl \
    --dbgfile ${OUTPUT}.dbg \
    -o ${OUTPUT}.nes \
    -C src/mmc3.cfg mmc3.o
