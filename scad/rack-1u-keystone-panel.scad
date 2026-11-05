// 1U 19" keystone patch panel, 24 ports (12 per piece), 2-piece bolt-together -- same EIA-310
// ears, M3 + nut-trap + filament-dowel joint, and front-plate-down print orientation as the
// other panels in this rack.
// Keystone cutout is a true industry standard, confirmed across multiple manufacturers
// (TrueCable, IDEAL, Digi-Key mechanical drawings): 14.5 mm wide x 16.0 mm tall, relying on
// the jack's own integrated spring clip + fulcrum to self-retain -- no bracket needed behind
// the panel. That clip has limited reach, though: one DIYer's mechanical-drawing check found
// a jack "barely tolerate[d]" a 2.0 mm panel and wouldn't take anything thicker. The rest of
// this rack's front plates are 4 mm; this one is thinned to 2.5 mm specifically so the clips
// have a real chance of engaging. PRINT A SINGLE TEST CUTOUT with your actual jacks before
// committing to a full 24-port print -- clip tolerance varies enough by brand that this is
// worth confirming, not assuming.
// v2: 2.5 mm was still too thick -- jacks wouldn't snap in (that's past the 2.0 mm the note
// above already flagged). The plate stays 2.5 mm for stiffness, but each port now gets a rear
// pocket that thins the material the latch and hook actually grab down to port_t, and the
// cutout gets port_clear of FDM slack (printed holes come out undersized, and the front face
// is the first layer, so elephant foot narrows it further). part="test" prints one port.
// v3: still too tight, and the latch couldn't compress enough to pass. Measured a jack body
// at 14.53 x 16.11 mm -- 0.3 mm total clearance left ~0.1 mm a side before FDM shrink. Width
// and height clearance are now separate (the latch side needs more), the front edge gets a
// chamfer to eat elephant foot, and part="test" is a 3-port ladder: -0.2 / +0 / +0.2 mm on
// both clearances, marked by 1 / 2 / 3 notches in the coupon's top edge.
// v4: the middle port (15.1 x 16.8) went in, but the latch had nothing to catch -- at 16.8 mm
// the catch sits inside the opening instead of overlapping its top edge. The 16.0 mm standard
// height is what gives the catch its bite, so height clearance goes back to 0 (the latch
// flexes to pass; that's its job). The front chamfer now only runs on the side edges: on the
// top/bottom edges it was shaving the lip the bottom hook needs. Width stays at the 15.1 mm
// that fit. The ladder now varies height only: 15.8 / 16.0 / 16.2 mm.

/* [Part] */
part = "both"; // [both, left, right, test]
print_orient = true;   // lie the panel flat instead of standing it on its thin edge -- same
                        // tip-over and horizontal-hole-printing reasons as the other panels

/* [Rack (EIA-310)] */
rack_w      = 482.6;
ear_hole_x  = 465.1;
ear_hole_dz = 31.75;
ear_hole_d  = 6.8;
panel_h     = 43.66;   // 1U minus clearance, matches the other panels
body_margin = 17.5;

/* [Plate] */
plate_t = 2.5;        // thinned for keystone clip engagement -- see header note
flange_depth = 10;    // joint flange reaches this far BEHIND the plate (there's no shelf/floor
                        // here to borrow overlap thickness from like the other panels, so each
                        // piece grows its own small flange block at the shared edge instead)

/* [Keystone cutouts] */
n_per_piece = 12;                 // 24 total across both pieces
keystone_w = 14.5;  keystone_h = 16.0;   // industry-standard cutout, confirmed across brands
clear_w    = 0.6;                 // added to cutout width  -> 15.1 mm (FDM holes print small)
clear_h    = 0.0;                 // added to cutout height -> 16.0 mm. Keep this tight: the
                                    // latch catch only overlaps the top edge by ~1 mm, and any
                                    // extra height lets it slip inside the hole (v3, 16.8 mm)
front_chamfer = 0.5;              // 45 deg on the cutout's front SIDE edges, eats elephant foot
                                    // (not top/bottom -- the hook and catch need those edges)
