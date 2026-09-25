# Hairband artwork

Generated with the built-in imagegen tool on 2026-09-25. The existing Hairband
accessory (addition ID 3) keeps its light-blue color, arch silhouette, placement
and transparent 264 x 280 avatar canvas. The new shading adds softly rounded
edges, a subtle inner shadow and an upper-left highlight.
Visible bounds remain (76, 39, 113, 60) in avatar coordinates.

iOS contains 1x, 2x and 3x PNGs. Android uses identical 1x and 3x exports.
Rendering code and avatar IDs are unchanged.

Edit target: `Addon/Hairband`. Shading reference: `Addon/Headphones`.

## Generation prompt

```text
Use case: precise-object-edit.
Asset type: transparent PNG hairband accessory for an existing mobile cartoon avatar.
Input image 1: EDIT TARGET, a plain light sky-blue hairband on a transparent 264 x 280 avatar canvas. Input image 2: STYLE REFERENCE ONLY, the headphones from the same avatar library; use their clean soft dimensional shading, not their design.
Primary request: polish the simple blue hairband a little while preserving its identity, color family and exact simple front-facing arch silhouette. Make it a tasteful softly rounded satin-finish light sky-blue / pale cyan plastic hairband with subtle deeper-blue shading along its inner edge, gentle beveled edges, and one soft narrow curved highlight along the upper-left crown of the arch. It should feel like the same accessory finished with care.
Shape: a SINGLE broad upside-down U / upper crescent, about 1.9 times as wide as it is tall. The highest center portion of the arch has a band thickness about one quarter of the total arch height, smoothly narrowing toward the two delicate lower side ends. Ends at exactly the same height, symmetric outer contour. Completely open and TRANSPARENT under the arch. The broad top of the original blue crescent matters; preserve it. No full oval, no lower closing band, no thick vertical legs.
Composition: isolate the single hairband, centered and substantially enlarged in the output for high resolution, with generous transparent margins on every side. It will be reduced and placed in its original 113 x 60-ish pixel location in the avatar, so keep the soft bevel and highlights simple and readable.
Lighting/style: clean polished casual-game cartoon accessory, soft upper-left light, subtle depth like the supplied headphones, no black outline, not photorealistic.
Background: genuine transparent alpha, including all empty space inside and beneath the arch. Do not paint a fake checkerboard.
Constraints: preserve light-blue color, same recognizable plain curved shape; no bow, flowers, jewels, pearls, logo, text, pattern, head, hair, face, mannequin, ears, headphones, ear pads, cables, floor, cast shadow or extra objects. All tips intact. Return only the improved blue hairband.
```
