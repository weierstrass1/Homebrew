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
	STA.b $00|!DMARegOR                   ;parameter of DMA
-
    LDA.w CGRAMQueue.SourceAddress,x
    STA.b $02|!DMARegOR

    LDA.w CGRAMQueue.SourceLength,x
    STA.b $05|!DMARegOR                   ;Load Length

    SEP #$20

    PHX
    TXA
    LSR
    TAX

    LDA.w CGRAMQueue.SourceAddress+2,x
    STA.b $04|!DMARegOR
    LDA.w CGRAMQueue.CGRAMOffset,x
    PLX

    STA $2121                           ;Loads VRAM destination
    REP #$20

    STY $420B                           ;Start the DMA Transfer

    DEX
    DEX
    BPL -
    
    SEP #$20
    STZ.w CGRAMQueue.Length
RTS
