# rack-build — 3D-printed 19" rack panels

Three parametric OpenSCAD panels for a home 19" rack. Source files are in
`scad/`, printable pieces in `stl/`. Printers: 2x Prusa i3 MK3S (250x210 mm bed).

**Test-first, every panel:** print the piece with a snap-fit or clip mechanism
first (right half of the 1U, column 1 of the 2U, one keystone piece) and
dry-fit the hardware before committing to a full print run. Several
mechanisms here are first-pass designs validated by geometry checks, not by
an actual print — see the cautions under each section.

---

## Print settings (all three files)

- **Material:** PETG
- **Supports:** none needed, for any piece, in its specified orientation
- **Orientation:** every file prints with its front plate face-down on the
  bed (the .scad files handle this rotation automatically — just slice the
  STL as exported, don't reorient it in the slicer)
- **Layer height / infill:** no hard requirement from the design; 0.2mm /
  15-20% infill is a reasonable default. Parts with threads cut directly
  into the plastic (standoffs, bosses) will hold a self-tapping screw better
  with higher infill in that specific region if your slicer supports it.

---

## Hardware shopping list (consolidated)

| Qty | Item | Used for |
|---|---|---|
| 23x | M3 bolt, ~14-16mm | Panel joints (see per-section counts below) |
| 23x | M3 hex nut | Panel joints (nut traps) |
| ~20x | 1.75mm filament offcuts, ~10-12mm long | Joint alignment dowels |
| 8x | M2.5 self-tapping screw | Raspberry Pi 5 to sled standoffs |
| 2x | M3 self-tapping screw | PoE++ bracket standoffs |
| 4x | M6 cage nut + screw | Rack ear mounting (1U Hue/PoE+Pi, 1U keystone) |
| 6x | M6 cage nut + screw | Rack ear mounting (2U audio stacks, 3 columns) |
| 2x | M2.5 or M3 screw | Kinter MA170 tab mounting (x2 per active column) |

Bolt/nut/dowel counts below are per-file; add them up for a shopping total.

---

## 1. 1U — Hue Bridge + PoE++ injector + 2x Raspberry Pi 5

**Source:** `scad/rack-1u-airport-hue-pi.scad`
**Pieces:** `rack-1u-left.stl`, `rack-1u-right.stl`, `rack-1u-sled.stl` (**print this one twice** — one per Pi), `rack-1u-pin.stl`, `rack-1u-rod.stl`

- **Left piece:** Philips Hue Bridge (model 3241312018) — front push-rod
  reaches the top sync button, two split snap-fit posts engage the Bridge's
  own keyhole + oval mounting slots. The UniFi PoE++ Adapter (60W) clips
  onto 2 printed standoffs on the floor's underside (92.80mm hole spacing,
  front-to-back) and hangs below the shelf; a 48x28mm front window keeps
  both port labels readable.
- **Right piece:** two Raspberry Pi 5 + PoE HAT sleds — one Home Assistant,
  one TBD. Each slides in from the front and latches via a flexing tongue
  riding a ratchet tooth, rather than lifting out from above (earthquake
  country — a Pi swap never needs the panel pulled from the rack). USB
  ports face front.

**Joint:** 3x M3 bolt + nut, 2x filament dowel, per half-to-half seam (one
seam total on this panel) = **3 bolts, 3 nuts, 2 dowels**.

**Assembly:**
1. Dry-fit one Pi sled into the right piece before printing a second — check
   the latch clicks in and the pull-tab releases it cleanly.
2. Push the Hue Bridge down into its left-piece pocket until the snap posts
   click; thread the push-rod and pin into the button-pusher channel from
   the front.
3. Screw the PoE++ adapter onto its 2 underside standoffs (M3 self-tap).
   **Check there's genuinely empty space in the rack slot directly below**
   — the adapter hangs ~31mm below the shelf floor.
4. Screw each Pi 5 onto its sled (4x M2.5 each, 8x total), then slide both
   sleds into the right piece from the front until they latch.
5. Bolt the two halves together: heads go in from the left piece's face,
   nuts tighten on the right piece's face. Seat the filament dowels first
   so the faces can't shift while you torque the bolts.
6. Mount in the rack with M6 cage nuts.

**Open items:**
- Hue snap-post offsets are a photo estimate, not calipered — if a post
  doesn't land in its slot, that's the first thing to re-check.
- The Pi sled latch (flexing tongue + ratchet tooth) is untested as a
  physical mechanism. `ramp_h` in the .scad file is the knob to back off
  if the tooth grips too hard to release by hand.

---

## 2. 2U — Audio stacks (Kitchen + Owner's Bathroom AirPlay)

**Source:** `scad/rack-2u-audio-stacks.scad`
**Pieces:** `audio-1.stl`, `audio-2.stl`, `audio-3.stl`

Three bolt-together columns, each pairing one AirPort Express (upper U)
directly above one Kinter MA170 amp (lower U).

- **Columns 1 & 3 (active):** AirPort rear-flush with a full-face front
  window + floor dimple; Kinter front-flush with a control-panel window and
  two printed screw bosses under the amp's factory mounting tabs.
- **Column 2:** blank for now — floor levels are there, no devices cut in.

**Joint:** 2 seams (col 1-2, col 2-3), each 6x M3 bolt + nut (3 Y-positions x
2 Z-levels, one level per U) + 4x filament dowel = **12 bolts, 12 nuts, 8
dowels** total across both seams.

**Assembly:**
1. Print and dry-fit column 1 first — it's the active/populated design;
   column 2 is just a blank spacer.
2. Drop the AirPort Express into its upper-U window/dimple from the front.
3. Screw the Kinter MA170 into its lower-U mounting bosses (through the
   amp's factory tabs).
4. Bolt columns together in order (1-2, then 2-3), dowels first, same as
   the 1U panel.
5. Mount with M6 cage nuts — these columns carry protruding ear tabs that
   reach the rack's true 482.6mm hole spacing (the 3 columns' own content
   only spans 406.5mm).

**Open items:** none outstanding — this design hasn't needed any
corrections since it was built.

---

## 3. 1U — 24-port keystone patch panel

**Source:** `scad/rack-1u-keystone-panel.scad`
**Pieces:** `keystone-left.stl`, `keystone-right.stl` (12 ports each)

Standard 14.5 x 16mm keystone cutouts, industry-standard across brands.
Panel's thinned to 2.5mm specifically so keystone clips can actually engage
(the rest of this rack's panels are 4mm — too thick for most keystone
jacks' spring clips to reach). Ports sit low in the panel, leaving ~20mm of
clear space above each one for a label.

**Joint:** 3x M3 bolt + nut, 2x filament dowel = **3 bolts, 3 nuts, 2
dowels**.

**Assembly:**
1. **Print one piece and test a single keystone jack before printing both**
   — clip tolerance varies enough by brand/model that this is worth
   confirming. If jacks won't seat, thin the panel further; if they're
   loose, that's likely fine (the clip still does the retaining).
2. Snap jacks in from the front, terminated or not — they self-retain, no
   bracket needed behind the panel.
3. Bolt the two pieces together same as the other panels (heads from the
   left piece, nuts on the right, dowels first).
4. Mount with M6 cage nuts.

---

## Superseded / not included

- `rack-1u-kinter-amps.scad` — standalone single-amp panel, replaced by the
  2U audio stacks (each amp now pairs with its own AirPort Express instead).
- An earlier "keyhole" cable-management panel design was replaced entirely
  by the keystone panel above, per a wording correction mid-session — no
  files from that version exist.

Both are left out of this collection since they're not part of the current
build.
