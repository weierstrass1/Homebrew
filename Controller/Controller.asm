ControllerHandler:
-
    LDA.w HardwareRegisters.PPUStatusReg4212
    LSR
    BCS -

    REP #$20
    LDA.w HardwareRegisters.ControllerPort1Data1Reg4218
    STA.b DirectPage.Controller1
    LDA.w HardwareRegisters.ControllerPort2Data1Reg421A
    STA.b DirectPage.Controller2

    LDA.b DirectPage.Controller1Disable
    TRB.b DirectPage.Controller1

    LDA.b DirectPage.Controller2Disable
    TRB.b DirectPage.Controller2

    STZ.b DirectPage.Controller1Disable
    STZ.b DirectPage.Controller2Disable

    LDA.b DirectPage.LastController1
    EOR.b DirectPage.Controller1
    PHA
    AND.b DirectPage.Controller1
    STA.b DirectPage.Controller1Down
    PLA
    AND.b DirectPage.LastController1
    STA.b DirectPage.Controller1Up

    LDA.b DirectPage.LastController2
    EOR.b DirectPage.Controller2
    PHA
    AND.b DirectPage.Controller2
    STA.b DirectPage.Controller2Down
    PLA
    AND.b DirectPage.LastController2
    STA.b DirectPage.Controller2Up

    LDA.b DirectPage.Controller1
    STA.b DirectPage.LastController1
    LDA.b DirectPage.Controller2
    STA.b DirectPage.LastController2
    SEP #$20
RTS
