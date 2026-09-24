# Feature: powermenu-dual-env

Make `powermenu.sh` work on both Wayland (tofi) and X11 (rofi).

## Context
- The powermenu script (⏻ in the bar) called `rofi -dmenu` unconditionally
  and used `i3-msg exit` for session exit (a no-op on sway).
- An earlier attempt exists in the (stale) `feat/dual-env-powermenu` branch
  (`3d52278`, fuzzel/rofi detection) — superseded by the tofi switch; kept
  unmerged, deletable.
- The script is versioned at `bin/.local/bin/powermenu.sh` and symlinked to
  `~/.local/bin/powermenu.sh`.
- Installed tofi is Debian 0.9.1 (`--fuzzy-match`, no `matching-algorithm`).

## Tasks
1. [x] Rewrite the script: single options list (`printf '%b'` once), dual-env
   launcher detection via `$WAYLAND_DISPLAY` (tofi dmenu with the Ayu Gold
   theme, overridden to a small 20%/20% menu and its own prompt; rofi
   unchanged for X11), and per-environment session exit (`swaymsg exit` on
   Wayland, `i3-msg exit` on X11).
2. [x] Fix `tofi/.config/tofi/config`: `matching-algorithm = fuzzy` →
   `fuzzy-match = true` (found while testing the dmenu path: the installed
   0.9.1 logs an Unknown option error on every launch otherwise).
3. [x] Syntax check (`sh -n`) and tofi dmenu smoke test (menu opens, no
   config errors).

## Acceptance criteria
- ⏻ opens the menu on Wayland (tofi, small, Ayu Gold) and on X11 (rofi).
- Cerrar Sesión exits the session on both environments.

## Non-goals
- No changes to the stale `feat/dual-env-powermenu` branch (left unmerged).
- No changes to the main tofi window size (45%/30%); the powermenu overrides
  size via CLI flags only.

## Evidence
- `be5b6da` feat(powermenu): dual-env launcher detection (tofi/rofi)
- `11296da` fix(launcher): use fuzzy-match option compatible with tofi 0.9.1
