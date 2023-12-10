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


wallHackyStageSprite:
        lda     #$10
        sec
        sbc     ppuScrollX
        sta     tmp3
        jsr     stageSpriteForCurrentPiece
        lda     #$60
        sec
        sbc     ppuScrollX
        sta     tmp3
        jsr     stageSpriteForCurrentPiece
        lda     #$B0
        sec
        sbc     ppuScrollX
        sta     tmp3
        jsr     stageSpriteForCurrentPiece
        rts

incrementWallHackScroll:
        lda     gameMode
        cmp     #$04
        bne     @ret
        lda     playState
        cmp     #$0A
        beq     @ret
        lda     #$01
        clc
        adc     ppuScrollX
        sta     ppuScrollX
        lda     currentPpuCtrl
        and     #$FE
        adc     #$00
        sta     currentPpuCtrl
@ret:   rts



      
; $00,$01,$02,$03,$04,$05,$06,$07,$08,$09
; $0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13
; $14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d
; $1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27
; $28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31
; $32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b
; $3c,$3d,$3e,$3f,$40,$40,$40,$40,$40,$40



        .addr $20c0
        .addr $20e0
        .addr $2100
        .addr $2120
        .addr $2140
        .addr $2160
        .addr $2180
        .addr $21a0
        .addr $21c0
        .addr $21e0
        .addr $2200
        .addr $2220
        .addr $2240
        .addr $2260
        .addr $2280
        .addr $22a0
        .addr $22c0
        .addr $22e0
        .addr $2300
        .addr $2320
