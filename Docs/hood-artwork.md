# Raised hood accessory

Addition ID 23 (`Hood`) is appended without renumbering existing accessories.
It uses the existing addition extension bit and color field in the hex ID.
Both editors expose it through their existing list of accessories and palette.

The hood's middle and lower sections are approximately 25% narrower than the
previous fit. The fabric is exported at 150 x 234 points, centered horizontally.
The inner face opening is approximately 10% larger, with thinner side lining;
the outer dimensions and placement are retained.
Both fabric and face shadow use the base vertical placement, raised by 14 points
(5% of the 280-point avatar canvas) from the previous fit. The transparent face
opening ends near y196, and the narrow collar
covers the lower throat and overlaps the sweatshirt neckline. The drawstring eyelets sit
close to the neck. The grayscale fabric receives the selected accessory color.
A separate black alpha gradient casts a soft shadow
across the forehead without coloring the skin. Both layers follow body width.
Hair is hidden only while Hood is selected; the saved hair choice is preserved.
Other headwear shares the accessory category with Hood, so selecting it replaces Hood. The hood is drawn immediately before facial hair, so the beard
overlays its fabric. The nose and glasses retain their normal foreground order.

The original Hoodie assets are unchanged. Only the Hood + Hoodie combination
uses a separate plain sweatshirt torso to avoid doubled collars and cords.
Removing Hood immediately returns to the original Hoodie artwork.

## Files and export

- `Sources/Avatar/Avatar.xcassets/Addon/Hood.imageset`: tintable fabric, 264 x 280 points.
- `Sources/Avatar/Avatar.xcassets/Addon/HoodShadow.imageset`: neutral face shadow, same canvas.
- `Sources/Avatar/Avatar.xcassets/Clothing/HoodieRaised.imageset`: conditional torso, 264 x 110 points.
- `Scripts/Artwork/Hood-source.png` and `HoodieRaised-source.png`: retained imagegen masters.
- `Scripts/import-hood.swift`: reproducible framing, resizing and shadow generation.

Run `swift Scripts/import-hood.swift /path/to/Yamb_android` from the Avatar
package. It exports iOS 1x/2x/3x PNGs and byte-identical Android 3x assets:
`addon_hood`, `addon_hood_shadow`, and `clothing_hoodie_raised`.
The Android import script also includes these three assets.

## Generation

Created with the built-in imagegen tool on 2026-09-25. Both initial calls used the
existing `Clothing/Hoodie.imageset/Hoodie.png` as the edit/style reference.
Only export framing and resizing are applied to the retained masters.
The hood was then revised with the same tool to narrow and lower the collar.
That revision used the exported hood as the edit target and the three-avatar
preview as a fit reference. After narrowing the middle and lower sections, the
latest artwork widens only the face opening. Both hood layers retain the base
vertical placement; the conditional torso and shadow are unchanged.

### Wider face opening

The built-in imagegen tool edited the previous exported hood, then made a small
inner-edge correction. The 3x export has an 11.4% larger transparent face-opening
area; its outer contour differs by at most one logical point across y25...220.
The export rectangle, shadow, collar placement and beard layering are retained.

#### Edit 1

```text
Use case: precise-object-edit.
EDIT TARGET: the attached grayscale hood accessory with transparent background and transparent face opening.
Make ONE very small change: widen ONLY the empty inner face opening by 10% HORIZONTALLY, centered on the same vertical centerline. Its width should be 1.10 times its current width at each height. This requires moving only the inner left edge a little left and the inner right edge a little right, thinning the inside lining slightly. Keep the opening's top and bottom at the EXACT SAME vertical positions; do not make it taller or shift it. Preserve its smooth rounded shape.
The outer hood is already approved: LOCK the entire outer silhouette, size, top dome, seam, outside folds, neck collar, eyelets, strings, vertical placement, lighting and texture. Do not redraw, enlarge, shrink, move, narrow or reshape the outer hood. Keep every unaffected area identical to the reference. No overall rescaling or recentering. Modify ONLY a thin strip of inner lining along the transparent hole's left and right sides to make the hole 10% wider. Blend the new antialiased inner edges naturally into the existing fabric.
The input is 792x840 pixels with hood centered at x396. Move the INNER boundary with x_new = 396 + 1.10*(x_old-396); keep y unchanged. Do not apply this transform to the outer contour or any other part. Preserve the full original canvas and margins. Output only the edited hood with real transparent alpha inside and outside, neutral grayscale suitable for tinting. No face, head, skin, mannequin, body, shirt, background, text, logos or new elements.
```

