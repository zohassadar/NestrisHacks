oamContentLookup:
        .addr   sprite00LevelSelectCursor
        .addr   sprite01GameTypeCursor
        .addr   sprite02Blank
        .addr   sprite03PausePalette6
        .addr   sprite05PausePalette4
        .addr   sprite05PausePalette4
        .addr   sprite06TPiece
        .addr   sprite07SPiece
        .addr   sprite08ZPiece
        .addr   sprite09JPiece
        .addr   sprite0ALPiece
        .addr   sprite0BOPiece
        .addr   sprite0CIPiece
        .addr   sprite0EHighScoreNameCursor
        .addr   sprite0EHighScoreNameCursor
.ifdef PENGUIN
        .addr   sprite0FPenguineLineClear1
        .addr   sprite10PenguineLineClear2
.else
        .addr   sprite0FTPieceOffset
        .addr   sprite10SPieceOffset
.endif
        .addr   sprite11ZPieceOffset
        .addr   sprite12JPieceOffset
        .addr   sprite13LPieceOffset
        .addr   sprite14OPieceOffset
        .addr   sprite15IPieceOffset
        .addr   sprite16KidIcarus1
        .addr   sprite17KidIcarus2
        .addr   sprite18Link1
        .addr   sprite19Link2
        .addr   sprite1ASamus1
        .addr   sprite1BSamus2
        .addr   sprite1CDonkeyKong_armsClosed
        .addr   sprite1DDonkeyKong1
        .addr   sprite1EDonkeyKong2
        .addr   sprite1FBowser1
        .addr   sprite20Bowser2
        .addr   sprite21PrincessPeach1
        .addr   sprite22PrincessPeach2
        .addr   sprite23CathedralRocketJet1
        .addr   sprite24CathedralRocketJet2
        .addr   sprite25CloudLarge
        .addr   sprite26CloudSmall
        .addr   sprite27Mario1
        .addr   sprite28Mario2
        .addr   sprite29Luigi1
        .addr   sprite2ALuigi2
        .addr   sprite2CDragonfly1
        .addr   sprite2CDragonfly1
        .addr   sprite2DDragonfly2
        .addr   sprite2EDove1
        .addr   sprite2FDove2
        .addr   sprite30Airplane1
        .addr   sprite31Airplane2
        .addr   sprite32Ufo1
        .addr   sprite33Ufo2
        .addr   sprite34Pterosaur1
        .addr   sprite35Pterosaur2
        .addr   sprite36Blimp1
        .addr   sprite37Blimp2
        .addr   sprite38Dragon1
        .addr   sprite39Dragon2
        .addr   sprite3ABuran1
        .addr   sprite3BBuran2
        .addr   sprite3CHelicopter1
        .addr   sprite3DHelicopter2
        .addr   sprite3ESmallRocket
        .addr   sprite3FSmallRocketJet1
        .addr   sprite40SmallRocketJet2
        .addr   sprite41MediumRocket
        .addr   sprite42MediumRocketJet1
        .addr   sprite43MediumRocketJet2
        .addr   sprite44LargeRocket
        .addr   sprite45LargeRocketJet1
        .addr   sprite46LargeRocketJet2
        .addr   sprite47BuranRocket
        .addr   sprite48BuranRocketJet1
        .addr   sprite49BuranRocketJet2
        .addr   sprite4ACathedralRocket
        .addr   sprite4BOstrich1
        .addr   sprite4COstrich2
        .addr   sprite4DCathedralEasternDome
        .addr   sprite4ECathedralNorthernDome
        .addr   sprite4FCathedralCentralDome
        .addr   sprite50CathedralWesternDome
        .addr   sprite51CathedralDomeRocketJet1
        .addr   sprite52CathedralDomeRocketJet2
        .addr   sprite53MusicTypeCursor
        .addr   sprite54Penguin1
        .addr   sprite55Penguin2
        .addr   isPositionValid
        .addr   isPositionValid
        .addr   isPositionValid
        .addr   isPositionValid
; Sprites are sets of 4 bytes in the OAM format, terminated by FF. byte0=y, byte1=tile, byte2=attrs, byte3=x
sprite00LevelSelectCursor:
        .byte   $00,$FC,$20,$00,$00,$FC,$20,$08
        .byte   $08,$FC,$20,$00,$08,$FC,$20,$08
        .byte   $FF
