SetupScrollRoutine:
    LDA.b DirectPage.ModeMirror
    AND #$07
    ASL
    TAX

    REP #$20
    LDA ScrollMovementRoutines,x
    STA.w NMI_ScrollRoutine
    SEP #$20
RTS

ScrollMovementRoutines:
    dw .L4
    dw .L3
    dw .L2
    dw .L2
    dw .L2
    dw .L2
    dw .L1
    dw .L1

.L4
    LDA.b DirectPage.HScrollLayer4Mirror
    STA $2113
    LDA.b DirectPage.HScrollLayer4Mirror+1
    STA $2113
    LDA.b DirectPage.VScrollLayer4Mirror
    STA $2114
    LDA.b DirectPage.VScrollLayer4Mirror+1
    STA $2114
.L3
    LDA.b DirectPage.HScrollLayer3Mirror
    STA $2111
    LDA.b DirectPage.HScrollLayer3Mirror+1
    STA $2111
    LDA.b DirectPage.VScrollLayer3Mirror
    STA $2112
    LDA.b DirectPage.VScrollLayer3Mirror+1
    STA $2112
.L2
    LDA.b DirectPage.HScrollLayer2Mirror
    STA $210F
    LDA.b DirectPage.HScrollLayer2Mirror+1
    STA $210F
    LDA.b DirectPage.VScrollLayer2Mirror
    STA $2110
    LDA.b DirectPage.VScrollLayer2Mirror+1
    STA $2110
.L1
    LDA.b DirectPage.HScrollLayer1Mirror
    STA $210D
    LDA.b DirectPage.HScrollLayer1Mirror+1
    STA $210D
    LDA.b DirectPage.VScrollLayer1Mirror
    STA $210E
    LDA.b DirectPage.VScrollLayer1Mirror+1
    STA $210E
RTS
