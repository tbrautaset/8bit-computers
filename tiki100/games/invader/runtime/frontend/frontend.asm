; ============================================================================
; Title, options and hardware setup
; Original range B2A0h-B51Ah (635 bytes)
; SHA-256 ee8b57c6f38c7734f76390474611954e17965d8b164ed54072ea63332a74656a
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

TITLE_SCREEN:
        CALL LOAD_HARDWARE_TABLE                                                                                   ; B2A0: CD 0B B5
        LD A,00h                                                                                     ; B2A3: 3E 00
        LD B,0Fh                                                                                     ; B2A5: 06 0F
        CALL HARDWARE_REGISTER_WRITE                                                                                   ; B2A7: CD F4 B4
        LD A,01h                                                                                     ; B2AA: 3E 01
        CALL TERMINAL_SERVICE_F00C                         ; console/screen output                                   ; B2AC: CD 0C F0
        LD BC,0000h                        ; CP/M warm return / restart                              ; B2AF: 01 00 00
        CALL CLEAR_MODE3_ROWS                                                                                   ; B2B2: CD 00 A8
        LD HL,9D00h                                                                                  ; B2B5: 21 00 9D
        LD D,01h                                                                                     ; B2B8: 16 01
        LD E,1Eh                                                                                     ; B2BA: 1E 1E

FRONTEND_LOOP_B2BC:
        CALL DRAW_SPRITE_SAFE                                                                                   ; B2BC: CD 1E A8
        LD BC,0080h                                                                                  ; B2BF: 01 80 00
        ADD HL,BC                                                                                    ; B2C2: 09
        LD A,E                                                                                       ; B2C3: 7B
        ADD A,10h                                                                                    ; B2C4: C6 10
        LD E,A                                                                                       ; B2C6: 5F
        PUSH HL                                                                                      ; B2C7: E5
        LD BC,0A200h                                                                                  ; B2C8: 01 00 A2
        AND A                                                                                        ; B2CB: A7
        SBC HL,BC                                                                                    ; B2CC: ED 42
        POP HL                                                                                       ; B2CE: E1
        JP NZ,FRONTEND_LOOP_B2BC                                                                                  ; B2CF: C2 BC B2
        LD BC,026Ah                                                                                  ; B2D2: 01 6A 02
        LD HL,0B820h                                                                                  ; B2D5: 21 20 B8

FRONTEND_LOOP_B2D8:
        PUSH HL                                                                                      ; B2D8: E5
        PUSH BC                                                                                      ; B2D9: C5
        LD A,(HL)                                                                                    ; B2DA: 7E
        CALL TERMINAL_SERVICE_F00C                         ; console/screen output                                   ; B2DB: CD 0C F0
        POP BC                                                                                       ; B2DE: C1
        POP HL                                                                                       ; B2DF: E1
        CPI                                                                                          ; B2E0: ED A1
        JP PE,FRONTEND_LOOP_B2D8                                                                                  ; B2E2: EA D8 B2
        LD HL,8080h                                                                                  ; B2E5: 21 80 80
        LD DE,0F022h                                                                                  ; B2E8: 11 22 F0
        CALL DRAW_SPRITE_SAFE                                                                                   ; B2EB: CD 1E A8

FRONTEND_LOOP_B2EE:
        CALL 05880h                                                                                   ; B2EE: R0 intro-only controller
        JP   0B318h                                                                                   ; B2F1: original GAME_INITIALIZE
        NOP                                                                                           ; B2F4
        NOP                                                                                           ; B2F5
        NOP                                                                                           ; B2F6
        NOP                                                                                           ; B2F7
        NOP                                                                                           ; B2F8
        NOP                                                                                           ; B2F9
        NOP                                                                                           ; B2FA
        NOP                                                                                           ; B2FB

FRONTEND_LOOP_B2FC:
        LD HL,0A50Fh                                                                                  ; B2FC: 21 0F A5
        INC (HL)                                                                                     ; B2FF: 34
        DI                                 ; disable interrupts                                      ; B300: F3
        OUT (00h),A                                                                                  ; B301: D3 00
        IN A,(00h)                                                                                   ; B303: DB 00
        IN A,(00h)                                                                                   ; B305: DB 00
        CP 0F7h                                                                                       ; B307: FE F7
        EI                                 ; enable interrupts                                       ; B309: FB
        JP Z,OPTIONS_MENU                                                                                   ; B30A: CA 3D B3
        DI                                 ; disable interrupts                                      ; B30D: F3
        OUT (00h),A                                                                                  ; B30E: D3 00
        IN A,(00h)                                                                                   ; B310: DB 00
        CP 0FFh                                                                                       ; B312: FE FF
        EI                                 ; enable interrupts                                       ; B314: FB
        JP Z,FRONTEND_EPILOGUE_B339                                                                                   ; B315: CA 39 B3
        CALL 0588Ch                                                                                   ; B318: R2A game-start wrapper
        JP   05886h                                                                                   ; B31B: R2A complete game-over flow
        CALL SOUND_AND_STATE_RESET                                                                                   ; B31E: CD 12 B0

