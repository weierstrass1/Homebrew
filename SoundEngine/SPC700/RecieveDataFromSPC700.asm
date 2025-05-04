RecieveDataFromSPC700:

!i = 1
while !i < !SampleStreamingDataPerLoopSize
    %PrepareTransferCode(..p{!i}, 1)
    !i #= !i+1
endwhile
    %PrepareTransferCode(..p{!i}, 0)

    MOV y, #$00
    MOV $F7, #!SampleStreamingAcknowledge

    MOV A, #!SampleStreamingAcknowledge
.Wait
    CMP A, $F7
    BNE .Wait
.Loop
!i = 1
while !i <= !SampleStreamingDataPerLoopSize
    %UploadCycle()
endwhile

    MOV A, y
    CLRC
    ADC A, #!SampleStreamingDataPerLoopSize
    MOV y, A
    CMP A, !Size
    BCC .Loop

RET
