GamemodeCall:
    LDA.w Gamemode_Index
    CMP.w Gamemode_LastIndex
    BEQ .Loop
.Init
    %JSRRoutineTable(0, .Gamemodes_Init)

    LDA.w Gamemode_Index
    STA.w Gamemode_LastIndex
.Loop
    %JMPRoutineTable(0, .Gamemodes_Loop)

.Gamemodes
..Init
    dw Load_Init
    dw MainGameMode_Init
    dw MainGameMode_Init
    dw MainGameMode_Init
..Loop
    dw Load_Main
    dw MainGameMode_Main
    dw MainGameMode_Main
    dw MainGameMode_Main

namespace Load
incsrc "Load/Main.asm"
namespace off

namespace MainGameMode
incsrc "MainGameMode/Main.asm"
namespace off