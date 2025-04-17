NMIHandlerEmu:
NMIHandlerNative:

    SEI ;Set Interrupt flag so routine can start

    PHP
    PHB
    REP #$30
    PHA
    PHX
    PHY
    SEP #$30

    LDA.b DirectPage.GameLoopRunning
    BEQ .FullNMI
    ;Short NMI runs at 60FPS, It is executed when the game has lag.
.ShortNMI
    LDA #$80
    TRB.w PPURegisters.ScreenDisplayReg2100_x000bbbb

    STZ.b DirectPage.InterruptRunning

    REP #$30
    PLY
    PLX
    PLA
    SEP #$30
    PLB
    PLP
RTI
    ;FullNMI Runs once every 1 gameloop.
.FullNMI
    LDA.w HardwareRegisters.NMIFlagAnd5A22VersionReg4210_n000vvvv
    LDA #$80
    TSB.w PPURegisters.ScreenDisplayReg2100_x000bbbb

    LDA.b DirectPage.HDMAEnablerMirror
    STA.w HardwareRegisters.HDMAEnablerReg420C

    LDA.b DirectPage.OAMSizeAndAddressMirror
    STA.w PPURegisters.OAMSizeAndAddressReg2101_sssnnbbb
    LDA.b DirectPage.PixelationMirror
    STA.w PPURegisters.ScreenPixelationReg2106_xxxxDCBA

    LDA.b DirectPage.ChangeColorMathConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeColorMathConfigFlag

    LDA.b DirectPage.ColorMathConfigMirror
    STA.w PPURegisters.ColorMathDesignationReg2131_shbo4321
    LDA.b DirectPage.ColorAdditionSelectMirror
    STA.w PPURegisters.ColorAdditionSelectReg2130_ccmm00sd
+

    LDA.b DirectPage.ChangeMainSubScreenConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeMainSubScreenConfigFlag

    LDA.b DirectPage.MainScreenDesignationMirror
    STA.w PPURegisters.MainScreenDesignationReg212C_000o4321
    LDA.b DirectPage.SubScreenDesignation
    STA.w PPURegisters.SubScreenDesignationReg212D_000o4321
+

    LDA.b DirectPage.ChangeWindowConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeWindowConfigFlag

    LDA.b DirectPage.WindowSettingsLayer12Mirror
    STA.w PPURegisters.WindowMaskSettingsBG12Reg2123_ABCDabcd
    LDA.b DirectPage.WindowSettingsLayer34Mirror
    STA.w PPURegisters.WindowMaskSettingsBG34Reg2124_ABCDabcd
    LDA.b DirectPage.WindowSettingsObjectAndColorWindowMirror
    STA.w PPURegisters.WindowMaskSettingsOAMColorWindowReg2125_ABCDabcd
    LDA.b DirectPage.MainScreenWindowMaskMirror
    STA.w PPURegisters.WindowLogicBG1234Reg212A_44332211
    LDA.b DirectPage.SubScreenWindowMaskMirror
    STA.w PPURegisters.WindowLogicOAMColorwindowReg212B_0000ccoo
+

    LDA.b DirectPage.UseWindowFlag
    BEQ +
    LDA.b DirectPage.Window1LeftMirror
    STA.w PPURegisters.Window1LeftReg2126
    LDA.b DirectPage.Window1RightMirror
    STA.w PPURegisters.Window1RightReg2127
    LDA.b DirectPage.Window2LeftMirror
    STA.w PPURegisters.Window2LeftReg2128
    LDA.b DirectPage.Window2RightMirror
    STA.w PPURegisters.Window2RightReg2129
+

    LDA.b DirectPage.ChangeLayerConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeLayerConfigFlag

    LDA.b DirectPage.ModeMirror
    STA.w PPURegisters.SNESModeReg2105_DCBAemmm

    REP #$20
    LDA.b DirectPage.TilemapAddressLayer1Mirror
    STA.w PPURegisters.BG1TileAddressAndSizeReg2107_aaaaaayx
    LDA.b DirectPage.TilemapAddressLayer3Mirror
    STA.w PPURegisters.BG3TileAddressAndSizeReg2109_aaaaaayx
    LDA.b DirectPage.GraphicsAddressLayer12Mirror
    STA.w PPURegisters.BG12GraphicsAddressReg210B_22221111
    SEP #$20
+
    LDA.b DirectPage.FixedColorNMIMirror
    STA.w PPURegisters.FixedColorDataReg2132_Write1OrMore_BGRVVVVV
    LDA.b DirectPage.FixedColorNMIMirror+1
    STA.w PPURegisters.FixedColorDataReg2132_Write1OrMore_BGRVVVVV
    LDA.b DirectPage.FixedColorNMIMirror+2
    STA.w PPURegisters.FixedColorDataReg2132_Write1OrMore_BGRVVVVV

    LDX #$00
    JSR.w (NMI_ScrollRoutine,x)

    REP #$30
    LDA #$4300                ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    SEP #$30

    LDY #!DMAEnabler

    JSR VRAMQueueRoutine
    JSR CGRAMQueueRoutine

    REP #$30
    LDA #$0000                ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    SEP #$30

    LDA #$80
    TRB.w PPURegisters.ScreenDisplayReg2100_x000bbbb

    STZ.b DirectPage.InterruptRunning

    REP #$30
    PLY
    PLX
    PLA
    SEP #$30
    PLB
    PLP
RTI

incsrc "VRAMQueue.asm"
incsrc "CGRAMQueue.asm"
incsrc "FixedColor.asm"
incsrc "Scrollroutine.asm"
