// Run from the Avatar package root: swift Scripts/import-beer-logo.swift [Android repo]
// Use the imagegen silhouette as a white shirt-logo mask on the existing canvas.
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let android = CommandLine.arguments.dropFirst().first.map { URL(fileURLWithPath: $0) }
let source = root.appendingPathComponent("Scripts/Artwork/BeerLogo-source.png")
let master = NSBitmapImageRep(data: try Data(contentsOf: source))!
var minX = master.pixelsWide, minY = master.pixelsHigh, maxX = 0, maxY = 0
for y in 0..<master.pixelsHigh { for x in 0..<master.pixelsWide {
    if master.colorAt(x: x, y: y)!.alphaComponent > 0.05 {
        minX = min(minX, x); maxX = max(maxX, x)
        minY = min(minY, y); maxY = max(maxY, y)
    }
} }
let glyph = master.cgImage!.cropping(to: CGRect(x: minX, y: minY,
    width: maxX - minX + 1, height: maxY - minY + 1))!
let directory = root.appendingPathComponent("Sources/Avatar/Avatar.xcassets/ClothingLogo/BeerLogo.imageset")
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
let factor = min(42 / CGFloat(glyph.width), 36 / CGFloat(glyph.height))
let glyphSize = CGSize(width: CGFloat(glyph.width) * factor, height: CGFloat(glyph.height) * factor)
let frame = CGRect(x: (110 - glyphSize.width) / 2, y: (44 - glyphSize.height) / 2,
                   width: glyphSize.width, height: glyphSize.height)
var entries = [[String: String]]()
for scale in 1...3 {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 110 * scale, pixelsHigh: 44 * scale,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let context = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
    context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
    context.interpolationQuality = .high
    context.draw(glyph, in: frame)
    // Normalize the imagegen mask to the same pure white as the other shirt logos.
    context.setBlendMode(.sourceIn)
    context.setFillColor(CGColor(gray: 1, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: 110, height: 44))
    let data = bitmap.representation(using: .png, properties: [:])!
    let filename = "BeerLogo" + (scale == 1 ? "" : "@\(scale)x") + ".png"
    try data.write(to: directory.appendingPathComponent(filename))
    entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
    if let android, scale == 1 || scale == 3 {
        let density = scale == 1 ? "drawable" : "drawable-xxhdpi"
        let output = android.appendingPathComponent("app/src/main/res/\(density)")
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
        try data.write(to: output.appendingPathComponent("logo_beer.png"))
    }
}
let json: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
try (JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) + Data([10]))
    .write(to: directory.appendingPathComponent("Contents.json"))
print("Exported white beer logo at 1x/2x/3x on the original 110 x 44 canvas.")
