EntityLoop:
    LDA.w Entities_Length
    BNE +
RTS
+
    PHB
    PHK
    PLB
    LDY.w Entities_FirstSlot
.Loop
    PHY
    REP #$10

    TYA
    XBA
    LDA #$00
    TAX
    STX.w Entities_CurrentSpriteSlot

    LDA.l Entity.ID+1,x
    XBA
    LDA.l Entity.ID,x
    REP #$20
    %MulX3(DirectPage.Scratch)
    TAY

    LDA.w .EntitiesScript,y
    STA.b DirectPage.Scratch
    SEP #$20
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

    SEP #$10
    PLX
    LDY.w Entities_NextSlot,x
    BPL .Loop
    PLB
RTS

.EntitiesScript
    dl Entity_TestEntity_Main

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
EntityInit:
    PHB
    PHK
    PLB

    LDA.b DirectPage.Scratch+1
    STA.l Entity.ID+1,x
    XBA
    LDA.b DirectPage.Scratch
    STA.l Entity.ID,x
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

    PHA
    PLA

	PHK
	PEA.w .SpriteRet-1
    JML.w [DirectPage.Scratch]
.SpriteRet

    PLB
RTL

.EntitiesInitScript
    dl Entity_TestEntity_Init

;s0-s1: Entity ID
;A,X,Y start at 8 bits
AddWhenIsEmpty:
    LDA #(!EntitiesMaxSize/2)
    STA.w Entities_FirstSlot
    STA.w Entities_LastSlot

    LDA #$FF
    STA.w Entities_NextSlot+(!EntitiesMaxSize/2)
    STA.w Entities_PreviousSlot+(!EntitiesMaxSize/2)

    INC.w Entities_Length

    REP #$10
    LDX.w #(!EntitiesMaxSize/2)<<8
    JSL EntityInit
    SEC
RTS

FindListSlot:
    BPL +
    LDA #$00
    BRA .StartFind
+
    CMP #!EntitiesMaxSize
    BCC .StartFind
    LDA #!EntitiesMaxSize-1
.StartFind
    XBA
    LDA #$00
    REP #$30
    TAX
    SEP #$20
    LDA.l Entity.ID+1,x
    BPL +
    LDA #$00
    XBA
    TAY
RTS
+
    LDA.b DirectPage.Scratch
    AND #!EntitiesMaxSize-1
    XBA
    LDA #$00
    TAX
.Loop
    LDA.l Entity.ID+1,x
    BPL +
    LDA #$00
    XBA
    TAY
RTS
+
    LDA #$00
    XBA
    CLC
    ADC #$0F
    AND #!EntitiesMaxSize-1
    XBA
    TAX
    BRA .Loop

;s0-s1: Entity ID
;A,X,Y start at 8 bits
AddFirstEntity:
    LDA.w Entities_Length
    BNE +
    JSR AddWhenIsEmpty
    SEP #$31
RTL
+
    CMP #$80
    BCC +
    CLC
RTL
+
.Start
    LDA.w Entities_FirstSlot
    DEC A
    JSR FindListSlot

    LDA.w Entities_FirstSlot
    STA.b DirectPage.Scratch+2
    STA.w Entities_NextSlot,y

    LDA #$FF
    STA.w Entities_PreviousSlot,y
    TYA
    STA.w Entities_FirstSlot

    LDA.b DirectPage.Scratch+2
    TAY
    LDA.w Entities_FirstSlot
    STA.w Entities_PreviousSlot,y

    INC.w Entities_Length

    JSL EntityInit
    SEP #$31
RTL

;s0-s1: Entity ID
;A,X,Y start at 8 bits
AddLastEntity:
    LDA.w Entities_Length
    BNE +
    JSR AddWhenIsEmpty
    SEP #$31
RTL
+
    CMP #$80
    BCC +
    CLC
