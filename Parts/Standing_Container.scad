include <BOSL2/std.scad>
include <BOSL2/threading.scad>
// Container
module create_standing_container(radius, thickness, inner_container_radius, font_size, text_step_height, container_spacing, container_thickness, container_height, container_threaded_rod_height, spacing, hexagonal_container) {
  outer_container_radius = (radius + thickness + font_size + container_spacing + container_thickness) / (Hexagonal_container ? cos(180 / 6) : 1);
  inner_pole_radius = radius - container_spacing;
  inner_container_height = (thickness + text_step_height) * container_height;
  outer_base_container_height = inner_container_height + container_thickness;
  outer_lid_height = container_threaded_rod_height + container_thickness;
  screw_diameter = inner_pole_radius * 2 - 5;

  // Base Container
  union() {
    difference() {
      translate([0, 0, 0])
        cylinder(h = outer_base_container_height, r = outer_container_radius, $fn = (Hexagonal_container ? 6 : 100));
      translate([0, 0, container_thickness])
        cylinder(h = inner_container_height + 0.1, r = inner_container_radius, $fn = 100);
    }
    translate([0, 0, (container_thickness - 0.1)])
      cylinder(h = inner_container_height + 0.1, r = inner_pole_radius, $fn = 100);
    translate([0, 0, outer_base_container_height - 0.1])
      threaded_rod(d=screw_diameter, height=container_threaded_rod_height + 0.1, pitch=2, anchor=BOTTOM, $fa=1, $fs=1);
  }

  // Lid
  union() {
    difference() {
      translate([(outer_container_radius * 2) + spacing, 0, 0])
        cylinder(h = outer_lid_height, r = outer_container_radius, $fn = (Hexagonal_container ? 6 : 100));
      translate([(outer_container_radius * 2) + spacing, 0, container_thickness])
        cylinder(h = outer_lid_height - (container_thickness - 0.1), r = inner_container_radius, $fn = 100);
    }
    difference() {
      translate([(outer_container_radius * 2) + spacing, 0, container_thickness - 0.1])
        cylinder(h = outer_lid_height - container_thickness + 0.1, r = inner_pole_radius, $fn = 100);
      translate([(outer_container_radius * 2) + spacing, 0, container_thickness])
        threaded_rod(d=screw_diameter, height=container_threaded_rod_height + 0.1, pitch=2, anchor=BOTTOM, $fa=1, $fs=1, internal = true);
    }
  }
}