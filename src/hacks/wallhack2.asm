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
        jsr     stageSpriteForCurrentPiece
        rts


andValuesSlowFastHi:
        .byte   $FF,$FC
andValuesSlowFastLo:
        .byte   $FF,$00

incValuesSlowFastHi:
        .byte   $00,$04


scrollSpeedTable:
        .byte $38,$40,$48,$50,$58,$60,$68,$70,$78,$80

setScrollSpeed:
        ldx     incrementSpeed
        dex
        beq     @fast 
        lda     player1_levelNumber
        cmp     #$14
        bcc     @shiftAndLoad     
        lda     #$13
@shiftAndLoad:
        lsr
        tay
        ldx     scrollSpeedTable,y
@fast:
        stx     scrollSpeed
        rts

resetScroll:
        lda     #$00
        sta     ppuScrollX
        lda     currentPpuCtrl
        and     #$FE
        sta     currentPpuCtrl
        rts


incrementWallHackScroll:
; modify this so it is cycle count consistent
        lda     renderMode
        cmp     #$03
        bne     resetScroll
        ldx     incrementSpeed
        clc
        lda     andValuesSlowFastLo,x
        and     ppuScrollXLo
        adc     scrollSpeed
        sta     ppuScrollXLo
        php
        
        lda     andValuesSlowFastHi,x  
        and     ppuScrollX
        adc     incValuesSlowFastHi,x
        sta     ppuScrollX

        lda     ppuScrollXHi
        adc     #$00
        and     #$01 ; never let this number get above 511
        sta     ppuScrollXHi 
        ror
        lda     currentPpuCtrl
        and     #$FE
        adc     #$00
        sta     currentPpuCtrl

        ; lda     frameCounter
        ; and     #$03
        ; bne     @skipTopPart

        lda     #$01
        clc
        adc     topPartPPUScrollX
        sta     topPartPPUScrollX

        lda     topPartPPUScrollXHi
        adc     #$00
        and     #$01 ; never let this number get above 511
        sta     topPartPPUScrollXHi 
        ror
        lda     currentPpuCtrl
        and     #$FE
        adc     #$00
        sta     topPartPPUCtrl

@skipTopPart:
; cycle offset every 8 pixels
        plp
        bcs     @inc
        lda     incrementSpeed
        beq     @ret
@inc:
        lda     ppuScrollX
        and     #$07
        bne     @ret
        inc     columnOffset
        lda     columnOffset
        cmp     #$0a
        bne     @ret
        lda     #$00
        sta     columnOffset
@ret:   rts


initTasks:
        lda     #$04
        sta     playfieldAddr+1
        jsr     copyPlayfieldColumnToBuffer
        rts

cleanupTasks:
        jsr     render_mode_play_and_demo
        jsr     copyPlayfieldColumnToBuffer
        ; jmp     updateLineClearingAnimation
        rts
