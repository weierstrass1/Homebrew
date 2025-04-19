org $004300
struct DMARegisters
    .ControlReg43x0_da0ifttt: skip 1
    .DestinationRegisterReg43x1: skip 1
    .SourceAddressReg43x2: skip 3
    .SizeReg43x5: skip 2
    .HDMAIndirectBankReg43x7: skip 1
    .HDMATableAddressReg43x8: skip 2
    .HDMALineCounterReg43xA_rccccccc: skip 1
endstruct align $10
skip sizeof(DMARegisters)*8
