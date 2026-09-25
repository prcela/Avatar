# Avatar hex ID reference

`AvatarHexID` stores two `UInt64` words and serializes them as a 32-character lowercase string:

```text
00000000325e0000 0c8849616c39285a
| high word    | | low word     |
```

The space above is only a visual separator; an actual ID contains no spaces. Bit positions below are zero-based within each word. The low word keeps the original encoding; `legacyID` exposes its signed `Int64` bit pattern.

## Part fields

Each field gets one extra bit in the high word. Clothing gets a second extra bit at high-word position 30.

| Field | Low-word bits | High-word extension bit(s) | Encoded range |
| --- | --- | --- | --- |
| Skin | 62 | 0 | 0...3 |
| Skin color | 58...61 | 1 | 0...31 |
| Eyes | 53...57 | 2 | 0...63 |
| Mouth | 48...52 | 3 | 0...63 |
| Eyebrow | 44...47 | 4 | 0...31 |
| Glasses | 39...43 | 5 | 0...63 |
| Hair | 33...38 | 6 | 0...127 |
| Hair color | 29...32 | 7 | 0...31 |
| Clothing | 25...28 | 8 (bit 4), 30 (bit 5) | 0...63 |
| Clothing color | 20...24 | 9 | 0...63 |
| Facial hair | 16...19 | 10 | 0...31 |
| Facial hair color | 12...15 | 11 | 0...31 |
| Accessory (`addition`) | 8...11 | 12 | 0...31 |
| Nose | 5...7 | 13 | 0...15 |
| Shirt logo | 0...4 | 14 | 0...63 |

These are storage capacities, not counts of currently available parts. Low-word bit 63 is not assigned to a part. Do not reuse, clear, or reinterpret unassigned bits when forwarding an existing ID.

## Additional high-word fields

| Bits | Field | Supported values |
| --- | --- | --- |
| 15...17 | Body type | 0 normal, 1 slim, 2 very slim, 3 broad, 4 very broad; 5...7 reserved |
| 18...22 | Accessory color | Palette indices 0...25; 26...31 reserved |
| 23...29 | Jersey number | 0 none, 1...100 display numbers 0...99; 101...127 reserved |
| 30 | Clothing bit 5 | See the part-field table |
| 31...32 | Eye spacing | 0 normal, 1 narrow, 2 wide; 3 reserved |
| 33...34 | Eye size | 0 normal, 1 small, 2 large; 3 reserved |
| 35...36 | Mouth width | 0 normal, 1 narrow, 2 wide; 3 reserved |
| 37...38 | Nose size | 0 normal, 1 small, 2 large; 3 reserved |
| 39...63 | Reserved | Preserve on unrelated edits |

Raw setters enforce the encoded range with a precondition. A value fitting that range is not necessarily a supported catalog option. Facial-hair raw value 11 is retired; current options continue at 12 and 13, so enum case counts must not be inferred from the maximum raw value.

## Proportions and compatibility

`Avatar.eyeSize`, `mouthWidth`, and `noseSize` use `FeatureSize` (`normal = 0`, `small = 1`, `large = 2`). `eyeSpacing` uses `EyeSpacing` (`normal = 0`, `narrow = 1`, `wide = 2`). All four fields are independent of the selected shape.

Zero preserves the previous proportions. Each eye moves an additional -5 / 0 / +5 points outward per side on the 264-point canvas, on top of body-width positioning. Separate eyebrows follow the spacing; the unibrow stays connected. Eyes scale to 0.8 / 1 / 1.2 about each half's center. Mouth width and nose size use 0.85 / 1 / 1.15; the mouth's height is unchanged.

`Avatar.decompress(value:hexId:)` retains the original packed ID. Unknown values render using supported fallbacks and survive unrelated changes through `compressHex()`. Setting a specific property replaces that property's stored value. Clients need the corresponding renderer and assets to display new options; preserving the string alone does not update their appearance.

Always save `compressHex()`. If older consumers still require the numeric ID, save `legacyAvatarId` alongside it. Converting the low word back into a new hex ID discards the extension word.
