
rotate_tetrimino:
        lda     currentPiece
        sta     originalY
        clc
        lda     currentPiece
        asl     a
        tax
        lda     newlyPressedButtons
        and     #$80
        cmp     #$80
        bne     @aNotPressed
        inx
        lda     rotationTable,x
        sta     currentPiece
        jsr     isPositionValid
        bne     @restoreOrientationID
        lda     #$05
        sta     soundEffectSlot1Init
        jmp     @ret

@aNotPressed:
        lda     newlyPressedButtons
        and     #$40
        cmp     #$40
        bne     @ret
        lda     rotationTable,x
        sta     currentPiece
        jsr     isPositionValid
        bne     @restoreOrientationID
        lda     #$05
        sta     soundEffectSlot1Init
        jmp     @ret

@restoreOrientationID:
        lda     originalY
        sta     currentPiece
@ret:   rts

rotationTable:
        .dbyt   $0301,$0002,$0103,$0200
        .dbyt   $0705,$0406,$0507,$0604
        .dbyt   $0909,$0808,$0A0A,$0C0C
        .dbyt   $0B0B,$100E,$0D0F,$0E10
        .dbyt   $0F0D,$1212,$1111
