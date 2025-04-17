!sa1 = 0
!Stack = $01FF
!DMAChannel = 0
!DMAEnabler #= 2**!DMAChannel
!DMAInitialMaxDataPerFrame = $1000
!VRAMQueueSize = $40
!CGRAMQueueSize = $40

!MainRAMBank = $7E0000
!OAMBuffer = !MainRAMBank+$200
!OAMTileX = !OAMBuffer+0
!OAMTileY = !OAMBuffer+1
!OAMTileNumber = !OAMBuffer+2
!OAMTileProp = !OAMBuffer+3

!SampleStreamingAcknowledge = $69
!SampleStreamingDataBlockCount = 9
!SampleStreamingDataPerLoopSize #= !SampleStreamingDataBlockCount*4
