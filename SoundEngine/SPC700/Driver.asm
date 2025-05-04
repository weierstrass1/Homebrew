arch spc700-raw

incsrc "Macros/MacrosInclude.asm"
incsrc "DSPRegs.asm"
incsrc "Variables.asm"

SetupTable:
.Address
    db !DSPRegMainVolumeLeft
    db !DSPRegMainVolumeRight
    db !DSPRegEchoVolumeLeft
    db !DSPRegEchoVolumeRight
    db !DSPRegFlags
    db !DSPRegEchoFeedback
    db !DSPRegPitchModulation
    db !DSPRegNoiseEnable
    db !DSPRegEchoEnable
    db !DSPRegSampleDirectoryOffset
    db !DSPRegEchoBufferAddressOffset
    db !DSPRegEchoDelay
..End
.Value
    db $7F
    db $7F
    db $00
    db $00
    db $20
    db $60
    db $00
    db $00
    db $00
    db $2F
    db $60
    db $00
Main:
.InitialSetup
	MOV x, #SetupTable_Address_End-SetupTable_Address
-	
    %WriteDSP("SetupTable_Address+x", "SetupTable_Value+x")
    DEC x
    BPL -

	MOV !RegTimer0, #$10   ; Set Timer 0's frequency to 2 ms

.Loop
	;check if we need to upload data, this goes first. it's just a bit-check (7F has bit 6 active) since doing cmp $f5, #$7f then BNE .noupload yadda yadda was too stupid and wasted cycles
	BBC1 !RegAPUPort1.6, .noUploadRoutine
    ;UPLOAD ROUTINE
    ;Note that after this, the program is "reset."
    ;Disable echo. We don't want any rogue sounds during upload
    ;and we ESPECIALLY don't want the echo buffer to overwrite anything.
    %WriteDSPConstantAddressValue(!DSPRegFlags, $20)
    ;Also set the echo delay to 0.
    %WriteDSPConstantAddressValue(!DSPRegEchoDelay, $00)
    %WriteDSPConstantAddressValue(!DSPRegKeyOff, $FF)
	JMP $FFC0
.noUploadRoutine

	;wait for counter 0 increment
	MOV y, !RegCounter0
	BEQ .Loop

	MOV A, EngineVariables.MusicEnable
	BEQ .NoMusic
	;Song tempo calculations
	MOV A, EngineVariables.MusicTempo
	MUL ya
    CLRC
	ADC A, EngineVariables.MusicTickCounter
	MOV EngineVariables.MusicTickCounter, A
    BCC .NoMusic

    CALL MusicLoop
.NoMusic

	MOV A, EngineVariables.SoundEffectEnable
	BEQ .Loop

    CALL SoundEffectLoop

    BRA .Loop

Bitchecker:
    db  $01,$02,$04,$08,$10,$20,$40,$80

!TotalDuration = SPC700Scratch
!CurrentDuration = SPC700Scratch+2
!EndCommandReadFlag = SPC700Scratch+4
!CurrentPointer = SPC700Scratch+5
!CurrentChannel = SPC700Scratch+7
!CurrentBitChecker = SPC700Scratch+8
!MulTunning = SPC700Scratch+9

MusicLoop:

    MOV x, #$07
    MOV !CurrentChannel, x
.Loop
    MOV x, !CurrentChannel
    MOV A, EngineVariables.MusicEnable
    AND A, Bitchecker+x
    BEQ MusicLoop_NextChannel

    MOV A, SPC700MusicChannels_TotalDurationHighByte+x
    MOV !TotalDuration+1, A 
    MOV A, SPC700MusicChannels_TotalDurationLowByte+x
    MOV !TotalDuration, A

    INC SPC700MusicChannels_CurrentDurationLowByte+x
    BNE +
    INC SPC700MusicChannels_CurrentDurationHighByte+x
