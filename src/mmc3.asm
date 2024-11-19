.segment "HEADER"

.include "header.asm"

.segment "ZP"
.segment "BSS"
.segment "WRAM"


.segment "BANK0"
.segment "BANK1"
.segment "BANK2"
.segment "BANK3"
.segment "BANK4"
.segment "BANK5"
.segment "PRG"
.include "main.asm"
; .segment "BANK6"
; .segment "FIXEDA"
; .segment "FIXEDB"
; .segment "VECTORS"


.segment "CHR"
.repeat 16
.incbin "gfx/title_menu_tileset.chr"
.endrepeat
