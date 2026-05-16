// The text strings for each of the rings. The number in the second element of each pair indicates how many times the text should be repeated around the ring. For example, "FRIGHTENED" will be repeated once, while "0" through "9" will be repeated three times.
Ring_texts = [
  ["BLINDED", 1],
  ["CHARMED", 1],
  ["DEAFENED", 1],
  ["FRIGHTENED", 1],
  ["GRAPPLED", 1],
  ["INCAPACITATED", 1],
  ["INVISIBLE", 1],
  ["PARALYZED", 1],
  ["PETRIFIED", 1],
  ["POISONED", 1],
  ["PRONE", 1],
  ["RESTRAINED", 1],
  ["STUNNED", 1],
  ["UNCONSCIOUS", 1],
  ["EXHAUSTION", 1],
  ["0", 3],
  ["1", 3],
  ["2", 3],
  ["3", 3],
  ["4", 3],
  ["5", 3],
  ["6", 3],
  ["7", 3],
  ["8", 3],
  ["9", 3],
  ["HUNTERS MARK", 1],
  ["BANE", 1],
  ["BANISHED", 1],
  ["BLESSED", 1],
  ["CONCENTRATION", 1],
  ["CURSED", 1],
  ["EXHAUSTED", 1],
  ["FAERIE FIRE", 1],
  ["HEX", 1],
  ["RAGING", 1],
  ["BARDIC INSPIRATION", 1]
];
// The font family to be used for the text on the rings.
Font_family = "Liberation Sans"; //[Arial, Courier New, Times New Roman, Liberation Mono, Liberation Sans, Liberation Serif, Verdana, Sans Serif, Ubuntu]
// The font style to be used for the text on the rings.
Font_style = "Bold"; //[Bold Italic, Bold, Italic, Regular]
// The internal diameter of the ring.
Diameter = 25;
// Font size
Font_size = 5;
// The angle step for arranging the text around the ring. A smaller step will result in more tightly packed text.
Letter_separation = 17;
// The thickness of the ring itself.
Thickness = 2;
// The direction of the text. A positive value will attach the letters to the ring by the bottom, while a negative value will attach it by the top.
Direction = 1; //[-1:Top of letters,1:Bottom of letters]
// The spacing between the text and the ring.
Text_ring_spacing = -0.400;
// Text height relative to ring height
Text_step_height = 1;
// The spacing used when arranging the rings in a grid.
Spacing = 10;

// The height of the threaded rod for the lid of the container.
Container_threaded_rod_height = 10;
// Height of the container tube (in # of rings)
Container_height = 25;
// Spacing between the container and the rings (to ensure they fit inside)
Container_spacing = 0.2; // .1
// Thickness of the container walls
Container_thickness = 2;
// Whether the container should be hexagonal (true) or cylindrical (false).
Hexagonal_container = true;
// The height of the case-style container
Case_style_container_height = 10;

// Radius of the magneets for the lid and base of the container
Magnet_radius = 4.5;
// The thickness of the magnets for the lid and base of the container
Magnet_thickness = 3;
// The tolerance for the magnet holes to ensure a snug fit with the magnets
Magnet_hole_tolerance = 0.05;

// Radius of the holes for the alignment pins for the lid and base of the container
Alignment_hole_radius = 4.5;
// The depth of the holes for the alignment pins for the lid and base of the container
Alignment_hole_depth = 3;
// The tolerance for the alignment holes to ensure a snug fit with the alignment pins
Alignment_hole_tolerance = 0.05;

radius = Diameter / 2;
columns = floor(sqrt(len(Ring_texts)));
rows = ceil(len(Ring_texts) / columns);
font_spec = str(Font_family, ":style=", Font_style);

for (i = [0:len(Ring_texts) - 1]) {
  current_col = i % columns;
  current_row = floor(i / columns);
  translate([(Spacing + ((radius + Thickness) * 2)) * current_col, (Spacing + ((radius + Thickness) * 2)) * current_row, 0])
    create_ring(Ring_texts[i][0], Ring_texts[i][1]);
}

module create_ring(text, count) {
  union() {
    for (repeat_i = [0:count - 1]) {
      repeat_degree = (360 / count) * repeat_i;
      linear_extrude(Thickness + Text_step_height)for (i = [0:len(text) - 1])
        rotate(((len(text) - 1) / 2 * Letter_separation - i * Letter_separation) + repeat_degree)
          translate([0, radius * Direction + (Direction > 0 ? (Thickness + Text_ring_spacing) : -(Font_size + Thickness + Text_ring_spacing))])
            text(text[Direction > 0 ? i : len(text) - 1 - i], size=Font_size, font=font_spec, halign="center");
            //text(str(repeat_i), size=Font_size, font=font_spec, halign="center", valign="center", Spacing=0.1);
    }
    difference() {
      linear_extrude(Thickness)
        circle(radius + Thickness);
      translate([0, 0, -0.5])
        linear_extrude(Thickness + 1)
          circle(radius);
    }
  }
}

// Container
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

outer_container_radius = (radius + Thickness + Font_size + Container_spacing + Container_thickness) / (Hexagonal_container ? cos(180 / 6) : 1);
inner_container_radius = radius + Thickness + Font_size + Container_spacing;
inner_pole_radius = radius - Container_spacing;
inner_container_height = (Thickness + Text_step_height) * Container_height;
outer_base_container_height = inner_container_height + Container_thickness;
outer_lid_height = Container_threaded_rod_height + Container_thickness;
screw_diameter = inner_pole_radius * 2 - 5;

