render_mode_play_and_demo:
        ldx     #$00
        lda     completedLines
        cmp     #$04
        bne     @setPaletteColor
        lda     frameCounter
        and     #$03
        bne     @setPaletteColor
        ldx     #$30
        lda     frameCounter
        and     #$07
        bne     @setPaletteColor
        lda     #$09
        sta     soundEffectSlot1Init
@setPaletteColor:
        stx     backgroundColor

updatePaletteForLevel:
        lda     player1_levelNumber
@mod10: cmp     #$0A
        bmi     @copyPalettes
        sec
        sbc     #$0A
        jmp     @mod10
@copyPalettes:
        asl     a
        asl     a
        tax
        lda     colorTable,x
        sta     levelPalette
        lda     colorTable+1,x
        sta     levelPalette+1
        lda     colorTable+1+1,x
        sta     levelPalette+2
        lda     colorTable+1+1+1,x
        sta     levelPalette+3
        lda     generalCounter
        rts



levelDisplayTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23
        .byte   $24,$25,$26,$27,$28,$29

multBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE

vramPlayfieldRows:


twoDigsToPPU:
        sta     generalCounter
        and     #$F0
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        sta     PPUDATA
        lda     generalCounter
        and     #$0F
        sta     PPUDATA
        rts


multBy32TableLo:
        .byte $00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20,$40
multBy32TableHi:
        .byte $00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20,$40

mod10A:
        cmp #$0a
        bcc @ret
        sec
        sbc #$0a
        jmp mod10A
@ret:   rts

copyPlayfieldColumnToBuffer:
        ldx     player1_levelNumber
        lda     levelDisplayTable,x
        lsr
        lsr
        lsr
        lsr
        sta     levelTiles
        lda     levelDisplayTable,x
        and     #$0F
        sta     levelTiles+1


        lda     player1_lines+1
        sta     linesTiles
        lda     player1_lines
        lsr
        lsr
        lsr
        lsr
        sta     linesTiles+1
        lda     player1_lines
        and     #$0F
        sta     linesTiles+2

        lda     player1_score+2
        lsr
        lsr
        lsr
        lsr
        sta     scoreTiles
        lda     player1_score+2
        and     #$0F
        sta     scoreTiles+1
        lda     player1_score+1
        lsr
        lsr
        lsr
        lsr
        sta     scoreTiles+2
        lda     player1_score+1
        and     #$0F
        sta     scoreTiles+3
        lda     player1_score
        lsr
        lsr
        lsr
        lsr
        sta     scoreTiles+4
        lda     player1_score
        and     #$0F
        sta     scoreTiles+5

; start here
        lda     #$20
        sta     columnAddress+1
        lda     #$c0
        sta     columnAddress
; figure out which column to focus on
        ; render a column 40 tiles ahead (8 * 40 = $0140)
        lda     ppuScrollX
        clc
        adc     #$00
        sta     renderOffset
        lda     ppuScrollXHi
        adc     #$01
        lsr
        ; divide by 2 with bit from hi
        lda     renderOffset
        ror
        lsr
        lsr
        cmp     #$20
        bcc     @addToLowByte
        pha
        lda     #$04
        clc
        adc     columnAddress+1
        sta     columnAddress+1
        pla
        sec
        sbc     #$20
@addToLowByte:
        clc
        adc     columnAddress
        sta     columnAddress

        ; lda     currentPpuCtrl
        ; ora     #$04
        ; sta     PPUCTRL

        lda     columnAddress+1
        sta     stripeAddr+1
        lda     columnAddress
        sta     stripeAddr

        lda     #$03
        sta     playfieldAddr+1

        lda     columnOffset
        sec
        sbc     #$08
        bcs     @store
        clc
        adc     #$0A
@store:
        sta     playfieldAddr

        ldy     #$00
        ldx     #$13
@loop:
        lda     (playfieldAddr),y
        sta     stripe,x
        lda     playfieldAddr
        clc     
        adc     #$0A
        sta     playfieldAddr
        dex
        bpl     @loop
        lda     #$00
        sta     playfieldAddr
        inc     playfieldAddr+1
        lda     #$20
        sta     player1_vramRow
@ret:   rts



dump_render_buffer:
        lda     currentPpuCtrl
        ora     #$04
        sta     PPUCTRL
        lda     stripeAddr+1
        sta     PPUADDR
        lda     stripeAddr
        sta     PPUADDR
        ldx     #$13
