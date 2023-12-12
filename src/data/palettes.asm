game_palette:
.ifdef PENGUIN
        .byte   $3F,$00,$20
        .byte   $0F,$30,$12,$16
        .byte   $0F,$20,$12,$18
        .byte   $0F,$2C,$16,$29
        .byte   $0F,$3C,$00,$30
        .byte   $0F,$35,$15,$22
        .byte   $0F,$35,$29,$26
        .byte   $0F,$2C,$16,$29
        .byte   $0F,$0F,$20,$27  ; color for penguin
        .byte   $FF
.else
        .byte   $3F,$00,$20,$0F,$30,$12,$16,$0F
        .byte   $20,$12,$18,$0F,$2C,$16,$29,$0F
        .byte   $3C,$00,$30,$0F,$35,$15,$22,$0F
        .byte   $35,$29,$26,$0F,$2C,$16,$29,$0F
        .byte   $3C,$00,$30,$FF
.endif
legal_screen_palette:
        .byte   $3F,$00,$10,$0F,$27,$2A,$2B,$0F
        .byte   $3C,$2A,$22,$0F,$27,$2C,$29,$0F
        .byte   $30,$3A,$15,$FF
menu_palette_old:
        .byte   $3F,$00,$14
        .byte   $0F,$30,$38,$00
        .byte   $0F,$30,$16,$00
        .byte   $0F,$30,$21,$00
        .byte   $0F,$16,$2A,$28
        .byte   $0F,$30,$29,$27
        .byte   $FF
ending_palette:
        .byte   $3F,$00,$20,$12,$0F,$29,$37,$12
        .byte   $0F,$30,$27,$12,$0F,$17,$27,$12
        .byte   $0F,$15,$37,$12,$0F,$29,$37,$12
        .byte   $0F,$30,$27,$12,$0F,$17,$27,$12
        .byte   $0F,$15,$37,$FF


menu_palette:
        .byte   $3F,$00,$20
        .byte   $0F,$30,$38,$00
        .byte   $0F,$30,$16,$00
        .byte   $0F,$30,$21,$00
        .byte   $0F,$16,$2A,$28
        .byte   $0F,$30,$29,$27
        .byte   $0F,$30,$16,$00
        .byte   $0F,$30,$21,$00
        .byte   $0F,$16,$2A,$28
        .byte   $FF