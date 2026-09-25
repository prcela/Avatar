# Beer shirt logo

The beer logo now uses the same solid white pictogram style as the coffee,
trophy and dice logos. The rounded mug has a foamy top, an open handle and two
transparent vertical slots. It stays centered on the existing 110 x 44 canvas;
the visible glyph is 36 points tall. The saved logo ID and shirt placement are
unchanged.

The built-in imagegen tool produced `Scripts/Artwork/BeerLogo-source.png` as
a charcoal silhouette. `Scripts/import-beer-logo.swift` crops transparent margins,
scales the icon and normalizes the silhouette to pure white while preserving alpha.

```sh
swift Scripts/import-beer-logo.swift /path/to/Yamb_android
```

The iOS outputs are in `Sources/Avatar/Avatar.xcassets/ClothingLogo/BeerLogo.imageset`
at 1x, 2x and 3x. Android uses the identical 1x PNG in
`app/src/main/res/drawable/logo_beer.png` and 3x PNG in
`app/src/main/res/drawable-xxhdpi/logo_beer.png`.

## Final prompt

Use case: precise-object-edit. Clean up this beer mug icon for a small shirt emblem. Keep the same recognizable outline: rounded beer stein, foam lobes at top, handle on right and two narrow vertical rounded slots. Render it as a perfectly flat SOLID DARK CHARCOAL silhouette on genuinely TRANSPARENT background; the app will tint the silhouette white. Very important: the entire inner opening of the handle and BOTH entire vertical rib slots must be completely transparent, clean continuous holes with smooth rounded edges, absolutely no speckles, fragments, scribbles, leftover fill or texture inside them. All edges should be smooth and crisp like a simple vector pictogram. Keep bold balanced proportions readable at 36px high. Remove stray specks outside the mug too. Single icon centered on a square transparent canvas, no shadow, gradient, highlights, photograph, outline stroke, white fill, lettering or other objects.
