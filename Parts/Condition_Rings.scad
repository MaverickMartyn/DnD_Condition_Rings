// Rings
module create_ring_grid(ring_texts, radius, font_family, font_style, font_size, spacing, thickness, text_step_height, letter_separation, text_ring_spacing, direction, use_backplate, backplate_thickness) {
  columns = floor(sqrt(len(ring_texts)));
  rows = ceil(len(ring_texts) / columns);
  font_spec = str(font_family, ":style=", font_style);

  for (i = [0:len(ring_texts) - 1]) {
    current_col = i % columns;
    current_row = floor(i / columns);
    translate([(spacing + ((radius + thickness) * 2)) * current_col, (spacing + ((radius + thickness) * 2)) * current_row, 0])
      create_ring(ring_texts[i][0], ring_texts[i][1], thickness, text_step_height, letter_separation, text_ring_spacing, radius, font_size, font_spec, direction, use_backplate, backplate_thickness);
  }
}

module create_ring(text, count, thickness, text_step_height, letter_separation, text_ring_spacing, radius, font_size, font_spec, direction, use_backplate, backplate_thickness) {
  union() {
    for (repeat_i = [0:count - 1]) {
      repeat_degree = (360 / count) * repeat_i;
      linear_extrude(thickness + text_step_height)for (i = [0:len(text) - 1])
        rotate(((len(text) - 1) / 2 * letter_separation - i * letter_separation) + repeat_degree)
          translate([0, radius * direction + (direction > 0 ? (thickness + text_ring_spacing) : -(font_size + thickness + text_ring_spacing))])
            text(text[direction > 0 ? i : len(text) - 1 - i], size=font_size, font=font_spec, halign="center");
    }
    difference() {
      linear_extrude(thickness)
        circle(radius + thickness);
      translate([0, 0, -0.5])
        linear_extrude(thickness + 1)
          circle(radius);
    }
    
    if (use_backplate) {
      for (repeat_i = [0:count - 1]) {
        repeat_degree = (360 / count) * repeat_i;
        text_arc_angle = (len(text)) * letter_separation;
        rotate([0, 0, 90-(text_arc_angle / 2) + repeat_degree])
          rotate_extrude(angle = text_arc_angle, convexity = 2)
            translate([radius + thickness + text_ring_spacing, 0, 0])
              square([font_size, backplate_thickness], center=false); 
      }
    }
  }
}