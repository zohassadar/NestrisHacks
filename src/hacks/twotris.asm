STATE_PAUSED := $00
STATE_PLAYING := $01
STATE_CHECKING := $02
STATE_CLEARING := $03
STATE_REFRESHING := $04

menuThrottleStart := $10
menuThrottleRepeat := $4

SOUND_EFFECT_LOCK := $07
SOUND_EFFECT_LINE_CLEAR := $0A

PLANT_TIMER :=  $1F

EMPTY   :=      $EF


twotris:
        pha
        txa
        pha
        tya
        pha
; Figure out if we're in twotris mode
        lda     player1_autorepeatY
        cmp     #$A0
        beq     @newGameStarted
        sta     twotrisPreviousAutorepeatY
        ; set mmc1 control every frame for normal game
        inc     initRam
        lda     #$10
        jsr     setMMC1Control
        jmp     notPlayingTwotris

        ; find out if a new game just started
@newGameStarted:
        cmp     twotrisPreviousAutorepeatY
        beq     @initialized
        jmp     twotrisInitialize
@initialized:
        jsr     fulfillRenderQueue
        jsr     copyOamStagingToOam
        jsr     setMmcControlAndRenderFlags
        ; --------
        jsr     emptyRenderQueue

        ldx     #$02
        ldy     #$02
        lda     #$FF
        jsr     memset_page

        ; --------
        inc     frameCounter
        lda     #$00
        sta     twotrisOamIndex
        sta     renderQueueIndex
        ; --------
        jsr     pollControllerButtons
        jsr     jumpToGamePlayState
        jsr     checkForPause
        jsr     updateAudio
        jsr     generateNumbers
twoTrisNmiTail:
        pla
        tay
        pla
        tax
        pla
        rti

generateNumbers:
        lda     rng_seed+1
        and     #$0F
        sta     twotrisTemp
@reRoll:
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        dec     twotrisTemp
        bne     @reRoll
        rts


pickRandomInstruction:
        ldx     #$20
        lda     rng_seed
        adc     frameCounter
@nextPiece:
        cmp     twotrisInstructionWeightTable,x
        bcs     @foundInstruction
        dex
        bmi     @foundInstruction
        bpl     @nextPiece
@foundInstruction:
        inx
        lda     spawnInstructions,x
        rts



twotrisInitialize:
        ; store renderVars
        lda     outOfDateRenderFlags
        pha
        ; do last render so colors/score/lines/level show up
        jsr     render_mode_play_and_demo
        ; restore render vars
        pla
        sta     outOfDateRenderFlags

        ; clear the slate
        ldx     #$05
        ldy     #$05
        lda     #$00
        jsr     memset_page

        ; set up variables here
        lda     #$01
        sta     twotrisState
        lda     #$13
        sta     twotrisMmcControl
        lda     #$80
        sta     twotrisPpuCtrl
        lda     #$1E
        sta     twotrisPpuMask
        lda     #$20
        sta     twotrisRts
        lda     #PLANT_TIMER
        sta     twotrisPlantTimer
        lda     #$FF
        jsr     setMusicTrack

        ldy     #$13
        lda     #EMPTY
@fillPlayfield:
        sta     twotrisPlayfield,y
        dey
        bpl     @fillPlayfield

        lda     #$00
        sta     twotrisPauseInitialized
        sta     player1_vramRow
        sta     vramRow

        jsr     generateNumbers
        jsr     pickRandomInstruction
        sta     twotrisCurrentPiece
        jsr     generateNumbers
        lda     rng_seed
        sta     twotrisCurrentDigit
        jsr     newNextInstruction

        lda     player1_autorepeatY
        sta     twotrisPreviousAutorepeatY

        ; load initial render of flags/regs into queue
        jsr     initializeBoard
        jmp     twoTrisNmiTail

newNextInstruction:
        jsr     generateNumbers
        jsr     pickRandomInstruction
        sta     twotrisNextPiece
        jsr     generateNumbers
        lda     rng_seed
        sta     twotrisNextDigit
        rts

playstatePlaying:
        lda     twotrisCurrentRow
        sta     twotrisPreviousRow

