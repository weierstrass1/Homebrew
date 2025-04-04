pushpc
struct DirectPage !MainRAMBank
    .Scratch: skip $30
    .InterruptRunning: skip 1
    .ScreenDisplayMirror: skip 1
    .OAMSizeAndAddressMirror: skip 1
    .ModeMirror: skip 1
    .ModeReadMirror: skip 1
    .PixelationMirror: skip 1
    .ChangeLayerConfigFlag: skip 1
    .TilemapAddressLayer1Mirror: skip 1
    .TilemapAddressLayer2Mirror: skip 1
    .TilemapAddressLayer3Mirror: skip 1
    .TilemapAddressLayer4Mirror: skip 1
    .GraphicsAddressLayer12Mirror: skip 1
    .GraphicsAddressLayer34Mirror: skip 1
    .HScrollLayer1Mirror: skip 2
    .VScrollLayer1Mirror: skip 2
    .HScrollLayer2Mirror: skip 2
    .VScrollLayer2Mirror: skip 2
    .HScrollLayer3Mirror: skip 2
    .VScrollLayer3Mirror: skip 2
    .HScrollLayer4Mirror: skip 2
    .VScrollLayer4Mirror: skip 2
endstruct

org !OAMBuffer
namespace OAMBuffer
    TileXYNumberProp: skip 4*128
    SizesCompressed: skip 32
    Sizes: skip 128
namespace off

struct VRAMQueue
    .Length: skip 1
    .SourceLength: skip !VRAMQueueSize*2
    .SourceAddress: skip !VRAMQueueSize*3
    .VRAMOffset: skip !VRAMQueueSize*2 
endstruct
skip sizeof(VRAMQueue)

struct CGRAMQueue
    .Length: skip 1
    .SourceLength: skip !CGRAMQueueSize*2
    .SourceAddress: skip !CGRAMQueueSize*3
    .CGRAMOffset: skip !CGRAMQueueSize
endstruct
skip sizeof(CGRAMQueue)
pullpc
