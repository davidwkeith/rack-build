// 1U 19" rack mount, two halves bolted at the centre.
//   Left half : 1x Hue Bridge v2 + 1x Ubiquiti PoE++ Adapter (60W, U-POE++)
//   Right half: 2x Home Assistant Raspberry Pi 5 + PoE HAT, each on a removable sled (below)
// The Hue sits rear-flush (ports at the back) and gets a front push-rod button pusher (see its
// own section below) -- no LED light pipes, the unit's status LEDs are too dim to be worth
// routing. The PoE++ injector hangs from standoffs under the floor -- its Ethernet ports face
// the rack front through a window, AC cord exits to the rear.
// Print each half front-plate-down (print_orient = true), no supports. PETG, brim helps.
// Half is 241.3 mm wide; MK3S bed is 250 x 210.
// Model coordinates: X across, Y front(0)->rear, Z up. Floor bottom at Z=0.

/* [Part] */
part = "both"; // [both, assembly, left, right, pin, rod, sled]

/* [Rack (EIA-310)] */
rack_w      = 482.6;
ear_hole_x  = 465.1;   // hole centre-to-centre
ear_hole_dz = 31.75;   // 1U hole pair spacing
ear_hole_d  = 6.8;     // M6 cage-nut clearance
panel_h     = 43.66;   // 1U minus clearance
body_margin = 17.5;    // keep body inside the rails

/* [Shelf] */
plate_t     = 4;
floor_t     = 3;
wall_t      = 3;
wall_h      = 37;      // above floor -- tall enough to contain the PoE injector (34 mm) + a lip
flange_t    = 6;       // joint flange per half
shelf_depth = 116;     // includes plate_t -- deepened for the 106 mm-long PoE++ injector

/* [Devices: width(X) x depth(Y) x height(Z)] */
hue_dims = [91, 91, 26];     // Philips spec: ~90.6 x 90.9 x 26 mm
clr      = 1.0;              // total side clearance, all devices
hue_stop = 0.5;               // gap between Hue front and its stop wall
stop_wall_h = 25;             // front-registration rib height for Hue (capped by the room in
                               // front of it) -- stays low so it doesn't block the Hue pusher rod
hue_stop_dx = 28;             // the two stop ribs sit this far either side of the Hue's centre

/* [PoE++ mounting bracket (screws to the shelf UNDERSIDE; adapter clips onto the bracket's
   own sliders and hangs below the shelf -- it is no longer in a floor pocket) ] */
// Only 2 real screw holes -- the large countersunk pair, 92.80 mm apart centre-to-centre
// (direct caliper reading between the holes themselves, not a photo-scale estimate). The
// small holes next to the cleat aren't mounting points at all: they're part of how the
// adapter LATCHES onto the cleat, not how the bracket attaches to whatever it's screwed to.
// Hole diameter is still a photo estimate -- confirm before printing.
// Orientation: in normal use the bracket mounts to a WALL with Ethernet at the top, power
// cord at the bottom -- so the two holes sit along the Ethernet-to-power axis. That's the
// same axis as the adapter's own front(Ethernet)-to-rear(power) run through this rack, so
// the holes go along Y (front-to-back), not X, with the front one nearer the window above.
// CAUTION: the bracket is a thin plate, but the clipped-on adapter is ~31 mm thick in this
// orientation (measured; spec sheet says 34) and hangs straight down from the shelf floor --
// that will very likely intrude
// into whatever occupies the 1U slot directly below (e.g. the Kinter amp panel) unless a
// clear 1U gap is left there. Check real rack clearance before committing to this mount.
bracket_hole_dy = 46.4;    // half-spacing: 2 holes, 92.80 mm apart, same X (front/rear of bracket_cy)
bracket_cx = 162;          bracket_cy = shelf_depth / 2;   // centre of the hole pattern, in the
                                                             // left half's spare bay (local u)
                                                             // -- pick your own spot if this is wrong