// Base Container
union() {
  difference() {
    translate([0, -(outer_container_radius * 2), 0])
      cylinder(h = outer_base_container_height, r = outer_container_radius, $fn = (Hexagonal_container ? 6 : 100));
    translate([0, -(outer_container_radius * 2), Container_thickness])
      cylinder(h = inner_container_height + 0.1, r = inner_container_radius, $fn = 100);
  }
  translate([0, -(outer_container_radius * 2), (Container_thickness - 0.1)])
    cylinder(h = inner_container_height + 0.1, r = inner_pole_radius, $fn = 100);
  translate([0, -(outer_container_radius * 2), outer_base_container_height - 0.1])
    threaded_rod(d=screw_diameter, height=Container_threaded_rod_height + 0.1, pitch=2, anchor=BOTTOM, $fa=1, $fs=1);
}

// Lid
union() {
  difference() {
    translate([(outer_container_radius * 2) + Spacing, -(outer_container_radius * 2), 0])
      cylinder(h = outer_lid_height, r = outer_container_radius, $fn = (Hexagonal_container ? 6 : 100));
    translate([(outer_container_radius * 2) + Spacing, -(outer_container_radius * 2), Container_thickness])
      cylinder(h = outer_lid_height - (Container_thickness - 0.1), r = inner_container_radius, $fn = 100);
  }
  difference() {
    translate([(outer_container_radius * 2) + Spacing, -(outer_container_radius * 2), Container_thickness - 0.1])
      cylinder(h = outer_lid_height - Container_thickness + 0.1, r = inner_pole_radius, $fn = 100);
    translate([(outer_container_radius * 2) + Spacing, -(outer_container_radius * 2), Container_thickness])
      threaded_rod(d=screw_diameter, height=Container_threaded_rod_height + 0.1, pitch=2, anchor=BOTTOM, $fa=1, $fs=1, internal = true);
  }
}

// Case-style container (with sorted slots for each type of ring)
case_width_single = (inner_container_radius * 2) + Container_thickness;
case_depth_single = (inner_container_radius * 2) + Container_thickness;
case_width = (case_width_single * columns) + Container_thickness;
case_depth = (case_depth_single * rows) + Container_thickness;
case_height = (Thickness + Text_step_height) * Case_style_container_height;
inner_case_style_container_height = (Thickness + Text_step_height) * Case_style_container_height;
hole_distance_from_edge = (inner_container_radius * 2) + (Container_thickness * 1.5);
alignment_hole_distance_from_edge = (inner_container_radius * 4) + (Container_thickness * 2.5);
lid_thickness = Container_thickness + Magnet_thickness;

translate([-(case_width + case_width_single), 10, 0])
  difference() {
    cube([case_width, case_depth, case_height]);
    translate([inner_container_radius + Container_thickness, inner_container_radius + Container_thickness, 0])
      for (i = [0:len(Ring_texts) - 1]) {
        current_col = i % columns;
        current_row = floor(i / columns);
        translate([(((inner_container_radius) * 2) + Container_thickness) * current_col, (((inner_container_radius) * 2) + Container_thickness) * current_row, Container_thickness])
          cylinder(h = inner_case_style_container_height, r = inner_container_radius, $fn = 100);
      }

    // Magnet holes
    union() {
      // Bottom left
      translate([hole_distance_from_edge, hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
      // Bottom right
      translate([case_width - hole_distance_from_edge, hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
      // Top right
      translate([case_width - hole_distance_from_edge, case_depth - hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
      // Top left
      translate([hole_distance_from_edge, case_depth - hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
    }

    // Alignment holes
    union() {
      // Bottom left
      translate([alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius + Alignment_hole_tolerance, $fn = 100);
      // Bottom right
      translate([case_width - alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius + Alignment_hole_tolerance, $fn = 100);
      // Top right
      translate([case_width - alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius + Alignment_hole_tolerance, $fn = 100);
      // Top left
      translate([alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, case_height - Container_thickness])
        cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius + Alignment_hole_tolerance, $fn = 100);
    }
  }

// Lid for case-style container
translate([-(case_width + case_width_single), -(case_depth + 10), 0])
  difference() {
    union() {
      cube([case_width, case_depth, lid_thickness]);

      // Alignment studs
      union() {
        // Bottom left
        translate([alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, lid_thickness - 0.1])
          cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius - Alignment_hole_tolerance, $fn = 100);
        // Bottom right
        translate([case_width - alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, lid_thickness - 0.1])
          cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius - Alignment_hole_tolerance, $fn = 100);
        // Top right
        translate([case_width - alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, lid_thickness - 0.1])
          cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius - Alignment_hole_tolerance, $fn = 100);
        // Top left
        translate([alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, lid_thickness - 0.1])
          cylinder(h = Container_thickness + 0.1, r = Alignment_hole_radius - Alignment_hole_tolerance, $fn = 100);
      }
    }

    // Magnet holes
    // Bottom left
    translate([hole_distance_from_edge, hole_distance_from_edge, Container_thickness])
      cylinder(h = Magnet_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
    // Bottom right
    translate([case_width - hole_distance_from_edge, hole_distance_from_edge, Container_thickness])
      cylinder(h = Magnet_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
    // Top right
    translate([case_width - hole_distance_from_edge, case_depth - hole_distance_from_edge, Container_thickness])
      cylinder(h = Magnet_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
    // Top left
    translate([hole_distance_from_edge, case_depth - hole_distance_from_edge, Container_thickness])
      cylinder(h = Magnet_thickness + 0.1, r = Magnet_radius - Magnet_hole_tolerance, $fn = 100);
  }
