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
    LDA.b DirectPage.ScreenDisplayMirror
    AND #$0F
    STA.w PPURegisters.ScreenDisplayReg2100

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

    LDA.w HardwareRegisters.NMIFlagAnd5A22VersionReg4210
    LDA #$80
    ORA.b DirectPage.ScreenDisplayMirror
    STA.w PPURegisters.ScreenDisplayReg2100

    LDA.b DirectPage.HDMAEnablerMirror
    STA.w HardwareRegisters.HDMAEnablerReg420C

    LDA.b DirectPage.OAMSizeAndAddressMirror
    STA.w PPURegisters.OAMSizeAndAddressReg2101
    LDA.b DirectPage.PixelationMirror
    STA.w PPURegisters.ScreenPixelationReg2106

    LDA.b DirectPage.ChangeColorMathConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeColorMathConfigFlag

    LDA.b DirectPage.ColorMathConfigMirror
    STA.w PPURegisters.ColorMathDesignationReg2131
    LDA.b DirectPage.ColorAdditionSelectMirror
    STA.w PPURegisters.ColorAdditionSelectReg2130
+

    LDA.b DirectPage.ChangeMainSubScreenConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeMainSubScreenConfigFlag

    LDA.b DirectPage.MainScreenDesignationMirror
    STA.w PPURegisters.MainScreenDesignationReg212C
    LDA.b DirectPage.SubScreenDesignation
    STA.w PPURegisters.SubScreenDesignationReg212D
+

    LDA.b DirectPage.ChangeWindowConfigFlag
    BEQ +
    STZ.b DirectPage.ChangeWindowConfigFlag

    LDA.b DirectPage.WindowSettingsLayer12Mirror
    STA.w PPURegisters.WindowMaskSettingsBG12Reg2123
    LDA.b DirectPage.WindowSettingsLayer34Mirror
    STA.w PPURegisters.WindowMaskSettingsBG34Reg2124
    LDA.b DirectPage.WindowSettingsObjectAndColorWindowMirror
    STA.w PPURegisters.WindowMaskSettingsOAMColorWindowReg2125
    LDA.b DirectPage.MainScreenWindowMaskMirror
    STA.w PPURegisters.WindowLogicBG1234Reg212A
    LDA.b DirectPage.SubScreenWindowMaskMirror
    STA.w PPURegisters.WindowLogicOAMColorwindowReg212B
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
    STA.w PPURegisters.SNESModeReg2105

    REP #$20
    LDA.b DirectPage.TilemapAddressLayer1Mirror
    STA.w PPURegisters.BG1TileAddressAndSizeReg2107
    LDA.b DirectPage.TilemapAddressLayer3Mirror
    STA.w PPURegisters.BG3TileAddressAndSizeReg2109
    LDA.b DirectPage.GraphicsAddressLayer12Mirror
    STA.w PPURegisters.BG12GraphicsAddressReg210B
    SEP #$20
+
    LDA.b DirectPage.FixedColorNMIMirror
    STA.w PPURegisters.FixedColorDataReg2132
    LDA.b DirectPage.FixedColorNMIMirror+1
    STA.w PPURegisters.FixedColorDataReg2132
    LDA.b DirectPage.FixedColorNMIMirror+2
    STA.w PPURegisters.FixedColorDataReg2132

    LDX #$00
    JSR.w (NMI_ScrollRoutine,x)

    REP #$30
    LDA.w #DMARegisters       ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    SEP #$30

    LDY #!DMAEnabler

    LDX #$00
    JSR.w (NMI_OAMRoutine,x)

    JSR VRAMQueueRoutine
    JSR CGRAMQueueRoutine

    REP #$30
    LDA #$0000                ;\ Set the Direct Page $004300-FF
    TCD                       ;/ (mirror of $7E0000-FF)
    SEP #$30

    LDA.b DirectPage.ScreenDisplayMirror
    AND #$0F
    STA.w PPURegisters.ScreenDisplayReg2100

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
incsrc "OAM.asm"
