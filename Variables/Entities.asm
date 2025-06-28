struct Entity 
    .ID: skip 2
    .X: skip 3
    .Y: skip 3
    .XSpeed: skip 2
    .YSpeed: skip 2
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
