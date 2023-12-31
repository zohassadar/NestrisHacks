
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
        ; lda     gameType
        ; beq     @ret
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
        sta generalCounter
        ldy menuSeedCursorIndex
        cpy #$07
        bcc @piecesSeed
        lda #$30
        clc
        adc generalCounter
@piecesSeed:
        sta oamStaging,x
        inx
        stx oamStagingLength
@ret:   rts


renderSeedIfNecessary:
        lda gameMode
        cmp #$03
        beq @itsNecessary
        jmp render
@itsNecessary:
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
        lda #$FF
        sta PPUDATA
        ldx seedVersion
        bne @drawValidSeed
        lda #$18
        sta PPUDATA
        lda #$0F
        sta PPUDATA
        sta PPUDATA
        bne @drawBSeed
@drawValidSeed:
        lda #$1F
        sta PPUDATA
        lda seedVersion
        sta PPUDATA
        lda #$FF
        sta PPUDATA
@drawBSeed:
        lda #$FF
        sta PPUDATA
        sta PPUDATA
        ; ldy gameType
        ; beq @hideBSeed
        lda bseed_input
        jsr twoDigsToPPU
        lda bseed_input+1
        jsr twoDigsToPPU
        lda #$FF
        sta PPUDATA
        lda #$18
        sta PPUDATA
        lda bseed_input
        bne @validBSeed
        lda bseed_input+1
        beq @noBSeed
        cmp #$01
        bne @validBSeed
@noBSeed:
        lda #$0F
        sta PPUDATA
        sta PPUDATA
        jmp render
@validBSeed:
        lda startHeight
        beq @noBSeed
        lda #$17
        sta PPUDATA
        lda #$FF
        sta PPUDATA
        jmp render
; @hideBSeed:
;         sta PPUDATA
;         sta PPUDATA
;         sta PPUDATA
;         sta PPUDATA
;         sta PPUDATA
;         sta PPUDATA
;         sta PPUDATA
;         sta PPUDATA
;         jmp render

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



; seedLimit:
;         .byte $07,$0B

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
        lda menuSeedCursorIndex
        cmp #$7
        bcc @randomizePieceSeed
        lda rng_seed
        sta bseed_input
        lda rng_seed+1
        sta bseed_input+1
        jmp @randomizeSound
@randomizePieceSeed:
        lda rng_seed
        sta set_seed_input
        lda rng_seed+1
        sta set_seed_input+1
        lda rng_seed+1
        eor #$77
        ror
        sta set_seed_input+2
@randomizeSound:
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
        lda menuSeedCursorIndex
        cmp #$7
        bcc @clearPieceSeed
        lda #$00
        sta bseed_input
        sta bseed_input+1
        beq @soundEffect
@clearPieceSeed:
        lda #$00
        sta set_seed_input
        sta set_seed_input+1
        sta set_seed_input+2
@soundEffect:
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
        ; ldx gameType
        ; lda seedLimit,x
        lda #$0B
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
        ; ldx gameType
        ; cmp seedLimit,x
        cmp #$0B
        bne @skipSeedRight
        lda #1
        sta menuSeedCursorIndex
@skipSeedRight:
        lda menuSeedCursorIndex
        beq @skipSeedControl
        lda menuSeedCursorIndex
        sec
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
        lda newlyPressedButtons_player1
        and #$50 ; allow start & b through
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

resetBSeed:
        lda     bseed_input
        bne     @seededGame
        lda     bseed_input+1
        beq     @notSeeded
        cmp     #$01
        bne     @seededGame
@notSeeded:
        lda     startHeight
        beq     @skipStore
        ; store rng in input for replay
        lda     rng_seed
        sta     bseed_input
        lda     rng_seed+1
        sta     bseed_input+1
@skipStore:
        lda     #rng_seed
        bne     @storeAndJump
@seededGame:
        lda     bseed_input
        sta     bseed
        lda     bseed_input+1
        sta     bseed+1
        lda     #bseed
@storeAndJump:
        sta     bSeedSource
        lda     startHeight
        beq     @ret
        jmp     initPlayfieldIfTypeB
@ret:   rts


generateNextPseudoAndAlsoBSeed:
        jsr generateNextPseudorandomNumber
        ldx #bseed
        ldy #$02
        jmp generateNextPseudorandomNumber


generateNextPseudoAndAlsoCopy:
        jsr generateNextPseudorandomNumber
        ldx bSeedSource
        lda tmp1,x
        sta bseedCopy
        rts

show_a_on_level_select_screen:
        .byte   $20,$6D,$01,$0A
        .byte   $FF
