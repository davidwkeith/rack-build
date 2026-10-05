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
- **Orientation:** every panel piece prints with its front plate face-down on
  the bed (the .scad files handle this rotation automatically — just slice
  the STL as exported, don't reorient it in the slicer)
- **Supports:** none, for any piece. Stops, bosses and rail ends rise at 45
  degrees from the wall they grow out of, and the only overhangs left in
  the exported STLs are short bridges (12mm inside the Hue push-rod pier,
  16mm under the Pi sled, a 48mm strip of floor over the PoE window) and
  the tops of horizontal screw holes and pegs. A slicer's automatic
  supports will still build towers under every one of those holes, so
  leave supports switched off. This comes from measuring the STLs, not
  from a finished print.
- **Layer height / infill:** no hard requirement from the design; 0.2mm /
  15-20% infill is a reasonable default. Parts with threads cut directly
  into the plastic (standoffs, bosses) will hold a self-tapping screw better
  with higher infill in that specific region if your slicer supports it.

To re-export every STL and preview image after changing a source file (needs
`openscad` on your PATH):

```sh
./build.sh
```

---

## Hardware shopping list (consolidated)

| Qty | Item | Used for |
|---|---|---|
| 18x | M3 x 8mm socket-head cap screw | Panel joints: 3 (1U Hue/Pi) + 12 (2U audio) + 3 (keystone) |
| 18x | M3 hex nut | Panel joints (nut traps) |
| 12x | 1.75mm filament offcuts, ~10mm long | Joint alignment dowels: 2 + 8 + 2 |
| 8x | M2.5 self-tapping screw | Raspberry Pi 5 to sled standoffs (4 per sled) |
| 2x | M3 self-tapping screw | PoE++ bracket standoffs |
| 4x | M3 self-tapping screw + 9mm washer | Kinter MA170 tab mounting (2 per active column); the washer spans the tab's slot |
| 12x | M6 cage nut + screw | Rack ears, 4 per panel (the 2U has 8 holes; 4 is enough) |

Every joint is two 6mm flanges with a 3mm head recess on one side and a
2.8mm nut trap on the other, so an 8mm bolt ends inside the nut. A 10mm
bolt also works on the 1U panels, but on the 2U's lower row it stands 1mm
proud into an amp bay that only has 0.75mm of side clearance.

---

## 1. 1U — Hue Bridge + PoE++ injector + 2x Raspberry Pi 5

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="images/rack-1u-hue-pi-dark.png">
  <img src="images/rack-1u-hue-pi.png" alt="1U shelf seen from the front: Hue bay with its push-rod on the left, two Raspberry Pi sleds on the right">
</picture>

*Assembled, with the separately printed sleds, push-rod and pin in red.*

**Source:** `scad/rack-1u-hue-pi.scad`
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
   the latch clicks in and lifting the pull lip releases it cleanly.
2. Bolt the two halves together while both are still empty: the bolt heads
   sit in the Hue bay and the nuts in the first Pi bay, and the Hue covers
   two of the three heads once it's in. Heads go in from the left piece's
   face, nuts tighten on the right piece's face. Seat the filament dowels
   first so the faces can't shift while you torque the bolts.
3. Push the Hue Bridge down into its left-piece pocket until the snap posts
   click; thread the push-rod and pin into the button-pusher channel from
   the front.
4. Screw the PoE++ adapter onto its 2 underside standoffs (M3 self-tap).
   **Check there's genuinely empty space in the rack slot directly below**
   — the adapter hangs ~31mm below the shelf floor.
5. Screw each Pi 5 onto its sled (4x M2.5 each, 8x total), USB/Ethernet
   toward the pull lip, then slide both sleds into the right piece from the
   front until they latch. To pull one, lift the lip under the Pi's ports
   and draw the sled out by it.
6. Mount in the rack with M6 cage nuts.

**Open items** (both need the real hardware, not more modelling):
- **Needs calipers:** the Hue snap-post offsets are a photo estimate — if a
  post doesn't land in its slot, that's the first thing to re-check
  (`khole_dy` / `oval_dy`).
- **Needs a test print:** the Pi sled latch (flexing tongue + ratchet tooth)
  clears every interference check in the model but is untested as a
  physical mechanism. `ramp_h` in the .scad file is the knob to back off
  if the tooth grips too hard to release by hand.

---

## 2. 2U — Audio stacks (Kitchen + Owner's Bathroom AirPlay)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="images/rack-2u-audio-stacks-dark.png">
  <img src="images/rack-2u-audio-stacks.png" alt="2U panel seen from the front: three bolted columns, the outer two with an AirPort window above an amp window">
</picture>

**Source:** `scad/rack-2u-audio-stacks.scad`
**Pieces:** `audio-1.stl`, `audio-2.stl`, `audio-3.stl`

Three bolt-together columns, each pairing one AirPort Express (upper U)
directly above one Kinter MA170 amp (lower U).

- **Columns 1 & 3 (active):** AirPort rear-flush with a full-face front
  window + floor dimple; Kinter front-flush with a control-panel window and
  two printed screw bosses under the amp's factory mounting tabs. Both
  floors sit 4mm above the U lines so those bosses stay inside the panel.
- **Column 2:** blank for now — floor levels are there, no devices cut in.

**Joint:** 2 seams (col 1-2, col 2-3), each 6x M3 bolt + nut (3 Y-positions x
2 Z-levels, one level per U) + 4x filament dowel = **12 bolts, 12 nuts, 8
dowels** total across both seams.

**Assembly:**
1. Print and dry-fit column 1 first — it's the active/populated design;
   column 2 is just a blank spacer.
2. Bolt the empty columns together in order (1-2, then 2-3), dowels first,
   same as the 1U panel. The bolt heads and nuts sit inside the bays, so
   this has to happen before the amps go in.
3. Slide each Kinter MA170 into its lower U from the rear and screw it to
   the floor bosses through the amp's factory tabs. The two driver holes in
   the upper floor sit straight above the tab screws: lower each screw and
   washer through on the driver.
4. Slide each AirPort Express into its upper U from the rear until it drops
   into the floor dimple; it covers the driver holes.
5. Mount with M6 cage nuts — these columns carry protruding ear tabs that
   reach the rack's true 482.6mm hole spacing (the 3 columns' own content
   only spans 406.5mm).

