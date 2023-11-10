        .setcpu "6502"

.include "compat.asm"
.include "constants.asm"
.include "charmap.asm"
.include "ram.asm"

.segment        "PRG_chunk1": absolute
.include "boot.asm"
.include "loop.asm"
.include "gamemode/branch.asm"
.include "playstate/branch.asm"
.include "gamemode/legal.asm"
.include "gamemode/title.asm"
.include "nmi/legal_and_title.asm"
.include "gamemode/gametype_menu.asm"
.include "gamemode/level_menu.asm"
.include "nmi/menu_screens.asm"
.include "playstate/init.asm"
.include "gamemode/update.asm"
.include "playstate/rotate.asm"
.include "playstate/drop.asm"
.include "playstate/shift.asm"
.include "sprites/current.asm"
.include "data/otable.asm"
.if .defined(RANDO) | .defined(UPSIDEDOWN)
.include "hacks/otable_nextbox.asm"
.else
.include "sprites/next.asm"
.endif
.include "data/orientation_to_sprite.asm"
.include "data/unreferenced_data2.asm"
.include "sprites/load.asm"
.include "sprites/sprites.asm"
.include "playstate/position.asm"
.include "nmi/play.asm"
.include "playstate/spawn.asm"
.include "playstate/lock.asm"
.include "playstate/garbage.asm"
.include "playstate/score.asm"
.include "playstate/update_playfield.asm"
.include "playstate/gameover.asm"
.include "playstate/music_speed.asm"
.include "demo/demo_input.asm"
.include "util/set_music.asm"
.include "playstate/reset.asm"


; It looks like the jsr _must_ do nothing, otherwise reg a != gameModeState in mainLoop and there would not be any waiting on vsync
gameModeState_vblankThenRunState2:
        lda     #$02
        sta     gameModeState
        jsr     noop_disabledVramRowIncr
        rts

playState_unassignOrientationId:
        lda     #$13
        sta     currentPiece
        rts

        inc     gameModeState
        rts

playState_incrementPlayState:
        inc     playState
playState_noop:
        rts

.include "playstate/ending.asm"
.include "nmi/ending.asm"
.include "highscores.asm"
.include "nmi/congrats.asm"
.include "playstate/pause.asm"
.include "playstate/bgoal.asm"
.include "util/sleep.asm"
.include "ending.asm"
.include "util/ppuctrl.asm"
.include "bulkcopy.asm"
.include "util/rng.asm"
.include "util/oam.asm"
.include "nmi/poll_controller.asm"
.include "util/memset.asm"
.include "util/switch.asm"
.ifdef CNROM
.include "hacks/cnrom.asm"
.else
.include "util/mmc1.asm"
.endif
.include "data/palettes.asm"
.include "data/highscores.asm"

;.segment        "legal_screen_nametable": absolute

legal_screen_nametable:
        .incbin "nametables/legal_screen_nametable.bin"
title_screen_nametable:
        .incbin "nametables/title_screen_nametable.bin"
game_type_menu_nametable:
        .incbin "nametables/game_type_menu_nametable.bin"
level_menu_nametable:
        .incbin "nametables/level_menu_nametable.bin"
game_nametable:
.ifdef TALLER
        .incbin "nametables/taller_game_nametable.bin"
.else
        .incbin "nametables/game_nametable.bin"
.endif
enter_high_score_nametable:
        .incbin "nametables/enter_high_score_nametable.bin"
high_scores_nametable:
        .incbin "nametables/high_scores_nametable.bin"

.include "data/heightmenu.asm"

type_b_lvl9_ending_nametable:
        .incbin "nametables/type_b_lvl9_ending_nametable.bin"
type_b_ending_nametable:
        .incbin "nametables/type_b_ending_nametable.bin"
type_a_ending_nametable:
        .incbin "nametables/type_a_ending_nametable.bin"

; End of "PRG_chunk1" segment
.code


.segment        "unreferenced_data1": absolute
unreferenced_data1:

.ifdef TALLER
        .include "hacks/taller.asm"
.endif

.ifdef TOURNAMENT
        .include "hacks/tourney.asm"
.endif


.if .defined(SPS) .or .defined(ANYDAS)
        .include "hacks/menudas.asm"
.endif

.ifdef ANYDAS
        .include "hacks/anydas.asm"
.endif

.ifdef WALLHACK2
        .include "hacks/wallhack2.asm"
.endif

.ifdef SPS
        .include "hacks/same_piece_sets.asm"
.endif

.ifndef OMIT_UD1
        .incbin "data/unreferenced_data1.bin"
.endif
; End of "unreferenced_data1" segment
.code


.segment        "PRG_chunk2": absolute
.include "data/demo_data.asm"
.include "sound.asm"
; End of "PRG_chunk2" segment
.code


.segment        "unreferenced_data4": absolute
.include "data/unreferenced_data4.asm"
; End of "unreferenced_data4" segment
.code

.segment        "PRG_chunk3": absolute
; incremented to reset MMC1 reg
.include "reset.asm"
.include "data/unreferenced_data5.asm"
MMC1_PRG:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00
        .byte   $00
; End of "PRG_chunk3" segment
.code

.include "util/vectors.asm"
