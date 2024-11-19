
; This iNES header is from Brad Smith (rainwarrior)
; https://github.com/bbbradsmith/NES-ca65-example

INES_MAPPER = 4 ; 4 = MMC3
INES_MIRROR = 0
INES_SRAM = 1

.byte 'N', 'E', 'S', $1A ; ID
.byte $08 ; 16k PRG chunk count
.byte $08 ; 8k CHR chunk count
.byte INES_MIRROR | (INES_SRAM << 1) | ((INES_MAPPER & $f) << 4)
.byte (INES_MAPPER & %11110000)
.byte $0, $0, $0, $0, $0, $0, $0, $0 ; padding
