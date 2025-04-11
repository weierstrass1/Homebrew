ProcessFixedColor:
    LDA.b DirectPage.FixedColorCPUMirror
    AND #$1F
    ORA #$20
    STA.b DirectPage.FixedColorNMIMirror+0

    LDA.b DirectPage.FixedColorCPUMirror+1
    LSR
    LSR
    AND #$1F
    ORA #$80
    STA.b DirectPage.FixedColorNMIMirror+2

    REP #$20
    LDA.b DirectPage.FixedColorCPUMirror
    ASL
    ASL
    ASL
    SEP #$20
    XBA
    AND #$1F
    ORA #$40
    STA.b DirectPage.FixedColorNMIMirror+1
RTS
