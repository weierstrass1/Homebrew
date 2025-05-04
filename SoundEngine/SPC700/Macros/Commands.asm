macro DefaultNote(frecTable)
    MOV.b A, #<frecTable>&$FF
    MOV.b y, #<frecTable>>>8

    MOVW ProcessNote_p1+1, ya
    MOVW ProcessNote_p2+1, ya

    JMP GenericDefaultNote
endmacro

macro Note(frecTable)
    MOV.b A, #<frecTable>&$FF
    MOV.b y, #<frecTable>>>8

    MOVW ProcessNote_p1+1, ya
    MOVW ProcessNote_p2+1, ya

    JMP GenericNote
endmacro

macro ExtendedNote(frecTable)
    MOV.b A, #<frecTable>&$FF
    MOV.b y, #<frecTable>>>8

    MOVW ProcessNote_p1+1, ya
    MOVW ProcessNote_p2+1, ya

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
    MOV SPC700MusicChannels_TotalDurationLowByte+y, A

    MOV A, <valueH>
    MOV SPC700MusicChannels_TotalDurationHighByte+y, #$00
endmacro

macro Duration()
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+
    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_TotalDurationLowByte+y, A
    MOV SPC700MusicChannels_TotalDurationHighByte+y, #$00
endmacro

macro DefaultDuration()
    MOV A, SPC700MusicChannels_DefaultDurationLowByte+y
    MOV SPC700MusicChannels_TotalDurationLowByte+y, A

    MOV A, SPC700MusicChannels_DefaultDurationHighByte+y
    MOV SPC700MusicChannels_TotalDurationHighByte+y, A
endmacro

macro ExtendedDuration()
    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+

    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_TotalDurationLowByte+y, A

    INC !CurrentPointer
    BNE +
    INC !CurrentPointer+1
+

    MOV A, (!CurrentPointer)
    MOV SPC700MusicChannels_TotalDurationHighByte+y, A
endmacro
