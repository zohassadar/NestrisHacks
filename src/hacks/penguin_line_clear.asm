; 0 = show next piece (32 bytes in oam staging), 1 = not what 0 equals (16 bytes)
oamStagingLengthBasedOnNextBox:
        .byte   $20,$10 

penguinXOffset:   ; First byte not used and serves as offset only
        .byte  $00,$58,$5C,$60,$64,$68,$6C,$70
        .byte  $74,$78,$7C,$80,$84,$88,$8C,$90
        .byte  $94,$98,$9C,$A0,$A4

updateLineClearingAnimation:
        ;   Load 16 or 32 into oamStagingLength based on next box display
        ;   This prevents the next box from disappearing without calling stageSpriteForNextPiece
        ldy     displayNextPiece
        lda     oamStagingLengthBasedOnNextBox,y
        sta     oamStagingLength

        ;  Load Y offset based on table
        ldx     rowY
        lda     penguinXOffset,x
        sta     spriteXOffset

        ; Figure out lowest row cleared and put penguin there. 
        ldx     #$03                     
@nextRowToCheck:
        lda     completedRow,x
        beq     @decrementX    
        jmp     @foundRow
@decrementX:
        dex
        cpx     #$FF
        bne     @nextRowToCheck

@foundRow:
        rol
        rol
        rol
        clc     
        adc     #$2C
        sta     spriteYOffset
        lda     rowY
        and     #$01
        clc
        adc     #$54
        sta     spriteIndexInOamContentLookup


        ; I still don't think this is appropriate to do here, but it keeps the modification contained
        jsr     loadSpriteIntoOamStaging

; Clear block
        lda     rowY
        and     #$01
        bne     @skipBlockClear
        sta     generalCounter3 ; Countup through all four rows (0,1,2,3)
@whileCounter3LessThan4:

        ldy     generalCounter3
        lda     completedRow,y
        beq     @nextRow       ; Skip row if no line clear
        asl                    ; Multiply by 2 to get second byte of address from table
        tay
        iny
        lda     vramPlayfieldRows,y  ; first byte of PPU address
        sta     PPUADDR
        lda     rowY           ; Divide by 2 to get row to clear
        ror
        clc
        dey
        adc     vramPlayfieldRows,y  ; Add to get 2nd byte of PPU address
        adc     #$05                 ; Offset to line up with 1 player screen

        sta     PPUADDR

        lda     #$FF                 ; blank tile
        sta     PPUDATA
@nextRow:
        inc     generalCounter3
        lda     generalCounter3
        cmp     #$04
        bne     @whileCounter3LessThan4
; --------------

@skipBlockClear:
        dec     rowY
        bne     @ret
        inc     playState
@ret:   rts

padding:
        .byte   $00,$00,$00,$00 ; This keeps the above modification contained so game genie codes work for the rest of the game

; No longer necessary, removed for padding purposes
; leftColumns:
;         .byte   $04,$03,$02,$01,$00
rightColumns:
        .byte   $05,$06,$07,$08,$09
