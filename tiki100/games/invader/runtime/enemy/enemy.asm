; ============================================================================
; Enemy pool and update system
; Original range AE40h-AF33h (244 bytes)
; SHA-256 a3f9664b65d0646b991d1739622b2c44996dbd2195d5b98d891026f119e94890
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

UPDATE_ENEMY_POOL:
        LD IX,0A230h                                                                                  ; AE40: DD 21 30 A2
        LD A,(0A514h)                                                                                 ; AE44: 3A 14 A5
        LD (0A515h),A                                                                                 ; AE47: 32 15 A5

ENEMY_LOOP_AE4A:
        CALL ENEMY_BLOCK_AE5D                                                                                   ; AE4A: CD 5D AE
        INC IX                                                                                       ; AE4D: DD 23
        INC IX                                                                                       ; AE4F: DD 23
        LD A,(0A515h)                                                                                 ; AE51: 3A 15 A5
        SUB 01h                                                                                      ; AE54: D6 01
        LD (0A515h),A                                                                                 ; AE56: 32 15 A5
        JP NZ,ENEMY_LOOP_AE4A                                                                                  ; AE59: C2 4A AE
        RET                                                                                          ; AE5C: C9

ENEMY_BLOCK_AE5D:
        LD D,(IX+0)                                                                                  ; AE5D: DD 56 00
        LD E,(IX+1)                                                                                  ; AE60: DD 5E 01
        LD HL,8300h                                                                                  ; AE63: 21 00 83
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AE66: CD 00 AD
        LD A,D                                                                                       ; AE69: 7A
        CP 00h                                                                                       ; AE6A: FE 00
        JP NZ,ENEMY_BLOCK_AEB4                                                                                  ; AE6C: C2 B4 AE
        CALL RANDOM_BYTE                                                                                   ; AE6F: CD F5 AD
        AND 0Eh                                                                                      ; AE72: E6 0E
        LD C,A                                                                                       ; AE74: 4F
        LD B,00h                                                                                     ; AE75: 06 00
        LD IY,0A300h                                                                                  ; AE77: FD 21 00 A3
        ADD IY,BC                                                                                    ; AE7B: FD 09
        LD C,10h                                                                                     ; AE7D: 0E 10
        LD H,05h                                                                                     ; AE7F: 26 05

ENEMY_LOOP_AE81:
        LD A,(IY+0)                                                                                  ; AE81: FD 7E 00
        CP 00h                                                                                       ; AE84: FE 00
        JP NZ,ENEMY_BLOCK_AE90                                                                                  ; AE86: C2 90 AE
        DEC H                                                                                        ; AE89: 25
        RET Z                                                                                        ; AE8A: C8
        ADD IY,BC                                                                                    ; AE8B: FD 09
        JP ENEMY_LOOP_AE81                                                                                     ; AE8D: C3 81 AE

ENEMY_BLOCK_AE90:
        LD D,(IY+0)                                                                                  ; AE90: FD 56 00
        LD E,(IY+1)                                                                                  ; AE93: FD 5E 01
        LD A,D                                                                                       ; AE96: 7A
        ADD A,08h                                                                                    ; AE97: C6 08
        LD D,A                                                                                       ; AE99: 57
        LD A,E                                                                                       ; AE9A: 7B
        ADD A,08h                                                                                    ; AE9B: C6 08
        LD E,A                                                                                       ; AE9D: 5F
        LD B,09h                                                                                     ; AE9E: 06 09
        LD IY,0A230h                                                                                  ; AEA0: FD 21 30 A2

ENEMY_LOOP_AEA4:
        LD A,(IY+1)                                                                                  ; AEA4: FD 7E 01
        INC IY                                                                                       ; AEA7: FD 23
        INC IY                                                                                       ; AEA9: FD 23
        DEC B                                                                                        ; AEAB: 05
        JP Z,ENEMY_BLOCK_AEB4                                                                                   ; AEAC: CA B4 AE
        CP E                                                                                         ; AEAF: BB
        RET Z                                                                                        ; AEB0: C8
        JP ENEMY_LOOP_AEA4                                                                                     ; AEB1: C3 A4 AE

ENEMY_BLOCK_AEB4:
        CALL ENEMY_BLOCK_AEC4                                                                                   ; AEB4: CD C4 AE
        LD HL,8300h                                                                                  ; AEB7: 21 00 83
        CALL PROJECTILE_DRAW_HELPER                                                                                   ; AEBA: CD 00 AD
        LD (IX+0),D                                                                                  ; AEBD: DD 72 00
        LD (IX+1),E                                                                                  ; AEC0: DD 73 01
        RET                                                                                          ; AEC3: C9