bracket_pilot_d = 2.5;     // pilot hole for a self-tapping M3
bracket_boss_d  = 7;       bracket_boss_h = 4;   // printed standoff, hangs below the floor
// Connector end measured directly with calipers: 63.94 mm wide, ~31.2 mm tall (vs. 63 x 34 mm
// from Ubiquiti's spec sheet -- close on width, spec runs a bit tall, probably measured over a
// foot or lip calipers didn't catch). Widened from a plain cable slot to a real window so the
// two port labels (data / PoE++) printed above the jacks stay readable, not just cable access.
poe_pass_w = 48;  poe_pass_h = 28;  poe_pass_drop = 6;   // front window, open at the plate's
                                                           // bottom edge since the adapter hangs
                                                           // below rather than sitting in a pocket

/* [Home Assistant Pi sled -- front-slide, latching, swappable tray]
   Earthquake country, and the Pis are the part most likely to get swapped -- so the sled now
   slides in and out through the FRONT on a pair of rails, with a spring latch, instead of
   lifting out from above. A vertical lift would need clearance above this 1U that may not
   exist once the rack is populated; a front slide never requires pulling the panel. Concept
   nods to JaredC01's "1U Rackmount Cluster" (Printables 285853) but the mechanism is
   original -- theirs locks 5 sleds together with an all-thread rod through interlocking
   modules, built for a 5-bay PoE+OLED cluster; this is one bay with a simple channel + latch.
   UNTESTED PRINT-AND-FIT, like every other snap/latch in this file: dry-fit the rail
   clearance and latch spring force before committing to a full print. */
sled_dims = [95, 100, 3];        // W x D x plate thickness
sled_clr  = 1.5;                 // side clearance, bay vs sled
sled_corner = 6;                 // 45-degree cut on the sled's rear corners (see the rear stops)
sled_front_gap = 2;              // sled's front edge, FULLY INSERTED, to the plate's inner face
sled_overtravel = 1;             // how far past its latched position the sled can be pushed before
                                 // it meets the rear stop -- without this the catch bar has only
                                 // latch_clr to drop behind the tooth, less than print tolerance

/* [Pi sled rails + latch] */
rail_t = 1.6;      rail_depth = 4;     // retention lip: thickness, reach in from each side wall
rail_z0 = 0.3;                          // lip floats this far above the sled plate's top face
rail_start = 16;                        // lip begins this far back from the front opening, so
                                          // the sled's leading edge is already past the window
                                          // before the rails start gripping it
latch_w = 14;       latch_len = 30;     // cantilever tongue cut into the sled plate: width, length
latch_slit = 1;                         // slit width freeing the tongue to flex
latch_travel = 8;                       // rear edge of the tongue's catch bar, from the sled's
                                          // front edge. The bar is the only part of the sled left
                                          // full-thickness along the tooth's track -- the rest of
                                          // that track is relieved underneath (see pi_sled()) so
                                          // the sled can pass over the raised tooth at all
latch_catch = 3;                        // catch bar length; the tooth's sheer face lands just
                                          // in front of it once the sled is fully inserted
latch_clr = 0.3;                        // tooth-to-sled clearance, vertical and fore/aft
lip_ridge = [1.5, 2.5];                 // finger ridge at the pull lip's tip: thickness, height
ramp_len = 6;        ramp_h = 1.2;      // ratchet tooth: gentle rise over ramp_len, then an
                                          // immediate sheer drop -- easy to slide in over, caught
                                          // behind the drop when pulled back out

