; ============================================================================
; INVADER.ASM
;
; Permanent direct-source build for INVADER on TIKI-100.
;
; Build through the local build.ps1. It first assembles and byte-verifies the
; 16 KB runtime, then invokes the repository build system for this COM source.
; ============================================================================

        OUTPUT  "build/INVADER.COM"
        ORG     0100h

        INCLUDE "loader/bootstrap.asm"

        DS      0180h-$,0FFh
        ASSERT  $ = 0180h

INSTALLER_PACKAGE_SOURCE:
        INCBIN  "assets/installer/INSTALLER_0180_174F.bin"
INSTALLER_PACKAGE_SOURCE_END:
        ASSERT  INSTALLER_PACKAGE_SOURCE_END-INSTALLER_PACKAGE_SOURCE = 015D0h
        ASSERT  $ = 01750h

        DS      01800h-$,0FFh
        ASSERT  $ = 01800h

RUNTIME_SOURCE:
        INCBIN  "build/INVADER_RUNTIME_8000_BFFF.bin"
RUNTIME_SOURCE_END:
        ASSERT  RUNTIME_SOURCE_END-RUNTIME_SOURCE = 04000h
        ASSERT  $ = 05800h

STAGE1_INSTALLER_SOURCE:
        INCBIN  "assets/installer/STAGE1_0100_017F.bin"
STAGE1_INSTALLER_SOURCE_END:
        ASSERT  STAGE1_INSTALLER_SOURCE_END-STAGE1_INSTALLER_SOURCE = 0080h
        ASSERT  $ = 05880h


; ============================================================================
; CLEAN PATCH V1
; Only retained features. No gameplay music / no old experiment code.
; ============================================================================
R2A_INTRO_ENTRY:
        JP      R0_INTRO               ; 5880
R2A_CONTROL_ENTRY:
        JP      R2A_CONTROL_GATE       ; 5883
R2A_GAMEOVER_ENTRY:
        JP      R2A_GAME_OVER          ; 5886
R2A_GOD_HIT_ENTRY:
        JP      R2A_GOD_HIT_GATE       ; 5889
R2A_GAME_START_ENTRY:
        JP      R2A_GAME_START         ; 588C
R15_WAVE_LEVEL_ENTRY:
        JP      R15_WAVE_LEVEL_GATE    ; 588F
R16_ENEMY_EVENT_ENTRY:
        JP      R16_ENEMY_EVENT_GATE   ; 5892
R1B_BOTTOM_LIMIT_ENTRY:
        JP      R1B_BOTTOM_LIMIT_GATE  ; 5895
PLAYER_ROW_ATOMIC_ENTRY:
        JP      PLAYER_ROW_ATOMIC_MOVE ; 5898
INV_CAPTURE_ENTRY:
        JP      INV_CAPTURE_OLD         ; 589B
INV_ROW_ATOMIC_ENTRY:
        JP      INV_ROW_ATOMIC_PRESENT ; 589E
G_FULL_INIT_ENTRY:
        JP      R7A_G_FULL_INIT_GATE    ; 58A1
G_UFO_TIMER_ENTRY:
        JP      G_UFO_TIMER             ; 58A4

R2A_PAUSED:
        DB      00h
R2A_KEY_HELD:
        DB      00h
R2A_GOD:
        DB      00h
R3D_INTRO_MUSIC_DONE:
        DB      00h
G_FORCE_FULL_INIT:
        DB      00h