; unpack the compressed rotation
        ldy     twotrisCurrentPiece
        lda     CompressedRotation,y
        lsr
        lsr
        lsr
        lsr
        tax
        lda     fourBitTo8Bit,x
        sta     twotrisTemp+1
        lda     CompressedRotation,y
        and     #$0f
        tax
        lda     fourBitTo8Bit,x
        sta     twotrisTemp+2

        lda     heldButtons_player1
        and     #BUTTON_LEFT
        beq     @leftNotHeld
        dec     twotrisPlantTimer
        bpl     @waitToPlant
        lda     #SOUND_EFFECT_LOCK
        sta     soundEffectSlot1Init
        lda     #STATE_CHECKING
        sta     twotrisState
        jmp     @ret
@leftNotHeld:
        lda     #PLANT_TIMER
        sta     twotrisPlantTimer
@waitToPlant:
        lda     #BUTTON_DOWN
        jsr     menuThrottle
        beq     @cantMoveDown
        lda     #$01
        sta     soundEffectSlot1Init
        ldx     twotrisCurrentRow
@nextRow:
        inx
        cpx     #$14
        beq     @cantMoveDown
        lda     twotrisPlayfield,x
        cmp     #EMPTY
        bne     @nextRow
        stx     twotrisCurrentRow

@cantMoveDown:
        lda     #BUTTON_UP
        jsr     menuThrottle
        beq     @cantMoveUp
        lda     #$01
        sta     soundEffectSlot1Init
        ldx     twotrisCurrentRow
@nextRow2:
        dex
        bmi     @cantMoveUp
        lda     twotrisPlayfield,x
        cmp     #EMPTY
        bne     @nextRow2
        stx     twotrisCurrentRow
@cantMoveUp:
        lda     #BUTTON_A
        jsr     menuThrottle
        beq     @aNotPressed
        lda     twotrisCurrentPiece
        clc
        adc     twotrisTemp+2
        sta     twotrisCurrentPiece
        lda     #$01
        sta     soundEffectSlot1Init
@aNotPressed:
        lda     #BUTTON_B
        jsr     menuThrottle
        beq     @bNotPressed
        lda     twotrisCurrentPiece
        clc
        adc     twotrisTemp+1
        sta     twotrisCurrentPiece
        lda     #$01
        sta     soundEffectSlot1Init
@bNotPressed:
        lda     #STATE_PLAYING
        cmp     twotrisState
        bne     @ret
        jsr     loadCurrentPieceCursor
@ret:
        lda     twotrisCurrentRow
        sta     renderedRow

        ldy     twotrisCurrentPiece

        lda     twotrisInstructionGroups,y
        sta     renderedInstruction

        lda     twotrisCurrentDigit
        sta     renderedValue

        lda     twotrisAddressingTable,y
@storeType:
        sta     renderedType
        jsr     renderRow
        jsr     clearPreviousRow
        rts

renderRow:
        lda     renderQueueIndex
        tax
        clc
        adc     #$0D
        sta     renderQueueIndex
        lda     renderedRow
        asl
        tay
        lda     vramPlayfieldRows+1,y
        sta     twotrisRenderQueue,x
        lda     vramPlayfieldRows,y
        clc
        adc     #$06
        sta     twotrisRenderQueue+1,x
        lda     #$0A
        sta     twotrisRenderQueue+2,x

        inx
        inx
        inx

        ldy     renderedType
        lda     multBy10Table,y
        tay
        clc
        adc     #$0A
        sta     twotrisTemp

@nextRenderChar:
        lda     renderChars,y
        cmp     #$80
        bne     @skipInstruction

        tya
        pha

        lda     renderedInstruction
        asl
        clc
        adc     renderedInstruction
        tay
        lda     twotrisInstructionStrings,y
        sta     twotrisRenderQueue,x
        inx
        lda     twotrisInstructionStrings+1,y
        sta     twotrisRenderQueue,x
        inx
        lda     twotrisInstructionStrings+2,y
        sta     twotrisRenderQueue,x
        inx

        pla
        tay
        jmp     @next

