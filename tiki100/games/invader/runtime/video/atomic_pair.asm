; 8109h-817Fh: generic atomic 8-byte x 16-row XOR move.
; HL=old sprite, DE=new sprite, IY=old VRAM, IX=new VRAM.
; Each row is erase+draw atomically, then RAM is restored before EI.

ATOMIC_MOVE_8X16:
        LD      B,10h
.ROW:
        DI
        LD      A,0ACh
        OUT     (1Ch),A
        LD      C,08h
.BYTE:
        LD      A,(HL)
        XOR     (IY+0)
        LD      (IY+0),A
        LD      A,(DE)
        XOR     (IX+0)
        LD      (IX+0),A
        INC     HL
        INC     DE
        INC     IY
        INC     IX
        DEC     C
        JR      NZ,.BYTE

        LD      A,0A4h
        OUT     (1Ch),A
        EI

        PUSH    BC
        LD      BC,0078h
        ADD     IY,BC
        ADD     IX,BC
        POP     BC
        DJNZ    .ROW
        RET

; LEFT/RIGHT arrow aliases for original movement.
;
; Entry at AB9Dh:
;   D = player Y          MUST survive
;   E = old player X      MUST survive
;   B = E or E-1 if original LEFT was pressed
;   A = original RIGHT column result
;
; Output:
;   B = old X-1, old X, or old X+1.
; Z+LEFT and X+RIGHT cannot add together.
; D/E are restored exactly.
APPLY_RIGHT_AND_ARROWS:
        PUSH    DE                      ; preserve player Y + original X
        LD      C,A                     ; original RIGHT scan result
        LD      D,00h                   ; local flags: bit0 left, bit1 right

        ; Original LEFT already changed B from E to E-1.
        LD      A,B
        CP      E
        JR      Z,.NO_ORIG_LEFT
        SET     0,D
.NO_ORIG_LEFT:

        ; Original RIGHT.
        LD      A,C
        CP      0FFh
        JR      Z,.NO_ORIG_RIGHT
        SET     1,D
.NO_ORIG_RIGHT:

        ; Matrix is currently after column 3. Skip 4..7.
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)

        ; Column 8: LEFT arrow, active-low bit 3.
        IN      A,(00h)
        BIT     3,A
        JR      NZ,.NO_LEFT_ARROW
        SET     0,D
.NO_LEFT_ARROW:

        ; Columns 9..11.
        IN      A,(00h)
        IN      A,(00h)
        IN      A,(00h)

        ; Column 12: RIGHT arrow, active-low bit 1.
        IN      A,(00h)
        BIT     1,A
        JR      NZ,.APPLY
        SET     1,D

.APPLY:
        ; Build final movement from original X.
        LD      B,E
        BIT     0,D
        JR      Z,.CHECK_RIGHT
        BIT     1,D
        JR      NZ,.DONE                ; opposite directions cancel
        DEC     B
        JR      .DONE
.CHECK_RIGHT:
        BIT     1,D
        JR      Z,.DONE
        INC     B
.DONE:
        POP     DE                      ; restore original D/E exactly
        RET
