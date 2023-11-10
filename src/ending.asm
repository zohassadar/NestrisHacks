
ending_initTypeBVars:
        lda     #$00
        sta     ending
        sta     ending_customVars
        sta     ending_typeBCathedralFrameDelayCounter
        lda     #$02
        sta     spriteIndexInOamContentLookup
        lda     levelNumber
        cmp     #$09
        bne     @notLevel9
        lda     player1_startHeight
        clc
        adc     #$01
        sta     ending
        jsr     ending_typeBConcertPatchToPpuForHeight
        lda     #$00
        sta     ending
        sta     ending_customVars+2
        lda     LA73D
        sta     ending_customVars+3
        lda     LA73E
        sta     ending_customVars+4
        lda     LA73F
        sta     ending_customVars+5
        lda     LA740
        sta     ending_customVars+6
        rts

@notLevel9:
        ldx     levelNumber
        lda     LA767,x
        sta     ending_customVars+2
        sta     ending_customVars+3
        sta     ending_customVars+4
        sta     ending_customVars+5
        sta     ending_customVars+6
        ldx     levelNumber
        lda     LA75D,x
        sta     ending_customVars+1
        rts

ending_typeBConcertPatchToPpuForHeight:
        lda     ending
        jsr     switch_s_plus_2a
        .addr   @heightUnused
        .addr   @height0
        .addr   @height1
        .addr   @height2
        .addr   @height3
        .addr   @height4
        .addr   @height5
@heightUnused:
        lda     #$A8
        sta     patchToPpuAddr+1
        lda     #$22
        sta     patchToPpuAddr
        jsr     patchToPpu
@height0:
        lda     #>ending_patchToPpu_typeBConcertHeight0
        sta     patchToPpuAddr+1
        lda     #<ending_patchToPpu_typeBConcertHeight0
        sta     patchToPpuAddr
        jsr     patchToPpu
@height1:
        lda     #>ending_patchToPpu_typeBConcertHeight1
        sta     patchToPpuAddr+1
        lda     #<ending_patchToPpu_typeBConcertHeight1
        sta     patchToPpuAddr
        jsr     patchToPpu
@height2:
        lda     #>ending_patchToPpu_typeBConcertHeight2
        sta     patchToPpuAddr+1
        lda     #<ending_patchToPpu_typeBConcertHeight2
        sta     patchToPpuAddr
        jsr     patchToPpu
@height3:
        lda     #>ending_patchToPpu_typeBConcertHeight3
        sta     patchToPpuAddr+1
        lda     #<ending_patchToPpu_typeBConcertHeight3
        sta     patchToPpuAddr
        jsr     patchToPpu
@height4:
        lda     #>ending_patchToPpu_typeBConcertHeight4
        sta     patchToPpuAddr+1
        lda     #<ending_patchToPpu_typeBConcertHeight4
        sta     patchToPpuAddr
        jsr     patchToPpu
@height5:
        rts

patchToPpu:
        ldy     #$00
@patchAddr:
        lda     (patchToPpuAddr),y
        sta     PPUADDR
        iny
        lda     (patchToPpuAddr),y
        sta     PPUADDR
        iny
@patchValue:
        lda     (patchToPpuAddr),y
        iny
        cmp     #$FE
        beq     @patchAddr
        cmp     #$FD
        beq     @ret
        sta     PPUDATA
        jmp     @patchValue

@ret:   rts

render_ending:
        lda     gameType
        bne     ending_typeB
        jmp     ending_typeA

ending_typeB:
        lda     levelNumber
        cmp     #$09
        beq     @typeBConcert
        jmp     ending_typeBCathedral

@typeBConcert:
        jsr     ending_typeBConcert
        rts

ending_typeBConcert:
        lda     player1_startHeight
        jsr     switch_s_plus_2a
        .addr   @kidIcarus
        .addr   @link
        .addr   @samus
        .addr   @donkeyKong
        .addr   @bowser
        .addr   @marioLuigiPeach
