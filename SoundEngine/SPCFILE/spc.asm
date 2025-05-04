;asar.exe spc.asm file.spc
norom
org $0000 : incbin "spcbase.bin"
org $0100 : incsrc "../SPC700/Driver.asm"
org $10100 : incbin "dspbase.bin"
org $0025 : dw Main_InitialSetup