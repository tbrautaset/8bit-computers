FIRE_OR_UP:
        XOR     A
        OUT     (00h),A
        IN      A,(00h)
        CP      0FFh
        JR      NZ,.YES
        LD      B,07h
.SKIP:
        IN      A,(00h)
        DJNZ    .SKIP
        IN      A,(00h)
        BIT     4,A
        JR      Z,.YES
        XOR     A
        RET
.YES:
        LD      A,01h
        RET
