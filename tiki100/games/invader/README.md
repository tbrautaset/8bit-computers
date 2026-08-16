# INVADER – TIKI-100 Enhanced Edition

A cleaned and enhanced edition of the original TIKI-100 **INVADER**. The aim is to preserve the original game and its character while improving controls, presentation, rendering and a few gameplay details.

## Changes from the original

### Title screen and music

- Added **Sweet Dreams** AY-3-8912 music to the title screen.
- The music plays once and does not loop.
- `SPACE` fades the music out before starting the game.
- `A` retains access to the original options menu. If the music is still playing, it fades out before the menu opens; otherwise the menu opens directly.

### Controls

- Added **cursor/arrow-key control** for the player tank. Arrow keys were not part of the original control scheme.
- `P` – pause/resume.
- `Q` – quit cleanly back to TIKO.
- `G` – toggle God Mode.
- The original controls remain available.

### Game over and restart

- Added an improved **Game Over / retry screen and flow**.
- Restarting cleans up the previous game state and graphics correctly.
- Quitting restores the expected display/runtime state before returning to TIKO.

### Player and invaders

- The tank starts at a **random horizontal position** rather than the same fixed position on every new game.
- Reworked tank and invader rendering to remove visible sprite flicker.
- Improved cleanup between boards so old tank, projectile and invader graphics are not left behind.

### UFO

- Reworked the two-part UFO renderer to remove the visible seam and movement flicker.
- The UFO renderer executes from unused high RAM while the TIKI-100 VRAM window is active.
- UFO movement uses a precomputed XOR movement delta. The old image is transformed directly into the new position instead of exposing an intermediate erased image.

### God Mode (`G`)

- The player does not lose a life when hit.
- Invaders reaching the bottom advance to the next board instead of killing the player.
- Normal level progression is retained.
- New waves start from the top while God Mode is active.
- UFOs appear more frequently in God Mode, using the shortest UFO interval already present in the original game.
- Normal gameplay behaviour is retained when God Mode is disabled.

### Rendering and stability

- Flicker-free rendering for the tank, invaders and UFO.
- Correct cleanup when changing boards.
- Original game initialization is reused for wave transitions rather than maintaining a separate replacement game-state implementation.

### Gameplay music

Background music during gameplay was investigated and tested but deliberately not included. Continuous AY playback imposed too much CPU overhead and affected the timing/performance of the original game. Music is therefore limited to the title screen.

## Source cleanup

This repository contains the cleaned final source rather than the development workspace. Abandoned FAST/gameplay music players, gameplay PT3 interrupt handlers, frame-lock/pending-music experiments, rapid-fire experiments, obsolete UFO renderers, superseded wave-reset implementations, reconstruction material and development test files are not included.

The build retains a 16 KiB original-runtime reference used to verify that runtime changes remain inside explicitly approved patch areas.

## Building

This source is intended to live inside the TIKI-100 development tree used for the project. The parent tree must provide `tools\sjasmplus.exe` and the main TIKI-100 `build.ps1`.

From this directory:

```powershell
.\build.ps1 -Copy -Run
```

Use `-Copy` and `-Run` as required by your local TIKI-100 setup.

## Copyright / historical note

The original INVADER software was developed for the **TIKI-100** platform in the 1980s.

Tiki Data A/S was acquired by Merkantildata in 1996. Merkantildata subsequently became part of the corporate history of the company now known as Atea. This project has **not independently established the present copyright ownership of the original INVADER software**, and does not claim ownership of the original work.

Rights to the original software and other original TIKI-100 material remain with their respective rights holder(s), where applicable. The material in this repository represents preservation-oriented modifications and enhancements to the original software.

No new licence for the underlying original INVADER code is asserted by this repository.
