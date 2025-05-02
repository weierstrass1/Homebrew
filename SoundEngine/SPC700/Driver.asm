arch spc700-raw

incsrc "MacrosInclude.asm"
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
	MOV X, #SetupTable_Address_End-SetupTable_Address
-	
    %WriteDSP("SetupTable_Address+X", "SetupTable_Value+X")
    DEC X
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
	MOV Y, !RegCounter0
	BEQ .Loop

	MOV A, EngineVariables.MusicEnable
	BEQ .NoMusic
	;Song tempo calculations
	MOV A, EngineVariables.MusicTempo
	MUL YA
    CLRC
	ADC A, EngineVariables.TickCounter
	MOV EngineVariables.TickCounter, A
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

MusicLoop:

    MOV X, #$07
    MOV !CurrentChannel, X
.Loop
    MOV X, !CurrentChannel
    MOV A, MusicEnable
    AND A, Bitchecker+X
    BEQ MusicLoop_NextChannel

    MOV A, SPC700MusicChannels_TotalDurationLowByte+X
    MOV Y, SPC700MusicChannels_TotalDurationHighByte+X
    MOVW !TotalDuration, YA

    INC SPC700MusicChannels_CurrentDurationLowByte+X
    BNE +
    INC SPC700MusicChannels_CurrentDurationHighByte+X
+

    MOV A, SPC700MusicChannels_CurrentDurationLowByte+X
    MOV !CurrentDuration, A
    MOV A, SPC700MusicChannels_CurrentDurationLowByte+X
    MOV !CurrentDuration+1, A

    CALL MusicFadeCommands

    MOV A, !CurrentDuration
    MOV Y, !CurrentDuration+1
    CMPW YA, !TotalDuration
    BNE MusicLoop_NextChannel

    MOV SPC700MusicChannels_CurrentDurationLowByte+X, #$00
    MOV SPC700MusicChannels_CurrentDurationHighByte+X, #$00

    MOV A, SPC700MusicChannels_CurrentPointerLowByte+X
    MOV Y, SPC700MusicChannels_CurrentPointerHighByte+X
    MOVW !CurrentPointer, YA

    MOV !EndCommandReadFlag, #$00

..CommandLoop
    MOV A, (!CurrentPointer)
    CMP A, #$FF
    BNE +

    MOV X, !CurrentChannel
    MOV A, SPC700MusicChannels_ResetPointerLowByte+X
    MOV Y, SPC700MusicChannels_ResetPointerHighByte+X
    MOVW !CurrentPointer, YA
    BRA ..CommandLoop
+
    MOV Y, !CurrentChannel

    CMP A, #$80
    BCS +
    ASL A
    MOV X, A
    JMP (CommandTable+X)
+    
    SETC
    SBC A, #$80
    ASL A
    MOV X, A
    JMP (CommandTable+$0100+X)
.NextCommand
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+
    MOV A,!EndCommandReadFlag
    BEQ ..CommandLoop

    MOV A, !CurrentPointer
    MOV SPC700MusicChannels_CurrentPointerLowByte+X, YA
    MOV A, !CurrentPointer+1
    MOV SPC700MusicChannels_CurrentPointerHighByte+X, YA

.NextChannel
    DEC !CurrentChannel
    BPL .Loop
.Leave
RET

MusicFadeCommands:
RET

SoundEffectLoop:
RET

CommandTable:
    dw Octave
    dw IncreaseOctave
    dw DecreaseOctave
    
    dw NoteB_Default
    dw NoteASharp_Default
    dw NoteA_Default
    dw NoteGSharp_Default
    dw NoteG_Default
    dw NoteFSharp_Default
    dw NoteF_Default
    dw NoteE_Default
    dw NoteDSharp_Default
    dw NoteD_Default
    dw NoteCSharp_Default
    dw NoteC_Default
    dw Rest_Default

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
    dw Rest

    dw NoteB_Extended
    dw NoteASharp_Extended
    dw NoteA_Extended
    dw NoteGSharp_Extended
    dw NoteG_Extended
    dw NoteFSharp_Extended
    dw NoteF_Extended
    dw NoteE_Extended
    dw NoteDSharp_Extended
    dw NoteD_Extended
    dw NoteCSharp_Extended
    dw NoteC_Extended
    dw Rest_Extended

Frecuencies:
.B
    dw $0004,$0008,$0010,$0020,$003F,$007E,$00FD,$01FA,$03F3
.ASharp
    dw $0004,$0007,$000F,$001E,$003C,$0077,$00EF,$01DD,$03BB
.A
    dw $0004,$0007,$000E,$001C,$0038,$0071,$00E1,$01C3,$0385
.GSharp
    dw $0003,$0007,$000D,$001B,$0035,$006A,$00D5,$01A9,$0353
.G
    dw $0003,$0006,$000D,$0019,$0032,$0064,$00C9,$0191,$0323