// Official Pi mounting pattern (85 x 56 mm board, 58 x 49 mm hole rectangle inset 3.5 mm from
// the SD-card end and both long edges -- so the nearer hole row sits 23.5 mm back from the
// USB/Ethernet edge, not 3.5 mm).
pi_board = [56, 85];  pi_hole_x = 49;  pi_hole_y = 58;  pi_hole_inset = 3.5;
// USB ports face the FRONT (e.g. a Zigbee/Z-Wave dongle for Home Assistant, reachable
// without pulling the sled) -- USB-A and Ethernet share one edge on the Pi so they move
// together, meaning the PoE/Ethernet cable runs from the front too. SD card edge faces the
// sled's rear. USB-C power and HDMI go unused either way under PoE power.
pi_front_gap = 2.5;               // board's USB/Ethernet edge to the sled's own FRONT edge
so_h = 5;  so_d = 5.5;  pilot = 2.2;        // standoffs, printed ON the sled. Tall enough that the
                                            // latch tongue can rise ~1.5 mm beneath the board
                                            // without reaching its connector pins (~2 mm)
sled_open_w = 95 + sled_clr;                // front opening: full sled cross-section passes through
sled_open_h = 37;                           // clears sled + standoffs + Pi + PoE HAT + fan

/* [Hue mounting-slot snap posts] */
// Philips moulds two slots into the Hue's underside for wall-mounting: a true keyhole
// (round head-clearance + narrower neck) and a plain oval. Measured from a handheld photo,
// offset from the device's own centre (same reference as hue_yc), scaled off the 91 mm body:
// both read as roughly centred in X, ~22.2 mm to either side of centre in Y -- keyhole toward
// the front, oval toward the rear. Each post is a split, barbed boss sized to its slot so the
// bridge presses straight down onto them (snap-fit) instead of hanging-and-sliding like a real
// wall mount. Dry-fit before committing -- neither the exact offsets nor the slot depth are
// measured directly, only estimated from the photo.
// Spacing cross-checked against vladimir.aubrecht's Printables remix (model 125408, itself a
// remix of Luther2k's original Hue rack mount) of a working pin-based mount: its two round
// locating pins measure 45.5 mm apart on the same X -- within 1.1 mm of this photo estimate,
// so the offsets below are split evenly across that spacing.
khole_dx   = 0;      khole_dy   = -22.75;  // keyhole slot: neck ~5 mm, wide end ~9.7 mm
oval_dx    = 0;      oval_dy    = 22.75;   // oval slot: ~9.2 x 10.8 mm
post_h     = 5;                // total height above the floor (engages a ~2.5-3 mm deep slot)
post_taper = 1;                // conical lead-in at the tip, eases the press
slit_w     = 0.6;               // compliance slit through the barb (both axes -- a cross-slit)
khole_shaft_d = 4.2;  khole_barb_d = 5.8;   // through the ~5 mm neck
oval_shaft_d  = 8.2;  oval_barb_d  = 10.0;  // through the ~9.2 mm oval width

/* [Hue button pusher: front push-rod + pin] */
// Idea from RobinUit's "button pusher" (Printables 480200); geometry here is original.
// Push the rod in from the front; its tip wedges a chamfered pin down onto the top button.
btn_dx = 0;                  // button offset from device centre (X); measure with calipers
btn_dy = 0;                  // ... (Y, + = toward rear). Assumed centred.
btn_top = 0;                 // button height above the bridge's top surface
btn_travel = 1.5;            // pin stroke. Effective press is ~0.4 less; raise if it won't click
hue_gap = 1.0;               // beam clearance above the bridge
arm_t = 3;  lip_t = 2.6;  side_t = 2.5;
rod_w = 12; rod_h = 4;  rod_clr = 0.2;  lip_clr = 0.3;
open_w = 9.6;                // pin-loading slot between the lips
pin_d = 5;  pin_hole_d = 5.6;  pin_head_d = 9;  pin_head_h = 3;
pin_ch_top = 1.5;  pin_ch_tail = 1.7;
stroke = 5;  rod_fl_t = 3;  rod_fl_w = 24;  rod_fl_h = 7;   // rod knob flange