sprite01GameTypeCursor:
        .byte   $00,$27,$00,$00,$00,$27,$40,$3A
        .byte   $FF
; Used as a sort of NOOP for cursors
sprite02Blank:
        .byte   $00,$FF,$00,$00,$FF
sprite03PausePalette6:
        .byte   $00,$19,$02,$00,$00,$0A,$02,$08
        .byte   $00,$1E,$02,$10,$00,$1C,$02,$18
        .byte   $00,$0E,$02,$20,$FF
sprite05PausePalette4:
        .byte   $00,$19,$00,$00,$00,$0A,$00,$08
        .byte   $00,$1E,$00,$10,$00,$1C,$00,$18
        .byte   $00,$0E,$00,$20,$FF
sprite06TPiece:
        .byte   $00,$7B,$02,$FC,$00,$7B,$02,$04
        .byte   $00,$7B,$02,$0C,$08,$7B,$02,$04
        .byte   $FF
sprite07SPiece:
        .byte   $00,$7D,$02,$04,$00,$7D,$02,$0C
        .byte   $08,$7D,$02,$FC,$08,$7D,$02,$04
        .byte   $FF
sprite08ZPiece:
        .byte   $00,$7C,$02,$FC,$00,$7C,$02,$04
        .byte   $08,$7C,$02,$04,$08,$7C,$02,$0C
        .byte   $FF
sprite09JPiece:
        .byte   $00,$7D,$02,$FC,$00,$7D,$02,$04
        .byte   $00,$7D,$02,$0C,$08,$7D,$02,$0C
        .byte   $FF
sprite0ALPiece:
        .byte   $00,$7C,$02,$FC,$00,$7C,$02,$04
        .byte   $00,$7C,$02,$0C,$08,$7C,$02,$FC
        .byte   $FF
sprite0BOPiece:
        .byte   $00,$7B,$02,$00,$00,$7B,$02,$08
        .byte   $08,$7B,$02,$00,$08,$7B,$02,$08
        .byte   $FF
sprite0CIPiece:
        .byte   $04,$7B,$02,$F8,$04,$7B,$02,$00
        .byte   $04,$7B,$02,$08,$04,$7B,$02,$10
        .byte   $FF
sprite0EHighScoreNameCursor:
        .byte   $00,$FC,$21,$00,$FF
.ifdef PENGUIN
; Penguins used for line clear are modified from ending screen penguin
; Priority and palette are changed from $21 to $03
; https://www.nesdev.org/wiki/PPU_OAM

.ifdef UPSIDEDOWN
sprite0FPenguineLineClear1:
        .byte   $18,$A9,$83,$00
        .byte   $18,$AA,$83,$08
        .byte   $10,$B8,$83,$F8
        .byte   $10,$B9,$83,$00
        .byte   $10,$BA,$83,$08
        .byte   $08,$C9,$83,$00
        .byte   $08,$CA,$83,$08
        .byte   $08,$CB,$83,$10
        .byte   $00,$D9,$83,$00
        .byte   $00,$DA,$83,$08
        .byte   $FF
sprite10PenguineLineClear2:
        .byte   $18,$AD,$83,$00
        .byte   $18,$AE,$83,$08
        .byte   $10,$BC,$83,$F8
        .byte   $10,$BD,$83,$00
        .byte   $10,$BE,$83,$08
        .byte   $08,$CD,$83,$00
        .byte   $08,$CE,$83,$08
        .byte   $08,$CF,$83,$10
        .byte   $00,$DD,$83,$00
        .byte   $00,$DE,$83,$08
        .byte   $FF
.else
sprite0FPenguineLineClear1:
        .byte   $E8,$A9,$03,$00
        .byte   $E8,$AA,$03,$08
        .byte   $F0,$B8,$03,$F8
        .byte   $F0,$B9,$03,$00
        .byte   $F0,$BA,$03,$08
        .byte   $F8,$C9,$03,$00
        .byte   $F8,$CA,$03,$08
        .byte   $F8,$CB,$03,$10
        .byte   $00,$D9,$03,$00
        .byte   $00,$DA,$03,$08
        .byte   $FF
