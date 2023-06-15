gameMode_legalScreen:
        jsr     updateAudio2
        lda     #$00
        sta     renderMode
        jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
        lda     #$00
        jsr     changeCHRBank0
        lda     #$00
        jsr     changeCHRBank1
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
        lda     #$FF
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
