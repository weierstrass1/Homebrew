;s0-s2 : Resource Address
;s3 : blocks
;A,X,Y 8 bits
TransferToSPC700:
    LDY #$01
    LDX #$04

    LDA.b DirectPage.Scratch+3
    LSR
    LSR
    STA.b DirectPage.Scratch+3

    LDA.b DirectPage.Scratch+2
    STA.w DMARegisters[!DMAChannel].SourceAddressReg43x2+2

    STZ.w DMARegisters[!DMAChannel].SizeReg43x5+1

    REP #$20

    LDA #$4004
    STA.w DMARegisters[!DMAChannel].ControlReg43x0_da0ifttt

    LDA.b DirectPage.Scratch
    STA.w DMARegisters[!DMAChannel].SourceAddressReg43x2
    SEP #$20

    LDA #!SampleStreamingAcknowledge
    STA  $2143
.Loop
    LDA #!SampleStreamingAcknowledge
..Wait
    CMP $2143
    BNE ..Wait

    STX.w DMARegisters[!DMAChannel].SizeReg43x5
    STY.w HardwareRegisters.DMAEnablerReg420B

    DEC.b DirectPage.Scratch+3
    BNE .Loop

RTS
    