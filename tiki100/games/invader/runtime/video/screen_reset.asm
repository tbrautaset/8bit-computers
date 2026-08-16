; Exact runtime 8100h-8108h

SCREEN_RESET:
        CALL CLEAR_MODE3_ROWS                                                                                   ; 8100: CD 00 A8
        LD A,00h                                                                                     ; 8103: 3E 00
        LD (0A507h),A                                                                                 ; 8105: 32 07 A5
        RET                                                                                          ; 8108: C9
