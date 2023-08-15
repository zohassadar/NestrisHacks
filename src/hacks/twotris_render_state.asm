; not efficient
twotrisRenderState:
        lda     #$21
        sta     twotrisRenderQueue
        lda     #$18
        sta     twotrisRenderQueue+1
        lda     #$06
        sta     twotrisRenderQueue+2
        lda     player1_score+2
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+3
        lda     player1_score+2
        and     #$0F
        sta     twotrisRenderQueue+4
        lda     player1_score+1
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+5
        lda     player1_score+1
        and     #$0F
        sta     twotrisRenderQueue+6
        lda     player1_score
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+7
        lda     player1_score
        and     #$0F
        sta     twotrisRenderQueue+8

        lda     #$21
        sta     twotrisRenderQueue+9
        lda     #$87
        sta     twotrisRenderQueue+10
        lda     #$02
        sta     twotrisRenderQueue+11
        lda     twotrisA
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+12
        lda     twotrisA
        and     #$0F
        sta     twotrisRenderQueue+13


        lda     #$21
        sta     twotrisRenderQueue+14
        lda     #$C7
        sta     twotrisRenderQueue+15
        lda     #$02
        sta     twotrisRenderQueue+16
        lda     twotrisX
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+17
        lda     twotrisX
        and     #$0F
        sta     twotrisRenderQueue+18


        lda     #$22
        sta     twotrisRenderQueue+19
        lda     #$07
        sta     twotrisRenderQueue+20
        lda     #$02
        sta     twotrisRenderQueue+21
        lda     twotrisY
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+22
        lda     twotrisY
        and     #$0F
        sta     twotrisRenderQueue+23


        lda     #$22
        sta     twotrisRenderQueue+24
        lda     #$48
        sta     twotrisRenderQueue+25
        lda     #$01
        sta     twotrisRenderQueue+26
        lda     twotrisFlags
        rol
        lda     #$00
        rol
        sta     twotrisRenderQueue+27



        lda     #$22
        sta     twotrisRenderQueue+28
        lda     #$88
        sta     twotrisRenderQueue+29
        lda     #$01
        sta     twotrisRenderQueue+30
        lda     twotrisFlags
        rol
        rol
        lda     #$00
        rol
        sta     twotrisRenderQueue+31


        lda     #$22
        sta     twotrisRenderQueue+32
        lda     #$c8
        sta     twotrisRenderQueue+33
        lda     #$01
        sta     twotrisRenderQueue+34
        lda     twotrisFlags
        ror
        ror
        lda     #$00
        rol
        sta     twotrisRenderQueue+35


        lda     #$23
        sta     twotrisRenderQueue+36
        lda     #$08
        sta     twotrisRenderQueue+37
        lda     #$01
        sta     twotrisRenderQueue+38
        lda     twotrisFlags
        ror
        lda     #$00
        rol
        sta     twotrisRenderQueue+39


        lda     #$20
        sta     twotrisRenderQueue+40
        lda     #$73
        sta     twotrisRenderQueue+41
        lda     #$03
        sta     twotrisRenderQueue+42

        lda     twotrisLineCount+1
        and     #$0F
        sta     twotrisRenderQueue+43
        lda     twotrisLineCount
        lsr
        lsr
        lsr
        lsr
        sta     twotrisRenderQueue+44
        lda     twotrisLineCount
        and     #$0F
        sta     twotrisRenderQueue+45



; make sure this is all that is rendered
        lda     #$00
        sta     twotrisRenderQueue+46
        lda     #$2f
        sta     renderQueueIndex

        rts


STAGING_Y_ANCHOR := $7A
STAGING_X_ANCHOR := $C4

stageNextBox:
        lda     twotrisState
        bne     @notPaused
        rts

@notPaused:
        lda     twotrisDisplayNext
        beq     @displayNext
        rts

@displayNext:
; draw next sprites
        ldx     twotrisNextPiece
        ldy     twotrisOamIndex

        lda     twotrisAddressingTable,x
        bne     @shiftUp
        lda     #STAGING_Y_ANCHOR
        bne     @storeY
@shiftUp:
        lda     #STAGING_Y_ANCHOR - 6
@storeY:
        sta     oamStaging,y
        sta     oamStaging+4,y
        sta     oamStaging+8,y

; tiles
        lda     twotrisInstructionGroups,x
        asl
        clc
        adc     twotrisInstructionGroups,x
        tax

        lda     twotrisInstructionStrings,x
        sta     oamStaging+1,y
        lda     twotrisInstructionStrings+1,x
        sta     oamStaging+5,y
        lda     twotrisInstructionStrings+2,x
        sta     oamStaging+9,y

; Attributes
        lda     #$02
        sta     oamStaging+2,y
        sta     oamStaging+6,y
        sta     oamStaging+10,y


; X coords
        lda     #STAGING_X_ANCHOR
        sta     oamStaging+3,y
        lda     #STAGING_X_ANCHOR + 8
        sta     oamStaging+7,y
        lda     #STAGING_X_ANCHOR + 16
        sta     oamStaging+11,y

; Add 12 to oam index
        lda     twotrisOamIndex
        clc
        adc     #$0c
        sta     twotrisOamIndex

; draw next digits
        tay
        ldx     twotrisNextPiece

        lda     twotrisAddressingTable,x
        beq     @ret

; Y coords
        lda     #STAGING_Y_ANCHOR + 6
        sta     oamStaging,y
        sta     oamStaging+4,y
        sta     oamStaging+8,y


; tile
        lda     #$F9
        sta     oamStaging+1,y
        lda     twotrisNextDigit
        lsr
        lsr
        lsr
        lsr
        sta     oamStaging+5,y
        lda     twotrisNextDigit
        and     #$0f
        sta     oamStaging+9,y

; attributes
        lda     #$02
        sta     oamStaging+2,y
        sta     oamStaging+6,y
        sta     oamStaging+10,y

; X coords
        lda     #STAGING_X_ANCHOR
        sta     oamStaging+3,y
        lda     #STAGING_X_ANCHOR + 8
        sta     oamStaging+7,y
        lda     #STAGING_X_ANCHOR + 16
        sta     oamStaging+11,y

; Add 12 to oam index
        lda     twotrisOamIndex
        clc
        adc     #$0C
        sta     twotrisOamIndex


@ret:
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
@ret:   rts
