struct CGRAMQueue
    .Length: skip 1
    .SourceAddress: skip !CGRAMQueueSize*3
    .SourceLength: skip !CGRAMQueueSize*2
    .CGRAMOffset: skip !CGRAMQueueSize
endstruct
skip sizeof(CGRAMQueue)
