struct Scroll
    .WorldPosX                  skip 3  ;World X position in level [Fixed point, 2 byte coarse 1 byte fractional]
    .WorldPosY                  skip 3  ;World Y position in level [Fixed point, 2 byte coarse 1 byte fractional]
    .WorldXVel                  skip 2  ;World X Velocity
    .WorldYVel                  skip 2  ;World Y Velocity
    .HScrollLayer1NextFrame:    skip 2
    .VScrollLayer1NextFrame:    skip 2
    .HScrollLayer2NextFrame:    skip 2
    .VScrollLayer2NextFrame:    skip 2
    .HScrollLayer3NextFrame:    skip 2
    .VScrollLayer3NextFrame:    skip 2
    .HScrollLayer4NextFrame:    skip 2
    .VScrollLayer4NextFrame:    skip 2
endstruct
skip sizeof(Scroll)
