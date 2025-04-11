GraphicLoadPointersTable:
    dw GraphicsPerLevel_Level0

GraphicsPerLevel:
.Level0
    dw $0000 : dl Graphics_4 : dw Graphics_4_End-Graphics_4
    dw $0400 : dl Graphics_5 : dw Graphics_5_End-Graphics_5
    dw $0800 : dl Graphics_6 : dw Graphics_6_End-Graphics_6
    dw $0C00 : dl Graphics_7 : dw Graphics_7_End-Graphics_7
    dw $1000 : dl Graphics_0 : dw Graphics_0_End-Graphics_0
    dw $1800 : dl Graphics_1 : dw Graphics_1_End-Graphics_1
    dw $2000 : dl Graphics_2 : dw Graphics_2_End-Graphics_2
    dw $2800 : dl Graphics_3 : dw Graphics_3_End-Graphics_3
    dw $4800 : dl Tilemaps_0 : dw Tilemaps_0_End-Tilemaps_0
    dw $5000 : dl Tilemaps_1 : dw Tilemaps_1_End-Tilemaps_1
    dw $5800 : dl Tilemaps_2 : dw Tilemaps_2_End-Tilemaps_2
    dw $FFFF
