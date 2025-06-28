GetAnimationSpeed:
    STA DirectPage.Scratch

    LDA Entity.XSpeed+1,x
    BNE +
    LDA #$FF
RTL
+
    BPL +
    EOR #$FF
    INC A
+
    STA DirectPage.Scratch+2
    STZ DirectPage.Scratch+1

    %DivW(".b DirectPage.Scratch+1", ".b DirectPage.Scratch", ".b DirectPage.Scratch+2")
    LDA !DivisionResult
RTL
