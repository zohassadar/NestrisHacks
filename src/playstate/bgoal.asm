playState_bTypeGoalCheck:
        lda     gameType
        beq     @ret
        lda     lines
        bne     @ret
        lda     #$02
        jsr     setMusicTrack
        ldy     #$46
        ldx     #$00
@copySuccessGraphic:
        lda     typebSuccessGraphic,x
        cmp     #$80
        beq     @graphicCopied
        sta     (playfieldAddr),y
        inx
        iny
        jmp     @copySuccessGraphic

@graphicCopied:  lda     #$00
        sta     player1_vramRow
.ifdef TRIPLEWIDE
        jsr     sleep_for_14_vblanks_alt
.else
        jsr     sleep_for_14_vblanks
.endif
        lda     #$00
        sta     renderMode
        lda     #$80
.ifdef TRIPLEWIDE
        jsr     sleep_for_a_vblanks_alt
.else
        jsr     sleep_for_a_vblanks
.endif
        jsr     endingAnimation_maybe
        lda     #$00
        sta     playState
        inc     gameModeState
        rts

@ret:  inc     playState
        rts

typebSuccessGraphic:
        .byte   $38,$39,$39,$39,$39,$39,$39,$39
        .byte   $39,$3A,$3B,$1C,$1E,$0C,$0C,$0E
        .byte   $1C,$1C,$28,$3C,$3D,$3E,$3E,$3E
        .byte   $3E,$3E,$3E,$3E,$3E,$3F,$80
