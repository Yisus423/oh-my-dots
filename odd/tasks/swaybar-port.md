# Feature: swaybar-port

Port the waybar (Ayu Gold) aesthetic to swaybar using i3status-rust as the
status generator.

## Context
- User decision (2026-09): full-fidelity port with i3status-rs, verified
  against the v0.36.1 schema.
- sway 1.10.1: workspace buttons themable via `bar { colors { } }` (border is
  full-rectangle, not per-side); status blocks support per-block background,
  per-side borders and pango markup (swaybar-protocol(7)).
- i3status-rs v0.36.1 defaults emit `markup: "pango"` per block — the waybar
  gold spans reproduce 1:1. theme_overrides/icons_overrides/icons_format are
  per-block; blocks have per-block click handlers; keyboard_layout has a sway
  driver; sound has a pulseaudio driver; focused_window has sway IPC.
- i3status-rust is NOT packaged in Debian 13 and publishes no release binaries
  (cargo-binstall has nothing to fetch). Build from source: cargo + gcc +
  libssl-dev (installed), libsensors-dev and libpulse-dev (missing; temperature
  block links libsensors unconditionally, pulseaudio is the default feature
  needed for the volume block).
- Known minor losses vs waybar: window title moves to the status line (right
  side) if shown; 5-glyph battery series becomes 1 icon + state colors; no
  tooltips/hover; workspace focus underline becomes a full border or none.

## Tasks
1. [x] Install build deps: `sudo apt install libsensors-dev libpulse-dev`
   (`libssl-dev` already installed). Confirmed via dpkg.
2. [x] Build and install i3status-rs v0.36.1: cloned to `~/src/i3status-rust`,
   `cargo install --path . --locked -j 1` (two runs, ~45 min total on this
   machine: 2 cores / 1.8GB RAM / no swap), `./install.sh` (icons, themes,
   manpage). Binary at `~/.cargo/bin/i3status-rs`.
3. [x] Create `~/.config/i3status-rust/config.toml` with the Ayu Gold theme
   overrides and gold-span formats (symlinked into `~/.config/i3status-rust`).
4. [x] Change the `bar { }` section in the sway config (writer-verified,
   `sway -C` headless exit 0).
5. [x] Test i3status-rs output: all blocks render clean JSON, no error blocks.

## Acceptance criteria
- Bar renders with the Ayu Gold palette: workspaces (focus bg-alt + gold
  accents, urgent red), status modules with gold labels via pango spans.
- All waybar modules present: disk, VOL, language, RAM, CPU, network, battery,
  clock, powermenu (click works).
- i3status-rs outputs clean JSON with no error blocks.

## Non-goals
- No changes to the waybar config (kept as fallback until the user decides).
- No tray configuration.
- No window-title block unless the user asks for it.

## Evidence
- `b874d6f` feat(bar): port waybar aesthetic to native swaybar via
  i3status-rust (branch `feat/swaybar-port`, off `main`)
- `749cb4e` fix(bar): calibrate thresholds and flatten metric state colors
  (user feedback round: RAM counted cached memory; disk state checked used
  against alert=10; cpu spikes painted the bar red; workspace buttons small)
- `c451ab5` feat(bar): add focused window title block (first status block,
  sway_ipc driver, push-based, hidden until first event, max 60 chars)
- `4db8a66` fix(bar): hide focused_window on empty title instead of erroring
  (empty workspace raised "Failed to render full text": the block rendered
  with no values, so `$title` raised PlaceholderNotFound. Fixed with the
  recursive-template fallback `{ $title |}`: the empty alternative renders an
  empty full text and `get_data` hides the block when full is empty)

## Config gotchas found while testing (v0.36.1)
- The global theme table key is `[theme.overrides]` (the README's
  `[theme.theme_overrides]` is outdated; per-BLOCK overrides use
  `[block.theme_overrides]`).
- Percent placeholders (`$percentage`, `$volume`, `$utilization`,
  `$mem_total_used_percents`) already include the `%` sign — do not add a
  literal `%` (it renders doubled).
- Battery format field names are `full_format`, `charging_format`,
  `not_charging_format` (not `format_full`...); `deny_unknown_fields` turns a
  wrong name into a "Configuration error" block.
- The battery is Full by default threshold 95, and `full_format` defaults to
  `" $icon "` (icon only) — that is why a custom `format` appears ignored when
  the battery is full.
- The keyboard_layout sway driver needs `SWAYSOCK`; it failed only in the
  headless test environment, not in the user session.
- The debug macro for the battery block is commented out upstream, so
  `RUST_LOG=battery=debug` produces no battery logs.
- The upstream doc for focused_window claims a "Missing" fallback text
  (`format = " $title.str(0,21) | Missing "`), but in v0.36.1 a missing
  placeholder propagates the error before any fallback text renders. The
  working mechanism is the recursive-template fallback `{ $a | $b }`:
  `FormatTemplate::render` tries each alternative and swallows
  PlaceholderNotFound/IncompatibleFormatter/NumberOutOfRange for
  non-final alternatives; the final alternative must render (possibly
  empty) or the error propagates. An empty final alternative renders
  `Ok(vec![])` and `widget.rs get_data` hides the block when `full` is
  empty.

## Notes
- Unrelated in-progress changes in the working tree (fish, nvim, greetd,
  root `.gitignore`) were left out of the feature commits.
- i3status-rs source kept at `~/src/i3status-rust` (v0.36.1) for future
  rebuilds.
