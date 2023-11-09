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
        ldx anydasDASValue
        lda byteToBcdTable,x
        jsr twoDigsToPPU
        lda #$26
        sta PPUADDR
        lda #$90
        sta PPUADDR
        ldx anydasARRValue
        lda byteToBcdTable,x
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
        lda anydasInit
        bne @initialized
        lda #$10
        sta anydasDASValue
        lda #$06
        sta anydasARRValue
        inc anydasInit
@initialized:
        lda gameMode
        cmp #$01
        beq @getInputs
        rts
@getInputs:

        lda #BUTTON_DOWN
        jsr menuThrottle
        beq @downNotPressed
        lda #$01
        sta soundEffectSlot1Init
        inc anydasMenu
        lda anydasMenu
        cmp #$03
        bne @downNotPressed
        lda #$00
        sta anydasMenu
@downNotPressed:


        lda #BUTTON_UP
        jsr menuThrottle
        beq @upNotPressed
        lda #$01
        sta soundEffectSlot1Init
        dec anydasMenu
        bpl @upNotPressed
        lda #$02
        sta anydasMenu
@upNotPressed:


        lda #BUTTON_LEFT
        jsr menuThrottle
        beq @leftNotPressed
        lda #$01
        sta soundEffectSlot1Init
        ldx anydasMenu
        dec anydasDASValue,x
        bpl @leftNotPressed
        lda anydasUpperLimit,x
        sta anydasDASValue,x
        dec anydasDASValue,x
@leftNotPressed:


        lda #BUTTON_RIGHT
        jsr menuThrottle
        beq @rightNotPressed
        lda #$01
        sta soundEffectSlot1Init
        ldx anydasMenu
        inc anydasDASValue,x
        lda anydasDASValue,x
        cmp anydasUpperLimit,x
        bne @rightNotPressed
        lda #$00
        sta anydasDASValue,x
@rightNotPressed:
        rts


anydasUpperLimit:
        .byte $32,$32,$02