/* [Print] */
print_orient = true;         // left/right STLs: front plate face-down on the bed (windows would
                             // need a 98 mm bridge if printed floor-down). "both" stays assembled.

/* [Joint (M3)] */
bolt_d     = 3.4;
head_d     = 6.4;
head_depth = 3;
nut_af     = 5.7;            // M3 nut across flats + slop
nut_depth  = 2.8;
dowel_d    = 2.0;            // 1.75 mm filament offcuts as alignment pins
dowel_depth = 5;

half_w   = rack_w / 2;
body_end = half_w - body_margin;

left_items  = ["hue"];                  // + PoE++ bracket on the underside, see below
right_items = ["pi_sled", "pi_sled"];   // 2x Raspberry Pi 5 + PoE HAT, each on its own sled

function dev(t) = t == "hue" ? hue_dims : sled_dims;
function pw(t)  = dev(t)[0] + (t == "pi_sled" ? sled_clr : clr);
function off(items, i) = i == 0 ? flange_t : off(items, i - 1) + pw(items[i - 1]) + wall_t;

bolt_y = [plate_t + 12, (plate_t + shelf_depth) / 2, shelf_depth - 12];
bolt_z = floor_t + 9;
dowel_y = [plate_t + 26, shelf_depth - 26];
dowel_z = floor_t + 16;
wall_top = floor_t + wall_h;
ear_u = half_w - (rack_w - ear_hole_x) / 2;

zt       = floor_t + hue_dims[2];            // top of the Hue Bridge
arm_bot  = zt + hue_gap;
arm_top  = arm_bot + arm_t;
z_rb     = arm_top + pin_head_h;             // rod bottom = pressed pin-head top
lip_bot  = z_rb + rod_h + lip_clr;
chan_top = lip_bot + lip_t;
chan_w   = rod_w + 2 * rod_clr;
tw       = chan_w + 2 * side_t;
pin_len  = arm_top + btn_travel - (zt + btn_top);
hue_u    = off(left_items, 0) + pw("hue") / 2 + btn_dx;   // button X in Hue's half, local u
hue_yc   = shelf_depth - hue_dims[1] / 2 + btn_dy;
if (chan_top > panel_h - 0.3) echo("WARNING: pusher guide too tall for 1U", chan_top);

module push_guide(cx, yc) {
  y1 = shelf_depth - hue_dims[1] - hue_stop;
  y_end = yc + pin_head_d / 2 + 3.5;
  difference() {
    union() {
      translate([cx - tw / 2, y1 - 6, 0]) cube([tw, 6, chan_top]);                               // pier
      // legs carrying the pier forward to the front plate: printed plate-down it then grows up
      // from the plate (bridging the rod's width between the legs) instead of hanging off the floor
      for (x = [cx - tw / 2, cx + tw / 2 - side_t])
        translate([x, plate_t - 0.01, 0]) cube([side_t, y1 - 6 - plate_t + 0.02, chan_top]);
      translate([cx - tw / 2, y1 - 0.01, arm_bot]) cube([tw, y_end - y1 + 0.01, chan_top - arm_bot]); // beam
    }
    translate([cx - chan_w / 2, y1 - 6.1, z_rb - 0.2]) cube([chan_w, 6.2, rod_h + 0.4]);          // rod slot in pier
    translate([cx - chan_w / 2, y1, arm_top]) cube([chan_w, y_end - y1 + 0.1, lip_bot - arm_top]); // cavity
    translate([cx - open_w / 2, y1, lip_bot - 0.01]) cube([open_w, y_end - y1 + 0.1, lip_t + 0.02]); // pin slot
    translate([cx, yc, arm_bot - 0.1]) cylinder(d = pin_hole_d, h = arm_t + 0.2, $fn = 40);        // pin hole
  }
}