#### Edit 2

```text
Use case: precise-object-edit. EDIT TARGET: the attached transparent grayscale hood sprite. This is a tiny calibration of the inner hole only.
Reduce ONLY the WIDTH of its transparent FACE OPENING by THREE PERCENT (multiply its current width by 0.97), symmetrically around the centerline. This is a barely perceptible adjustment, around 1-2 pixels on each side at avatar size. Move only the inner fabric edges slightly inward with soft antialiasing. Keep the opening's height and its top and bottom positions EXACTLY unchanged.
LOCK the existing OUTER silhouette, hood size, every exterior fold and texture, upper dome, center seam, collar, eyelets and cords. Do not alter the outer boundary or resize/reposition/crop the hood. Keep all unaffected pixels as close as possible to the reference. No redesign. Same grayscale cotton and lighting. Same full transparent canvas and margins. Output the single edited hood only, with actual transparency outside it and inside the face opening. No person, face, head, skin, body, background, text or new objects.
```

### Narrower fit and vertical placement

The built-in imagegen tool reshaped the hood using the prior exported PNG as
the edit target. Export framing retains the reduced width rather than expanding
the new alpha bounds back to 200 points. At middle and collar sample rows,
the exported widths are approximately 75% of the previous widths.
The prior 5% downward offset has been removed from both hood layers, raising
them by 14 points without changing the retained artwork or its width.

```text
Use case: precise-object-edit.
Edit target: the attached neutral grayscale raised hood accessory PNG, with genuine transparency. This is a precise fit adjustment, not a new design.
NARROW the MIDDLE and LOWER parts of the hood by 25 percent horizontally, toward its vertical centerline. Each middle/lower cross-section should now have 75% of its previous width. The current wide bulges around the temples/cheeks must become visibly slimmer and closer to the head. The lower neck collar and both cords/eyelets should also be 25% narrower/closer together. Do NOT make the hood shorter. Do NOT raise its bottom collar.
Keep the entire top dome, center seam and upper forehead rim unchanged. Blend smoothly from unchanged upper dome to the 25% narrower middle section; avoid a ledge, seam or sudden pinch. Both fabric sides AND the transparent opening in the middle/lower section follow this horizontal squeeze. Keep the low rounded opening under the chin, the close-fitting collar, the drawstrings, cotton texture, neutral grayscale, same soft lighting, and antialiasing.
Use the exact same overall canvas proportions and original vertical positions. In the input's 792x840 pixel canvas: centerline x396, top y24, collar opening bottom at about y589, strings finish about y726. Preserve all those y positions. Above y180 keep the same shape. Transition gently over y180..300. At y330 and below use x_new = 396 + 0.75 * (x_old - 396). For example middle outer edges around x96 and x696 should move inward to x171 and x621. Lower collar sides move inward by the same percentage. Keep the top at its current size, so the final silhouette has the same rounded upper dome with a slimmer middle and lower neck, not a shrunken entire hood.
Output only the edited hood, with genuine transparent background and face opening. Keep transparent margins; do not crop tightly or auto-enlarge the narrower result to fill the canvas. No head, face, skin, body, torso, shirt, background, text, logos or extra objects.
```

### Chin clearance revision prompts

The built-in imagegen tool revised the lower opening and collar using the exported
hood and fit preview, followed by two focused edits of the exported hood.
The export height is 234 points: the opening ends near y196, approximately
10 points below the normal chin at y186. The narrow lower collar still covers
the lower throat and overlaps the clothing.

#### Edit 1