**Open items:**
- **Needs calipers:** amp dimensions and tab positions come from listings
  and a dimension diagram (see the notes in the .scad file). The driver
  holes and bosses both follow `amp_tab_inset` / `amp_tab_y`, so measure
  the tabs on a real amp before printing columns 1 and 3.

---

## 3. 1U — 24-port keystone patch panel

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="images/rack-1u-keystone-panel-dark.png">
  <img src="images/rack-1u-keystone-panel.png" alt="1U keystone panel seen from the front: two bolted halves with twelve square cutouts each">
</picture>

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
2. Bolt the two pieces together same as the other panels (heads from the
   left piece, nuts on the right, dowels first).
3. Snap jacks in from the rear, terminated or not — they self-retain, no
   bracket needed behind the panel.
4. Mount with M6 cage nuts.

---

## Also in the rack

The router isn't one of these panels. The UCG Fiber and its power supply
sit in the
[UCG Fiber + PSU 19 inch modular rack mount](https://www.printables.com/model/1359874-ucg-fiber-psu-19-inch-modular-rack-mount),
a separate design by the same author, [David W. Keith](https://dwk.io),
published on Printables.

---

## Superseded / not included

- `rack-1u-kinter-amps.scad` — standalone single-amp panel, replaced by the
  2U audio stacks (each amp now pairs with its own AirPort Express instead).
- An earlier "keyhole" cable-management panel design was replaced entirely
  by the keystone panel above — no files from that version exist.

Both are left out of this collection since they're not part of the current
build.

---

## Credits

All geometry here is original, but two ideas came from other people's
models on Printables:

- The Hue button pusher follows RobinUit's "button pusher" (model 480200).
- The front-loading Pi sleds nod to JaredC01's "1U Rackmount Cluster"
  (model 285853).

The Hue snap-post spacing was cross-checked against vladimir.aubrecht's
remix (model 125408) of Luther2k's Hue rack mount.

## License

[ISC](LICENSE) © David W. Keith