; ----------------------------------------------------------------------------
; INTRO
; Full Sweet Dreams pass once. The same proven fade mechanism used in the
; earlier 6-second intro is used:
; - naturally during the final ~3 seconds;
; - immediately when SPACE is pressed.
;
; 0345Bh is calibrated from the fixed module's ~5013 50 Hz frames and the
; previously proven 0322h ~= 6 second intro timing.
; ----------------------------------------------------------------------------
R0_INTRO:
        ; Intro music only once per program launch.
        LD      A,(R3D_INTRO_MUSIC_DONE)
        OR      A
        JP      NZ,R15_READ_WAIT
        INC     A
        LD      (R3D_INTRO_MUSIC_DONE),A

        DI
        LD      HL,R0_SWEET_IMAGE
        LD      DE,08000h
        LD      BC,R0_SWEET_SIZE
        LDIR

        LD      HL,(0FF16h)
        CALL    08006h
        LD      HL,08000h
        LD      (0FF16h),HL
        EI

        ; V1C: actual module-position based one-shot.
        ; Embedded PT3 module starts at 89D3h.
        ; Position list starts at 8A9Ch, end marker FF is at 8AB6h,
        ; therefore the final real position is 8AB5h.
        LD      HL,0000h
        LD      (R0_COUNTER),HL
        LD      A,0Fh
        LD      (09B7Fh),A
        LD      A,0Ah
        LD      (R0_FADE_DIV),A

R0_WAIT_LOOP:
        CALL    R2A_Q_PRESSED
        JP      NZ,R2A_INTRO_Q_ACTIVE

        ; Preserve original A = options/menu behavior from frontend B2FCh.
        CALL    R8D_A_MENU_PRESSED
        JP      Z,R8D_A_FADE_TO_MENU

        CALL    R0_SPACE_PRESSED
        JR      NZ,R0_SPACE_FADE_TO_GAME

        ; CrPsPtr operand in the fixed resident player is at 85E2h.
        ; Start fade when the final real position begins, before the FF marker
        ; can wrap playback back to LPosPtr.
        LD      HL,(085E2h)
        LD      DE,08AB5h
        OR      A
        SBC     HL,DE
        JR      Z,R0_NATURAL_FADE

        CALL    R0_DELAY
        JR      R0_WAIT_LOOP

R0_NATURAL_FADE:
        CALL    R0_COMMON_FADE
        CALL    R0_STOP_RESTORE
        JP      R15_READ_WAIT

R15_READ_WAIT:
        ; Silent title/read state after the song and on later title screens.
        CALL    R2A_Q_PRESSED
        JP      NZ,R2A_EXIT

        CALL    R8D_A_MENU_PRESSED
        JP      Z,R8D_A_SILENT_TO_MENU

        CALL    R0_SPACE_PRESSED
        JR      NZ,R15_READ_START_GAME

        CALL    R0_DELAY
        JR      R15_READ_WAIT

R15_READ_START_GAME:
        XOR     A
        LD      (R2A_PAUSED),A
        LD      (R2A_KEY_HELD),A
        RET

R0_SPACE_FADE_TO_GAME:
        CALL    R0_COMMON_FADE
        CALL    R0_STOP_RESTORE
        XOR     A
        LD      (R2A_PAUSED),A
        LD      (R2A_KEY_HELD),A
        RET

R0_COMMON_FADE:
        ; Same proven fade engine for natural song end and SPACE.
        ; Stop as soon as master volume is actually zero.
        LD      HL,018Fh
        LD      (R0_COUNTER),HL
        LD      A,0Ah
        LD      (R0_FADE_DIV),A
.FADE:
        CALL    R0_DELAY
        CALL    R0_FADE_STEP

        LD      A,(09B7Fh)
        OR      A
        RET     Z

        LD      HL,(R0_COUNTER)
        DEC     HL
        LD      (R0_COUNTER),HL
        JR      .FADE

R2A_INTRO_Q_ACTIVE:
        CALL    R0_STOP_RESTORE
        JP      R2A_EXIT

R0_STOP_RESTORE:
        DI
        CALL    08003h                 ; resident mute/stop

        ; Restore the complete clean runtime after intro overlay.
        DI
        LD      HL,RUNTIME_SOURCE
        LD      DE,08000h
        LD      BC,04000h
        LDIR
        EI
        RET

