pushpc
namespace nested on
struct DirectPage !MainRAMBank
    .Scratch: skip $30
    .InterruptRunning: skip 1
    .OAMSizeAndAddressMirror: skip 1
    .ModeMirror: skip 1
    .ModeReadMirror: skip 1
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

CurrentDataSent: skip 2
MaxDataPerFrame: skip 2

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
namespace nested off
pullpc

if !sa1
    !MultiplicationResult = $2306
    !DivisionResult = $2306
    !RemainderResult = $2308
else
    !MultiplicationResult = $4216
    !DivisionResult = $4214
    !RemainderResult = $4216
endif