+

    MOV A, SPC700MusicChannels_CurrentDurationLowByte+x
    MOV !CurrentDuration, A
    MOV A, SPC700MusicChannels_CurrentDurationLowByte+x
    MOV !CurrentDuration+1, A

    CALL MusicFadeCommands

    MOV A, !CurrentDuration
    MOV y, !CurrentDuration+1
    CMPW ya, !TotalDuration
    BNE MusicLoop_NextChannel

    MOV A, #$00
    MOV SPC700MusicChannels_CurrentDurationLowByte+x, A
    MOV SPC700MusicChannels_CurrentDurationHighByte+x, A

    MOV A, SPC700MusicChannels_CurrentPointerLowByte+x
    MOV !CurrentPointer, A
    MOV A, SPC700MusicChannels_CurrentPointerHighByte+x
    MOV !CurrentPointer+1, A

    MOV !EndCommandReadFlag, #$00

..CommandLoop
    MOV A, (!CurrentPointer)
    CMP A, #$FF
    BNE +

    MOV x, !CurrentChannel
    MOV A, SPC700MusicChannels_ResetPointerLowByte+x
    MOV !CurrentPointer, A
    MOV A, SPC700MusicChannels_ResetPointerHighByte+x
    MOV !CurrentPointer+1, A
    BRA ..CommandLoop
+
    MOV y, !CurrentChannel

    CMP A, #$80
    BCS +
    ASL A
    MOV x, A
    JMP (CommandTable+x)
+    
    SETC
    SBC A, #$80
    ASL A
    MOV x, A
    JMP (CommandTable+$0100+x)
..NextCommand
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+
    MOV A,!EndCommandReadFlag
    BEQ .CommandLoop

    MOV A, !CurrentPointer
    MOV SPC700MusicChannels_CurrentPointerLowByte+x, A
    MOV A, !CurrentPointer+1
    MOV SPC700MusicChannels_CurrentPointerHighByte+x, A

.NextChannel
    DEC !CurrentChannel
    BPL .Loop
.Leave

    %WriteDSPConstantAddress(!DSPRegKeyOn, SPC700Mirrors.KeyOn)
RET

MusicFadeCommands:
RET

SoundEffectLoop:
RET

CommandTable:
    dw Octave1
    dw Octave4
    dw Octave6

    dw OMinusNoteB
    dw OMinusNoteASharp
    dw OMinusNoteA
    dw OMinusNoteGSharp
    dw OMinusNoteG
    dw OMinusNoteFSharp
    dw OMinusNoteF
    dw OMinusNoteE
    dw OMinusNoteDSharp
    dw OMinusNoteD
    dw OMinusNoteCSharp
    dw OMinusNoteC

    dw NoteB
    dw NoteASharp
    dw NoteA
    dw NoteGSharp
    dw NoteG
    dw NoteFSharp
    dw NoteF
    dw NoteE
    dw NoteDSharp
    dw NoteD
    dw NoteCSharp
    dw NoteC

    dw OPlusNoteB
    dw OPlusNoteASharp
    dw OPlusNoteA
    dw OPlusNoteGSharp
    dw OPlusNoteG
    dw OPlusNoteFSharp
    dw OPlusNoteF
    dw OPlusNoteE
    dw OPlusNoteDSharp
    dw OPlusNoteD
    dw OPlusNoteCSharp
    dw OPlusNoteC

    dw Rest

    dw Tie

Frecuencies:
.B
    dw $003F,$007E,$00FD,$01FA,$03F3,$07E7,$0FCE,$1F9C
.ASharp
    dw $003C,$0077,$00EF,$01DD,$03BB,$0775,$0EEB,$1DD6
.A
    dw $0038,$0071,$00E1,$01C3,$0385,$070A,$0E14,$1C29
.GSharp
    dw $0035,$006A,$00D5,$01A9,$0353,$06A5,$0D4A,$1A94
.G
    dw $0032,$0064,$00C9,$0191,$0323,$0646,$0C8B,$1916
.FSharp
    dw $002F,$005F,$00BD,$017B,$02F6,$05EB,$0BD7,$17AE
.F
    dw $002D,$0059,$00B3,$0166,$02CB,$0596,$0B2D,$165A
