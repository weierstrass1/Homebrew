ControllerHandler:
    ;Controller recieving
    REP #$20
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

    ;Controller state last frame
    LDA.b DirectPage.Controller1
    STA.b DirectPage.LastController1
    LDA.b DirectPage.Controller2
    STA.b DirectPage.LastController2
    SEP #$20
RTS
