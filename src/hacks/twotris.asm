STATE_INITIALIZE := $00
STATE_PLAYING := $01
STATE_CHECKING := $02
STATE_CLEARING := $03
STATE_REFRESHING := $04
STATE_PAUSED := $05

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
        jmp     notPlayingTwotris
@newGameStarted:
        lda     twotrisState
        cmp     #$EF
        bne     @initialized
        jmp     twotrisInitialize
@initialized:
        jsr     fulfillRenderQueue
        jsr     copyOamStagingToOam
        jsr     setMmcControlAndRenderFlags
        ; --------

        jsr     emptyRenderQueue

        ; --------
        inc     frameCounter
        lda     #$00
        sta     ppuScrollX
        sta     PPUSCROLL
        sta     ppuScrollY
        sta     PPUSCROLL
        ; --------
        ldx     #$17
        ldy     #$02
        jsr     generateNextPseudorandomNumber
        jsr     pollControllerButtons
        ; jsr     jumpToGamePlayState
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

        ; load initial render of flags/regs into queue

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
        bpl     @nextTile
        jmp     @nextChunk
@ret:
        rts


emptyRenderQueue:
        ldx     #$80
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