R2A_Q_PRESSED:
        LD      C,06h
        LD      E,0FFh
        CALL    0005h
        OR      A
        JR      Z,.NO
        AND     05Fh
        CP      'Q'
        JR      NZ,.NO
        LD      A,01h
        OR      A
        RET
.NO:
        XOR     A
        RET

; ----------------------------------------------------------------------------
; GAMEPLAY INPUT
; ----------------------------------------------------------------------------
R2A_CONTROL_GATE:
        CALL    R2A_POLL_GAME_KEY
        LD      A,(R2A_PAUSED)
        OR      A
        JR      Z,.RUN
.PAUSE:
        CALL    R2A_POLL_GAME_KEY
        LD      A,(R2A_PAUSED)
        OR      A
        JR      NZ,.PAUSE
.RUN:
        CALL    0AA22h                 ; original UPDATE_WORLD_SYSTEM
        RET

R2A_POLL_GAME_KEY:
        LD      C,06h
        LD      E,0FFh
        CALL    0005h
        OR      A
        JR      Z,.RELEASE
        AND     05Fh
        LD      B,A
        LD      A,(R2A_KEY_HELD)
        CP      B
        RET     Z
        LD      A,B
        LD      (R2A_KEY_HELD),A

        CP      'Q'
        JP      Z,R2A_EXIT
        CP      'P'
        JR      Z,.TOGGLE_P
        CP      'G'
        JR      Z,.TOGGLE_G
        RET

.RELEASE:
        XOR     A
        LD      (R2A_KEY_HELD),A
        RET

.TOGGLE_P:
        LD      A,(R2A_PAUSED)
        XOR     01h
        LD      (R2A_PAUSED),A
        RET

.TOGGLE_G:
        ; Pure cheat toggle. No gameplay music.
        LD      A,(R2A_GOD)
        XOR     01h
        LD      (R2A_GOD),A
        RET

PLAYER_NEW_X_TMP:
        DB      00h
INV_OLD_SPRITE:
        DW      0000h
INV_OLD_Y:
        DB      00h
INV_OLD_X:
        DB      00h
INV_NEW_SPRITE:
        DW      0000h
INV_NEW_Y:
        DB      00h
INV_NEW_X:
        DB      00h

; ============================================================================
; EXACT PREVIOUSLY WORKING ROW-ATOMIC RENDER PATH
; 8109h primitive does old XOR + new XOR for each row before EI.
; ============================================================================

PLAYER_ROW_ATOMIC_MOVE:
        LD      (PLAYER_NEW_X_TMP),A
        PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    IX
        PUSH    IY

        ; IY = old tank VRAM.
        LD      H,D
        LD      L,E
        SRL     H
        RR      L
        PUSH    HL
        POP     IY

        ; IX = new tank VRAM.
        LD      A,(PLAYER_NEW_X_TMP)
        LD      E,A
        LD      H,D
        LD      L,E
        SRL     H
        RR      L
        PUSH    HL
        POP     IX

        LD      HL,08200h
        LD      DE,08200h
        CALL    08109h                 ; row-atomic old tank -> new tank

        POP     IY
        POP     IX
        POP     HL
        POP     DE
        POP     BC
        LD      A,(PLAYER_NEW_X_TMP)
        LD      E,A
        RET

INV_CAPTURE_OLD:
        LD      (INV_OLD_SPRITE),HL
        LD      A,D
        LD      (INV_OLD_Y),A
        LD      A,E
        LD      (INV_OLD_X),A
        RET