FRONTEND_LOOP_B321:
        DI                                 ; disable interrupts                                      ; B321: F3
        OUT (00h),A                                                                                  ; B322: D3 00
        IN A,(00h)                                                                                   ; B324: DB 00
        CP 0FFh                                                                                       ; B326: FE FF
        JP NZ,FRONTEND_LOOP_B321                                                                                  ; B328: C2 21 B3

FRONTEND_LOOP_B32B:
        DI                                 ; disable interrupts                                      ; B32B: F3
        OUT (00h),A                                                                                  ; B32C: D3 00
        IN A,(00h)                                                                                   ; B32E: DB 00
        CP 0FFh                                                                                       ; B330: FE FF
        JP Z,FRONTEND_LOOP_B32B                                                                                   ; B332: CA 2B B3
        EI                                 ; enable interrupts                                       ; B335: FB
        JP TITLE_SCREEN                                                                                     ; B336: C3 A0 B2

FRONTEND_EPILOGUE_B339:
        EI                                 ; enable interrupts                                       ; B339: FB
        JP FRONTEND_LOOP_B2FC                                                                                     ; B33A: C3 FC B2

OPTIONS_MENU:
        EI                                 ; enable interrupts                                       ; B33D: FB
        LD BC,0000h                        ; CP/M warm return / restart                              ; B33E: 01 00 00
        CALL CLEAR_MODE3_ROWS                                                                                   ; B341: CD 00 A8
        LD BC,01D7h                                                                                  ; B344: 01 D7 01
        LD HL,0BB00h                                                                                  ; B347: 21 00 BB

FRONTEND_LOOP_B34A:
        PUSH HL                                                                                      ; B34A: E5
        PUSH BC                                                                                      ; B34B: C5
        LD A,(HL)                                                                                    ; B34C: 7E
        CALL TERMINAL_SERVICE_F00C                         ; console/screen output                                   ; B34D: CD 0C F0
        POP BC                                                                                       ; B350: C1
        POP HL                                                                                       ; B351: E1
        CPI                                                                                          ; B352: ED A1
        JP PE,FRONTEND_LOOP_B34A                                                                                  ; B354: EA 4A B3
        LD IX,0A20Ah                                                                                  ; B357: DD 21 0A A2
        LD D,88h                                                                                     ; B35B: 16 88
        LD E,0DAh                                                                                     ; B35D: 1E DA
        LD HL,9800h                                                                                  ; B35F: 21 00 98
        CALL DRAW_SPRITE_SAFE                                                                                   ; B362: CD 1E A8
        LD (IX+0),D                                                                                  ; B365: DD 72 00
        LD (IX+1),E                                                                                  ; B368: DD 73 01
        DB      0DDh,74h,02h      ; B36B: DD 74 02  exact IXH/IXL opcode
        DB      0DDh,75h,03h      ; B36E: DD 75 03  exact IXH/IXL opcode
        PUSH IX                                                                                      ; B371: DD E5
        POP HL                                                                                       ; B373: E1
        LD A,(0A523h)                                                                                 ; B374: 3A 23 A5
        CALL OBJECT_SELECT_FRAME                                                                                   ; B377: CD D7 A9
        LD IX,0A20Eh                                                                                  ; B37A: DD 21 0E A2
        LD D,0B6h                                                                                     ; B37E: 16 B6
        LD E,50h                                                                                     ; B380: 1E 50
        LD HL,9800h                                                                                  ; B382: 21 00 98
        CALL DRAW_SPRITE_SAFE                                                                                   ; B385: CD 1E A8
        LD (IX+0),D                                                                                  ; B388: DD 72 00
        LD (IX+1),E                                                                                  ; B38B: DD 73 01
        DB      0DDh,74h,02h      ; B38E: DD 74 02  exact IXH/IXL opcode
        DB      0DDh,75h,03h      ; B391: DD 75 03  exact IXH/IXL opcode
        PUSH IX                                                                                      ; B394: DD E5
        POP HL                                                                                       ; B396: E1
        LD A,(0A522h)                                                                                 ; B397: 3A 22 A5
        CALL OBJECT_SELECT_FRAME                                                                                   ; B39A: CD D7 A9
        LD IX,0A216h                                                                                  ; B39D: DD 21 16 A2
        LD D,0CAh                                                                                     ; B3A1: 16 CA
        LD E,70h                                                                                     ; B3A3: 1E 70
        LD B,05h                                                                                     ; B3A5: 06 05

