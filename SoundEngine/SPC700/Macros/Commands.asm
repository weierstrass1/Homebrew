macro DefaultNote(frecTable)
    MOV.b A, #<frecTable>
    MOV.b Y, #<frecTable>>>8

    MOVW GenericDefaultNote_p1+1, YA
    MOVW GenericDefaultNote_p2+1, YA

    JMP GenericDefaultNote
endmacro

macro Note(frecTable)
    MOV.b A, #<frecTable>
    MOV.b Y, #<frecTable>>>8

    MOVW GenericDefaultNote_p1+1, YA
    MOVW GenericDefaultNote_p2+1, YA

    JMP GenericNote
endmacro

macro ExtendedNote(frecTable)
    MOV.b A, #<frecTable>
    MOV.b Y, #<frecTable>>>8

    MOVW GenericDefaultNote_p1+1, YA
    MOVW GenericDefaultNote_p2+1, YA

    JMP GenericExtendedNote
endmacro


macro OPlusNote(frecTable)
    %Note(<frecTable>+2)
endmacro

macro DefaultOPlusNote(frecTable)
    %DefaultNote(<frecTable>+2)
endmacro

macro ExtendedOPlusNote(frecTable)
    %ExtendedNote(<frecTable>+2)
endmacro


macro OMinusNote(frecTable)
    %Note(<frecTable>-2)
endmacro

macro DefaultOMinusNote(frecTable)
    %DefaultNote(<frecTable>-2)
endmacro

macro ExtendedOMinusNote(frecTable)
    %ExtendedNote(<frecTable>-2)
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
