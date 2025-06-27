Draw:
    PHB
    PHK
    PLB

    PHA
    STA DirectPage.Scratch+$09
    ASL
    CLC
    ADC DirectPage.Scratch+$09
    TAY

    LDA.w PoseGraphicRoutine,y
    STA DirectPage.Scratch+$0B
    LDA.w PoseGraphicRoutine+1,y
    STA DirectPage.Scratch+$0C

    PLY
    LDA.w PoseLength,y
    AND #$00FF
    STA DirectPage.Scratch+$09

    TYA
    ASL
    TAY

    LDA.w PoseOffset,y
    STA DirectPage.Scratch+$07
    CLC
    ADC DirectPage.Scratch+$09
    TAY
    SEP #$20

	PHK
	PEA.w .Return-1
    JML [DirectPage.Scratch+$0B]
.Return

    PLB
RTL

incsrc "PoseTables.asm"
