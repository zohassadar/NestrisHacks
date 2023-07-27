.ifdef MINIMAL_ARE
slightlyBiggerMultBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE,$C8
.else
unreferenced_data2:
        .byte   $00,$FF,$FE,$FD,$FC,$FD,$FE,$FF
        .byte   $00,$01,$02,$03,$04,$05,$06,$07
        .byte   $08,$09,$0A,$0B,$0C
.endif
        .byte $0D,$0E,$0F,$10,$11,$12,$13

