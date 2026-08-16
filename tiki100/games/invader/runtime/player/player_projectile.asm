; ============================================================================
; Player and projectile systems
; Original range AB7Bh-AE3Fh (709 bytes)
; SHA-256 a88044b314ba5265c5f8fbfc861467a390cacf5ba4145f38b8d766f67e604b5c
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

UPDATE_PLAYER_MOVEMENT:
        LD IX,0A206h                                                                                  ; AB7B: DD 21 06 A2
        LD D,(IX+0)                                                                                  ; AB7F: DD 56 00
        LD E,(IX+1)                                                                                  ; AB82: DD 5E 01
        LD B,E                                                                                       ; AB85: 43
        DI                                 ; disable interrupts                                      ; AB86: F3
        OUT (00h),A                                                                                  ; AB87: D3 00
        IN A,(00h)                                                                                   ; AB89: DB 00
        IN A,(00h)                                                                                   ; AB8B: DB 00
        EI                                 ; enable interrupts                                       ; AB8D: FB
        CP 0FFh                                                                                       ; AB8E: FE FF
        JR Z,PLAYER_BLOCK_AB93                                                                                   ; AB90: 28 01
        DEC B                                                                                        ; AB92: 05

PLAYER_BLOCK_AB93:
        DI                                 ; disable interrupts                                      ; AB93: F3
        OUT (00h),A                                                                                  ; AB94: D3 00
        IN A,(00h)                                                                                   ; AB96: DB 00
        IN A,(00h)                                                                                   ; AB98: DB 00
        IN A,(00h)                                                                                   ; AB9A: DB 00
        EI                                 ; enable interrupts                                       ; AB9C: FB
        CALL APPLY_RIGHT_AND_ARROWS                                                                           ; AB9D
        NOP
        NOP

PLAYER_BLOCK_ABA2:
        LD A,18h                                                                                     ; ABA2: 3E 18
        CP B                                                                                         ; ABA4: B8
        JR C,PLAYER_BLOCK_ABA9                                                                                   ; ABA5: 38 02
        LD B,18h                                                                                     ; ABA7: 06 18

PLAYER_BLOCK_ABA9:
        LD A,0D6h                                                                                     ; ABA9: 3E D6
        CP B                                                                                         ; ABAB: B8
        JR NC,PLAYER_BLOCK_ABB0                                                                                  ; ABAC: 30 02
        LD B,0D6h                                                                                     ; ABAE: 06 D6

PLAYER_BLOCK_ABB0:
        LD A,B                                                                                       ; ABB0: 78
        CP E                                                                                         ; ABB1: BB
        JR Z,PLAYER_RETURN_ABC4                                                                                   ; ABB2: 28 10
        CALL 05898h                                                                                                  ; ABB4: PLAYER_ROW_ATOMIC_ENTRY
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        LD (IX+0),D                                                                                  ; ABBE: DD 72 00
        LD (IX+1),E                                                                                  ; ABC1: DD 73 01

PLAYER_RETURN_ABC4:
        RET                                                                                          ; ABC4: C9

UPDATE_PLAYER_PROJECTILE:
        LD A,(0A50Ch)                                                                                 ; ABC5: 3A 0C A5
        CP 00h                                                                                       ; ABC8: FE 00
        JP NZ,PLAYER_BLOCK_ADC7                                                                                  ; ABCA: C2 C7 AD
        LD HL,8280h                                                                                  ; ABCD: 21 80 82
        LD IX,0A200h                                                                                  ; ABD0: DD 21 00 A2
        LD D,(IX+0)                                                                                  ; ABD4: DD 56 00
        LD E,(IX+1)                                                                                  ; ABD7: DD 5E 01
        LD A,D                                                                                       ; ABDA: 7A
        CP 00h                                                                                       ; ABDB: FE 00
        JR NZ,PLAYER_BLOCK_AC15                                                                                  ; ABDD: 20 36

