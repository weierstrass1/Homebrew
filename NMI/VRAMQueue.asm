VRAMQueueRoutine:
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
	STA.b $00|!DMARegOR                   ;parameter of DMA
-
    LDA.w VRAMQueue.SourceAddress,x
    STA.b $02|!DMARegOR
    LDA.w VRAMQueue.SourceAddress+1,x
    STA.b $03|!DMARegOR

    LDA.w VRAMQueue.SourceLength,x
    STA.b $05|!DMARegOR                   ;Load Length

    LDA.w VRAMQueue.VRAMOffset,x
    STA $2116                           ;Loads VRAM destination

    STY $420B                           ;Start the DMA Transfer

    DEX
    DEX
    BPL -
    
    SEP #$20
    STZ.w VRAMQueue.Length
RTS
