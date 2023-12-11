; Stuff stashed here to save space in the hacks section
unreferenced_data5:


.if .defined(RANDO) | .defined(UPSIDEDOWN)
        ; padding for easy adjustment in case of future development
        nop
        nop
        nop
        nop
        nop
        nop
chooseNextAndRandomizeOrientation:
        jsr     chooseNextTetrimino
randomizeOrientation:
        tax
        lda     tetriminoTypeFromOrientation,x
        asl
        asl
        sta     generalCounter
.ifdef SPS
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        lda     set_seed+1
.else
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        lda     rng_seed
.endif
        and     #$03
        clc
        adc     generalCounter
        tay
        lda     orientationList,y
        rts

orientationList:
        .byte $00,$01,$02,$03 ; t
        .byte $04,$05,$06,$07 ; j
        .byte $08,$09,$08,$09 ; z
        .byte $0A,$0A,$0A,$0A ; o
        .byte $0B,$0C,$0C,$0B ; s
        .byte $0D,$0E,$0F,$10 ; l
        .byte $11,$12,$11,$12 ; i

orientationToNextOffsetTableX:
        .byte   $0,$fe,$0,$4 ; t
        .byte   $6,$0,$fc,$0 ; j
        .byte   $0,$fc ; z
        .byte   $5 ; o
        .byte   $0,$fc ; s
        .byte   $fc,$0,$4,$0 ; l
        .byte   $0,$4 ; i

orientationToNextOffsetTableY:
        .byte   $6,$4,$0,$4 ; t
        .byte   $3,$8,$4,$0 ; j
        .byte   $0,$3 ; z
        .byte   $0 ; o
        .byte   $0,$3 ; s
        .byte   $3,$0,$4,$6 ; l
        .byte   $7,$2 ; i
.else
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
.endif


.ifdef AEPPOZ
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