PLAYER_LOOP_ABDF:
        LD IX,0A200h                                                                                  ; ABDF: DD 21 00 A2
        LD (IX+0),00h                                                                                ; ABE3: DD 36 00 00
        LD (IX+1),00h                                                                                ; ABE7: DD 36 01 00
        CALL FIRE_OR_UP                                                                                          ; ABEB
        OR      A
        RET     Z
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        LD IX,0A206h                                                                                  ; ABF6: DD 21 06 A2
        LD D,(IX+0)                                                                                  ; ABFA: DD 56 00
        LD E,(IX+1)                                                                                  ; ABFD: DD 5E 01
        LD A,E                                                                                       ; AC00: 7B
        ADD A,06h                                                                                    ; AC01: C6 06
        LD E,A                                                                                       ; AC03: 5F
        LD HL,8280h                                                                                  ; AC04: 21 80 82
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AC07: CD 00 AD
        LD IX,0A200h                                                                                  ; AC0A: DD 21 00 A2
        LD (IX+0),D                                                                                  ; AC0E: DD 72 00
        LD (IX+1),E                                                                                  ; AC11: DD 73 01
        RET                                                                                          ; AC14: C9

PLAYER_BLOCK_AC15:
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AC15: CD 00 AD
        LD A,D                                                                                       ; AC18: 7A
        CP 20h                                                                                       ; AC19: FE 20
        JP C,PLAYER_BLOCK_AC85                                                                                   ; AC1B: DA 85 AC
        CALL READ_MODE3_PIXEL_BYTE                                                                                   ; AC1E: CD C3 AC
        CP 00h                                                                                       ; AC21: FE 00
        JR NZ,PLAYER_BLOCK_AC31                                                                                  ; AC23: 20 0C
        INC D                                                                                        ; AC25: 14
        CALL READ_MODE3_PIXEL_BYTE                                                                                   ; AC26: CD C3 AC
        DEC D                                                                                        ; AC29: 15
        CP 00h                                                                                       ; AC2A: FE 00
        JR NZ,PLAYER_BLOCK_AC31                                                                                  ; AC2C: 20 03
        JP PLAYER_LOOP_AC77                                                                                     ; AC2E: C3 77 AC

PLAYER_BLOCK_AC31:
        LD A,(0A509h)                                                                                 ; AC31: 3A 09 A5
        ADD A,0Fh                                                                                    ; AC34: C6 0F
        CP D                                                                                         ; AC36: BA
        JR NC,PLAYER_BLOCK_AC44                                                                                  ; AC37: 30 0B
        CALL PLAYER_BLOCK_ACD7                                                                                   ; AC39: CD D7 AC
        INC D                                                                                        ; AC3C: 14
        CALL PLAYER_BLOCK_ACD7                                                                                   ; AC3D: CD D7 AC
        DEC D                                                                                        ; AC40: 15
        JP PLAYER_LOOP_ABDF                                                                                     ; AC41: C3 DF AB

PLAYER_BLOCK_AC44:
        LD B,D                                                                                       ; AC44: 42
        LD C,E                                                                                       ; AC45: 4B
        LD IX,0A300h                                                                                  ; AC46: DD 21 00 A3
        LD L,28h                                                                                     ; AC4A: 2E 28

PLAYER_LOOP_AC4C:
        LD D,(IX+0)                                                                                  ; AC4C: DD 56 00
        LD E,(IX+1)                                                                                  ; AC4F: DD 5E 01
        LD A,E                                                                                       ; AC52: 7B
        SUB 02h                                                                                      ; AC53: D6 02
        CP C                                                                                         ; AC55: B9
        JR NC,PLAYER_BLOCK_AC6A                                                                                  ; AC56: 30 12
        LD A,E                                                                                       ; AC58: 7B
        ADD A,10h                                                                                    ; AC59: C6 10
        CP C                                                                                         ; AC5B: B9
        JR C,PLAYER_BLOCK_AC6A                                                                                   ; AC5C: 38 0C
        LD A,D                                                                                       ; AC5E: 7A
        CP B                                                                                         ; AC5F: B8
        JR NC,PLAYER_BLOCK_AC6A                                                                                  ; AC60: 30 08
        ADD A,10h                                                                                    ; AC62: C6 10
        CP B                                                                                         ; AC64: B8
        JR C,PLAYER_BLOCK_AC6A                                                                                   ; AC65: 38 03
        JP PROJECTILE_HIT_HANDLER                                                                                     ; AC67: C3 5E AD

PLAYER_BLOCK_AC6A:
        INC IX                                                                                       ; AC6A: DD 23
        INC IX                                                                                       ; AC6C: DD 23
        LD A,L                                                                                       ; AC6E: 7D
        SUB 01h                                                                                      ; AC6F: D6 01
        LD L,A                                                                                       ; AC71: 6F
        JR NZ,PLAYER_LOOP_AC4C                                                                                  ; AC72: 20 D8
        JP PLAYER_LOOP_ABDF                                                                                     ; AC74: C3 DF AB

