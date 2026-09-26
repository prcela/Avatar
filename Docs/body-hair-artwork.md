# Body hair accessory

`Addition.BodyHair` uses accessory ID 24 on iOS and Android. It reuses the existing
hair color, including with a bald head. It needs no new
hex-ID fields, and the accessory color stays saved independently.

The transparent sprite has slightly thicker, longer irregular curls and overlapping open loops on the chest,
with straighter strands continuing across the shoulders and down the outer arms.
The arms have slightly denser coverage to fill the longer gaps between strands.
The upper chest has a shallower hair-free notch, bringing the curls closer to the base of the neck. It is drawn at avatar coordinates
`(32, 202, 200, 78)`, or body-local `(0, 166, 200, 78)`. The face and neck are above
this rectangle. Source-atop compositing clips the hair to the skin alpha before
clothing is drawn. The existing body-width transforms and clothing cutouts still
apply. Bot skin does not display body hair.

The built-in imagegen tool created the artwork. The final master is
`Scripts/Artwork/BodyHair-source.png`. Export with:

```sh
swift Scripts/import-body-hair.swift /path/to/Yamb_android
```

Outputs: `Sources/Avatar/Avatar.xcassets/Addon/BodyHair.imageset` (1x/2x/3x) and
Android `app/src/main/res/drawable-xxhdpi/addon_body_hair.png` (identical to iOS 3x).
The export only resizes the master and preserves its generated alpha.

## Final prompt

Use case: precise-object-edit. Edit ONLY the arm areas of this transparent body-hair sprite for an avatar. Add a modest amount of extra hair, about 30 percent more strands, on BOTH outer arm regions (the leftmost and rightmost quarters of the canvas), especially the larger empty gaps midway down and toward the lower inner edges of the arms. Spread the added strands naturally over more of the arm surface, with a few irregularly spaced rows between existing hairs; avoid isolated bare strips. Added arm hairs must remain mostly straight or gently curved and point generally downwards, matching the existing stroke thickness, length, dark gray color and soft antialiasing. Keep transparent gaps so individual strands remain visible. Preserve the CENTRAL CURLY CHEST, the shoulder coverage, the shallow empty neckline, canvas size, exact framing and outer silhouette. No new chest density, no thicker strokes, no large curls on arms, no solid shading or background. Output only the edited hair sprite on genuinely transparent alpha; no skin, person, clothes, text, border or other elements.