port_t     = 1.5;                 // plate thickness where the latch/hook engage (sheet-metal
                                    // panels are ~1.5 mm); rest of the plate stays plate_t
latch_relief = 3;                 // pocket reach above/below the cutout, room for the latch
                                    // and hook to seat on the thinned ledge
keystone_z = 15.83;               // moved down from centred (21.83) -- leaves ~20 mm of clear
                                    // panel above each port for a label, ~8 mm below

/* [Ear reinforcement] */
// The panel's thinned to 2.5 mm for the keystone clips, but a rack screw clamping down on
// only 2.5 mm of material right at the ear is asking for a cracked or stripped hole. Each ear
// gets a local pad bringing it back up to a sturdier 5 mm, running the full panel height.
ear_pad_w = 18;  ear_pad_t = 5;

/* [Joint (M3), same hardware as the other panels] */
bolt_d = 3.4;  head_d = 6.4;  head_depth = 3;
nut_af = 5.7;  nut_depth = 2.8;
dowel_d = 2.0; dowel_depth = 5;
flange_t = 6;  outer_t = 3;

half_w   = rack_w / 2;

// Port span has to clear BOTH ends now: the joint flange on one side, the ear pad on the
// other -- and which side is which flips between L and R (neither piece is mirrored, so
// "outer edge" is local X=0 for the left piece but local X=half_w for the right piece).
// gap is a buffer beyond each feature's own footprint; ear_half is the pad's reach from its
// own centre (ear_u), computed the same way per side in half_local() below.
port_gap  = 3;
// The ear itself sits (rack_w-ear_hole_x)/2 = 8.75 mm in from the piece's outer edge -- that
// inset has to be added, not just the pad's own half-width, or the first/last port overlaps
// the pad by about that same 8.75 mm (caught by checking the actual cutout, not just that
// port_gap looked reasonable on paper).
ear_half  = (rack_w - ear_hole_x) / 2 + ear_pad_w / 2 + port_gap;
flange_lo = flange_t + port_gap;
port_span = half_w - ear_half - flange_lo;
pitch     = port_span / n_per_piece;
echo(str("keystone pitch = ", pitch, " mm  (", keystone_w + clear_w, " mm port, ",
         pitch - keystone_w - clear_w, " mm gap between adjacent ports)"));
if (pitch < keystone_w + clear_w) echo("WARNING: pitch is narrower than the port itself -- ports would overlap");

bolt_z  = [panel_h * 0.22, panel_h * 0.5, panel_h * 0.78];   // 3 bolts, spread over the height
dowel_z = [panel_h * 0.36, panel_h * 0.64];

// cylinder along X, from x=u for length h -- bolts/dowels run this way, across the seam
module xcyl(u, y, z, d, h, fn = 32) {
  translate([u, y, z]) rotate([0, 90, 0]) cylinder(d = d, h = h, $fn = fn);
}

module keystone(cx, dh = 0) {
  w = keystone_w + clear_w;  h = keystone_h + clear_h + dh;  c = front_chamfer;
  translate([cx - w / 2, -1, keystone_z - h / 2]) cube([w, plate_t + 2, h]);
  hull() {   // front side-edge chamfer
    translate([cx - w / 2 - c, -0.01, keystone_z - h / 2]) cube([w + 2 * c, 0.01, h]);
    translate([cx - w / 2, c, keystone_z - h / 2]) cube([w, 0.01, h]);
  }
  // Rear pocket: only above/below the cutout (where latch and hook sit), same width as the
  // cutout so the webs between ports keep full plate_t. Opens upward when printed face-down.
  translate([cx - w / 2, port_t, keystone_z - h / 2 - latch_relief])
    cube([w, plate_t, h + 2 * latch_relief]);
}