// pin: axis Z, bottom (tail) at z=0
module pin() {
  rotate_extrude($fn = 48) polygon([
    [0, 0], [pin_d / 2 - pin_ch_tail, 0], [pin_d / 2, pin_ch_tail], [pin_d / 2, pin_len],
    [pin_head_d / 2, pin_len], [pin_head_d / 2, pin_len + pin_head_h - pin_ch_top],
    [pin_head_d / 2 - pin_ch_top, pin_len + pin_head_h], [0, pin_len + pin_head_h]]);
}

// rod in shelf-local coordinates; press = 0 rest .. stroke pressed
module rod_placed(cx, yc, press = 0) {
  y_tip = yc - pin_head_d / 2 - 1.5 + press;
  translate([cx - rod_w / 2, -stroke + press, z_rb]) cube([rod_w, y_tip + stroke - press, rod_h]);
  translate([cx - rod_fl_w / 2, -stroke - rod_fl_t + press, z_rb]) cube([rod_fl_w, rod_fl_t, rod_fl_h]);
}

// Split, barbed snap boss: the device presses straight down from above. Shaft, then a bead
// (cone out to barb_d, back down to a small guide tip) so the barb compresses going past the
// slot's edge in EITHER direction -- an easy, repeatable snap rather than a one-way ratchet.
// A cross-slit (two perpendicular cuts) lets the bead compress.
module snap_post(cx, cy, shaft_d, barb_d, h = post_h, taper = post_taper, slit = slit_w) {
  bead_h = taper;
  difference() {
    union() {
      translate([cx, cy, floor_t]) cylinder(d = shaft_d, h = h - bead_h, $fn = 28);
      translate([cx, cy, floor_t + h - bead_h])
        cylinder(d1 = shaft_d, d2 = barb_d, h = bead_h / 2, $fn = 28);
      translate([cx, cy, floor_t + h - bead_h / 2])
        cylinder(d1 = barb_d, d2 = shaft_d * 0.5, h = bead_h / 2, $fn = 28);
    }
    // the slits run diagonally so that, printed plate-down, no prong has a flat underside
    for (a = [45, 135]) translate([cx, cy, floor_t - 0.1]) rotate(a)
      translate([-slit / 2, -barb_d, 0]) cube([slit, barb_d * 2, h + 0.2]);
  }
}

// Screw boss with a 45-degree point toward the front plate, so it prints unsupported plate-down.
module boss(d, h) {
  hull() {
    cylinder(d = d, h = h, $fn = 24);
    translate([0, -d / sqrt(2), 0]) cylinder(d = 0.01, h = h, $fn = 4);
  }
}

module xcyl(u, y, z, d, h, fn = 32) {
  translate([u, y, z]) rotate([0, 90, 0]) cylinder(d = d, h = h, $fn = fn);
}

module half_local(side) {
  items = side == "L" ? left_items : right_items;
  n = len(items);
  spare = body_end - wall_t - off(items, n);
  echo(str(side, " half: spare bay = ", spare, " mm"));
  if (spare < 0) echo("WARNING: devices overrun the body width");

