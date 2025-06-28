!CurrentBank #= !CurrentBank+$010000
org !CurrentBank
Graphics:
.8:
    incbin "Graphics/OniririTest1.bin"
    ..End
.9:
    incbin "Graphics/OniririTest2.bin"
    ..End
.10:
    incbin "Graphics/bgtest0.bin"
    ..End
.11:
    incbin "Graphics/bgtest1.bin"
    ..End
.12:
    incbin "Graphics/bgtest2.bin"
        ..End
.13:
    incbin "Graphics/bgtest3.bin"
    ..End
!CurrentBank #= !CurrentBank+$010000
org !CurrentBank
Palettes:
.0
    incbin "Palettes/TestPal.bin"
    ..End
!CurrentBank #= !CurrentBank+$010000
org !CurrentBank
Tilemaps:
.0:
    incbin "Tilemaps/TestL1.bin"
    ..End
.1:
    incbin "Tilemaps/TestL2.bin"
    ..End
.2:
    incbin "Tilemaps/TestL3.bin"
    ..End
.3:
    incbin "Tilemaps/bgtestTilemap.bin"
    ..End

