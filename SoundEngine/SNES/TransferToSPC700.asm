;s0-s2 : Resource Address
;s3 : blocks
TransferToSPC700:
    LDY #$01
    LDX #$04

    LDA !BNK
    STA $4304

    STZ $4306

    REP #$20

    LDA #$4004
    STA $4300

    LDA !Addr
    STA $4302
    SEP #$20

    LDA #!Acknowledge
    STA  $2143
.Loop
    LDA #!Acknowledge
..Wait
    CMP $2143
    BNE ..Wait

    STX $4305
    STY $420B

    DEC.b DirectPage.Scratch
    BNE .Loop

RTS
    