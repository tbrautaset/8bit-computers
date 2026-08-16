; ============================================================================
; Object, screen and world engine
; Original range A800h-AB7Ah (891 bytes)
; SHA-256 6196a6158f99dfab5406e2fef434549c5c3087fe7a4f750a82458bf8e45facd6
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

CLEAR_MODE3_ROWS:
        LD H,B
        LD L,00h
        SRL H
        RR L
        LD A,0A4h
.CLEAR_ROW:
        DI
        XOR 08h
        OUT (1Ch),A
        XOR A
        LD B,80h
.CLEAR_BYTE:
        LD (HL),A
        INC HL
        DJNZ .CLEAR_BYTE
        LD A,0A4h
        OUT (1Ch),A
        EI
        DEC C
        JR NZ,.CLEAR_ROW
        RET

DRAW_SPRITE_SAFE:
        PUSH AF                                                                                      ; A81E: F5
        PUSH BC                                                                                      ; A81F: C5
        PUSH DE                                                                                      ; A820: D5
        PUSH HL                                                                                      ; A821: E5
        PUSH IX                                                                                      ; A822: DD E5
        LD A,00h                                                                                     ; A824: 3E 00
        CP D                                                                                         ; A826: BA
        JR Z,WORLD_EPILOGUE_A831                                                                                   ; A827: 28 08
        CP E                                                                                         ; A829: BB
        JR Z,WORLD_EPILOGUE_A831                                                                                   ; A82A: 28 05
        LD C,10h                                                                                     ; A82C: 0E 10
        CALL SPRITE_XOR_BLITTER                                                                                   ; A82E: CD 00 80

WORLD_EPILOGUE_A831:
        POP IX                                                                                       ; A831: DD E1
        POP HL                                                                                       ; A833: E1
        POP DE                                                                                       ; A834: D1
        POP BC                                                                                       ; A835: C1
        POP AF                                                                                       ; A836: F1
        RET                                                                                          ; A837: C9

WORLD_INITIALIZE_OR_REDRAW:
        CALL 058A1h                                                                                  ; A838: V7 full-init gate
        NOP                                                                                          ; A83B
        NOP                                                                                          ; A83C
        JR NZ,WORLD_BLOCK_A8B1                                                                                  ; A83D: original branch
        LD B,00h                                                                                     ; A83F: 06 00
        LD C,20h                                                                                     ; A841: 0E 20
        CALL SCREEN_RESET                                                                                   ; A843: CD 00 81
        LD HL,0A400h                                                                                  ; A846: 21 00 A4

WORLD_LOOP_A849:
        PUSH HL                                                                                      ; A849: E5
        LD A,(HL)                                                                                    ; A84A: 7E
        CALL TERMINAL_SERVICE_F00C                         ; console/screen output                                   ; A84B: CD 0C F0
        POP HL                                                                                       ; A84E: E1
        INC HL                                                                                       ; A84F: 23
        LD A,40h                                                                                     ; A850: 3E 40
        CP L                                                                                         ; A852: BD
        JP NC,WORLD_LOOP_A849                                                                                  ; A853: D2 49 A8
        CALL RANDOM_BYTE                                                                                   ; A856: CD F5 AD
        AND 03h                                                                                      ; A859: E6 03
        LD H,A                                                                                       ; A85B: 67
        LD L,50h                                                                                     ; A85C: 2E 50
        LD (0A516h),HL                                                                                ; A85E: 22 16 A5
        LD A,00h                                                                                     ; A861: 3E 00
        LD (0A518h),A                                                                                 ; A863: 32 18 A5
        LD A,02h                                                                                     ; A866: 3E 02
        LD (0A514h),A                                                                                 ; A868: 32 14 A5
        LD A,00h                                                                                     ; A86B: 3E 00
        LD (0A513h),A                                                                                 ; A86D: 32 13 A5
        LD A,02h                                                                                     ; A870: 3E 02
        LD (0A512h),A                                                                                 ; A872: 32 12 A5
        LD A,00h                                                                                     ; A875: 3E 00
        LD B,10h                                                                                     ; A877: 06 10
        LD HL,0A230h                                                                                  ; A879: 21 30 A2

