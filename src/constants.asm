PPUCTRL         := $2000
PPUMASK         := $2001
PPUSTATUS       := $2002
OAMADDR         := $2003
OAMDATA         := $2004
PPUSCROLL       := $2005
PPUADDR         := $2006
PPUDATA         := $2007

SQ1_VOL         := $4000
SQ1_SWEEP       := $4001
SQ1_LO          := $4002
SQ1_HI          := $4003
SQ2_VOL         := $4004
SQ2_SWEEP       := $4005
SQ2_LO          := $4006
SQ2_HI          := $4007
TRI_LINEAR      := $4008
TRI_LO          := $400A
TRI_HI          := $400B
NOISE_VOL       := $400C
NOISE_LO        := $400E
NOISE_HI        := $400F
DMC_FREQ        := $4010
DMC_RAW         := $4011
DMC_START       := $4012                        ; start << 6 + $C000
DMC_LEN         := $4013                        ; len << 4 + 1
OAMDMA          := $4014
SND_CHN         := $4015
JOY1            := $4016
JOY2_APUFC      := $4017                        ; read: bits 0-4 joy data lines (bit 0 being normal controller), bits 6-7 are FC inhibit and mode

FFFF := $FFFF

BUTTON_RIGHT := $1
BUTTON_LEFT := $2
BUTTON_DOWN := $4
BUTTON_UP := $8
BUTTON_START := $10
BUTTON_SELECT := $20
BUTTON_B := $40
BUTTON_A := $80

MMC1_CHR0       := $BFFF
MMC1_CHR1       := $DFFF

; https://www.nesdev.org/wiki/CNROM
; 2 8k banks, each with two tilesets
CNROM_BANK0 := $00
CNROM_BANK1 := $01

; PPU Background tileset
CNROM_BG0 := $00
CNROM_BG1 := $10

; PPU OAM tileset
CNROM_SPRITE0 := $00
CNROM_SPRITE1 := $08

.ifdef TWELVE
PAUSE_SPRITE_X := $6C
.elseif .defined(TRIPLEWIDE)
PAUSE_SPRITE_X := $6C
.else
PAUSE_SPRITE_X := $74
.endif
PAUSE_SPRITE_Y := $58
