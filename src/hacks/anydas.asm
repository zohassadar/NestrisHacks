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
        lda #$FF
        sta PPUDATA

        lda #$26
        sta PPUADDR
        lda #$90
        sta PPUADDR
        ldx anydasARRValue
        lda byteToBcdTable,x
        jsr twoDigsToPPU
        lda #$FF
        sta PPUDATA

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
        lda #$FF
        sta PPUDATA
@drawArrow:
        ldx #$FF
        stx PPUDATA

; draw big chance
        lda #$22
        sta PPUADDR
        lda #$D3
        sta PPUADDR
        stx PPUDATA
        lda bigChance
        sta PPUDATA
        lda #$4F ; /
        sta PPUDATA
        lda #$04
        sta PPUDATA
        stx PPUDATA

; arrow
        lda #$22
        sta PPUADDR
        lda #$72
        clc
        ldx anydasMenu
        adc arrowOffsets,x
        sta PPUADDR
        lda #$63
        sta PPUDATA

@clearOAMStagingAndReturn:
        lda #$00
        sta oamStagingLength
        jmp returnFromAnydasRender

anydasControllerInput:
        jsr pollController

; collectControllerEntropy:
        ; when buttons held: mess with 2 bytes for every button not held
        ; when buttons newly pressed: mess with same 2 bytes for every button not newly pressed

        ldy #$00 ; 0 or 1 to control loop
        lda heldButtons_player1
        beq @rotate ; skip if no buttons pressed
@newlyPressedAdd:
        sta generalCounter
        ldx #$08
@loop:
        dex
        bmi @checkNewlyPressed
        lsr generalCounter
        bcs @loop
        inc controllerEntropy
        dec controllerEntropy+4
        jmp @loop

@checkNewlyPressed:
        tya
        bne @rotate
        iny ; finished with loop after this
        lda newlyPressedButtons_player1
        bne @newlyPressedAdd

        ; always rotate bits and mess with another 2 bytes
@rotate:
        lda controllerEntropy+7
        lsr
        ror controllerEntropy
        ror controllerEntropy+1
        ror controllerEntropy+2
        ror controllerEntropy+3
        ror controllerEntropy+4
        ror controllerEntropy+5
        ror controllerEntropy+6
        ror controllerEntropy+7

        inc controllerEntropy+2
        dec controllerEntropy+6

; resume anydas render
        lda anydasInit
        bne @initialized
        lda #$10
        sta anydasDASValue
        lda #$06
        sta anydasARRValue
        lda #$0A
        sta levelOffset
        lda #$02 ; default to medium
        sta bigChance
        inc anydasInit
@initialized:
        lda gameMode
        cmp #$01
        beq @getInputs

; set tetris sound.  dump routine causes this to get skipped sometimes in og render routine
        lda renderMode
        cmp #$03 ; render_mode_play_and_demo
        bne @ret

        lda completedLines
        cmp tetrisSound ; 4 or 8 depending on bigFlag
        bne @ret

        ldx frameCounter
        dex ; use last frame's value
        txa
        and #$07
        bne @ret

        lda #$09
        sta soundEffectSlot1Init
@ret:
        rts

@getInputs:

        lda #BUTTON_DOWN
        jsr menuThrottle
        beq @downNotPressed
        lda #$01
        sta soundEffectSlot1Init
        inc anydasMenu
        lda anydasMenu
        cmp #$04
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
        lda #$03
        sta anydasMenu
@upNotPressed:


        lda #BUTTON_LEFT
        jsr menuThrottle
        beq @leftNotPressed
        lda #$01
        sta soundEffectSlot1Init
        ldx anydasMenu
        dec anydasDASValue,x
        lda anydasDASValue,x
        cmp #$FF
        bne @leftNotPressed
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

arrowOffsets:
        .byte $00,$20,$45,$65

anydasUpperLimit:
        .byte $32,$32,$02,$05


checkFor0Arr:
        lda     anydasARRValue
        beq     @zeroArr
        jmp     buttonHeldDown
@zeroArr:
        bit     bigFlag
        bmi     zeroArrForBig
        lda     heldButtons
        and     #BUTTON_RIGHT
        beq     @checkLeftPressed
@shiftRight:
        inc     tetriminoX
        jsr     isPositionValid
        bne     @shiftBackToLeft
        lda     #$03
        sta     soundEffectSlot1Init
        jmp     @shiftRight