WORLD_LOOP_A87C:
        LD (HL),A                                                                                    ; A87C: 77
        INC HL                                                                                       ; A87D: 23
        DEC B                                                                                        ; A87E: 05
        JP NZ,WORLD_LOOP_A87C                                                                                  ; A87F: C2 7C A8
        LD B,0D8h                                                                                     ; A882: 06 D8
        LD C,28h                                                                                     ; A884: 0E 28
        CALL CLEAR_MODE3_ROWS                                                                                   ; A886: CD 00 A8
        CALL WORLD_SETUP_HELPER                                                                                   ; A889: CD 91 A9
        LD HL,8200h                                                                                  ; A88C: 21 00 82
        LD D,0E4h                                                                                     ; A88F: 16 E4
        LD E,18h                                                                                     ; A891: 1E 18
        LD IX,0A206h                                                                                  ; A893: DD 21 06 A2
        LD (IX+0),D                                                                                  ; A897: DD 72 00
        LD (IX+1),E                                                                                  ; A89A: DD 73 01
        LD IX,0A200h                                                                                  ; A89D: DD 21 00 A2
        LD (IX+0),00h                                                                                ; A8A1: DD 36 00 00
        LD (IX+1),00h                                                                                ; A8A5: DD 36 01 00
        CALL DRAW_SPRITE_SAFE                                                                                   ; A8A9: CD 1E A8
        LD A,00h                                                                                     ; A8AC: 3E 00
        LD (0A50Ch),A                                                                                 ; A8AE: 32 0C A5

WORLD_BLOCK_A8B1:
        LD HL,8280h                                                                                  ; A8B1: 21 80 82
        LD IX,0A200h                                                                                  ; A8B4: DD 21 00 A2
        LD D,(IX+0)                                                                                  ; A8B8: DD 56 00
        LD E,(IX+1)                                                                                  ; A8BB: DD 5E 01
        CALL DRAW_SPRITE_SAFE                                                                                   ; A8BE: CD 1E A8
        LD B,20h                                                                                     ; A8C1: 06 20
        LD C,0B8h                                                                                     ; A8C3: 0E B8
        CALL CLEAR_MODE3_ROWS                                                                                   ; A8C5: CD 00 A8
        LD HL,8280h                                                                                  ; A8C8: 21 80 82
        LD IX,0A200h                                                                                  ; A8CB: DD 21 00 A2
        LD D,(IX+0)                                                                                  ; A8CF: DD 56 00
        LD E,(IX+1)                                                                                  ; A8D2: DD 5E 01
        CALL DRAW_SPRITE_SAFE                                                                                   ; A8D5: CD 1E A8
        LD A,01h                                                                                     ; A8D8: 3E 01
        LD HL,0A20Eh                                                                                  ; A8DA: 21 0E A2
        CALL OBJECT_SELECT_FRAME                                                                                   ; A8DD: CD D7 A9
        LD A,00h                                                                                     ; A8E0: 3E 00
        LD (0A500h),A                                                                                 ; A8E2: 32 00 A5
        LD HL,0A300h                                                                                  ; A8E5: 21 00 A3
        LD (0A502h),HL                                                                                ; A8E8: 22 02 A5
        LD A,00h                                                                                     ; A8EB: 3E 00
        LD (0A504h),A                                                                                 ; A8ED: 32 04 A5
        LD (0A505h),A                                                                                 ; A8F0: 32 05 A5
        LD A,(0A512h)                                                                                 ; A8F3: 3A 12 A5
        LD (0A506h),A                                                                                 ; A8F6: 32 06 A5
        LD A,00h                                                                                     ; A8F9: 3E 00
        LD (0A508h),A                                                                                 ; A8FB: 32 08 A5
        LD A,00h                                                                                     ; A8FE: 3E 00
        LD (0A509h),A                                                                                 ; A900: 32 09 A5
        LD A,28h                                                                                     ; A903: 3E 28
        LD (0A511h),A                                                                                 ; A905: 32 11 A5
        LD A,(0A501h)                                                                                 ; A908: 3A 01 A5
        RRA                                                                                          ; A90B: 1F
        JP NC,WORLD_BLOCK_A913                                                                                  ; A90C: D2 13 A9
        LD HL,0A514h                                                                                  ; A90F: 21 14 A5
        INC (HL)                                                                                     ; A912: 34