sprite10PenguineLineClear2:
        .byte   $E8,$AD,$03,$00
        .byte   $E8,$AE,$03,$08
        .byte   $F0,$BC,$03,$F8
        .byte   $F0,$BD,$03,$00
        .byte   $F0,$BE,$03,$08
        .byte   $F8,$CD,$03,$00
        .byte   $F8,$CE,$03,$08
        .byte   $F8,$CF,$03,$10
        .byte   $00,$DD,$03,$00
        .byte   $00,$DE,$03,$08
        .byte   $FF
.endif
        ;Pad with the appropriate number of bytes
        .byte  $00,$00,$00,$00,$00,$00,$00,$00
        .byte  $00,$00,$00,$00,$00,$00,$00,$00
        .byte  $00,$00,$00,$00,$00,$00,$00,$00
        .byte  $00,$00,$00,$00,$00,$00,$00,$00
        .byte  $00,$00,$00,$00,$00


; maintain same number of labels to account for constants in offsets
sprite11ZPieceOffset:
sprite12JPieceOffset:
sprite13LPieceOffset:
sprite14OPieceOffset:
sprite15IPieceOffset:
.else
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite0FTPieceOffset:
        ; .byte   $02,$7B,$02,$FC,$02,$7B,$02,$04
        ; .byte   $02,$7B,$02,$0C,$0A,$7B,$02,$04
        ; .byte   $FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite10SPieceOffset:
        ; .byte   $00,$7D,$02,$06,$00,$7D,$02,$0E
        ; .byte   $08,$7D,$02,$FE,$08,$7D,$02,$06
        ; .byte   $FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite11ZPieceOffset:
        ; .byte   $00,$7C,$02,$FA,$00,$7C,$02,$02
        ; .byte   $08,$7C,$02,$02,$08,$7C,$02,$0A
        ; .byte   $FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite12JPieceOffset:
        ; .byte   $08,$7D,$02,$00,$08,$7D,$02,$08
        ; .byte   $08,$7D,$02,$10,$10,$7D,$02,$10
        ; .byte   $FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite13LPieceOffset:
        ; .byte   $08,$7C,$02,$F8,$08,$7C,$02,$00
        ; .byte   $08,$7C,$02,$08,$10,$7C,$02,$F8
        ; .byte   $FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite14OPieceOffset:
        ; .byte   $00,$7B,$02,$00,$00,$7B,$02,$08
        ; .byte   $08,$7B,$02,$00,$08,$7B,$02,$08
        ; .byte   $FF
; Unused, but referenced from unreferenced_orientationToSpriteTable
sprite15IPieceOffset:
        ; .byte   $08,$7B,$02,$F8,$08,$7B,$02,$00
        ; .byte   $08,$7B,$02,$08,$08,$7B,$02,$10
        ; .byte   $FF
.endif
sprite16KidIcarus1:
        .byte   $F0,$95,$01,$10,$F8,$A3,$01,$00
        .byte   $F8,$A4,$01,$08,$F8,$A5,$01,$10
        .byte   $FF
sprite17KidIcarus2:
        .byte   $F8,$83,$01,$00,$F8,$84,$01,$08
        .byte   $F8,$85,$01,$10,$FF
sprite18Link1:
        .byte   $F0,$90,$00,$00,$F8,$A0,$00,$00
        .byte   $FF
sprite19Link2:
        .byte   $F0,$C4,$00,$00,$F8,$D4,$00,$00
        .byte   $FF
sprite1ASamus1:
        .byte   $E8,$28,$00,$08,$E8,$2A,$00,$10
        .byte   $F0,$C8,$03,$10,$F8,$D6,$03,$00
        .byte   $F8,$D7,$03,$08,$F8,$D8,$03,$10
        .byte   $FF
sprite1BSamus2:
        .byte   $E8,$28,$00,$08,$E8,$2A,$00,$10
        .byte   $F0,$B9,$03,$10,$F8,$F6,$03,$00
        .byte   $F8,$F7,$03,$08,$F8,$F8,$03,$10
        .byte   $FF
; Unused. Strange there isn't an unused arms open as well
sprite1CDonkeyKong_armsClosed:
        .byte   $E8,$C9,$02,$00,$E8,$CB,$02,$10
        .byte   $F0,$D9,$02,$00,$F0,$DB,$02,$10
        .byte   $F8,$E9,$02,$00,$F8,$EB,$02,$10
        .byte   $FF
