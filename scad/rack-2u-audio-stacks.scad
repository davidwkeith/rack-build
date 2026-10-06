// 2U 19" rack panel, THREE bolt-together columns (one per bed-sized piece). Each column is
// one AirPort Express (upper U) directly above one Kinter MA170 amp (lower U) -- a stack per
// audio zone. Supersedes the old 1U left half (2x AirPort) and the standalone Kinter panel
// (which only fit 2 amps): this holds up to 3 zones, with the middle column blank by default.
// Hue + the PoE++ injector are NOT here -- they stay on their own panel (rack-1u-hue-pi.scad).
//
// Column width is set by the WIDER device (the Kinter amp); the AirPort, being narrower,
// sits centred in the same column. Each column is its own piece (three Kinter amps side by
// side would not fit one bed-sized piece, same constraint as before).
// Print front-plate-down (print_orient), same reasoning as the other panels: the control-panel
// and AirPort windows are too wide to bridge printed any other way.

/* [Part] */
part = "all"; // [all, 1, 2, 2-stack, 3]
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

/* [Kinter MA170 -- lower U. Calipered off a real amp. Its dimension diagram's 4-7/8" turned
   out to be the width across the mounting tabs and its 4-5/8" the depth over knobs and
   terminals; the case itself is a good deal smaller than either. ] */
amp_dims  = [103, 70, 43];     // case only: width, depth (no knobs or terminals), height
amp_tab_w = 124.5;             // width across the two mounting tabs, tip to tip
amp_clr   = 1.5;
amp_floor_t = 2;
amp_headroom = 1;              // between the amp's top and the upper floor
amp_front_gap = 3;
// Front window: the knobs stand 20 mm proud of the front plate (27 mm from the case face,
// through the 3 mm gap and 4 mm plate), so they reach out into the rack for finger adjustment.
// The window is sized to the knob cluster, centred on the case face.
amp_win_w = 100;  amp_win_h = 40;
// Tab slots are 3.5 mm wide x 12 mm long, 113 mm apart centre to centre, and run from 30 to
// 42 mm behind the case's front face. The tabs sit flat on the floor (the amp has no feet).
amp_tab_dx = 113;                 // slot centre to slot centre
amp_tab_y  = 36;                  // slot centre, behind the case's front face
amp_tab_pilot_d = 2.5;            // self-tap pilot, in the floor and the boss beneath it
amp_pilot_skin  = 1;              // pilot is BLIND: this much boss is left under it, so a screw
                                  // can never come out of the panel's underside. Longest screw
                                  // that is safe = tab thickness + (amp_floor_t + amp_boss_h
                                  // - amp_pilot_skin) = tab + 5 mm; aim for tab + 4..5 mm.
amp_boss_h = 4;                   // boss under each tab screw, so it has more than the thin
                                  // floor to bite into. The lower floor is raised by this much
                                  // so the bosses stay inside the panel's own 2U envelope.
vent_w = 3;                       // slots run front-to-back so a 3 mm bridge is all they cost
vent_pitch = 8;  vent_span = 90;  // across the amp's width, clear of the tab bosses and driver holes
amp_vent_y   = [10, 70];          // (y from the plate's back face) lower floor, under the amp: air in from the open underside
ap_vent_y    = [102, 124];        // upper floor, behind the AirPort (it ends at y=102, front-flush; the rear holders' lip is just behind it):
                                  // the amp's heat rises past the AirPort bay's open top instead
                                  // of being trapped under it
amp_tab_access_d = 8;             // driver holes through the UPPER floor, straight above the tab
                                  // screws -- the only vertical way in once the amp is in place

/* [AirPort Express 2nd gen -- upper U] */
ap_dims  = [98, 98, 23];
ap_clr   = 1.0;
ap_floor_t = 3;
ap_win_w = 98;  ap_win_h = 24;
ap_corner_r = 12;               // AirPort's plan-view corner radius (the holders trace it)
ap_holder_t = 1.6;              // curved holder wall thickness
ap_holder_h = 10;               // ... and height above the upper floor
ap_holder_len = 16;             // reach of each holder from the rear corner, along the rear and the side

/* [Joint hardware -- M3 + filament dowels, same as the other panels, now at two Z levels] */
bolt_d = 3.4;  head_d = 6.4;  head_depth = 3;
nut_af = 5.7;  nut_depth = 2.8;
dowel_d = 2.0; dowel_depth = 5;

z_amp = amp_boss_h;         // underside of the lower (amp) floor
z_ap  = z_amp + amp_floor_t + amp_dims[2] + amp_headroom;   // underside of the upper (AirPort) floor