WORLD_BLOCK_A913:
        LD A,(0A501h)                                                                                 ; A913: 3A 01 A5
        CP 09h                                                                                       ; A916: FE 09
        JP C,WORLD_BLOCK_A91F                                                                                   ; A918: DA 1F A9
        LD HL,0A512h                                                                                  ; A91B: 21 12 A5
        INC (HL)                                                                                     ; A91E: 34

WORLD_BLOCK_A91F:
        LD IY,0A300h                                                                                  ; A91F: FD 21 00 A3
        LD A,(0A501h)                                                                                 ; A923: 3A 01 A5
        ADD A,87h                                                                                    ; A926: C6 87
        LD H,A                                                                                       ; A928: 67
        LD L,00h                                                                                     ; A929: 2E 00
        LD C,05h                                                                                     ; A92B: 0E 05
        CALL 0588Fh                                                                                  ; A92D: V1E level-for-start-Y gate
        SLA A                                                                                        ; A930: CB 27
        SLA A                                                                                        ; A932: CB 27
        SLA A                                                                                        ; A934: CB 27
        ADD A,0C8h                                                                                    ; A936: C6 C8
        JR NC,WORLD_BLOCK_A93C                                                                                  ; A938: 30 02
        LD A,00h                                                                                     ; A93A: 3E 00

WORLD_BLOCK_A93C:
        SUB 3Ch                                                                                      ; A93C: D6 3C
        LD D,A                                                                                       ; A93E: 57

WORLD_LOOP_A93F:
        LD B,08h                                                                                     ; A93F: 06 08
        LD E,14h                                                                                     ; A941: 1E 14

WORLD_LOOP_A943:
        CALL DRAW_SPRITE_SAFE                                                                                   ; A943: CD 1E A8
        LD (IY+0),D                                                                                  ; A946: FD 72 00
        LD (IY+1),E                                                                                  ; A949: FD 73 01
        LD A,E                                                                                       ; A94C: 7B
        ADD A,18h                                                                                    ; A94D: C6 18
        LD E,A                                                                                       ; A94F: 5F
        INC IY                                                                                       ; A950: FD 23
        INC IY                                                                                       ; A952: FD 23
        LD A,B                                                                                       ; A954: 78
        SUB 01h                                                                                      ; A955: D6 01
        LD B,A                                                                                       ; A957: 47
        JR NZ,WORLD_LOOP_A943                                                                                  ; A958: 20 E9
        INC H                                                                                        ; A95A: 24
        LD A,D                                                                                       ; A95B: 7A
        SUB 18h                                                                                      ; A95C: D6 18
        LD D,A                                                                                       ; A95E: 57
        LD A,C                                                                                       ; A95F: 79
        SUB 01h                                                                                      ; A960: D6 01
        LD C,A                                                                                       ; A962: 4F
        JR NZ,WORLD_LOOP_A93F                                                                                  ; A963: 20 DA
        LD A,(0A501h)                                                                                 ; A965: 3A 01 A5
        CP 06h                                                                                       ; A968: FE 06
        RET NC                                                                                       ; A96A: D0
        LD HL,9700h                                                                                  ; A96B: 21 00 97
        LD D,0C8h                                                                                     ; A96E: 16 C8
        LD E,30h                                                                                     ; A970: 1E 30
        CALL DRAW_SPRITE_SAFE                                                                                   ; A972: CD 1E A8
        LD E,70h                                                                                     ; A975: 1E 70
        CALL DRAW_SPRITE_SAFE                                                                                   ; A977: CD 1E A8
        LD E,0B0h                                                                                     ; A97A: 1E B0
        CALL DRAW_SPRITE_SAFE                                                                                   ; A97C: CD 1E A8
        LD L,80h                                                                                     ; A97F: 2E 80
        LD E,40h                                                                                     ; A981: 1E 40
        CALL DRAW_SPRITE_SAFE                                                                                   ; A983: CD 1E A8
        LD E,80h                                                                                     ; A986: 1E 80
        CALL DRAW_SPRITE_SAFE                                                                                   ; A988: CD 1E A8
        LD E,0C0h                                                                                     ; A98B: 1E C0
        CALL DRAW_SPRITE_SAFE                                                                                   ; A98D: CD 1E A8
        RET                                                                                          ; A990: C9

