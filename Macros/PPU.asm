macro ForcedTransferToVRAM(VRAMOffset, ResourceAddr, ResourceBNK, Lenght)

    LDA.w VRAMQueue.Length
    ASL
    TAX
    
    INC.w VRAMQueue.Length
    
    LDA<ResourceBNK>
    STA.w VRAMQueue.SourceAddress+2,x

    REP #$20
    LDA<ResourceAddr>
    STA.w VRAMQueue.SourceAddress,x

    LDA<Lenght>
    STA.w VRAMQueue.SourceLength,x
    CLC
    ADC.w NMI_DMACurrentDataSent
    STA.w NMI_DMACurrentDataSent

    LDA<VRAMOffset>
    STA.w VRAMQueue.VRAMOffset,x
    SEP #$20

endmacro

macro TransferToVRAM(VRAMOffset, ResourceAddr, ResourceBNK, Lenght)

    REP #$20
    LDA.w NMI_DMACurrentDataSent
    ADC<Lenght>
    CMP.w NMI_DMAMaxDataPerFrame
    SEP #$20
    BCC ?+
    STA.w NMI_DMACurrentDataSent
    XBA
    STA.w NMI_DMACurrentDataSent+1

    LDA.w VRAMQueue.Length
    ASL
    TAX
    
    INC.w VRAMQueue.Length

    LDA<ResourceBNK>
    STA.w VRAMQueue.SourceAddress+2,x

    REP #$20
    LDA<ResourceAddr>
    STA.w VRAMQueue.SourceAddress,x

    LDA<Lenght>
    STA.w VRAMQueue.SourceLength,x

    LDA<VRAMOffset>
    STA.w VRAMQueue.VRAMOffset,x
    SEP #$21
?+
endmacro

macro ForcedTransferToCGRAM(CGRAMOffset, ResourceAddr, ResourceBNK, Lenght)

    LDA.w CGRAMQueue.Length
    ASL
    TAX

    INC.w CGRAMQueue.Length

    LDA<ResourceBNK>
    STA.w CGRAMQueue.SourceAddress+2,x

    REP #$20
    LDA<ResourceAddr>
    STA.w CGRAMQueue.SourceAddress,x

    LDA<Lenght>
    STA.w CGRAMQueue.SourceLength,x
    SEP #$21
    TXA
    LSR
    TAX

    LDA<CGRAMOffset>
    STA.w CGRAMQueue.CGRAMOffset,x

endmacro

macro TransferToCGRAM(CGRAMOffset, ResourceAddr, ResourceBNK, Lenght)

    REP #$20
    LDA.w NMI_DMACurrentDataSent
    ADC<Lenght>
    CMP.w NMI_DMAMaxDataPerFrame
    SEP #$20
    BCC ?+
    STA.w NMI_DMACurrentDataSent
    XBA
    STA.w NMI_DMACurrentDataSent+1

    LDA.w CGRAMQueue.Length
    ASL
    TAX

    INC.w CGRAMQueue.Length

    LDA<ResourceBNK>
    STA.w CGRAMQueue.SourceAddress+2,x

    REP #$20
    LDA<ResourceAddr>
    STA.w CGRAMQueue.SourceAddress,x

    LDA<Lenght>
    STA.w CGRAMQueue.SourceLength,x
    SEP #$21
    TXA
    LSR
    TAX

    LDA<CGRAMOffset>
    STA.w CGRAMQueue.CGRAMOffset,x
    SEC
?+
endmacro