INV_ROW_ATOMIC_PRESENT:
        LD      (INV_NEW_SPRITE),HL
        LD      A,D
        LD      (INV_NEW_Y),A
        LD      A,E
        LD      (INV_NEW_X),A

        PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    IX
        PUSH    IY

        ; IY = old invader VRAM.
        LD      A,(INV_OLD_Y)
        LD      H,A
        LD      A,(INV_OLD_X)
        LD      L,A
        SRL     H
        RR      L
        PUSH    HL
        POP     IY

        ; IX = new invader VRAM.
        LD      A,(INV_NEW_Y)
        LD      H,A
        LD      A,(INV_NEW_X)
        LD      L,A
        SRL     H
        RR      L
        PUSH    HL
        POP     IX

        LD      HL,(INV_OLD_SPRITE)
        LD      DE,(INV_NEW_SPRITE)
        CALL    08109h                 ; row-atomic old invader -> new invader

        POP     IY
        POP     IX
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        RET

R2A_GAME_OVER:
        XOR     A
        LD      (R2A_GOD),A

        ; Original post-game cleanup, but keep the gameplay image on screen.
        CALL    0B3EAh
        CALL    0B012h

        ; White colour setup, same reversed palette convention as title.
        CALL    0B50Bh
        LD      A,00h
        LD      B,0Fh
        CALL    0B4F4h
        LD      A,01h
        CALL    0F00Ch                 ; cursor off

        ; Keep gameplay visible, but clear a bounded rectangle behind the message.
        ; This masks invaders/shots only in the text area so white text is readable.
        LD      BC,R2D_CLEAR_TEXT_END-R2D_CLEAR_TEXT
        LD      HL,R2D_CLEAR_TEXT
.CLEAR_TEXT:
        PUSH    HL
        PUSH    BC
        LD      A,(HL)
        CALL    0F00Ch
        POP     BC
        POP     HL
        CPI
        JP      PE,.CLEAR_TEXT

        ; Overlay the short centred message slightly higher on screen.
        LD      BC,R2A_GAME_OVER_TEXT_END-R2A_GAME_OVER_TEXT
        LD      HL,R2A_GAME_OVER_TEXT
.PRINT:
        PUSH    HL
        PUSH    BC
        LD      A,(HL)
        CALL    0F00Ch
        POP     BC
        POP     HL
        CPI
        JP      PE,.PRINT

        ; Ignore the key that caused/ended the last game action.
        CALL    R2A_DRAIN_KEYS

        ; New key -> intro immediately; otherwise auto intro in ~6 sec.
        LD      HL,0200h                ; shorter timeout, about 4 seconds
        LD      (R2A_END_COUNTER),HL
.WAIT:
        CALL    R3_GAMEOVER_KEY
        CP      02h
        JP      Z,R2A_EXIT             ; Q = quit to TIKO
        CP      01h
        JR      Z,.RETRY               ; any other key = retry
        CALL    R0_DELAY
        LD      HL,(R2A_END_COUNTER)
        DEC     HL
        LD      (R2A_END_COUNTER),HL
        LD      A,H
        OR      L
        JR      NZ,.WAIT

        ; No key for ~6 seconds -> back to intro/title.
        JP      0B2A0h

.RETRY:
        ; Start a complete new game through INVADER's original NEW_GAME path.
        ; This resets lives/score/game state and then naturally reaches our
        ; B318 game-start wrapper. This also makes game-over work on game #2+.
        JP      0B30Fh

R2A_DRAIN_KEYS:
.DRAIN:
        LD      C,06h
        LD      E,0FFh
        CALL    0005h
        OR      A
        JR      NZ,.DRAIN
        RET

R3_GAMEOVER_KEY:
        ; return A=0 no key, A=1 retry key, A=2 Q
        LD      C,06h
        LD      E,0FFh
        CALL    0005h
        OR      A
        RET     Z
        AND     05Fh
        CP      'Q'
        JR      Z,.QUIT
        LD      A,01h
        RET
.QUIT:
        LD      A,02h
        RET


; ----------------------------------------------------------------------------
; GAME START / RANDOM PLAYER X
; ----------------------------------------------------------------------------
R2A_GAME_START:
        XOR     A
        LD      (R2A_PAUSED),A
        LD      (R2A_KEY_HELD),A
        LD      (R2A_GOD),A

        ; Uniform legal X across 18h..D6h.
        ; Mix original RNG, a changing game counter and refresh register.
