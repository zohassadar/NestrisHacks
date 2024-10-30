.zeropage
tmp1:	.res $1	                    ; $0000
tmp2:	.res $1	                    ; $0001
tmp3:	.res $1	                    ; $0002
pointsTable: .res $2                ; $0003 used for big/normal scoring
tmpBulkCopyToPpuReturnAddr: .res $1 ; $0005

; for triplewide
effectiveTetriminoX: .res $1        ; $0006
orientationToSpriteTable: .res 2    ; $0007 to stage different sprites
nextBigFlag: .res 1                 ; $0009
.res $3
vramDumpNeeded: .res $1             ; $000D


currentTile: .res $1                ; $000E
bigFlag: .res 1                     ; $000F
backupX: .res 1                     ; $0010
backupY: .res 1                     ; $0011
backupPiece: .res 1                 ; $0012
orientIndex: .res 1                 ; $0013


patchToPpuAddr: .res $1             ; $0014
.res $2                             ; $0015
rng_seed: .res $2	                ; $0017
spawnID: .res $1	                ; $0019
spawnCount:	.res $1	                ; $001A

; Anydas
anydasInit: .res $1            ; $001B
anydasMenu: .res $1                 ; $001C
anydasDASValue: .res $1             ; $001D
anydasARRValue: .res $1             ; $001E
anydasARECharge: .res $1            ; $001F
levelOffset: .res $1                ; $0020

; SPS
set_seed_input: .res $3          ; $0021
bseed_input: .res $2             ; $0024
set_seed: .res $3                ; $0026
bseed: .res $2                   ; $0029
bSeedSource: .res 1              ; $002B
bseedCopy: .res 1                ; $002C
displayedNextPiece: .res 1       ; $002D
topRowValidityCheck: .res 1      ; $002E
tetrisSound: .res 1              ; $002F
.res $02
halfSpeed: .res $1                  ; $0032
verticalBlankingInterval:.res $1	; $0033
unused_0E: .res $1                  ; $0034
.res $B
tetriminoX:	.res $1	                ; $0040
tetriminoY:	.res $1	                ; $0041
currentPiece: .res 1	            ; $0042
.res 1
levelNumber: .res 1	                ; $0044
fallTimer: .res 1	                ; $0045
autorepeatX: .res 1 	            ; $0046
startLevel:	.res $1	                ; $0047
playState: .res $1	                ; $0048
vramRow: .res $1	                ; $0049
autorepeatY: .res $1	            ; $004A
holdDownPoints:	.res $1	            ; $004B
lines: .res $2	                    ; $004C
rowY: .res $1	                    ; $004E
score: .res $3	                    ; $004F
completedLines:	.res 1	            ; $0052
lineIndex: .res $1	                ; $0053
curtainRow:	.res $1	                ; $0054
startHeight: .res $1	            ; $0055
garbageHole: .res $1	            ; $0056
completedRow: .res $4	            ; $0057
.res $5
player1_tetriminoX:	.res 1	        ; $0060
player1_tetriminoY:	.res 1	        ; $0061
player1_currentPiece:	.res 1	    ; $0062
.res 1
player1_levelNumber:	.res 1	; $0064
player1_fallTimer:	.res 1	; $0065
player1_autorepeatX:	.res 1	; $0066
player1_startLevel:	.res 1	; $0067
player1_playState:	.res 1	; $0068
player1_vramRow:	.res 1	; $0069
player1_autorepeatY:	.res 1	; $006A
player1_holdDownPoints:	.res 1	; $006B
player1_lines:	.res 2	; $006C
player1_rowY:	.res 1	; $006E
player1_score:	.res 3	; $006F
player1_completedLines:	.res 1	; $0072
.res 1
player1_curtainRow:	.res 1	; $0074
player1_startHeight:	.res 1	; $0075
player1_garbageHole:	.res 1	; $0076
player1_completedRow:	.res 4	; $0077
.res 5
player2_tetriminoX:	.res 1	; $0080
player2_tetriminoY:	.res 1	; $0081
player2_currentPiece:	.res 1	; $0082
.res 1
player2_levelNumber:	.res 1	; $0084
player2_fallTimer:	.res 1	; $0085
player2_autorepeatX:	.res 1	; $0086
player2_startLevel:	.res 1	; $0087
player2_playState:	.res 1	; $0088
player2_vramRow:	.res 1	; $0089
player2_autorepeatY:	.res 1	; $008E
player2_holdDownPoints:	.res 1	; $008F
player2_lines:	.res 2	; $0090
player2_rowY:	.res 1	; $0092
player2_score:	.res 3	; $0093
player2_completedLines:	.res 1	; $0096
.res 1
player2_curtainRow:	.res 1	; $0098
player2_startHeight:	.res 1	; $0099
player2_garbageHole:	.res 1	; $009A
player2_completedRow:	.res 4	; $008A
.res 5
spriteXOffset:	.res 1	; $00A0
spriteYOffset:	.res 1	; $00A1
spriteIndexInOamContentLookup:	.res 1	; $00A2
outOfDateRenderFlags: .res 1 ; $00A3
twoPlayerPieceDelayCounter: .res 1 ; $00A4
twoPlayerPieceDelayPlayer: .res 1 ; $00A5
twoPlayerPieceDelayPiece:	.res 1	; $00A6
gameModeState:	.res 1	; $00A7
generalCounter:	.res 1	; $00A8
generalCounter2:	.res 1	; $00A9
generalCounter3:	.res 1	; $00AA
generalCounter4:	.res 1	; $00AB
generalCounter5:	.res 1	; $00AC
selectingLevelOrHeight:	.res 1	; $00AD
originalY:	.res 1	; $00AE
dropSpeed:	.res 1	; $00AF
tmpCurrentPiece: .res 1 ; $00B0
frameCounter:	.res 2	; $00B1
oamStagingLength:	.res 1	; $00B3
.res 1
newlyPressedButtons:	.res 1	; $00B5
heldButtons:	.res 1	; $00B6
activePlayer:	.res 1	; $00B7
playfieldAddr:	.res 2	; $00B8
allegro: .res 1 ; $00BA
pendingGarbage:	.res 1	; $00BB
pendingGarbageInactivePlayer:	.res 1	; $00BC
renderMode:	.res 1	; $00BD
numberOfPlayers:	.res 1	; $00BE
nextPiece:	.res 1	; $00BF
gameMode:	.res 1	; $00C0
gameType:	.res 1	; $00C1
musicType:	.res 1	; $00C2
sleepCounter:	.res 1	; $00C3
ending:	.res 1	; $00C4
ending_customVars:	.res 1	; $00C5
.res 5
displayNextPiece:	.res 1	; $00CB
ending_currentSprite: .res 1 ;$00CC
ending_typeBCathedralFrameDelayCounter: .res 1 ; $00CD
demo_heldButtons:	.res 1	; $00CE
demo_repeats:	.res 1	; $00CF
.res 1
demoButtonsAddr:	.res 1	; $00D1
demoButtonsTable_indexOverflowed:	.res 1	; $00D2
demoIndex:	.res 1	; $00D3
highScoreEntryNameOffsetForLetter:	.res 1	; $00D4
highScoreEntryRawPos:	.res 1	; $00D5
highScoreEntryNameOffsetForRow:	.res 1	; $00D6
highScoreEntryCurrentLetter:	.res 1	; $00D7
lineClearStatsByType:	.res 8	; $00D8