amp_pw = amp_tab_w + amp_clr;         // the tabs, not the case, set the bay width
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
  // centre of the BAY, not of the piece: the two side walls differ in thickness on pieces 1 and 3
  cx = (left_is_flange ? flange_t : outer_t) + col_w / 2;
  tab_x = [for (dx = [-1, 1]) cx + dx * amp_tab_dx / 2];
  tab_y = plate_t + amp_front_gap + amp_tab_y;
  difference() {
    union() {
      skeleton(w, left_is_flange, left_side, right_is_flange, right_side);
      // bosses under the thin amp floor, so the tab screws have something to bite into
      for (x = tab_x) translate([x, tab_y, 0]) teardrop(10, amp_boss_h + 0.01);
      // curved holders at the AirPort's two rear corners, so it cannot slide back out of its bay
      translate([cx, ap_y0_front(), z_ap + ap_floor_t - 0.01])
        linear_extrude(height = ap_holder_h + 0.01) ap_rear_holders();
    }
    // Kinter: control-panel window the knobs poke through
    translate([cx - amp_win_w / 2, -0.1, z_amp + amp_floor_t + (amp_dims[2] - amp_win_h) / 2])
      cube([amp_win_w, plate_t + 0.2, amp_win_h]);
    // tab screw pilots -- blind, into the floor and its boss below, for a self-tap from above
    for (x = tab_x) translate([x, tab_y, amp_pilot_skin])
      cylinder(d = amp_tab_pilot_d, h = z_amp + amp_floor_t + 0.2 - amp_pilot_skin, $fn = 16);
    // vent slots: under the amp (intake) and in the upper floor behind the AirPort (exhaust)
    n_vent = floor(vent_span / vent_pitch) + 1;
    for (i = [0 : n_vent - 1]) {
      vx = cx + (i - (n_vent - 1) / 2) * vent_pitch - vent_w / 2;
      translate([vx, plate_t + amp_vent_y[0], z_amp - 0.1])
        cube([vent_w, amp_vent_y[1] - amp_vent_y[0], amp_floor_t + 0.2]);
      translate([vx, plate_t + ap_vent_y[0], z_ap - 0.1])
        cube([vent_w, ap_vent_y[1] - ap_vent_y[0], ap_floor_t + 0.2]);
    }
    // ... and the driver holes that let a screwdriver reach them through the upper floor
    for (x = tab_x) translate([x, tab_y, z_ap - 0.1])
      teardrop(amp_tab_access_d, ap_floor_t + 0.2, hole = true);
    // AirPort: full-front window (status light), front-flush (its face meets the plate, behind
    // the window), in the upper U. The curved rear holders are added below.
    translate([cx - ap_win_w / 2, -0.1, z_ap + ap_floor_t])
      cube([ap_win_w, plate_t + 0.2, ap_win_h]);
  }
  echo(str("column: amp front=", plate_t + amp_front_gap, " rear=", plate_t + amp_front_gap + amp_dims[1],
           " | AirPort front-flush, front=", ap_y0_front(), " rear=", ap_y0_front() + ap_dims[1], "  (shelf rear at y=", shelf_depth, ")"));
}
// Plan view, origin at the front-centre of the AirPort's footprint: the rounded-rectangle outline
// of the device (plus clearance) offset outward by the wall thickness, kept only within
// ap_holder_len of each rear corner.
module ap_rear_holders() {
  w = ap_pw;  d = ap_dims[1] + ap_clr;  t = ap_holder_t;
  intersection() {
    difference() {
      offset(r = ap_corner_r + t) translate([-w / 2 + ap_corner_r, ap_corner_r]) square([w - 2 * ap_corner_r, d - 2 * ap_corner_r]);
      offset(r = ap_corner_r)     translate([-w / 2 + ap_corner_r, ap_corner_r]) square([w - 2 * ap_corner_r, d - 2 * ap_corner_r]);
    }
    for (sx = [-1, 1]) translate([sx * (w / 2 + t - ap_holder_len / 2), d + t - ap_holder_len / 2])
      square([ap_holder_len, ap_holder_len], center = true);
  }
}
function ap_y0_front() = plate_t;   // AirPort's face sits against the front plate's back face

// Piece 1 and 3 carry an ear tab reaching to the rack's true outer edge (see ear_tab_w above);
// the column itself shifts over to make room for piece 1's tab on its left.
module piece_1() { ear_tab(true); translate([ear_tab_w, 0, 0]) column(P1_w, false, "", true, "nut"); }
// Piece 2 is blank by default, for a rack with two zones: the same structural skeleton as the
// outer columns (both floors, both joint flanges), just no AirPort/amp windows, dimple or tab
// bosses. piece_2_stack() is the drop-in alternative that adds a third zone's stack.
module piece_2() { skeleton(P2_w, true, "head", true, "nut"); }
module piece_2_stack() { column(P2_w, true, "head", true, "nut"); }
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
if (part == "2-stack") oriented() piece_2_stack();
if (part == "3" || part == "all") translate([x3, 0, 0]) oriented() piece_3();