@marioLuigiPeach:
        lda     #$C8
        sta     spriteXOffset
        lda     #$47
        sta     spriteYOffset
        lda     frameCounter
        and     #$08
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$21
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
        lda     #$A0
        sta     spriteXOffset
        lda     #$27
        sta     spriteIndexInOamContentLookup
        lda     frameCounter
        and     #$18
        lsr     a
        lsr     a
        lsr     a
        tax
        lda     marioFrameToYOffsetTable,x
        sta     spriteYOffset
        cmp     #$97
        beq     @marioFrame1
        lda     #$28
        sta     spriteIndexInOamContentLookup
@marioFrame1:
        jsr     loadSpriteIntoOamStaging
@luigiCalculateFrame:
        lda     #$C0
        sta     spriteXOffset
        lda     ending
        lsr     a
        lsr     a
        lsr     a
        cmp     #$0A
        bne     @luigiFrameCalculated
        lda     #$00
        sta     ending
        inc     ending_customVars
        jmp     @luigiCalculateFrame

@luigiFrameCalculated:
        tax
        lda     luigiFrameToYOffsetTable,x
        sta     spriteYOffset
        lda     luigiFrameToSpriteTable,x
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
        inc     ending
@bowser:lda     #$30
        sta     spriteXOffset
        lda     #$A7
        sta     spriteYOffset
        lda     frameCounter
        and     #$10
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$1F
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
@donkeyKong:
        lda     #$40
        sta     spriteXOffset
        lda     #$77
        sta     spriteYOffset
        lda     frameCounter
        and     #$10
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$1D
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
@samus: lda     #$A8
        sta     spriteXOffset
        lda     #$D7
        sta     spriteYOffset
        lda     frameCounter
        and     #$10
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$1A
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
@link:  lda     #$C8
        sta     spriteXOffset
        lda     #$D7
        sta     spriteYOffset
        lda     frameCounter
        and     #$10
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$18
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
@kidIcarus:
        lda     #$28
        sta     spriteXOffset
        lda     #$77
        sta     spriteYOffset
        lda     frameCounter
        and     #$10
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #$16
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
        jsr     LA6BC
        rts

ending_typeBCathedral:
        jsr     ending_typeBCathedralSetSprite
        inc     ending_typeBCathedralFrameDelayCounter
        lda     #$00
        sta     ending_currentSprite
@spriteLoop:
        ldx     levelNumber
        lda     LA767,x
        sta     generalCounter
        ldx     ending_currentSprite
        lda     ending_customVars+1,x
        cmp     generalCounter
        beq     @continue
        sta     spriteXOffset
        jsr     ending_computeTypeBCathedralYTableIndex
        lda     ending_typeBCathedralYTable,x
        sta     spriteYOffset
        jsr     loadSpriteIntoOamStaging
        ldx     levelNumber
        lda     ending_typeBCathedralFrameDelayTable,x
        cmp     ending_typeBCathedralFrameDelayCounter
        bne     @continue
        ldx     levelNumber
        lda     ending_typeBCathedralVectorTable,x
        clc
        adc     spriteXOffset
        sta     spriteXOffset
        ldx     ending_currentSprite
        sta     ending_customVars+1,x
        jsr     ending_computeTypeBCathedralYTableIndex
        lda     ending_typeBCathedralXTable,x
        cmp     spriteXOffset
        bne     @continue
        ldx     levelNumber
        lda     LA75D,x
        ldx     ending_currentSprite
        inx
        sta     ending_customVars+1,x
@continue:
        lda     ending_currentSprite
        sta     generalCounter
        cmp     startHeight
        beq     @done
        inc     ending_currentSprite
        jmp     @spriteLoop

@done:  ldx     levelNumber
        lda     ending_typeBCathedralFrameDelayTable,x
        cmp     ending_typeBCathedralFrameDelayCounter
        bne     @ret
        lda     #$00
        sta     ending_typeBCathedralFrameDelayCounter
@ret:   rts

ending_typeBCathedralSetSprite:
        inc     ending
        ldx     levelNumber
        lda     ending_typeBCathedralAnimSpeed,x
        cmp     ending
        bne     @skipAnimSpriteChange
        lda     ending_customVars
        eor     #$01
        sta     ending_customVars
        lda     #$00
        sta     ending