@checkLeftPressed:
        lda     heldButtons
        and     #BUTTON_LEFT
        beq     @leftNotPressed
@shiftLeft:
        dec     tetriminoX
        jsr     isPositionValid
        bne     @shiftBackToRight
        lda     #$03
        sta     soundEffectSlot1Init
        jmp     @shiftLeft
@shiftBackToLeft:
        dec     tetriminoX
        dec     tetriminoX
@shiftBackToRight:
        inc     tetriminoX
        lda     #$01
        sta     autorepeatX
@leftNotPressed:
        rts

soundNeeded=generalCounter
yStash=generalCounter2
yBackup=generalCounter3
loopCounter=generalCounter4
abovePlayfield=generalCounter5
tablePointer=tmp3

shiftBackToLeft:
        dec  tetriminoX
        lda  $01
        sta  autorepeatX
        lda  soundNeeded
        beq  @storeSound
        lda  #$03
@storeSound:
        sta  soundEffectSlot1Init
        rts

zeroArrForBig:
        lda #$00
        sta soundNeeded
        lda currentPiece
        asl a
        asl a
        asl a
        sta tablePointer
        lda heldButtons
        and #BUTTON_RIGHT
        beq @checkLeftPressed
@shiftRight:
        inc tetriminoX

        lda tablePointer
        sta yBackup
        lda #$08
        sta loopCounter
@checkSquareRight:
        ldy yBackup
        lda zeroArrYRight,y
        clc
        adc tetriminoY
        sta abovePlayfield
        tax
        lda multBy10Table,x
        sta yStash
        lda zeroArrXRight,y
        clc
        adc tetriminoX
        cmp #$1e
        bcs shiftBackToLeft
        bit abovePlayfield
        bmi @skipCheckLeft
        tax
        lda tetriminoXPlayfieldTable,x
        sta playfieldAddr+1
        lda effectiveTetriminoXTable,x
        clc
        adc yStash
        tay
        lda (playfieldAddr),y
        bpl shiftBackToLeft
@skipCheckLeft:
        inc yBackup
        dec loopCounter
        bne @checkSquareRight
        inc soundNeeded
        bne @shiftRight

@checkLeftPressed:
        lda heldButtons
        and #BUTTON_LEFT
        beq @leftNotPressed

@shiftLeft:
        dec tetriminoX
        lda tablePointer
        sta yBackup
        lda #$08
        sta loopCounter
@checkSquareLeft:
        ldy yBackup
        lda zeroArrYLeft,y
        clc
        adc tetriminoY
        sta abovePlayfield
        tax
        lda multBy10Table,x
        sta yStash

        lda zeroArrXLeft,y
        clc
        adc tetriminoX
        bmi @shiftBackToRight
        bit abovePlayfield
        bmi @skipCheckRight
        tax
        lda tetriminoXPlayfieldTable,x
        sta playfieldAddr+1
        lda effectiveTetriminoXTable,x
        clc
        adc yStash
        tay
        lda (playfieldAddr),y
        bpl @shiftBackToRight
@skipCheckRight:
        inc yBackup
        dec loopCounter
        bne @checkSquareLeft
        inc soundNeeded
        bne @shiftLeft

@shiftBackToRight:
        inc tetriminoX
        lda #$01
        sta autorepeatX
        lda soundNeeded
        beq @storeSound
        lda #$03
@storeSound:
        sta soundEffectSlot1Init
@leftNotPressed:
        rts


renderByteBCD:
        ldx #$0
renderByteBCDStart:
        sta generalCounter
        cmp #200
        bcc @maybe100
        lda #2
        sta PPUDATA
        lda generalCounter
        sbc #200
        jmp @byte
@maybe100:
        cmp #100
        bcc @not100
        lda #1
        sta PPUDATA
        lda generalCounter
        sbc #100
        jmp @byte
@not100:
        cpx #0
        bne @main
        lda #$FF
        sta PPUDATA
@main:
        lda generalCounter
@byte:
        tax
        lda longerByteToBCDTable, x
        jmp twoDigsToPPU


longerByteToBCDTable: ; original goes to 49
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23
        .byte   $24,$25,$26,$27,$28,$29,$30,$31
        .byte   $32,$33,$34,$35,$36,$37,$38,$39
        .byte   $40,$41,$42,$43,$44,$45,$46,$47
        .byte   $48,$49
        ; 50 extra bytes is shorter than a conversion routine (and super fast)
        ; (used in renderByteBCD)
        .byte   $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99