sprite1DDonkeyKong1:
        .byte   $E8,$46,$02,$F8,$E8,$47,$02,$00
        .byte   $E8,$CB,$02,$10,$F0,$56,$02,$F8
        .byte   $F0,$57,$02,$00,$F0,$DB,$02,$10
        .byte   $F8,$87,$02,$00,$F8,$EB,$02,$10
        .byte   $FF
sprite1EDonkeyKong2:
        .byte   $E8,$C9,$02,$00,$E8,$66,$02,$10
        .byte   $E8,$67,$02,$18,$F0,$D9,$02,$00
        .byte   $F0,$76,$02,$10,$F0,$77,$02,$18
        .byte   $F8,$E9,$02,$00,$F8,$86,$02,$10
        .byte   $FF
sprite1FBowser1:
        .byte   $F8,$E1,$00,$08,$F8,$E2,$00,$10
        .byte   $00,$F1,$00,$08,$00,$C5,$00,$10
        .byte   $00,$D5,$00,$18,$FF
sprite20Bowser2:
        .byte   $F8,$E4,$00,$08,$F8,$E5,$00,$10
        .byte   $00,$F4,$00,$08,$00,$F5,$00,$10
        .byte   $00,$F3,$00,$18,$FF
sprite21PrincessPeach1:
        .byte   $00,$63,$01,$00,$00,$64,$01,$08
        .byte   $FF
sprite22PrincessPeach2:
        .byte   $00,$73,$01,$00,$00,$74,$01,$08
        .byte   $FF
sprite23CathedralRocketJet1:
        .byte   $08,$A8,$23,$18,$08,$A9,$23,$20
        .byte   $FF
sprite24CathedralRocketJet2:
        .byte   $08,$AA,$23,$10,$08,$AB,$23,$18
        .byte   $08,$AC,$23,$20,$08,$AD,$23,$28
        .byte   $10,$BA,$23,$10,$10,$BB,$23,$18
        .byte   $10,$BC,$23,$20,$10,$BD,$23,$28
        .byte   $FF
; Seems unused
sprite25CloudLarge:
        .byte   $00,$60,$21,$00,$00,$61,$21,$08
        .byte   $00,$62,$21,$10,$08,$70,$21,$00
        .byte   $08,$71,$21,$08,$08,$72,$21,$10
        .byte   $FF
; Seems unused. Broken? Seems $81 should be $81
sprite26CloudSmall:
        .byte   $00,$80,$21,$00,$00,$81,$21,$08
        .byte   $FF
sprite27Mario1:
        .byte   $F0,$30,$03,$00,$F0,$31,$03,$08
        .byte   $F0,$32,$03,$10,$F8,$40,$03,$00
        .byte   $F8,$41,$03,$08,$F8,$42,$03,$10
        .byte   $00,$50,$03,$00,$00,$51,$03,$08
        .byte   $00,$52,$03,$10,$FF
sprite28Mario2:
        .byte   $F8,$23,$03,$00,$F8,$24,$03,$08
        .byte   $F8,$25,$03,$10,$00,$33,$03,$00
        .byte   $00,$34,$03,$08,$00,$35,$03,$10
        .byte   $FF
sprite29Luigi1:
        .byte   $F0,$30,$00,$00,$F0,$31,$00,$08
        .byte   $F0,$32,$00,$10,$F8,$29,$00,$00
        .byte   $F8,$41,$00,$08,$F8,$2B,$00,$10
        .byte   $00,$2C,$00,$00,$00,$2D,$00,$08
        .byte   $00,$2E,$00,$10,$FF
sprite2ALuigi2:
        .byte   $F0,$32,$40,$00,$F0,$31,$40,$08
        .byte   $F0,$30,$40,$10,$F8,$2B,$40,$00
        .byte   $F8,$41,$40,$08,$F8,$29,$40,$10
        .byte   $00,$2E,$40,$00,$00,$2D,$40,$08
        .byte   $00,$2C,$40,$10,$FF
sprite2CDragonfly1:
        .byte   $00,$20,$23,$00,$FF
sprite2DDragonfly2:
        .byte   $00,$21,$23,$00,$FF
sprite2EDove1:
        .byte   $F8,$22,$21,$00,$F8,$23,$21,$08
        .byte   $00,$32,$21,$00,$00,$33,$21,$08
        .byte   $FF
sprite2FDove2:
        .byte   $F8,$24,$21,$00,$F8,$25,$21,$08
        .byte   $00,$34,$21,$00,$00,$35,$21,$08
        .byte   $FF
