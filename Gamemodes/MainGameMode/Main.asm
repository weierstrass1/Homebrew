Init:
    STZ.b DirectPage.Scratch
    STZ.b DirectPage.Scratch+1
    JSL AddLastEntity
RTS

Main:
    JSR EntityLoop
RTS
