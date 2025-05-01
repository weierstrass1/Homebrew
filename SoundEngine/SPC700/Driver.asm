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

MusicLoop:

    MOV X, #$07
.Loop
    MOV A, MusicEnable
    AND A, Bitchecker+X
    BEQ .NextChannel

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
    BNE .NextChannel

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

    MOV A, SPC700MusicChannels_ResetPointerLowByte+X
    MOV Y, SPC700MusicChannels_ResetPointerHighByte+X
    MOVW !CurrentPointer, YA
    BRA ..CommandLoop
+
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
.NextChannel
    DEC X
    BPL .Loop
.Leave
RET

MusicFadeCommands:
RET

SoundEffectLoop:
RET

CommandTable:
    dw .Nothing

.Nothing
JMP .NextCommand