FRONTEND_LOOP_B3A7:
        LD (IX+0),D                                                                                  ; B3A7: DD 72 00
        LD (IX+1),E                                                                                  ; B3AA: DD 73 01
        DB      0DDh,66h,02h      ; B3AD: DD 66 02  exact IXH/IXL opcode
        DB      0DDh,6Eh,03h      ; B3B0: DD 6E 03  exact IXH/IXL opcode
        INC IX                                                                                       ; B3B3: DD 23
        INC IX                                                                                       ; B3B5: DD 23
        INC IX                                                                                       ; B3B7: DD 23
        INC IX                                                                                       ; B3B9: DD 23
        CALL DRAW_SPRITE_SAFE                                                                                   ; B3BB: CD 1E A8
        LD A,E                                                                                       ; B3BE: 7B
        ADD A,10h                                                                                    ; B3BF: C6 10
        LD E,A                                                                                       ; B3C1: 5F
        DEC B                                                                                        ; B3C2: 05
        JP NZ,FRONTEND_LOOP_B3A7                                                                                  ; B3C3: C2 A7 B3
        LD IX,0A22Ah                                                                                  ; B3C6: DD 21 2A A2
        LD B,05h                                                                                     ; B3CA: 06 05

FRONTEND_LOOP_B3CC:
        LD D,(IX+0)                                                                                  ; B3CC: DD 56 00
        LD E,(IX+1)                                                                                  ; B3CF: DD 5E 01
        DB      0DDh,66h,02h      ; B3D2: DD 66 02  exact IXH/IXL opcode
        DB      0DDh,6Eh,03h      ; B3D5: DD 6E 03  exact IXH/IXL opcode
        INC IX                                                                                       ; B3D8: DD 23
        INC IX                                                                                       ; B3DA: DD 23
        INC IX                                                                                       ; B3DC: DD 23
        INC IX                                                                                       ; B3DE: DD 23
        CALL DRAW_SPRITE_SAFE                                                                                   ; B3E0: CD 1E A8
        DEC B                                                                                        ; B3E3: 05
        JP NZ,FRONTEND_LOOP_B3CC                                                                                  ; B3E4: C2 CC B3
        JP FRONTEND_LOOP_B430                                                                                     ; B3E7: C3 30 B4

FRONTEND_BLOCK_B3EA:
        LD IX,0A216h                                                                                  ; B3EA: DD 21 16 A2
        LD B,05h                                                                                     ; B3EE: 06 05

FRONTEND_LOOP_B3F0:
        DB      0DDh,66h,02h      ; B3F0: DD 66 02  exact IXH/IXL opcode
        DB      0DDh,6Eh,03h      ; B3F3: DD 6E 03  exact IXH/IXL opcode
        LD D,(IX+22)                                                                                 ; B3F6: DD 56 16
        LD E,(IX+23)                                                                                 ; B3F9: DD 5E 17
        INC IX                                                                                       ; B3FC: DD 23
        INC IX                                                                                       ; B3FE: DD 23
        INC IX                                                                                       ; B400: DD 23
        INC IX                                                                                       ; B402: DD 23
        AND A                                                                                        ; B404: A7
        SBC HL,DE                                                                                    ; B405: ED 52
        JP NZ,FRONTEND_BLOCK_B40E                                                                                  ; B407: C2 0E B4
        DEC B                                                                                        ; B40A: 05
        JP NZ,FRONTEND_LOOP_B3F0                                                                                  ; B40B: C2 F0 B3

FRONTEND_BLOCK_B40E:
        JP M,FRONTEND_RETURN_B42F                                                                                   ; B40E: FA 2F B4
        LD IX,0A216h                                                                                  ; B411: DD 21 16 A2
        LD B,05h                                                                                     ; B415: 06 05

FRONTEND_LOOP_B417:
        DB      0DDh,66h,02h      ; B417: DD 66 02  exact IXH/IXL opcode
        DB      0DDh,6Eh,03h      ; B41A: DD 6E 03  exact IXH/IXL opcode
        DB      0DDh,74h,16h      ; B41D: DD 74 16  exact IXH/IXL opcode
        DB      0DDh,75h,17h      ; B420: DD 75 17  exact IXH/IXL opcode
        INC IX                                                                                       ; B423: DD 23
        INC IX                                                                                       ; B425: DD 23
        INC IX                                                                                       ; B427: DD 23
        INC IX                                                                                       ; B429: DD 23
        DEC B                                                                                        ; B42B: 05
        JP NZ,FRONTEND_LOOP_B417                                                                                  ; B42C: C2 17 B4