@skipAnimSpriteChange:
        lda     ending_typeBCathedralSpriteTable,x
        clc
        adc     ending_customVars
        sta     spriteIndexInOamContentLookup
        rts

; levelNumber * 6 + currentEndingBSprite
ending_computeTypeBCathedralYTableIndex:
        lda     levelNumber
        asl     a
        sta     generalCounter
        asl     a
        clc
        adc     generalCounter
        clc
        adc     ending_currentSprite
        tax
        rts

LA6BC:  ldx     #$00
LA6BE:  lda     LA735,x
        cmp     ending_customVars
        bne     LA6D0
        lda     ending_customVars+3,x
        beq     LA6D0
        sec
        sbc     #$01
        sta     ending_customVars+3,x
        inc     ending_customVars
LA6D0:  inx
        cpx     #$04
        bne     LA6BE
        lda     #$00
        sta     ending_currentSprite
LA6D9:  ldx     ending_currentSprite
        lda     ending_customVars+3,x
        beq     LA72C
        sta     generalCounter
        lda     LA73D,x
        cmp     generalCounter
        beq     LA6F7
        lda     #$03
        sta     soundEffectSlot0Init
        dec     generalCounter
        lda     generalCounter
        cmp     #$A0
        bcs     LA6F7
        dec     generalCounter
LA6F7:  lda     generalCounter
        sta     ending_customVars+3,x
        sta     spriteYOffset
        lda     domeNumberToXOffsetTable,x
        sta     spriteXOffset
        lda     domeNumberToSpriteTable,x
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
        ldx     ending_currentSprite
        lda     ending_customVars+3,x
        sta     generalCounter
        lda     LA73D,x
        cmp     generalCounter
        beq     LA72C
        lda     LA745,x
        clc
        adc     spriteXOffset
        sta     spriteXOffset
        lda     frameCounter
        and     #$02
        lsr     a
        clc
        adc     #$51
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
LA72C:  inc     ending_currentSprite
        lda     ending_currentSprite
        cmp     #$04
        bne     LA6D9
        rts

LA735:  .byte   $05,$07,$09,$0B
domeNumberToXOffsetTable:
        .byte   $60,$90,$70,$7E
LA73D:  .byte   $BC
LA73E:  .byte   $B8
LA73F:  .byte   $BC
LA740:  .byte   $B3
domeNumberToSpriteTable:
        .byte   $4D,$50,$4E,$4F
LA745:  .byte   $00,$00,$00,$02
; Frames before changing to next frame's sprite
ending_typeBCathedralAnimSpeed:
        .byte   $02,$04,$06,$03,$10,$03,$05,$06
        .byte   $02,$05
; Number of frames to keep sprites in same position (inverse of vector table)
ending_typeBCathedralFrameDelayTable:
        .byte   $03,$01,$01,$01,$02,$05,$01,$02
        .byte   $01,$01
LA75D:  .byte   $02,$02,$FE,$FE,$02,$FE,$02,$02
        .byte   $FE,$02
LA767:  .byte   $00,$00,$00,$02,$F0,$10,$F0,$F0
        .byte   $20,$F0
ending_typeBCathedralVectorTable:
        .byte   $01,$01,$FF,$FC,$01,$FF,$02,$02
        .byte   $FE,$02
ending_typeBCathedralXTable:
        .byte   $3A,$24,$0A,$4A,$3A,$FF,$22,$44
        .byte   $12,$32,$4A,$FF,$AE,$6E,$8E,$6E
        .byte   $1E,$02,$42,$42,$42,$42,$42,$02
        .byte   $22,$0A,$1A,$04,$0A,$FF,$EE,$DE
        .byte   $FC,$FC,$F6,$02,$80,$80,$80,$80
        .byte   $80,$FF,$E8,$E8,$E8,$E8,$48,$FF
        .byte   $80,$AE,$9E,$90,$80,$02,$80,$80
        .byte   $80,$80,$80,$FF