```text
Use case: precise-object-edit.
Asset type: transparent grayscale raised hood sprite for a layered mobile avatar.
Input image 1: EDIT TARGET, current standalone hood on its transparent 264x280 logical avatar canvas (exported at 3x). Input image 2: FIT REFERENCE ONLY, the current hood on three avatars. Output only the edited standalone hood, never the avatars or comparison.
Primary request: lower ONLY the bottom of the face opening and the attached collar so the fabric no longer covers the lower cheeks, jaw or chin. The current pointed V opening squeezes across the lower face. Make its lower section a deeper, slightly wider rounded U, with clear space for a round chin. The top edge of the collar at the center must sit about 10 logical pixels BELOW the actual avatar chin. The avatar chin is at logical y186, so the lowest point of the transparent face opening should be around (132,196), instead of the current (132,183). Lower the neighboring left and right diagonal rim sections as well, uncovering the cheeks and jaw rather than simply cutting a small central hole. At y175 leave a transparent opening at least x102..162, and at y186 at least x111..153; taper softly to the center at y196. Leave the lower cheeks comfortably clear.
Keep the collar NARROW around the neck as now; do not widen its outer wings or make a shoulder cape. Move the gathered lower cloth down, smoothly connecting to the unchanged hood sides. Below y198 there should still be opaque folded cloth covering the throat and overlapping the sweatshirt, down to about y227. Lower the two closely spaced eyelets with the collar and shorten the exposed drawstrings slightly if needed so their bottom ends still reach y238. The only visible neck clearance should be the small area immediately under the chin; keep lower throat covered.
INVARIANTS: preserve the upper dome, seam, forehead rim, face opening above mouth level, maximum outer width, grayscale cotton texture, dimensional soft shading and clean antialiased edges. Keep top at y8, outer width x32..232, canvas 264x280 proportions, string ends around y238, so the export can retain the exact current position. Do not shift or resize the entire hood. Only reshape the bottom opening and move its collar lower. Do not turn the opening into a pointed V or cover the chin. No person, skin, hair, torso, shirt, background, text, logos or added objects. Genuine transparent alpha background AND transparent face opening. Preserve the reference style.
```

#### Edit 2

```text
Use case: precise-object-edit. Edit this transparent standalone hood sprite. The ONLY change is to move its bottom collar DOWN, making the transparent face hole visibly TALLER. Preserve the upper 60% exactly.
The attached target is 792x840 pixels. At its center x396, the bottom of the transparent face opening is currently y550. Move that boundary DOWN to y590, a clear 40-pixel drop. Move the entire lower padded rim with it, including the sections around the lower cheeks and the neck collar folds. Blend the sides smoothly downward from around y400. The center of the transparent opening must extend to y590. Do not leave the collar at y550. The exposed lower cheeks and chin need substantially more room. Keep a gentle rounded U at the bottom of the opening, not a sharp V. At x324 and x468, the opening bottom should be around y565 rather than y524. Narrow outer collar width should stay the same. The two eyelets move down with the collar; shorten cords to keep their tips inside the existing bottom extent at y714. The cloth must remain opaque below the new opening.
Keep original canvas proportions, top y24, same overall maximum width x96..696, and string ends near y714. Do NOT move the entire hood. Keep the dome, top seam, forehead rim, upper lining, upper side outlines, lighting, neutral gray cotton, and fabric style unchanged. Only lower the bottom collar so its edge is clearly lower than before. The output must still be just the hood with genuine transparency behind and inside it. No head, face, neck, mannequin, torso, shirt, background, text, or anything else. This is a fit correction, not a redesign.
```

#### Edit 3

```text
Use case: precise-object-edit. Make a very small fit correction to this transparent hood sprite. Keep its upper dome, upper lining, forehead rim, and entire upper two thirds unchanged. The lower U opening is now at a good depth but is a few pixels too wide beside the neck. Close those small side gaps with the existing gray lining: bring the LEFT lower inner edge inward by about 3% of the sprite width and the RIGHT lower inner edge inward by the same amount, only in the bottom 15% of the transparent opening. Leave the central bottom of the opening at the current depth, or 1% of the sprite height LOWER. The bottom of the face hole must be a small, gently rounded V/U under the chin, narrower than the current very broad U. A person's narrow throat has to fit inside this lower opening with no gaps outside the neck.
In the input image's 792x840 coordinates: central bottom of the transparent hole at x396 should be near y590. At y550 the transparent opening should go only from about x332 to x460; at y560 from x340 to x452; at y580 from x364 to x428. Preserve the face opening above y500 as it is. The opaque collar fabric still extends below this opening. Do NOT raise the collar back over the face, do not fill the face hole, do not lower or resize the whole hood. Keep top and outer contour, overall sprite extent and string endpoints unchanged. Same neutral grayscale cotton texture, same soft shading and folds. Actual transparency inside the face hole and outside the hood. Output this single hood only, no avatar, face, head, skin, neck, clothing, background, text, or props.
```

### Neck fit revision prompt