FRONTEND_RETURN_B42F:
        RET                                                                                          ; B42F: C9

FRONTEND_LOOP_B430:
        DI                                 ; disable interrupts                                      ; B430: F3
        OUT (00h),A                                                                                  ; B431: D3 00
        IN A,(00h)                                                                                   ; B433: DB 00
        IN A,(00h)                                                                                   ; B435: DB 00
        IN A,(00h)                                                                                   ; B437: DB 00
        EI                                 ; enable interrupts                                       ; B439: FB
        CP 0FFh                                                                                       ; B43A: FE FF
        CALL NZ,FRONTEND_BLOCK_B464                                                                                ; B43C: C4 64 B4
        DI                                 ; disable interrupts                                      ; B43F: F3
        OUT (00h),A                                                                                  ; B440: D3 00
        IN A,(00h)                                                                                   ; B442: DB 00
        IN A,(00h)                                                                                   ; B444: DB 00
        IN A,(00h)                                                                                   ; B446: DB 00
        IN A,(00h)                                                                                   ; B448: DB 00
        IN A,(00h)                                                                                   ; B44A: DB 00
        EI                                 ; enable interrupts                                       ; B44C: FB
        CP 0FFh                                                                                       ; B44D: FE FF
        CALL NZ,FRONTEND_BLOCK_B4BC                                                                                ; B44F: C4 BC B4
        DI                                 ; disable interrupts                                      ; B452: F3
        OUT (00h),A                                                                                  ; B453: D3 00
        IN A,(00h)                                                                                   ; B455: DB 00
        EI                                 ; enable interrupts                                       ; B457: FB
        CP 0FFh                                                                                       ; B458: FE FF
        JP NZ,FRONTEND_EPILOGUE_B460                                                                                  ; B45A: C2 60 B4
        JP FRONTEND_LOOP_B430                                                                                     ; B45D: C3 30 B4

FRONTEND_EPILOGUE_B460:
        EI                                 ; enable interrupts                                       ; B460: FB
        JP TITLE_SCREEN                                                                                     ; B461: C3 A0 B2

FRONTEND_BLOCK_B464:
        LD A,(0A523h)                                                                                 ; B464: 3A 23 A5
        INC A                                                                                        ; B467: 3C
        LD (0A523h),A                                                                                 ; B468: 32 23 A5
        LD A,01h                                                                                     ; B46B: 3E 01
        LD HL,0A20Ah                                                                                  ; B46D: 21 0A A2
        CALL OBJECT_SELECT_FRAME                                                                                   ; B470: CD D7 A9
        LD A,(0A523h)                                                                                 ; B473: 3A 23 A5
        CP 06h                                                                                       ; B476: FE 06
        JP C,FRONTEND_BLOCK_B48D                                                                                   ; B478: DA 8D B4
        LD HL,0A20Ah                                                                                  ; B47B: 21 0A A2
        LD A,(0A523h)                                                                                 ; B47E: 3A 23 A5
        SUB 05h                                                                                      ; B481: D6 05
        LD (0A523h),A                                                                                 ; B483: 32 23 A5
        LD A,00h                                                                                     ; B486: 3E 00
        SUB 05h                                                                                      ; B488: D6 05
        CALL OBJECT_SELECT_FRAME                                                                                   ; B48A: CD D7 A9

FRONTEND_BLOCK_B48D:
        LD A,(0A523h)                                                                                 ; B48D: 3A 23 A5
        LD C,A                                                                                       ; B490: 4F
        LD B,00h                                                                                     ; B491: 06 00
        LD HL,0B80Fh                                                                                  ; B493: 21 0F B8
        ADD HL,BC                                                                                    ; B496: 09
        LD A,(HL)                                                                                    ; B497: 7E
        LD (0A521h),A                                                                                 ; B498: 32 21 A5
        LD A,01h                                                                                     ; B49B: 3E 01
        LD (0A520h),A                                                                                 ; B49D: 32 20 A5

