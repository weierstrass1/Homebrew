incsrc "SetupScrollNextFrame.asm"

HandleScrolling:
    PHP
    REP #$31
    ;Test input code
    STZ.W Scroll.WorldXVel
    STZ.W Scroll.WorldYVel

    ;Left check
    LDA.B DirectPage.Controller1
    BIT.W #!C_DL
    BEQ .SkipL
    LDA.W #!ScrollDirSpeed
    STA.W Scroll.WorldXVel
    .SkipL:
    
    ;Right check
    LDA.B DirectPage.Controller1
    BIT.W #!C_DR
    BEQ .SkipR
    LDA.W #~!ScrollDirSpeed
    STA.W Scroll.WorldXVel
    .SkipR:
    
    ;Up check
    LDA.B DirectPage.Controller1
    BIT.W #!C_DU
    BEQ .SkipU
    LDA.W #!ScrollDirSpeed
    STA.W Scroll.WorldYVel
    .SkipU:
    
    ;Down check
    LDA.B DirectPage.Controller1
    BIT.W #!C_DD
    BEQ .SkipD
    LDA.W #~!ScrollDirSpeed
    STA.W Scroll.WorldYVel
    .SkipD:
    
    ;Check world X movement    
    LDA.W Scroll.WorldXVel  ;Check if xvel is negative
    BMI .NegativeCheck
    ;If not then do positive check
    LDA.W Scroll.WorldPosX
    CLC
    ADC.W Scroll.WorldXVel
    BCC .ApplyXPos
    ;Add carry to WorldPosX hi byte
    SEP #$20
    INC.W Scroll.WorldPosX+2
    REP #$20
    BRA .ApplyXPos
    .NegativeCheck:
    ;Else do negative check
    LDA.W Scroll.WorldPosX
    CLC
    ADC.W Scroll.WorldXVel
    BCS .ApplyXPos
    ;Sub carry to WorldPosX hi byte
    SEP #$20
    DEC.W Scroll.WorldPosX+2
    REP #$20
    .ApplyXPos:
    STA.W Scroll.WorldPosX

    ;Check world Y movement
    REP #$31
    LDA.W Scroll.WorldYVel  ;Check if xvel is negative
    BMI .NegativeCheckY
    ;If not then do positive check
    LDA.W Scroll.WorldPosY
    CLC
    ADC.W Scroll.WorldYVel
    BCC .ApplyYPos
    ;Add carry to WorldPosX hi byte
    SEP #$20
    INC.W Scroll.WorldPosY+2
    REP #$20
    BRA .ApplyYPos
    .NegativeCheckY:
    ;Else do negative check
    LDA.W Scroll.WorldPosY
    CLC
    ADC.W Scroll.WorldYVel
    BCS .ApplyYPos
    ;Sub carry to WorldPosX hi byte
    SEP #$20
    DEC.W Scroll.WorldPosY+2
    REP #$20
    .ApplyYPos:
    STA.W Scroll.WorldPosY

    LDA.w Scroll.WorldPosX+1
    STA.w Scroll.HScrollLayer1NextFrame
    LDA.w Scroll.WorldPosY+1
    STA.w Scroll.VScrollLayer1NextFrame

    PLP
    RTS