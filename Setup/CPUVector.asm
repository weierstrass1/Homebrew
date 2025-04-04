org $80FFE0
CPUVector:
    dw $0000,$0000
.COPNative
    dw COPHandlerNative
.BRKNative
    dw BRKHandlerNative
.AbortNative
    dw AbortHandlerNative
.NMINative
    dw NMIHandlerNative
    dw $0000
.IRQNative
    dw IRQHandlerNative
    dw $0000,$0000
.COPEmu
    dw COPHandlerEmu
    dw $0000
.AbortEmu
    dw AbortHandlerEmu
.NMIEmu
    dw NMIHandlerEmu
.ResetEmu
    dw ResetHandlerEmu
.IRQEmu
    dw IRQHandlerEmu
