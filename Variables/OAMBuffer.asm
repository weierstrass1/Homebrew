Struct OAM_Buffer_Tile
    .X: skip 1
    .Y: skip 1
    .Number: skip 1
    .Property: skip 1
endstruct
skip sizeof(OAM_Buffer_Tile)*128
namespace OAM
    namespace Buffer
        SizesCompressed: skip 32
        Sizes: skip 128
    namespace off
    SizeCurrentFrame: skip 1
    SizeLastFrame: skip 1
    ClearRoutine: skip (128*3)+1
namespace off
