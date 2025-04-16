;s0-s1: Entity ID
AddFirstEntity:
RTL

;s0-s1: Entity ID
AddLastEntity:
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
AddNextEntity:
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
AddPreviousEntity:
RTL

RemoveFirstEntity:
RTL

RemoveLastEntity:
RTL

;X: Base Slot (16 bits)
RemoveAt:
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
ReplaceFirstEntity:
RTL

;s0-s1: Entity ID
;X: Base Slot (16 bits)
ReplaceLastEntity:
RTL

;X: Base Slot (16 bits)
ReplaceEntity:
RTL

;X: Base Slot (16 bits)
EntityInit:
    LDA.w Entity.ID+1,x
    XBA
    LDA.w Entity.ID,x
    TAY

    LDA.w EntitiesCode,y
    STA.b DirectPage.Scratch
    LDA.w EntitiesCode+1,y
    STA.b DirectPage.Scratch+1
    LDA.w EntitiesCode+2,y
    STA.b DirectPage.Scratch+2

    PHB
    PHA
    PLB

	PHK
	PEA.w ..SpriteRet-1
    JML.w [DirectPage.Scratch]
..SpriteRet

    PLB
RTL