namespace nested on

incsrc "PPURegisters.asm"
incsrc "NESJoypadRegisters.asm"
incsrc "HardwareRegisters.asm"
incsrc "DMARegisters.asm"

incsrc "DirectPage.asm"

org !VariablesAfterStack

incsrc "OAMBuffer.asm"
incsrc "VRAMQueue.asm"
incsrc "CGRAMQueue.asm"
incsrc "Scrolling.asm"
incsrc "NMI.asm"
incsrc "Levels.asm"
incsrc "Gamemode.asm"
incsrc "EntityLinkedList.asm"

org !MainRAMBank+$010000

incsrc "Entities.asm"

namespace nested off
