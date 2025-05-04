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
    MOV $0000+y, A
    MOV $F7, #$00

    MOV A, $F5
    !i #= !i+1
..p{!i}
    MOV $0000+y, A

    MOV A, $F6
    !i #= !i+1
..p{!i}
    MOV $0000+y, A

    MOV A, $F7
    !i #= !i+1
..p{!i}
    MOV $0000+y, A
    !i #= !i+1

    MOV $F7, #!SampleStreamingAcknowledge
endmacro
