Rest_Default:
    MOV !CurrentBitChecker, Bitchecker+Y
    OR A, SPC700Mirrors.KeyOff
    MOV SPC700Mirrors.KeyOff, A
    
    %DefaultDuration()
RET
