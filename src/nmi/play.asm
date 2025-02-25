render_mode_play_and_demo:
        lda     player1_playState
        cmp     #$04
        bne     @playStateNotDisplayLineClearingAnimation
.ifdef PLAYFIELD_TOGGLE
        lda     playfieldAddr+1
.else
        lda     #$04
.endif
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
.ifdef PLAYFIELD_TOGGLE
        lda     playfieldAddr+1
.else
        lda     #$04
.endif
        sta     playfieldAddr+1
.ifdef TRIPLEWIDE
        .repeat 12
        nop
        .endrepeat
.else
        jsr     copyPlayfieldRowToVRAM
        jsr     copyPlayfieldRowToVRAM
.ifdef TALLER
        jsr     copyPlayfieldRowToVRAM3Times
        jmp     @carryOn
.else
        jsr     copyPlayfieldRowToVRAM
        jsr     copyPlayfieldRowToVRAM
.endif
.endif
@carryOn:
        lda     vramRow
        sta     player1_vramRow
@renderPlayer2Playfield:
        lda     numberOfPlayers
        cmp     #$02
        bne     @renderLines
        lda     player2_playState
        cmp     #$04
        bne     @player2PlayStateNotDisplayLineClearingAnimation
.ifdef PLAYFIELD_TOGGLE
        lda     playfieldAddr+1
.else
        lda     #$05
.endif
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
.ifdef PLAYFIELD_TOGGLE
        lda     playfieldAddr+1
.else
        lda     #$05
.endif
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
.ifdef TALLER
        lda     #$20
        sta     PPUADDR
        lda     #$53
.else
        lda     #$20
        sta     PPUADDR
.ifdef TWELVE
        lda     #$72
.elseif .defined(TRIPLEWIDE)
        lda     #$54
.else
        lda     #$73
.endif
.endif
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
.ifdef ANYDAS
.ifdef TRIPLEWIDE
        lda     #$20
        sta     PPUADDR
        lda     #$49
.else
        lda     #$22
        sta     PPUADDR
        lda     #$B9
.endif
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
.else
        ldx     player1_levelNumber
        lda     levelDisplayTable,x
        sta     generalCounter
.ifdef TRIPLEWIDE
        lda     #$20
        sta     PPUADDR
        lda     #$4A
.else
        lda     #$22
        sta     PPUADDR
        lda     #$BA
.endif
        sta     PPUADDR
        lda     generalCounter
        jsr     twoDigsToPPU
.endif
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
.ifdef TRIPLEWIDE
        lda     #$20
        sta     PPUADDR
        lda     #$58
.else
        lda     #$21
        sta     PPUADDR
        lda     #$18
.endif
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
        cmp     #$02
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
.ifdef CNROM
        ; 969b
        ; Very important to reset PPUCTRL
        ; Relevant conversation in NESDEV discord
        ; https://discord.com/channels/352252932953079811/745626657439744011/1106210182125592666
        lda     currentPpuCtrl
        sta     PPUCTRL
        ldy     #$00
        sty     PPUSCROLL
        sty     PPUSCROLL
        nop
        ; 96a9
.else
        ldy     #$00
.ifdef SCROLLTRIS
        ldy     ppuScrollX
        sty     PPUSCROLL
        nop
        nop
        ldy     ppuScrollY
        sty     PPUSCROLL
.else
        sty     ppuScrollX
        sty     PPUSCROLL
        ldy     #$00
        sty     ppuScrollY
        sty     PPUSCROLL
.endif

.endif
        rts

pieceToPpuStatAddr:
.ifdef TWELVE
        .dbyt   $2184,$21C4,$2204,$2244
        .dbyt   $2284,$22C4,$2304
.elseif .defined(TRIPLEWIDE)

        .dbyt   $0000,$0000,$0000,$0000
        .dbyt   $0000,$0000,$0000
.else
        .dbyt   $2186,$21C6,$2206,$2246
        .dbyt   $2286,$22C6,$2306
.endif
levelDisplayTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$10,$11,$12,$13,$14,$15
        .byte   $16,$17,$18,$19,$20,$21,$22,$23
        .byte   $24,$25,$26,$27,$28,$29
.ifdef TALLER
unusedMultBy10Table:
.else
.ifdef TRIPLEWIDE
unusedMultBy10Table:
.else
multBy10Table:
.endif
.endif
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE
; addresses
.ifdef TALLER
.elseif .defined(TRIPLEWIDE)
.else
vramPlayfieldRows:
.endif
        .word   $20C6,$20E6,$2106,$2126
        .word   $2146,$2166,$2186,$21A6
        .word   $21C6,$21E6,$2206,$2226
        .word   $2246,$2266,$2286,$22A6
        .word   $22C6,$22E6,$2306,$2326
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

copyPlayfieldRowToVRAM:
        ldx     vramRow
.ifdef TALLER
        cpx     #$19
.else
        cpx     #$15
.endif
        bpl     @ret
.ifdef TWELVE
        lda     multBy12Table,x
.else
        lda     multBy10Table,x
.endif
.ifdef UPSIDEDOWN
        clc
        adc     #$9
.endif
        tay
        txa
.ifdef UPSIDEDOWN
        lda      #$13
        sec
        sbc     vramRow
.endif
        asl     a
        tax
.ifdef  UPSIDEDOWN
        ; this nonsense is to shave a few cycles
        lda     vramPlayfieldRows+1,x
.else
        inx
        lda     vramPlayfieldRows,x
.endif
        sta     PPUADDR
.ifdef UPSIDEDOWN
        ; this nonsense is also to shave a few cycles
        jmp @onePlayer
.else
        dex
.endif
        lda     numberOfPlayers
        cmp     #$01
        beq     @onePlayer
        lda     playfieldAddr+1
        cmp     #$05
        beq     @playerTwo
        lda     vramPlayfieldRows,x
        sec
        sbc     #$02
        sta     PPUADDR
        jmp     @copyRow

@playerTwo:
.ifndef UPSIDEDOWN
        lda     vramPlayfieldRows,x
        clc
        adc     #$0C
        sta     PPUADDR
        jmp     @copyRow
.endif

@onePlayer:
        lda     vramPlayfieldRows,x
        clc
.ifdef TWELVE
        adc     #$04
.else
        adc     #$06
.endif
        sta     PPUADDR
@copyRow:
.ifdef TWELVE
        ldx     #$0C
.else
        ldx     #$0A
.endif
@copyByte:
        lda     (playfieldAddr),y
        sta     PPUDATA
.ifdef UPSIDEDOWN
        dey
.else
        iny
.endif
        dex
        bne     @copyByte
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

.ifdef UPSIDEDOWN
        .byte $00,$00,$00
.endif

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
