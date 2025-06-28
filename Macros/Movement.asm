macro UpdatePosition(position, speed, index, ret)
    REP #$21
    LDA<position><index>
    ADC<speed><index>
    STA<position><index>
    SEP #$20

    LDA<speed>+1<index>
    BMI ?+
    LDA #$00
    ADC<position>+2<index>
    STA<position>+2<index>
<ret>
?+
    LDA #$FF
    ADC<position>+2<index>
    STA<position>+2<index>
<ret>
endmacro