WORLD_SETUP_HELPER:
        LD HL,9800h                                                                                  ; A991: 21 00 98
        LD B,02h                                                                                     ; A994: 06 02
        LD DE,01C0h                                                                                  ; A996: 11 C0 01
        LD IX,0A20Ah                                                                                  ; A999: DD 21 0A A2

WORLD_LOOP_A99D:
        CALL OBJECT_STORE_AND_DRAW                                                                                   ; A99D: CD BB A9
        DEC B                                                                                        ; A9A0: 05
        JR NZ,WORLD_LOOP_A99D                                                                                  ; A9A1: 20 FA
        LD HL,9980h                                                                                  ; A9A3: 21 80 99
        LD DE,0190h                                                                                  ; A9A6: 11 90 01
        CALL OBJECT_STORE_AND_DRAW                                                                                   ; A9A9: CD BB A9
        LD HL,9800h                                                                                  ; A9AC: 21 00 98
        LD DE,0128h                                                                                  ; A9AF: 11 28 01
        LD B,05h                                                                                     ; A9B2: 06 05

WORLD_LOOP_A9B4:
        CALL OBJECT_STORE_AND_DRAW                                                                                   ; A9B4: CD BB A9
        DEC B                                                                                        ; A9B7: 05
        JR NZ,WORLD_LOOP_A9B4                                                                                  ; A9B8: 20 FA
        RET                                                                                          ; A9BA: C9

OBJECT_STORE_AND_DRAW:
        LD (IX+0),D                                                                                  ; A9BB: DD 72 00
        LD (IX+1),E                                                                                  ; A9BE: DD 73 01
        DB      0DDh,74h,02h      ; A9C1: DD 74 02  exact IXH/IXL opcode
        DB      0DDh,75h,03h      ; A9C4: DD 75 03  exact IXH/IXL opcode
        CALL DRAW_SPRITE_SAFE                                                                                   ; A9C7: CD 1E A8
        INC IX                                                                                       ; A9CA: DD 23
        INC IX                                                                                       ; A9CC: DD 23
        INC IX                                                                                       ; A9CE: DD 23
        INC IX                                                                                       ; A9D0: DD 23
        LD A,E                                                                                       ; A9D2: 7B
        ADD A,10h                                                                                    ; A9D3: C6 10
        LD E,A                                                                                       ; A9D5: 5F
        RET                                                                                          ; A9D6: C9

OBJECT_SELECT_FRAME:
        LD B,A                                                                                       ; A9D7: 47
        LD C,00h                                                                                     ; A9D8: 0E 00
        SRA B                                                                                        ; A9DA: CB 28
        RR C                                                                                         ; A9DC: CB 19
        PUSH HL                                                                                      ; A9DE: E5
        POP IX                                                                                       ; A9DF: DD E1
        DB      0DDh,66h,02h      ; A9E1: DD 66 02  exact IXH/IXL opcode
        DB      0DDh,6Eh,03h      ; A9E4: DD 6E 03  exact IXH/IXL opcode
        LD D,(IX+0)                                                                                  ; A9E7: DD 56 00
        LD E,(IX+1)                                                                                  ; A9EA: DD 5E 01
        CALL DRAW_SPRITE_SAFE                                                                                   ; A9ED: CD 1E A8
        ADD HL,BC                                                                                    ; A9F0: 09
        PUSH DE                                                                                      ; A9F1: D5
        PUSH IX                                                                                      ; A9F2: DD E5
        PUSH HL                                                                                      ; A9F4: E5

