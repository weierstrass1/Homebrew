ProcessFixedColor:
    ;Blue
    LDA.b DirectPage.FixedColorCPUMirror+1
    LSR
    SEC
    ROR
    STA.b DirectPage.FixedColorNMIMirror+2

    ;Red and Green
    REP #$20
    LDA.b DirectPage.FixedColorCPUMirror
    ASL
    ASL
    ASL
    SEP #$21
    ROR
    ROR
    ROR
    ;Red
    STA.b DirectPage.FixedColorNMIMirror+0
    XBA
    AND #$1F
    ORA #$40
    ;Green
    STA.b DirectPage.FixedColorNMIMirror+1
RTS
