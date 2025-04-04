org $7E0000

struct DirectPage $7E0000
    .Scratch: skip $30
endstruct

struct VRAMQueue $7E04A0
    .Length: skip 1
    .SourceLength: skip !VRAMQueueSize*2
    .SourceAddress: skip !VRAMQueueSize*3
    .VRAMOffset: skip !VRAMQueueSize*2 
endstruct