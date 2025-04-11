GamemodeCall:
    LDA.w Gamemode_Index
    REP #$20
    AND #$00FF
    %MulX3(DirectPage.Scratch)
    STA.b DirectPage.GamemodeIndexer

    LDA.w Levels_Index
    AND #$00FF
    %MulX3(DirectPage.Scratch)
    STA.b DirectPage.LevelIndexer
    SEP #$30

    LDA.w Gamemode_Index
    CMP.w Gamemode_LastIndex
    BEQ .Loop
.Init

    %JSLRoutineTable(".w .Gamemodes_Init", ".b DirectPage.GamemodeIndexer", $00)

    LDA.w Gamemode_Index
    STA.w Gamemode_LastIndex
.Loop
    %JSLRoutineTable(".w .Gamemodes_Loop", ".b DirectPage.GamemodeIndexer", $00)
RTS

.Gamemodes
..Init
    dl Load_Init
..Loop
    dl Load_Main

namespace Load
incsrc "Load/Main.asm"
namespace off