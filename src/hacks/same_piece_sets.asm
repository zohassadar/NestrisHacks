
menuThrottle: ; add DAS-like movement to the menu
        sta menuThrottleTmp
        lda newlyPressedButtons_player1
        cmp menuThrottleTmp
        beq menuThrottleNew
        lda heldButtons_player1
        cmp menuThrottleTmp
        bne @endThrottle
        dec menuMoveThrottle
        beq menuThrottleContinue
@endThrottle:
        lda #0
        rts

menuThrottleStart := $10
menuThrottleRepeat := $4
menuThrottleNew:
        lda #menuThrottleStart
        sta menuMoveThrottle
        rts
menuThrottleContinue:
        lda #menuThrottleRepeat
        sta menuMoveThrottle
        rts

drawNonBlinkingMenuSprite:
        ldx     startLevel
        lda     levelToSpriteYOffset,x
        sta     spriteYOffset
        lda     #$00
        sta     spriteIndexInOamContentLookup
        ldx     startLevel
        lda     levelToSpriteXOffset,x
        sta     spriteXOffset
        jsr     loadSpriteIntoOamStaging
        lda     gameType
        beq     @ret
        ldx     startHeight
        lda     heightToPpuHighAddr,x
        sta     spriteYOffset
        lda     #$00
        sta     spriteIndexInOamContentLookup
        ldx     startHeight
        lda     heightToPpuLowAddr,x
        sta     spriteXOffset
        jsr     loadSpriteIntoOamStaging
@ret:   rts

loadSeedCursor:
        lda frameCounter
        and #$03
        bne @loadSeedCursor
        lda sps_menu
        bne @ret
@loadSeedCursor:
        ldx oamStagingLength
        lda #$78
        sta oamStaging,x
        inx
        lda #$92
        sta oamStaging,x
        inx
        lda #$00
        sta oamStaging,x
        inx
        lda menuSeedCursorIndex
        asl
        asl
        asl
        clc
        adc #$27
        sta oamStaging,x
        inx
        stx oamStagingLength
@ret:   rts


renderSeedIfNecessary:
        lda gameMode
        cmp #$03
        bne @continueToRender
        lda #$22
        sta PPUADDR
        lda #$06
        sta PPUADDR
        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
        lda #$22
        sta PPUADDR
        lda #$0F
        sta PPUADDR
        ldx seedVersion
        bne @drawValidSeed
        lda #$17
        sta PPUDATA
        lda #$18
        sta PPUDATA
        lda #$1B
        sta PPUDATA
        lda #$16
        sta PPUDATA
        lda #$0A
        sta PPUDATA
        lda #$15
        sta PPUDATA
        jmp render
@drawValidSeed:
        lda #$1F
        sta PPUDATA
        lda seedVersion
        sta PPUDATA
        lda #$1C
        sta PPUDATA
        lda #$0E
        sta PPUDATA
        sta PPUDATA
        lda #$0D
        sta PPUDATA
@continueToRender:
        jmp render

drawSeedOnBackground:
        lda seedVersion
        beq @dontDrawSeed
        lda #$20
        sta PPUADDR
        lda #$83
        sta PPUADDR
        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
@dontDrawSeed:
        jmp gameModeState_initGameBackground_finish


pickTetriminoSeed:
        ; seed code by kirjava
        lda seedVersion
        bne @pickSeeded
        jsr pickNormalRNG
        jmp @ret
@pickSeeded:
        jsr setSeedNextRNG

        ; SPSv3

        lda set_seed_input+2
        ror
        ror
        ror
        ror
        and #$F
        ; v3
        cmp #0
        bne @notZero
        lda #$10
@notZero:
        ; v2
        ; cmp #0
        ; beq @compatMode

        adc #1
        sta tmp3 ; step + 1 in tmp3
@loop:
        jsr setSeedNextRNG
        dec tmp3
        lda tmp3
        bne @loop
@compatMode:

        inc set_seed+2 ; 'spawnCount'
        lda set_seed
        clc
        adc set_seed+2
        and #$07
        cmp #$07
        beq @invalidIndex
        tax
        lda spawnTable,x
        cmp spawnID
        bne @useNewSpawnID
@invalidIndex:
        ldx #set_seed
        ldy #$02
        jsr generateNextPseudorandomNumber
        lda set_seed
        and #$07
        clc
        adc spawnID
@L992A:
        cmp #$07
        bcc @L9934
        sec
        sbc #$07
        jmp @L992A

@L9934:
        tax
        lda spawnTable,x
@useNewSpawnID:
        sta spawnID
@ret:   rts

setSeedNextRNG:
        ldx #set_seed
        ldy #$02
        jsr generateNextPseudorandomNumber
        rts

