Init:
    STZ.w Gamemode_Load_Step
RTL

Main:
    LDA.w Gamemode_Load_Step
    BNE +
    JSR GraphicSetup
    JSR LoadPalette
    INC.w Gamemode_Load_Step
RTL
+
    JSR LoadGraphic
RTL

GraphicSetup:
    LDA #$0F
    TRB $2100

    LDA #$01
    STA.b DirectPage.ChangeLayerConfigFlag
    STA.b DirectPage.ChangeMainSubScreenConfigFlag
    STA.b DirectPage.ChangeColorMathConfigFlag
    STA.b DirectPage.ChangeWindowConfigFlag

    STZ.b DirectPage.UseWindowFlag

    %MulW(".w Levels_Index", " #$24")
    REP #$30
    LDX !MultiplicationResult
    
    LDA.w ConfigPerLevel+$03,x
    STA.b DirectPage.TilemapAddressLayer1Mirror
    LDA.w ConfigPerLevel+$05,x
    STA.b DirectPage.TilemapAddressLayer3Mirror
    LDA.w ConfigPerLevel+$07,x
    STA.b DirectPage.GraphicsAddressLayer12Mirror
    LDA.w ConfigPerLevel+$09,x
    STA.b DirectPage.ColorMathConfigMirror
    LDA.w ConfigPerLevel+$0B,x
    STA.b DirectPage.MainScreenDesignationMirror
    LDA.w ConfigPerLevel+$0D,x
    STA.b DirectPage.WindowSettingsLayer12Mirror
    LDA.w ConfigPerLevel+$10,x
    STA.b DirectPage.MainScreenWindowMaskMirror

    LDA.w ConfigPerLevel+$12,x
    STA.w Scroll.HScrollLayer1NextFrame
    LDA.w ConfigPerLevel+$14,x
    STA.w Scroll.VScrollLayer1NextFrame
    LDA.w ConfigPerLevel+$16,x
    STA.w Scroll.HScrollLayer2NextFrame
    LDA.w ConfigPerLevel+$18,x
    STA.w Scroll.VScrollLayer2NextFrame
    LDA.w ConfigPerLevel+$1A,x
    STA.w Scroll.HScrollLayer3NextFrame
    LDA.w ConfigPerLevel+$1C,x
    STA.w Scroll.VScrollLayer3NextFrame
    LDA.w ConfigPerLevel+$1E,x
    STA.w Scroll.HScrollLayer4NextFrame
    LDA.w ConfigPerLevel+$20,x
    STA.w Scroll.VScrollLayer4NextFrame

    LDA.w ConfigPerLevel+$22,x
    STA.b DirectPage.FixedColorCPUMirror
    SEP #$20

    LDA.w ConfigPerLevel+$00,x
    STA.b DirectPage.OAMSizeAndAddressMirror
    LDA.w ConfigPerLevel+$01,x
    STA.b DirectPage.ModeMirror
    LDA.w ConfigPerLevel+$02,x
    STA.b DirectPage.PixelationMirror
    LDA.w ConfigPerLevel+$0F,x
    STA.b DirectPage.WindowSettingsObjectAndColorWindowMirror
    SEP #$30
RTS
incsrc "GraphicConfigTable.asm"

LoadGraphic:
    LDA.w Levels_Index
    REP #$30
    AND #$00FF
    ASL
    TAY

    LDA.w GraphicLoadPointersTable,y
    STA.b DirectPage.Scratch+$10

    LDA.w Gamemode_Load_Step
    DEC A
    AND #$00FF
    %MulX7(DirectPage.Scratch+$12)
    TAY

    LDA.b (DirectPage.Scratch+$10),y
    BPL +
    SEP #$30
    LDA #$0F
    TSB $2100
RTS
+
    STA.b DirectPage.Scratch+5
    
    SEP #$10
    INY : INY
    LDA.b (DirectPage.Scratch+$10),y
    STA.b DirectPage.Scratch

    INY
    LDA.b (DirectPage.Scratch+$10),y
    STA.b DirectPage.Scratch+1

    INY : INY
    LDA.b (DirectPage.Scratch+$10),y
    STA.b DirectPage.Scratch+3
    SEP #$30

    JSL Routines_ForcedVRAMDMA

    INC.w Gamemode_Load_Step
RTS
incsrc "GraphicLoadTable.asm"

LoadPalette:

    LDA.w Levels_Index
    REP #$30
    AND #$00FF
    ASL
    TAY

    LDA.w PalettePerLevel,y
    STA.b DirectPage.Scratch
    LDA.w PalettePerLevel+1,y
    STA.b DirectPage.Scratch+1


    LDA #$0200
    STA.b DirectPage.Scratch+3
        
    SEP #$30
    STZ.b DirectPage.Scratch+5

    JSL Routines_ForcedCGRAMDMA
RTS
incsrc "PaletteLoadTable.asm"