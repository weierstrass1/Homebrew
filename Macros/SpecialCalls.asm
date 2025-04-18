macro JSLRoutineTable(table, indexer, scratch)
?JSLRoutineTable:
    REP #$30
    LDX<indexer>

    LDA<table>,x
    STA.b <scratch>
    LDA<table>+1,x
    STA.b <scratch>+1
    SEP #$30

    PHB
    LDA.b <scratch>+2
    PHA
    PLB

	PHK
	PEA.w ?.Return-1
    JML [<scratch>]
?.Return
    PLB
endmacro

macro JSRRoutineTable(sep20, table)
    ASL
    TAX
    if <sep20> == 1
    SEP #$20
    endif

    JSR.w (<table>,x)
endmacro

macro JMPRoutineTable(sep20, table)
    ASL
    TAX
    if <sep20> == 1
    SEP #$20
    endif

    JMP.w (<table>,x)
endmacro