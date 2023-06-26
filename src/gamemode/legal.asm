gameMode_legalScreen:
        jsr     updateAudio2
        lda     #$00
        sta     renderMode
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
.ifdef CNROM
        ; 820d
        nop     ; padded out for GG codes & mods
        lda     #CNROM_BANK0
        ldy     #CNROM_BG0
        ldx     #CNROM_SPRITE0
        jsr     changeCHRBank0
        ; 8217
.else
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
.endif
        jsr     bulkCopyToPpu
        .addr   legal_screen_palette
        jsr     bulkCopyToPpu
        .addr   legal_screen_nametable
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$00
        ldx     #$02
        ldy     #$02
        jsr     memset_page
.if .defined(SKIPPABLE_LEGAL) | .defined(AEPPOZ) | .defined(B_TYPE_DEBUG)
        lda     #$00
.else
        lda     #$FF
.endif
        jsr     sleep_for_a_vblanks
        lda     #$FF
        sta     generalCounter
@waitForStartButton:
        lda     newlyPressedButtons_player1
        cmp     #$10
        beq     @continueToNextScreen
        jsr     updateAudioWaitForNmiAndResetOamStaging
        dec     generalCounter
        bne     @waitForStartButton
@continueToNextScreen:
        inc     gameMode
        rts