PLAYER_LOOP_AC77:
        LD A,D                                                                                       ; AC77: 7A
        SUB 02h                                                                                      ; AC78: D6 02
        LD D,A                                                                                       ; AC7A: 57
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AC7B: CD 00 AD
        LD (IX+0),D                                                                                  ; AC7E: DD 72 00
        LD (IX+1),E                                                                                  ; AC81: DD 73 01
        RET                                                                                          ; AC84: C9

PLAYER_BLOCK_AC85:
        LD A,D                                                                                       ; AC85: 7A
        CP 18h                                                                                       ; AC86: FE 18
        JP C,PLAYER_LOOP_ABDF                                                                                   ; AC88: DA DF AB
        CALL READ_MODE3_PIXEL_BYTE                                                                                   ; AC8B: CD C3 AC
        CP 44h                                                                                       ; AC8E: FE 44
        JP NZ,PLAYER_BLOCK_ACBB                                                                                  ; AC90: C2 BB AC
        LD A,32h                                                                                     ; AC93: 3E 32
        LD HL,0A222h                                                                                  ; AC95: 21 22 A2
        CALL OBJECT_SELECT_FRAME                                                                                   ; AC98: CD D7 A9
        LD A,(0A208h)                                                                                 ; AC9B: 3A 08 A2
        LD D,A                                                                                       ; AC9E: 57
        LD A,(0A209h)                                                                                 ; AC9F: 3A 09 A2
        LD E,A                                                                                       ; ACA2: 5F
        LD HL,8380h                                                                                  ; ACA3: 21 80 83
        CALL DRAW_SPRITE_SAFE                                                                                   ; ACA6: CD 1E A8
        LD A,10h                                                                                     ; ACA9: 3E 10
        ADD A,E                                                                                      ; ACAB: 83
        LD E,A                                                                                       ; ACAC: 5F
        LD HL,8400h                                                                                  ; ACAD: 21 00 84
        CALL DRAW_SPRITE_SAFE                                                                                   ; ACB0: CD 1E A8
        LD A,00h                                                                                     ; ACB3: 3E 00
        LD (0A518h),A                                                                                 ; ACB5: 32 18 A5
        JP PLAYER_LOOP_ABDF                                                                                     ; ACB8: C3 DF AB

PLAYER_BLOCK_ACBB:
        CP 00h                                                                                       ; ACBB: FE 00
        JP Z,PLAYER_LOOP_AC77                                                                                   ; ACBD: CA 77 AC
        JP PLAYER_LOOP_ABDF                                                                                     ; ACC0: C3 DF AB

READ_MODE3_PIXEL_BYTE:
        PUSH DE                                                                                      ; ACC3: D5
        SRL D                                                                                        ; ACC4: CB 3A
        RR E                                                                                         ; ACC6: CB 1B
        DI                                 ; disable interrupts                                      ; ACC8: F3
        LD A,0ACh                                                                                     ; ACC9: 3E AC
        OUT (1Ch),A                                                                                  ; ACCB: D3 1C
        LD A,(DE)                                                                                    ; ACCD: 1A
        LD D,A                                                                                       ; ACCE: 57
        LD A,0A4h                                                                                     ; ACCF: 3E A4
        OUT (1Ch),A                                                                                  ; ACD1: D3 1C
        EI                                 ; enable interrupts                                       ; ACD3: FB
        LD A,D                                                                                       ; ACD4: 7A
        POP DE                                                                                       ; ACD5: D1
        RET                                                                                          ; ACD6: C9

