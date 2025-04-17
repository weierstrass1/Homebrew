incsrc "Constants.asm"
incsrc "Variables.asm"
incsrc "MacrosInclude.asm"

incsrc "Setup/Header.asm"
incsrc "Setup/CPUVector.asm"

org $808000
StartGame:
ResetHandlerEmu:
    SEI                       ; Disable IRQ
    LDA #$01
    STA.w HardwareRegisters.ROMAccessSpeedReg420D_0000000f  ; Disable IRQ, NMI and joypad reading
    STZ.w HardwareRegisters.HDMAEnablerReg420C              ; Disable HDMA
    STZ.w HardwareRegisters.DMAEnablerReg420B               ; Disable DMA
    STZ.w PPURegisters.APUPort0Reg2140                      ;\ Clear APU I/O ports (1-4) (End music)
    STZ.w PPURegisters.APUPort1Reg2141                      ;|
    STZ.w PPURegisters.APUPort2Reg2142                      ;|
    STZ.w PPURegisters.APUPort3Reg2143                      ;/

    LDA #$80                                                ;\ Activate force blank (lowest brightness)
    STA.w PPURegisters.ScreenDisplayReg2100_x000bbbb        ;/

    CLC                       ;\ Disable 6502 emulation mode
    XCE                       ;/

    REP #$38                  ; Disable decimal mode; widen A, X and Y to 16-bit
    LDA #!DMAInitialMaxDataPerFrame
    STA.w NMI_DMAMaxDataPerFrame
    LDA #$0000                ;\ Set the Direct Page $000000-FF
    STA.b DirectPage.GameLoopRunning
    STA.b DirectPage.TilemapAddressLayer1Mirror
    STA.b DirectPage.TilemapAddressLayer3Mirror
    STA.b DirectPage.GraphicsAddressLayer12Mirror
    STA.b DirectPage.HScrollLayer1Mirror
    STA.b DirectPage.VScrollLayer1Mirror
    STA.b DirectPage.HScrollLayer2Mirror
    STA.b DirectPage.VScrollLayer2Mirror
    STA.b DirectPage.HScrollLayer3Mirror
    STA.b DirectPage.VScrollLayer3Mirror
    STA.b DirectPage.HScrollLayer4Mirror
    STA.b DirectPage.VScrollLayer4Mirror
    STA.w Scroll.HScrollLayer1NextFrame
    STA.w Scroll.VScrollLayer1NextFrame
    STA.w Scroll.HScrollLayer2NextFrame
    STA.w Scroll.VScrollLayer2NextFrame
    STA.w Scroll.HScrollLayer3NextFrame
    STA.w Scroll.VScrollLayer3NextFrame
    STA.w Scroll.HScrollLayer4NextFrame
    STA.w Scroll.VScrollLayer4NextFrame
    STA.b DirectPage.ColorMathConfigMirror
    STA.b DirectPage.MainScreenDesignationMirror
    STA.b DirectPage.WindowSettingsLayer12Mirror
    STA.b DirectPage.WindowSettingsObjectAndColorWindowMirror
    STA.b DirectPage.MainScreenWindowMaskMirror
    STA.b DirectPage.SubScreenWindowMaskMirror
    STA.b DirectPage.HDMAEnablerMirror

    TCD                       ;/             (mirror of $7E0000-FF)
    LDA #!Stack               ;\ Set the Stack Pointer
    TCS                       ;/
    SEP #$30

    STZ.b DirectPage.UseWindowFlag
    STZ.w Gamemode_Index
    STZ.w Levels_Index
    STZ.w CGRAMQueue.Length
    STZ.w VRAMQueue.Length

    LDA #$01
    STA.b DirectPage.ChangeColorMathConfigFlag
    STA.b DirectPage.ChangeMainSubScreenConfigFlag
    STA.b DirectPage.ChangeWindowConfigFlag
    STA.b DirectPage.ChangeLayerConfigFlag
    STA.b DirectPage.InterruptRunning
    STA.b DirectPage.ModeMirror

    JSR SetupScrollRoutine
    LDA.w HardwareRegisters.NMIFlagAnd5A22VersionReg4210_n000vvvv
    LDA #$81
    STA.w HardwareRegisters.InterruptEnableFlagsReg4200_n0yx000a
    WAI
-
    LDA.b DirectPage.InterruptRunning
    BNE -
    CLI
    
    INC.b DirectPage.GameLoopRunning
    STZ.w NMI_DMACurrentDataSent
    STZ.w NMI_DMACurrentDataSent+1
    JSR SetupScrollNextFrame
    JSR GamemodeCall
    JSR ProcessFixedColor
    JSR SetupScrollRoutine
    
    INC.b DirectPage.InterruptRunning
    STZ.b DirectPage.GameLoopRunning
    WAI
    BRA -

incsrc "Setup/CPUVector/COP.asm"
incsrc "Setup/CPUVector/BRK.asm"
incsrc "Setup/CPUVector/Abort.asm"
incsrc "Setup/CPUVector/IRQ/IRQ.asm"
incsrc "Setup/CPUVector/NMI/NMI.asm"

incsrc "Gamemodes/GamemodeManagement.asm"
incsrc "Scroll/ScrollingSystem.asm"

incsrc "Routines/RoutinesInclude.asm"
incsrc "Resources/ResourceInclude.asm"
