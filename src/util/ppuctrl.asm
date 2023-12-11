; canon is waitForVerticalBlankingInterval
updateAudioWaitForNmiAndResetOamStaging:
        jsr     updateAudio_jmp
        jsr     cleanupTasks
        lda     #$00
        sta     verticalBlankingInterval
        nop
@checkForNmi:
        lda     verticalBlankingInterval
        beq     @checkForNmi
resetOAMStaging:
; Hide a sprite by moving it down offscreen, by writing any values between #$EF-#$FF here. 
; Sprites are never displayed on the first line of the picture, and it is impossible to place 
; a sprite partially off the top of the screen. 
; https://www.nesdev.org/wiki/PPU_OAM
        ldx #$00
        lda #$FF
@hideY:
        sta oamStaging,x
        inx
        inx
        inx
        inx
        bne @hideY
        rts

updateAudioAndWaitForNmi:
        jsr     updateAudio_jmp
        jsr     cleanupTasks
        lda     #$00
        sta     verticalBlankingInterval
        nop
@checkForNmi:
        lda     verticalBlankingInterval
        beq     @checkForNmi
        rts

updateAudioWaitForNmiAndDisablePpuRendering:
        jsr     updateAudioAndWaitForNmi
        lda     currentPpuMask
        and     #$E1
_updatePpuMask:
        sta     PPUMASK
        sta     currentPpuMask
        rts

updateAudioWaitForNmiAndEnablePpuRendering:
        jsr     updateAudioAndWaitForNmi
        jsr     copyCurrentScrollAndCtrlToPPU
        lda     currentPpuMask
        ora     #$1E
        bne     _updatePpuMask
waitForVBlankAndEnableNmi:
        lda     PPUSTATUS
        and     #$80
        bne     waitForVBlankAndEnableNmi
        lda     currentPpuCtrl
        ora     #$80
        bne     _updatePpuCtrl
disableNmi:
        lda     currentPpuCtrl
        and     #$7F
_updatePpuCtrl:
        sta     PPUCTRL
        sta     currentPpuCtrl
        rts

LAA82:  ldx     #$FF
        ldy     #$00
        jsr     memset_ppu_page_and_more
        rts

copyCurrentScrollAndCtrlToPPU:
        rts
        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     currentPpuCtrl
        sta     PPUCTRL
    