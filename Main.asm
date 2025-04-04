incsrc "Constants.asm"
incsrc "Variables.asm"

incsrc "Setup/Header.asm"
incsrc "Setup/CPUVector.asm"

org $808000
StartGame:
ResetHandlerEmu:
    SEI                       ; Disable IRQ
    STZ $4200                 ; Disable IRQ, NMI and joypad reading
    STZ $420C                 ; Disable HDMA
    STZ $420B                 ; Disable DMA
    STZ $2140                 ;\ Clear APU I/O ports (1-4) (End music)
    STZ $2141                 ;|
    STZ $2142                 ;|
    STZ $2143                 ;/

    LDA #$80                  ;\ Activate force blank (lowest brightness)
    STA $2100                 ;/

    CLC                       ;\ Disable 6502 emulation mode
    XCE                       ;/

    REP #$38                  ; Disable decimal mode; widen A, X and Y to 16-bit
    LDA #$0000                ;\ Set the Direct Page $000000-FF
    STA.b DirectPage.TilemapAddressLayer1Mirror
    STA.b DirectPage.TilemapAddressLayer3Mirror
    STA.b DirectPage.GraphicsAddressLayer12Mirror
    STA.b DirectPage.HScrollLayer1Mirror
    STA.b DirectPage.VScrollLayer1Mirror
    STA.b DirectPage.HScrollLayer2Mirror
    STA.b DirectPage.VScrollLayer2Mirror
    STA.b DirectPage.HScrollLayer3Mirror
    STA.b DirectPage.VScrollLayer3Mirror
    STA.b DirectPage.HScrollLayer4Mirror
    STA.b DirectPage.VScrollLayer4Mirror
    TCD                       ;/             (mirror of $7E0000-FF)
    LDA #!Stack               ;\ Set the Stack Pointer
    TCS                       ;/
    SEP #$20

    STZ.w CGRAMQueue.Length
    STZ.w VRAMQueue.Length

    LDA #$01
    STA.b DirectPage.ChangeLayerConfigFlag
    STA.b DirectPage.InterruptRunning
    STA.b DirectPage.ModeMirror

    LDA #$81
    STA $4200
-
    LDA.b DirectPage.InterruptRunning
    BEQ -
    CLI
    STZ.b DirectPage.InterruptRunning
    BRA -

incsrc "COPBRKAbort/COPBRKAbort.asm"
incsrc "IRQ/IRQ.asm"
incsrc "NMI/NMI.asm"
