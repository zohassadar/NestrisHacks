
; canon is adjustMusicSpeed
setMusicTrack:
        sta     musicTrack
        lda     gameMode
        cmp     #$05
        bne     @ret
        lda     #$FF
        sta     musicTrack
@ret:   rts
