nmi:    pha
        txa
        pha
        tya
        pha
        jsr     renderAnydasMenu
        jsr     incrementWallHackScroll
        jsr     restore_top_part_scroll
        lda     #$00
        sta     OAMADDR
        lda     #$02
        sta     OAMDMA
        inc     frameCounter
        bne     :+
        inc     frameCounter+1
:
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        inc     verticalBlankingInterval

.repeat 20,index
        lda     tileHi+index
        sta     tileEraseHi+index
        lda     tileLo+index
        sta     tileEraseLo+index
.endrepeat

        lda     renderMode
        cmp     #$03
        bne     @noGameModeScroll
; this sorta works to change scrolling 
        ldy     #$3
        ldx     #$8E    
@loop:
        dex
        bne @loop
        dey
        bne @loop

        jsr     restore_ppu_scroll
@noGameModeScroll:
        lda     gameMode
        cmp     #$01
        bne     @endNmi


        ldy     #$5
        ldx     #$F0
@loop2:
        dex
        bne @loop2
        dey
        bne @loop2

        lda     frameCounter
        sta     PPUSCROLL
        lda     #$00
        sta     PPUSCROLL
        lda     currentPpuCtrl
        sta     PPUCTRL

        ldy     #$6
        ldx     #$EE    
@loop3:
        dex
        bne @loop3
        dey
        bne @loop3

        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     currentPpuCtrl
        sta     PPUCTRL

@endNmi:

        lda     sleepCounter
        beq     @jumpOverDecrement
        dec     sleepCounter
@jumpOverDecrement:

        jsr     anydasControllerInput
        pla
        tay
        pla
        tax
        pla
irq:    rti




yIndexes:
    .byte  $27,$27,$27,$27,$2f,$2f,$2f,$37,$37,$37,$37,$3f,$3f,$3f,$47,$47,$47,$47,$4f,$4f,$4f,$4f,$4f,$4f,$57,$57,$57,$57,$5f,$5f,$5f,$5f,$5f,$67,$67,$67,$67,$6f,$6f,$6f,$6f
xIndexes:
    .byte  $00,$08,$f0,$f8,$00,$f0,$f8,$00,$08,$f0,$f8,$00,$f0,$f8,$00,$e8,$f0,$f8,$00,$08,$10,$e8,$f0,$f8,$00,$08,$f0,$f8,$00,$08,$10,$f0,$f8,$00,$08,$f0,$f8,$00,$08,$f0,$f8
tileIndexes:
    .byte  $90,$a1,$a0,$91,$82,$62,$82,$90,$73,$72,$62,$72,$72,$72,$82,$62,$82,$72,$90,$81,$83,$a0,$91,$82,$82,$62,$82,$62,$80,$43,$83,$62,$40,$83,$82,$72,$82,$60,$61,$a0,$83

stageTitleSprites:
        ldx     #((xIndexes-yIndexes)-1)
        ldy     #$00
@loop:
        lda     yIndexes,x
        sta     oamStaging,y
        lda     tileIndexes,x
        sta     oamStaging+1,y
        lda     #$02
        sta     oamStaging+2,y
        lda     xIndexes,x
        sta     oamStaging+3,y
        iny
        iny
        iny
        iny
        dex
        bpl     @loop
        rts