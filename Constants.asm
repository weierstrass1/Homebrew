!sa1 = 0
!Stack = $01FF
!DMAChannel = 0
!DMARegOR #= !DMAChannel<<4 
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