AUDIOTMP1:	.res 1	; $00E0
AUDIOTMP2:	.res 1	; $00E1
AUDIOTMP3:	.res 1	; $00E2
AUDIOTMP4:	.res 1	; $00E3
AUDIOTMP5:	.res 1	; $00E4
.res 1
musicChanTmpAddr:	.res 2	; $00E6
.res 2
music_unused2: .res 1  ; $00EA
soundRngSeed: .res 2  ; $00EB
currentSoundEffectSlot:	.res 1	; $00ED
musicChannelOffset:	.res 1	; $00EE
currentAudioSlot:	.res 1	; $00EF
.res 1
unreferenced_buttonMirror:  .res 3  ; $00F1
.res 1
newlyPressedButtons_player1:	.res 1	; $00F5
newlyPressedButtons_player2:	.res 1	; $00F6
heldButtons_player1:	.res 1	; $00F7
heldButtons_player2: .res 1 ; $00F8
.res 2
joy1Location:	.res 1	; $00FB
ppuScrollY: .res 1 ; $00FC
ppuScrollX: .res 1 ; $00FD
currentPpuMask:	.res 1	; $00FE
currentPpuCtrl:	.res 1	; $00FF

.bss
stack:
.ifdef TRIPLEWIDE
row1Address:
row1Data := row1Address + 2
row2Address := row1Data + 30
row2Data := row2Address + 2
row3Address := row2Data + 30
row3Data := row3Address + 2
row4Address := row3Data + 30
row4Data := row4Address + 2
row5Address := row4Data + 30
row5Data := row5Address + 2
.endif
.res $100	; $0100
oamStaging:	.res $100	; $0200
leftPlayfield:
.res $F0

