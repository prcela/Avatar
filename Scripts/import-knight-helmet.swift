// SPDX-License-Identifier: MPL-2.0

// Run from the Avatar package root: swift Scripts/import-knight-helmet.swift
// Crop transparent margins and resize without changing the generated alpha or colors.
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let source = root.appendingPathComponent("Scripts/Artwork/KnightHelmet-source.png")
let master = NSBitmapImageRep(data: try Data(contentsOf: source))!
var minX = master.pixelsWide, minY = master.pixelsHigh, maxX = 0, maxY = 0
for y in 0..<master.pixelsHigh {
    for x in 0..<master.pixelsWide where master.colorAt(x: x, y: y)!.alphaComponent > 0 {
        minX = min(minX, x); maxX = max(maxX, x)
        minY = min(minY, y); maxY = max(maxY, y)
    }
}
let cropped = master.cgImage!.cropping(to: CGRect(x: minX, y: minY,
    width: maxX - minX + 1, height: maxY - minY + 1))!
let directory = root.appendingPathComponent("Sources/Avatar/Avatar.xcassets/Top/KnightHelmet.imageset")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
var entries = [[String: String]]()
for scale in 1...3 {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 266 * scale, pixelsHigh: 280 * scale,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let context = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
    context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
    context.interpolationQuality = .high
    // Avatar coordinates (40, 13, 186, 211); Core Graphics starts at the bottom.
    context.draw(cropped, in: CGRect(x: 40, y: 280 - 13 - 211, width: 186, height: 211))
    let filename = "KnightHelmet" + (scale == 1 ? "" : "@\(scale)x") + ".png"
    try bitmap.representation(using: .png, properties: [:])!.write(to: directory.appendingPathComponent(filename))
    entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
}
let json: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
try (JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) + Data([10]))
    .write(to: directory.appendingPathComponent("Contents.json"))
print("Exported KnightHelmet at 1x/2x/3x on a 266 x 280 canvas.")