PLAYER_BLOCK_ACD7:
        PUSH DE                                                                                      ; ACD7: D5
        PUSH AF                                                                                      ; ACD8: F5
        SRL D                                                                                        ; ACD9: CB 3A
        RR E                                                                                         ; ACDB: CB 1B
        DI                                 ; disable interrupts                                      ; ACDD: F3
        LD A,0ACh                                                                                     ; ACDE: 3E AC
        OUT (1Ch),A                                                                                  ; ACE0: D3 1C
        LD A,(DE)                                                                                    ; ACE2: 1A
        CP 07h                                                                                       ; ACE3: FE 07
        JP Z,PLAYER_BLOCK_ACF5                                                                                   ; ACE5: CA F5 AC
        CP 70h                                                                                       ; ACE8: FE 70
        JP Z,PLAYER_BLOCK_ACF5                                                                                   ; ACEA: CA F5 AC
        CP 77h                                                                                       ; ACED: FE 77
        JP Z,PLAYER_BLOCK_ACF5                                                                                   ; ACEF: CA F5 AC
        JP PLAYER_BLOCK_ACF8                                                                                     ; ACF2: C3 F8 AC

PLAYER_BLOCK_ACF5:
        LD A,00h                                                                                     ; ACF5: 3E 00
        LD (DE),A                                                                                    ; ACF7: 12

PLAYER_BLOCK_ACF8:
        LD A,0A4h                                                                                     ; ACF8: 3E A4
        OUT (1Ch),A                                                                                  ; ACFA: D3 1C
        EI                                 ; enable interrupts                                       ; ACFC: FB
        POP AF                                                                                       ; ACFD: F1
        POP DE                                                                                       ; ACFE: D1
        RET                                                                                          ; ACFF: C9

PROJECTILE_DRAW_HELPER:
        PUSH AF                                                                                      ; AD00: F5
        PUSH BC                                                                                      ; AD01: C5
        PUSH IX                                                                                      ; AD02: DD E5
        PUSH HL                                                                                      ; AD04: E5
        POP IX                                                                                       ; AD05: DD E1
        LD A,D                                                                                       ; AD07: 7A
        CP 00h                                                                                       ; AD08: FE 00
        JP Z,PLAYER_BLOCK_AD56                                                                                   ; AD0A: CA 56 AD
        LD A,E                                                                                       ; AD0D: 7B
        CP 00h                                                                                       ; AD0E: FE 00
        JP Z,PLAYER_BLOCK_AD56                                                                                   ; AD10: CA 56 AD
        LD H,D                                                                                       ; AD13: 62
        LD L,E                                                                                       ; AD14: 6B
        SRL H                                                                                        ; AD15: CB 3C
        RR L                                                                                         ; AD17: CB 1D
        LD BC,0080h                                                                                  ; AD19: 01 80 00
        DI                                 ; disable interrupts                                      ; AD1C: F3
        LD A,0ACh                                                                                     ; AD1D: 3E AC
        OUT (1Ch),A                                                                                  ; AD1F: D3 1C
        LD A,(HL)                                                                                    ; AD21: 7E
        XOR (IX+0)                                                                                   ; AD22: DD AE 00
        LD (HL),A                                                                                    ; AD25: 77
        ADD HL,BC                                                                                    ; AD26: 09
        LD A,(HL)                                                                                    ; AD27: 7E
        XOR (IX+8)                                                                                   ; AD28: DD AE 08
        LD (HL),A                                                                                    ; AD2B: 77
        ADD HL,BC                                                                                    ; AD2C: 09
        LD A,(HL)                                                                                    ; AD2D: 7E
        XOR (IX+16)                                                                                  ; AD2E: DD AE 10
        LD (HL),A                                                                                    ; AD31: 77
        ADD HL,BC                                                                                    ; AD32: 09
        LD A,(HL)                                                                                    ; AD33: 7E
        XOR (IX+24)                                                                                  ; AD34: DD AE 18
        LD (HL),A                                                                                    ; AD37: 77
        ADD HL,BC                                                                                    ; AD38: 09
        LD A,(HL)                                                                                    ; AD39: 7E
        XOR (IX+32)                                                                                  ; AD3A: DD AE 20
        LD (HL),A                                                                                    ; AD3D: 77
        ADD HL,BC                                                                                    ; AD3E: 09
        LD A,(HL)                                                                                    ; AD3F: 7E
        XOR (IX+40)                                                                                  ; AD40: DD AE 28
        LD (HL),A                                                                                    ; AD43: 77
        ADD HL,BC                                                                                    ; AD44: 09
        LD A,(HL)                                                                                    ; AD45: 7E
        XOR (IX+48)                                                                                  ; AD46: DD AE 30
        LD (HL),A                                                                                    ; AD49: 77
        ADD HL,BC                                                                                    ; AD4A: 09
        LD A,(HL)                                                                                    ; AD4B: 7E
        XOR (IX+56)                                                                                  ; AD4C: DD AE 38
        LD (HL),A                                                                                    ; AD4F: 77
        ADD HL,BC                                                                                    ; AD50: 09
        LD A,0A4h                                                                                     ; AD51: 3E A4
        OUT (1Ch),A                                                                                  ; AD53: D3 1C
        EI                                 ; enable interrupts                                       ; AD55: FB