@loop:
        lda     stripe,x
        sta     PPUDATA
        dex
        bpl     @loop
        lda     currentPpuCtrl
        sta     PPUCTRL

; ---------------------
        ldy     #$EF
.repeat 20,index
        lda     tileEraseHi+index
        sta     PPUADDR
        lda     tileEraseLo+index
        sta     PPUADDR
        sty     PPUDATA
.endrepeat

.repeat 20,index
        lda     tileHi+index
        sta     PPUADDR
        lda     tileLo+index
        sta     PPUADDR
        lda     tiles+index
        sta     PPUDATA
.endrepeat

        lda     #$20
        sta     PPUADDR
        lda     #$7C
        sta     PPUADDR
.repeat 3,index
        lda     linesTiles+index
        sta     PPUDATA
.endrepeat

        lda     #$24
        sta     PPUADDR
        lda     #$7A
        sta     PPUADDR
.repeat 2,index
        lda     levelTiles+index
        sta     PPUDATA
.endrepeat

        lda     #$20
        sta     PPUADDR
        lda     #$6f
        sta     PPUADDR
.repeat 6,index
        lda     scoreTiles+index
        sta     PPUDATA
.endrepeat

;---------------------
        lda     #$3F
        sta     PPUADDR
        lda     #$0E
        sta     PPUADDR
        lda     backgroundColor
        sta     PPUDATA

        lda     #$3F
        sta     PPUADDR
        lda     #$08
        sta     PPUADDR
.repeat 4,index
        lda     levelPalette+index
        sta     PPUDATA
.endrepeat

        lda     #$3F
        sta     PPUADDR
        lda     #$18
        sta     PPUADDR
.repeat 4,index
        lda     levelPalette+index
        sta     PPUDATA
.endrepeat

; .repeat 4,index
;         lda     animationHi+index
;         sta     PPUADDR
;         lda     animationLo+index
;         sta     PPUADDR
; .repeat 2,i
;         lda     animationTiles+i
;         sta     PPUDATA
; .endrepeat
; .endrepeat


@ret:   rts


counter := generalCounter2

yPos := generalCounter3
xPos := generalCounter4
tile := generalCounter5

stageSpriteForCurrentPiece:
        lda     #$00
        sta     tileBufferPosition
        sta     tileStartingOffset
        jsr     updateLineClearingAnimation
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter
        asl     a
        adc     generalCounter
        tax     ; x contains index into orientation table
        lda     #$04
        sta     counter ; iterate through all four minos
@stageMino:
        lda     orientationTable,x
        clc
        adc     tetriminoY
        pha
        inx
        lda     orientationTable,x
        pha ; stage block type of mino
        inx
        lda     orientationTable,x
        clc
        adc     tetriminoX
        tay
        lda     effectiveTetriminoXTable,y
        pha
        inx
        dec     counter
        bne     @stageMino

        lda     #$04
        sta     counter
@loop:
        pla
        sta     xPos
        pla 
        sta     tile
        pla
        sta     yPos
        jsr     translatePieceIntoBuffer
        lda     tileStartingOffset
        pha
        clc
        adc     #$0A
        sta     tileStartingOffset
        jsr     translatePieceIntoBuffer
        lda     tileStartingOffset
        clc
        adc     #$0A
        sta     tileStartingOffset
        jsr     translatePieceIntoBuffer
        lda     tileStartingOffset
        clc
        adc     #$0A
        sta     tileStartingOffset
        jsr     translatePieceIntoBuffer
        lda     tileStartingOffset
        clc
        adc     #$0A
        sta     tileStartingOffset
        jsr     translatePieceIntoBuffer
        pla
        sta     tileStartingOffset
        dec     counter
        bne     @loop
        lda     #$20
        sta     player1_vramRow
        sta     vramRow
        ; lda     playState
        ; cmp     #$04
        ; bne     @ret
        ; inc     playState
@ret:    rts


offsetPpuAddresHi:
        .byte $20,$20
ppuAddressHi:
        .byte $20,$20,$21,$21,$21,$21,$21,$21,$21,$21,$22,$22,$22,$22,$22,$22,$22,$22,$23,$23

offsetPpuAddresLo:
        .byte $40,$40
ppuAddressLo:
        .byte $c0,$e0,$00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20

