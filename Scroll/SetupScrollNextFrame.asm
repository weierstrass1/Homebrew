SetupScrollNextFrame:
    REP #$20
    LDA.w Scroll.HScrollLayer1NextFrame
    STA.b DirectPage.HScrollLayer1Mirror
    LDA.w Scroll.VScrollLayer1NextFrame
    STA.b DirectPage.VScrollLayer1Mirror
    LDA.w Scroll.HScrollLayer2NextFrame
    STA.b DirectPage.HScrollLayer2Mirror
    LDA.w Scroll.VScrollLayer2NextFrame
    STA.b DirectPage.VScrollLayer2Mirror
    LDA.w Scroll.HScrollLayer3NextFrame
    STA.b DirectPage.HScrollLayer3Mirror
    LDA.w Scroll.VScrollLayer3NextFrame
    STA.b DirectPage.VScrollLayer3Mirror
    LDA.w Scroll.HScrollLayer4NextFrame
    STA.b DirectPage.HScrollLayer4Mirror
    LDA.w Scroll.VScrollLayer4NextFrame
    STA.b DirectPage.VScrollLayer4Mirror
    SEP #$20
RTS