!sa1 = 0
!Fastrom = 1
!Stack = $01FF
!DMAChannel = 0
!DMAEnabler #= 2**!DMAChannel
!DMAInitialMaxDataPerFrame = $1000
!VRAMQueueSize = $40
!CGRAMQueueSize = $40

!UseHIRQ = 0
!UseVIRQ = 0

!IRQFlag #= (!UseHIRQ*$10)|(!UseVIRQ*$20)

!MainRAMBank = $7E0000
!OAMBuffer = !MainRAMBank+$200
!OAMTileX = !OAMBuffer+0
!OAMTileY = !OAMBuffer+1
!OAMTileNumber = !OAMBuffer+2
!OAMTileProp = !OAMBuffer+3

!SampleStreamingAcknowledge = $69
!SampleStreamingDataBlockCount = 9
!SampleStreamingDataPerLoopSize #= !SampleStreamingDataBlockCount*4

;0 = 1 entity
;1 = 2 entities
;2 = 4 entities
;3 = 8 entities
;4 = 16 entities
;5 = 32 entities
;6 = 64 entities
;7 = 128 entities
!EntitiesMaxSizeSQRT = 6
!EntitiesMaxSize #= 2**!EntitiesMaxSizeSQRT

if !EntitiesMaxSize > 128
    !EntitiesMaxSize = 128
endif

if !Fastrom == 1
!FastromBNK = $800000
else
!FastromBNK = $000000
endif