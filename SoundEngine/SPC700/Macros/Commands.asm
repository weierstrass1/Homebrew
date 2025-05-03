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
    MOV A, TunningLowByte+Y
    MOV Y, A
.p1
    MOV A, $0000+X
    MUL YA
    MOV !MulTunning, YA

    ;256*PL*TH
    PUSH A
    MOV Y, !CurrentChannel
    MOV A, TunningHighByte+Y
    MOV Y, A
    POP A
    MUL YA
    MOV !MulTunning+2, YA

    ;256*PL*TH + PL*TL
    MOV A, !MulTunning+1
    CLRC
    ADC A, !MulTunning+2
    MOV !MulTunning+2, A
    BCC +
    INC !MulTunning+3
+

    ;256*PH*TL
    MOV Y, !CurrentChannel
    MOV A, TunningLowByte+Y
    MOV Y, A
.p2
    MOV A, $0000+X
    MUL YA
    PUSH A
    CLRC
    ;256*PH*TL + 256*PL*TH + PL*TL
    ADDW YA, !MulTunning+2
    MOVW !MulTunning+2, YA
    BCC +
    INC !MulTunning+4
+
    ;256^2*PH*TH
    MOV Y, !CurrentChannel
    MOV A, TunningHighByte+Y
    MOV Y, A
    POP A
    MUL YA
    CLRC
    ;256^2*PH*TH + 256*PH*TL + 256*PL*TH + PL*TL
    ADDW YA, !MulTunning+4
    MOVW !MulTunning+4, YA

    MOV A, !CurrentChannel
    XCN A
    ORA A, #!DSPRegChannelPitchLowByte
    MOV !RegDSPAddress, A

    MOV A, !MulTunning+3
    MOV !RegDSPValue, A

    INC !RegDSPAddress

    MOV A, !MulTunning+4
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
