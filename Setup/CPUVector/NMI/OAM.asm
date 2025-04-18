ClearOAMBuffer:
    LDA.w OAM_SizeLastFrame 
    CMP.w OAM_SizeCurrentFrame
    BEQ .Return
    BCS +
    LDA.w OAM_SizeLastFrame 
    STA.w OAM_SizeCurrentFrame
.Return
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

    LDA #$60
    STA.w OAM_ClearRoutine,y 
    
    LDX #$0000
    LDA #$F0
    JSR (DirectPage.Scratch+2,x)

    LDA #$8D
    STA.w OAM_ClearRoutine,y
    SEP #$30

    LDA.w OAM_SizeLastFrame 
    STA.w OAM_SizeCurrentFrame
RTS

ClearAllOAMBuffer:
    LDA #$F0
.StartClear
!i = 0
while !i < 128
    STA.w OAM_Buffer_Tile.Y+(!i*4)
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
    STA OAM_ClearRoutine+(128*3)
RTS

SelectOAMRoutine:
    LDA.w OAM_SizeCurrentFrame
    ORA.w OAM_SizeLastFrame
    BNE +

    REP #$20
    LDA.w #.Empty
    STA.w NMI_OAMRoutine
    SEP #$20
RTS
+
    LDA.w OAM_SizeLastFrame
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

    LDA.w OAM_SizeLastFrame
    INC A
    INC A
    AND #$FC
    CMP #127
    BCC +
    LDA #127
+
    INC A
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

    LDA.w #544
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

    LDA #512
    STA.w PPURegisters.OAMAddressLowByteReg2102

    LDA.w #SizesCompressed
    STA.b DMARegisters[!DMAChannel].SourceAddressReg43x2
    SEP #$20

    STY.w HardwareRegisters.DMAEnablerReg420B
RTS
