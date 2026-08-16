; ============================================================================
; runtime_symbols.asm
;
; Address aliases for confirmed runtime state and assets.
; These symbols emit no bytes.
; ============================================================================

; Projectile record
PROJECTILE_Y                    EQU     0A200h
PROJECTILE_X                    EQU     0A201h
PROJECTILE_SPRITE               EQU     08280h

; Player record
PLAYER_Y                        EQU     0A206h
PLAYER_X                        EQU     0A207h
PLAYER_LIVES                    EQU     0A208h
PLAYER_FRAME_POINTER            EQU     0A20Ch
PLAYER_SPRITE                   EQU     08200h

; Ten 4-byte object descriptors begin here.
LEVEL_OBJECT_LIST               EQU     0A216h
LEVEL_OBJECT_COUNT              EQU     10
LEVEL_OBJECT_RECORD_SIZE        EQU     4

; Runtime state
FRAME_PHASE_COUNTER             EQU     0A501h
SCREEN_STATE_FLAG               EQU     0A507h
PLAYER_RUNTIME_Y                EQU     0A509h
PROJECTILE_ACTIVE               EQU     0A50Ch

RANDOM_STATE_A                  EQU     0A50Dh
RANDOM_STATE_B                  EQU     0A50Eh
RANDOM_STATE_C                  EQU     0A50Fh

PAUSE_OR_WAIT_FLAG              EQU     0A511h
GAME_EVENT_FLAG                 EQU     0A513h
SPECIAL_HIT_FLAG                EQU     0A518h

SOUND_WORK_POINTER              EQU     0A519h
SOUND_SEQUENCE_POINTER          EQU     0A51Bh
SOUND_SEQUENCE_DELAY            EQU     0A51Dh
SOUND_SEQUENCE_INDEX            EQU     0A51Eh

FRAME_COUNTDOWN                 EQU     0A51Fh
FRAME_DELAY_VALUE               EQU     0A520h
SOUND_OPTION                    EQU     0A522h
SPEED_OPTION                    EQU     0A523h

; Persistent data
STATUS_TEXT_TEMPLATE            EQU     0A400h
SOUND_TIMING_TABLE              EQU     0B800h
TITLE_TEXT_STREAM               EQU     0B820h
TITLE_MASK_DATA                 EQU     0BA90h
OPTIONS_TEXT_STREAM             EQU     0BB00h
OPTIONS_MASK_DATA               EQU     0BCE0h
COMPLETION_TEXT_STREAM          EQU     0BD80h
COMPLETION_MASK_DATA            EQU     0BE00h
HARDWARE_INITIALIZATION_TABLE   EQU     0BF00h

; Confirmed gameplay limits
PLAYER_X_MINIMUM                EQU     018h
PLAYER_X_MAXIMUM                EQU     0D6h