; Unused
sprite30Airplane1:
        .byte   $F8,$26,$21,$F0,$F8,$27,$21,$F8
        .byte   $00,$36,$21,$F0,$00,$37,$21,$F8
        .byte   $FF
; Unused
sprite31Airplane2:
        .byte   $F8,$28,$21,$F0,$F8,$27,$21,$F8
        .byte   $00,$29,$21,$F0,$00,$37,$21,$F8
        .byte   $FF
sprite32Ufo1:
        .byte   $F8,$46,$21,$F0,$F8,$47,$21,$F8
        .byte   $00,$56,$21,$F0,$00,$57,$21,$F8
        .byte   $FF
sprite33Ufo2:
        .byte   $F8,$46,$21,$F0,$F8,$47,$21,$F8
        .byte   $00,$66,$21,$F0,$00,$67,$21,$F8
        .byte   $FF
sprite34Pterosaur1:
        .byte   $F8,$43,$22,$00,$F8,$44,$22,$08
        .byte   $F8,$45,$22,$10,$00,$53,$22,$00
        .byte   $00,$54,$22,$08,$00,$55,$22,$10
        .byte   $FF
sprite35Pterosaur2:
        .byte   $F8,$63,$22,$00,$F8,$64,$22,$08
        .byte   $F8,$65,$22,$10,$00,$73,$22,$00
        .byte   $00,$74,$22,$08,$00,$75,$22,$10
        .byte   $FF
sprite36Blimp1:
        .byte   $F8,$40,$21,$E8,$F8,$41,$21,$F0
        .byte   $F8,$42,$21,$F8,$00,$50,$21,$E8
        .byte   $00,$51,$21,$F0,$00,$52,$21,$F8
        .byte   $FF
sprite37Blimp2:
        .byte   $F8,$40,$21,$E8,$F8,$41,$21,$F0
        .byte   $F8,$42,$21,$F8,$00,$50,$21,$E8
        .byte   $00,$30,$21,$F0,$00,$52,$21,$F8
        .byte   $FF
sprite38Dragon1:
        .byte   $F8,$90,$23,$08,$F8,$A2,$23,$10
        .byte   $00,$91,$23,$F0,$00,$92,$23,$F8
        .byte   $00,$B0,$23,$00,$00,$A0,$23,$08
        .byte   $00,$B2,$23,$10,$00,$B3,$23,$18
        .byte   $08,$C0,$23,$00,$08,$C1,$23,$08
        .byte   $FF
sprite39Dragon2:
        .byte   $F8,$A1,$23,$08,$F8,$A2,$23,$10
        .byte   $00,$91,$23,$F0,$00,$92,$23,$F8
        .byte   $00,$B0,$23,$00,$00,$B1,$23,$08
        .byte   $00,$B2,$23,$10,$00,$B3,$23,$18
        .byte   $08,$C0,$23,$00,$08,$C1,$23,$08
        .byte   $FF
sprite3ABuran1:
        .byte   $F8,$D3,$21,$F0,$00,$E1,$21,$E0
        .byte   $00,$E2,$21,$E8,$00,$E3,$21,$F0
        .byte   $08,$F0,$21,$D8,$08,$F1,$21,$E0
        .byte   $08,$F2,$21,$E8,$08,$F3,$21,$F0
        .byte   $08,$D1,$21,$F8,$08,$D2,$21,$00
        .byte   $FF
sprite3BBuran2:
        .byte   $F8,$D3,$21,$F0,$00,$E1,$21,$E0
        .byte   $00,$E2,$21,$E8,$00,$E3,$21,$F0
        .byte   $08,$F0,$21,$D8,$08,$F1,$21,$E0
        .byte   $08,$F2,$21,$E8,$08,$F3,$21,$F0
        .byte   $08,$D0,$21,$F8,$FF
; Unused
sprite3CHelicopter1:
        .byte   $F8,$83,$23,$E8,$F8,$84,$23,$F0
        .byte   $F8,$85,$23,$F8,$00,$93,$23,$E8
        .byte   $00,$94,$23,$F0,$FF
; Unused
sprite3DHelicopter2:
        .byte   $F8,$A3,$23,$E8,$F8,$A4,$23,$F0
        .byte   $F8,$A5,$23,$F8,$00,$93,$23,$E8
        .byte   $00,$94,$23,$F0,$FF
