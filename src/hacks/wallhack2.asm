testRightShiftAndValidate:
        lda     tetriminoX
        cmp     #$0F
        bne     @noResetR
        lda     #$05
        sta     tetriminoX
@noResetR:
        jsr     isPositionValid
        rts

testLeftShiftAndValidate:
        lda     tetriminoX
        cmp     #$01
        bne     @noResetL
        lda     #$0B
        sta     tetriminoX
@noResetL:
        jsr     isPositionValid
        rts

multBy12Table:
        .byte   $00,$0c,$18,$24,$30,$3c,$48,$54
        .byte   $60,$6c,$78,$84,$90,$9c,$a8,$b4
        .byte   $c0,$cc,$d8

effectiveTetriminoXTable:
        .byte   $07,$08,$09
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09
        .byte   $00,$01,$02

