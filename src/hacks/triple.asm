initTripleWide:
    lda     #$2C     ; glitch uses lower left nametable, no need to fix
    jsr     LAA82
    jsr bulkCopyToPpu
    .addr triplewide_nt
    rts

triplewide_nt:
    .byte $2C,$80,$D9,$33 ; left border
    .byte $2C,$9F,$D9,$34 ; right border
    .byte $2F,$A0,$01,$35 ; lower left corner
    .byte $2F,$BF,$01,$37 ; lower right corner
    .byte $2F,$A1,$5E,$36 ; bottom border
    .byte $2F,$C0,$48,$FF ; info attributes
    .byte $2F,$C8,$78,$AA ; playfield attributes
    .byte $FF