  difference() {
    union() {
      cube([half_w, plate_t, panel_h]);                                            // front plate
      translate([0, plate_t, 0]) cube([body_end, shelf_depth - plate_t, floor_t]); // floor
      translate([0, plate_t, 0]) cube([flange_t, shelf_depth - plate_t, wall_top]);// joint flange
      translate([body_end - wall_t, plate_t, 0])
        cube([wall_t, shelf_depth - plate_t, wall_top]);                           // outer wall
      for (i = [0 : n - 1]) {
        t = items[i];
        u0 = off(items, i);
        translate([u0 + pw(t), plate_t, 0])
          cube([wall_t, shelf_depth - plate_t, wall_top]);                         // divider
        // Front stop: two ribs, with the pusher pier's rear face between them as a third. Each
        // rib is a 45-degree gusset rising off the floor, so plate-down it prints unsupported
        // (a full-width wall here would be a pair of 37 mm bridges).
        if (t == "hue") {
          y1 = shelf_depth - dev(t)[1] - hue_stop;
          rib_h = min(stop_wall_h - floor_t, y1 - wall_t - plate_t);
          for (dx = [-1, 1]) translate([u0 + pw(t) / 2 + dx * hue_stop_dx - wall_t / 2, 0, 0]) hull() {
            translate([0, y1 - wall_t, 0]) cube([wall_t, wall_t, floor_t + rib_h]);
            translate([0, y1 - wall_t - rib_h, 0]) cube([wall_t, 0.01, floor_t]);
          }
        }

        if (t == "hue") {
          push_guide(u0 + pw(t) / 2 + btn_dx, hue_yc);                            // button pusher guide
          snap_post(u0 + pw(t) / 2 + khole_dx, hue_yc + khole_dy, khole_shaft_d, khole_barb_d);
          snap_post(u0 + pw(t) / 2 + oval_dx,  hue_yc + oval_dy,  oval_shaft_d,  oval_barb_d);
        }
      }
      if (side == "L")   // PoE++ bracket standoffs, hang below the floor -- see caution above
        for (dx = [-1, 1])
          translate([bracket_cx, bracket_cy + dx * bracket_hole_dy, -bracket_boss_h])
            boss(bracket_boss_d, bracket_boss_h);
      // Pi sled rails, rear stops and latch ramp -- see the per-item cut block for the matching
      // front opening. Rails run from just behind the opening to near the bay's rear, floating
      // just above the sled's plate so it can slide but not lift out.
      for (i = [0 : n - 1]) if (items[i] == "pi_sled") {
        u0 = off(items, i);
        bcx = u0 + pw("pi_sled") / 2;
        sled_y0 = plate_t + sled_front_gap;
        rail_y0 = plate_t + rail_start;
        rail_y1 = sled_y0 + sled_dims[1] - 4;             // stop a little short of the rear stop
        // each lip grows out of its wall at 45 degrees, so its front end prints unsupported
        for (m = [0, 1])
          translate([u0 + m * pw("pi_sled"), 0, floor_t + sled_dims[2] + rail_z0]) mirror([m, 0, 0])
            linear_extrude(rail_t)
              polygon([[0, rail_y0 - rail_depth], [rail_depth, rail_y0], [rail_depth, rail_y1], [0, rail_y1]]);
        // rear stops: a 45-degree wedge in each rear corner, matching the sled's cut corners.
        // They centre the sled as it seats, and plate-down they print unsupported.
        y_rear = sled_y0 + sled_dims[1] + sled_overtravel;
        for (m = [0, 1]) translate([u0 + m * pw("pi_sled"), 0, 0]) mirror([m, 0, 0])
          linear_extrude(floor_t + sled_dims[2] + rail_z0 + rail_t)
            polygon([[0, y_rear - sled_corner - sled_clr / 2], [sled_corner + sled_clr / 2, y_rear], [0, y_rear]]);
        peak_y = sled_y0 + latch_travel - latch_catch;   // sheer face, just ahead of the catch bar
        hull() {
          translate([bcx - latch_w / 2, peak_y - ramp_len, floor_t]) cube([latch_w, 0.1, 0.1]);
          translate([bcx - latch_w / 2, peak_y - 0.1, floor_t]) cube([latch_w, 0.1, ramp_h]);
        }
      }
    }
    // rack ear holes
    for (dz = [-1, 1])
      translate([ear_u, -0.1, panel_h / 2 + dz * ear_hole_dz / 2])
        rotate([-90, 0, 0]) cylinder(d = ear_hole_d, h = plate_t + 0.2, $fn = 40);
    // rod hole through the front plate for the Hue pusher
    for (i = [0 : n - 1]) if (items[i] == "hue")
      translate([off(items, i) + pw("hue") / 2 + btn_dx - chan_w / 2, -0.1, z_rb - 0.2])
        cube([chan_w, plate_t + 0.2, rod_h + 0.4]);
    // Pi sled bay: full front opening -- the whole sled + Pi + PoE HAT slides through here,
    // then rides the rails (added above) back to its latched position.
    for (i = [0 : n - 1]) if (items[i] == "pi_sled") {
      bcx = off(items, i) + pw("pi_sled") / 2;
      translate([bcx - sled_open_w / 2, -0.1, floor_t])
        cube([sled_open_w, plate_t + 0.2, sled_open_h]);
    }
    // PoE++ bracket pilot holes (Hue's half only -- cut after the boss geometry is unioned in)
    if (side == "L")
      for (dx = [-1, 1])
        translate([bracket_cx, bracket_cy + dx * bracket_hole_dy, -bracket_boss_h - 0.1])
          cylinder(d = bracket_pilot_d, h = bracket_boss_h + floor_t + 0.2, $fn = 16);
    // PoE++ cable pass-through: hanging below via the underside bracket, the adapter's
    // Ethernet end (LAN-in + PoE-out -- "PoE++ output" is that second jack) sits roughly at
    // the front plate already, assuming the adapter's long axis runs front-to-back on the
    // bracket with Ethernet forward and the 110V cord toward the rear (matching "ethernet on
    // the front, 110V on the back"). Open notch in the plate's bottom-front edge for both
    // RJ45 cables to route up to the front rather than being stuck underneath.
    if (side == "L")
      translate([bracket_cx - poe_pass_w / 2, -0.1, -poe_pass_drop]) cube([poe_pass_w, plate_t + 0.2, poe_pass_h + poe_pass_drop]);
    // joint bolts: head recess on left, nut trap on right, both on the device-facing face
    for (y = bolt_y) {
      xcyl(-0.1, y, bolt_z, bolt_d, flange_t + 0.2);
      if (side == "L") xcyl(flange_t - head_depth, y, bolt_z, head_d, head_depth + 0.1);
      else             xcyl(flange_t - nut_depth,  y, bolt_z, nut_af / cos(30), nut_depth + 0.1, 6);
    }
    // filament-dowel sockets in the joint face
    for (y = dowel_y) xcyl(-0.1, y, dowel_z, dowel_d, dowel_depth + 0.1, 24);
  }
}

