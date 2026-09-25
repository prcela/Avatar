# Glasses frame colors

All 20 model IDs remain unchanged. Prescription 01/02, Sunglasses, Wayfarers,
Shutter/Lines and Prozirne retain their original bitmap artwork, including the
frame silhouette, lenses or slats, and shadow.
Their 1x PNGs are the raster masters; the generator only scales the originals and
normalizes the frame color for tinting. Original displays the unchanged source.
Sunglasses and Wayfarers separate the colored frames from their original neutral
lens gradients and shadows, so tinting leaves the lenses and reflections unchanged.
Prozirne keeps both original rimless lenses unchanged; only the small central
bridge is extracted into the tintable layer. It has no added frame or arms.
Thin Square and Bold Shades trace the original contours with smooth curves.
Thin Square keeps its fine rims and transparent openings; Bold Shades keeps its
broad brow, tapered lenses and dark gradient. Their flat brown frames can be
tinted while the lenses remain fixed. Both are supersampled from vector paths
at every output scale, avoiding enlarged 1x pixel edges.
Ski Goggles, Monocle and Future Visor retain all three original PNG scales and
never change color. The other models use updated vector artwork with shaded
frames and lens details.

`Scripts/generate-glasses.swift` is the editable artwork source. Run it from the
Avatar package root, optionally passing the Android repository path. It exports
1x/2x/3x model images and two 3x layers per tintable style: a grayscale frame multiplied by
the selected color, and fixed lenses plus highlights. The details layer is empty
for Prescription 01/02 and Shutter/Lines, preserving their original transparent
openings. Both platforms composite the same layers; changing a frame color
never tints the lenses. Ski Goggles, Monocle and Future Visor are copied unchanged
and have no tint layers.

The four editors/renderers use the same palette. Index 0 is Original; indices
1...15 are black, graphite, silver, white, gold, copper, brown, red, pink, violet,
navy, blue, turquoise, green and orange. No glasses, Ski Goggles, Monocle and Future Visor
hide the palette but retain the selection for the next tintable model. Cancel discards the draft as before.

High-word bits 39...43 store the index; 16...31 are reserved. Unknown colors
render as Original and survive edits until an explicit color selection. Legacy
IDs are unchanged. Bits 44...63 remain available.

Shared codec fixture: `0000064cc00000000c8849616c39285a` has color index 12 (blue), plus the
existing face-proportion fixture and extended clothing value 38.