WORLD_LOOP_A9F5:
        POP HL                                                                                       ; A9F5: E1
        POP IX                                                                                       ; A9F6: DD E1
        PUSH IX                                                                                      ; A9F8: DD E5
        PUSH HL                                                                                      ; A9FA: E5
        LD A,H                                                                                       ; A9FB: 7C
        CP 9Dh                                                                                       ; A9FC: FE 9D
        JR C,WORLD_EPILOGUE_AA14                                                                                   ; A9FE: 38 14
        SUB 05h                                                                                      ; AA00: D6 05
        POP HL                                                                                       ; AA02: E1
        LD H,A                                                                                       ; AA03: 67
        PUSH HL                                                                                      ; AA04: E5
        PUSH IX                                                                                      ; AA05: DD E5
        POP HL                                                                                       ; AA07: E1
        DEC HL                                                                                       ; AA08: 2B
        DEC HL                                                                                       ; AA09: 2B
        DEC HL                                                                                       ; AA0A: 2B
        DEC HL                                                                                       ; AA0B: 2B
        LD A,01h                                                                                     ; AA0C: 3E 01
        CALL OBJECT_SELECT_FRAME                                                                                   ; AA0E: CD D7 A9
        JP WORLD_LOOP_A9F5                                                                                     ; AA11: C3 F5 A9

WORLD_EPILOGUE_AA14:
        POP HL                                                                                       ; AA14: E1
        POP IX                                                                                       ; AA15: DD E1
        POP DE                                                                                       ; AA17: D1
        DB      0DDh,74h,02h      ; AA18: DD 74 02  exact IXH/IXL opcode
        DB      0DDh,75h,03h      ; AA1B: DD 75 03  exact IXH/IXL opcode
        CALL DRAW_SPRITE_SAFE                                                                                   ; AA1E: CD 1E A8
        RET                                                                                          ; AA21: C9

UPDATE_WORLD_SYSTEM:
        LD A,(0A511h)                                                                                 ; AA22: 3A 11 A5
        CP 00h                                                                                       ; AA25: FE 00
        RET Z                                                                                        ; AA27: C8
        LD IX,(0A502h)                                                                                ; AA28: DD 2A 02 A5
        LD D,(IX+0)                                                                                  ; AA2C: DD 56 00
        LD E,(IX+1)                                                                                  ; AA2F: DD 5E 01
        LD A,E                                                                                       ; AA32: 7B
        CP 00h                                                                                       ; AA33: FE 00
        JP Z,WORLD_BLOCK_AB30                                                                                   ; AA35: CA 30 AB
        LD A,(0A501h)                                                                                 ; AA38: 3A 01 A5
        LD B,A                                                                                       ; AA3B: 47
        LD A,(0A504h)                                                                                 ; AA3C: 3A 04 A5
        ADD A,B                                                                                      ; AA3F: 80
        ADD A,87h                                                                                    ; AA40: C6 87
        LD H,A                                                                                       ; AA42: 67
        LD A,(0A500h)                                                                                 ; AA43: 3A 00 A5
        LD L,A                                                                                       ; AA46: 6F
        CALL 0589Bh                                                                                                  ; AA47: INV_CAPTURE_ENTRY
        LD A,(0A506h)                                                                                 ; AA4A: 3A 06 A5
        ADD A,E                                                                                      ; AA4D: 83
        LD E,A                                                                                       ; AA4E: 5F
        LD A,(0A507h)                                                                                 ; AA4F: 3A 07 A5
        ADD A,D                                                                                      ; AA52: 82
        LD D,A                                                                                       ; AA53: 57
        LD A,(0A509h)                                                                                 ; AA54: 3A 09 A5
        CP D                                                                                         ; AA57: BA
        JP NC,WORLD_BLOCK_AA5F                                                                                  ; AA58: D2 5F AA
        LD A,D                                                                                       ; AA5B: 7A
        LD (0A509h),A                                                                                 ; AA5C: 32 09 A5

WORLD_BLOCK_AA5F:
        LD A,(0A508h)                                                                                 ; AA5F: 3A 08 A5
        CP 01h                                                                                       ; AA62: FE 01
        JP Z,WORLD_BLOCK_AA76                                                                                   ; AA64: CA 76 AA
        CP 02h                                                                                       ; AA67: FE 02
        JP Z,WORLD_BLOCK_AA76                                                                                   ; AA69: CA 76 AA
        LD A,E                                                                                       ; AA6C: 7B
        CP 0E6h                                                                                       ; AA6D: FE E6
        JR C,WORLD_BLOCK_AA76                                                                                   ; AA6F: 38 05
        LD A,01h                                                                                     ; AA71: 3E 01
        LD (0A508h),A                                                                                 ; AA73: 32 08 A5

