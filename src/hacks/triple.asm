.ifdef TRIPLEWIDE
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
    .byte $2C,$44,$04,$1D,$22,$19,$0E ; "TYPE"
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


.endif

.ifdef BIGMODE30


tripleWideVramRowsHi:
        .byte   $20,$20,$20
        .byte   $21,$21,$21,$21
        .byte   $21,$21,$21,$21
        .byte   $22,$22,$22,$22
        .byte   $22,$22,$22,$22
        .byte   $23,$23,$23,$23
        .byte   $23,$00,$00,$00
        .byte   $00,$00
        .byte   $00,$00

tripleWideVramRowsLo:
        .byte   $a1,$c1,$e1
        .byte   $01,$21,$41,$61
        .byte   $81,$a1,$c1,$e1
        .byte   $01,$21,$41,$61
        .byte   $81,$a1,$c1,$e1
        .byte   $01,$21,$41,$61
        .byte   $81,$00,$00,$00
        .byte   $00,$00
        .byte   $00,$00



initBigMode30:
    lda     #$2C     ; glitch uses lower left nametable, no need to fix
    jsr     LAA82
    jsr bulkCopyToPpu
    .addr bigmode30_nt
    rts

bigmode30_nt:
    .byte $2C,$81,$5E,$31 ; top border
    .byte $2C,$80,$01,$30 ; top left corner
    .byte $2C,$9F,$01,$32 ; top right corner
    .byte $2C,$A0,$D9,$33 ; left border
    .byte $2C,$BF,$D9,$34 ; right border
    .byte $2F,$A0,$01,$35 ; lower left corner
    .byte $2F,$BF,$01,$37 ; lower right corner
    .byte $2F,$A1,$5E,$36 ; bottom border
    .byte $2C,$44,$04,$1D,$22,$19,$0E ; "TYPE"
    .byte $2F,$C0,$48,$FF ; info attributes
    .byte $2F,$C8,$78,$AA ; playfield attributes
    .byte $FF


dataAddresses:
        .byte  <row1Data
        .byte  <row2Data
        .byte  <row3Data
        .byte  <row4Data
        .byte  <row5Data
        .byte  <row6Data

render_mode_play_and_demo_or_dump:
        lda     playState
        cmp     #$04
        beq     @ret
        lda     vramDumpNeeded
        beq     @ret
        jmp     vramRowDump
@ret:
        jmp     render_mode_play_and_demo

stageSpriteForCurrentPiece:
        jsr stageSpriteForCurrentPieceBigMode30

stageVramRows:
        lda     vramRow
        cmp     #$20
        bne     @carryOn
        jmp     @ret
@carryOn:
        inc     vramDumpNeeded
        lda     #$00
        sta     generalCounter5  ; counts to 6 and quits

        lda     vramRow
        asl
        tax

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

        lda     tripleWideVramRowsHi+5,x
        sta     row6Address
        lda     tripleWideVramRowsLo+5,x
        sta     row6Address+1

@copyPlayfieldData:
        ldy     generalCounter5
        ldx     dataAddresses,y

        tya
        and      #$01
        asl
        asl
        asl
        asl
        sta     generalCounter3
        tya
        lsr
        clc
        adc     vramRow
        tay
        lda     multBy15Table,y
        tay
        lda     #$0F
        sta     generalCounter2
        clc
@copyLoop:
        lda     playfield,y
        adc     generalCounter3
        sta     stack,x
        adc     #$01
        sta     stack+1,x
        inx
        inx
        iny
        dec     generalCounter2
        bne     @copyLoop

        inc     generalCounter5
        lda     generalCounter5
        cmp     #$06
        bne     @copyPlayfieldData
        lda     vramRow
        clc
        adc     #$03
        sta     vramRow
        cmp     #$0C
        bcc     @ret
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
        .repeat 6
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
.endif



.ifdef TRIPLEWIDE
dataAddresses:
        .byte  <row1Data
        .byte  <row2Data
        .byte  <row3Data
        .byte  <row4Data
        .byte  <row5Data

render_mode_play_and_demo_or_dump:
        lda     playState
        cmp     #$04
        beq     @ret
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


effectiveTetriminoXTable:
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09

tetriminoXPlayfieldTable:
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
        .byte   $05,$05,$05,$05,$05,$05,$05,$05,$05,$05

isPositionValid:
        lda     currentPiece
        asl     a
        asl     a
        sta     generalCounter2
        asl     a
        clc
        adc     generalCounter2
        tax
        lda     #$04
        ldy     #$00
        sta     generalCounter3
@newcheckSquare:
; reset check to zero
        lda    #$00
        sta    topRowValidityCheck
        lda     orientationTable,x
        clc
        adc     tetriminoY
        adc     #$02
        cmp     #$1B
        bcs     @invalid
        clc
        lda     tetriminoY
        adc     orientationTable,x
        sta     generalCounter4

; Set 1 if tetriminoY with offset is negative -1 or negative -2
        cmp     #$FE
        bcc     @yOffsetIsNotNegative
        lda     topRowValidityCheck
        ora     #$01
        sta     topRowValidityCheck
@yOffsetIsNotNegative:
        lda     generalCounter4
        asl     a
        sta     generalCounter4
        asl     a
        asl     a
        adc     generalCounter4
        sta     generalCounter4
        inx
        inx
        lda     tetriminoX
        clc
        adc     orientationTable,x

; Invalid if TetriminoX with offset applied is between 0 and 29
        cmp     #$1e
        bcs     @invalid
        tay
        lda     tetriminoXPlayfieldTable,y
        sta     playfieldAddr+1
        lda     effectiveTetriminoXTable,y
        sta     effectiveTetriminoX


        lda     generalCounter4
        clc
        adc     effectiveTetriminoX
        tay
        lda     (playfieldAddr),y
        cmp     #$EF
        bne     @invalidByCollision

@notActuallyInvalid:
        inx
        dec     generalCounter3
        bne     @newcheckSquare

        lda     #$00
        rts

@invalidByCollision:
        ; Set 2 if invalid due to collision (x is between 0 and 29 and Y is negative)
        lda     topRowValidityCheck
        ora     #$02
        cmp     #$03
        beq     @notActuallyInvalid

@invalid:
        lda     #$FF
        rts


.repeat 21
nop
.endrepeat
.endif
