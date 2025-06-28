GraphicLoadPointersTable:
    dw GraphicsPerLevel_Level0

GraphicsPerLevel:
.Level0
    dw $0000 : dl Graphics_10 : dw Graphics_10_End-Graphics_10
    dw $0800 : dl Graphics_11 : dw Graphics_11_End-Graphics_11
    dw $1000 : dl Graphics_12 : dw Graphics_12_End-Graphics_12
    dw $1800 : dl Graphics_13 : dw Graphics_13_End-Graphics_13
    dw $4800 : dl Tilemaps_3 : dw Tilemaps_3_End-Tilemaps_3
    dw $6000 : dl Graphics_8 : dw Graphics_8_End-Graphics_8
    dw $6800 : dl Graphics_9 : dw Graphics_8_End-Graphics_8
    dw $FFFF
