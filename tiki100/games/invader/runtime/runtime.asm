; ============================================================================
; runtime.asm
; Complete address-fixed INVADER runtime built from source and exact data assets.
; ============================================================================

        OUTPUT  "build/INVADER_RUNTIME_8000_BFFF.bin"
        ORG     08000h

TERMINAL_SERVICE_F00C   EQU     0F00Ch
TAIL_BLOCK_B51B        EQU     0B51Bh

        INCLUDE "video/sprite_blitter.asm"
        ASSERT  $ = 0805Bh
        INCLUDE "video/input_r1a.asm"
        ASSERT  $ <= 08080h
        DS      08080h-$,0FFh
        ASSERT  $ = 08080h
        INCBIN  "../assets/sprites/00_8080_title_extra.bin"
        ASSERT  $ = 08100h
        INCLUDE "video/screen_reset.asm"
        ASSERT  $ = 08109h
        ; Exact proven V22 row-atomic sprite move + arrow helper.
        INCLUDE "video/atomic_pair.asm"
        ASSERT  $ <= 08180h
        DS      08180h-$,0FFh
        ASSERT  $ = 08180h
        INCBIN  "../assets/sprites/01_8180_sprite_00.bin"
        INCBIN  "../assets/sprites/02_8200_sprite_01.bin"
        INCBIN  "../assets/sprites/03_8280_sprite_02.bin"
        INCBIN  "../assets/sprites/04_8300_sprite_03.bin"
        INCBIN  "../assets/sprites/05_8380_sprite_04.bin"
        INCBIN  "../assets/sprites/06_8400_sprite_05.bin"
        INCBIN  "../assets/sprites/07_8480_sprite_06.bin"
        INCBIN  "../assets/sprites/08_8500_sprite_07.bin"
        INCBIN  "../assets/sprites/09_8580_sprite_08.bin"
        INCBIN  "../assets/sprites/10_8600_sprite_09.bin"
        INCBIN  "../assets/sprites/11_8680_sprite_10.bin"
        INCBIN  "../assets/sprites/12_8700_sprite_11.bin"
        INCBIN  "../assets/sprites/13_8780_sprite_12.bin"
        INCBIN  "../assets/sprites/14_8800_sprite_13.bin"
        INCBIN  "../assets/sprites/15_8880_sprite_14.bin"
        INCBIN  "../assets/sprites/16_8900_sprite_15.bin"
        INCBIN  "../assets/sprites/17_8980_sprite_16.bin"
        INCBIN  "../assets/sprites/18_8A00_sprite_17.bin"
        INCBIN  "../assets/sprites/19_8A80_sprite_18.bin"
        INCBIN  "../assets/sprites/20_8B00_sprite_19.bin"
        INCBIN  "../assets/sprites/21_8B80_sprite_20.bin"
        INCBIN  "../assets/sprites/22_8C00_sprite_21.bin"
        INCBIN  "../assets/sprites/23_8C80_sprite_22.bin"
        INCBIN  "../assets/sprites/24_8D00_sprite_23.bin"
        INCBIN  "../assets/sprites/25_8D80_sprite_24.bin"
        INCBIN  "../assets/sprites/26_8E00_sprite_25.bin"
        INCBIN  "../assets/sprites/27_8E80_sprite_26.bin"
        INCBIN  "../assets/sprites/28_8F00_sprite_27.bin"
        INCBIN  "../assets/sprites/29_8F80_sprite_28.bin"
        INCBIN  "../assets/sprites/30_9000_sprite_29.bin"
        INCBIN  "../assets/sprites/31_9080_sprite_30.bin"
        INCBIN  "../assets/sprites/32_9100_sprite_31.bin"
        INCBIN  "../assets/sprites/33_9180_sprite_32.bin"
        INCBIN  "../assets/sprites/34_9200_sprite_33.bin"
        INCBIN  "../assets/sprites/35_9280_sprite_34.bin"
        INCBIN  "../assets/sprites/36_9300_sprite_35.bin"
        INCBIN  "../assets/sprites/37_9380_sprite_36.bin"
        INCBIN  "../assets/sprites/38_9400_sprite_37.bin"
        INCBIN  "../assets/sprites/39_9480_sprite_38.bin"
        INCBIN  "../assets/sprites/40_9500_sprite_39.bin"
        INCBIN  "../assets/sprites/41_9580_sprite_40.bin"
        INCBIN  "../assets/sprites/42_9600_sprite_41.bin"
        INCBIN  "../assets/sprites/43_9680_sprite_42.bin"
        INCBIN  "../assets/sprites/44_9700_sprite_43.bin"
        INCBIN  "../assets/sprites/45_9780_sprite_44.bin"
        INCBIN  "../assets/sprites/46_9800_sprite_45.bin"
        INCBIN  "../assets/sprites/47_9880_sprite_46.bin"
        INCBIN  "../assets/sprites/48_9900_sprite_47.bin"
        INCBIN  "../assets/sprites/49_9980_sprite_48.bin"
        INCBIN  "../assets/sprites/50_9A00_sprite_49.bin"
        INCBIN  "../assets/sprites/51_9A80_sprite_50.bin"
        INCBIN  "../assets/sprites/52_9B00_sprite_51.bin"
        INCBIN  "../assets/sprites/53_9B80_sprite_52.bin"
        INCBIN  "../assets/sprites/54_9C00_sprite_53.bin"
        INCBIN  "../assets/sprites/55_9C80_sprite_54.bin"
        INCBIN  "../assets/sprites/56_9D00_sprite_55.bin"
        INCBIN  "../assets/sprites/57_9D80_sprite_56.bin"
        INCBIN  "../assets/sprites/58_9E00_sprite_57.bin"
        INCBIN  "../assets/sprites/59_9E80_sprite_58.bin"
        INCBIN  "../assets/sprites/60_9F00_sprite_59.bin"
        INCBIN  "../assets/sprites/61_9F80_sprite_60.bin"
        INCBIN  "../assets/sprites/62_A000_sprite_61.bin"
        INCBIN  "../assets/sprites/63_A080_sprite_62.bin"
        INCBIN  "../assets/sprites/64_A100_sprite_63.bin"
        INCBIN  "../assets/sprites/65_A180_sprite_64.bin"
        ASSERT  $ = 0A200h
        INCBIN  "../assets/data/state_objects_A200_A23F.bin"
        ASSERT  $ = 0A240h
        INCBIN  "../assets/data/state_work_A240_A3FF.bin"
        ASSERT  $ = 0A400h
        INCBIN  "../assets/data/state_status_A400_A42F.bin"
        ASSERT  $ = 0A430h
        INCBIN  "../assets/data/state_masks_A430_A4FF.bin"
        ASSERT  $ = 0A500h
        INCBIN  "../assets/data/state_variables_A500_A53F.bin"
        ASSERT  $ = 0A540h
        INCBIN  "../assets/data/state_scratch_A540_A7FF.bin"
        ASSERT  $ = 0A800h
        INCLUDE "world/object_world.asm"
        ASSERT  $ = 0AB7Bh
        INCLUDE "player/player_projectile.asm"
        ASSERT  $ = 0AE40h
        INCLUDE "enemy/enemy.asm"
        ASSERT  $ = 0AF34h
        INCLUDE "collision/collision.asm"
        ASSERT  $ = 0B00Bh
        INCLUDE "audio/sound.asm"
        ASSERT  $ = 0B173h
        INCLUDE "game/game_loop.asm"
        ASSERT  $ = 0B2A0h
        INCLUDE "frontend/frontend.asm"
        ASSERT  $ = 0B51Bh