checkValidSeed:
        lda #$00
        sta seedVersion
        lda set_seed_input
        bne @seeded
        lda set_seed_input+1
        bne @seeded
        rts
@seeded:
        lda #$05
        sta seedVersion
        lda set_seed_input+2
        and #$F0
        beq @ret
        dec seedVersion
@ret:   rts



samePieceSetMenu:
        lda menuSeedCursorIndex
        bne @cursorAlreadySet
        inc menuSeedCursorIndex
@cursorAlreadySet:
        lda newlyPressedButtons_player1
        and #BUTTON_SELECT
        beq @selectNotPressed
        lda sps_menu
        eor #$01
        sta sps_menu
        lda #$01
        sta soundEffectSlot1Init
@selectNotPressed:
        lda sps_menu
        bne continueSamePieceSetMenu
        jsr loadSeedCursor
        jsr gameMode_levelMenu_handleLevelHeightNavigation
        rts
continueSamePieceSetMenu:
        lda heldButtons_player1
        and #BUTTON_A
        beq @skipSeedSelect
        lda newlyPressedButtons_player1
        and #BUTTON_UP
        beq @skipSeedSelect
        lda rng_seed
        sta set_seed_input
        lda rng_seed+1
        sta set_seed_input+1
        lda rng_seed+1
        eor #$77
        ror
        sta set_seed_input+2
        lda #$01
        sta soundEffectSlot1Init
        jmp @skipSeedControl
@skipSeedSelect:
        lda heldButtons_player1
        and #BUTTON_A
        beq @skipSeedReset
        lda newlyPressedButtons_player1
        and #BUTTON_DOWN
        beq @skipSeedReset
        lda #$00
        sta set_seed_input
        sta set_seed_input+1
        sta set_seed_input+2
        lda #$01
        sta menuSeedCursorIndex
        lda #$01
        sta soundEffectSlot1Init
        jmp @skipSeedControl
@skipSeedReset:
        lda #BUTTON_LEFT
        jsr menuThrottle
        beq @skipSeedLeft
        lda #$01
        sta soundEffectSlot1Init
        lda menuSeedCursorIndex
        cmp #$01
        bne @noSeedLeftWrap
        lda #7
        sta menuSeedCursorIndex
@noSeedLeftWrap:
        dec menuSeedCursorIndex
@skipSeedLeft:
        lda #BUTTON_RIGHT
        jsr menuThrottle
        beq @skipSeedRight
        lda #$01
        sta soundEffectSlot1Init
        inc menuSeedCursorIndex
        lda menuSeedCursorIndex
        cmp #7
        bne @skipSeedRight
        lda #1
        sta menuSeedCursorIndex
@skipSeedRight:
        lda menuSeedCursorIndex
        beq @skipSeedControl
        lda menuSeedCursorIndex
        sbc #1
        lsr
        tax ; save seed offset

        ; handle changing seed vals

        lda #BUTTON_UP
        jsr menuThrottle
        beq @skipSeedUp
        lda #$01
        sta soundEffectSlot1Init
        lda menuSeedCursorIndex
        and #1
        beq @lowNybbleUp

        lda set_seed_input, x
        clc
        adc #$10
        sta set_seed_input, x

        jmp @skipSeedUp
@lowNybbleUp:
        lda set_seed_input, x
        clc
        tay
        and #$F
        cmp #$F
        bne @noWrapUp
        tya
        and #$F0
        sta set_seed_input, x
        jmp @skipSeedUp
@noWrapUp:
        tya
        adc #1
        sta set_seed_input, x
@skipSeedUp:

        lda #BUTTON_DOWN
        jsr menuThrottle
        beq @skipSeedDown
        lda #$01
        sta soundEffectSlot1Init
        lda menuSeedCursorIndex
        and #1
        beq @lowNybbleDown

        lda set_seed_input, x
        sbc #$10
        clc
        sta set_seed_input, x

        jmp @skipSeedDown
@lowNybbleDown:
        lda set_seed_input, x
        clc
        tay
        and #$F
        cmp #$0
        bne @noWrapDown
        tya
        and #$F0
        clc
        adc #$F
        sta set_seed_input, x
        jmp @skipSeedDown
@noWrapDown:
        tya
        sbc #1
        sta set_seed_input, x
@skipSeedDown:
@skipSeedControl:
        jsr checkValidSeed
        jsr loadSeedCursor
        jsr drawNonBlinkingMenuSprite
        lda #$00
        sta newlyPressedButtons_player1
        rts

resetSetSeedandChooseNextTetrimino:
        lda set_seed_input
        sta set_seed
        lda set_seed_input+1
        sta set_seed+1
        lda set_seed_input+2
        sta set_seed+2
.ifdef RANDO
        jmp     chooseNextAndRandomizeOrientation
.else
        jmp     chooseNextTetrimino
.endif
