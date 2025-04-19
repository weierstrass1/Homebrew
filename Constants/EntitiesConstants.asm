;0 = 1 entity
;1 = 2 entities
;2 = 4 entities
;3 = 8 entities
;4 = 16 entities
;5 = 32 entities
;6 = 64 entities
;7 = 128 entities
!EntitiesMaxSizeSQRT = 6
!EntitiesMaxSize #= 2**!EntitiesMaxSizeSQRT

if !EntitiesMaxSize > 128
    !EntitiesMaxSize = 128
endif
