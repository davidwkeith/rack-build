// 2U 19" rack panel, THREE bolt-together columns (one per bed-sized piece). Each column is
// one AirPort Express (upper U) directly above one Kinter MA170 amp (lower U) -- a stack per
// audio zone. Supersedes the old 1U left half (2x AirPort) and the standalone Kinter panel
// (which only fit 2 amps): this is the complete 3-zone audio rack.
// Hue + the PoE++ injector are NOT here -- they stay on their own panel (rack-1u-hue-pi.scad).
//
// Column width is set by the WIDER device (the Kinter amp); the AirPort, being narrower,
// sits centred in the same column. Each column is its own piece (three Kinter amps side by
// side would not fit one bed-sized piece, same constraint as before).
// Print front-plate-down (print_orient), same reasoning as the other panels: the control-panel
// and AirPort windows are too wide to bridge printed any other way.

/* [Part] */
part = "all"; // [all, 1, 2, 3]
print_orient = true;

/* [Rack (EIA-310)] */
rack_w      = 482.6;
U           = 44.45;          // one rack unit
panel_h     = 2 * U - 0.79;   // 2U minus the same clearance used on the 1U panels
ear_hole_x  = 465.1;
ear_hole_dz = 31.75;          // hole-pair spacing within one U
ear_hole_d  = 6.8;

/* [Shelf] */
plate_t = 4;
wall_t  = 3;
flange_t = 6;   outer_t = 3;        // joint walls run the FULL 2U height on this design
shelf_depth = 130;

/* [Kinter MA170 -- lower U. Same figures/caveats as the standalone Kinter panel: two
   independent listings (US in, UK cm) agree on 124 x 117 x 41 mm; others for the same
   product disagree by ~2x, so confirm before printing. ] */
amp_dims  = [124, 117, 41];
amp_clr   = 1.5;
amp_floor_t = 2;               // thinned -- 41 mm amp only leaves 1.45 mm to spare in one U
amp_front_gap = 3;
amp_win_inset = 4;
// Mounting tabs confirmed by the official dimension diagram (4-7/8" = 123.8 mm is tab-to-tab,
// matching amp_dims[0] already -- no resize needed). Measured off that same diagram: each
// tab is ~15 mm wide with a ~7.7 x 13.9 mm oval slot, centred about 63 mm from the amp's rear
// edge (~mid-depth). Photo/diagram estimate, not calipered -- confirm before printing.
amp_tab_inset = 15 - 7.7 / 2;     // slot centre, in from each side edge
amp_tab_y     = 63;               // slot centre, measured from the amp's rear edge
amp_tab_pilot_d = 2.5;            // self-tap pilot, through the floor and the boss beneath it
amp_boss_h = 4;                   // boss under each tab screw, so it has more than the thin
                                  // floor to bite into. Both floors are raised by this much
                                  // so the bosses stay inside the panel's own 2U envelope.
amp_tab_access_d = 10;            // driver holes through the UPPER floor, straight above the tab
                                  // screws -- the only vertical way in once the amp is in place

/* [AirPort Express 2nd gen -- upper U] */
ap_dims  = [98, 98, 23];
ap_clr   = 1.0;
ap_floor_t = 3;
ap_win_w = 98;  ap_win_h = 24;
ap_dimple_depth = 1;  ap_dimple_inset = 3;

/* [Joint hardware -- M3 + filament dowels, same as the other panels, now at two Z levels] */
bolt_d = 3.4;  head_d = 6.4;  head_depth = 3;
nut_af = 5.7;  nut_depth = 2.8;
dowel_d = 2.0; dowel_depth = 5;

z_amp = amp_boss_h;         // underside of the lower (amp) floor
z_ap  = U + amp_boss_h;     // underside of the upper (AirPort) floor

amp_pw = amp_dims[0] + amp_clr;
ap_pw  = ap_dims[0] + ap_clr;
col_w  = amp_pw;                       // the wider device sets the column width
ap_x_margin = (col_w - ap_pw) / 2;     // AirPort is centred within the column

