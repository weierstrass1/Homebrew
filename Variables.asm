namespace nested on
struct PPURegisters $002100
    .ScreenDisplayReg2100_x000bbbb: skip 1
    .OAMSizeAndAddressReg2101_sssnnbbb: skip 1
    .OAMAddressLowByteReg2102: skip 1
    .OAMAddressHighBitAndPriorityReg2103_p000000b: skip 1
    .OAMDataReg2104: skip 1
    .SNESModeReg2105_DCBAemmm: skip 1
    .ScreenPixelationReg2106_xxxxDCBA: skip 1
    .BG1TileAddressAndSizeReg2107_aaaaaayx: skip 1
    .BG2TileAddressAndSizeReg2108_aaaaaayx: skip 1
    .BG3TileAddressAndSizeReg2109_aaaaaayx: skip 1
    .BG4TileAddressAndSizeReg210A_aaaaaayx: skip 1
    .BG12GraphicsAddressReg210B_22221111: skip 1
    .BG34GraphicsAddressReg210C_44443333: skip 1
    .BG1HScrollReg210D_WriteTwice: skip 1
    .BG1VScrollReg210E_WriteTwice: skip 1
    .BG2HScrollReg210F_WriteTwice: skip 1
    .BG2VScrollReg2110_WriteTwice: skip 1
    .BG3HScrollReg2111_WriteTwice: skip 1
    .BG3VScrollReg2112_WriteTwice: skip 1
    .BG4HScrollReg2113_WriteTwice: skip 1
    .BG4VScrollReg2114_WriteTwice: skip 1
    .VideoPortControlReg2115_i000mmii: skip 1
    .VRAMAddressReg2116: skip 2
    .VRAMDataWriteReg2118: skip 2
    .Mode7SettingsReg211A_rc0000yx: skip 1
    .Mode7MatrixAReg211B_WriteTwice: skip 1
    .Mode7MatrixBReg211C_WriteTwice: skip 1
    .Mode7MatrixCReg211D_WriteTwice: skip 1
    .Mode7MatrixDReg211E_WriteTwice: skip 1
    .Mode7XCenterReg211F_WriteTwice: skip 1
    .Mode7YCenterReg2120_WriteTwice: skip 1
    .CGRAMAddressReg2121: skip 1
    .CGRAMDataWriteReg2122_WriteTwice_0BBBBBGGGGGRRRRR: skip 1
    .WindowMaskSettingsBG12Reg2123_ABCDabcd: skip 1
    .WindowMaskSettingsBG34Reg2124_ABCDabcd: skip 1
    .WindowMaskSettingsOAMColorWindowReg2125_ABCDabcd: skip 1
    .Window1LeftReg2126: skip 1
    .Window1RightReg2127: skip 1
    .Window2LeftReg2128: skip 1
    .Window2RightReg2129: skip 1
    .WindowLogicBG1234Reg212A_44332211: skip 1
    .WindowLogicOAMColorwindowReg212B_0000ccoo: skip 1
    .MainScreenDesignationReg212C_000o4321: skip 1
    .SubScreenDesignationReg212D_000o4321: skip 1
    .WindowMaskMainScreenDesignationReg212E_000o4321: skip 1
    .WindowMaskSubScreenDesignationReg212F_000o4321: skip 1
    .ColorAdditionSelectReg2130_ccmm00sd: skip 1
    .ColorMathDesignationReg2131_shbo4321: skip 1
    .FixedColorDataReg2132_Write1OrMore_BGRVVVVV: skip 1
    .ScreenModeVideoSelectReg2133_se00poIi: skip 1
    .MultiplicationResultReg2134: skip 3
    .SoftwareLatchHVCounterReg2137: skip 1
    .OAMDataReadReg2138: skip 1
    .VRAMDataReadReg2139: skip 2
    .CGRAMDataReadReg213B_ReadTwice_0BBBBBGGGGGRRRRR: skip 1
    .HScanlineLocationReg213C: skip 1
    .VScanlineLocationReg213D: skip 1
    .PPUStatusFlagAndVersion1Reg213E_trm0vvvv: skip 1
    .PPUStatusFlagAndVersion2Reg213F_fl0pvvvv: skip 1
    .APUPort0Reg2140: skip 1
    .APUPort1Reg2141: skip 1
    .APUPort2Reg2142: skip 1
    .APUPort3Reg2143: skip $3D
    .WRAMDataReadWriteReg2180: skip 1
    .WRAMAddressReg2181: skip 3
endstruct

