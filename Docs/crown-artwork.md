# Compact crown artwork

Generated with the built-in imagegen tool on 2026-09-25.

The existing Crown asset (addition ID 7) is replaced in place. The transparent
264 x 280 avatar canvas, original visible width, horizontal alignment and bottom
edge are preserved. The new artwork is 56 points tall, leaving headroom above
all five tips. Visible bounds change from (69, 0, 127, 87) to (69, 31, 127, 56),
so the crown is about 36% shorter while retaining its 127-point width and y=87
bottom edge. iOS includes 1x, 2x and 3x exports; Android uses matching 1x and 3x
PNGs. Both renderers lift the crown by 18 points on bald heads. Hair raises it another 8 points, for a total
lift of 26 points. Visible bounds are (69, 13, 127, 56) without hair and
(69, 5, 127, 56) with hair. Size and avatar IDs are unchanged.

Style references: `Addon/GoldMedal` and `Addon/GoldChain` in the avatar asset catalog.
The old `Addon/Crown` was the edit target.

## Generation prompt

```text
Use case: precise-object-edit.
Asset type: transparent PNG crown accessory for an existing mobile cartoon avatar system.
Input image 1 is the old crown design to replace: its tips are cut off. Images 2 and 3 are style references only (gold medal and gold chain).
Primary request: redraw the crown as a noticeably LOWER, squat royal crown, same wide silhouette and gold/emerald/magenta identity, matching the soft polished cartoon 3D shading of the medal and necklace. Crown visible width to full visible height must be about 2.2:1. This is a low-profile crown with five short broad points, NOT a tall king's crown. Keep the curved lower gold band, a central rounded green emerald and smaller magenta side gems, soft rounded golden tip beads. Shorten the spikes substantially; the band should feel substantial and the teeth compact, with every tip completely visible.
Composition: front view, symmetric and upright, minimal perspective matching old crown, width larger than height, single isolated crown centered in the image with ample transparent margin on every side. Render at high resolution for reduction to a 123 x 56 pixel crown.
Style: polished gold with warm shadowing and soft highlights, softly beveled contours, clean readable casual-game accessory, no black outline, no intricate filigree.
Background must be genuinely TRANSPARENT alpha. No head, hair, face, person, scenery, floor, external drop shadow, text, logo, labels, border, checkerboard baked into the artwork, or extra objects. Do not include medal or chain. Return only the new short crown, intact and uncropped.
```
