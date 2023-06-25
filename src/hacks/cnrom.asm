 changeCHRBank0:
 ; aca3
        pha                         ;1    
        lda     #$00                ;2
        sta     generalCounter      ;2
        txa                         ;1
        ora     generalCounter      ;2
        sta     generalCounter      ;2
        tya                         ;1
        ora     generalCounter      ;2
        sta     generalCounter      ;2
        lda     currentPpuCtrl      ;2
        and     #$E7                ;2
        ora     generalCounter      ;2
        sta     currentPpuCtrl      ;2
        sta     PPUCTRL             ;3
        pla                         ;1
        tax                         ;1
        sta     chrBankTable,x      ;3
        rts                         ;1
chrBankTable:
        .byte   $00,$01             ;2
        rts                         ;1  = 35

; padding
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00