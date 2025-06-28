Init:
    LDA #$00
    STA Entity.PoseIndex,x
    STA Entity.PoseIndex+1,x
    STA Entity.X+$02,x
    STA Entity.X,x

    STA Entity.Y+$02,x
    STA Entity.Y,x

    STA Entity.XSpeed+$01,x
    STA Entity.XSpeed,x

    STA Entity.YSpeed+$01,x
    STA Entity.YSpeed,x

    STA Entity.GlobalFlip,x

    LDA #$80
    STA Entity.X+$01,x

    LDA #$70
    STA Entity.Y+$01,x

RTL

Main:
    JSR GraphicRoutine
    JSR Movement
    JSR Animation
RTL

Movement:
    JSL Routines_UpdateEntityXPosition
    JSL Routines_UpdateEntityYPosition

    REP #$20
    LDA #$0400
    STA DirectPage.Scratch

    LDA DirectPage.Controller1
    AND #$8000
    BEQ +
    LDA #$0030
    BRA ++
+
    LDA #$0060
++
    JSL Routines_UpdateEntityFallSpeed

    LDY #$0000
    LDA Entity.Y+$01,x
    CMP #$00B0
    BCC .OverTheFloor

    LDA #$00B0
    STA Entity.Y+$01,x

    LDA #$0000
    STA Entity.YSpeed,x
    INY
.OverTheFloor
    SEP #$20

    CPY #$0000
    BEQ +
    LDA DirectPage.Controller1Down+1
    AND #$80
    BEQ +
    LDA #$FA
    STA Entity.YSpeed+1,x
+

    LDA DirectPage.Controller1+1
    AND #$03
    BEQ .friction
    CMP #$03
    BNE .accel
.friction
    REP #$21
    LDA #$0040
    STA DirectPage.Scratch
    JSL Routines_UpdateEntityXSpeedWithFriction
    SEP #$20
RTS
.accel
    REP #$21
    AND #$0001
    ASL
    TAY

    LDA #$0200
    STA DirectPage.Scratch

    LDA .XAccel,y
    JSL Routines_UpdateEntityXSpeedWithMaxSpeed
    SEP #$20
RTS
.XAccel
    dw $FFC0,$0040

GraphicRoutine:
    LDA Entity.GlobalFlip,x
    ROR
    ROR
    ROR
    AND #$C0
    ORA #$2E
    STA.b DirectPage.Scratch+$05

    REP #$21
    LDA Entity.X+$01,x
    SEC
    SBC.b DirectPage.HScrollLayer1Mirror
    STA.b DirectPage.Scratch

    LDA Entity.Y+$01,x
    SEC
    SBC.b DirectPage.VScrollLayer1Mirror
    STA.b DirectPage.Scratch+$02

    LDA Entity.PoseIndex,x
    LDX #$0000
    CLC
    ADC #!PoseID_OniririTest_OniririTest0
    JSL Draw

    LDX.w Entities_CurrentSpriteSlot
RTS

Animation:
    LDA Entity.XSpeed+1,x
    BEQ +
    PHP
    PLA
    ROL
    ROL
    AND #$01
    STA Entity.GlobalFlip,x
+
    LDA Entity.XSpeed,x
    BNE .Walk
    LDA Entity.XSpeed+1,x
    BNE .Walk
.Idle
    LDA #$00
    STA Entity.PoseIndex,x
RTS
.Walk
    LDA Entity.PoseIndex,x
    BNE +
    LDA #$01
    STA Entity.PoseIndex,x

    LDA #$08
    STA Entity.AnimationTimer,x
RTS
+
    LDA #$06
    JSL Routines_GetAnimationSpeed
    CMP Entity.AnimationTimer,x
    BCS +
    STA Entity.AnimationTimer,x
+
    LDA Entity.AnimationTimer,x
    BEQ +
    DEC A
    STA Entity.AnimationTimer,x
RTS
+
    LDA #$06
    JSL Routines_GetAnimationSpeed
    STA Entity.AnimationTimer,x

    LDA Entity.PoseIndex,x
    INC A
    CMP #$07
    BCC +
    LDA #$01
+
    STA Entity.PoseIndex,x
RTS
