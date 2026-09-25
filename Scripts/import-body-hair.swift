// SPDX-License-Identifier: MPL-2.0

// Run from the Avatar package root: swift Scripts/import-body-hair.swift [Android repo]
// Resize the imagegen master without changing its transparent hair texture.
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let android = CommandLine.arguments.dropFirst().first.map { URL(fileURLWithPath: $0) }
let source = root.appendingPathComponent("Scripts/Artwork/BodyHair-source.png")
let master = NSBitmapImageRep(data: try Data(contentsOf: source))!.cgImage!
let directory = root.appendingPathComponent("Sources/Avatar/Avatar.xcassets/Addon/BodyHair.imageset")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
var entries = [[String: String]]()
for scale in 1...3 {
    let width = 200 * scale, height = 78 * scale
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let context = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
    context.interpolationQuality = .high
    context.draw(master, in: CGRect(x: 0, y: 0, width: width, height: height))
    let data = bitmap.representation(using: .png, properties: [:])!
    let filename = "BodyHair" + (scale == 1 ? "" : "@\(scale)x") + ".png"
    try data.write(to: directory.appendingPathComponent(filename))
    entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
    if scale == 3, let android {
        let output = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        try data.write(to: output.appendingPathComponent("addon_body_hair.png"))
    }
}
let json: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
try (JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) + Data([10]))
    .write(to: directory.appendingPathComponent("Contents.json"))
print("Exported body hair at 1x/2x/3x; logical size 200 x 78.")