@skipInstruction:
        cmp     #$81
        bne     @skipDigit
        lda     renderedValue
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue,x
        inx
        lda     renderedValue
        and     #$0F
        sta     twotrisRenderQueue,x
        inx
        jmp     @next

@skipDigit:
        cmp     #$82
        bne     @skipNull
        jmp     @next

@skipNull:
        sta     twotrisRenderQueue,x
        inx
@next:
        iny
        cpy     twotrisTemp
        bne     @nextRenderChar
        rts


clearPreviousRow:
        lda     twotrisPreviousRow
        cmp     twotrisCurrentRow
        beq     @ret
        sta     renderedRow
        lda     #$07
        sta     renderedType
        jsr     renderRow
@ret:
        rts

playstateLockAndCheck:
        ldy     twotrisCurrentRow
        lda     twotrisCurrentPiece
        sta     twotrisPlayfield,y
        lda     twotrisCurrentDigit
        sta     twotrisDigits,y
@moveToClearing:
        lda     #$13
        sta     twotrisAnimationColumn
        lda     #STATE_CLEARING
        sta     twotrisState
        lda     twotrisCurrentRow
        bne     @ret
        lda     #SOUND_EFFECT_LINE_CLEAR
        sta     soundEffectSlot1Init
@ret:
        rts

playstateClearing:
        lda     twotrisAnimationColumn
        and     #$01
        sta     twotrisTemp
        lda     #$FF
        sec
        sbc     twotrisTemp
        sta     twotrisTemp     ; solid or black tile
        lda     #$20
        sta     twotrisRenderQueue
        lda     twotrisAnimationColumn
        lsr
        clc
        adc     #$CC
        sta     twotrisRenderQueue+1
        lda     #$01
        sta     twotrisRenderQueue+2
        lda     twotrisTemp
        sta     twotrisRenderQueue+3
        dec     twotrisAnimationColumn
        bpl     @ret
        lda     #$00
        sta     twotrisVramRow
        lda     #STATE_REFRESHING
        sta     twotrisState
@ret:
        rts


playstateRefreshing:
        lda     #$04
        sta     twotrisTemp+3
@checkAgain:
        lda     twotrisVramRow
        cmp     #$14
        bcc     @inClearState
        lda     #STATE_PLAYING
        sta     twotrisState
        rts

@inClearState:
        lda     twotrisVramRow
        sta     renderedRow
        tay
        lda     twotrisPlayfield,y
        sta     twotrisTemp
        cmp     #EMPTY
        bne     @notBlank
        lda     #$07
        jmp     @storeType

@notBlank:
        lda     twotrisDigits,y
        sta     renderedValue

        ldy     twotrisTemp
        lda     twotrisInstructionGroups,y
        sta     renderedInstruction

        lda     twotrisAddressingTable,y
@storeType:
        sta     renderedType
        jsr     renderRow
        inc     twotrisVramRow
        dec     twotrisTemp+3
        bne     @checkAgain
        rts

playstatePaused:
        lda     #BUTTON_RIGHT
        jsr     menuThrottle
        beq     @rightNotPressed
        inc     twotrisPauseDigit
        lda     twotrisPauseDigit
        and     #$03
        sta     twotrisPauseDigit
        jmp     @finished
@rightNotPressed:
        lda     #BUTTON_LEFT
        jsr     menuThrottle
        beq     @leftNotPressed
        dec     twotrisPauseDigit
        lda     twotrisPauseDigit
        and     #$03
        sta     twotrisPauseDigit
        jmp     @finished
@leftNotPressed:
        lda     #BUTTON_UP
        jsr     menuThrottle
        beq     @upNotPressed
        ldx     twotrisPauseDigit
        inc     twotrisPauseStartHigh0,x
        lda     twotrisPauseStartHigh0,x
        and     #$0F
        sta     twotrisPauseStartHigh0,x
        jsr     pauseIndividualToGroup
        jmp     @finished