ending_typeBCathedralYTable:
        .byte   $98,$A8,$C0,$A8,$90,$B0,$B0,$B8
        .byte   $A0,$B8,$A8,$A0,$C8,$C8,$C8,$C8
        .byte   $C8,$C8,$30,$20,$40,$28,$A0,$80
        .byte   $A8,$88,$68,$A8,$48,$78,$58,$68
        .byte   $18,$48,$78,$38,$C8,$C8,$C8,$C8
        .byte   $C8,$C8,$90,$58,$70,$A8,$40,$38
        .byte   $68,$88,$78,$18,$48,$A8,$C8,$C8
        .byte   $C8,$C8,$C8,$C8
ending_typeBCathedralSpriteTable:
        .byte   $2C,$2E,$54,$32,$34,$36,$4B,$38
        .byte   $3A,$4B
render_endingUnskippable:
        sta     sleepCounter
@loopUntilEnoughFrames:
        jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     sleepCounter
        bne     @loopUntilEnoughFrames
        rts

marioFrameToYOffsetTable:
        .byte   $97,$8F,$87,$8F
luigiFrameToYOffsetTable:
        .byte   $97,$8F,$87,$87,$8F,$97,$8F,$87
        .byte   $87,$8F
luigiFrameToSpriteTable:
        .byte   $29,$29,$29,$2A,$2A,$2A,$2A,$2A
        .byte   $29,$29
; Used by patchToPpu. Address followed by bytes to write. $FE to start next address. $FD to end
ending_patchToPpu_typeBConcertHeightUnused:
        .byte   $21,$A5,$FF,$FF,$FF,$FE,$21,$C5
        .byte   $FF,$FF,$FF,$FE,$21,$E5,$FF,$FF
        .byte   $FF,$FD
ending_patchToPpu_typeBConcertHeight0:
        .byte   $23,$1A,$FF,$FE,$23,$39,$FF,$FF
        .byte   $FF,$FE,$23,$59,$FF,$FF,$FF,$FE
        .byte   $23,$79,$FF,$FF,$FF,$FD
ending_patchToPpu_typeBConcertHeight1:
        .byte   $23,$15,$FF,$FF,$FF,$FE,$23,$35
        .byte   $FF,$FF,$FF,$FE,$23,$55,$FF,$FF
        .byte   $FF,$FE,$23,$75,$FF,$FF,$FF,$FD
ending_patchToPpu_typeBConcertHeight2:
        .byte   $21,$88,$FF,$FF,$FF,$FE,$21,$A8
        .byte   $FF,$FF,$FF,$FE,$21,$C8,$FF,$FF
        .byte   $FF,$FE,$21,$E8,$FF,$FF,$FF,$FD
ending_patchToPpu_typeBConcertHeight3:
        .byte   $22,$46,$FF,$FF,$FF,$FF,$FE,$22
        .byte   $66,$FF,$FF,$FF,$FF,$FE,$22,$86
        .byte   $FF,$FF,$FF,$FF,$FE,$22,$A6,$FF
        .byte   $FF,$FF,$FF,$FD
ending_patchToPpu_typeBConcertHeight4:
        .byte   $20,$F9,$FF,$FF,$FF,$FE,$21,$19
        .byte   $FF,$FF,$FF,$FE,$21,$39,$FF,$FF
        .byte   $FF,$FD
unreferenced_patchToPpu0:
        .byte   $23,$35,$FF,$FF,$FF,$FE,$23,$55
        .byte   $FF,$FF,$FF,$FE,$23,$75,$FF,$FF
        .byte   $FF,$FD
unreferenced_patchToPpu1:
        .byte   $23,$39,$FF,$FF,$FF,$FE,$23,$59
        .byte   $FF,$FF,$FF,$FE,$23,$79,$FF,$FF
        .byte   $FF,$FD
ending_patchToPpu_typeAOver120k:
        .byte   $22,$58,$FF,$FE,$22,$75,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FE,$22,$94,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE
        .byte   $22,$B4,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FE,$22,$D4,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FE,$22,$F4
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FE,$23,$14,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FE,$23,$34,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FE,$22
        .byte   $CA,$46,$47,$FE,$22,$EA,$56,$57
        .byte   $FD
unreferenced_data6:
        .byte   $FC
