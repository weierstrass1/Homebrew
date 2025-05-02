macro Note(table)
    MOV A, SPC700MusicChannels_Octave+Y
    ASL A
    MOV X, A

    MOV A, <table>+X
    MOV SPC700Musicchannels_PitchLowByte+Y, A

    MOV A, SPC700MusicChannels_Octave+1+x
    MOV SPC700Musicchannels_PitchHighByte+Y, A
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
