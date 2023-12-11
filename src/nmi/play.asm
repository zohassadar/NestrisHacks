render_mode_play_and_demo:
        lda     player1_playState
        cmp     #$04
        bne     @playStateNotDisplayLineClearingAnimation
        lda     #$04
        sta     playfieldAddr+1
        lda     player1_rowY
        sta     rowY
        lda     player1_completedRow
        sta     completedRow
        lda     player1_completedRow+1
        sta     completedRow+1
        lda     player1_completedRow+2
        sta     completedRow+2
        lda     player1_completedRow+3
        sta     completedRow+3
        lda     player1_playState
        sta     playState
        jsr     updateLineClearingAnimation
        lda     rowY
        sta     player1_rowY
        lda     playState
        sta     player1_playState
        lda     #$00
        sta     player1_vramRow
        jmp     @renderPlayer2Playfield

@playStateNotDisplayLineClearingAnimation:
        lda     player1_vramRow
        sta     vramRow
        lda     #$04
        sta     playfieldAddr+1
        jsr     copyPlayfieldColumnToVRAM
        ; jsr     copyPlayfieldRowToVRAM
        ; jsr     copyPlayfieldRowToVRAM
        ; jsr     copyPlayfieldRowToVRAM
        lda     vramRow
        sta     player1_vramRow

        rts
@renderPlayer2Playfield:
        lda     numberOfPlayers
        cmp     #$02
        bne     @renderLines
        lda     player2_playState
        cmp     #$04
        bne     @player2PlayStateNotDisplayLineClearingAnimation
        lda     #$05
        sta     playfieldAddr+1
        lda     player2_rowY
        sta     rowY
        lda     player2_completedRow
        sta     completedRow
        lda     player2_completedRow+1
        sta     completedRow+1
        lda     player2_completedRow+2
        sta     completedRow+2
        lda     player2_completedRow+3
        sta     completedRow+3
        lda     player2_playState
        sta     playState
        jsr     updateLineClearingAnimation
        lda     rowY
        sta     player2_rowY
        lda     playState
        sta     player2_playState
        lda     #$00
        sta     player2_vramRow
        jmp     @renderLines

@player2PlayStateNotDisplayLineClearingAnimation:
        lda     player2_vramRow
        sta     vramRow
        lda     #$05
        sta     playfieldAddr+1
        jsr     copyPlayfieldRowToVRAM
        jsr     copyPlayfieldRowToVRAM
        jsr     copyPlayfieldRowToVRAM
        jsr     copyPlayfieldRowToVRAM
        lda     vramRow
        sta     player2_vramRow
@renderLines:
        lda     outOfDateRenderFlags
        and     #$01
        beq     @renderLevel
        lda     numberOfPlayers
        cmp     #$02
        beq     @renderLinesTwoPlayers
        lda     #$20
        sta     PPUADDR
        lda     #$70
        sta     PPUADDR
        lda     player1_lines+1
        sta     PPUDATA
        lda     player1_lines
        jsr     twoDigsToPPU
        lda     outOfDateRenderFlags
        and     #$FE
        sta     outOfDateRenderFlags
        jmp     @renderLevel

@renderLinesTwoPlayers:
        lda     #$20
        sta     PPUADDR
        lda     #$68
        sta     PPUADDR
        lda     player1_lines+1
        sta     PPUDATA
        lda     player1_lines
        jsr     twoDigsToPPU
        lda     #$20
        sta     PPUADDR
        lda     #$7A
        sta     PPUADDR
        lda     player2_lines+1
        sta     PPUDATA
        lda     player2_lines
        jsr     twoDigsToPPU
        lda     outOfDateRenderFlags
        and     #$FE
        sta     outOfDateRenderFlags