LA926:  jsr     updateAudioWaitForNmiAndDisablePpuRendering
        jsr     disableNmi
.ifdef CNROM
        nop     ; padded out for GG codes & mods
        lda     #CNROM_BANK1
        ldy     #CNROM_BG0
        ldx     #CNROM_SPRITE0
        jsr     changeCHRBank0
        ; a936
.else
        lda     #$02
        jsr     changeCHRBank0
        lda     #$02
        jsr     changeCHRBank1
.endif
        jsr     bulkCopyToPpu
        .addr   type_a_ending_nametable
        jsr     bulkCopyToPpu
        .addr   ending_palette
        jsr     LA96E
        jsr     waitForVBlankAndEnableNmi
        jsr     updateAudioWaitForNmiAndResetOamStaging
        jsr     updateAudioWaitForNmiAndEnablePpuRendering
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     #$04
        sta     renderMode
        lda     #$0A
        jsr     setMusicTrack
        lda     #$80
.ifdef TOURNAMENT
        jmp     render_endingSkippable_A
.else
        jsr     render_endingUnskippable
.endif
LA95D:  jsr     render_ending
        jsr     updateAudioWaitForNmiAndResetOamStaging
        lda     ending_customVars
        bne     LA95D
        lda     newlyPressedButtons_player1
        cmp     #$10
        bne     LA95D
        rts

LA96E:  lda     #$00
        sta     ending
        lda     player1_score+2
        cmp     #$05
        bcc     ending_selected
        lda     #$01
        sta     ending
        lda     player1_score+2
        cmp     #$07
        bcc     ending_selected
        lda     #$02
        sta     ending
        lda     player1_score+2
        cmp     #$10
        bcc     ending_selected
        lda     #$03
        sta     ending
        lda     player1_score+2
        cmp     #$12
        bcc     ending_selected
        lda     #$04
        sta     ending
        lda     #>ending_patchToPpu_typeAOver120k
        sta     patchToPpuAddr+1
        lda     #<ending_patchToPpu_typeAOver120k
        sta     patchToPpuAddr
        jsr     patchToPpu
ending_selected:
        ldx     ending
        lda     LAA2A,x
        sta     ending_customVars
        lda     #$00
        sta     ending_customVars+1
        rts

ending_typeA:
        lda     ending_customVars
        cmp     #$00
        beq     LAA10
        sta     spriteYOffset
        lda     #$58
        ldx     ending
        lda     rocketToXOffsetTable,x
        sta     spriteXOffset
        lda     rocketToSpriteTable,x
        sta     spriteIndexInOamContentLookup
        jsr     loadSpriteIntoOamStaging
        lda     ending
        asl     a
        sta     generalCounter
        lda     frameCounter
        and     #$02
        lsr     a
        clc
        adc     generalCounter
        tax
        lda     rocketToJetSpriteTable,x
        sta     spriteIndexInOamContentLookup
        ldx     ending
        lda     rocketToJetXOffsetTable,x
        clc
        adc     spriteXOffset
        sta     spriteXOffset
        jsr     loadSpriteIntoOamStaging
        lda     ending_customVars+1
        cmp     #$F0
        bne     LAA0E
        lda     ending_customVars
        cmp     #$B0
        bcc     LA9FC
        lda     frameCounter
        and     #$01
        bne     LAA0B
LA9FC:  lda     #$03
        sta     soundEffectSlot0Init
        dec     ending_customVars
        lda     ending_customVars
        cmp     #$80
        bcs     LAA0B
        dec     ending_customVars
LAA0B:  jmp     LAA10

LAA0E:  inc     ending_customVars+1
LAA10:  rts

rocketToSpriteTable:
        .byte   $3E,$41,$44,$47,$4A
rocketToJetSpriteTable:
        .byte   $3F,$40,$42,$43,$45,$46,$48,$49
        .byte   $23,$24
rocketToJetXOffsetTable:
        .byte   $00,$00,$00,$00,$00
rocketToXOffsetTable:
        .byte   $54,$54,$50,$48,$A0
LAA2A:  .byte   $BF,$BF,$BF,$BF,$C7