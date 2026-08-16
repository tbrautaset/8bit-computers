; ============================================================================
; Sound reset and sequencer
; Original range B00Bh-B172h (360 bytes)
; SHA-256 70c87f3a89c8c25063179075890dd531c172da58a4a0da3f91fed6fbac8a3e20
; Exact instruction transcription. No semantic instructions invented.
; ============================================================================

SOUND_WRITE_REGISTER:
        LD A,D                                                                                       ; B00B: 7A
        OUT (16h),A                                                                                  ; B00C: D3 16
        LD A,E                                                                                       ; B00E: 7B
        OUT (17h),A                                                                                  ; B00F: D3 17
        RET                                                                                          ; B011: C9

SOUND_AND_STATE_RESET:
        LD A,04h                                                                                     ; B012: 3E 04
        LD (0A209h),A                                                                                 ; B014: 32 09 A2
        LD A,00h                                                                                     ; B017: 3E 00
        LD (0A51Eh),A                                                                                 ; B019: 32 1E A5
        LD HL,0B800h                                                                                  ; B01C: 21 00 B8
        LD (0A51Bh),HL                                                                                ; B01F: 22 1B A5
        LD A,00h                                                                                     ; B022: 3E 00
        LD (0A51Dh),A                                                                                 ; B024: 32 1D A5
        LD HL,0A300h                                                                                  ; B027: 21 00 A3
        LD (0A519h),HL                                                                                ; B02A: 22 19 A5
        LD D,00h                                                                                     ; B02D: 16 00
        LD E,00h                                                                                     ; B02F: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B031: CD 0B B0
        LD D,01h                                                                                     ; B034: 16 01
        LD E,00h                                                                                     ; B036: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B038: CD 0B B0
        LD D,02h                                                                                     ; B03B: 16 02
        LD E,00h                                                                                     ; B03D: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B03F: CD 0B B0
        LD D,03h                                                                                     ; B042: 16 03
        LD E,00h                                                                                     ; B044: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B046: CD 0B B0
        LD D,04h                                                                                     ; B049: 16 04
        LD E,00h                                                                                     ; B04B: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B04D: CD 0B B0
        LD D,05h                                                                                     ; B050: 16 05
        LD E,00h                                                                                     ; B052: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B054: CD 0B B0
        LD D,06h                                                                                     ; B057: 16 06
        LD E,00h                                                                                     ; B059: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B05B: CD 0B B0
        LD D,07h                                                                                     ; B05E: 16 07
        LD E,4Ch                                                                                     ; B060: 1E 4C
        CALL SOUND_WRITE_REGISTER                                                                                   ; B062: CD 0B B0
        LD D,08h                                                                                     ; B065: 16 08
        LD E,00h                                                                                     ; B067: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B069: CD 0B B0
        LD D,09h                                                                                     ; B06C: 16 09
        LD E,00h                                                                                     ; B06E: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B070: CD 0B B0
        LD D,0Ah                                                                                     ; B073: 16 0A
        LD E,00h                                                                                     ; B075: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B077: CD 0B B0
        LD D,0Bh                                                                                     ; B07A: 16 0B
        LD E,00h                                                                                     ; B07C: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B07E: CD 0B B0
        LD D,0Ch                                                                                     ; B081: 16 0C
        LD E,00h                                                                                     ; B083: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B085: CD 0B B0
        LD D,0Dh                                                                                     ; B088: 16 0D
        LD E,01h                                                                                     ; B08A: 1E 01
        CALL SOUND_WRITE_REGISTER                                                                                   ; B08C: CD 0B B0
        RET                                                                                          ; B08F: C9

UPDATE_SOUND_SEQUENCE:
        LD A,(0A509h)                                                                                 ; B090: 3A 09 A5
        CP 0D8h                                                                                       ; B093: FE D8
        JP C,SOUND_BLOCK_B0A0                                                                                   ; B095: DA A0 B0
        LD A,01h                                                                                     ; B098: 3E 01
        LD (0A513h),A                                                                                 ; B09A: 32 13 A5
        JP 05895h                                                                                                    ; B09D: V1B G bottom-limit gate

SOUND_BLOCK_B0A0:
        LD A,(0A522h)                                                                                 ; B0A0: 3A 22 A5
        CP 00h                                                                                       ; B0A3: FE 00
        RET NZ                                                                                       ; B0A5: C0
        CALL SOUND_BLOCK_B103                                                                                   ; B0A6: CD 03 B1
        CALL SOUND_BLOCK_B132                                                                                   ; B0A9: CD 32 B1
        LD A,(0A209h)                                                                                 ; B0AC: 3A 09 A2
        LD (0A51Eh),A                                                                                 ; B0AF: 32 1E A5
        LD A,(0A51Dh)                                                                                 ; B0B2: 3A 1D A5
        DEC A                                                                                        ; B0B5: 3D
        LD (0A51Dh),A                                                                                 ; B0B6: 32 1D A5
        JP M,SOUND_BLOCK_B0C4                                                                                   ; B0B9: FA C4 B0
        LD D,08h                                                                                     ; B0BC: 16 08
        LD E,A                                                                                       ; B0BE: 5F
        SRL E                                                                                        ; B0BF: CB 3B
        CALL SOUND_WRITE_REGISTER                                                                                   ; B0C1: CD 0B B0

