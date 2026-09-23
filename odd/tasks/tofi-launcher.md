# Feature: tofi-launcher

Replace wofi with tofi as the Sway launcher, with the Ayu Gold theme ported.

## Context
- User pain: fuzzel/wofi did not adapt to the active screen or center reliably
  (fuzzel `width=100` chars ≈ 2040px wide; wofi height/lines competing).
- Decision (2026-09): tofi chosen over rofi-wayland — Debian 13 ships tofi in
  repos; rofi-wayland needs a source build (lbonn fork frozen, mainline rofi 2.0
  not packaged in trixie).
- Distro: Debian 13 (trixie). sway + kanshi (eDP-1 1366x768 / HDMI-A-1
  1920x1080, one output active at a time).
- Live configs are symlinks into ~/dotfiles.

## Tasks
1. [x] Install tofi from Debian 13 repos. (`apt install tofi`, confirmed
   `tofi`/`tofi-drun` in PATH)
2. [x] Create `tofi/.config/tofi/config` with Ayu Gold ported (width %, anchor
   center), symlinked into `~/.config/tofi`.
3. [x] Point sway `$menu` to `tofi-drun` (writer-verified via grep).
4. [x] Config parse verified in live use; user confirmed visually with `$mod+d`.

## Acceptance criteria
- tofi opens centered on the focused output, sized as a % of the active screen.
- Ayu Gold palette consistent with the rest of the setup.
- `$mod+d` launches tofi-drun and selected apps start.

## Non-goals
- No icons (tofi is text-only).
- No changes to wofi/fuzzel configs or the `fix/fuzzel-dpi` branch.
- No power menu changes.

## Evidence
- `d7ed578` feat(launcher): replace wofi with tofi using Ayu Gold palette
  (branch `feat/tofi-launcher`, off `main`)

## Notes
- The prompt glyph U+276F is not in JetBrainsMonoNerdFont-Regular.ttf; font is
  set by name (Pango) so fontconfig fallback renders it. Pointing `font` at a
  .ttf path would cut startup to <1ms but loses the fallback.
- Unrelated in-progress changes in the working tree (fish, nvim, greetd,
  root `.gitignore`) were left out of the feature commits.
