;asar.exe spcfile.asm spcfile.spc
norom
org $00000 : incbin "spcbase.bin"
org $00100 ;0x100 - SPC data/driver
base $0000 : incsrc "../SPC700/Driver.asm"
org $10100 : incbin "dspbase.bin"