SOUND_BLOCK_B0C4:
        LD HL,(0A519h)                                                                                ; B0C4: 2A 19 A5
        LD BC,(0A502h)                                                                                ; B0C7: ED 4B 02 A5
        AND A                                                                                        ; B0CB: A7
        SBC HL,BC                                                                                    ; B0CC: ED 42
        LD (0A519h),BC                                                                                ; B0CE: ED 43 19 A5
        RET C                                                                                        ; B0D2: D8
        LD A,(0A511h)                                                                                 ; B0D3: 3A 11 A5
        CP 00h                                                                                       ; B0D6: FE 00
        RET Z                                                                                        ; B0D8: C8
        LD HL,(0A51Bh)                                                                                ; B0D9: 2A 1B A5
        LD D,00h                                                                                     ; B0DC: 16 00
        LD E,(HL)                                                                                    ; B0DE: 5E
        CALL SOUND_WRITE_REGISTER                                                                                   ; B0DF: CD 0B B0
        INC HL                                                                                       ; B0E2: 23
        LD D,01h                                                                                     ; B0E3: 16 01
        LD E,(HL)                                                                                    ; B0E5: 5E
        CALL SOUND_WRITE_REGISTER                                                                                   ; B0E6: CD 0B B0
        INC HL                                                                                       ; B0E9: 23
        LD A,06h                                                                                     ; B0EA: 3E 06
        CP L                                                                                         ; B0EC: BD
        JP NC,SOUND_BLOCK_B0F3                                                                                  ; B0ED: D2 F3 B0
        LD HL,0B800h                                                                                  ; B0F0: 21 00 B8

SOUND_BLOCK_B0F3:
        LD (0A51Bh),HL                                                                                ; B0F3: 22 1B A5
        LD D,08h                                                                                     ; B0F6: 16 08
        LD E,06h                                                                                     ; B0F8: 1E 06
        CALL SOUND_WRITE_REGISTER                                                                                   ; B0FA: CD 0B B0
        LD A,10h                                                                                     ; B0FD: 3E 10
        LD (0A51Dh),A                                                                                 ; B0FF: 32 1D A5
        RET                                                                                          ; B102: C9

SOUND_BLOCK_B103:
        LD A,(0A50Ch)                                                                                 ; B103: 3A 0C A5
        CP 00h                                                                                       ; B106: FE 00
        JP NZ,SOUND_BLOCK_B113                                                                                  ; B108: C2 13 B1
        LD D,09h                                                                                     ; B10B: 16 09
        LD E,00h                                                                                     ; B10D: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B10F: CD 0B B0
        RET                                                                                          ; B112: C9

SOUND_BLOCK_B113:
        ADD A,0Ah                                                                                    ; B113: C6 0A
        SLA A                                                                                        ; B115: CB 27
        SLA A                                                                                        ; B117: CB 27
        SLA A                                                                                        ; B119: CB 27
        SLA A                                                                                        ; B11B: CB 27
        LD D,02h                                                                                     ; B11D: 16 02
        LD E,A                                                                                       ; B11F: 5F
        CALL SOUND_WRITE_REGISTER                                                                                   ; B120: CD 0B B0
        LD D,03h                                                                                     ; B123: 16 03
        LD E,00h                                                                                     ; B125: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B127: CD 0B B0
        LD D,09h                                                                                     ; B12A: 16 09
        LD E,0Fh                                                                                     ; B12C: 1E 0F
        CALL SOUND_WRITE_REGISTER                                                                                   ; B12E: CD 0B B0
        RET                                                                                          ; B131: C9

SOUND_BLOCK_B132:
        LD A,(0A209h)                                                                                 ; B132: 3A 09 A2
        LD B,A                                                                                       ; B135: 47
        LD A,(0A51Eh)                                                                                 ; B136: 3A 1E A5
        CP B                                                                                         ; B139: B8
        RET NZ                                                                                       ; B13A: C0
        LD A,(0A209h)                                                                                 ; B13B: 3A 09 A2
        CP 0DAh                                                                                       ; B13E: FE DA
        RET Z                                                                                        ; B140: C8
        LD A,(0A209h)                                                                                 ; B141: 3A 09 A2
        CP 04h                                                                                       ; B144: FE 04
        RET Z                                                                                        ; B146: C8
        LD A,(0A518h)                                                                                 ; B147: 3A 18 A5
        CP 00h                                                                                       ; B14A: FE 00
        RET NZ                                                                                       ; B14C: C0
        LD D,0Ah                                                                                     ; B14D: 16 0A
        LD E,0Fh                                                                                     ; B14F: 1E 0F
        CALL SOUND_WRITE_REGISTER                                                                                   ; B151: CD 0B B0
        LD BC,0001h                                                                                  ; B154: 01 01 00
        LD HL,0CFFFh                                                                                  ; B157: 21 FF CF

SOUND_LOOP_B15A:
        LD D,06h                                                                                     ; B15A: 16 06
        LD E,H                                                                                       ; B15C: 5C
        CALL SOUND_WRITE_REGISTER                                                                                   ; B15D: CD 0B B0
        AND A                                                                                        ; B160: A7
        ADC HL,BC                                                                                    ; B161: ED 4A
        JP NZ,SOUND_LOOP_B15A                                                                                  ; B163: C2 5A B1
        LD D,0Ah                                                                                     ; B166: 16 0A
        LD E,00h                                                                                     ; B168: 1E 00
        CALL SOUND_WRITE_REGISTER                                                                                   ; B16A: CD 0B B0
        LD A,04h                                                                                     ; B16D: 3E 04
        LD (0A209h),A                                                                                 ; B16F: 32 09 A2
        RET                                                                                          ; B172: C9
