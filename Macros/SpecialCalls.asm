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