P1_w = outer_t + col_w + flange_t;
P2_w = flange_t + col_w + flange_t;
P3_w = flange_t + col_w + outer_t;
echo(str("column widths: 1=", P1_w, " 2=", P2_w, " 3=", P3_w,
         "  (3 cols use ", P1_w+P2_w+P3_w, " of ", rack_w, " mm rack width)"));

bolt_y  = [plate_t + 14, shelf_depth / 2, shelf_depth - 14];
bolt_z_levels  = [14, U + 14];
dowel_y = [plate_t + 28, shelf_depth - 28];
dowel_z_levels = [22, U + 22];

module xcyl(u, y, z, d, h, fn = 32) {
  translate([u, y, z]) rotate([0, 90, 0]) cylinder(d = d, h = h, $fn = fn);
}

// Flange-local coordinates: x=0 is the SEAM face, x=flange_t the interior (device-facing) face.
// Head recesses and nut traps open onto the interior face so they stay reachable once two
// columns are butted together; dowel sockets open onto the seam. A right-hand flange gets
// these same cuts mirrored (see skeleton()).
module joint_cuts(side) {
  for (y = bolt_y) for (z = bolt_z_levels) {
    xcyl(-0.1, y, z, bolt_d, flange_t + 0.2);
    if (side == "head") xcyl(flange_t - head_depth, y, z, head_d, head_depth + 0.1);
    else                 xcyl(flange_t - nut_depth, y, z, nut_af / cos(30), nut_depth + 0.1, 6);
  }
  for (y = dowel_y) for (z = dowel_z_levels)
    xcyl(-0.1, y, z, dowel_d, dowel_depth + 0.1, 24);
}

// The 3 columns only span 406.5 of the rack's 482.6 mm -- ear holes placed relative to a
// column's own edge would float in mid-air, well short of the actual rack rails. Real ear
// TABS make up the difference: a plain plate_t-thick flange reaching from the column's outer
// edge out to the rack's true mounting-hole position, same panel_h height as the front plate.
ear_tab_w = (rack_w - (P1_w + P2_w + P3_w)) / 2;
inset = (rack_w - ear_hole_x) / 2;   // hole inset from the TRUE rack edge, both ends

module ear_tab(hole_at_left) {
  u = hole_at_left ? inset : ear_tab_w - inset;
  difference() {
    cube([ear_tab_w, plate_t, panel_h]);
    for (u_center = [U / 2, U + U / 2])          // one hole-pair per U
      for (dz = [-1, 1])
        translate([u, -0.1, u_center + dz * ear_hole_dz / 2])
          rotate([-90, 0, 0]) cylinder(d = ear_hole_d, h = plate_t + 0.2, $fn = 40);
  }
}

module skeleton(w, left_is_flange, left_side, right_is_flange, right_side) {
  difference() {
    union() {
      cube([w, plate_t, panel_h]);                                                 // front plate
      translate([0, plate_t, z_amp]) cube([w, shelf_depth - plate_t, amp_floor_t]);  // lower floor
      translate([0, plate_t, z_ap]) cube([w, shelf_depth - plate_t, ap_floor_t]);    // upper floor
      if (left_is_flange) translate([0, plate_t, 0]) cube([flange_t, shelf_depth - plate_t, panel_h]);
      else cube([outer_t, shelf_depth, panel_h]);
      if (right_is_flange) translate([w - flange_t, plate_t, 0]) cube([flange_t, shelf_depth - plate_t, panel_h]);
      else translate([w - outer_t, 0, 0]) cube([outer_t, shelf_depth, panel_h]);
    }
    if (left_is_flange) translate([0, plate_t, 0]) joint_cuts(left_side);
    if (right_is_flange) translate([w, plate_t, 0]) mirror([1, 0, 0]) joint_cuts(right_side);
  }
}

// Vertical cylinder drawn out to a 45-degree point, so it prints unsupported plate-down: a
// boss points toward the front plate (the bed), a hole points away from it.
module teardrop(d, h, hole = false) {
  hull() {
    cylinder(d = d, h = h, $fn = 32);
    translate([0, (hole ? 1 : -1) * d / sqrt(2), 0]) cylinder(d = 0.01, h = h, $fn = 4);
  }
}

