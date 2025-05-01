macro WriteDSPConstantAddress(address, value)
    MOV !RegDSPAddress, #<address>

    MOV A, <value>
    MOV !RegDSPValue, A
endmacro

macro WriteDSPConstantAddressA(address)
    MOV !RegDSPAddress, #<address>
    MOV !RegDSPValue, A
endmacro

macro WriteDSPConstantValue(address, value)
    MOV A, <address>
    MOV !RegDSPAddress, A

    MOV !RegDSPValue, #<value>
endmacro

macro WriteDSPConstantAddressValue(address, value)
    MOV !RegDSPAddress, #<address>
    MOV !RegDSPValue, #<value>
endmacro

macro WriteDSP(address, value)
    MOV A, <address>
    MOV !RegDSPAddress, A

    MOV A, <value>
    MOV !RegDSPValue, A
endmacro

macro WriteDSPX(address, value)
    MOV X, <address>
    MOV !RegDSPAddress, X

    MOV X, <value>
    MOV !RegDSPValue, X
endmacro

macro WriteDSPY(address, value)
    MOV Y, <address>
    MOV !RegDSPAddress, Y

    MOV Y, <value>
    MOV !RegDSPValue, Y
endmacro

macro KeyOnVoices()
    %WriteConstantAddressA($5C)
endmacro

macro KeyOffVoices()
    %WriteConstantAddressA($5C)
endmacro
