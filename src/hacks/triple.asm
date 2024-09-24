initTripleWide:
    lda     #$2C     ; glitch uses lower left nametable, no need to fix
    jsr     LAA82
    jsr bulkCopyToPpu
    .addr triplewide_nt
    rts

triplewide_nt:
    .byte $2C,$80,$D9,$33 ; left border
    .byte $2C,$9F,$D9,$34 ; right border
    .byte $2F,$A0,$01,$35 ; lower left corner
    .byte $2F,$BF,$01,$37 ; lower right corner
    .byte $2F,$A1,$5E,$36 ; bottom border
    .byte $2F,$C0,$48,$FF ; info attributes
    .byte $2F,$C8,$78,$AA ; playfield attributes
    .byte $FF

tripleWideVramRowsHi:
        .byte   $20,$20,$20,$20
        .byte   $21,$21,$21,$21
        .byte   $21,$21,$21,$21
        .byte   $22,$22,$22,$22
        .byte   $22,$22,$22,$22
        .byte   $23,$23,$23,$23
        .byte   $23,$00,$00,$00
        .byte   $00

tripleWideVramRowsLo:
        .byte   $81,$a1,$c1,$e1
        .byte   $01,$21,$41,$61
        .byte   $81,$a1,$c1,$e1
        .byte   $01,$21,$41,$61
        .byte   $81,$a1,$c1,$e1
        .byte   $01,$21,$41,$61
        .byte   $81,$00,$00,$00
        .byte   $00

dataAddresses:
        .byte  <row1Data
        .byte  <row2Data
        .byte  <row3Data
        .byte  <row4Data
        .byte  <row5Data

render_mode_play_and_demo_or_dump:
        lda     vramDumpNeeded
        beq     @ret
        jmp     vramRowDump
@ret:
        jmp     render_mode_play_and_demo

stageSpriteThenVramRows:
        jsr stageSpriteForCurrentPiece

stageVramRows:
        ldx     vramRow
        cpx     #$20
        bne     @carryOn
        jmp     @ret
@carryOn:
        inc     vramDumpNeeded
        lda     #$00
        sta     generalCounter5  ; counts to 5 and quits

        lda     tripleWideVramRowsHi,x
        sta     row1Address
        lda     tripleWideVramRowsLo,x
        sta     row1Address+1

        lda     tripleWideVramRowsHi+1,x
        sta     row2Address
        lda     tripleWideVramRowsLo+1,x
        sta     row2Address+1

        lda     tripleWideVramRowsHi+2,x
        sta     row3Address
        lda     tripleWideVramRowsLo+2,x
        sta     row3Address+1

        lda     tripleWideVramRowsHi+3,x
        sta     row4Address
        lda     tripleWideVramRowsLo+3,x
        sta     row4Address+1

        lda     tripleWideVramRowsHi+4,x
        sta     row5Address
        lda     tripleWideVramRowsLo+4,x
        sta     row5Address+1

@copyPlayfieldData:
        ldy     generalCounter5
        ldx     dataAddresses,y

        lda     vramRow
        asl
        sta     generalCounter
        asl
        asl
        adc     generalCounter ; carry clear from asl
        tay     ; y contains index into playfield

        lda     #$0A
        sta     generalCounter2
@copyLoop:
        lda     leftPlayfield,y
        sta     stack,x
        lda     centerPlayfield,y
        sta     stack+10,x
        lda     rightPlayfield,y
        sta     stack+20,x
        inx
        iny
        dec     generalCounter2
        bne     @copyLoop

        inc     vramRow
        lda     vramRow
        cmp     #$1A
        beq     @vramRowsFinished
        inc     generalCounter5
        lda     generalCounter5
        cmp     #$05
        beq     @ret
        bne     @copyPlayfieldData
@vramRowsFinished:
        lda     #$20
        sta     vramRow
@ret:
        rts

vramRowDump:
        tsx
        stx     generalCounter
        ldx     #$FF
        txs
        .repeat 5
        pla
        sta     PPUADDR
        pla
        sta     PPUADDR
        .repeat 30
        pla
        sta     PPUDATA
        .endrepeat
        .endrepeat
        ldx     generalCounter
        txs
        lda     #$00
        sta     vramDumpNeeded
        rts