updateLineClearingAnimation:
        lda     playState
        cmp     #$04
        beq     @animation
        ; placeholder
        rts

@animation:
        dec     rowY
        beq     @finish
        rts

@finish:
        inc     playState
        lda     #$00
        sta     incrementSpeed
        rts

clearEmptyQueue:
        lda     #$24
        ldx     #$13
@loop:
        sta     tileEraseHi,x
        dex
        bpl     @loop

        lda     #$42
        ldx     #$13
@loop2:
        sta     tileEraseLo,x
        dex
        bpl     @loop2
        rts



resetStagingBuffer:
        lda     #$24
        ldx     #$13
@loop:
        sta     tileHi,x
        dex
        bpl     @loop

        lda     #$42
        ldx     #$13
@loop2:
        sta     tileLo,x
        dex
        bpl     @loop2


        lda     #$EF
        ldx     #$13
@loop3:
        sta     tiles,x
        dex
        bpl     @loop3
        rts


translatePieceIntoBuffer:
        lda     xPos
        clc
        adc    tileStartingOffset
        sec
        sbc     columnOffset
        asl
        asl
        clc
        asl
        sta     tmp3    ; This should have the best first position to draw the tile
        lda     #$00
        rol
        pha

        lda     yPos
        clc
        adc     #$02
        tay
        lda     offsetPpuAddresHi,y
        sta     columnAddress+1
        lda     offsetPpuAddresLo,y
        sta     columnAddress

        lda     ppuScrollX
        clc
        adc     tmp3
        sta     renderOffset
        pla
        adc     ppuScrollXHi
        lsr
        ; divide by 2 with bit from hi
        lda     renderOffset
        ror
        lsr
        lsr
        cmp     #$20
        bcc     @addToLowByte
        pha
        lda     #$04
        clc
        adc     columnAddress+1
        sta     columnAddress+1
        pla
        sec
        sbc     #$20
@addToLowByte:
        clc
        adc     columnAddress
        sta     columnAddress
        ldx     tileBufferPosition
        lda     columnAddress
        sta     tileLo,x
        lda     columnAddress+1
        sta     tileHi,x
        lda     tile
        cpy     #$02
        bcs     @store
        lda     #$ef
@store:
        sta     tiles,x
        inc     tileBufferPosition
        rts




copyPlayfieldToRenderRam:
        ldx #0
@loop:
        lda     playfield,x
        sta     renderedPlayfield,x
        inx
        cpx     #200
        bne     @loop
        rts


renderEntirePlayfield:
        lda     #$04
        sta     playfieldAddr+1
        lda     #$00
        sta     playfieldAddr
        lda     #$00
        sta     counter
        ldx     #$00
@loop:
        ldx     #$20
        ldy     counter 
        lda     ppuAddressHi,y
        sta     PPUADDR
        lda     ppuAddressLo,y
        sta     PPUADDR
        ldy     #$00
@innerLoop:
        lda     (playfieldAddr),y
        sta     PPUDATA
        iny
        cpy     #$0a
        bne     @noresetY
        ldy     #$00
@noresetY:
        dex
        bne     @innerLoop
        lda     playfieldAddr
        clc
        adc     #$0A
        sta     playfieldAddr
        inc     counter
        lda     counter
        cmp     #$14
        bne     @loop
        lda     #$00
        sta     playfieldAddr
        sta     counter
        lda     #$00
        sta     PPUADDR
        sta     PPUADDR
        rts






; 4 bytes per level (bg, fg, c3, c4)
colorTable:
        .dbyt   $0F30,$2112,$0F30,$291A
        .dbyt   $0F30,$2414,$0F30,$2A12
        .dbyt   $0F30,$2B15,$0F30,$222B
        .dbyt   $0F30,$0016,$0F30,$0513
        .dbyt   $0F30,$1612,$0F30,$2716
; This increment and clamping is performed in copyPlayfieldRowToVRAM instead of here
noop_disabledVramRowIncr:
        rts

        inc     player1_vramRow
        lda     player1_vramRow
        cmp     #$14
        bmi     @player2
        lda     #$20
        sta     player1_vramRow
@player2:
        inc     player2_vramRow
        lda     player2_vramRow
        cmp     #$14
        bmi     @ret
        lda     #$20
        sta     player2_vramRow
@ret:   rts