module left_half()  { translate([half_w, 0, 0]) mirror([1, 0, 0]) half_local("L"); }
module right_half() { translate([half_w, 0, 0]) half_local("R"); }

module oriented() {
  if (print_orient) translate([0, panel_h, 0]) rotate([90, 0, 0]) children();
  else children();
}

// Removable Pi sled: flat tray + standoffs (M2.5 self-tap) in the official 58 x 49 mm Pi
// pattern, board oriented USB/Ethernet-forward. A cantilever latch tongue (two slits, open at
// the sled's front edge) carries a full-thickness catch bar; everything else along the shelf
// tooth's track is relieved on the underside so the sled slides over the tooth freely. As the
// sled goes home the bar climbs the tooth's gentle front slope, lifting the tongue, then drops
// behind the sheer back face. The tongue carries on forward through the front opening as a
// pull lip with a finger ridge: lift it to clear the tooth, then pull the sled out by it. The
// lip sits in front of the Pi's connectors rather than under the board, so the only thing that
// has to rise beneath the board is the bare tongue.
module pi_sled() {
  cx = sled_dims[0] / 2;
  by0 = pi_front_gap;   // board's front (USB/Ethernet) edge, local to the sled
  hole_y0 = by0 + pi_board[1] - pi_hole_inset - pi_hole_y;   // front hole row
  catch_y0 = latch_travel - latch_catch + latch_clr;         // catch bar's front (latching) face
  // toe of the tooth, with the sled pushed hard against the rear stop
  pocket_y0 = latch_travel - latch_catch - ramp_len - latch_clr - sled_overtravel;
  lip_y0 = -(sled_front_gap + plate_t - 1);                  // lip stops 1 mm short of the panel face
  relief_w = latch_w + 2 * latch_slit;
  relief_h = ramp_h + latch_clr;
  difference() {
    union() {
      cube(sled_dims);
      for (dx = [-1, 1], dy = [0, 1])
        translate([cx + dx * pi_hole_x / 2, hole_y0 + dy * pi_hole_y, sled_dims[2] - 0.01])
          cylinder(d = so_d, h = so_h + 0.01, $fn = 32);
      translate([cx - latch_w / 2, lip_y0, 0])                         // pull lip
        cube([latch_w, -lip_y0 + 0.01, sled_dims[2]]);
      translate([cx - latch_w / 2, lip_y0, sled_dims[2] - 0.01])       // finger ridge
        cube([latch_w, lip_ridge[0], lip_ridge[1] + 0.01]);
    }
    for (dx = [-1, 1], dy = [0, 1])
      translate([cx + dx * pi_hole_x / 2, hole_y0 + dy * pi_hole_y, sled_dims[2] + so_h - 6])
        cylinder(d = pilot, h = 6.1, $fn = 24);
    // the two slits that free the latch tongue to flex: free at the front edge, anchored at latch_len
    for (x = [cx - latch_w / 2 - latch_slit, cx + latch_w / 2])
      translate([x, -0.1, -0.1]) cube([latch_slit, latch_len + 0.1, sled_dims[2] + 0.2]);
    // rear corners cut at 45 degrees to seat against the shelf's corner stops
    for (m = [0, 1]) translate([m * sled_dims[0], sled_dims[1], -0.1]) mirror([m, 0, 0])
      linear_extrude(sled_dims[2] + 0.2)
        polygon([[-0.1, -sled_corner - 0.1], [-0.1, 0.1], [sled_corner + 0.1, 0.1]]);
    // underside relief along the tooth's track: a pocket ahead of the catch bar (where the tooth
    // sits once latched) and a clearance channel behind it, out through the sled's rear edge.
    // The lip and the bar both stay full thickness, so printed flat the pocket's roof bridges
    // between them instead of hanging free.
    for (seg = [[pocket_y0, catch_y0], [latch_travel, sled_dims[1] + 0.1]])
      translate([cx - relief_w / 2, seg[0], -0.1]) cube([relief_w, seg[1] - seg[0], relief_h + 0.1]);
  }
}

