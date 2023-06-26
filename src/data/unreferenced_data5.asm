unreferenced_data5:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$BF,$FF,$FF,$FF,$EF,$FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FF,$FF,$FF,$FF,$EF,$7F,$FF,$FF
        .byte   $FF,$FF,$7D,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FB,$FF,$FF,$FF,$FF,$BF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $BF,$FF,$FF,$7F,$FF,$FF,$FF,$FF
        .byte   $00,$00,$00,$00,$00,$00
.ifdef AEPPOZ
; This is stashed here to save space in the hacks section
checkPositionAndMaybeEndGame:
        jsr     isPositionValid
        bne     @ret
        lda     heldButtons_player1
        and     #BUTTON_SELECT
@ret:   rts
.else
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00
.endif