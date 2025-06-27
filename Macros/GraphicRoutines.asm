;s0 = default x
;s2 = default y
;s4 = default tile/oam offset
;s5 = default prop/base prop
;s6 = size OR
;s7 = table offset first tile 
;X = oam slot
;Y = table offset

;s9 = temp x
;sB = temp y
;sD = x table
;sF = y table
;s11 = tmp tile
macro GraphicRoutine(onetile,dynamic,code,props,size,bigSize,x,y,xflip,yflip)
if <onetile> == 1
    REP #$21
    LDA DirectPage.Scratch+$02
    JSL Routines_YIsValid
    BCS +
RTL
+
    STA OAM_Buffer_Tile.Y,x

    STZ DirectPage.Scratch+$06
    REP #$21
    LDA DirectPage.Scratch+$00
    JSL Routines_XIsValid
    BCS +
RTL
+
    STA OAM_Buffer_Tile.X,x

if <dynamic> == 1
    LDA DirectPage.Scratch+$04
    JSL Routines_RemapOamTile
    STA OAM_Buffer_Tile.Property,x

    LDA DirectPage.Scratch+$11
else
    LDA DirectPage.Scratch+$05
    STA OAM_Buffer_Tile.Property,x

    LDA DirectPage.Scratch+$04
endif
    STA OAM_Buffer_Tile.Number,x

else
    PHB
    PHK
    PLB

if <y> == 1
    REP #$21
    LDA DirectPage.Scratch+$02
    JSL Routines_YIsValid
    BCS +
    PLB
RTL
+
endif

if <x> == 1
    STZ DirectPage.Scratch+$06
    REP #$21
    LDA DirectPage.Scratch+$00
    JSL Routines_XIsValid
    BCS +
    PLB
RTL
+
endif

if <xflip> == 1
    LDA DirectPage.Scratch+$05
    AND #$40
    REP #$20
    BNE +
    LDA #XDisplacements
    BRA ++
+
    LDA #XDisplacementsFlipped
++
    STA DirectPage.Scratch+$0D
    SEP #$20
endif

if <yflip> == 1
    LDA DirectPage.Scratch+$05
    AND #$80
    REP #$20
    BNE +
    LDA #YDisplacements
    BRA ++
+
    LDA #YDisplacementsFlipped
++
    STA DirectPage.Scratch+$0F
    SEP #$20
endif

.Loop

if <x> == 0 && <y> == 0
    STZ DirectPage.Scratch+$06

    STZ DirectPage.Scratch+$0A
    if <xflip> == 1
    LDA (DirectPage.Scratch+$0D),y
    else
    LDA XDisplacements,y
    endif
    STA DirectPage.Scratch+$09
    BPL +
    DEC DirectPage.Scratch+$0A
+

    STZ DirectPage.Scratch+$0C
    if <yflip> == 1
    LDA (DirectPage.Scratch+$0F),y
    else
    LDA YDisplacements,y
    endif
    STA DirectPage.Scratch+$0B
    BPL +
    DEC DirectPage.Scratch+$0C
+

    REP #$21
    LDA DirectPage.Scratch+$00
    ADC DirectPage.Scratch+$09
    STA DirectPage.Scratch+$09

    LDA DirectPage.Scratch+$02
    CLC
    ADC DirectPage.Scratch+$0B
    STA DirectPage.Scratch+$0B
    JSL Routines_PositionIsValid
    BCC .Next

    LDA DirectPage.Scratch+$09
    STA OAM_Buffer_Tile.X,x

    LDA DirectPage.Scratch+$0B
    STA OAM_Buffer_Tile.Y,x

elseif <y> == 0
    STZ DirectPage.Scratch+$0C
    if <yflip> == 1
    LDA (DirectPage.Scratch+$0F),y
    else
    LDA YDisplacements,y
    endif
    STA DirectPage.Scratch+$0B
    BPL +
    DEC DirectPage.Scratch+$0C
+
    REP #$21
    LDA DirectPage.Scratch+$02
    ADC DirectPage.Scratch+$0B
    STA DirectPage.Scratch+$0B
    JSL Routines_YIsValid
    BCC .Next

    LDA DirectPage.Scratch+$00
    STA OAM_Buffer_Tile.X,x

    LDA DirectPage.Scratch+$0B
    STA OAM_Buffer_Tile.Y,x
elseif <x> == 0
    STZ DirectPage.Scratch+$06

    STZ DirectPage.Scratch+$0A
    if <xflip> == 1
    LDA (DirectPage.Scratch+$0D),y
    else
    LDA XDisplacements,y
    endif
    STA DirectPage.Scratch+$09
    BPL +
    DEC DirectPage.Scratch+$0A
+

    REP #$21
    LDA DirectPage.Scratch+$00
    ADC DirectPage.Scratch+$09
    STA DirectPage.Scratch+$09
    JSL Routines_XIsValid
    BCC .Next

    LDA DirectPage.Scratch+$09
    STA OAM_Buffer_Tile.X,x

    LDA DirectPage.Scratch+$02
    STA OAM_Buffer_Tile.Y,x
else
    LDA DirectPage.Scratch+$00
    STA OAM_Buffer_Tile.X,x

    LDA DirectPage.Scratch+$02
    STA OAM_Buffer_Tile.Y,x
endif

if <dynamic> == 1
    if <code> == 1
    LDA DirectPage.Scratch+$04
    else
    LDA Tiles,y
    endif
    JSL Routines_RemapOamTile
    if <props> == 0
    EOR Properties,y
    endif
    STA OAM_Buffer_Tile.Property,x

    LDA DirectPage.Scratch+$11
else
    LDA DirectPage.Scratch+$05
    if <props> == 0
    EOR Properties,y
    endif
    STA OAM_Buffer_Tile.Property,x

    if <code> == 1
    LDA DirectPage.Scratch+$04
    else
    LDA Tiles,y
    endif
endif
    STA OAM_Buffer_Tile.Number,x

endif

    PHX
    TXA
    LSR
    LSR
    TAX

    INC.w OAM_SizeCurrentFrame

if <size> == 1   
if <bigSize> == 1
    LDA #$02
    ORA DirectPage.Scratch+6
else
    LDA DirectPage.Scratch+6
endif
else
    LDA Sizes,y
    ORA DirectPage.Scratch+6
endif
    STA OAM_Buffer_Sizes,x
    PLX

.Next
if <onetile> == 0
    CPY DirectPage.Scratch+$07
    BEQ +

    DEY

    INX
    INX
    INX
    INX
    CPX #$0200
    BCC .Loop
+
    PLB
endif
RTL
endmacro