module column(w, left_is_flange, left_side, right_is_flange, right_side) {
  cx = w / 2;
  tab_x = [for (dx = [-1, 1]) cx + dx * (amp_dims[0] / 2 - amp_tab_inset)];
  tab_y = plate_t + amp_front_gap + amp_dims[1] - amp_tab_y;
  difference() {
    union() {
      skeleton(w, left_is_flange, left_side, right_is_flange, right_side);
      // bosses under the thin amp floor, so the tab screws have something to bite into
      for (x = tab_x) translate([x, tab_y, 0]) teardrop(10, amp_boss_h + 0.01);
    }
    // Kinter: front-flush control-panel window
    translate([cx - (amp_dims[0] - 2 * amp_win_inset) / 2, -0.1, z_amp + amp_floor_t + amp_win_inset])
      cube([amp_dims[0] - 2 * amp_win_inset, plate_t + 0.2, amp_dims[2] - 2 * amp_win_inset]);
    // tab screw pilots -- through the floor and its boss below, for a self-tap from above
    for (x = tab_x) translate([x, tab_y, -0.1])
      cylinder(d = amp_tab_pilot_d, h = z_amp + amp_floor_t + 0.2, $fn = 16);
    // ... and the driver holes that let a screwdriver reach them through the upper floor
    for (x = tab_x) translate([x, tab_y, z_ap - 0.1])
      teardrop(amp_tab_access_d, ap_floor_t + 0.2, hole = true);
    // AirPort: full-front window (status light) + floor dimple, rear-flush, in the upper U
    translate([cx - ap_win_w / 2, -0.1, z_ap + ap_floor_t])
      cube([ap_win_w, plate_t + 0.2, ap_win_h]);
    ap_y0 = shelf_depth - ap_dims[1];
    // the dimple's rear wall slopes at 45 degrees: printed plate-down it would otherwise be a
    // ledge hanging over the recess
    translate([cx - ap_dims[0] / 2 + ap_dimple_inset, ap_y0 + ap_dimple_inset, z_ap + ap_floor_t]) hull() {
      translate([0, 0, -ap_dimple_depth])
        cube([ap_dims[0] - 2 * ap_dimple_inset, ap_dims[1] - 2 * ap_dimple_inset - ap_dimple_depth, ap_dimple_depth + 0.01]);
      cube([ap_dims[0] - 2 * ap_dimple_inset, ap_dims[1] - 2 * ap_dimple_inset, 0.01]);
    }
  }
  echo(str("column: amp front=", plate_t + amp_front_gap, " rear=", plate_t + amp_front_gap + amp_dims[1],
           " | AirPort rear-flush, front=", ap_y0_echo(), "  (shelf rear at y=", shelf_depth, ")"));
}
function ap_y0_echo() = shelf_depth - ap_dims[1];

// Piece 1 and 3 carry an ear tab reaching to the rack's true outer edge (see ear_tab_w above);
// the column itself shifts over to make room for piece 1's tab on its left.
module piece_1() { ear_tab(true); translate([ear_tab_w, 0, 0]) column(P1_w, false, "", true, "nut"); }
// Blank for now -- both floor levels are there (same structural skeleton as the other two
// columns), just no AirPort/amp windows or dimple cut into it yet.
module piece_2() { skeleton(P2_w, true, "head", true, "nut"); }
module piece_3() { column(P3_w, true, "head", false, ""); translate([P3_w, 0, 0]) ear_tab(false); }

module oriented() {
  if (print_orient) translate([0, panel_h, 0]) rotate([90, 0, 0]) children();
  else children();
}

gap = (part == "all") ? 10 : 0;
x2 = (part == "all") ? ear_tab_w + P1_w + gap : 0;            // piece 1 carries its ear tab
x3 = (part == "all") ? ear_tab_w + P1_w + P2_w + 2 * gap : 0;
if (part == "1" || part == "all") oriented() piece_1();
if (part == "2" || part == "all") translate([x2, 0, 0]) oriented() piece_2();
if (part == "3" || part == "all") translate([x3, 0, 0]) oriented() piece_3();
