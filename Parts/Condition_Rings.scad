// Rings
module create_ring_grid(ring_texts, radius, font_family, font_style, spacing, thickness, text_step_height, letter_separation, text_ring_spacing, direction) {
  columns = floor(sqrt(len(ring_texts)));
  rows = ceil(len(ring_texts) / columns);
  font_spec = str(font_family, ":style=", font_style);

  for (i = [0:len(ring_texts) - 1]) {
    current_col = i % columns;
    current_row = floor(i / columns);
    translate([(spacing + ((radius + thickness) * 2)) * current_col, (spacing + ((radius + thickness) * 2)) * current_row, 0])
      create_ring(ring_texts[i][0], ring_texts[i][1], thickness, text_step_height, letter_separation, text_ring_spacing, radius, font_spec, direction);
  }
}

module create_ring(text, count, thickness, text_step_height, letter_separation, text_ring_spacing, radius, font_spec, direction) {
  union() {
    for (repeat_i = [0:count - 1]) {
      repeat_degree = (360 / count) * repeat_i;
      linear_extrude(thickness + text_step_height)for (i = [0:len(text) - 1])
        rotate(((len(text) - 1) / 2 * letter_separation - i * letter_separation) + repeat_degree)
          translate([0, radius * direction + (direction > 0 ? (thickness + text_ring_spacing) : -(Font_size + thickness + text_ring_spacing))])
            text(text[direction > 0 ? i : len(text) - 1 - i], size=Font_size, font=font_spec, halign="center");
    }
    difference() {
      linear_extrude(thickness)
        circle(radius + thickness);
      translate([0, 0, -0.5])
        linear_extrude(thickness + 1)
          circle(radius);
    }
  }
}