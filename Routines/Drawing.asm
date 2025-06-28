YIsValid:
    BPL .posYOffset
.negYOffset
    CMP #$FFF0
    LDA #$0000
    SEP #$20
RTL
.posYOffset
    CMP #$00E0
    SEP #$20
    BCC .continueY
    CLC
RTL
.continueY
    SEC
RTL

XIsValid:
    BPL .posXOffset
.negXOffset
    CMP #$FFF0
    LDA #$0000
    SEP #$20
    BCS .continueXHigh
RTL
.posXOffset
    CMP #$0100
    SEP #$20
    BCC .continueXLow
    CLC
RTL
.continueXHigh
    INC DirectPage.Scratch+$06
RTL
.continueXLow
    SEC
RTL

PositionIsValid:
    BPL .posYOffset
.negYOffset
    CMP #$FFF0
    BCS .continueX
    SEP #$20
    CLC
RTL
.posYOffset
    CMP #$00E0
    BCC .continueX
    SEP #$20
    CLC
RTL
.continueX
    LDA DirectPage.Scratch+$09
    BPL .posXOffset
.negXOffset
    CMP #$FFF0
    LDA #$0000
    SEP #$20
    BCS .continueXHigh
    CLC
RTL
.posXOffset
    CMP #$0100
    SEP #$20
    BCC .continueXLow
    CLC
RTL
.continueXHigh
    INC DirectPage.Scratch+$06
RTL
.continueXLow
    SEC
RTL

RemapOamTile:
    STA DirectPage.Scratch+$11
    CLC
    ADC DirectPage.Scratch+$04
    PHA
    EOR DirectPage.Scratch+$11
    AND #$10
    BEQ +
    PLA
    CLC
    ADC #$10
    BRA ++
+
    PLA
++
    CMP DirectPage.Scratch+$04
    STA DirectPage.Scratch+$11
    LDA DirectPage.Scratch+$05
    BCS +
    ORA #$01
+
RTL
