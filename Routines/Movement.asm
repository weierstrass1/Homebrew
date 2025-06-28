UpdateEntityXPosition:
    %UpdatePosition(" Entity.X", " Entity.XSpeed", ",x", "RTL")

UpdateEntityYPosition:
    %UpdatePosition(" Entity.Y", " Entity.YSpeed", ",x", "RTL")

;s0: Max Speed
;A = Accel, must be 16 bits with REP #$21
UpdateEntityXSpeedWithMaxSpeed:
    LDY #$0000
    ADC Entity.XSpeed,x
    BPL +
    INY
    EOR #$FFFF
    INC A
+
    CMP DirectPage.Scratch
    BCC +
    LDA DirectPage.Scratch
+
    CPY #$0000
    BEQ +
    EOR #$FFFF
    INC A
+
    STA Entity.XSpeed,x
RTL

;s0: Friction, Must be positive
;A must be 16 bits with REP #$21
UpdateEntityXSpeedWithFriction:
    LDA Entity.XSpeed,x
    BNE .change
RTL
.change
    BPL .positive
.negative
    ADC DirectPage.Scratch
    BMI +
    LDA #$0000
+
    STA Entity.XSpeed,x
RTL
.positive
    SEC 
    SBC DirectPage.Scratch
    BPL +
    LDA #$0000
+
    STA Entity.XSpeed,x
RTL

;s0: Fall Speed
;A = Gravity, must be 16 bits with REP #$21
UpdateEntityFallSpeed:
    LDY #$0000
    ADC Entity.YSpeed,x
    BMI +
    CMP DirectPage.Scratch
    BCC +
    LDA DirectPage.Scratch
+
    STA Entity.YSpeed,x
RTL