@renderLevel:
        lda     outOfDateRenderFlags
        and     #$02
        beq     @renderScore
        lda     numberOfPlayers
        cmp     #$02
        beq     @renderScore
        lda     #$20
        sta     PPUADDR
        lda     #$64
        sta     PPUADDR
        lda     player1_levelNumber
        jsr     renderByteBCD
        sec
        bcs     @skipthis
        nop
        nop
        nop
        nop
@skipthis:
        jsr     updatePaletteForLevel
        lda     outOfDateRenderFlags
        and     #$FD
        sta     outOfDateRenderFlags
@renderScore:
        lda     numberOfPlayers
        cmp     #$02
        beq     @renderStats
        lda     outOfDateRenderFlags
        and     #$04
        beq     @renderStats
        lda     #$24
        sta     PPUADDR
        lda     #$6e
        sta     PPUADDR
        lda     player1_score+2
        jsr     twoDigsToPPU
        lda     player1_score+1
        jsr     twoDigsToPPU
        lda     player1_score
        jsr     twoDigsToPPU
        lda     outOfDateRenderFlags
        and     #$FB
        sta     outOfDateRenderFlags
@renderStats:
        lda     numberOfPlayers
        bne     @renderTetrisFlashAndSound
        beq     @renderTetrisFlashAndSound
        lda     outOfDateRenderFlags
        and     #$40
        beq     @renderTetrisFlashAndSound
.if .defined(TALLER) .or .defined(ANYDAS)
        nop
        ldx     player1_currentPiece
        lda     tetriminoTypeFromOrientation,x
.else
        lda     #$00
        sta     tmpCurrentPiece
@renderPieceStat:
        lda     tmpCurrentPiece
.endif
        asl     a
        tax
        lda     pieceToPpuStatAddr,x
        sta     PPUADDR
        lda     pieceToPpuStatAddr+1,x
        sta     PPUADDR
        lda     statsByType+1,x
        sta     PPUDATA
        lda     statsByType,x
        jsr     twoDigsToPPU
.if .defined(TALLER) .or .defined(ANYDAS)
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
.else
        inc     tmpCurrentPiece
        lda     tmpCurrentPiece
        cmp     #$07
        bne     @renderPieceStat
.endif
        lda     outOfDateRenderFlags
        and     #$BF
        sta     outOfDateRenderFlags
@renderTetrisFlashAndSound:
        lda     #$3F
        sta     PPUADDR
        lda     #$0E
        sta     PPUADDR
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
        stx     PPUDATA
        rts

pieceToPpuStatAddr:
        .dbyt   $2186,$21C6,$2206,$2246
        .dbyt   $2286,$22C6,$2306
levelDisplayTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23
        .byte   $24,$25,$26,$27,$28,$29
.ifdef TALLER
unusedMultBy10Table:
.else
multBy10Table:
.endif
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE
; addresses
.ifdef TALLER
.else
vramPlayfieldRows:
.endif
        .word   $20C2,$20E2,$2102,$2122
        .word   $2142,$2162,$2182,$21A2
        .word   $21C2,$21E2,$2202,$2222
        .word   $2242,$2262,$2282,$22A2
        .word   $22C2,$22E2,$2302,$2322
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

mod64A:
        cmp #$40
        bcc @ret
        sec
        sbc #$40
        jmp mod64A
@ret:   rts

copyPlayfieldColumnToBuffer:
; start here
        lda     #$20
        sta     columnAddress+1
        lda     #$c0
        sta     columnAddress
; figure out which column to focus on
        ; render a column 40 tiles ahead (8 * 40 = $0140)
        lda     ppuScrollX
        clc
        adc     #$40
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

        lda     columnOffset
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
        lda     #$20
        sta     vramRow
@ret:   rts



copyPlayfieldColumnToVRAM:
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
        ldx     #$0B
        ldy     #$EF
@loop2:
        lda     tileEraseHi,x
        sta     PPUADDR
        lda     tileEraseLo,x
        sta     PPUADDR
        sty     PPUDATA
        dex
        bpl     @loop2