PLAYER_BLOCK_AD56:
        PUSH IX                                                                                      ; AD56: DD E5
        POP HL                                                                                       ; AD58: E1
        POP IX                                                                                       ; AD59: DD E1
        POP BC                                                                                       ; AD5B: C1
        POP AF                                                                                       ; AD5C: F1
        RET                                                                                          ; AD5D: C9

PROJECTILE_HIT_HANDLER:
        CALL 05889h                                                                                   ; AD5E: R2A God Mode hit gate
        SUB 01h                                                                                      ; AD61: D6 01
        LD (0A511h),A                                                                                 ; AD63: 32 11 A5
        LD HL,8480h                                                                                  ; AD66: 21 80 84
        CALL DRAW_SPRITE_SAFE                                                                                   ; AD69: CD 1E A8
        LD A,05h                                                                                     ; AD6C: 3E 05
        LD (0A50Ch),A                                                                                 ; AD6E: 32 0C A5
        LD (0A50Ah),DE                                                                                ; AD71: ED 53 0A A5
        PUSH IX                                                                                      ; AD75: DD E5
        POP HL                                                                                       ; AD77: E1
        SRL L                                                                                        ; AD78: CB 3D
        SRL L                                                                                        ; AD7A: CB 3D
        SRL L                                                                                        ; AD7C: CB 3D
        SRL L                                                                                        ; AD7E: CB 3D
        LD A,(0A501h)                                                                                 ; AD80: 3A 01 A5
        ADD A,87h                                                                                    ; AD83: C6 87
        ADD A,L                                                                                      ; AD85: 85
        LD H,A                                                                                       ; AD86: 67
        LD A,(0A500h)                                                                                 ; AD87: 3A 00 A5
        PUSH HL                                                                                      ; AD8A: E5
        PUSH IX                                                                                      ; AD8B: DD E5
        POP HL                                                                                       ; AD8D: E1
        SCF                                                                                          ; AD8E: 37
        CCF                                                                                          ; AD8F: 3F
        LD BC,(0A502h)                                                                                ; AD90: ED 4B 02 A5
        SBC HL,BC                                                                                    ; AD94: ED 42
        JR NC,PLAYER_EPILOGUE_AD9A                                                                                  ; AD96: 30 02
        XOR 80h                                                                                      ; AD98: EE 80

PLAYER_EPILOGUE_AD9A:
        POP HL                                                                                       ; AD9A: E1
        LD L,A                                                                                       ; AD9B: 6F
        CALL DRAW_SPRITE_SAFE                                                                                   ; AD9C: CD 1E A8
        LD (IX+0),00h                                                                                ; AD9F: DD 36 00 00
        LD (IX+1),00h                                                                                ; ADA3: DD 36 01 00
        PUSH IX                                                                                      ; ADA7: DD E5
        POP HL                                                                                       ; ADA9: E1
        SRL L                                                                                        ; ADAA: CB 3D
        SRL L                                                                                        ; ADAC: CB 3D
        SRL L                                                                                        ; ADAE: CB 3D
        SRL L                                                                                        ; ADB0: CB 3D
        LD A,(0A501h)                                                                                 ; ADB2: 3A 01 A5
        ADD A,L                                                                                      ; ADB5: 85
        LD HL,0A222h                                                                                  ; ADB6: 21 22 A2
        PUSH DE                                                                                      ; ADB9: D5
        CALL OBJECT_SELECT_FRAME                                                                                   ; ADBA: CD D7 A9
        POP DE                                                                                       ; ADBD: D1
        LD A,00h                                                                                     ; ADBE: 3E 00
        LD (0A200h),A                                                                                 ; ADC0: 32 00 A2
        LD (0A201h),A                                                                                 ; ADC3: 32 01 A2
        RET                                                                                          ; ADC6: C9