WORLD_BLOCK_AA76:
        LD A,(0A508h)                                                                                 ; AA76: 3A 08 A5
        CP 04h                                                                                       ; AA79: FE 04
        JP Z,WORLD_BLOCK_AA8D                                                                                   ; AA7B: CA 8D AA
        CP 05h                                                                                       ; AA7E: FE 05
        JP Z,WORLD_BLOCK_AA8D                                                                                   ; AA80: CA 8D AA
        LD A,E                                                                                       ; AA83: 7B
        CP 08h                                                                                       ; AA84: FE 08
        JR NC,WORLD_BLOCK_AA8D                                                                                  ; AA86: 30 05
        LD A,04h                                                                                     ; AA88: 3E 04
        LD (0A508h),A                                                                                 ; AA8A: 32 08 A5

WORLD_BLOCK_AA8D:
        LD (IX+0),D                                                                                  ; AA8D: DD 72 00
        LD (IX+1),E                                                                                  ; AA90: DD 73 01
        LD A,L                                                                                       ; AA93: 7D
        XOR 80h                                                                                      ; AA94: EE 80
        LD L,A                                                                                       ; AA96: 6F
        CALL 0589Eh                                                                                                  ; AA97: INV_ROW_ATOMIC_ENTRY

WORLD_LOOP_AA9A:
        LD HL,(0A502h)                                                                                ; AA9A: 2A 02 A5
        INC HL                                                                                       ; AA9D: 23
        INC HL                                                                                       ; AA9E: 23
        LD (0A502h),HL                                                                                ; AA9F: 22 02 A5
        LD HL,0A505h                                                                                  ; AAA2: 21 05 A5
        INC (HL)                                                                                     ; AAA5: 34
        LD A,07h                                                                                     ; AAA6: 3E 07
        CP (HL)                                                                                      ; AAA8: BE
        RET NC                                                                                       ; AAA9: D0
        LD (HL),00h                                                                                  ; AAAA: 36 00
        LD HL,0A504h                                                                                  ; AAAC: 21 04 A5
        INC (HL)                                                                                     ; AAAF: 34
        LD A,04h                                                                                     ; AAB0: 3E 04
        CP (HL)                                                                                      ; AAB2: BE
        RET NC                                                                                       ; AAB3: D0
        LD HL,0A502h                                                                                  ; AAB4: 21 02 A5
        LD (HL),00h                                                                                  ; AAB7: 36 00
        LD A,00h                                                                                     ; AAB9: 3E 00
        LD (0A505h),A                                                                                 ; AABB: 32 05 A5
        LD (0A504h),A                                                                                 ; AABE: 32 04 A5
        LD A,(0A500h)                                                                                 ; AAC1: 3A 00 A5
        XOR 80h                                                                                      ; AAC4: EE 80
        LD (0A500h),A                                                                                 ; AAC6: 32 00 A5
        LD A,(0A508h)                                                                                 ; AAC9: 3A 08 A5
        CP 01h                                                                                       ; AACC: FE 01
        JR NZ,WORLD_BLOCK_AAE3                                                                                  ; AACE: 20 13
        LD A,08h                                                                                     ; AAD0: 3E 08
        LD (0A507h),A                                                                                 ; AAD2: 32 07 A5
        LD A,00h                                                                                     ; AAD5: 3E 00
        LD (0A506h),A                                                                                 ; AAD7: 32 06 A5
        LD A,02h                                                                                     ; AADA: 3E 02
        LD (0A508h),A                                                                                 ; AADC: 32 08 A5
        CALL REFRESH_SCREEN_STRIP                                                                                   ; AADF: CD 38 AB
        RET                                                                                          ; AAE2: C9

WORLD_BLOCK_AAE3:
        LD A,(0A508h)                                                                                 ; AAE3: 3A 08 A5
        CP 02h                                                                                       ; AAE6: FE 02
        JR NZ,WORLD_BLOCK_AAFD                                                                                  ; AAE8: 20 13
        LD A,00h                                                                                     ; AAEA: 3E 00
        LD (0A507h),A                                                                                 ; AAEC: 32 07 A5
        LD A,(0A512h)                                                                                 ; AAEF: 3A 12 A5
        NEG                                                                                          ; AAF2: ED 44
        LD (0A506h),A                                                                                 ; AAF4: 32 06 A5
        LD A,03h                                                                                     ; AAF7: 3E 03
        LD (0A508h),A                                                                                 ; AAF9: 32 08 A5
        RET                                                                                          ; AAFC: C9

