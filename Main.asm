org $80FFB0
Header:
.Company
    db "HG"
.GameCode
    db "HEGA"
.FixedBytes1
    db $00,$00,$00,$00,$00,$00,$00
.RAMExpansion
    db $00
.SpecialVersion
    db $00
.CatridgeType_SubNumber
    db $00
.Title
    ;  "                     "
    db "Hetaumas Game        "
.MapMode ;Fast lorom
    db $30
.CatridgeType ;ROM-RAM-Battery
    db $02
.ROMSize ;4MB
    db $0C
.RAMSize ;128kb
    db $07
.DestinationCode ;USA
    db $01
.FixedValue2
    db $33
.Version ;V0.1
    db $01

org $80FFE0
CPUVector:
    dw $0000,$0000
.COPNative
    dw COPHandlerNative
.BRKNative
    dw BRKHandlerNative
.AbortNative
    dw AbortHandlerNative
.NMINative
    dw NMIHandlerNative
    dw $0000
.IRQNative
    dw IRQHandlerNative
    dw $0000,$0000
.COPEmu
    dw COPHandlerEmu
    dw $0000
.AbortEmu
    dw AbortHandlerEmu
.NMIEmu
    dw NMIHandlerEmu
.ResetEmu
    dw ResetHandlerEmu
.IRQEmu
    dw IRQHandlerEmu

incsrc "Constants.asm"
incsrc "Variables.asm"

org $808000
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

IRQHandlerEmu:
IRQHandlerNative:
    SEI ;Set Interrupt flag so routine can start
RTI

COPHandlerEmu:
COPHandlerNative:
BRKHandlerNative:
AbortHandlerNative:
AbortHandlerEmu:
    STP

incsrc "NMI/NMI.asm"