.FSharp
    dw $0003,$0006,$000C,$0018,$002F,$005F,$00BD,$017B,$02F6
.F
    dw $0003,$0006,$000B,$0016,$002D,$0059,$00B3,$0166,$02CB
.E
    dw $0003,$0005,$000B,$0015,$002A,$0054,$00A9,$0152,$02A3
.DSharp
    dw $0002,$0005,$000A,$0014,$0028,$0050,$009F,$013F,$027D
.D
    dw $0002,$0005,$0009,$0013,$0026,$004B,$0096,$012D,$0259
.CSharp
    dw $0002,$0004,$0009,$0012,$0023,$0047,$008E,$011C,$0238
.C
    dw $0002,$0004,$0008,$0011,$0021,$0043,$0086,$010C,$0218

Octave:
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+

    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_Octave+Y, A
JMP MusicLoop_NextCommand

IncreaseOctave:
    INC SPC700MusicChannels_Octave+Y
    MOV A, SPC700MusicChannels_Octave+Y
    MOV A, #$09
    BCC +
    MOV SPC700MusicChannels_Octave+Y, #$08
+
JMP MusicLoop_NextCommand

DecreaseOctave:
    DEC SPC700MusicChannels_Octave+Y
    BPL +
    MOV SPC700MusicChannels_Octave+Y, #$00
+
JMP MusicLoop_NextCommand

NoteB_Default:
    %Note(Frecuencies_B)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteASharp_Default:
    %Note(Frecuencies_ASharp)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteA_Default:
    %Note(Frecuencies_A)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteGSharp_Default:
    %Note(Frecuencies_GSharp)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteG_Default:
    %Note(Frecuencies_G)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteFSharp_Default:
    %Note(Frecuencies_FSharp)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteF_Default:
    %Note(Frecuencies_F)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteE_Default:
    %Note(Frecuencies_E)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteDSharp_Default:
    %Note(Frecuencies_DSharp)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteD_Default:
    %Note(Frecuencies_D)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteCSharp_Default:
    %Note(Frecuencies_CSharp)
    %DefaultDuration()
JMP MusicLoop_NextCommand

NoteC_Default:
    %Note(Frecuencies_C)
    %DefaultDuration()
JMP MusicLoop_NextCommand

Rest_Default:
    %DefaultDuration()
JMP MusicLoop_NextCommand


NoteB:
    %Note(Frecuencies_B)
    %Duration()
JMP MusicLoop_NextCommand

NoteASharp:
    %Note(Frecuencies_ASharp)
    %Duration()
JMP MusicLoop_NextCommand

NoteA:
    %Note(Frecuencies_A)
    %Duration()
JMP MusicLoop_NextCommand

NoteGSharp:
    %Note(Frecuencies_GSharp)
    %Duration()
JMP MusicLoop_NextCommand

NoteG:
    %Note(Frecuencies_G)
    %Duration()
JMP MusicLoop_NextCommand

NoteFSharp:
    %Note(Frecuencies_FSharp)
    %Duration()
JMP MusicLoop_NextCommand

NoteF:
    %Note(Frecuencies_F)
    %Duration()
JMP MusicLoop_NextCommand

NoteE:
    %Note(Frecuencies_E)
    %Duration()
JMP MusicLoop_NextCommand

NoteDSharp:
    %Note(Frecuencies_DSharp)
    %Duration()
JMP MusicLoop_NextCommand

NoteD:
    %Note(Frecuencies_D)
    %Duration()
JMP MusicLoop_NextCommand

NoteCSharp:
    %Note(Frecuencies_CSharp)
    %Duration()
JMP MusicLoop_NextCommand

NoteC:
    %Note(Frecuencies_C)
    %Duration()
JMP MusicLoop_NextCommand

Rest:
    %Duration()
JMP MusicLoop_NextCommand


NoteB_Extended:
    %Note(Frecuencies_B)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteASharp_Extended:
    %Note(Frecuencies_ASharp)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteA_Extended:
    %Note(Frecuencies_A)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteGSharp_Extended:
    %Note(Frecuencies_GSharp)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteG_Extended:
    %Note(Frecuencies_G)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteFSharp_Extended:
    %Note(Frecuencies_FSharp)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteF_Extended:
    %Note(Frecuencies_F)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteE_Extended:
    %Note(Frecuencies_E)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteDSharp_Extended:
    %Note(Frecuencies_DSharp)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteD_Extended:
    %Note(Frecuencies_D)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteCSharp_Extended:
    %Note(Frecuencies_CSharp)
    %DurationExtended()
JMP MusicLoop_NextCommand

NoteC_Extended:
    %Note(Frecuencies_C)
    %DurationExtended()
JMP MusicLoop_NextCommand

Rest_Extended:
    %DurationExtended()
JMP MusicLoop_NextCommand
