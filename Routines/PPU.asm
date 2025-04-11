;Input:
;s0-s2 = Source
;s3-s4 = Length
;s5-s6 = VRAM Offset
VRAMDMA:
    %TransferToVRAM(".b DirectPage.Scratch+5", ".b DirectPage.Scratch+0", ".b DirectPage.Scratch+2", ".b DirectPage.Scratch+3")
RTL

;Input:
;s0-s2 = Source
;s3-s4 = Length
;s5-s6 = VRAM Offset
ForcedVRAMDMA:
    %ForcedTransferToVRAM(".b DirectPage.Scratch+5", ".b DirectPage.Scratch+0", ".b DirectPage.Scratch+2", ".b DirectPage.Scratch+3")
RTL

;Input:
;s0-s2 = Source
;s3-s4 = Length
;s5 = CGRAM Offset
CGRAMDMA:
    %TransferToCGRAM(".b DirectPage.Scratch+5", ".b DirectPage.Scratch+0", ".b DirectPage.Scratch+2", ".b DirectPage.Scratch+3")
RTL

;Input:
;s0-s2 = Source
;s3-s4 = Length
;s5 = CGRAM Offset
ForcedCGRAMDMA:
    %ForcedTransferToCGRAM(".b DirectPage.Scratch+5", ".b DirectPage.Scratch+0", ".b DirectPage.Scratch+2", ".b DirectPage.Scratch+3")
RTL