PLAYER_BLOCK_ADC7:
        LD DE,(0A50Ah)                                                                                ; ADC7: ED 5B 0A A5
        LD HL,8700h                                                                                  ; ADCB: 21 00 87
        LD A,(0A50Ch)                                                                                 ; ADCE: 3A 0C A5
        LD B,A                                                                                       ; ADD1: 47
        LD C,00h                                                                                     ; ADD2: 0E 00
        SRL B                                                                                        ; ADD4: CB 38
        RR C                                                                                         ; ADD6: CB 19
        SCF                                                                                          ; ADD8: 37
        CCF                                                                                          ; ADD9: 3F
        SBC HL,BC                                                                                    ; ADDA: ED 42
        CALL DRAW_SPRITE_SAFE                                                                                   ; ADDC: CD 1E A8
        LD A,(0A50Ch)                                                                                 ; ADDF: 3A 0C A5
        SUB 01h                                                                                      ; ADE2: D6 01
        LD (0A50Ch),A                                                                                 ; ADE4: 32 0C A5
        JP Z,PLAYER_LOOP_ABDF                                                                                   ; ADE7: CA DF AB
        LD BC,0080h                                                                                  ; ADEA: 01 80 00
        SCF                                                                                          ; ADED: 37
        CCF                                                                                          ; ADEE: 3F
        ADC HL,BC                                                                                    ; ADEF: ED 4A
        CALL DRAW_SPRITE_SAFE                                                                                   ; ADF1: CD 1E A8
        RET                                                                                          ; ADF4: C9

RANDOM_BYTE:
        PUSH HL                                                                                      ; ADF5: E5
        PUSH DE                                                                                      ; ADF6: D5
        PUSH IX                                                                                      ; ADF7: DD E5
        PUSH BC                                                                                      ; ADF9: C5
        LD IX,0A50Dh                                                                                  ; ADFA: DD 21 0D A5
        LD D,(IX+0)                                                                                  ; ADFE: DD 56 00
        LD E,(IX+1)                                                                                  ; AE01: DD 5E 01
        DB      0DDh,66h,02h      ; AE04: DD 66 02  exact IXH/IXL opcode
        DB      0DDh,6Eh,03h      ; AE07: DD 6E 03  exact IXH/IXL opcode
        LD B,08h                                                                                     ; AE0A: 06 08

PLAYER_LOOP_AE0C:
        BIT 7,L                                                                                      ; AE0C: CB 7D
        JR NZ,PLAYER_BLOCK_AE1C                                                                                  ; AE0E: 20 0C
        LD A,D                                                                                       ; AE10: 7A
        XOR 24h                                                                                      ; AE11: EE 24
        LD D,A                                                                                       ; AE13: 57
        LD A,E                                                                                       ; AE14: 7B
        XOR 0FAh                                                                                      ; AE15: EE FA
        LD E,A                                                                                       ; AE17: 5F
        LD A,H                                                                                       ; AE18: 7C
        XOR 03h                                                                                      ; AE19: EE 03
        LD H,A                                                                                       ; AE1B: 67

PLAYER_BLOCK_AE1C:
        SLA D                                                                                        ; AE1C: CB 22
        RL E                                                                                         ; AE1E: CB 13
        RL H                                                                                         ; AE20: CB 14
        RL L                                                                                         ; AE22: CB 15
        JR NC,PLAYER_BLOCK_AE27                                                                                  ; AE24: 30 01
        INC D                                                                                        ; AE26: 14

PLAYER_BLOCK_AE27:
        DEC B                                                                                        ; AE27: 05
        LD A,B                                                                                       ; AE28: 78
        CP 00h                                                                                       ; AE29: FE 00
        JR NZ,PLAYER_LOOP_AE0C                                                                                  ; AE2B: 20 DF
        LD (IX+0),D                                                                                  ; AE2D: DD 72 00
        LD (IX+1),E                                                                                  ; AE30: DD 73 01
        DB      0DDh,74h,02h      ; AE33: DD 74 02  exact IXH/IXL opcode
        DB      0DDh,75h,03h      ; AE36: DD 75 03  exact IXH/IXL opcode
        LD A,L                                                                                       ; AE39: 7D
        POP BC                                                                                       ; AE3A: C1
        POP IX                                                                                       ; AE3B: DD E1
        POP DE                                                                                       ; AE3D: D1
        POP HL                                                                                       ; AE3E: E1
        RET                                                                                          ; AE3F: C9