WORLD_BLOCK_AAFD:
        LD A,(0A508h)                                                                                 ; AAFD: 3A 08 A5
        CP 04h                                                                                       ; AB00: FE 04
        JR NZ,WORLD_BLOCK_AB17                                                                                  ; AB02: 20 13
        LD A,08h                                                                                     ; AB04: 3E 08
        LD (0A507h),A                                                                                 ; AB06: 32 07 A5
        LD A,00h                                                                                     ; AB09: 3E 00
        LD (0A506h),A                                                                                 ; AB0B: 32 06 A5
        LD A,05h                                                                                     ; AB0E: 3E 05
        LD (0A508h),A                                                                                 ; AB10: 32 08 A5
        CALL REFRESH_SCREEN_STRIP                                                                                   ; AB13: CD 38 AB
        RET                                                                                          ; AB16: C9

WORLD_BLOCK_AB17:
        LD A,(0A508h)                                                                                 ; AB17: 3A 08 A5
        CP 05h                                                                                       ; AB1A: FE 05
        JR NZ,WORLD_RETURN_AB2F                                                                                  ; AB1C: 20 11
        LD A,00h                                                                                     ; AB1E: 3E 00
        LD (0A507h),A                                                                                 ; AB20: 32 07 A5
        LD A,(0A512h)                                                                                 ; AB23: 3A 12 A5
        LD (0A506h),A                                                                                 ; AB26: 32 06 A5
        LD A,00h                                                                                     ; AB29: 3E 00
        LD (0A508h),A                                                                                 ; AB2B: 32 08 A5
        RET                                                                                          ; AB2E: C9

WORLD_RETURN_AB2F:
        RET                                                                                          ; AB2F: C9

WORLD_BLOCK_AB30:
        LD HL,0AA22h                                                                                  ; AB30: 21 22 AA
        PUSH HL                                                                                      ; AB33: E5
        JP WORLD_LOOP_AA9A                                                                                     ; AB34: C3 9A AA
        RET                                                                                          ; AB37: C9

REFRESH_SCREEN_STRIP:
        LD A,(0A509h)                                                                                 ; AB38: 3A 09 A5
        CP 0D0h                                                                                       ; AB3B: FE D0
        RET NC                                                                                       ; AB3D: D0
        CALL REDRAW_PROJECTILE_AND_POOL                                                                                   ; AB3E: CD 50 AB
        LD A,(0A509h)                                                                                 ; AB41: 3A 09 A5
        ADD A,10h                                                                                    ; AB44: C6 10
        LD B,A                                                                                       ; AB46: 47
        LD C,08h                                                                                     ; AB47: 0E 08
        CALL CLEAR_MODE3_ROWS                                                                                   ; AB49: CD 00 A8
        CALL REDRAW_PROJECTILE_AND_POOL                                                                                   ; AB4C: CD 50 AB
        RET                                                                                          ; AB4F: C9

REDRAW_PROJECTILE_AND_POOL:
        LD HL,8280h                                                                                  ; AB50: 21 80 82
        LD IX,0A200h                                                                                  ; AB53: DD 21 00 A2
        LD D,(IX+0)                                                                                  ; AB57: DD 56 00
        LD E,(IX+1)                                                                                  ; AB5A: DD 5E 01
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AB5D: CD 00 AD
        LD B,08h                                                                                     ; AB60: 06 08
        LD IX,0A230h                                                                                  ; AB62: DD 21 30 A2
        LD HL,8300h                                                                                  ; AB66: 21 00 83

WORLD_LOOP_AB69:
        LD D,(IX+0)                                                                                  ; AB69: DD 56 00
        LD E,(IX+1)                                                                                  ; AB6C: DD 5E 01
        INC IX                                                                                       ; AB6F: DD 23
        INC IX                                                                                       ; AB71: DD 23
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AB73: CD 00 AD
        DEC B                                                                                        ; AB76: 05
        JP NZ,WORLD_LOOP_AB69                                                                                  ; AB77: C2 69 AB
        RET                                                                                          ; AB7A: C9
