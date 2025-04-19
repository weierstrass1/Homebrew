struct DirectPage !MainRAMBank
    .Scratch: skip $30
    .GameLoopRunning: skip 1
    .ScreenDisplayMirror: skip 1
    .OAMSizeAndAddressMirror: skip 1
    .ModeMirror: skip 1
    .PixelationMirror: skip 1
    .ChangeLayerConfigFlag: skip 1
    .ChangeMainSubScreenConfigFlag: skip 1
    .ChangeWindowConfigFlag: skip 1
    .ChangeColorMathConfigFlag: skip 1
    .UseWindowFlag: skip 1
    .TilemapAddressLayer1Mirror: skip 1
    .TilemapAddressLayer2Mirror: skip 1
    .TilemapAddressLayer3Mirror: skip 1
    .TilemapAddressLayer4Mirror: skip 1
    .GraphicsAddressLayer12Mirror: skip 1
    .GraphicsAddressLayer34Mirror: skip 1
    .ColorMathConfigMirror: skip 1
    .ColorAdditionSelectMirror: skip 1
    .MainScreenDesignationMirror: skip 1
    .SubScreenDesignation: skip 1
    .WindowSettingsLayer12Mirror: skip 1
    .WindowSettingsLayer34Mirror: skip 1
    .WindowSettingsObjectAndColorWindowMirror: skip 1
    .MainScreenWindowMaskMirror: skip 1
    .SubScreenWindowMaskMirror: skip 1
    .Window1LeftMirror: skip 1
    .Window1RightMirror: skip 1
    .Window2LeftMirror: skip 1
    .Window2RightMirror: skip 1
    .HScrollLayer1Mirror: skip 2
    .VScrollLayer1Mirror: skip 2
    .HScrollLayer2Mirror: skip 2
    .VScrollLayer2Mirror: skip 2
    .HScrollLayer3Mirror: skip 2
    .VScrollLayer3Mirror: skip 2
    .HScrollLayer4Mirror: skip 2
    .VScrollLayer4Mirror: skip 2
    .FixedColorCPUMirror: skip 2
    .FixedColorNMIMirror: skip 3
    .HDMAEnablerMirror: skip 1
endstruct