.ifdef TRIPLEWIDE
.res $0E
.else
statsByType:	.res $0E	; $03F0
.endif

.res 2
centerPlayfield:
playfield:	.res $C8	; $0400
.res $38
rightPlayfield:
playfieldForSecondPlayer:	.res $C8	; $0500
.res $38

; Area for romhacks

; SPS Variables
sps_menu: .res $1                ; $0600
menuSeedCursorIndex: .res 1      ; $0601
menuMoveThrottle: .res 1         ; $0602
menuThrottleTmp: .res 1          ; $0603
seedVersion: .res 1              ; $0604

.res $7B

; End romhacks

musicStagingSq1Lo:	.res 1	; $0680
musicStagingSq1Hi:	.res 1	; $0681
audioInitialized:	.res 1	; $0682
musicPauseSoundEffectLengthCounter: .res 1 ; $0683
musicStagingSq2Lo:	.res 1	; $0684
musicStagingSq2Hi:	.res 1	; $0685
.res 2
musicStagingTriLo:	.res 1	; $0688
musicStagingTriHi:	.res 1	; $0689
resetSq12ForMusic:	.res 1	; $068A
musicPauseSoundEffectCounter: .res 1 ; $068B
musicStagingNoiseLo:	.res 1	; $068C
musicStagingNoiseHi:	.res 1	; $068D
.res 2
musicDataNoteTableOffset:	.res 1	; $0690
musicDataDurationTableOffset:	.res 1	; $0691
musicDataChanPtr:	.res $08	; $0692
musicChanControl:	.res $03	; $069A
musicChanVolume:	.res $03	; $069D
musicDataChanPtrDeref:	.res $08	; $06A0
musicDataChanPtrOff:	.res $04	; $06A8
musicDataChanInstructionOffset:	.res $04	; $06AC
musicDataChanInstructionOffsetBackup:	.res $04	; $06B0
musicChanNoteDurationRemaining:	.res $04	; $06B4
musicChanNoteDuration:	.res $04	; $06B8
musicChanProgLoopCounter:	.res $04	; $06BC
musicStagingSq1Sweep:	.res $02	; $06C0
.res 1
musicChanNote:  .res 4  ; $06C3
.res 1
musicChanInhibit:	.res $03	; $06C8
.res 1
musicTrack_dec:	.res 1	; $06CC
musicChanVolFrameCounter:	.res $04	; $06CD
musicChanLoFrameCounter:	.res $04	; $06D1
soundEffectSlot0FrameCount:	.res 5	; $06D5
soundEffectSlot0FrameCounter:	.res 5	; $06DA
soundEffectSlot0SecondaryCounter:	.res 1	; $06DF
soundEffectSlot1SecondaryCounter:	.res 1	; $06E0
soundEffectSlot2SecondaryCounter:	.res 1	; $06E1
soundEffectSlot3SecondaryCounter:	.res 1	; $06E2
soundEffectSlot0TertiaryCounter:	.res 1	; $06E3
soundEffectSlot1TertiaryCounter:	.res 1	; $06E4
soundEffectSlot2TertiaryCounter:	.res 1	; $06E5
soundEffectSlot3TertiaryCounter:	.res 1	; $06E6
soundEffectSlot0Tmp:	.res 1	; $06E7
soundEffectSlot1Tmp:	.res 1	; $06E8
soundEffectSlot2Tmp:	.res 1	; $06E9
soundEffectSlot3Tmp:	.res 1	; $06EA
.res 5
soundEffectSlot0Init:	.res 1	; $06F0
soundEffectSlot1Init:	.res 1	; $06F1
soundEffectSlot2Init:	.res 1	; $06F2
soundEffectSlot3Init:	.res 1	; $06F3
soundEffectSlot4Init:	.res 1	; $06F4
musicTrack:	.res 1	; $06F5
.res 2
soundEffectSlot0Playing:	.res 1	; $06F8
soundEffectSlot1Playing:	.res 1	; $06F9
soundEffectSlot2Playing:	.res 1	; $06FA
soundEffectSlot3Playing:	.res 1	; $06FB
soundEffectSlot4Playing:	.res 1	; $06FC
currentlyPlayingMusicTrack:	.res 1	; $06FD
.res 1
unreferenced_soundRngTmp:  .res 1  ; $06FF
highScoreNames:	.res $30	; $0700
highScoreScoresA:	.res $C	; $0730
highScoreScoresB:	.res $C	; $073C
highScoreLevels:	.res $08	; $0748
initMagic:	.res $05	; $0750
.res $9B
.ifdef TRIPLEWIDE
statsByType: .res $10
.else
.res $10
.endif