FRONTEND_LOOP_B4A0:
        DI                                 ; disable interrupts                                      ; B4A0: F3
        OUT (00h),A                                                                                  ; B4A1: D3 00
        IN A,(00h)                                                                                   ; B4A3: DB 00
        IN A,(00h)                                                                                   ; B4A5: DB 00
        IN A,(00h)                                                                                   ; B4A7: DB 00
        EI                                 ; enable interrupts                                       ; B4A9: FB
        CP 0FFh                                                                                       ; B4AA: FE FF
        JP NZ,FRONTEND_LOOP_B4A0                                                                                  ; B4AC: C2 A0 B4
        LD B,00h                                                                                     ; B4AF: 06 00

FRONTEND_LOOP_B4B1:
        LD A,(IX+8)                                                                                  ; B4B1: DD 7E 08
        LD A,(IX+8)                                                                                  ; B4B4: DD 7E 08
        DEC B                                                                                        ; B4B7: 05
        JP NZ,FRONTEND_LOOP_B4B1                                                                                  ; B4B8: C2 B1 B4
        RET                                                                                          ; B4BB: C9

FRONTEND_BLOCK_B4BC:
        LD D,0B6h                                                                                     ; B4BC: 16 B6
        LD E,50h                                                                                     ; B4BE: 1E 50
        LD HL,9800h                                                                                  ; B4C0: 21 00 98
        CALL DRAW_SPRITE_SAFE                                                                                   ; B4C3: CD 1E A8
        LD HL,9880h                                                                                  ; B4C6: 21 80 98
        CALL DRAW_SPRITE_SAFE                                                                                   ; B4C9: CD 1E A8
        LD A,(0A522h)                                                                                 ; B4CC: 3A 22 A5
        XOR 01h                                                                                      ; B4CF: EE 01
        LD (0A522h),A                                                                                 ; B4D1: 32 22 A5

FRONTEND_LOOP_B4D4:
        DI                                 ; disable interrupts                                      ; B4D4: F3
        OUT (00h),A                                                                                  ; B4D5: D3 00
        IN A,(00h)                                                                                   ; B4D7: DB 00
        IN A,(00h)                                                                                   ; B4D9: DB 00
        IN A,(00h)                                                                                   ; B4DB: DB 00
        IN A,(00h)                                                                                   ; B4DD: DB 00
        IN A,(00h)                                                                                   ; B4DF: DB 00
        EI                                 ; enable interrupts                                       ; B4E1: FB
        CP 0FFh                                                                                       ; B4E2: FE FF
        JP NZ,FRONTEND_LOOP_B4D4                                                                                  ; B4E4: C2 D4 B4
        LD B,00h                                                                                     ; B4E7: 06 00

FRONTEND_LOOP_B4E9:
        LD A,(IX+8)                                                                                  ; B4E9: DD 7E 08
        LD A,(IX+8)                                                                                  ; B4EC: DD 7E 08
        DEC B                                                                                        ; B4EF: 05
        JP NZ,FRONTEND_LOOP_B4E9                                                                                  ; B4F0: C2 E9 B4
        RET                                                                                          ; B4F3: C9

HARDWARE_REGISTER_WRITE:
        DI                                 ; disable interrupts                                      ; B4F4: F3
        OUT (14h),A                                                                                  ; B4F5: D3 14
        OUT (14h),A                                                                                  ; B4F7: D3 14
        LD A,B                                                                                       ; B4F9: 78
        ADD A,0B0h                                                                                    ; B4FA: C6 B0
        OUT (0Ch),A                                                                                  ; B4FC: D3 0C
        LD C,00h                                                                                     ; B4FE: 0E 00

FRONTEND_LOOP_B500:
        DEC C                                                                                        ; B500: 0D
        JP NZ,FRONTEND_LOOP_B500                                                                                  ; B501: C2 00 B5
        LD A,B                                                                                       ; B504: 78
        ADD A,30h                                                                                    ; B505: C6 30
        OUT (0Ch),A                                                                                  ; B507: D3 0C
        EI                                 ; enable interrupts                                       ; B509: FB
        RET                                                                                          ; B50A: C9

LOAD_HARDWARE_TABLE:
        LD HL,0BF0Fh                                                                                  ; B50B: 21 0F BF
        LD D,0Fh                                                                                     ; B50E: 16 0F

FRONTEND_LOOP_B510:
        LD B,D                                                                                       ; B510: 42
        LD A,(HL)                                                                                    ; B511: 7E
        CALL HARDWARE_REGISTER_WRITE                                                                                   ; B512: CD F4 B4
        DEC HL                                                                                       ; B515: 2B
        DEC D                                                                                        ; B516: 15
        JP P,FRONTEND_LOOP_B510                                                                                   ; B517: F2 10 B5
        RET                                                                                          ; B51A: C9