```text
Use case: precise-object-edit. EDIT TARGET is image 1, the standalone transparent grayscale raised hood accessory. Image 2 is a FIT REFERENCE ONLY showing this hood on the avatar; do not output any avatar, face, skin, shirt or comparison sheet. Modify ONLY the lower half of the hood so it fits tightly and naturally around the neck instead of flaring outward like a wide helmet. Preserve the upper dome, forehead rim, empty transparent face opening around the eyes, neutral grayscale cotton shading, fabric detail, frontal angle, and actual alpha background. The current wide lower side wings and thin loose horizontal ring under the chin are the problem. From about cheek/mouth height downward, taper the outer sides decisively inward toward the neck. End in a snug compact fabric collar, about 40-45 percent of the hood's maximum width, directly under the chin. The lower face opening should taper naturally to the same chin point. BELOW that chin point, there must be an OPAQUE continuous area of softly folded cotton fabric extending down over the whole throat and meeting/overlapping the shirt, so absolutely NO exposed crescent of neck skin or transparent gap is visible below the chin in image 2. Make it look like the lower part of a real raised tracksuit hood gathered snugly at the neck, not a separate scarf, loose ring, mask or shoulder cape. Keep folds subtle. Bring the two drawstring eyelets closer together on this narrow collar and let the two short strings hang down in front. Preserve the existing overall maximum width and top/bottom extent including strings so the sprite can be swapped into the same position. On the target's logical 264x280 avatar canvas: outer head width is about x32..232, top y8; keep the upper head shape and forehead opening fixed; the face/chin opening ends around (132,185); collar fabric should fill x~92..172 from y185 to y220 (naturally tapering), covering the throat; strings finish about y238 as now. Collar should overlap neckline, with no transparent hole in that central throat patch. NO new shoulders, torso, chest, shirt, person, hair, logos, text, props or background. Output only the edited hood accessory, on genuine transparency, preserving smooth edges and neutral grayscale suitable for recoloring.
```

### Hood prompt

```text
Use case: precise-object-edit. Asset type: transparent PNG accessory for a layered front-facing cartoon avatar. Input image 1 is the existing hoodie clothing sprite, STYLE AND FABRIC reference. Create a matching RAISED HOOD ONLY, as though that sweatshirt hood is pulled up over a person's head. Remove the torso/shirt entirely: output only the raised hood around an EMPTY TRANSPARENT FACE OPENING and its short collar/neck drape with two drawstrings. No human, no head, no hair. The hood is a broad rounded dome, softly structured cotton with smooth convincing dimensional folds, rounded padded face rim, soft upper-left lighting, in the exact clean softly shaded 3D casual-game style of the reference, no black outline. Neutral light gray/white fabric for later app tinting; darker gray inner lining, white cords. Frontal symmetrical view with subtle asymmetric folds. Make it wide and round enough for a cartoon head, not a narrow tall human hood. The central face hole must be completely transparent (actual alpha) and fairly wide: opening about 62 percent of the hood width and 66 percent of its height, softly rounded oval top, near vertical cheeks, tapering toward chin. Hood sides descend to a short folded V collar at the throat, with drawstrings hanging a little below. Outer hood width approx 80 percent of its total height including cords. Keep the entire silhouette and cords comfortably inside image bounds with transparent margin. Important: NO face/head/hair/skin/mannequin, NO chest, shoulders, sleeves, torso, sweatshirt body, logos, text, watermark, floor or drop shadow. No filled gray or black area inside the face opening, no checkerboard painted into the image. The app will add its own translucent shadow over the face; output opaque fabric and transparent empty space only. High quality antialiased edges and actual transparent background.
```

### Conditional torso prompt

```text
Use case: precise-object-edit. Asset type: neutral grayscale transparent clothing sprite for the same mobile avatar. EDIT TARGET is image 1, a front-facing cropped sweatshirt torso with lowered hood around the neckline and drawstrings. The application is adding a separate RAISED hood over the head, so create the exact same sweatshirt TORSO BASE with the lowered hood/collar folds and BOTH drawstrings REMOVED. Preserve the original outer shoulder silhouette, chest width, lower straight crop edge, shirt fabric folds, white/gray cotton material, soft 3D casual game style and frontal viewpoint. Replace only the removed lowered hood and strings with clean continuous plain cotton chest fabric and a simple unobtrusive U neckline cutout at top center; no high collar, no ribbed collar, no thick rim, no strings and no eyelets. Keep neckline opening approximately as wide as the original central opening. Transparent background and neck opening (genuine alpha). No person/head/skin, no raised hood, no arms beyond the exact original shoulders, no logo/text/pattern. Keep the shirt as a wide shallow torso sprite, original width-to-height roughly 2.4:1; render it large in a landscape canvas with transparent margins. Entire shoulders and bottom edge visible. We will downsample the output to fit the original 264x110 clothing canvas.
```
