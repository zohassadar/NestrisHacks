; Anydas code by HydrantDude
renderAnydasMenu:
        lda gameMode
        cmp #$01
        beq @continueRendering
        jmp @clearOAMStagingAndReturn
@continueRendering:
        lda #$26
        sta PPUADDR
        lda #$70
        sta PPUADDR
        lda anydasDASValue
        jsr twoDigsToPPU
        lda #$26
        sta PPUADDR
        lda #$90
        sta PPUADDR
        lda anydasARRValue
        jsr twoDigsToPPU
        lda #$26
        sta PPUADDR
        lda #$B5
        sta PPUADDR
        lda anydasARECharge
        bne @areChargeOn
        lda #$0F
        sta PPUDATA
        sta PPUDATA
        bne @drawArrow
@areChargeOn:
        lda #$17
        sta PPUDATA
@drawArrow:
        lda #$FF
        sta PPUDATA
        ldx #$FF
        lda #$26
        sta PPUADDR
        lda #$72
        sta PPUADDR
        lda anydasMenu
        bne @notDasOption
        ldx #$63
@notDasOption:
        stx PPUDATA
        ldx #$FF
        lda #$26
        sta PPUADDR
        lda #$92
        sta PPUADDR
        lda anydasMenu
        cmp #$01
        bne @notARROption
        ldx #$63
@notARROption:
        stx PPUDATA
        ldx #$FF
        lda #$26
        sta PPUADDR
        lda #$B7
        sta PPUADDR
        lda anydasMenu
        cmp #$02
        bne @notAREOption
        ldx #$63
@notAREOption:
        stx PPUDATA
@clearOAMStagingAndReturn:
        lda #$00
        sta oamStagingLength
        jmp returnFromAnydasRender

anydasControllerInput:
        jsr pollController
        lda gameMode
        cmp #$01
        bne @ret3
        lda newlyPressedButtons_player1
        and #$0F
        beq @ret3
        and #$0C
        beq @upDownNotPressed
        and #$04
        beq @downNotPressed
        inc anydasMenu
        lda anydasMenu
        cmp #$03
        bne @ret1
        lda #$00
        sta anydasMenu
@ret1:  rts
@downNotPressed:
        dec anydasMenu
        lda anydasMenu
        cmp #$FF
        bne @ret2
        lda #$02
        sta anydasMenu
@ret2:
        rts
@upDownNotPressed:
        ldx anydasMenu
        cpx #$02
        beq @toggleARECharge
        lda newlyPressedButtons_player1
        and #$01
        beq @rightNotPressed
        inc anydasDASValue,X
        rts
@rightNotPressed:
        dec anydasDASValue,X
        rts
@toggleARECharge:
        lda anydasARECharge
        eor #$01
        sta anydasARECharge
@ret3:  rts
