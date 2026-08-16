; ============================================================================
; UFO direct-delta mover - high RAM B545h
;
; IY = old UFO left-half VRAM base
; IX = new UFO left-half VRAM base
;
; UFO movement is +/-2 X coordinate units = +/-1 VRAM byte.
; A 17-byte XOR delta changes each complete 16-byte UFO row directly from
; OLD position to NEW position. There is no erase-then-draw blank interval.
; ============================================================================

UFO_SEAM_HIGH:
        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    IX
        PUSH    IY

        ; union base = leftmost(old,new)
        PUSH    IY
        POP     HL
        PUSH    IX
        POP     DE
        OR      A
        SBC     HL,DE
        JR      C,.BASE_READY          ; old < new, IY already old
        JR      Z,.BASE_READY
        PUSH    IX                     ; new < old
        POP     IY

.BASE_READY:
        LD      HL,UFO_MOVE_DELTA
        LD      B,010h

        DI
        LD      A,0ACh
        OUT     (01Ch),A

.ROW:
        LD      C,011h
.BYTE:
        LD      A,(HL)
        XOR     (IY+0)
        LD      (IY+0),A
        INC     HL
        INC     IY
        DEC     C
        JR      NZ,.BYTE

        ; VRAM row start stride is 80h. 11h bytes consumed -> +6Fh.
        PUSH    BC
        LD      BC,006Fh
        ADD     IY,BC
        POP     BC

        DJNZ    .ROW

        LD      A,0A4h
        OUT     (01Ch),A
        EI

        POP     IY
        POP     IX
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        RET

UFO_MOVE_DELTA:
        INCBIN  "../../assets/data/ufo_move_delta_17x16.bin"

UFO_SEAM_HIGH_END:
