Rest_Extended:
    MOV !CurrentBitChecker, Bitchecker+y
    OR A, SPC700Mirrors.KeyOff
    MOV SPC700Mirrors.KeyOff, A
    
    %ExtendedDuration()
RET
