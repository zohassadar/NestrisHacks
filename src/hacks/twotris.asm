STATE_PAUSED := $00
STATE_PLAYING := $01
STATE_CHECKING := $02
STATE_CLEARING := $03
STATE_REFRESHING := $04

menuThrottleStart := $10
menuThrottleRepeat := $4


INST_NOP :=     $EF

instructionTable:
        .byte   $00,$00         ; actual opcodes go here in an order
instructionAddressing:
        .byte   $00,$00         ; number corresponding to 0 - implied, 1 immediate, 2 zp, 3 zp,x, 4 (zp),y 5 (zp,x)

instructionIdAPressed:
        .byte   $00,$00         ; when currentPiece is incremented
instructionIdBPressed:
        .byte   $00,$00         ; decremented

pauseByteRows:
        .word   $2000           ; pause row 0
        .word   $2000           ; pause row 1
        .word   $2000           ; pause row 2
        .word   $2000           ; pause row 3
        .word   $2000           ; pause row 4
        .word   $2000           ; pause row 5
        .word   $2000           ; pause row 6
        .word   $2000           ; pause row 7



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
        inc     initRam
        lda     #$10
        jsr     setMMC1Control
        jmp     notPlayingTwotris
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
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        jsr     pollControllerButtons
        jsr     jumpToGamePlayState
        jsr     checkForPause
        jsr     updateAudio
twoTrisNmiTail:
        pla
        tay
        pla
        tax
        pla
        rti




twotrisInitialize:
        ; store renderVars
        lda     outOfDateRenderFlags
        pha
        lda     vramRow
        pha

        ; do last render so colors/score/lines/level show up
        jsr     render_mode_play_and_demo

        ; clear the slate
        ldx     #$05
        ldy     #$05
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

        lda     player1_autorepeatY
        sta     twotrisPreviousAutorepeatY

        ; load initial render of flags/regs into queue
        jsr     initializeBoard

; restore render vars
        pla
        sta     vramRow
        pla
        sta     outOfDateRenderFlags

        jmp     twoTrisNmiTail


playstateInitializing:
        rts

playstatePlaying:
        rts

playstateChecking:
        rts

playstateClearing:
        rts

playstateRefreshing:
        rts

playstatePaused:
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
        beq     @ret
        lda     twotrisPpuCtrl
        eor     #$02
        sta     twotrisPpuCtrl
        lda     twotrisPauseInitialized
        bne     @ret
        pla
        pla
        tsx
        lda     #<initializePause
        sta     stack+5,x
        lda     #>initializePause
        sta     stack+6,x
        jmp     twoTrisNmiTail       
@ret:
        rts


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
        ; disable nmi
        lda     #$00
        sta     PPUMASK
        lda     #$00
        sta     PPUCTRL

        lda     #$00
        sta     twotrisJump
        lda     #$28
        sta     twotrisJump+1
        ldy     #$1E            ; 30 rows

@blankRow:
        ldx     #$20            ; 32 cols
        lda     twotrisJump+1
        sta     PPUADDR
        lda     twotrisJump
        sta     PPUADDR

        lda     #$FD            ; blank tile
@blankColumn:
        sta     PPUDATA
        dex
        bne     @blankColumn

        dey
        beq     @waitForVBlankAndEnableNmi

        lda     #$20
        clc

        adc     twotrisJump
        sta     twotrisJump
        lda     #$00
        adc     twotrisJump+1
        sta     twotrisJump+1

        jmp     @blankRow

        ; enable nmi
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
        .addr   playstateInitializing
        .addr   playstatePlaying
        .addr   playstateChecking
        .addr   playstateClearing
        .addr   playstateRefreshing
        .addr   playstatePaused


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


initializeBoard:
    ldx #$00
@loopThroughInitialize:
    lda boardInitializeData,x
    cmp #$FE
    beq @ret
    sta twotrisRenderQueue,x
    inx
    jmp @loopThroughInitialize
@ret:
    rts


boardInitializeData:
    .byte $21,$86,$03,$0A,$00,$00 ;A in T spot
    .byte $21,$C6,$03,$21,$00,$00 ;X in J spot
    .byte $22,$06,$03,$22,$00,$00 ;Y in Z spot
    .byte $22,$46,$03,$17,$FF,$00 ;N in O spot
    .byte $22,$86,$03,$1F,$FF,$00 ;V in S spot
    .byte $22,$C6,$03,$23,$FF,$00 ;Z in L spot
    .byte $23,$06,$03,$0C,$FF,$00 ;C in I spot
    .byte $FE ; end
