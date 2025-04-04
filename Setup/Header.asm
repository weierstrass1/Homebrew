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
