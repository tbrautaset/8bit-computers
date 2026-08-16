; ============================================================================
; Game initialization and main loop
; Original range B173h-B29Fh (301 bytes)
; SHA-256 b40cc52500d8bd190eb198178a1eca1adfcc6bb4e1ef30375245e58f2b7ce1d5
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

GAME_INITIALIZE:
        CALL LOAD_HARDWARE_TABLE                                                                                   ; B173: CD 0B B5
        CALL SOUND_AND_STATE_RESET                                                                                   ; B176: CD 12 B0
        LD A,00h                                                                                     ; B179: 3E 00
        LD (0A501h),A                                                                                 ; B17B: 32 01 A5
        LD B,0Ah                                                                                     ; B17E: 06 0A
        LD HL,0A22Ah                                                                                  ; B180: 21 2A A2

GAME_LOOP_B183:
        LD E,(HL)                                                                                    ; B183: 5E
        INC HL                                                                                       ; B184: 23
        LD D,(HL)                                                                                    ; B185: 56
        INC HL                                                                                       ; B186: 23
        PUSH DE                                                                                      ; B187: D5
        DEC B                                                                                        ; B188: 05
        JP NZ,GAME_LOOP_B183                                                                                  ; B189: C2 83 B1
        PUSH HL                                                                                      ; B18C: E5
        CALL WORLD_INITIALIZE_OR_REDRAW                                                                                   ; B18D: CD 38 A8
        LD A,(0A523h)                                                                                 ; B190: 3A 23 A5
        LD HL,0A226h                                                                                  ; B193: 21 26 A2
        CALL OBJECT_SELECT_FRAME                                                                                   ; B196: CD D7 A9
        LD A,0FFh                                                                                     ; B199: 3E FF
        LD (0A51Fh),A                                                                                 ; B19B: 32 1F A5

GAME_MAIN_LOOP:
        CALL 05883h                                                                                   ; B19E: CLEAN P/Q/G gate
        CALL UPDATE_PLAYER_MOVEMENT                                                                                   ; B1A1: CD 7B AB
        CALL UPDATE_PLAYER_PROJECTILE                                                                                   ; B1A4: CD C5 AB
        LD HL,(0A520h)                                                                                ; B1A7: 2A 20 A5
        LD BC,0001h                                                                                  ; B1AA: 01 01 00

GAME_LOOP_B1AD:
        AND A                                                                                        ; B1AD: A7
        SBC HL,BC                                                                                    ; B1AE: ED 42
        JP NZ,GAME_LOOP_B1AD                                                                                  ; B1B0: C2 AD B1
        CALL UPDATE_PLAYER_PROJECTILE                                                                                   ; B1B3: CD C5 AB
        CALL UPDATE_ENEMY_POOL                                                                                   ; B1B6: CD 40 AE
        CALL UPDATE_COLLISIONS                                                                                   ; B1B9: CD 34 AF
        CALL UPDATE_SOUND_SEQUENCE                                                                                   ; B1BC: CD 90 B0
        LD A,(0A511h)                                                                                 ; B1BF: 3A 11 A5
        CP 00h                                                                                       ; B1C2: FE 00
        JP NZ,GAME_BLOCK_B1CE                                                                                  ; B1C4: C2 CE B1
        LD A,(0A51Fh)                                                                                 ; B1C7: 3A 1F A5
        DEC A                                                                                        ; B1CA: 3D
        LD (0A51Fh),A                                                                                 ; B1CB: 32 1F A5

GAME_BLOCK_B1CE:
        LD A,(0A51Fh)                                                                                 ; B1CE: 3A 1F A5
        CP 00h                                                                                       ; B1D1: FE 00
        JP NZ,GAME_BLOCK_B1EA                                                                                  ; B1D3: C2 EA B1
        LD HL,0A501h                                                                                  ; B1D6: original level progression
        INC (HL)                                                                                     ; B1D9
        LD A,(0A501h)                                                                                 ; B1DA: 3A 01 A5
        CP 0Ch                                                                                       ; B1DD: FE 0C
        CALL Z,TAIL_BLOCK_B51B                                                                                 ; B1DF: CC 1B B5
        CALL WORLD_INITIALIZE_OR_REDRAW                                                                                   ; B1E2: CD 38 A8
        LD A,0FFh                                                                                     ; B1E5: 3E FF
        LD (0A51Fh),A                                                                                 ; B1E7: 32 1F A5

GAME_BLOCK_B1EA:
        LD A,(0A513h)                                                                                 ; B1EA: 3A 13 A5
        CP 00h                                                                                       ; B1ED: FE 00
        CALL NZ,GAME_ROUND_TRANSITION                                                                                ; B1EF: C4 F5 B1
        JP GAME_MAIN_LOOP                                                                                     ; B1F2: C3 9E B1

