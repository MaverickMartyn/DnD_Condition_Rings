// ---
// Common Parameters
// ---
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
// The internal diameter of the ring.
Diameter = 25;
// Font size
Font_size = 5;
// The thickness of the ring itself.
Thickness = 2;
// The angle step for arranging the text around the ring. A smaller step will result in more tightly packed text.
Letter_separation = 17;
// Text height relative to ring height
Text_step_height = 1;
// The spacing used when arranging the rings in a grid.
Spacing = 10;

// ---
// Condition Ring Parameters
// ---
// The font family to be used for the text on the rings.
Font_family = "Liberation Sans"; //[Arial, Courier New, Times New Roman, Liberation Mono, Liberation Sans, Liberation Serif, Verdana, Sans Serif, Ubuntu]
// The font style to be used for the text on the rings.
Font_style = "Bold"; //[Bold Italic, Bold, Italic, Regular]
// The direction of the text. A positive value will attach the letters to the ring by the bottom, while a negative value will attach it by the top.
Direction = 1; //[-1:Top of letters,1:Bottom of letters]
// The spacing between the text and the ring.
Text_ring_spacing = -0.400;
// Whether to use a backplate, to support the lettering.
Use_backplate = false;
// The thickness of the backplate.
Backplate_thickness = 1;

// ---
// Common variables
// ---
radius = Diameter / 2;

// ---
// Condition Rings
// ---
include <Parts/Condition_Rings.scad>
create_ring_grid(ring_texts = Ring_texts, radius = radius, font_family = Font_family, font_style = Font_style, font_size = Font_size, spacing = Spacing, thickness = Thickness, text_step_height = Text_step_height, letter_separation = Letter_separation, text_ring_spacing = Text_ring_spacing, direction = Direction, use_backplate = Use_backplate, backplate_thickness = Backplate_thickness);