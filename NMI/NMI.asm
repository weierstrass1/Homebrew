NMIHandlerEmu:
NMIHandlerNative:
    SEI ;Set Interrupt flag so routine can start
    PHB
    PHP
    REP #$30
    PHA
    PHX
    PHY
    SEP #$30

    LDA.b DirectPage.ScreenDisplayMirror
    STA $2100
    LDA.b DirectPage.OAMSizeAndAddressMirror
    STA $2101
    LDA.b DirectPage.PixelationMirror
    STA $2106

    LDA.b DirectPage.ChangeLayerConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeLayerConfigFlag
    LDA.b DirectPage.ModeMirror
    STA $2105
    STA.b DirectPage.ModeReadMirror
    REP #$20
    LDA.b DirectPage.TilemapAddressLayer1Mirror
    STA $2107
    LDA.b DirectPage.TilemapAddressLayer3Mirror
    STA $2109
    LDA.b DirectPage.GraphicsAddressLayer12Mirror
    STA $210B
    SEP #$20
+
    LDA.b DirectPage.ModeReadMirror
    AND #$07
    ASL
    TAX
    JSR (ScrollMovementRoutines,x)

    REP #$30
    LDA #$4300                ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    SEP #$30
    PHK
    PLB

    INC.b DirectPage.InterruptRunning

    LDY #!DMAEnabler

    JSR VRAMQueueRoutine
    JSR CGRAMQueueRoutine

    REP #$30
    LDA #$0000                ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    PLY
    PLX
    PLA
    SEP #$30
    PLP
    PLB
RTI

incsrc "VRAMQueue.asm"
incsrc "CGRAMQueue.asm"

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