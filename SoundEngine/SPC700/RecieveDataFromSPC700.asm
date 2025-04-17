RecieveDataFromSPC700:

!i = 1
while !i < !SampleStreamingDataPerLoopSize
    %PrepareTransferCode(..p{!i}, 1)
    !i #= !i+1
endwhile
    %PrepareTransferCode(..p{!i}, 0)

    MOV Y, #$00
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

    MOV A, Y
    CLRC
    ADC A, #!SampleStreamingDataPerLoopSize
    MOV Y, A
    CMP A, !Size
    BCC .Loop

RET
