Rest_Extended:
    MOV A, Bitchecker+y
    MOV !CurrentBitChecker, A
    OR A, SPC700Mirrors.KeyOff
    MOV SPC700Mirrors.KeyOff, A
    
    %ExtendedDuration()
RET