// Fit ladder: three ports at -/0/+ test_step on height (width is settled), marked by 1/2/3
// notches in the top edge (2 notches = the defaults above). Same plate, chamfer and pocket.
test_step = 0.2;
module test_coupon() {
  sp = keystone_w + 8;
  difference() {
    cube([3 * sp, plate_t, panel_h]);
    for (i = [0 : 2]) {
      keystone(sp / 2 + i * sp, (i - 1) * test_step);
      for (n = [0 : i])
        translate([sp / 2 + i * sp + (n - i / 2) * 2.5 - 0.5, -1, panel_h - 2]) cube([1, plate_t + 2, 3]);
    }
  }
}

module half_local(side) {
  // The panel is only plate_t thick -- not enough material on its own for a bolt + nut-trap
  // joint, so each piece grows a flange_depth-deep block at the shared edge only (same M3 +
  // nut-trap + filament-dowel hardware as the other panels in this rack).
  fx0 = (side == "L") ? half_w - flange_t : 0;
  // Neither piece is mirrored -- each is built directly in its final position, so "near the
  // outer rack edge" is local X=0 for the left piece but local X=half_w for the right piece.
  // The flange (fx0, above) already accounts for this; the ear needs to as well.
  ear_u = (side == "L") ? (rack_w - ear_hole_x) / 2 : half_w - (rack_w - ear_hole_x) / 2;
  difference() {
    union() {
      cube([half_w, plate_t, panel_h]);
      translate([fx0, 0, 0]) cube([flange_t, flange_depth, panel_h]);
      // Ear reinforcement pad, see header note. One full-height strip from the piece's outer
      // edge to ear_pad_w/2 past the holes -- square pads centred on each hole would overhang
      // the panel's top, bottom and outer edges and foul the neighbouring rack units.
      ear_pad_x0 = (side == "L") ? 0 : ear_u - ear_pad_w / 2;
      translate([ear_pad_x0, 0, 0])
        cube([(rack_w - ear_hole_x) / 2 + ear_pad_w / 2, ear_pad_t, panel_h]);
    }
    for (dz = [-1, 1])
      translate([ear_u, -0.1, panel_h / 2 + dz * ear_hole_dz / 2])
        rotate([-90, 0, 0]) cylinder(d = ear_hole_d, h = ear_pad_t + 0.2, $fn = 40);
    // Start from whichever end has the EAR on this piece (ear_half clearance); the other end
    // clears the flange instead (flange_lo). Same swap as fx0/ear_u above.
    port_start = (side == "L") ? ear_half : flange_lo;
    for (i = [0 : n_per_piece - 1])
      keystone(port_start + pitch / 2 + i * pitch);
    // Bolts run ACROSS the seam (X), not into the panel (Y) -- each piece's flange is only
    // flange_t wide, so a bolt has to pass all the way through one piece's flange, across the
    // seam, and partway into the other piece's flange to reach the nut on the far side. Which
    // end is "outer" (head/nut) vs "seam-facing" flips with fx0/ear_u above: for L the flange
    // sits at the high-X end of the piece (outer face = low X, fx0 side); for R it sits at the
    // low-X end (outer face = high X, fx0+flange_t side).
    jy = flange_depth / 2;
    for (z = bolt_z) {
      xcyl(fx0 - 0.1, jy, z, bolt_d, flange_t + 0.2);
      if (side == "L") xcyl(fx0 - 0.1, jy, z, head_d, head_depth + 0.1);
      else              xcyl(fx0 + flange_t - nut_depth, jy, z, nut_af / cos(30), nut_depth + 0.1, 6);
    }
    // Dowels also cross the seam, same as the bolts -- a dowel pin spans the full combined
    // flange_t + flange_t once assembled.
    for (z = dowel_z) xcyl(fx0 - 0.1, jy, z, dowel_d, flange_t + 0.2, 24);
  }
}

module left_half()  { half_local("L"); }
module right_half() { translate([half_w, 0, 0]) half_local("R"); }

module oriented() {
  if (print_orient) translate([0, panel_h, 0]) rotate([90, 0, 0]) children();
  else children();
}

gap = (part == "both") ? 10 : 0;
if (part == "test") oriented() test_coupon();
if (part == "left"  || part == "both") oriented() left_half();
if (part == "right" || part == "both") translate([gap, 0, 0]) oriented() right_half();