sprite3ESmallRocket:
        .byte   $00,$A6,$23,$00,$FF
sprite3FSmallRocketJet1:
        .byte   $08,$A7,$23,$00,$FF
sprite40SmallRocketJet2:
        .byte   $08,$F4,$23,$00,$FF
sprite41MediumRocket:
        .byte   $F8,$B4,$21,$00,$00,$C4,$21,$00
        .byte   $FF
sprite42MediumRocketJet1:
        .byte   $08,$D4,$23,$00,$FF
sprite43MediumRocketJet2:
        .byte   $08,$E4,$23,$00,$FF
sprite44LargeRocket:
        .byte   $E8,$B5,$23,$00,$E8,$B6,$23,$08
        .byte   $F0,$C5,$23,$00,$F0,$C6,$23,$08
        .byte   $F8,$D5,$23,$00,$F8,$D6,$23,$08
        .byte   $00,$E5,$23,$00,$00,$E6,$23,$08
        .byte   $FF
sprite45LargeRocketJet1:
        .byte   $08,$F5,$23,$00,$08,$F6,$23,$08
        .byte   $FF
sprite46LargeRocketJet2:
        .byte   $08,$B7,$23,$00,$08,$B8,$23,$08
        .byte   $FF
sprite47BuranRocket:
        .byte   $D0,$C2,$21,$08,$D0,$C3,$21,$10
        .byte   $D8,$CB,$21,$08,$D8,$EB,$21,$10
        .byte   $E0,$DB,$21,$08,$E0,$FB,$21,$10
        .byte   $E8,$C7,$21,$00,$E8,$C8,$21,$08
        .byte   $E8,$C9,$21,$10,$E8,$CA,$21,$18
        .byte   $F0,$D7,$21,$00,$F0,$D8,$21,$08
        .byte   $F0,$D9,$21,$10,$F0,$DA,$21,$18
        .byte   $F8,$E7,$21,$00,$F8,$E8,$21,$08
        .byte   $F8,$E9,$21,$10,$F8,$EA,$21,$18
        .byte   $00,$F7,$21,$00,$00,$F8,$21,$08
        .byte   $00,$F9,$21,$10,$00,$FA,$21,$18
        .byte   $FF
sprite48BuranRocketJet1:
        .byte   $08,$2A,$23,$08,$08,$2B,$23,$10
        .byte   $FF
sprite49BuranRocketJet2:
        .byte   $08,$2C,$23,$08,$08,$2D,$23,$10
        .byte   $10,$2E,$23,$08,$10,$2F,$23,$10
        .byte   $FF
sprite4ACathedralRocket:
        .byte   $C8,$38,$23,$20,$D0,$39,$23,$08
        .byte   $D0,$3B,$23,$18,$D0,$3C,$23,$20
        .byte   $D0,$3E,$23,$30,$D0,$3F,$23,$38
        .byte   $D8,$48,$23,$00,$D8,$49,$23,$08
        .byte   $D8,$4A,$23,$10,$D8,$4B,$23,$18
        .byte   $D8,$4C,$23,$20,$D8,$4D,$23,$28
        .byte   $D8,$4E,$20,$30,$D8,$4F,$20,$38
        .byte   $E0,$58,$23,$00,$E0,$59,$23,$08
        .byte   $E0,$5A,$23,$10,$E0,$5B,$23,$18
        .byte   $E0,$5C,$23,$20,$E0,$5D,$23,$28
        .byte   $E0,$5E,$20,$30,$E0,$5F,$20,$38
        .byte   $E8,$68,$23,$00,$E8,$69,$23,$08
        .byte   $E8,$6A,$23,$10,$E8,$6B,$23,$18
        .byte   $E8,$6C,$23,$20,$E8,$6D,$23,$28
        .byte   $E8,$6E,$23,$30,$E8,$6F,$23,$38
        .byte   $F0,$78,$23,$00,$F0,$79,$23,$08
        .byte   $F0,$7A,$23,$10,$F0,$7B,$23,$18
        .byte   $F0,$7C,$23,$20,$F0,$7D,$23,$28
        .byte   $F0,$7E,$23,$30,$F0,$7F,$23,$38
        .byte   $F8,$88,$20,$00,$F8,$89,$20,$08
        .byte   $F8,$8A,$20,$10,$F8,$8B,$20,$18
        .byte   $F8,$8C,$20,$20,$F8,$8D,$20,$28
        .byte   $F8,$8E,$20,$30,$F8,$8F,$20,$38
        .byte   $00,$98,$20,$00,$00,$99,$20,$08
        .byte   $00,$9A,$20,$10,$00,$9B,$20,$18
        .byte   $00,$9C,$20,$20,$00,$9D,$20,$28
        .byte   $00,$9E,$20,$30,$00,$9F,$20,$38
        .byte   $FF
