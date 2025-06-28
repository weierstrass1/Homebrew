!CurrentBank #= !CurrentBank+$010000
org !CurrentBank
namespace Routines
    incsrc "PPU.asm"
    incsrc "Drawing.asm"
    incsrc "Movement.asm"
    incsrc "Animation.asm"
namespace off