// printable pin (head flat on the bed) and rod (flat, wide face down)
module pin_print() { translate([0, 0, pin_len + pin_head_h]) rotate([180, 0, 0]) pin(); }
module rod_print() {
  translate([-(hue_u - rod_fl_w / 2), stroke + rod_fl_t, -z_rb]) rod_placed(hue_u, hue_yc, 0);
}
// assembly helpers for interference checks (left half's local coordinates: half_local("L"))
module pin_rest()    { translate([hue_u, hue_yc, zt + btn_top]) pin(); }
module pin_pressed() { translate([hue_u, hue_yc, zt + btn_top - btn_travel]) pin(); }
module rod_at(press) { rod_placed(hue_u, hue_yc, press); }

// everything in place, for previews: both halves, sleds latched, push-rod and pin at rest
module assembly() {
  left_half();
  right_half();
  color("Tomato") {
    translate([half_w, 0, 0]) mirror([1, 0, 0]) { pin_rest(); rod_at(0); }
    for (i = [0 : len(right_items) - 1]) if (right_items[i] == "pi_sled")
      translate([half_w + off(right_items, i) + sled_clr / 2, plate_t + sled_front_gap, floor_t])
        pi_sled();
  }
}

if (part == "assembly") assembly();
if (part == "pin") pin_print();
if (part == "rod") rod_print();
if (part == "sled") pi_sled();
if (part == "left")  oriented() left_half();
if (part == "right") oriented() right_half();
if (part == "both") { left_half(); right_half(); }
