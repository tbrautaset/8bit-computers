; ============================================================================
; loader_direct.asm
;
; New direct loader. It preserves the original low-memory execution method so
; stage 1 may overwrite 0100h-017Fh safely, but removes the packed stage-2
; runtime decoder entirely.
; ============================================================================

BOOTSTRAP:
        LD      HL,LOW_MEMORY_CONTROLLER_SOURCE
        LD      DE,0080h
        LD      BC,LOW_MEMORY_CONTROLLER_SIZE
        LDIR
        JP      0080h

        ASSERT  $ = 010Eh

LOW_MEMORY_CONTROLLER_SOURCE:
        LD      HL,STAGE1_INSTALLER_SOURCE
        LD      DE,0100h
        LD      BC,0080h
        LDIR
        CALL    0100h

        ; Runtime source ends below its 8000h destination, so normal LDIR is
        ; non-overlapping and safe.
        LD      HL,RUNTIME_SOURCE
        LD      DE,08000h
        LD      BC,04000h
        LDIR
        JP      0B2A0h

LOW_MEMORY_CONTROLLER_END:
LOW_MEMORY_CONTROLLER_SIZE EQU LOW_MEMORY_CONTROLLER_END-LOW_MEMORY_CONTROLLER_SOURCE

        ASSERT  LOW_MEMORY_CONTROLLER_SIZE <= 0072h
