CGRAMQueueRoutine:
    LDA.w CGRAMQueue.Length
    BNE +
RTS
+
    DEC A
    ASL
    TAX

    REP #$20
	LDA #$2202              
	STA.b DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt  ;parameter of DMA
-
    LDA.w CGRAMQueue.SourceAddress,x
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2

    LDA.w CGRAMQueue.SourceLength,x
    STA.b DMARegisters[!DMAChannel].SizeReg43x5              ;Load Length

    SEP #$20

    PHX
    TXA
    LSR
    TAX

    LDA.w CGRAMQueue.SourceAddress+2,x
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2+2
    LDA.w CGRAMQueue.CGRAMOffset,x
    PLX

    STA.w PPURegisters.CGRAMAddressReg2121                   ;Loads VRAM destination
    REP #$20

    STY.w HardwareRegisters.DMAEnablerReg420B                ;Start the DMA Transfer

    DEX
    DEX
    BPL -
    
    SEP #$20
    STZ.w CGRAMQueue.Length
RTS