; ---------------------
        ldx     #$0B
@loop3:
        lda     tileHi,x
        sta     PPUADDR
        lda     tileLo,x
        sta     PPUADDR
        lda     tiles,x
        sta     PPUDATA
        dex
        bpl     @loop3
;---------------------
        lda     #$20
        sta     vramRow

;---------------------
        ldx     #$0B
@loop4:
        lda     tileHi,x
        sta     tileEraseHi,x
        lda     tileLo,x
        sta     tileEraseLo,x
        dex
        bpl     @loop4

        rts


counter := generalCounter2

yPos := generalCounter3
xPos := generalCounter4
tile := generalCounter5

stageSpriteForCurrentPiece:
        lda     #$00
        sta     tileBufferPosition
        sta     tileStartingOffset
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
        cmp     columnOffset
        bcs     @dontAdd
        lda     #$0A
        sta     tileStartingOffset
@dontAdd:
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
        pla
        sta     tileStartingOffset
        dec     counter
        bne     @loop
        rts

ppuAddressHi:
        .byte $20,$20,$21,$21,$21,$21,$21,$21,$21,$21,$22,$22,$22,$22,$22,$22,$22,$22,$23,$23
ppuAddressLo:
        .byte $c0,$e0,$00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20,$40,$60,$80,$a0,$c0,$e0,$00,$20


translatePieceIntoBuffer:
        lda     xPos
        clc
        adc    tileStartingOffset
        ; sta     tmp3
;         cmp     columnOffset
;         bcs     @dontAdd
;         clc
;         adc     #$0A
;         sta     tmp3
; @dontAdd:
        ; lda     tileBufferPosition
        ; ; lsr
        ; lsr
        ; tax
        ; lda     multBy10Table,x
        ; clc
        ; adc     tmp3
        sec
        sbc     columnOffset
        asl
        asl
        asl
        sta     tmp3    ; This should have the best first position to draw the tile

        ldy     yPos
        lda     ppuAddressHi,y
        sta     columnAddress+1
        lda     ppuAddressLo,y
        sta     columnAddress

        lda     ppuScrollX
        clc
        adc     tmp3
        sta     renderOffset
        lda     #$00
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
        sta     tiles,x
        inc     tileBufferPosition
        rts










copyPlayfieldRowToVRAM:
        ldx     vramRow
        cpx     #$15
        bpl     @ret
        lda     multBy10Table,x
        sta     generalCounter2
        txa
        asl     a
        tax
        lda     vramPlayfieldRows+1,x
        sta     PPUADDR
        lda     vramPlayfieldRows,x
        sta     PPUADDR
        lda     #$03
        sta     generalCounter
@copyRow:
        ldx     #$0A
        ldy     generalCounter2
@copyByte:
        lda     playfield,y
        sta     PPUDATA
        iny
        dex
        bne     @copyByte
        dec     generalCounter
        bne     @copyRow
        inc     vramRow
        lda     vramRow
.ifdef TALLER
        cmp     #$18
.else
        cmp     #$14
.endif
        bmi     @ret
        lda     #$20
        sta     vramRow
@ret:   rts

.ifdef PENGUIN
        .include "../hacks/penguin_line_clear.asm"
.else
        .include "line_clear_animation.asm"
.endif

; Set Background palette 2 and Sprite palette 2
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
        lda     #$00
        sta     generalCounter
@copyPalette:
        lda     #$3F
        sta     PPUADDR
        lda     #$08
        clc
        adc     generalCounter
        sta     PPUADDR
        lda     colorTable,x
        sta     PPUDATA
        lda     colorTable+1,x
        sta     PPUDATA
        lda     colorTable+1+1,x
        sta     PPUDATA
        lda     colorTable+1+1+1,x
        sta     PPUDATA
        lda     generalCounter
        clc
        adc     #$10
        sta     generalCounter
        cmp     #$20
        bne     @copyPalette
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
