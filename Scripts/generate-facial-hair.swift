// SPDX-License-Identifier: MPL-2.0

// Run from the package root: swift Scripts/generate-facial-hair.swift
// Artwork uses the existing facial-hair layer's 168 x 152 point coordinates.
import AppKit

let output = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("Sources/Avatar/Avatar.xcassets/Facial Hair")

func path(_ draw: (CGMutablePath) -> Void) -> CGPath {
    let result = CGMutablePath()
    draw(result)
    return result
}

func fill(_ context: CGContext, _ shape: CGPath, alpha: CGFloat = 1) {
    context.setFillColor(CGColor(gray: 0, alpha: alpha))
    context.addPath(shape)
    context.fillPath()
}

func pencil(_ context: CGContext) {
    let half = path { p in
        p.move(to: CGPoint(x: 54, y: 76))
        p.addCurve(to: CGPoint(x: 81.5, y: 71.5), control1: CGPoint(x: 63, y: 71), control2: CGPoint(x: 74, y: 69.5))
        p.addQuadCurve(to: CGPoint(x: 81, y: 74.5), control: CGPoint(x: 83, y: 73.5))
        p.addCurve(to: CGPoint(x: 54, y: 76), control1: CGPoint(x: 73, y: 72.5), control2: CGPoint(x: 63, y: 75.5))
        p.closeSubpath()
    }
    fill(context, half)
    context.saveGState()
    context.translateBy(x: 168, y: 0)
    context.scaleBy(x: -1, y: 1)
    fill(context, half)
    context.restoreGState()
}

func horseshoe(_ context: CGContext) {
    let half = path { p in
        p.move(to: CGPoint(x: 82.5, y: 66.8))
        p.addCurve(to: CGPoint(x: 69, y: 65.6), control1: CGPoint(x: 79, y: 64.4), control2: CGPoint(x: 74, y: 64.5))
        p.addCurve(to: CGPoint(x: 51.6, y: 77.5), control1: CGPoint(x: 59.5, y: 67), control2: CGPoint(x: 53.8, y: 71))
        p.addCurve(to: CGPoint(x: 54, y: 110), control1: CGPoint(x: 48.8, y: 85.3), control2: CGPoint(x: 51, y: 99.8))
        p.addQuadCurve(to: CGPoint(x: 57, y: 111.6), control: CGPoint(x: 55.2, y: 111.2))
        p.addLine(to: CGPoint(x: 57.2, y: 109.7))
        p.addQuadCurve(to: CGPoint(x: 60.1, y: 110.4), control: CGPoint(x: 58.8, y: 110.8))
        p.addCurve(to: CGPoint(x: 59.5, y: 82.6), control1: CGPoint(x: 58.8, y: 100), control2: CGPoint(x: 57.4, y: 90))
        p.addCurve(to: CGPoint(x: 76.8, y: 76), control1: CGPoint(x: 61.2, y: 77.4), control2: CGPoint(x: 69.5, y: 77.1))
        p.addCurve(to: CGPoint(x: 82.5, y: 66.8), control1: CGPoint(x: 82.4, y: 75), control2: CGPoint(x: 84, y: 71))
        p.closeSubpath()
    }
    let strands = path { p in
        p.move(to: CGPoint(x: 76, y: 68))
        p.addCurve(to: CGPoint(x: 55.5, y: 102), control1: CGPoint(x: 56, y: 69), control2: CGPoint(x: 53, y: 80))
        p.move(to: CGPoint(x: 78, y: 71.5))
        p.addQuadCurve(to: CGPoint(x: 62, y: 76), control: CGPoint(x: 68.5, y: 70))
    }
    for mirrored in [false, true] {
        context.saveGState()
        if mirrored {
            context.translateBy(x: 168, y: 0)
            context.scaleBy(x: -1, y: 1)
        }
        fill(context, half)
        context.addPath(half)
        context.clip()
        context.setBlendMode(.destinationOut)
        context.setStrokeColor(CGColor(gray: 0, alpha: 0.16))
        context.setLineWidth(0.8)
        context.setLineCap(.round)
        context.addPath(strands)
        context.strokePath()
        context.restoreGState()
    }
}

