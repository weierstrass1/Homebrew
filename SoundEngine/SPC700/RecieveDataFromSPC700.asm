!BlockSize = 8

macro PrepareTransferCode(p, inc)
    mov <p>+1, a
    mov <p>+2, y
    if <inc> == 1
        inc a : bne +
            inc y
        +
    endif
endmacro

macro UploadCycle()

    MOV A, $F4
..p{!i}
    MOV $0000+Y, A
    MOV $F7, #$00

    MOV A, $F5
    !i #= !i+1
..p{!i}
    MOV $0000+Y, A

    MOV A, $F6
    !i #= !i+1
..p{!i}
    MOV $0000+Y, A

    MOV A, $F7
    !i #= !i+1
..p{!i}
    MOV $0000+Y, A
    !i #= !i+1

    MOV $F7, #!Acknowledge
endmacro

!BlockSize #= !BlockSize*4

RecieveDataFromSPC700:

!i = 1
while !i < !BlockSize
    %PrepareTransferCode(..p{!i}, 1)
    !i #= !i+1
endwhile
    %PrepareTransferCode(..p{!i}, 0)

    MOV Y, #$00
    MOV $F7, #!Acknowledge

    MOV A, #!Acknowledge
.Wait
    CMP A, $F7
    BNE .Wait
.Loop
!i = 1
while !i <= !BlockSize
    %UploadCycle()
endwhile

    MOV A, Y
    CLRC
    ADC A, #!BlockSize
    MOV Y, A
    CMP A, !Size
    BCC .Loop

RET
