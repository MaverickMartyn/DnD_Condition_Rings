// Case-style container (with sorted slots for each type of ring)
module create_case_container(container_thickness, thickness, text_step_height, case_style_container_height, ring_texts, magnet_thickness, magnet_radius, magnet_hole_tolerance, alignment_hole_radius, alignment_hole_tolerance) {
  case_width_single = (inner_container_radius * 2) + container_thickness;
  case_depth_single = (inner_container_radius * 2) + container_thickness;
  case_width = (case_width_single * columns) + container_thickness;
  case_depth = (case_depth_single * rows) + container_thickness;
  case_height = (thickness + text_step_height) * case_style_container_height;
  inner_case_style_container_height = (thickness + text_step_height) * case_style_container_height;
  hole_distance_from_edge = (inner_container_radius * 2) + (container_thickness * 1.5);
  alignment_hole_distance_from_edge = (inner_container_radius * 4) + (container_thickness * 2.5);
  lid_thickness = container_thickness + magnet_thickness;

  translate([-(case_width + case_width_single), 10, 0])
    difference() {
      cube([case_width, case_depth, case_height]);
      translate([inner_container_radius + container_thickness, inner_container_radius + container_thickness, 0])for (i = [0:len(ring_texts) - 1]) {
        current_col = i % columns;
        current_row = floor(i / columns);
        translate([( ( (inner_container_radius) * 2) + container_thickness) * current_col, ( ( (inner_container_radius) * 2) + container_thickness) * current_row, container_thickness])
          cylinder(h=inner_case_style_container_height, r=inner_container_radius, $fn=100);
      }

      // Magnet holes
      union() {
        // Bottom left
        translate([hole_distance_from_edge, hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
        // Bottom right
        translate([case_width - hole_distance_from_edge, hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
        // Top right
        translate([case_width - hole_distance_from_edge, case_depth - hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
        // Top left
        translate([hole_distance_from_edge, case_depth - hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
      }

      // Alignment holes
      union() {
        // Bottom left
        translate([alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=alignment_hole_radius + alignment_hole_tolerance, $fn=100);
        // Bottom right
        translate([case_width - alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=alignment_hole_radius + alignment_hole_tolerance, $fn=100);
        // Top right
        translate([case_width - alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=alignment_hole_radius + alignment_hole_tolerance, $fn=100);
        // Top left
        translate([alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, case_height - container_thickness])
          cylinder(h=container_thickness + 0.1, r=alignment_hole_radius + alignment_hole_tolerance, $fn=100);
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
            cylinder(h=container_thickness + 0.1, r=alignment_hole_radius - alignment_hole_tolerance, $fn=100);
          // Bottom right
          translate([case_width - alignment_hole_distance_from_edge, alignment_hole_distance_from_edge, lid_thickness - 0.1])
            cylinder(h=container_thickness + 0.1, r=alignment_hole_radius - alignment_hole_tolerance, $fn=100);
          // Top right
          translate([case_width - alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, lid_thickness - 0.1])
            cylinder(h=container_thickness + 0.1, r=alignment_hole_radius - alignment_hole_tolerance, $fn=100);
          // Top left
          translate([alignment_hole_distance_from_edge, case_depth - alignment_hole_distance_from_edge, lid_thickness - 0.1])
            cylinder(h=container_thickness + 0.1, r=alignment_hole_radius - alignment_hole_tolerance, $fn=100);
        }
      }

      // Magnet holes
      // Bottom left
      translate([hole_distance_from_edge, hole_distance_from_edge, container_thickness])
        cylinder(h=magnet_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
      // Bottom right
      translate([case_width - hole_distance_from_edge, hole_distance_from_edge, container_thickness])
        cylinder(h=magnet_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
      // Top right
      translate([case_width - hole_distance_from_edge, case_depth - hole_distance_from_edge, container_thickness])
        cylinder(h=magnet_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
      // Top left
      translate([hole_distance_from_edge, case_depth - hole_distance_from_edge, container_thickness])
        cylinder(h=magnet_thickness + 0.1, r=magnet_radius - magnet_hole_tolerance, $fn=100);
    }
}
