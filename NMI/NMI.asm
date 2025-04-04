NMIHandlerEmu:
NMIHandlerNative:
    SEI ;Set Interrupt flag so routine can start

    PHB
    PHP
    REP #$30
    PHA
    PHX
    PHY

    LDA #$4300                ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    SEP #$30

    JSR VRAMQueue

    REP #$30
    PLY
    PLX
    PLA
    SEP #$30
    PLP
    PLB
RTI

incsrc "VRAMQueue.asm"