ENEMY_BLOCK_AEC4:
        LD A,D                                                                                       ; AEC4: 7A
        CP 00h                                                                                       ; AEC5: FE 00
        RET Z                                                                                        ; AEC7: C8
        LD A,D                                                                                       ; AEC8: 7A
        CP 0F0h                                                                                       ; AEC9: FE F0
        JP C,ENEMY_BLOCK_AED3                                                                                   ; AECB: DA D3 AE
        LD D,00h                                                                                     ; AECE: 16 00
        LD E,00h                                                                                     ; AED0: 1E 00
        RET                                                                                          ; AED2: C9

ENEMY_BLOCK_AED3:
        LD A,D                                                                                       ; AED3: 7A
        ADD A,08h                                                                                    ; AED4: C6 08
        LD D,A                                                                                       ; AED6: 57
        LD A,(0A509h)                                                                                 ; AED7: 3A 09 A5
        ADD A,10h                                                                                    ; AEDA: C6 10
        CP D                                                                                         ; AEDC: BA
        JP NC,ENEMY_BLOCK_AF2F                                                                                  ; AEDD: D2 2F AF
        CALL READ_MODE3_PIXEL_BYTE                                                                                   ; AEE0: CD C3 AC
        CP 00h                                                                                       ; AEE3: FE 00
        JP Z,ENEMY_BLOCK_AF2F                                                                                   ; AEE5: CA 2F AF
        LD A,0E6h                                                                                     ; AEE8: 3E E6
        CP D                                                                                         ; AEEA: BA
        JP NC,ENEMY_BLOCK_AF0D                                                                                  ; AEEB: D2 0D AF
        LD A,(0A207h)                                                                                 ; AEEE: 3A 07 A2
        SUB 05h                                                                                      ; AEF1: D6 05
        CP E                                                                                         ; AEF3: BB
        JP NC,ENEMY_BLOCK_AF0D                                                                                  ; AEF4: D2 0D AF
        ADD A,12h                                                                                    ; AEF7: C6 12
        CP E                                                                                         ; AEF9: BB
        JP C,ENEMY_BLOCK_AF0D                                                                                   ; AEFA: DA 0D AF
        CALL 05892h                                                                                  ; AEFD: G enemy-event gate
        NOP                                                                                          ; AF00
        NOP                                                                                          ; AF01
        LD (IX+0),00h                                                                                ; AF02: DD 36 00 00
        LD (IX+1),00h                                                                                ; AF06: DD 36 01 00
        POP BC                                                                                       ; AF0A: C1
        POP BC                                                                                       ; AF0B: C1
        RET                                                                                          ; AF0C: C9

ENEMY_BLOCK_AF0D:
        CALL READ_MODE3_PIXEL_BYTE                                                                                   ; AF0D: CD C3 AC
        CP 07h                                                                                       ; AF10: FE 07
        JP Z,ENEMY_BLOCK_AF22                                                                                   ; AF12: CA 22 AF
        CP 77h                                                                                       ; AF15: FE 77
        JP Z,ENEMY_BLOCK_AF22                                                                                   ; AF17: CA 22 AF
        CP 70h                                                                                       ; AF1A: FE 70
        JP Z,ENEMY_BLOCK_AF22                                                                                   ; AF1C: CA 22 AF
        JP ENEMY_BLOCK_AF2F                                                                                     ; AF1F: C3 2F AF

ENEMY_BLOCK_AF22:
        CALL PLAYER_BLOCK_ACD7                                                                                   ; AF22: CD D7 AC
        INC D                                                                                        ; AF25: 14
        CALL PLAYER_BLOCK_ACD7                                                                                   ; AF26: CD D7 AC
        DEC D                                                                                        ; AF29: 15
        LD D,00h                                                                                     ; AF2A: 16 00
        LD E,00h                                                                                     ; AF2C: 1E 00
        RET                                                                                          ; AF2E: C9

ENEMY_BLOCK_AF2F:
        LD A,D                                                                                       ; AF2F: 7A
        SUB 07h                                                                                      ; AF30: D6 07
        LD D,A                                                                                       ; AF32: 57
        RET                                                                                          ; AF33: C9