sprite4BOstrich1:
        .byte   $E0,$91,$21,$08,$E0,$92,$21,$10
        .byte   $E8,$A0,$21,$00,$E8,$A1,$21,$08
        .byte   $E8,$A2,$21,$10,$F0,$B0,$21,$00
        .byte   $F0,$B1,$21,$08,$F0,$B2,$21,$10
        .byte   $F8,$C0,$21,$00,$F8,$C1,$21,$08
        .byte   $F8,$C2,$21,$10,$00,$D0,$21,$00
        .byte   $00,$D2,$21,$10,$FF
sprite4COstrich2:
        .byte   $E0,$C4,$21,$08,$E0,$C5,$21,$10
        .byte   $E8,$D3,$21,$00,$E8,$D4,$21,$08
        .byte   $E8,$D5,$21,$10,$F0,$E3,$21,$00
        .byte   $F0,$E4,$21,$08,$F0,$E5,$21,$10
        .byte   $F8,$F3,$21,$00,$F8,$F4,$21,$08
        .byte   $F8,$F5,$21,$10,$00,$B3,$21,$00
        .byte   $00,$B4,$21,$08,$FF
; Saint Basil's is shown from the NNW. https://en.wikipedia.org/wiki/File:Sant_Vasily_cathedral_in_Moscow.JPG Use https://www.moscow-driver.com/photos/moscow_sightseeing/st_basil_cathedral/model_and_plan_of_cathedral_chapels to determine names of chapels
sprite4DCathedralEasternDome:
        .byte   $F0,$39,$22,$04,$F8,$AA,$22,$00
        .byte   $F8,$AB,$22,$08,$00,$BA,$22,$00
        .byte   $00,$BB,$22,$08,$FF
sprite4ECathedralNorthernDome:
        .byte   $F0,$3A,$23,$04,$F8,$AC,$23,$00
        .byte   $F8,$AD,$23,$08,$00,$BC,$23,$00
        .byte   $00,$BD,$23,$08,$FF
sprite4FCathedralCentralDome:
        .byte   $F0,$38,$23,$08,$F8,$49,$23,$00
        .byte   $F8,$4A,$23,$08,$00,$3B,$23,$00
        .byte   $00,$3C,$23,$08,$FF
sprite50CathedralWesternDome:
        .byte   $F8,$4E,$20,$00,$F8,$4F,$20,$08
        .byte   $00,$5E,$20,$00,$00,$5F,$20,$08
        .byte   $FF
sprite51CathedralDomeRocketJet1:
        .byte   $08,$5B,$23,$04,$FF
sprite52CathedralDomeRocketJet2:
        .byte   $08,$48,$23,$04,$10,$58,$23,$04
        .byte   $FF
sprite53MusicTypeCursor:
        .byte   $00,$27,$00,$00,$00,$27,$40,$4A
        .byte   $FF
sprite54Penguin1:
        .byte   $E8,$A9,$21,$00,$E8,$AA,$21,$08
        .byte   $F0,$B8,$21,$F8,$F0,$B9,$21,$00
        .byte   $F0,$BA,$21,$08,$F8,$C9,$21,$00
        .byte   $F8,$CA,$21,$08,$F8,$CB,$21,$10
        .byte   $00,$D9,$21,$00,$00,$DA,$21,$08
        .byte   $FF
sprite55Penguin2:
        .byte   $E8,$AD,$21,$00,$E8,$AE,$21,$08
        .byte   $F0,$BC,$21,$F8,$F0,$BD,$21,$00
        .byte   $F0,$BE,$21,$08,$F8,$CD,$21,$00
        .byte   $F8,$CE,$21,$08,$F8,$CF,$21,$10
        .byte   $00,$DD,$21,$00,$00,$DE,$21,$08
        .byte   $FF