; ---------------------------------------------------------------------------
; B51Bh-B544h: exact original tail bytes following the reconstructed frontend.
;
; B545h-B7FFh: verified unused gap (699 bytes).
;
; Static verification:
;   - no direct references
;   - no indirect references
;   - all 50 computed-pointer contexts analysed
;   - numeric entry points resolved
;
; Dynamic verification:
;   - entire B545h-B7FFh range replaced with 76h (HALT): PASS
;   - entire B545h-B7FFh range replaced with 00h       : PASS
;   - entire B545h-B7FFh range replaced with FFh       : PASS
;
; The original bytes remain included here so the permanent runtime build stays
; byte-identical with the reference image. See docs/B545_B7FF_VERIFICATION.md.
; ---------------------------------------------------------------------------
        ; Keep exact original B51Bh-B544h tail (42 bytes).
        INCBIN  "../assets/data/runtime_mixed_tail_B51B_B7FF.bin",0,02Ah
        ASSERT  $ = 0B545h

        ; B545h-B7FFh is already verified unused by static + dynamic tests.
        INCLUDE "video/ufo_seam_high.asm"
        ASSERT  $ <= 0B800h
        DS      0B800h-$,0FFh
        ASSERT  $ = 0B800h
        INCBIN  "../assets/data/table_sound_B800_B81F.bin"
        ASSERT  $ = 0B820h
        INCBIN  "../assets/data/text_title_B820_BA8F.bin"
        ASSERT  $ = 0BA90h
        INCBIN  "../assets/data/mask_title_BA90_BAFF.bin"
        ASSERT  $ = 0BB00h
        INCBIN  "../assets/data/text_menu_BB00_BCDF.bin"
        ASSERT  $ = 0BCE0h
        INCBIN  "../assets/data/mask_menu_BCE0_BD7F.bin"
        ASSERT  $ = 0BD80h
        INCBIN  "../assets/data/text_completion_BD80_BDFF.bin"
        ASSERT  $ = 0BE00h
        INCBIN  "../assets/data/mask_completion_BE00_BEFF.bin"
        ASSERT  $ = 0BF00h
        INCBIN  "../assets/data/table_hardware_BF00_BF0F.bin"
        ASSERT  $ = 0BF10h
        INCBIN  "../assets/data/mask_frontend_BF10_BFAF.bin"
        ASSERT  $ = 0BFB0h
        INCBIN  "../assets/data/table_tail_BFB0_BFFF.bin"
        ASSERT  $ = 0C000h
RUNTIME_IMAGE_END:
        ASSERT  RUNTIME_IMAGE_END-08000h = 04000h

        INCLUDE "symbols/runtime_symbols.asm"

        END