.RANDOM_X:
        CALL    0ADF5h                 ; original RANDOM_BYTE
        LD      B,A
        CALL    0ADF5h
        XOR     B
        LD      B,A
        LD      A,(0A50Fh)
        XOR     B
        LD      B,A
        LD      A,R
        XOR     B
        CP      0BFh                   ; accept 00h..BEh (191 positions)
        JR      NC,.RANDOM_X
        ADD     A,018h
        LD      (0A892h),A             ; immediate of original A891: LD E,nn

        CALL    0B173h                 ; original GAME_INITIALIZE
        RET

; ----------------------------------------------------------------------------
; G MODE
; ----------------------------------------------------------------------------
R15_WAVE_LEVEL_GATE:
        ; V1E: return only the level value used for formation START HEIGHT.
        ; Keep real A501 progression intact so board 2,3,4... remain real.
        LD      A,(R2A_GOD)
        OR      A
        JR      NZ,.GOD_TOP

        LD      A,(0A501h)             ; normal: original level value
        RET

.GOD_TOP:
        XOR     A                      ; G: calculate formation Y as level 0/top
        RET

R16_ENEMY_EVENT_GATE:
        ; Ordinary enemy/player hit event.
        ; G off: reproduce the original death-event write.
        ; G on : suppress ONLY this hit. Do not request redraw/new wave.
        LD      A,(R2A_GOD)
        OR      A
        JR      Z,.NORMAL

        XOR     A
        LD      (0A513h),A             ; no death/event
        RET

.NORMAL:
        LD      A,0FFh
        LD      (0A513h),A
        RET

R1B_BOTTOM_LIMIT_GATE:
        ; UPDATE_SOUND_SEQUENCE reaches this path when PLAYER_RUNTIME_Y >= D8h.
        ; Normal mode: preserve the original GAME_ROUND_TRANSITION.
        ; G mode: suppress death/explosion and request a fresh top-starting wave.
        LD      A,(R2A_GOD)
        OR      A
        JR      NZ,.GOD

        JP      0B1F5h                 ; original GAME_ROUND_TRANSITION

.GOD:
        LD      A,01h
        LD      (G_FORCE_FULL_INIT),A

        XOR     A
        LD      (0A513h),A
        LD      (0A507h),A
        LD      (0A509h),A
        LD      (0A51Fh),A
        RET
R7A_G_FULL_INIT_GATE:
        LD      A,(G_FORCE_FULL_INIT)
        OR      A
        JR      Z,R7A_G_FULL_INIT_NORMAL
        XOR     A
        LD      (G_FORCE_FULL_INIT),A
        RET

R7A_G_FULL_INIT_NORMAL:
        LD      A,(0A501h)
        OR      A
        RET

R2A_GOD_HIT_GATE:
        ; PROJECTILE_HIT_HANDLER calls this when the PLAYER shot has hit an
        ; invader. God Mode must NOT alter the invader hit index/state here.
        ;
        ; Previous G-mode code returned 29h. PROJECTILE_HIT_HANDLER then does
        ; SUB 1 and stores the result in A511h before starting the explosion.
        ; That injects an invalid hit/explosion state and can hang when an
        ; invader explodes in G mode.
        ;
        ; Player immunity is handled by the enemy/player event gates
        ; (R16_ENEMY_EVENT_GATE / bottom-limit handling), not here.
        LD      A,(0A511h)
        RET

R2A_EXIT:
        DI
        LD      A,020h
        LD      (0F04Dh),A
        OUT     (00Ch),A
        EI
        LD      A,019h
        CALL    0F00Ch
        JP      0000h

R2A_END_COUNTER:
        DW      0000h

G_UFO_TIMER:
        ; Normal mode = exact original random xx50h interval.
        ; G mode = shortest original interval 0050h.
        CALL    0ADF5h
        AND     03h
        LD      H,A
        LD      L,050h
        LD      A,(R2A_GOD)
        OR      A
        RET     Z
        LD      H,00h
        RET

