STATE_PAUSED := $00
STATE_PLAYING := $01
STATE_CHECKING := $02
STATE_CLEARING := $03
STATE_REFRESHING := $04

menuThrottleStart := $10
menuThrottleRepeat := $4

INST_NOP :=     $EF

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
        lda rng_seed+1
        and #$0F
        sta twotrisTemp
@reRoll:
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        dec twotrisTemp
        bne @reRoll
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
        rts

playstateChecking:
        rts

playstateClearing:
        rts

playstateRefreshing:
        lda nextPiece
        sta currentPiece
        lda twotrisNextDigit
        sta twotrisCurrentDigit
        jsr newNextInstruction
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
        lda     #STATE_PLAYING
        bne     storeNewState
notPaused:
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
        .addr   playstateChecking
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


boardInitializeData:
        .byte   $21,$86,$03,$0A,$00,$00;A in T spot
        .byte   $21,$C6,$03,$21,$00,$00;X in J spot
        .byte   $22,$06,$03,$22,$00,$00;Y in Z spot
        .byte   $22,$46,$03,$17,$FF,$00;N in O spot
        .byte   $22,$86,$03,$1F,$FF,$00;V in S spot
        .byte   $22,$C6,$03,$23,$FF,$00;Z in L spot
        .byte   $23,$06,$03,$0C,$FF,$00;C in I spot
        .byte   $FE             ; end


        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00


        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00


        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00


        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00

        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
        .byte $00,$00,$00,$00,$00,$00,$00,$00
