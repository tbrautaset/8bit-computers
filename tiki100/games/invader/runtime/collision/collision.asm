; ============================================================================
; Collision and hit handling
; Original range AF34h-B00Ah (215 bytes)
; SHA-256 916ef5bb6a30d73e1a2072c0852db6aed252fa10f4c33431adae370edfea7bdc
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

UPDATE_COLLISIONS:
        LD A,(0A518h)                                                                                 ; AF34: 3A 18 A5
        CP 00h                                                                                       ; AF37: FE 00
        JP NZ,COLLISION_BLOCK_AF92                                                                                  ; AF39: C2 92 AF
        LD HL,(0A516h)                                                                                ; AF3C: 2A 16 A5
        LD BC,0001h                                                                                  ; AF3F: 01 01 00
        AND A                                                                                        ; AF42: A7
        SBC HL,BC                                                                                    ; AF43: ED 42
        LD (0A516h),HL                                                                                ; AF45: 22 16 A5
        RET NZ                                                                                       ; AF48: C0
        CALL 058A4h                                                                                  ; AF49: G-only UFO timer
        NOP                                                                                          ; AF4C
        NOP                                                                                          ; AF4D
        NOP                                                                                          ; AF4E
        NOP                                                                                          ; AF4F
        NOP                                                                                          ; AF50
        LD (0A516h),HL                                                                                ; AF51: 22 16 A5
        CALL RANDOM_BYTE                                                                                   ; AF54: CD F5 AD
        CP 00h                                                                                       ; AF57: FE 00
        JP M,COLLISION_BLOCK_AF70                                                                                   ; AF59: FA 70 AF
        LD A,10h                                                                                     ; AF5C: 3E 10
        LD D,A                                                                                       ; AF5E: 57
        LD (0A208h),A                                                                                 ; AF5F: 32 08 A2
        LD A,0C8h                                                                                     ; AF62: 3E C8
        LD E,A                                                                                       ; AF64: 5F
        LD (0A209h),A                                                                                 ; AF65: 32 09 A2
        LD A,0FAh                                                                                     ; AF68: 3E FA
        LD (0A518h),A                                                                                 ; AF6A: 32 18 A5
        JP COLLISION_BLOCK_AF81                                                                                     ; AF6D: C3 81 AF

COLLISION_BLOCK_AF70:
        LD A,10h                                                                                     ; AF70: 3E 10
        LD D,A                                                                                       ; AF72: 57
        LD (0A208h),A                                                                                 ; AF73: 32 08 A2
        LD A,08h                                                                                     ; AF76: 3E 08
        LD E,A                                                                                       ; AF78: 5F
        LD (0A209h),A                                                                                 ; AF79: 32 09 A2
        LD A,06h                                                                                     ; AF7C: 3E 06
        LD (0A518h),A                                                                                 ; AF7E: 32 18 A5

COLLISION_BLOCK_AF81:
        LD HL,8380h                                                                                  ; AF81: 21 80 83
        CALL DRAW_SPRITE_SAFE                                                                                   ; AF84: CD 1E A8
        LD A,10h                                                                                     ; AF87: 3E 10
        ADD A,E                                                                                      ; AF89: 83
        LD E,A                                                                                       ; AF8A: 5F
        LD HL,8400h                                                                                  ; AF8B: 21 00 84
        CALL DRAW_SPRITE_SAFE                                                                                   ; AF8E: CD 1E A8
        RET                                                                                          ; AF91: C9

COLLISION_BLOCK_AF92:
        JP P,COLLISION_BLOCK_AFA3                                                                                   ; AF92: F2 A3 AF
        CP 0FEh                                                                                       ; AF95: FE FE
        JP NZ,COLLISION_BLOCK_AFB6                                                                                  ; AF97: C2 B6 AF
        CALL COLLISION_BLOCK_AFBB                                                                                   ; AF9A: CD BB AF
        LD A,0FCh                                                                                     ; AF9D: 3E FC
        LD (0A518h),A                                                                                 ; AF9F: 32 18 A5
        RET                                                                                          ; AFA2: C9

COLLISION_BLOCK_AFA3:
        CP 02h                                                                                       ; AFA3: FE 02
        JP NZ,COLLISION_BLOCK_AFB1                                                                                  ; AFA5: C2 B1 AF
        CALL COLLISION_BLOCK_AFBB                                                                                   ; AFA8: CD BB AF
        LD A,04h                                                                                     ; AFAB: 3E 04
        LD (0A518h),A                                                                                 ; AFAD: 32 18 A5
        RET                                                                                          ; AFB0: C9

COLLISION_BLOCK_AFB1:
        DEC A                                                                                        ; AFB1: 3D
        LD (0A518h),A                                                                                 ; AFB2: 32 18 A5
        RET                                                                                          ; AFB5: C9

COLLISION_BLOCK_AFB6:
        INC A                                                                                        ; AFB6: 3C
        LD (0A518h),A                                                                                 ; AFB7: 32 18 A5
        RET                                                                                          ; AFBA: C9

COLLISION_BLOCK_AFBB:
        LD      IX,0A208h
        LD      D,(IX+0)
        LD      E,(IX+1)
        PUSH    DE                     ; old Y/X
        ADD     A,E
        LD      E,A                    ; new X
        LD      (IX+1),E

        CP      06h
        JR      C,.OFF
        CP      0DAh
        JR      NC,.OFF

        ; Exact stable V7A address calculation.
        POP     HL
        SRL     H
        RR      L
        PUSH    HL
        POP     IY                     ; old left-half VRAM

        PUSH    DE
        POP     HL
        SRL     H
        RR      L
        PUSH    HL
        POP     IX                     ; new left-half VRAM

        CALL    0B545h                 ; seam-free helper executes above VRAM window
        RET

.OFF:
        POP     DE
        CALL    COLLISION_BLOCK_AF81   ; original stable erase-both-halves
        JR      COLLISION_BLOCK_B004

        ASSERT  $ <= 0B004h
        DS      0B004h-$,0FFh
        ASSERT  $ = 0B004h

COLLISION_BLOCK_B004:
        LD A,00h                                                                                     ; B004: 3E 00
        LD (0A518h),A                                                                                 ; B006: 32 18 A5
        POP AF                                                                                       ; B009: F1
        RET                                                                                          ; B00A: C9
