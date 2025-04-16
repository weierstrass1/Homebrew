EntityLoop:
    LDA.w Entities_Length
    BNE +
RTS
+
    LDY.w Entities_FirstSlot
.Loop
    PHY
    REP #$10

    TYA
    XBA
    LDA #$00
    TAX
    STX.w Entities_CurrentSpriteSlot

    LDA.w Entity.ID+1,x
    XBA
    LDA.w Entity.ID,x
    REP #$20
    %MulX3(DirectPage.Scratch)
    TAY

    LDA.w .EntitiesScript,y
    STA.b DirectPage.Scratch
    LDA.w .EntitiesScript+1,y
    STA.b DirectPage.Scratch+1
    LDA.w .EntitiesScript+2,y
    STA.b DirectPage.Scratch+2

    PHB
    PHA
    PLB

	PHK
	PEA.w ..SpriteRet-1
    JML.w [DirectPage.Scratch]
..SpriteRet

    PLB

    PLX
    SEP #$10
    LDY.w Entities_NextSlot,x
    BPL .Loop
RTS

.EntitiesScript
    dl $FFFFFF

;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
EntityInit:
    PHB
    PHK

    LDA.w Entity.ID+1,x
    XBA
    LDA.w Entity.ID,x
    REP #$20
    %MulX3(DirectPage.Scratch)
    TAY

    SEP #$20
    LDA.w .EntitiesInitScript,y
    STA.b DirectPage.Scratch
    LDA.w .EntitiesInitScript+1,y
    STA.b DirectPage.Scratch+1
    LDA.w .EntitiesInitScript+2,y
    STA.b DirectPage.Scratch+2

    PHB
    PHA

	PHK
	PEA.w ..SpriteRet-1
    JML.w [DirectPage.Scratch]
..SpriteRet

    PLB
RTL

.EntitiesInitScript
    dl $FFFFFF

;s0-s1: Entity ID
;A,X,Y start at 8 bits
AddWhenIsEmpty:
    LDA #$40
    STA.w Entities_FirstSlot
    STA.w Entities_LastSlot
    STA.w Entities_CurrentSpriteSlot

    LDA #$FF
    STA.w Entities_PreviousSlot+$40
    STA.w Entities_PreviousSlot+$40

    INC.w Entities_Length

    LDA.b DirectPage.Scratch
    STA.w Entity[$40].ID
    LDA.b DirectPage.Scratch+1
    STA.w Entity[$40].ID+1

    STZ.w Entities_CurrentSpriteSlot

    REP #$10
    LDX.b DirectPage.Scratch
    JML EntityInit
    REP #$10
    LDX #$4000
    SEC
RTS

FindPreviousSlot:
RTS

FindNextSlot:
RTS

;s0-s1: Entity ID
;A,X,Y start at 8 bits
AddFirstEntity:
    LDA.w Entities_Length
    BNE +
    JSR AddWhenIsEmpty
RTL
+
    CMP #$80
    BCC +
    CLC
RTL
+
.Start
    LDA.w Entities_FirstSlot
    JSR FindPreviousSlot
    TAY

    LDA.w Entities_PreviousSlot,y

    SEC
RTL

;s0-s1: Entity ID
;A,X,Y start at 8 bits
AddLastEntity:
    LDA.w Entities_Length
    BNE +
    JSR AddWhenIsEmpty
RTL
+
    CMP #$80
    BCC +
    CLC
RTL
+
.Start
    LDA.w Entities_LastSlot
    JSR FindNextSlot
    TAY


    SEC
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
AddPreviousEntity:
    LDA.w Entities_Length
    BNE +
    PHX
    SEP #$10
    JSR AddWhenIsEmpty
    REP #$11
    PLX
    STX.w Entities_CurrentSpriteSlot
RTL
+
    CMP #$80
    BCC +
    CLC
RTL
+
    REP #$20
    TXA
    XBA
    TAY
    SEP #$20

    LDA.w Entities_PreviousSlot,y
    BPL +
    SEP #$10
    JSL AddFirstEntity_Start
    REP #$11
    LDX.w Entities_CurrentSpriteSlot
RTL
+
    LDA.w Entities_PreviousSlot,y
    BPL +
    SEP #$10
    JSL AddLastEntity_Start
    REP #$11
    LDX.w Entities_CurrentSpriteSlot
RTL
+
    SEC
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
AddNextEntity:
    LDA.w Entities_Length
    BNE +
    PHX
    SEP #$10
    JSR AddWhenIsEmpty
    REP #$11
    PLX
    STX.w Entities_CurrentSpriteSlot
RTL
+
    CMP #$80
    BCC +
    CLC
RTL
+
    REP #$20
    TXA
    XBA
    TAY
    SEP #$20

    LDA.w Entities_PreviousSlot,y
    BPL +
    SEP #$10
    JSL AddFirstEntity_Start
    REP #$11
    LDX.w Entities_CurrentSpriteSlot
RTL
+
    LDA.w Entities_PreviousSlot,y
    BPL +
    SEP #$10
    JSL AddLastEntity_Start
    REP #$11
    LDX.w Entities_CurrentSpriteSlot
RTL
+
    SEC
RTL

;A,X,Y start at 8 bits
RemoveFirstEntity:
    LDA.w Entities_Length
    BNE +
    CLC
RTL
+
    CMP #$01
    BNE +

    STZ.w Entities_Length
    SEC
RTL
+
    SEC
RTL

;A,X,Y start at 8 bits
RemoveLastEntity:
    LDA.w Entities_Length
    BNE +
    CLC
RTL
+
    CMP #$01
    BNE +

    STZ.w Entities_Length
    SEC
RTL
+
    SEC
RTL

;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
RemoveAt:
    LDA.w Entities_Length
    BNE +
    CLC
RTL
+
    CMP #$01
    BNE +

    STZ.w Entities_Length
    SEC
RTL
+
    SEC
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
ReplaceFirstEntity:
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
ReplaceLastEntity:
RTL

;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
ReplaceEntity:
RTL