R8D_A_SILENT_TO_MENU:
        CALL    R8D_WAIT_A_RELEASE
        JP      0B33Dh                 ; original OPTIONS_MENU

R8D_A_FADE_TO_MENU:
        ; A during active intro: same fade as SPACE, restore runtime,
        ; wait for key release, then enter original OPTIONS_MENU.
        CALL    R0_COMMON_FADE
        CALL    R0_STOP_RESTORE
        CALL    R8D_WAIT_A_RELEASE
        JP      0B33Dh                 ; original OPTIONS_MENU

R8D_A_MENU_PRESSED:
        ; Exact original B2FC/B300 matrix context:
        ; the preceding original release loop leaves A=FFh before OUT (00h),A.
        ; Our custom intro bypasses that loop, so set FFh explicitly.
        LD      A,0FFh
        DI
        OUT     (00h),A
        IN      A,(00h)
        IN      A,(00h)
        CP      0F7h
        EI
        RET

R8D_WAIT_A_RELEASE:
        ; Prevent the same physical A press from immediately reopening the
        ; menu when OPTIONS_MENU returns.
.RELEASE:
        LD      A,0FFh
        DI
        OUT     (00h),A
        IN      A,(00h)
        IN      A,(00h)
        EI
        CP      0F7h
        JR      Z,.RELEASE
        RET

R0_SPACE_PRESSED:
        XOR     A
        DI
        OUT     (00h),A
        IN      A,(00h)
        EI
        CP      0FFh
        RET

; Same fade engine previously proven in the short ~6 second intro.
R0_FADE_STEP:
        LD      HL,(R0_COUNTER)
        LD      DE,0190h
        OR      A
        SBC     HL,DE
        RET     NC

        LD      A,(R0_FADE_DIV)
        DEC     A
        LD      (R0_FADE_DIV),A
        RET     NZ

        LD      A,0Ah
        LD      (R0_FADE_DIV),A

        LD      A,(09B7Fh)
        OR      A
        RET     Z
        DEC     A
        LD      (09B7Fh),A
        RET

R0_DELAY:
        LD      B,13
.DELAY_OUTER:
        LD      DE,220
.DELAY_INNER:
        DEC     DE
        LD      A,D
        OR      E
        JR      NZ,.DELAY_INNER
        DJNZ    .DELAY_OUTER
        RET

R0_COUNTER:
        DW      0000h
R0_FADE_DIV:
        DB      0Ah

R2D_CLEAR_TEXT:
        ; Five 40-character blank lines behind the game-over text.
        DB      01Dh,010h,008h,000h
        DB      "                                        "
        DB      01Dh,010h,009h,000h
        DB      "                                        "
        DB      01Dh,010h,00Ah,000h
        DB      "                                        "
        DB      01Dh,010h,00Bh,000h
        DB      "                                        "
        DB      01Dh,010h,00Ch,000h
        DB      "                                        "
R2D_CLEAR_TEXT_END:

R2A_GAME_OVER_TEXT:
        ; TIKI charset: å='}', ø='|'
        DB      00h,00h,01Dh,010h,009h,00Ch
        DB      "Spillet er over !"
        DB      01Dh,010h,00Bh,003h
        DB      "Trykk tast for } pr|ve igjen ASAP ?"
R2A_GAME_OVER_TEXT_END:


R0_SWEET_IMAGE:
        INCBIN  "music/SWEET_PERFECT_M80_RESIDENT_8000_9B50.bin"
R0_SWEET_IMAGE_END:
R0_SWEET_SIZE EQU R0_SWEET_IMAGE_END-R0_SWEET_IMAGE

        ASSERT  R0_SWEET_SIZE = 01B80h
        ASSERT  $ < 08000h

INVADER_END:

        END     BOOTSTRAP
