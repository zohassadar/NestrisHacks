

        ;are the following zeros unused entries for each high score table?
defaultHighScoresTable:
        .byte  "HOWARD" ;$08,$0F,$17,$01,$12,$04
        .byte  "OTASAN" ;$0F,$14,$01,$13,$01,$0E
        .byte  "LANCE " ;$0C,$01,$0E,$03,$05,$2B
        .byte  $00,$00,$00,$00,$00,$00 ;unused fourth name
        .byte  "ALEX  " ;$01,$0C,$05,$18,$2B,$2B
        .byte  "TONY  " ;$14,$0F,$0E,$19,$2B,$2B
        .byte  "NINTEN" ;$0E,$09,$0E,$14,$05,$0E
        .byte   $00,$00,$00,$00,$00,$00 ;unused fourth name
        ;High Scores are stored in BCD
        .byte   $01,$00,$00 ;Game A 1st Entry Score, 10000
        .byte   $00,$75,$00 ;Game A 2nd Entry Score, 7500
        .byte   $00,$50,$00 ;Game A 3rd Entry Score, 5000
        .byte   $00,$00,$00 ;unused fourth score
        .byte   $00,$20,$00 ;Game B 1st Entry Score, 2000
        .byte   $00,$10,$00 ;Game B 2nd Entry Score, 1000
        .byte   $00,$05,$00 ;Game B 3rd Entry Score, 500
        .byte   $00,$00,$00 ;unused fourth score
        .byte   $09 ;Game A 1st Entry Level
        .byte   $05 ;Game A 2nd Entry Level
        .byte   $00 ;Game A 3nd Entry Level
        .byte   $00 ;unused fourth level
        .byte   $09 ;Game B 1st Entry Level
        .byte   $05 ;Game B 2nd Entry Level
        .byte   $00 ;Game B 3rd Entry Level
        .byte   $00 ;unused fourth level
        .byte   $FF
