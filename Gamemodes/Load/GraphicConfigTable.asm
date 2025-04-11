ConfigPerLevel:
;00 OC = OAM Config (Size and Address)
;01 Mo = Snes Mode
;02 Pi = Pixelation
;03 T1 = Tilemap Address Layer 1
;04 T2 = Tilemap Address Layer 2
;05 T3 = Tilemap Address Layer 3
;06 T4 = Tilemap Address Layer 4
;07 G12 = Graphics Address Layer 1 and 2
;08 G34 = Graphics Address Layer 3 and 4
;09 CMC = Color Math Config
;0A CAS = Color Addition Select
;0B MSD = Main Screen Designation
;0C SSD = Sub Screen Designation
;0D W12 = Window Settings Layer 1 and 2
;0E W34 = Window Settings Layer 3 and 4
;0F WOC = Window Settings Object And Color Window
;10 MWM = MainScreen Window Mask
;11 SWM = SubScreen Window Mask
;12 HS1 = Horizontal Scroll Layer 1
;14 VS1 = Vertical Scroll Layer 1
;16 HS2 = Horizontal Scroll Layer 2
;18 VS2 = Vertical Scroll Layer 2
;1A HS3 = Horizontal Scroll Layer 3
;1C VS3 = Vertical Scroll Layer 3
;1E HS4 = Horizontal Scroll Layer 4
;20 VS4 = Vertical Scroll Layer 4
;22 FC = Fixed Color
.Level0
;      OC  Mo  Pi  T1  T2  T3  T4  G12 G34 CMC CAS MSD SSD W12 W34 WOC MWM SWM
    db $07,$09,$00,$C9,$D1,$D9,$00,$11,$00,$20,$22,$15,$02,$00,$00,$00,$15,$02
;      HS1   VS1   HS2   VS2   HS3   VS3   HS4   VS4   FC
    dw $0000,$FFC0,$0000,$FFC0,$0000,$0000,$0000,$0000,$7393
