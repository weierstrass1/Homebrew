incsrc "Constants.asm"
incsrc "Variables.asm"
incsrc "MacrosInclude.asm"

incsrc "Setup/Header.asm"
incsrc "Setup/CPUVector.asm"

org $808000
StartGame:
ResetHandlerEmu:
    SEI                       ; Disable IRQ
    STZ $4200                 ; Disable IRQ, NMI and joypad reading
    STZ $420C                 ; Disable HDMA
    STZ $420B                 ; Disable DMA
    STZ $2140                 ;\ Clear APU I/O ports (1-4) (End music)
    STZ $2141                 ;|
    STZ $2142                 ;|
    STZ $2143                 ;/

    LDA #$80                  ;\ Activate force blank (lowest brightness)
    STA $2100                 ;/

    CLC                       ;\ Disable 6502 emulation mode
    XCE                       ;/

    REP #$38                  ; Disable decimal mode; widen A, X and Y to 16-bit
    LDA #!DMAInitialMaxDataPerFrame
    STA.w NMI_DMAMaxDataPerFrame
    LDA #$0000                ;\ Set the Direct Page $000000-FF
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
    SEP #$20

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

    LDA $4210
    LDA #$81
    STA $4200
-
    LDA.b DirectPage.InterruptRunning
    BEQ -
    CLI
    
    LDA #$01
    STA $4200
    STZ.w NMI_DMACurrentDataSent
    STZ.w NMI_DMACurrentDataSent+1
    JSR SetupScrollNextFrame
    JSR GamemodeCall
    JSR ProcessFixedColor
    JSR SetupScrollRoutine
    
    STZ.b DirectPage.InterruptRunning

    LDA $4210
    LDA #$81
    STA $4200
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
