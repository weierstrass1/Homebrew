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
!CurrentBitChecker = SPC700Scratch+8
!MulTunning = SPC700Scratch+9

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

    MOV !CurrentBitChecker, Bitchecker+Y
    OR A, SPC700Mirrors.KeyOff
    MOV SPC700Mirrors.KeyOff, A

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

    %WriteDSPConstantAddress(!DSPRegKeyOn, SPC700Mirrors.KeyOn)
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

GenericDefaultNote:
    %GenericNote()
    %DefaultDuration()
RET

GenericNote:
    %GenericNote()
    %Duration()
RET

GenericExtendedNote:
    %GenericNote()
    %DurationExtended()
RET

Octave:
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+

    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_Octave+Y, A
RET

IncreaseOctave:
    INC SPC700MusicChannels_Octave+Y
    INC SPC700MusicChannels_Octave+Y
    MOV A, SPC700MusicChannels_Octave+Y
    MOV A, #$09
    BCC +
    MOV SPC700MusicChannels_Octave+Y, #$0E
+
RET

DecreaseOctave:
    DEC SPC700MusicChannels_Octave+Y
    DEC SPC700MusicChannels_Octave+Y
    BPL +
    MOV SPC700MusicChannels_Octave+Y, #$00
+
RET

NoteB_Default:
    %DefaultNote(Frecuencies_B)
    
NoteASharp_Default:
    %DefaultNote(Frecuencies_ASharp)
    
NoteA_Default:
    %DefaultNote(Frecuencies_A)
    
NoteGSharp_Default:
    %DefaultNote(Frecuencies_GSharp)
    
NoteG_Default:
    %DefaultNote(Frecuencies_G)
    
NoteFSharp_Default:
    %DefaultNote(Frecuencies_FSharp)
    
NoteF_Default:
    %DefaultNote(Frecuencies_F)
    
NoteE_Default:
    %DefaultNote(Frecuencies_F)
    
NoteDSharp_Default:
    %DefaultNote(Frecuencies_DSharp)
    
NoteD_Default:
    %DefaultNote(Frecuencies_D)
    
NoteCSharp_Default:
    %DefaultNote(Frecuencies_CSharp)
    
NoteC_Default:
    %DefaultNote(Frecuencies_C)
    
Rest_Default:
    %DefaultDuration()
RET


NoteB:
    %Note(Frecuencies_B)
    
NoteASharp:
    %Note(Frecuencies_ASharp)
    
NoteA:
    %Note(Frecuencies_A)
    
NoteGSharp:
    %Note(Frecuencies_GSharp)
    
NoteG:
    %Note(Frecuencies_G)
    
NoteFSharp:
    %Note(Frecuencies_FSharp)
    
NoteF:
    %Note(Frecuencies_F)
    
NoteE:
    %Note(Frecuencies_F)
    
NoteDSharp:
    %Note(Frecuencies_DSharp)
    
NoteD:
    %Note(Frecuencies_D)
    
NoteCSharp:
    %Note(Frecuencies_CSharp)
    
NoteC:
    %Note(Frecuencies_C)
    
Rest:
    %Duration()
RET


NoteB_Extended:
    %ExtendedNote(Frecuencies_B)
    
NoteASharp_Extended:
    %ExtendedNote(Frecuencies_ASharp)
    
NoteA_Extended:
    %ExtendedNote(Frecuencies_A)
    
NoteGSharp_Extended:
    %ExtendedNote(Frecuencies_GSharp)
    
NoteG_Extended:
    %ExtendedNote(Frecuencies_G)
    
NoteFSharp_Extended:
    %ExtendedNote(Frecuencies_FSharp)
    
NoteF_Extended:
    %ExtendedNote(Frecuencies_F)
    
NoteE_Extended:
    %ExtendedNote(Frecuencies_F)
    
NoteDSharp_Extended:
    %ExtendedNote(Frecuencies_DSharp)
    
NoteD_Extended:
    %ExtendedNote(Frecuencies_D)
    
NoteCSharp_Extended:
    %ExtendedNote(Frecuencies_CSharp)
    
NoteC_Extended:
    %ExtendedNote(Frecuencies_C)
    
Rest_Extended:
    %ExtendedDuration()
RET
