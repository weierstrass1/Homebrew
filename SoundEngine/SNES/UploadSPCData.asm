;s0-s2: Source Data Address
;s3-s4: Destination Aram Address
;s5-s6: How many bytes were sent at the end of the routine.
UploadSPCData:
    REP #$30                        ;Make A 16-bit
    LDY #$0000                      ;
    LDA #$BBAA                      ;\ Wait until SPC700 is ready to recive data
.WaitSPC700    
    CMP $2140                       ;|
    BNE .WaitSPC700  
    SEP #$20                        ;Make A 8-bit
    LDA #$CC                        ;Load byte to start transfer routine
    PHA                             ;Push A
    REP #$20                        ;Make A 16-bit
    LDA.b [DirectPage.Scratch],Y    ;Load music data length
    STA.b DirectPage.Scratch+5
    INY                             ;\ Get ready to load the address
    INY                             ;/
    TAX                             ;Put the length in X
    LDA.b [DirectPage.Scratch],Y    ;Load the address
    INY                             ;\ Get ready to load the data
    INY                             ;/
Entry2:    
    STA $2142                       ;Store the address to APU I/O ports 2 and 3 (SPC700's)
    SEP #$20                        ;Make A (8 bit)
    CPX #$0001                      ;Compare the previous address to 1 (if 0000, the carry flag will not be set and therfore the code will end)
    LDA #$00                        ;\ Clear A
    ROL                             ;| Puts carry into A
    STA $2141                       ;/ End the block transfer
    ADC #$7F                        ;Set the overflow flag if carry flag is set (Length is over 0000)
    PLA                             ;\ Take out A
    STA $2140                       ;| Store it into APU I/O port 0. Wait until they are equal (SPC700 has caught up)
.WaitSPC700
    CMP $2140                       ;|
    BNE .WaitSPC700                 ;/
    BVS UploadData                  ;If the length was 0000, then finish the routine. Otherwise, upload the data.
RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadData:
    LDA.b [DirectPage.Scratch],Y    ;\ Load the byte of data
    INY                             ;| (Ensure that the address is shifted properly)
    XBA                             ;|
    LDA #$00                        ;| Load the counter (00)
    BRA StoreByte                   ;/
GetNextByte:
    XBA                             ;\ Load the byte of data
    LDA.b [DirectPage.Scratch],Y    ;/
    INY                             ;Shift the used location appropriately
    XBA                             ;Make sure the byte of data is put into APU I/O port 1
.WaitSPC700 
    CMP $2140                       ;\ Wait for HW_APUIO0 to equal the counter (SPC700 has caught up)
    BNE .WaitSPC700                 ;/
    INC A                           ;Increase the counter
StoreByte:
    REP #$20                        ;\Make A 16-bit to input the byte of data into APU I/O port 1 and the counter into APU I/O port 0
    STA.W HW_APUIO0                 ;|
    SEP #$20                        ;/Make A 8-bit
    DEX                             ;\ Repeat this until you have covered the whole block
    BNE GetNextByte                 ;/
.WaitSPC700  
    CMP $2140                       ;Then make sure that APU I/O port 0 is the same as X
    BNE .WaitSPC700                 ;
.WaitSPC700_2
    ADC.B #$03                      ;\ Increase the counter by 03 unless it would become 00, in which case, add another 03 to prevent the transfer from ending
    BEQ .WaitSPC700_2               ;/
Finished:
    REP #$20
    LDA.b DirectPage.Scratch+3
    STA $2142
    LDA.b DirectPage.Scratch+5
    INC
    AND #$00FF
    STA $2140
    SEP #$30
.WaitSPC700  
    CMP $2140
    BNE .WaitSPC700                 ;Return the processor's state back to normal
RTL
