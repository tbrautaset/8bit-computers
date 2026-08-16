; Exact runtime 8000h-805Ah
; Original XOR/address/register semantics, but IRQ blackout is one row only.

SPRITE_XOR_BLITTER:
        SRL D
        RR E
        PUSH DE
        POP IX
        LD D,00h
        LD E,80h

VIDEO_LOOP_8010:
        DI
        LD A,0ACh
        OUT (1Ch),A

        LD A,(HL)
        XOR (IX+0)
        LD (IX+0),A
        INC HL
        LD A,(HL)
        XOR (IX+1)
        LD (IX+1),A
        INC HL
        LD A,(HL)
        XOR (IX+2)
        LD (IX+2),A
        INC HL
        LD A,(HL)
        XOR (IX+3)
        LD (IX+3),A
        INC HL
        LD A,(HL)
        XOR (IX+4)
        LD (IX+4),A
        INC HL
        LD A,(HL)
        XOR (IX+5)
        LD (IX+5),A
        INC HL
        LD A,(HL)
        XOR (IX+6)
        LD (IX+6),A
        INC HL
        LD A,(HL)
        XOR (IX+7)
        LD (IX+7),A
        INC HL

        ADD IX,DE

        LD A,0A4h
        OUT (1Ch),A
        EI

        DEC C
        JR NZ,VIDEO_LOOP_8010
        RET

        ASSERT  $ = 0805Bh