@upNotPressed:
        lda     #BUTTON_DOWN
        jsr     menuThrottle
        beq     @downNotPressed
        ldx     twotrisPauseDigit
        dec     twotrisPauseStartHigh0,x
        lda     twotrisPauseStartHigh0,x
        and     #$0F
        sta     twotrisPauseStartHigh0,x
        jsr     pauseIndividualToGroup
        jmp     @finished
@downNotPressed:
        lda     #BUTTON_A
        jsr     menuThrottle
        beq     @aNotPressed
        lda     twotrisPauseStartLow
        clc
        adc     #$08
        sta     twotrisPauseStartLow
        lda     twotrisPauseStartHigh
        adc     #$00
        sta     twotrisPauseStartHigh
        jsr     pauseGroupToIndividual
        jmp     @finished
@aNotPressed:
        lda     #BUTTON_B
        jsr     menuThrottle
        beq     @finished
        lda     twotrisPauseStartLow
        sec
        sbc     #$08
        sta     twotrisPauseStartLow
        lda     twotrisPauseStartHigh
        sbc     #$00
        sta     twotrisPauseStartHigh
        jsr     pauseGroupToIndividual
@finished:
        jsr     pauseDrawRows
        jsr     loadPauseAddressCursor
        rts


pauseIndividualToGroup:
        lda     twotrisPauseStartHigh0
        asl
        asl
        asl
        asl
        ora     twotrisPauseStartHigh1
        sta     twotrisPauseStartHigh
        lda     twotrisPauseStartLow0
        asl
        asl
        asl
        asl
        ora     twotrisPauseStartLow1
        sta     twotrisPauseStartLow
        rts

pauseGroupToIndividual:
        lda     twotrisPauseStartHigh
        lsr
        lsr
        lsr
        lsr
        sta     twotrisPauseStartHigh0
        lda     twotrisPauseStartHigh
        and     #$0f
        sta     twotrisPauseStartHigh1
        lda     twotrisPauseStartLow
        lsr
        lsr
        lsr
        lsr
        sta     twotrisPauseStartLow0
        lda     twotrisPauseStartLow
        and     #$0f
        sta     twotrisPauseStartLow1
        rts


pauseDrawRows:
        lda     twotrisPauseStartLow
        sta     tmp1
        lda     twotrisPauseStartHigh
        sta     tmp2

        ldy     #$00
        ldx     #$00

        lda     #$29
        sta     twotrisRenderQueue,x
        inx
        lda     #$84
        sta     twotrisRenderQueue,x
        inx
        lda     #$18
        sta     twotrisRenderQueue,x
        inx

@nextByte:
        lda     (tmp1),y
        sta     twotrisTemp
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue,x
        inx

        lda     twotrisTemp
        and     #$0F
        sta     twotrisRenderQueue,x
        inx

        lda     #$FF
        sta     twotrisRenderQueue,x
        inx
        iny
        cpy     #$08
        bne     @nextByte

        lda     #$28
        sta     twotrisRenderQueue,x
        inx

        lda     #$CC
        sta     twotrisRenderQueue,x
        inx

        lda     #$04
        sta     twotrisRenderQueue,x
        inx

        lda     twotrisPauseStartHigh0
        sta     twotrisRenderQueue,x
        inx
        lda     twotrisPauseStartHigh1
        sta     twotrisRenderQueue,x
        inx
        lda     twotrisPauseStartLow0
        sta     twotrisRenderQueue,x
        inx
        lda     twotrisPauseStartLow1
        sta     twotrisRenderQueue,x
        rts



fulfillRenderQueue:
        ldx     #$00
@nextChunk:
        lda     twotrisRenderQueue,x
        beq     @ret
        sta     PPUADDR
        inx
        lda     twotrisRenderQueue,x
        sta     PPUADDR
        inx
        ldy     twotrisRenderQueue,x
        inx
@nextTile:
        lda     twotrisRenderQueue,x
        sta     PPUDATA
        inx
        dey
        bne     @nextTile
        jmp     @nextChunk
@ret:
        rts

emptyRenderQueue:
        ldx     #$7F
        lda     #$00
@emptyQueueLoop:
        sta     twotrisRenderQueue,x
        dex
        bpl     @emptyQueueLoop
        rts

