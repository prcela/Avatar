// SPDX-License-Identifier: MPL-2.0

// Run from the Avatar package root: swift Scripts/import-hood.swift [Android repo]
// The imagegen master keeps its original alpha; resize into the avatar canvas.
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let android = CommandLine.arguments.dropFirst().first.map { URL(fileURLWithPath: $0) }
func croppedMaster(_ name: String) -> CGImage {
    let source = root.appendingPathComponent("Scripts/Artwork/\(name)-source.png")
    let master = NSBitmapImageRep(data: try! Data(contentsOf: source))!
    var minX = master.pixelsWide, minY = master.pixelsHigh, maxX = 0, maxY = 0
    for y in 0..<master.pixelsHigh { for x in 0..<master.pixelsWide {
        if master.colorAt(x: x, y: y)!.alphaComponent > 0.05 {
            minX = min(minX, x); maxX = max(maxX, x)
            minY = min(minY, y); maxY = max(maxY, y)
        }
    } }
    return master.cgImage!.cropping(to: CGRect(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1))!
}
let fabric = croppedMaster("Hood")
let torso = croppedMaster("HoodieRaised")
// Shared vertical placement keeps the hood fabric and face shadow aligned.
let hoodOffsetY: CGFloat = 0

func render(_ scale: Int, name: String) -> Data {
    let height = name == "HoodieRaised" ? 110 : 280
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 264 * scale, pixelsHigh: height * scale,
        bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
        colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let context = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
    context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
    context.translateBy(x: 0, y: CGFloat(height))
    context.scaleBy(x: 1, y: -1)
    if name == "HoodShadow" {
        context.translateBy(x: 0, y: hoodOffsetY)
        // Fade the shadow down the forehead. The opening contains actual skin;
        // the opaque hood fabric is drawn over the outer edges of this ellipse.
        context.addEllipse(in: CGRect(x: 76, y: 42, width: 112, height: 142))
        context.clip()
        let space = CGColorSpaceCreateDeviceRGB()
        let colors = [CGColor(gray: 0, alpha: 0.34), CGColor(gray: 0, alpha: 0.15), CGColor(gray: 0, alpha: 0)]
        let gradient = CGGradient(colorsSpace: space, colors: colors as CFArray, locations: [0, 0.5, 1])!
        context.drawLinearGradient(gradient, start: CGPoint(x: 132, y: 57), end: CGPoint(x: 132, y: 116), options: [.drawsBeforeStartLocation])
    } else {
        let placement = name == "HoodieRaised"
            ? CGRect(x: 32, y: 14, width: 200, height: 96)
            // Preserve the narrower artwork instead of expanding its alpha bounds.
            : CGRect(x: 57, y: 8 + hoodOffsetY, width: 150, height: 234)
        context.interpolationQuality = .high
        context.translateBy(x: 0, y: placement.minY * 2 + placement.height)
        context.scaleBy(x: 1, y: -1)
        context.draw(name == "HoodieRaised" ? torso : fabric, in: placement)
    }
    return bitmap.representation(using: .png, properties: [:])!
}
for (name, resource) in [("Hood", "addon_hood"), ("HoodShadow", "addon_hood_shadow"), ("HoodieRaised", "clothing_hoodie_raised")] {
    let category = name == "HoodieRaised" ? "Clothing" : "Addon"
    let directory = root.appendingPathComponent("Sources/Avatar/Avatar.xcassets/\(category)/\(name).imageset")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    var entries = [[String: String]]()
    for scale in 1...3 {
        let filename = name + (scale == 1 ? "" : "@\(scale)x") + ".png"
        let data = render(scale, name: name)
        try data.write(to: directory.appendingPathComponent(filename))
        entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
        if scale == 3, let android {
            let destination = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
            try data.write(to: destination.appendingPathComponent(resource + ".png"))
        }
    }
    let json: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
    try (JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]) + Data([10]))
        .write(to: directory.appendingPathComponent("Contents.json"))
}
print("Exported hood, neutral shadow and sweatshirt base at 1x/2x/3x.")
