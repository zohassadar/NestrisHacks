
orientationTable:
.ifndef BIGMODE30
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$FF,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$00,$00,$7B,$01,$01,$7B,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$01,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$FF,$00,$7B,$00,$01,$7B,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$01,$7D
        .byte   $FF,$01,$7D,$00,$FF,$7D,$FF,$00
        .byte   $7D,$FF,$00,$7D,$00,$00,$7D,$01
        .byte   $FF,$7D,$00,$FF,$7D,$01,$00,$7D
        .byte   $00,$01,$7D,$00,$00,$7D,$FF,$00
        .byte   $7D,$00,$00,$7D,$01,$01,$7D,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$01,$7C
        .byte   $00,$01,$7C,$01,$FF,$7C,$01,$00
        .byte   $7C,$00,$00,$7C,$01,$01,$7C,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$01,$7B
        .byte   $FF,$01,$7B,$00,$00,$7D,$00,$00
        .byte   $7D,$01,$01,$7D,$FF,$01,$7D,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$00,$7D
        .byte   $01,$01,$7D,$01,$FF,$7C,$00,$00
        .byte   $7C,$00,$01,$7C,$00,$01,$7C,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$00,$7C
        .byte   $01,$01,$7C,$FF,$FF,$7C,$FF,$FF
        .byte   $7C,$00,$00,$7C,$00,$01,$7C,$00
        .byte   $FF,$7C,$01,$00,$7C,$FF,$00,$7C
        .byte   $00,$00,$7C,$01,$FE,$7B,$00,$FF
        .byte   $7B,$00,$00,$7B,$00,$01,$7B,$00
        .byte   $00,$7B,$FE,$00,$7B,$FF,$00,$7B
        .byte   $00,$00,$7B,$01,$00,$FF,$00,$00
        .byte   $FF,$00,$00,$FF,$00,$00,$FF,$00
.else
        .byte   $00,$93,$FF,$00,$93,$00,$00,$93
        .byte   $01,$FF,$93,$00,$FF,$93,$00,$00
        .byte   $93,$00,$00,$93,$01,$01,$93,$00
        .byte   $00,$93,$FF,$00,$93,$00,$00,$93
        .byte   $01,$01,$93,$00,$FF,$93,$00,$00
        .byte   $93,$FF,$00,$93,$00,$01,$93,$00
        .byte   $FF,$e0,$00,$00,$e0,$00,$01,$e0
        .byte   $FF,$01,$e0,$00,$FF,$e0,$FF,$00
        .byte   $e0,$FF,$00,$e0,$00,$00,$e0,$01
        .byte   $FF,$e0,$00,$FF,$e0,$01,$00,$e0
        .byte   $00,$01,$e0,$00,$00,$e0,$FF,$00
        .byte   $e0,$00,$00,$e0,$01,$01,$e0,$01
        .byte   $00,$9b,$FF,$00,$9b,$00,$01,$9b
        .byte   $00,$01,$9b,$01,$FF,$9b,$01,$00
        .byte   $9b,$00,$00,$9b,$01,$01,$9b,$00
        .byte   $00,$93,$FF,$00,$93,$00,$01,$93
        .byte   $FF,$01,$93,$00,$00,$e0,$00,$00
        .byte   $e0,$01,$01,$e0,$FF,$01,$e0,$00
        .byte   $FF,$e0,$00,$00,$e0,$00,$00,$e0
        .byte   $01,$01,$e0,$01,$FF,$9b,$00,$00
        .byte   $9b,$00,$01,$9b,$00,$01,$9b,$01
        .byte   $00,$9b,$FF,$00,$9b,$00,$00,$9b
        .byte   $01,$01,$9b,$FF,$FF,$9b,$FF,$FF
        .byte   $9b,$00,$00,$9b,$00,$01,$9b,$00
        .byte   $FF,$9b,$01,$00,$9b,$FF,$00,$9b
        .byte   $00,$00,$9b,$01,$FE,$93,$00,$FF
        .byte   $93,$00,$00,$93,$00,$01,$93,$00
        .byte   $00,$93,$FE,$00,$93,$FF,$00,$93
        .byte   $00,$00,$93,$01,$00,$EA,$00,$00
        .byte   $EA,$00,$00,$EA,$00,$00,$EA,$00
.endif
