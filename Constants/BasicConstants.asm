!sa1 = 0
!Fastrom = 1
!Stack = $01FF

!MainRAMBank = $7E0000
!VariablesAfterStack = !MainRAMBank+$200

if !Fastrom == 1
!FastromBNK = $800000
else
!FastromBNK = $000000
endif

if !sa1
    !MultiplicationResult = $2306
    !DivisionResult = $2306
    !RemainderResult = $2308
else
    !MultiplicationResult = $4216
    !DivisionResult = $4214
    !RemainderResult = $4216
endif
