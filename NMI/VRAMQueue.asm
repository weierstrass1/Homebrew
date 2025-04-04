VRAMQueue:
    LDA.w VRAMQueue.Length
    BNE +
RTS
+
    LDX #$80                
	STX $2115

    DEC A
    ASL
    TAX

    REP #$20
	LDA #$1801              
	STA $00                 ;parameter of DMA
-
    LDA.w VRAMQueue.SourceAddress,x
    STA $02
    LDA.w VRAMQueue.SourceAddress+1,x
    STA $03

    LDA.w VRAMQueue.SourceLength,x
    STA $05                 ;Load Length

    LDA.w VRAMQueue.VRAMOffset,x
    STA $2116               ;Loads VRAM destination

    LDY.w VRAMQueue.SourceBNK,x
    STY $04

    INC $420B               ;Start the DMA Transfer

    DEX
    DEX
    BPL -
    
    SEP #$20
    STZ.w VRAMQueue.Length
RTS