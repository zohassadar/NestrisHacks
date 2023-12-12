playState_bTypeGoalCheck:
        lda     gameType
        beq     @ret
        lda     lines
        bne     @ret
        lda     #$02
        jsr     setMusicTrack
       
        lda     #$FF
        sta     sleepCounter

@sleepLoop:
        jsr     stageSpriteForCurrentPiece
        jsr     stageSpriteForNextPiece

        lda     #$90
        sec
        sbc     sleepCounter
        asl
        sta     spriteXOffset
        lda     #PAUSE_SPRITE_Y
        sta     spriteYOffset
        lda     #$0F
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging


        jsr     updateAudioWaitForNmiAndResetOamStaging

        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        bne     @carryOn
        lda     sleepCounter
        bne     @sleepLoop

@carryOn:
        lda     #$00
        sta     renderMode
        jsr     endingAnimation_maybe
        lda     #$00
        sta     playState
        inc     gameModeState
        rts

@ret:  inc     playState
        rts