func stubble(_ context: CGContext) {
    let mask = path { p in
        p.move(to: CGPoint(x: 29, y: 46))
        p.addCurve(to: CGPoint(x: 50, y: 67), control1: CGPoint(x: 34, y: 60), control2: CGPoint(x: 41, y: 65))
        p.addCurve(to: CGPoint(x: 84, y: 70), control1: CGPoint(x: 61, y: 70), control2: CGPoint(x: 71, y: 70))
        p.addCurve(to: CGPoint(x: 118, y: 67), control1: CGPoint(x: 97, y: 70), control2: CGPoint(x: 108, y: 70))
        p.addCurve(to: CGPoint(x: 139, y: 46), control1: CGPoint(x: 128, y: 65), control2: CGPoint(x: 134, y: 60))
        p.addLine(to: CGPoint(x: 140, y: 70))
        p.addCurve(to: CGPoint(x: 84, y: 115), control1: CGPoint(x: 140, y: 95), control2: CGPoint(x: 114, y: 115))
        p.addCurve(to: CGPoint(x: 28, y: 70), control1: CGPoint(x: 54, y: 115), control2: CGPoint(x: 28, y: 95))
        p.closeSubpath()
        p.addEllipse(in: CGRect(x: 61, y: 75, width: 46, height: 26))
    }
    context.saveGState()
    context.addPath(mask)
    context.clip(using: .evenOdd)
    context.setFillColor(CGColor(gray: 0, alpha: 0.07))
    context.fill(CGRect(x: 24, y: 44, width: 120, height: 74))

    // Fixed jitter keeps the short hairs organic and asset exports reproducible.
    var seed: UInt64 = 29471
    func random() -> CGFloat {
        seed = seed &* 6364136223846793005 &+ 1442695040888963407
        return CGFloat((seed >> 32) & 65535) / 65535
    }
    context.setLineCap(.round)
    for row in 0..<23 {
        for column in 0..<36 {
            let x = 26 + CGFloat(column) * 3.3 + (random() - 0.5) * 2
            let y = 44 + CGFloat(row) * 3.3 + (random() - 0.5) * 2
            let length = 0.65 + random() * 0.8
            context.setLineWidth(0.55 + random() * 0.25)
            context.setStrokeColor(CGColor(gray: 0, alpha: 0.32 + random() * 0.25))
            context.move(to: CGPoint(x: x, y: y))
            context.addLine(to: CGPoint(x: x + (x - 84) / 150, y: y + length))
            context.strokePath()
        }
    }
    context.restoreGState()
}

let styles: [(String, (CGContext) -> Void)] = [
    ("MoustachePencil", pencil), ("MoustacheHorseshoe", horseshoe),
    ("BeardStubble", stubble)
]
for (name, draw) in styles {
    let directory = output.appendingPathComponent(name + ".imageset")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    var entries = [[String: String]]()
    for scale in 1...3 {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 168 * scale, pixelsHigh: 152 * scale,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        let context = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
        context.clear(CGRect(x: 0, y: 0, width: 168 * scale, height: 152 * scale))
        context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
        context.translateBy(x: 0, y: 152)
        context.scaleBy(x: 1, y: -1)
        draw(context)
        let filename = name + (scale == 1 ? "" : "@\(scale)x") + ".png"
        try bitmap.representation(using: .png, properties: [:])!.write(to: directory.appendingPathComponent(filename))
        entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
    }
    let contents: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1],
        "properties": ["template-rendering-intent": "template"]]
    let json = try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted, .sortedKeys])
    try (json + Data([10])).write(to: directory.appendingPathComponent("Contents.json"))
    print("Exported \(name), 168 x 152 points, 1x/2x/3x template.")
}