.E
    dw $002A,$0054,$00A9,$0152,$02A3,$0546,$0A8C,$1519
.DSharp
    dw $0028,$0050,$009F,$013F,$027D,$04FA,$09F5,$13EA
.D
    dw $0026,$004B,$0096,$012D,$0259,$04B3,$0966,$12CB
.CSharp
    dw $0023,$0047,$008E,$011C,$0238,$046F,$08DF,$11BD
.C
    dw $0021,$0043,$0086,$010C,$0218,$0430,$085F,$10BE

incsrc "Commands/CommandsInclude.asm"

GenericDefaultNote:
    %DefaultDuration()
    BRA ProcessNote

GenericExtendedNote:
    %ExtendedDuration()
    BRA ProcessNote

GenericNote:
    %Duration()

ProcessNote:
    MOV A, SPC700MusicChannels_Octave+y
    MOV x, A

    MOV A, Bitchecker+y
    MOV !CurrentBitChecker, A
    OR A, SPC700Mirrors.KeyOff
    MOV SPC700Mirrors.KeyOff, A

    MOV A, !CurrentBitChecker
    OR A, SPC700Mirrors.KeyOn
    MOV SPC700Mirrors.KeyOn, A

    ;P = Pitch, T = Tunning, L = Low Byte, H = High Byte
    ;PH PL * TH TL
    ;(256*PH+PL)*(256*TH + TL)
    ;256^2*PH*TH + 256*PH*TL + 256*PL*TH + PL*TL
    
    ;Example:
    ;Pitch = $0385 (A4), Tunning = $0300
    ;PH PL * TH TL = $03 $85 * $03 * $00
    ;(256*PH+PL)*(256*TH + TL) = (256*$03 + $85)*(256*$03 + $00)
    ;256^2*PH*TH + 256*PH*TL + 256*PL*TH + PL*TL = 256^2*$03*$03 + 256*$03*$00 + 256*$85*$03 + $85*$00
    ;256^2*$09 + 256*$18F
    ;$090000 + $018F00
    ;$0A8F00
    ;Pitch = Byte 3|Byte 2 = $0A8F
    MOV !MulTunning+4, #$00
    MOV !MulTunning+5, #$00

    ;PL*TL
    MOV A, SPC700MusicChannels_TunningLowByte+y
    MOV y, A
.p1
    MOV A, $0000+x
    MUL ya
    MOVW !MulTunning, ya

    ;256*PL*TH
    PUSH A
    MOV y, !CurrentChannel
    MOV A, SPC700MusicChannels_TunningHighByte+y
    MOV y, A
    POP A
    MUL ya
    MOVW !MulTunning+2, ya

    ;256*PL*TH + PL*TL
    MOV A, !MulTunning+1
    CLRC
    ADC A, !MulTunning+2
    MOV !MulTunning+2, A
    BCC +
    INC !MulTunning+3
+

    ;256*PH*TL
    MOV y, !CurrentChannel
    MOV A, SPC700MusicChannels_TunningLowByte+y
    MOV y, A
.p2
    MOV A, $0000+x
    MUL ya
    PUSH A
    CLRC
    ;256*PH*TL + 256*PL*TH + PL*TL
    ADDW ya, !MulTunning+2
    MOVW !MulTunning+2, ya
    BCC +
    INC !MulTunning+4
+
    ;256^2*PH*TH
    MOV y, !CurrentChannel
    MOV A, SPC700MusicChannels_TunningHighByte+y
    MOV y, A
    POP A
    MUL ya
    CLRC
    ;256^2*PH*TH + 256*PH*TL + 256*PL*TH + PL*TL
    ADDW ya, !MulTunning+4
    MOVW !MulTunning+4, ya

    MOV A, !CurrentChannel
    xCN A
    OR A, #!DSPRegChannelPitchLowByte
    MOV !RegDSPAddress, A

    MOV A, !MulTunning+3
    MOV !RegDSPValue, A

    INC !RegDSPAddress

    MOV A, !MulTunning+4
    MOV !RegDSPValue, A
RET