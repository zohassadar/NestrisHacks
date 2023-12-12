gameMode_gameTypeMenu:
.ifdef CNROM
        ; 82d1
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        ; 82d9
.else
        inc     initRam
        lda     #$12
        jsr     setMMC1Control
.endif
        lda     #$01
        sta     renderMode
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
        jsr     bulkCopyToPpu
        .addr   menu_palette
        jsr     copyRleNametableToPpu
        .addr   game_type_menu_nametable
.ifdef CNROM
        ; 82ed
        nop     ; padded out for GG codes & mods
        lda     #CNROM_BANK0
        ldy     #CNROM_BG0
        ldx     #CNROM_SPRITE0
        jsr     changeCHRBank0
        ; 82f7
.else
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
.endif
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        ldx     musicType
        lda     musicSelectionTable,x
        jsr     setMusicTrack
L830B:  lda     #$FF
        ldx     #$02
        ldy     #$02
        jsr     memset_page
        lda     newlyPressedButtons_player1
        cmp     #$01
        bne     @rightNotPressed
        lda     #$01
        sta     gameType
        lda     #$01
        sta     soundEffectSlot1Init
        jmp     @leftNotPressed

@rightNotPressed:
        lda     newlyPressedButtons_player1
        cmp     #$02
        bne     @leftNotPressed
        lda     #$00
        sta     gameType
        lda     #$01
        sta     soundEffectSlot1Init
@leftNotPressed:
        lda     newlyPressedButtons_player1
        cmp     #$04
        bne     @downNotPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     musicType
        cmp     #$03
        beq     @upNotPressed
        inc     musicType
        ldx     musicType
        lda     musicSelectionTable,x
        jsr     setMusicTrack
@downNotPressed:
        lda     newlyPressedButtons_player1
        cmp     #$08
        bne     @upNotPressed
        lda     #$01
        sta     soundEffectSlot1Init
        lda     musicType
        beq     @upNotPressed
        dec     musicType
        ldx     musicType
        lda     musicSelectionTable,x
        jsr     setMusicTrack
@upNotPressed:
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     @startNotPressed
        lda     #$02
        sta     soundEffectSlot1Init
        inc     gameMode
        rts

@startNotPressed:
        lda     newlyPressedButtons_player1
        cmp     #$40
        bne     @bNotPressed
        lda     #$02
        sta     soundEffectSlot1Init
        lda     #$00
        sta     frameCounter+1
        dec     gameMode
        rts

@bNotPressed:
        ldy     #$00
        lda     gameType
        asl     a
        sta     generalCounter
        asl     a
        adc     generalCounter
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     #$3F
        sta     spriteXOffset
        lda     #$3F
        sta     spriteYOffset
        lda     #$01
        sta     spriteIndexInOamContentLookup
        lda     frameCounter
        and     #$03
        bne     @flickerCursorPair1
        lda     #$02
        sta     spriteIndexInOamContentLookup
@flickerCursorPair1:
        jsr     loadSpriteIntoOamStaging
        lda     musicType
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     #$8F
        sta     spriteYOffset
        lda     #$53
        sta     spriteIndexInOamContentLookup
        lda     #$67
        sta     spriteXOffset
        lda     frameCounter
        and     #$03
        bne     @flickerCursorPair2
        lda     #$02
        sta     spriteIndexInOamContentLookup
@flickerCursorPair2:
        jsr     loadSpriteIntoOamStaging
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jmp     L830B