struct NESJoypadRegisters $004016
    .Port1Reg4016: skip 1
    .Port2Reg4017: skip 1
endstruct

struct HardwareRegisters $004200
    .InterruptEnableFlagsReg4200_n0yx000a: skip 1
    .ProgramableIOOutPortReg4201_abxxxxxx: skip 1
    .MultiplicandAReg4202: skip 1
    .MultiplicandBReg4203: skip 1
    .DividendReg4204: skip 2
    .DivisorReg4206: skip 1
    .HTimerReg4207: skip 2
    .VTimerReg4209: skip 2
    .DMAEnablerReg420B: skip 1
    .HDMAEnablerReg420C: skip 1
    .ROMAccessSpeedReg420D_0000000f: skip 3
    .NMIFlagAnd5A22VersionReg4210_n000vvvv: skip 1
    .IRQFlagReg4211_i0000000: skip 1
    .PPUStatusReg4212_vh00000a: skip 1
    .ProgramableIOInPortReg4213_abxxxxxx: skip 1
    .DivisionResultReg4214: skip 2
    .DivisionRemainderMultiplicationResultReg4216: skip 2
    .ControllerPort1Data1Reg4218_byetUDLRaxlr0000: skip 2
    .ControllerPort2Data1Reg421A_byetUDLRaxlr0000: skip 2
    .ControllerPort1Data2Reg421C_byetUDLRaxlr0000: skip 2
    .ControllerPort2Data2Reg421E_byetUDLRaxlr0000: skip 2
endstruct

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
    .GamemodeIndexer: skip 2
    .LevelIndexer: skip 2
endstruct

org !OAMBuffer
namespace OAMBuffer
    TileXYNumberProp: skip 4*128
    SizesCompressed: skip 32
    Sizes: skip 128
namespace off

struct VRAMQueue
    .Length: skip 1
    .SourceAddress: skip !VRAMQueueSize*3
    .SourceLength: skip !VRAMQueueSize*2
    .VRAMOffset: skip !VRAMQueueSize*2 
endstruct
skip sizeof(VRAMQueue)

struct CGRAMQueue
    .Length: skip 1
    .SourceAddress: skip !CGRAMQueueSize*3
    .SourceLength: skip !CGRAMQueueSize*2
    .CGRAMOffset: skip !CGRAMQueueSize
endstruct
skip sizeof(CGRAMQueue)

struct Scroll
    .HScrollLayer1NextFrame: skip 2
    .VScrollLayer1NextFrame: skip 2
    .HScrollLayer2NextFrame: skip 2
    .VScrollLayer2NextFrame: skip 2
    .HScrollLayer3NextFrame: skip 2
    .VScrollLayer3NextFrame: skip 2
    .HScrollLayer4NextFrame: skip 2
    .VScrollLayer4NextFrame: skip 2
endstruct
skip sizeof(Scroll)

namespace NMI
    DMACurrentDataSent: skip 2
    DMAMaxDataPerFrame: skip 2
    ScrollRoutine: skip 2
namespace off

namespace Levels
    Index: skip 1
namespace off

namespace Gamemode
    Index: skip 1
    LastIndex: skip 1
    namespace Load
        Step: skip 1
    namespace off
namespace off

namespace Entities
    FirstSlot: skip 1
    LastSlot: skip 1
    Length: skip 1
    CurrentSpriteSlot: skip 2
    PreviousSlot: skip 128
    NextSlot: skip 128
namespace off

struct Entity !MainRAMBank+$010000
    .ID: skip 2
    .X: skip 3
    .Y: skip 3
    .XSpeed: skip 2
    .YSpeed: skip 2
    .XAccel: skip 2
    .YAccel: skip 2
    .HitboxSetIndex: skip 2
    .TerrainInteractionIndex: skip 2
    .State: skip 2
    .PoseIndex: skip 2
    .LastPoseIndex: skip 2
    .LastPoseHashIndex: skip 1
    .GlobalFlip: skip 1
    .LocalFlip: skip 1
    .LastFlip: skip 1
    .AnimationIndex: skip 1
    .AnimationPoseIndex: skip 1
    .AnimationTimer: skip 1
    .OthersVariables:
endstruct align 256
skip sizeof(Entity)*!EntitiesMaxSize
namespace nested off

if !sa1
    !MultiplicationResult = $2306
    !DivisionResult = $2306
    !RemainderResult = $2308
else
    !MultiplicationResult = $4216
    !DivisionResult = $4214
    !RemainderResult = $4216
endif
