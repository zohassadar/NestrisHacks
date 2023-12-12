gameMode_titleScreen:
        jsr     updateAudio2
        lda     #$00
        sta     renderMode
        sta     $D0
        sta     displayNextPiece
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
.ifdef CNROM
        ; 8260
        nop     ; padded out for GG codes & mods
        lda     #CNROM_BANK0
        ldy     #CNROM_BG0
        ldx     #CNROM_SPRITE0
        jsr     changeCHRBank0
        ; 826a
.else
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
.endif
        jsr     bulkCopyToPpu
        .addr   menu_palette
        jsr     copyRleNametableToPpu
        .addr   title_screen_nametable
        lda     #$24
        sta     addrOff
        jsr     copyRleNametableToPpuOffset
        .addr   title_screen_nametable
        lda     #$00
        sta     addrOff
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$00
        ldx     #$02
        ldy     #$02
        jsr     memset_page
        lda     #$00
        sta     frameCounter+1
@waitForStartButton:
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     newlyPressedButtons_player1
        cmp     #$10
        beq     @startButtonPressed
        lda     frameCounter+1
        cmp     #$05
.ifdef ANYDAS
        beq     @dontGoToTimeout
@dontGoToTimeout:
.else
        beq     @timeout
.endif
        jmp     @waitForStartButton

; Show menu screens
@startButtonPressed:
        lda     #$02
        sta     soundEffectSlot1Init
        inc     gameMode
        rts

; Start demo
@timeout:
        lda     #$02
        sta     soundEffectSlot1Init
        lda     #$06
        sta     gameMode
        rts