GAME_ROUND_TRANSITION:
        LD A,0FFh                                                                                     ; B1F5: 3E FF
        LD HL,0A212h                                                                                  ; B1F7: 21 12 A2
        CALL OBJECT_SELECT_FRAME                                                                                   ; B1FA: CD D7 A9
        LD A,00h                                                                                     ; B1FD: 3E 00
        LD (0A513h),A                                                                                 ; B1FF: 32 13 A5
        LD HL,8200h                                                                                  ; B202: 21 00 82
        LD BC,8480h                                                                                  ; B205: 01 80 84
        CALL DRAW_TRANSITION_FRAME                                                                                   ; B208: CD 56 B2
        LD HL,8480h                                                                                  ; B20B: 21 80 84
        LD BC,8500h                                                                                  ; B20E: 01 00 85
        CALL DRAW_TRANSITION_FRAME                                                                                   ; B211: CD 56 B2
        LD HL,8500h                                                                                  ; B214: 21 00 85
        LD BC,8580h                                                                                  ; B217: 01 80 85
        CALL DRAW_TRANSITION_FRAME                                                                                   ; B21A: CD 56 B2
        LD HL,8580h                                                                                  ; B21D: 21 80 85
        LD BC,8600h                                                                                  ; B220: 01 00 86
        CALL DRAW_TRANSITION_FRAME                                                                                   ; B223: CD 56 B2
        LD HL,8600h                                                                                  ; B226: 21 00 86
        LD BC,8680h                                                                                  ; B229: 01 80 86
        CALL DRAW_TRANSITION_FRAME                                                                                   ; B22C: CD 56 B2
        LD HL,8680h                                                                                  ; B22F: 21 80 86
        LD BC,8200h                                                                                  ; B232: 01 00 82
        CALL DRAW_TRANSITION_FRAME                                                                                   ; B235: CD 56 B2
        LD HL,(0A214h)                                                                                ; B238: 2A 14 A2
        LD BC,9800h                                                                                  ; B23B: 01 00 98
        LD A,H                                                                                       ; B23E: 7C
        LD H,L                                                                                       ; B23F: 65
        LD L,A                                                                                       ; B240: 6F
        AND A                                                                                        ; B241: A7
        SBC HL,BC                                                                                    ; B242: ED 42
        JP NZ,GAME_RETURN_B255                                                                                  ; B244: C2 55 B2

GAME_EPILOGUE_B247:
        POP AF                                                                                       ; B247: F1
        LD B,0Ah                                                                                     ; B248: 06 0A
        POP HL                                                                                       ; B24A: E1

GAME_LOOP_B24B:
        POP DE                                                                                       ; B24B: D1
        DEC HL                                                                                       ; B24C: 2B
        LD (HL),D                                                                                    ; B24D: 72
        DEC HL                                                                                       ; B24E: 2B
        LD (HL),E                                                                                    ; B24F: 73
        DEC B                                                                                        ; B250: 05
        JP NZ,GAME_LOOP_B24B                                                                                  ; B251: C2 4B B2
        RET                                                                                          ; B254: C9

GAME_RETURN_B255:
        RET                                                                                          ; B255: C9

DRAW_TRANSITION_FRAME:
        LD IX,0A206h                                                                                  ; B256: DD 21 06 A2
        LD D,(IX+0)                                                                                  ; B25A: DD 56 00
        LD E,(IX+1)                                                                                  ; B25D: DD 5E 01
        CALL DRAW_SPRITE_SAFE                                                                                   ; B260: CD 1E A8
        LD H,B                                                                                       ; B263: 60
        LD L,C                                                                                       ; B264: 69
        CALL DRAW_SPRITE_SAFE                                                                                   ; B265: CD 1E A8
        LD B,40h                                                                                     ; B268: 06 40

GAME_LOOP_B26A:
        LD A,(0A522h)                                                                                 ; B26A: 3A 22 A5
        CP 00h                                                                                       ; B26D: FE 00
        JP NZ,GAME_LOOP_B28E                                                                                  ; B26F: C2 8E B2
        CALL RANDOM_BYTE                                                                                   ; B272: CD F5 AD
        LD D,00h                                                                                     ; B275: 16 00
        LD E,A                                                                                       ; B277: 5F
        CALL SOUND_WRITE_REGISTER                                                                                   ; B278: CD 0B B0
        LD D,08h                                                                                     ; B27B: 16 08
        LD E,B                                                                                       ; B27D: 58
        SRL E                                                                                        ; B27E: CB 3B
        SRL E                                                                                        ; B280: CB 3B
        CALL SOUND_WRITE_REGISTER                                                                                   ; B282: CD 0B B0
        LD D,01h                                                                                     ; B285: 16 01
        LD E,01h                                                                                     ; B287: 1E 01
        CALL SOUND_WRITE_REGISTER                                                                                   ; B289: CD 0B B0
        LD C,00h                                                                                     ; B28C: 0E 00

GAME_LOOP_B28E:
        PUSH AF                                                                                      ; B28E: F5
        POP AF                                                                                       ; B28F: F1
        DEC C                                                                                        ; B290: 0D
        JP NZ,GAME_LOOP_B28E                                                                                  ; B291: C2 8E B2
        DEC B                                                                                        ; B294: 05
        JP NZ,GAME_LOOP_B26A                                                                                  ; B295: C2 6A B2
        LD D,08h                                                                                     ; B298: 16 08
        LD E,00h                                                                                     ; B29A: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B29C: CD 0B B0
        RET                                                                                          ; B29F: C9