RTL
+
.Start
    LDA.w Entities_LastSlot
    INC A
    JSR FindListSlot

    LDA.w Entities_LastSlot
    STA.b DirectPage.Scratch+2
    STA.w Entities_PreviousSlot,y

    LDA #$FF
    STA.w Entities_NextSlot,y
    TYA
    STA.w Entities_LastSlot

    LDA.b DirectPage.Scratch+2
    TAY
    LDA.w Entities_LastSlot
    STA.w Entities_NextSlot,y

    INC.w Entities_Length

    JSL EntityInit
    SEP #$31
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;Entities_CurrentSpriteSlot: Base Slot (16 bits) 
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
    LDA.w Entities_CurrentSpriteSlot
    DEC A
    JSR FindListSlot

    STY.b DirectPage.Scratch+2
    
    ;New.Next = Current
    LDA.w Entities_CurrentSpriteSlot+1
    STA.w Entities_NextSlot,y
    TAY

    PHY

    ;Current.Previous.Next = New
    LDA.w Entities_PreviousSlot,y
    TAY
    LDA.b DirectPage.Scratch+2
    STA.w Entities_NextSlot,y
    STY.b DirectPage.Scratch+3

    PLY

    ;New.Previous = Current.Previous
    LDA.b DirectPage.Scratch+2
    STA.w Entities_PreviousSlot,y
    TAY

    ;Current.Previous = New
    LDA.b DirectPage.Scratch+3
    STA.w Entities_PreviousSlot,y

    INC.w Entities_Length

    JSL EntityInit
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
    LDA.w Entities_CurrentSpriteSlot
    INC A
    JSR FindListSlot

    STY.b DirectPage.Scratch+2
    
    ;New.Previous = Current
    LDA.w Entities_CurrentSpriteSlot+1
    STA.w Entities_PreviousSlot,y
    TAY

    PHY

    ;Current.Next.Previous = New
    LDA.w Entities_NextSlot,y
    TAY
    LDA.b DirectPage.Scratch+2
    STA.w Entities_PreviousSlot,y
    STY.b DirectPage.Scratch+3

    PLY

    ;New.Next = Current.Next
    LDA.b DirectPage.Scratch+2
    STA.w Entities_NextSlot,y
    TAY

    ;Current.Next = New
    LDA.b DirectPage.Scratch+3
    STA.w Entities_NextSlot,y

    INC.w Entities_Length

    JSL EntityInit
    SEC
RTL

;A,X,Y start at 8 bits
RemoveFirstEntity:
    LDA.w Entities_Length
    BNE +
    CLC
RTL
+
    LDY.w Entities_FirstSlot
    TYA

    REP #$30
    AND #$00FF
    XBA
    TAX

    LDA.w Entities_Length
    LDA #$FFFF
    STA.l Entity.ID,x
    SEP #$30

    CMP #$01
    BNE +

    STZ.w Entities_Length
    SEC
RTL
+
.Start
    
    LDA.w Entities_NextSlot,y
    STA.w Entities_FirstSlot
    TAY

    LDA #$FF
    STA.w Entities_PreviousSlot,y

    DEC.w Entities_Length
    SEC
RTL

;A,X,Y start at 8 bits
RemoveLastEntity:
    LDA.w Entities_Length
    BNE +
    CLC
RTL
+
    LDY.w Entities_LastSlot
    TYA

    REP #$30
    AND #$00FF
    XBA
    TAX

    LDA.w Entities_Length
    CMP #$01
    BNE +

    STZ.w Entities_Length
    SEC
RTL
+
.Start
    
    LDA.w Entities_PreviousSlot,y
    STA.w Entities_LastSlot
    TAY

    LDA #$FF
    STA.w Entities_NextSlot,y

    DEC.w Entities_Length
    SEC
RTL

;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
RemoveAt:
    LDA.l Entity.ID+1,x
    BPL +
    CLC
RTL
+
    LDA.w Entities_Length
    BNE +
    CLC
RTL
+
    REP #$20
    TXA
    XBA
    AND #$00FF
    TAY
    SEP #$20

    LDA.w Entities_Length
    CMP #$01
    BNE +

    STZ.w Entities_Length
    SEC
RTL
+

    CMP.w Entities_FirstSlot
    BNE +
    JSL RemoveFirstEntity_Start
    REP #$10
RTL
+
    CMP.w Entities_LastSlot
    BNE +
    JSL RemoveLastEntity_Start
    REP #$10
RTL
+

    REP #$20
    LDA #$FFFF
    STA.l Entity.ID,x
    SEP #$20

    LDA.w Entities_PreviousSlot,y
    PHA

    LDA.w Entities_NextSlot,y
    STA.b DirectPage.Scratch
    TAY

    PLA
    STA.w Entities_PreviousSlot,y
    TAY

    LDA.b DirectPage.Scratch
    STA.w Entities_NextSlot,y

    DEC.w Entities_Length
    SEC
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
;A start at 8 bits
;X,Y start at 16 bits
ReplaceEntity:
    LDA.l Entity.ID+1,x
    BPL +
    CLC
RTL
+
    JSL EntityInit
RTL

ClearEntities:
    PHB
    LDA.b #Entity>>16
    PHA
    PLB
    REP #$20
    LDA #$FFFF
!i = 0
while !i < !EntitiesMaxSize
    STA.w Entity.ID+(!i*256)
    !i #= !i+1
endwhile
    SEP #$20
    PLB
RTS
