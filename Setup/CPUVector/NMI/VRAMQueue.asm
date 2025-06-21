VRAMQueueRoutine:
    LDA.w VRAMQueue.Length
    BNE +
RTS
+
    LDX #$80                
	STX.w PPURegisters.VideoPortControlReg2115

    DEC A
    ASL
    TAX

    REP #$20
	LDA #$1801            
	STA.b DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt  ;parameter of DMA
-
    LDA.w VRAMQueue.SourceAddress,x
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2
    LDA.w VRAMQueue.SourceAddress+1,x
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2+1

    LDA.w VRAMQueue.SourceLength,x
    STA.b DMARegisters[!DMAChannel].SizeReg43x5              ;Load Length

    LDA.w VRAMQueue.VRAMOffset,x
    STA.w PPURegisters.VRAMAddressReg2116                    ;Loads VRAM destination

    STY.w HardwareRegisters.DMAEnablerReg420B                ;Start the DMA Transfer

    DEX
    DEX
    BPL -
    
    SEP #$20
    STZ.w VRAMQueue.Length
RTS
