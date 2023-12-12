
; Handles pausing and exiting demo
gameModeState_startButtonHandling:
        lda     gameMode
        cmp     #$05
        bne     @checkIfInGame
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     @checkIfInGame
        lda     #$01
        sta     gameMode
        jmp     @ret

@checkIfInGame:
        lda     renderMode
        cmp     #$03
        bne     @ret
        lda     newlyPressedButtons_player1
        and     #$10
        bne     @startPressed
        jmp     @ret

; Do nothing if curtain is being lowered
@startPressed:
        lda     player1_playState
        cmp     #$0A
        bne     @pause
        jmp     @ret

@pause: lda     #$05
        sta     musicStagingNoiseHi
        ; lda     #$05
        ; sta     renderMode
        jsr     updateAudioWaitForNmiAndResetOamStaging
.ifdef TOURNAMENT
        lda     currentPpuMask
.else
        lda     #$16
.endif
        sta     PPUMASK
        lda     #$FF
        ldx     #$02
        ldy     #$02
        jsr     memset_page
@pauseLoop:
        lda     frameCounter
        sta     spriteXOffset
        lda     #PAUSE_SPRITE_Y
        sta     spriteYOffset

        lda     #$05
        sta     spriteIndexInOamContentLookup
        jsr     stageSpritesThenloadSprites
        lda     newlyPressedButtons_player1
        cmp     #$10
        beq     @resume
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jmp     @pauseLoop

@resume:lda     #$1E
        sta     PPUMASK
        lda     #$00
        sta     musicStagingNoiseHi
        sta     player1_vramRow
        lda     #$03
        sta     renderMode
@ret:   inc     gameModeState
        rts
