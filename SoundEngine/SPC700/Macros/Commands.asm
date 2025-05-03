macro DefaultNote(<frecTable>)
    MOV A, #<frecTable>
    MOV Y, #<frecTable>+1

    MOVW GenericDefaultNote_p1+1, YA
    MOVW GenericDefaultNote_p2+1, YA

    JMP GenericDefaultNote
endmacro

macro Note(<frecTable>)
    MOV A, #<frecTable>
    MOV Y, #<frecTable>+1

    MOVW GenericDefaultNote_p1+1, YA
    MOVW GenericDefaultNote_p2+1, YA

    JMP GenericNote
endmacro

macro ExtendedNote(<frecTable>)
    MOV A, #<frecTable>
    MOV Y, #<frecTable>+1

    MOVW GenericDefaultNote_p1+1, YA
    MOVW GenericDefaultNote_p2+1, YA

    JMP GenericExtendedNote
endmacro

macro GenericNote()
    MOV A, SPC700MusicChannels_Octave+Y
    MOV X, A

    MOV A, !CurrentBitChecker
    OR A, SPC700Mirrors.KeyOn
    MOV SPC700Mirrors.KeyOn, A

    MOV A, Y
    XCN A
    PUSH A

    ORA A, #!DSPRegChannelPitchLowByte
    MOV !RegDSPAddress, A

.p1
    MOV A, $0000+X
    MOV !RegDSPValue, A

    POP A
    ORA A, #!DSPRegChannelPitchHighByte
    MOV !RegDSPAddress, A
.p2
    MOV A, $0000+X
    MOV !RegDSPValue, A
endmacro

macro DurationGeneral(valueH, valueL)
    MOV A, <valueL>
    MOV SPC700MusicChannels_TotalDurationLowByte+Y, A

    MOV A, <valueH>
    MOV SPC700MusicChannels_TotalDurationHighByte+Y, #$00
endmacro

macro Duration()
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+
    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_TotalDurationLowByte+Y, A
    MOV SPC700MusicChannels_TotalDurationHighByte+Y, #$00
endmacro

macro DefaultDuration()
    MOV A, SPC700MusicChannels_DefaultDurationLowByte+Y
    MOV SPC700MusicChannels_TotalDurationLowByte+Y, A

    MOV A, SPC700MusicChannels_DefaultDurationHighByte+Y
    MOV SPC700MusicChannels_TotalDurationHighByte+Y, A
endmacro

macro ExtendedDuration()
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+

    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_TotalDurationLowByte+Y, A

    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+

    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_TotalDurationHighByte+Y, A
endmacro
