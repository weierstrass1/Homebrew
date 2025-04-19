struct VRAMQueue
    .Length: skip 1
    .SourceAddress: skip !VRAMQueueSize*3
    .SourceLength: skip !VRAMQueueSize*2
    .VRAMOffset: skip !VRAMQueueSize*2 
endstruct
skip sizeof(VRAMQueue)
