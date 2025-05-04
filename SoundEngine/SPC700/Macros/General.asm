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

macro WriteDSPx(address, value)
    MOV x, <address>
    MOV !RegDSPAddress, x

    MOV x, <value>
    MOV !RegDSPValue, x
endmacro

macro WriteDSPy(address, value)
    MOV y, <address>
    MOV !RegDSPAddress, y

    MOV y, <value>
    MOV !RegDSPValue, y
endmacro

macro KeyOnVoices()
    %WriteConstantAddressA($5C)
endmacro

macro KeyOffVoices()
    %WriteConstantAddressA($5C)
endmacro
