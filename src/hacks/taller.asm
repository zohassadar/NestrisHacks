multBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE,$C8,$D2,$DC,$E6

vramPlayfieldRows:
        .word               $2086,$20A6
        .word   $20C6,$20E6,$2106,$2126
        .word   $2146,$2166,$2186,$21A6
        .word   $21C6,$21E6,$2206,$2226
        .word   $2246,$2266,$2286,$22A6
        .word   $22C6,$22E6,$2306,$2326
        .word   $2346,$2366

game_typeb_hyphen_patch:
        .byte   $22,$BB,$24,$FD

copyPlayfieldRowToVRAM3Times:
        jsr     copyPlayfieldRowToVRAM
        jsr     copyPlayfieldRowToVRAM
        jmp     copyPlayfieldRowToVRAM