checkForPause:
        lda     newlyPressedButtons_player1
        and     #BUTTON_START
        beq     nearbyReturn
        lda     twotrisPpuCtrl
        eor     #$02
        sta     twotrisPpuCtrl
        and     #$02
        bne     notPaused
        lda     #$00
        sta     musicStagingNoiseHi
        lda     #STATE_PLAYING
        bne     storeNewState
notPaused:
        lda     #$05
        sta     musicStagingNoiseHi
        lda     #STATE_PAUSED
storeNewState:
        sta     twotrisState
        lda     twotrisPauseInitialized
        bne     nearbyReturn
        pla
        pla
        tsx
        lda     #<initializePause
        sta     stack+5,x
        lda     #>initializePause
        sta     stack+6,x
        jmp     twoTrisNmiTail

menuThrottle:                   ; add DAS-like movement to the menu
        sta     menuThrottleTmp
        lda     newlyPressedButtons_player1
        cmp     menuThrottleTmp
        beq     menuThrottleNew
        lda     heldButtons_player1
        cmp     menuThrottleTmp
        bne     @endThrottle
        dec     menuMoveThrottle
        beq     menuThrottleContinue
@endThrottle:
        lda     #0
nearbyReturn:
        rts

menuThrottleNew:
        lda     #menuThrottleStart
        sta     menuMoveThrottle
        rts
menuThrottleContinue:
        lda     #menuThrottleRepeat
        sta     menuMoveThrottle
        rts


initializePause:
        lda     #$00
        sta     PPUMASK
        sta     PPUCTRL
        ldy     #$04
        tax
        lda     #$28
        sta     PPUADDR
        txa
        sta     PPUADDR
        lda     #$FF
@nextTile:
        sta     PPUDATA
        inx
        bne     @nextTile
        dey
        bne     @nextTile
        jsr     pauseDrawRows
@waitForVBlankAndEnableNmi:
        bit     PPUSTATUS
        bpl     @waitForVBlankAndEnableNmi
        lda     #$80
        sta     PPUCTRL
        inc     twotrisPauseInitialized
        jmp     waitPartOfUpdateAudioWaitForNmiAndResetOamStaging

jumpToGamePlayState:
        lda     twotrisState
        jsr     switch_s_plus_2a
        .addr   playstatePaused
        .addr   playstatePlaying
        .addr   playstateLockAndCheck
        .addr   playstateClearing
        .addr   playstateRefreshing

setMmcControlAndRenderFlags:
        inc     initRam
        lda     twotrisMmcControl
        jsr     setMMC1Control
        lda     #$00
        sta     PPUSCROLL
        sta     PPUSCROLL
        lda     twotrisPpuCtrl
        sta     PPUCTRL
        lda     twotrisPpuMask
        sta     PPUMASK
        rts

loadCurrentPieceCursor:
        lda     frameCounter
        and     #$07
        beq     @ret
        ldx     twotrisOamIndex
        lda     twotrisCurrentRow
        asl
        asl
        asl
        clc
        adc     #$2F
        sta     oamStaging,x
        inx
        lda     #$FB
        sta     oamStaging,x
        inx
        lda     #$03
        sta     oamStaging,x
        inx
        lda     #$55
        sta     oamStaging,x
        inx
        stx     twotrisOamIndex
@ret:   rts


loadPauseAddressCursor:
        lda     frameCounter
        and     #$03
        beq     @ret
        ldx     twotrisOamIndex
        lda     #$28
        sta     oamStaging,x
        inx
        lda     #$F6
        sta     oamStaging,x
        inx
        lda     #$23
        sta     oamStaging,x
        inx
        lda     twotrisPauseDigit
        asl
        asl
        asl
        clc
        adc     #$5F
        sta     oamStaging,x
        inx
        stx     twotrisOamIndex
@ret:   rts


initializeBoard:
        ldx     #$00
@loopThroughInitialize:
        lda     boardInitializeData,x
        cmp     #$FE
        beq     @ret
        sta     twotrisRenderQueue,x
        inx
        jmp     @loopThroughInitialize
@ret:
        rts


        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00

        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00


