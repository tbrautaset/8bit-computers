APPLY_RIGHT_AND_ARROWS:
        PUSH    DE
        LD      C,A
        LD      D,00h
        LD      A,B
        CP      E
        JR      Z,.NO_OLD_LEFT
        SET     0,D
.NO_OLD_LEFT:
        LD      A,C
        CP      0FFh
        JR      Z,.NO_OLD_RIGHT
        SET     1,D
.NO_OLD_RIGHT:
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)
        BIT     3,A
        JR      NZ,.NO_LEFT
        SET     0,D
.NO_LEFT:
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)
        BIT     1,A
        JR      NZ,.APPLY
        SET     1,D
.APPLY:
        LD      B,E
        BIT     0,D
        JR      Z,.RIGHT
        BIT     1,D
        JR      NZ,.DONE
        DEC     B
        JR      .DONE
.RIGHT:
        BIT     1,D
        JR      Z,.DONE
        INC     B
.DONE:
        POP     DE
        RET
