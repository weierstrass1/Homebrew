macro Note(table)
    MOV A, SPC700MusicChannels_Octave+Y
    ASL A
    MOV X, A


    MOV A, Y
    XCN A
    PUSH A

    ORA A, #!DSPRegChannelPitchLowByte
    MOV !RegDSPAddress, A

    MOV A, <table>+X
    MOV !RegDSPValue, A

    POP A
    ORA A, #!DSPRegChannelPitchHighByte
    MOV !RegDSPAddress, A

    MOV A, <table>+1+X
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

macro DurationExtended()
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
