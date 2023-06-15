@mainLoop:
        jsr     branchOnGameMode
        cmp     gameModeState
        bne     @checkForDemoDataExhaustion
        jsr     updateAudioWaitForNmiAndResetOamStaging
@checkForDemoDataExhaustion:
        lda     gameMode
        cmp     #$05
        bne     @continue
        lda     demoButtonsAddr+1
        cmp     #>demoTetriminoTypeTable
        bne     @continue
        lda     #>demoButtonsTable
        sta     demoButtonsAddr+1
        lda     #$00
        sta     frameCounter+1
        lda     #$01
        sta     gameMode
@continue:
        jmp     @mainLoop