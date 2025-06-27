ClearOAMBuffer:
    LDA.w OAM_SizeLastFrame 
    CMP.w OAM_SizeCurrentFrame
    BEQ .Return
    BCS +
.Return
    LDA.w OAM_SizeCurrentFrame
    STA.w OAM_MaxSizeCurrentFrame
    STA.w OAM_SizeLastFrame

    STZ.w OAM_SizeCurrentFrame
RTS
+
    REP #$30
   
    LDA.w OAM_SizeCurrentFrame
    AND #$00FF
    %MulX3(DirectPage.Scratch)
    CLC
    ADC.w #OAM_ClearRoutine
    STA.b DirectPage.Scratch+2

    LDA.w OAM_SizeLastFrame
    AND #$00FF
    %MulX3(DirectPage.Scratch)
    TAY
    SEP #$20

    LDA OAM_ClearRoutine,y 
    PHA

    LDA #$60
    STA.w OAM_ClearRoutine,y 
    
    LDX #$0000
    LDA #$F0
    JSR.W (DirectPage.Scratch+2,x)

    PLA
    STA.w OAM_ClearRoutine,y
    SEP #$30

    LDA.w OAM_SizeCurrentFrame
    STA.w OAM_MaxSizeCurrentFrame
    CMP.w OAM_SizeLastFrame
    BCS +
    LDA.w OAM_SizeLastFrame
    STA.w OAM_MaxSizeCurrentFrame 
+
    LDA.w OAM_SizeCurrentFrame
    STA.w OAM_SizeLastFrame

    STZ.w OAM_SizeCurrentFrame
RTS

MergeSizesOAMBuffer:
    LDA.w OAM_SizeCurrentFrame 
    BNE +
RTS
+
    REP #$31
    AND #$00FF
    ADC #$0003
    LSR
    LSR
    STA.b DirectPage.Scratch
    ASL
    ASL
    STA.b DirectPage.Scratch+$02
    ASL
    ASL
    CLC
    ADC.b DirectPage.Scratch+$02
    CLC
    ADC.b DirectPage.Scratch
    TAX
    SEP #$20

    LDA.w OAM_MergeSizesRoutine,x
    PHA

    LDA #$60
    STA.w OAM_MergeSizesRoutine,x
    
    JSR OAM_MergeSizesRoutine

    PLA
    STA OAM_MergeSizesRoutine,x
    SEP #$10
RTS

ClearAllOAMBuffer:
    LDA #$F0
.StartClear
!i = 0
while !i < 128
    STA.w OAM_Buffer_Tile[!i].Y
    !i #= !i+1
endwhile
RTS

MergeSizes:
!i = 0
while !i < 32
    LDA.w OAM_Buffer_Sizes+(!i*4)+3
    ASL
    ASL
    ORA.w OAM_Buffer_Sizes+(!i*4)+2
    ASL
    ASL
    ORA.w OAM_Buffer_Sizes+(!i*4)+1
    ASL
    ASL
    ORA.w OAM_Buffer_Sizes+(!i*4)+0
    STA.w OAM_Buffer_SizesCompressed+!i
    !i #= !i+1
endwhile
RTS

MoveOAMClearToRAM:
    LDA.b #OAM_ClearRoutine>>16
    STA.w PPURegisters.WRAMAddressReg2181+2

    LDA.b #ClearAllOAMBuffer_StartClear>>16
    STA.w DMARegisters[!DMAChannel].SourceAddressReg43x2+2

    REP #$20
    LDA.w #OAM_ClearRoutine
    STA.w PPURegisters.WRAMAddressReg2181

    LDA #$8000
    STA.w DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt

    LDA.w #ClearAllOAMBuffer_StartClear
    STA.w DMARegisters[!DMAChannel].SourceAddressReg43x2

    LDA.w #128*3
    STA.w DMARegisters[!DMAChannel].SizeReg43x5
    SEP #$20

    LDA #!DMAEnabler
    STA.w HardwareRegisters.DMAEnablerReg420B

    LDA #$60
    STA.W OAM_ClearRoutine+(128*3)
RTS

MoveMergeSizeToRAM:
    LDA.b #OAM_MergeSizesRoutine>>16
    STA.w PPURegisters.WRAMAddressReg2181+2

    LDA.b #MergeSizes>>16
    STA.w DMARegisters[!DMAChannel].SourceAddressReg43x2+2

    REP #$20
    LDA.w #OAM_MergeSizesRoutine
    STA.w PPURegisters.WRAMAddressReg2181

    LDA #$8000
    STA.w DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt

    LDA.w #MergeSizes
    STA.w DMARegisters[!DMAChannel].SourceAddressReg43x2

    LDA.w #(31*21)
    STA.w DMARegisters[!DMAChannel].SizeReg43x5
    SEP #$20

    LDA #!DMAEnabler
    STA.w HardwareRegisters.DMAEnablerReg420B

    LDA #$60
    STA.W OAM_MergeSizesRoutine+(32*21)
RTS

SelectOAMRoutine:
    LDA.w OAM_MaxSizeCurrentFrame
    BNE +

    REP #$20
    LDA.w #.Empty
    STA.w NMI_OAMRoutine
    SEP #$20
RTS
+
    CMP #100
    BCC +
    REP #$20
    LDA.w #.UploadAll
    STA.w NMI_OAMRoutine
    SEP #$20
RTS
+
    REP #$20
    AND #$00FF
    ASL
    ASL
    STA.w NMI_OAMDMASize1

    LDA.w #.UploadSome
    STA.w NMI_OAMRoutine
    SEP #$20

    LDA.w OAM_MaxSizeCurrentFrame
    INC A
    INC A
    INC A
    AND #$FC
    CMP #128
    BCC +
    LDA #128
+
    LSR
    LSR
    STA.w NMI_OAMDMASize2
RTS

.Empty
RTS

.UploadAll
    LDA.b #OAM_Buffer_Tile+2
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2+2

    REP #$20
    STZ.w PPURegisters.OAMAddressLowByteReg2102
    LDA #$0400
    STA.b DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt

    LDA.w #OAM_Buffer_Tile
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2

    LDA.w #$0220
    STA.b DMARegisters[!DMAChannel].SizeReg43x5
    SEP #$20

    STY.w HardwareRegisters.DMAEnablerReg420B
RTS

.UploadSome
    LDA.b #OAM_Buffer_Tile>>16
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2+2

    REP #$20
    STZ.w PPURegisters.OAMAddressLowByteReg2102
    LDA #$0400
    STA.b DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt

    LDA.w #OAM_Buffer_Tile
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2

    LDA.w NMI_OAMDMASize1
    STA.b DMARegisters[!DMAChannel].SizeReg43x5

    STY.w HardwareRegisters.DMAEnablerReg420B

    LDX.w NMI_OAMDMASize2
    STX.b DMARegisters[!DMAChannel].SizeReg43x5

    LDA #$0100
    STA.w PPURegisters.OAMAddressLowByteReg2102

    LDA.w #OAM_Buffer_SizesCompressed
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2
    SEP #$20

    STY.w HardwareRegisters.DMAEnablerReg420B
RTS
