// Run from the package root: swift Scripts/generate-glasses.swift [Android repo]
// Artwork for 17 tintable glasses; Ski Goggles, Monocle and Future Visor keep their originals.
// Selected styles use their original PNG masters; Prozirne recolors only its bridge.
import AppKit
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let catalog = root.appendingPathComponent("Sources/Avatar/Avatar.xcassets/Glasses")
let android = CommandLine.arguments.dropFirst().first.map { URL(fileURLWithPath: $0) }
let names = ["Kurt", "Prescription 01", "Prescription 02", "Round", "Sunglasses", "Wayfarers", "KurtRed", "OliverBlack", "OliverGreen", "GlassesLines", "Prozirne", "BakineGlasses", "Bakine2Glasses", "StarsGlasses", "Soft Square", "Thin Square", "Bold Shades", "SkiGoggles", "Monocle", "FutureVisor"]
let androidNames = ["glasses_kurt", "glasses_prescription_01", "glasses_prescription_02", "glasses_round", "sunglasses", "glasses_wayfarers", "glasses_kurt_red", "glasses_oliver_black", "glasses_oliver_green", "glasses_lines", "glasses_prozirne", "glasses_bakine", "glasses_bakine2", "glasses_stars", "glasses_soft_square", "glasses_thin_square", "glasses_bold_shades", "glasses_ski_goggles", "glasses_monocle", "glasses_future_visor"]
let defaultColors: [UInt32] = [0xF4F3ED, 0xD6EDF2, 0x242A30, 0x30383E, 0x30383E, 0x242A30, 0xDB4549, 0x55535B, 0xC9AB50, 0x292B34, 0xB8BEC5, 0x8076D8, 0x548431, 0xECC43E, 0x573A30, 0x674E43, 0x433029, 0x354553, 0xD9AC48, 0x354553]
func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> CGColor { CGColor(srgbRed: CGFloat((hex >> 16) & 255)/255, green: CGFloat((hex >> 8) & 255)/255, blue: CGFloat(hex & 255)/255, alpha: alpha) }
func path(_ build: (CGMutablePath) -> Void) -> CGPath { let p = CGMutablePath(); build(p); return p }
func rr(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ r: CGFloat) -> CGPath { CGPath(roundedRect: CGRect(x: x, y: y, width: w, height: h), cornerWidth: r, cornerHeight: r, transform: nil) }
func stroke(_ p: CGPath, _ w: CGFloat) -> CGPath { p.copy(strokingWithWidth: w, lineCap: .round, lineJoin: .round, miterLimit: 2) }
func line(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ w: CGFloat) -> CGPath { stroke(path { $0.move(to: CGPoint(x: x1, y: y1)); $0.addLine(to: CGPoint(x: x2, y: y2)) }, w) }
func mirror(_ p: CGPath) -> CGPath { var t = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 142, ty: 0); return p.copy(using: &t)! }
struct Style { let frame: CGPath; let lenses: [CGPath]; let lensColors: [CGColor]; let bevel: CGImage }
func style(_ id: Int) -> Style {
    var frame = CGMutablePath(); var lenses = [CGPath]()
    var colors = [color(0x9EDCED, 0.06), color(0xBADCE6, 0.12)]
    func rim(_ p: CGPath, _ w: CGFloat) { lenses.append(p); frame.addPath(stroke(p, w)) }
    func pair(_ p: CGPath, _ w: CGFloat, bridge: CGFloat = 20, arms: CGFloat = 19, armWidth: CGFloat? = nil) {
        rim(p, w); rim(mirror(p), w)
        let b = path { $0.move(to: CGPoint(x: 60, y: bridge)); $0.addCurve(to: CGPoint(x: 82, y: bridge), control1: CGPoint(x: 67, y: bridge - 5), control2: CGPoint(x: 75, y: bridge - 5)) }
        frame.addPath(stroke(b, max(1.5, w * 0.75)))
        let edge = p.boundingBoxOfPath.minX
        frame.addPath(line(max(3, edge - 6), arms, edge + 0.5, arms, max(1.5, armWidth ?? w)))
        frame.addPath(line(141.5 - edge, arms, min(139, 148 - edge), arms, max(1.5, armWidth ?? w)))
    }
    let aviator = path { p in
        p.move(to: CGPoint(x: 13, y: 14)); p.addCurve(to: CGPoint(x: 62, y: 15), control1: CGPoint(x: 21, y: 8), control2: CGPoint(x: 51, y: 8))
        p.addCurve(to: CGPoint(x: 45, y: 48), control1: CGPoint(x: 68, y: 22), control2: CGPoint(x: 58, y: 43))
        p.addCurve(to: CGPoint(x: 14, y: 35), control1: CGPoint(x: 25, y: 54), control2: CGPoint(x: 15, y: 45))
        p.addQuadCurve(to: CGPoint(x: 13, y: 14), control: CGPoint(x: 9, y: 21)); p.closeSubpath()
    }
    switch id {
    case 1, 7:
        // Follow the original rounded, upright silhouette. The outer edge is
        // fuller than the inner rim, with no pointed extension at the brow.
        let lens = path { p in
            p.move(to: CGPoint(x: 34, y: 8))
            p.addCurve(to: CGPoint(x: 58.5, y: 18.5), control1: CGPoint(x: 46, y: 8), control2: CGPoint(x: 56, y: 14))
            p.addCurve(to: CGPoint(x: 57, y: 33), control1: CGPoint(x: 61, y: 22), control2: CGPoint(x: 58, y: 29))
            p.addCurve(to: CGPoint(x: 42, y: 46), control1: CGPoint(x: 54, y: 43), control2: CGPoint(x: 49, y: 46))
            p.addCurve(to: CGPoint(x: 24, y: 37), control1: CGPoint(x: 35, y: 46), control2: CGPoint(x: 28, y: 43))
            p.addCurve(to: CGPoint(x: 17, y: 23), control1: CGPoint(x: 19, y: 31), control2: CGPoint(x: 17, y: 27))
            p.addCurve(to: CGPoint(x: 23, y: 10), control1: CGPoint(x: 17, y: 16), control2: CGPoint(x: 18, y: 12))
            p.addCurve(to: CGPoint(x: 34, y: 8), control1: CGPoint(x: 26, y: 8), control2: CGPoint(x: 31, y: 8))
            p.closeSubpath()
        }
        let outer = path { p in
            p.move(to: CGPoint(x: 31, y: 3))
            p.addCurve(to: CGPoint(x: 60, y: 10), control1: CGPoint(x: 43, y: 3), control2: CGPoint(x: 52, y: 6))
            p.addCurve(to: CGPoint(x: 67, y: 19), control1: CGPoint(x: 65, y: 12), control2: CGPoint(x: 67, y: 15))
            p.addCurve(to: CGPoint(x: 60, y: 38), control1: CGPoint(x: 67, y: 25), control2: CGPoint(x: 63, y: 32))
            p.addCurve(to: CGPoint(x: 44, y: 51), control1: CGPoint(x: 55, y: 47), control2: CGPoint(x: 52, y: 51))
            p.addCurve(to: CGPoint(x: 21, y: 43), control1: CGPoint(x: 35, y: 51), control2: CGPoint(x: 28, y: 50))
            p.addCurve(to: CGPoint(x: 6, y: 20), control1: CGPoint(x: 13, y: 34), control2: CGPoint(x: 6, y: 25))
            p.addCurve(to: CGPoint(x: 11, y: 7), control1: CGPoint(x: 6, y: 13), control2: CGPoint(x: 7, y: 9))
            p.addCurve(to: CGPoint(x: 31, y: 3), control1: CGPoint(x: 17, y: 3), control2: CGPoint(x: 23, y: 3))
            p.closeSubpath()
        }
        let bridge = path {
            $0.move(to: CGPoint(x: 62, y: 24))
            $0.addCurve(to: CGPoint(x: 80, y: 24), control1: CGPoint(x: 67, y: 15), control2: CGPoint(x: 75, y: 15))
        }
        lenses = [lens, mirror(lens)]
        frame = outer.union(mirror(outer)).union(stroke(bridge, 8)).mutableCopy()!
        colors = [color(0x25313A), color(0x101923)]
    case 4:
        pair(CGPath(ellipseIn: CGRect(x: 17, y: 9, width: 44, height: 42), transform: nil), 4.2, bridge: 23, arms: 20)
    case 8, 9:
        pair(aviator, 1.8, bridge: 21, arms: 16); frame.addPath(line(43, 11, 99, 11, 1.5))
        if id == 8 { colors = [color(0x344650), color(0x172735)] }
        if id == 9 { colors = [color(0x376E3D), color(0x196D91)] }
    case 12, 13:
        let p = path { p in
            p.move(to: CGPoint(x: 16, y: 21)); p.addCurve(to: CGPoint(x: 63, y: 25), control1: CGPoint(x: 28, y: 5), control2: CGPoint(x: 52, y: 9))
            p.addCurve(to: CGPoint(x: 45, y: 45), control1: CGPoint(x: 57, y: 41), control2: CGPoint(x: 55, y: 45))
            p.addCurve(to: CGPoint(x: 16, y: 21), control1: CGPoint(x: 28, y: 49), control2: CGPoint(x: 20, y: 35)); p.closeSubpath()
        }
        if id == 12 {
            // Close both rims at a consistent width. The bridge terminates at
            // the actual inner corners instead of protruding into the lenses.
            rim(p, 1.8); rim(mirror(p), 1.8)
            let bridge = path {
                $0.move(to: CGPoint(x: 63, y: 25))
                $0.addCurve(to: CGPoint(x: 79, y: 25), control1: CGPoint(x: 67, y: 19), control2: CGPoint(x: 75, y: 19))
            }
            frame.addPath(stroke(bridge, 1.8))
            frame.addPath(line(10, 21, 16, 21, 1.8))
            frame.addPath(line(126, 21, 132, 21, 1.8))
            // Keep lens fill and reflections inside the rims, leaving their
            // full outline visible at small avatar sizes.
            lenses = lenses.map { $0.subtracting(frame) }
        } else {
            pair(p, 4.8, bridge: 24, arms: 21)
        }
    case 14:
        func star(_ cx: CGFloat) -> CGPath { path { p in
            // Broaden the center as well as the tips so large eyes fit inside
            // the lower notches. Keep the rim within the 54-point canvas.
            for i in 0..<10 {
                let a = CGFloat(i) * .pi / 5 - .pi / 2
                let inner: CGFloat = i == 5 ? 14.5 : (i == 3 || i == 7 ? 18 : 16)
                let r: CGFloat = i % 2 == 0 ? 27 : inner
                let pt = CGPoint(x: cx + cos(a) * r, y: 29 + sin(a) * r)
                if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
            }; p.closeSubpath()
        } }
        let left = star(43), right = star(99)
        lenses = [left, right]
        frame = stroke(left, 3.5).union(stroke(right, 3.5))
            .union(line(68, 21, 74, 21, 2.2)).mutableCopy()!
        colors = [color(0xEED47B, 0.30), color(0x907A32, 0.40)]
    case 15:
        // Follow the original Soft Square silhouette: broad brow corners,
        // a solid bridge, and thin rims tapering into a rounded lower half.
        let lens = path { p in
            p.move(to: CGPoint(x: 38, y: 12))
            p.addCurve(to: CGPoint(x: 61, y: 18), control1: CGPoint(x: 48, y: 12), control2: CGPoint(x: 58, y: 13))
            p.addCurve(to: CGPoint(x: 64, y: 28), control1: CGPoint(x: 64, y: 23), control2: CGPoint(x: 65, y: 25))
            p.addCurve(to: CGPoint(x: 39, y: 51), control1: CGPoint(x: 63, y: 40), control2: CGPoint(x: 54, y: 51))
            p.addCurve(to: CGPoint(x: 24, y: 47), control1: CGPoint(x: 32, y: 51), control2: CGPoint(x: 28, y: 51))
            p.addCurve(to: CGPoint(x: 15, y: 27), control1: CGPoint(x: 18, y: 41), control2: CGPoint(x: 15, y: 34))
            p.addCurve(to: CGPoint(x: 18, y: 18), control1: CGPoint(x: 15, y: 22), control2: CGPoint(x: 15, y: 20))
            p.addCurve(to: CGPoint(x: 38, y: 12), control1: CGPoint(x: 23, y: 14), control2: CGPoint(x: 29, y: 12))
            p.closeSubpath()
        }
        rim(lens, 3); rim(mirror(lens), 3)
        let brow = path { p in
            p.move(to: CGPoint(x: 8, y: 15))
            p.addCurve(to: CGPoint(x: 38, y: 10), control1: CGPoint(x: 17, y: 11), control2: CGPoint(x: 26, y: 10))
            p.addCurve(to: CGPoint(x: 64, y: 16), control1: CGPoint(x: 52, y: 10), control2: CGPoint(x: 57, y: 12))
            p.addCurve(to: CGPoint(x: 71, y: 19), control1: CGPoint(x: 67, y: 18), control2: CGPoint(x: 68, y: 19))
            p.addCurve(to: CGPoint(x: 78, y: 16), control1: CGPoint(x: 74, y: 19), control2: CGPoint(x: 75, y: 18))
            p.addCurve(to: CGPoint(x: 104, y: 10), control1: CGPoint(x: 85, y: 12), control2: CGPoint(x: 90, y: 10))
            p.addCurve(to: CGPoint(x: 134, y: 15), control1: CGPoint(x: 116, y: 10), control2: CGPoint(x: 125, y: 11))
            p.addLine(to: CGPoint(x: 134, y: 23))
            p.addQuadCurve(to: CGPoint(x: 127, y: 27), control: CGPoint(x: 134, y: 25))
            p.addCurve(to: CGPoint(x: 104, y: 17), control1: CGPoint(x: 126, y: 20), control2: CGPoint(x: 117, y: 17))
            p.addCurve(to: CGPoint(x: 76, y: 23), control1: CGPoint(x: 91, y: 17), control2: CGPoint(x: 84, y: 23))
            p.addLine(to: CGPoint(x: 66, y: 23))
            p.addCurve(to: CGPoint(x: 38, y: 17), control1: CGPoint(x: 58, y: 23), control2: CGPoint(x: 51, y: 17))
            p.addCurve(to: CGPoint(x: 15, y: 27), control1: CGPoint(x: 25, y: 17), control2: CGPoint(x: 16, y: 20))
            p.addQuadCurve(to: CGPoint(x: 8, y: 23), control: CGPoint(x: 8, y: 25))
            p.closeSubpath()
        }
        frame = frame.union(brow).mutableCopy()!
        colors = [color(0xFFFFFF, 0), color(0xFFFFFF, 0)]
    default: fatalError("Unknown glasses style")
    }
    // Keep Kurt and Soft Square rims and brows outside the lens openings.
    let visibleFrame: CGPath = id == 1 || id == 7 || id == 15
        ? lenses.reduce(frame as CGPath) { $0.subtracting($1) }
        : frame
    return Style(frame: visibleFrame, lenses: lenses, lensColors: colors, bevel: makeBevel(visibleFrame))
}
func gradient(_ ctx: CGContext, _ colors: [CGColor], _ from: CGPoint, _ to: CGPoint) {
    let g = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB), colors: colors as CFArray, locations: nil)!
    ctx.drawLinearGradient(g, start: from, end: to, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
}
func drawFrame(_ ctx: CGContext, _ s: Style, _ tint: CGColor) {
    ctx.saveGState(); ctx.addPath(s.frame); ctx.clip(); ctx.setFillColor(tint); ctx.fill(CGRect(x: 0, y: 0, width: 142, height: 54)); ctx.setBlendMode(.multiply)
    gradient(ctx, [color(0xFAFAFA), color(0xB7B7B7), color(0x838383)], CGPoint(x: 50, y: 4), CGPoint(x: 80, y: 54)); ctx.restoreGState()
}
func drawDetails(_ ctx: CGContext, _ s: Style) {
    for p in s.lenses {
        ctx.saveGState(); ctx.addPath(p); ctx.clip(); gradient(ctx, s.lensColors, CGPoint(x: 0, y: 7), CGPoint(x: 0, y: 51))
        let b = p.boundingBoxOfPath
        let shine = path { p in
            p.move(to: CGPoint(x: b.minX + b.width * 0.16, y: b.minY)); p.addLine(to: CGPoint(x: b.minX + b.width * 0.32, y: b.minY)); p.addLine(to: CGPoint(x: b.minX + b.width * 0.12, y: b.maxY)); p.addLine(to: CGPoint(x: b.minX, y: b.maxY)); p.closeSubpath()
        }
        ctx.setFillColor(color(0xFFFFFF, 0.17)); ctx.addPath(shine); ctx.fillPath(); ctx.restoreGState()
    }
    // Preserve soft highlights even when the selected frame color is black.
    ctx.saveGState(); ctx.addPath(s.frame); ctx.clip()
    gradient(ctx, [color(0xFFFFFF, 0.20), color(0xFFFFFF, 0.02), color(0xFFFFFF, 0)], CGPoint(x: 15, y: 5), CGPoint(x: 70, y: 27))
    ctx.restoreGState()
    ctx.saveGState(); ctx.translateBy(x: 0, y: 54); ctx.scaleBy(x: 1, y: -1)
    ctx.draw(s.bevel, in: CGRect(x: 0, y: 0, width: 142, height: 54)); ctx.restoreGState()
}
// Shade the union silhouette, avoiding seams where rims, bridges and arms join.
func makeBevel(_ shape: CGPath) -> CGImage {
    func bitmap() -> NSBitmapImageRep { NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 426, pixelsHigh: 162, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)! }
    let mask = bitmap(), result = bitmap()
    let ctx = NSGraphicsContext(bitmapImageRep: mask)!.cgContext
    ctx.scaleBy(x: 3, y: 3); ctx.translateBy(x: 0, y: 54); ctx.scaleBy(x: 1, y: -1)
    ctx.setFillColor(color(0xFFFFFF)); ctx.addPath(shape); ctx.fillPath()
    let input = mask.bitmapData!, output = result.bitmapData!
    for y in 0..<162 { for x in 0..<426 {
        let offset = y * mask.bytesPerRow + x * 4
        guard input[offset + 3] > 0 else { continue }
        var distance = 25, nx = 0, ny = 0
        for dy in -4...4 { for dx in -4...4 {
            let d = dx * dx + dy * dy
            guard d > 0 && d < distance else { continue }
            let xx = x + dx, yy = y + dy
            if xx < 0 || yy < 0 || xx >= 426 || yy >= 162 || input[yy * mask.bytesPerRow + xx * 4 + 3] < 128 {
                distance = d; nx = dx; ny = dy
            }
        } }
        guard distance < 25 else { continue }
        let radius = sqrt(Double(distance))
        let light = (-0.5 * Double(nx) - 0.866 * Double(ny)) / radius
        let alpha = UInt8(min(255, abs(light) * (1 - radius / 5) * (light > 0 ? 0.7 : 0.42) * Double(input[offset + 3])))
        let out = y * result.bytesPerRow + x * 4
        output[out + 3] = alpha
        if light > 0 { output[out] = alpha; output[out + 1] = alpha; output[out + 2] = alpha }
    } }
    return result.cgImage!
}
func render(_ scale: Int, _ draw: (CGContext) -> Void) -> Data {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 142 * scale, pixelsHigh: 54 * scale, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!.cgContext
    ctx.scaleBy(x: CGFloat(scale), y: CGFloat(scale)); ctx.translateBy(x: 0, y: 54); ctx.scaleBy(x: 1, y: -1); draw(ctx)
    return rep.representation(using: .png, properties: [:])!
}
func save(_ name: String, _ scales: [Int], originalData: Data? = nil, _ draw: (CGContext) -> Void) throws {
    let dir = catalog.appendingPathComponent(name + ".imageset"); try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    var entries = [[String: String]]()
    for scale in scales {
        let filename = name + (scale == 1 ? "" : "@\(scale)x") + ".png"
        let data = scale == 1 ? (originalData ?? render(scale, draw)) : render(scale, draw)
        try data.write(to: dir.appendingPathComponent(filename)); entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
    }
    let metadata: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
    try (JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted, .sortedKeys]) + Data([10])).write(to: dir.appendingPathComponent("Contents.json"))
}
// Preserve the supplied bitmap geometry, antialiasing and shadow. The original
// opaque frame color becomes white so the existing multiply tint can recolor it.
// Openings remain transparent; no new lens, bevel or reflection is added.
func exportOriginalFrame(_ id: Int) throws {
    let name = names[id - 1], suffix = String(format: "%02d", id)
    let originalURL = catalog.appendingPathComponent(name + ".imageset/" + name + ".png")
    let originalData = try Data(contentsOf: originalURL)
    let original = NSBitmapImageRep(data: originalData)!
    precondition(original.pixelsWide == 142 && original.pixelsHigh == 54)
    let frame = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 142, pixelsHigh: 54, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bitmapFormat: .alphaNonpremultiplied, bytesPerRow: 0, bitsPerPixel: 0)!
    let base: NSColor
    switch id {
    case 2: base = NSColor(srgbRed: 221/255, green: 238/255, blue: 245/255, alpha: 1)
    case 3: base = NSColor(srgbRed: 49/255, green: 58/255, blue: 62/255, alpha: 1)
    case 10: base = NSColor(srgbRed: 50/255, green: 36/255, blue: 36/255, alpha: 1)
    default: fatalError("Unknown original frame")
    }
    func luminance(_ c: NSColor) -> CGFloat { 0.2126 * c.redComponent + 0.7152 * c.greenComponent + 0.0722 * c.blueComponent }
    let baseLuminance = luminance(base)
    for y in 0..<54 { for x in 0..<142 {
        let c = original.colorAt(x: x, y: y)!.usingColorSpace(.sRGB)!
        let shade = min(1, luminance(c) / baseLuminance)
        let offset = y * frame.bytesPerRow + x * 4, pixels = frame.bitmapData!
        let gray = UInt8((shade * 255).rounded())
        pixels[offset] = gray; pixels[offset + 1] = gray; pixels[offset + 2] = gray
        pixels[offset + 3] = UInt8((c.alphaComponent * 255).rounded())
    } }
    func draw(_ image: CGImage, in ctx: CGContext) {
        ctx.saveGState(); ctx.translateBy(x: 0, y: 54); ctx.scaleBy(x: 1, y: -1)
        ctx.interpolationQuality = .high
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: 142, height: 54)); ctx.restoreGState()
    }
    let sourceImage = original.cgImage!, frameImage = frame.cgImage!
    try save(name, [1, 2, 3], originalData: originalData) { draw(sourceImage, in: $0) }
    try save("GlassesFrame" + suffix, [3]) { draw(frameImage, in: $0) }
    try save("GlassesDetails" + suffix, [3]) { _ in }
    if let android {
        let dest = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
        try FileManager.default.createDirectory(at: dest, withIntermediateDirectories: true)
        try render(3) { draw(sourceImage, in: $0) }.write(to: dest.appendingPathComponent(androidNames[id - 1] + ".png"))
        try render(3) { draw(frameImage, in: $0) }.write(to: dest.appendingPathComponent("glasses_frame_" + suffix + ".png"))
        try render(3) { _ in }.write(to: dest.appendingPathComponent("glasses_details_" + suffix + ".png"))
        let fallback = android.appendingPathComponent("app/src/main/res/drawable/" + androidNames[id - 1] + ".png")
        if FileManager.default.fileExists(atPath: fallback.path) { try originalData.write(to: fallback) }
    }
}
// Original Sunglasses and Wayfarers use #313A3E frames with neutral lenses
// and shadow. Separate their premultiplied contributions at export resolution,
// retaining the existing silhouette, lens gradient and antialiased edges.
func exportOriginalShades(_ id: Int) throws {
    let name = names[id - 1], suffix = String(format: "%02d", id)
    let originalURL = catalog.appendingPathComponent(name + ".imageset/" + name + ".png")
    let originalData = try Data(contentsOf: originalURL)
    let original = NSBitmapImageRep(data: originalData)!
    precondition(original.pixelsWide == 142 && original.pixelsHigh == 54)
    func draw(_ image: CGImage, in ctx: CGContext) {
        ctx.saveGState(); ctx.translateBy(x: 0, y: 54); ctx.scaleBy(x: 1, y: -1)
        ctx.interpolationQuality = .high
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: 142, height: 54)); ctx.restoreGState()
    }
    let sourceImage = original.cgImage!
    let source3xData = render(3) { draw(sourceImage, in: $0) }
    let scaled = NSBitmapImageRep(data: source3xData)!
    func layer() -> NSBitmapImageRep {
        NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 426, pixelsHigh: 162, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bitmapFormat: .alphaNonpremultiplied, bytesPerRow: 0, bitsPerPixel: 0)!
    }
    let frame = layer(), details = layer()
    let baseRed: CGFloat = 49/255, baseGreen: CGFloat = 58/255, baseBlue: CGFloat = 62/255
    func byte(_ value: CGFloat) -> UInt8 { UInt8((min(1, max(0, value)) * 255).rounded()) }
    for y in 0..<162 { for x in 0..<426 {
        let c = scaled.colorAt(x: x, y: y)!.usingColorSpace(.sRGB)!
        let alpha = c.alphaComponent
        let contribution = min(alpha, max(0, (c.blueComponent - c.redComponent) * alpha / (baseBlue - baseRed)))
        let detailAlpha = alpha - contribution
        // Details are drawn over the tinted frame by both platform renderers.
        let frameAlpha = detailAlpha < 1 ? contribution / (1 - detailAlpha) : 0
        let grayContribution = ((c.redComponent + c.greenComponent + c.blueComponent) * alpha - (baseRed + baseGreen + baseBlue) * contribution) / 3
        let shade = detailAlpha > 0 ? grayContribution / detailAlpha : 0
        let f = y * frame.bytesPerRow + x * 4, d = y * details.bytesPerRow + x * 4
        let fp = frame.bitmapData!, dp = details.bitmapData!
        fp[f] = 255; fp[f + 1] = 255; fp[f + 2] = 255; fp[f + 3] = byte(frameAlpha)
        dp[d] = byte(shade); dp[d + 1] = byte(shade); dp[d + 2] = byte(shade); dp[d + 3] = byte(detailAlpha)
    } }
    try save(name, [1, 2, 3], originalData: originalData) { draw(sourceImage, in: $0) }
    try save("GlassesFrame" + suffix, [3]) { draw(frame.cgImage!, in: $0) }
    try save("GlassesDetails" + suffix, [3]) { draw(details.cgImage!, in: $0) }
    if let android {
        let dest = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
        try FileManager.default.createDirectory(at: dest, withIntermediateDirectories: true)
        try source3xData.write(to: dest.appendingPathComponent(androidNames[id - 1] + ".png"))
        try render(3) { draw(frame.cgImage!, in: $0) }.write(to: dest.appendingPathComponent("glasses_frame_" + suffix + ".png"))
        try render(3) { draw(details.cgImage!, in: $0) }.write(to: dest.appendingPathComponent("glasses_details_" + suffix + ".png"))
        let fallback = android.appendingPathComponent("app/src/main/res/drawable/" + androidNames[id - 1] + ".png")
        if FileManager.default.fileExists(atPath: fallback.path) { try originalData.write(to: fallback) }
    }
}
// Prozirne is rimless. Retain the original glass pixels and isolate only the
// brighter metal bridge in the small region above the nose for tinting.
func exportOriginalBridge() throws {
    let name = "Prozirne"
    let originalURL = catalog.appendingPathComponent(name + ".imageset/" + name + ".png")
    let originalData = try Data(contentsOf: originalURL)
    let original = NSBitmapImageRep(data: originalData)!
    precondition(original.pixelsWide == 142 && original.pixelsHigh == 54)
    func draw(_ image: CGImage, in ctx: CGContext) {
        ctx.saveGState(); ctx.translateBy(x: 0, y: 54); ctx.scaleBy(x: 1, y: -1)
        ctx.interpolationQuality = .high
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: 142, height: 54)); ctx.restoreGState()
    }
    let sourceImage = original.cgImage!
    let source3xData = render(3) { draw(sourceImage, in: $0) }
    let details = NSBitmapImageRep(data: source3xData)!
    precondition(details.bitmapFormat.contains(.alphaNonpremultiplied) && details.samplesPerPixel == 4)
    let frame = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 426, pixelsHigh: 162, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bitmapFormat: .alphaNonpremultiplied, bytesPerRow: 0, bitsPerPixel: 0)!
    // Original glass is #606060 with highlights up to #696969. The #8A8A8A
    // bridge is confined to this region; darker glass and shadow stay untouched.
    let metal: CGFloat = 138/255, glassCeiling: CGFloat = 110/255
    func byte(_ value: CGFloat) -> UInt8 { UInt8((min(1, max(0, value)) * 255).rounded()) }
    for y in 15..<33 { for x in 174..<252 {
        let d = y * details.bytesPerRow + x * 4, f = y * frame.bytesPerRow + x * 4
        let dp = details.bitmapData!, fp = frame.bitmapData!
        let alpha = CGFloat(dp[d + 3]) / 255
        let gray = CGFloat(dp[d]) / 255
        let contribution = alpha * min(1, max(0, (gray - glassCeiling) / (metal - glassCeiling)))
        let detailAlpha = alpha - contribution
        let frameAlpha = detailAlpha < 1 ? contribution / (1 - detailAlpha) : 0
        guard byte(frameAlpha) > 0 else { continue }
        let shade = detailAlpha > 0 ? (gray * alpha - metal * contribution) / detailAlpha : 0
        fp[f] = 255; fp[f + 1] = 255; fp[f + 2] = 255; fp[f + 3] = byte(frameAlpha)
        dp[d] = byte(shade); dp[d + 1] = byte(shade); dp[d + 2] = byte(shade); dp[d + 3] = byte(detailAlpha)
    } }
    // Write the layers directly, preserving all untouched original glass pixels.
    func saveLayer(_ layerName: String, _ data: Data) throws {
        let dir = catalog.appendingPathComponent(layerName + ".imageset")
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let filename = layerName + "@3x.png"
        try data.write(to: dir.appendingPathComponent(filename))
        let metadata: [String: Any] = ["images": [["filename": filename, "idiom": "universal", "scale": "3x"]], "info": ["author": "xcode", "version": 1]]
        try (JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted, .sortedKeys]) + Data([10])).write(to: dir.appendingPathComponent("Contents.json"))
    }
    let frameData = frame.representation(using: .png, properties: [:])!
    let detailsData = details.representation(using: .png, properties: [:])!
    try save(name, [1, 2, 3], originalData: originalData) { draw(sourceImage, in: $0) }
    try saveLayer("GlassesFrame11", frameData)
    try saveLayer("GlassesDetails11", detailsData)
    if let android {
        let dest = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
        try FileManager.default.createDirectory(at: dest, withIntermediateDirectories: true)
        try source3xData.write(to: dest.appendingPathComponent("glasses_prozirne.png"))
        try frameData.write(to: dest.appendingPathComponent("glasses_frame_11.png"))
        try detailsData.write(to: dest.appendingPathComponent("glasses_details_11.png"))
        let fallback = android.appendingPathComponent("app/src/main/res/drawable/glasses_prozirne.png")
        if FileManager.default.fileExists(atPath: fallback.path) { try originalData.write(to: fallback) }
    }
}
// Trace the original Thin Square and Bold Shades contours as smooth curves.
// Export from the curves at each scale instead of enlarging their 1x pixels.
func exportSmoothOriginal(_ id: Int) throws {
    let name = names[id - 1], suffix = String(format: "%02d", id)
    let frame: CGPath
    var lenses = [CGPath]()
    if id == 16 {
        let rim = path { p in
            p.move(to: CGPoint(x: 39, y: 12))
            p.addCurve(to: CGPoint(x: 59, y: 15), control1: CGPoint(x: 49, y: 12), control2: CGPoint(x: 55, y: 12))
            p.addCurve(to: CGPoint(x: 63.5, y: 25), control1: CGPoint(x: 63, y: 18), control2: CGPoint(x: 63.5, y: 21))
            p.addCurve(to: CGPoint(x: 58, y: 42), control1: CGPoint(x: 63.5, y: 32), control2: CGPoint(x: 61, y: 38))
            p.addCurve(to: CGPoint(x: 40, y: 49.5), control1: CGPoint(x: 54, y: 47), control2: CGPoint(x: 50, y: 49.5))
            p.addCurve(to: CGPoint(x: 22, y: 44), control1: CGPoint(x: 30, y: 49.5), control2: CGPoint(x: 26, y: 49))
            p.addCurve(to: CGPoint(x: 17.5, y: 26), control1: CGPoint(x: 18, y: 40), control2: CGPoint(x: 17.5, y: 34))
            p.addCurve(to: CGPoint(x: 21, y: 16), control1: CGPoint(x: 17.5, y: 21), control2: CGPoint(x: 17.5, y: 19))
            p.addCurve(to: CGPoint(x: 39, y: 12), control1: CGPoint(x: 25, y: 12), control2: CGPoint(x: 30, y: 12))
            p.closeSubpath()
        }
        let brow = path { p in
            p.move(to: CGPoint(x: 17.5, y: 21))
            p.addCurve(to: CGPoint(x: 39, y: 12), control1: CGPoint(x: 19, y: 13), control2: CGPoint(x: 28, y: 12))
            p.addCurve(to: CGPoint(x: 63.5, y: 21), control1: CGPoint(x: 54, y: 12), control2: CGPoint(x: 62, y: 12))
        }
        let arm = path { p in
            p.move(to: CGPoint(x: 7, y: 18))
            p.addQuadCurve(to: CGPoint(x: 18, y: 20), control: CGPoint(x: 13, y: 21))
        }
        let bridge = path { p in
            p.move(to: CGPoint(x: 63.5, y: 21))
            p.addQuadCurve(to: CGPoint(x: 78.5, y: 21), control: CGPoint(x: 71, y: 19))
        }
        let left = stroke(rim, 0.55).union(stroke(brow, 1.8)).union(stroke(arm, 1.4))
        frame = left.union(mirror(left)).union(stroke(bridge, 1.8))
    } else {
        let lens = path { p in
            p.move(to: CGPoint(x: 38, y: 12))
            p.addCurve(to: CGPoint(x: 60, y: 17), control1: CGPoint(x: 48, y: 12), control2: CGPoint(x: 57, y: 14))
            p.addCurve(to: CGPoint(x: 63.5, y: 28), control1: CGPoint(x: 64.5, y: 20), control2: CGPoint(x: 64.5, y: 23))
            p.addCurve(to: CGPoint(x: 55.5, y: 44), control1: CGPoint(x: 63, y: 34), control2: CGPoint(x: 59, y: 40))
            p.addCurve(to: CGPoint(x: 34, y: 53), control1: CGPoint(x: 49, y: 50), control2: CGPoint(x: 43, y: 53))
            p.addCurve(to: CGPoint(x: 15.5, y: 47), control1: CGPoint(x: 25, y: 53), control2: CGPoint(x: 19, y: 52))
            p.addCurve(to: CGPoint(x: 11, y: 27), control1: CGPoint(x: 11.3, y: 40), control2: CGPoint(x: 11, y: 32))
            p.addCurve(to: CGPoint(x: 17, y: 16), control1: CGPoint(x: 11.5, y: 21), control2: CGPoint(x: 12, y: 18))
            p.addCurve(to: CGPoint(x: 38, y: 12), control1: CGPoint(x: 23, y: 12), control2: CGPoint(x: 29, y: 12))
            p.closeSubpath()
        }
        let outer = path { p in
            p.move(to: CGPoint(x: 35, y: 9.5))
            p.addCurve(to: CGPoint(x: 65, y: 13), control1: CGPoint(x: 49, y: 9.5), control2: CGPoint(x: 55, y: 11))
            p.addCurve(to: CGPoint(x: 68, y: 26), control1: CGPoint(x: 72, y: 15), control2: CGPoint(x: 72, y: 20))
            p.addCurve(to: CGPoint(x: 52, y: 51), control1: CGPoint(x: 61, y: 42), control2: CGPoint(x: 58, y: 46))
            p.addCurve(to: CGPoint(x: 33, y: 54.5), control1: CGPoint(x: 46, y: 54.5), control2: CGPoint(x: 39, y: 54.5))
            p.addCurve(to: CGPoint(x: 13, y: 47), control1: CGPoint(x: 24, y: 54.5), control2: CGPoint(x: 16, y: 53.5))
            p.addCurve(to: CGPoint(x: 8.5, y: 27), control1: CGPoint(x: 10, y: 41), control2: CGPoint(x: 9, y: 34))
            p.addQuadCurve(to: CGPoint(x: 6.5, y: 23), control: CGPoint(x: 8.5, y: 24))
            p.addLine(to: CGPoint(x: 6.5, y: 14.5))
            p.addCurve(to: CGPoint(x: 35, y: 9.5), control1: CGPoint(x: 15, y: 11), control2: CGPoint(x: 25, y: 9.5))
            p.closeSubpath()
        }
        let bridge = path { p in
            p.move(to: CGPoint(x: 62, y: 14))
            p.addQuadCurve(to: CGPoint(x: 80, y: 14), control: CGPoint(x: 71, y: 15))
            p.addLine(to: CGPoint(x: 81, y: 26))
            p.addCurve(to: CGPoint(x: 71, y: 23), control1: CGPoint(x: 78, y: 26), control2: CGPoint(x: 75, y: 23))
            p.addCurve(to: CGPoint(x: 61, y: 26), control1: CGPoint(x: 67, y: 23), control2: CGPoint(x: 64, y: 26))
            p.closeSubpath()
        }
        frame = outer.union(mirror(outer)).union(bridge)
        lenses = [lens, mirror(lens)]
    }
    func encodedColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> CGColor {
        CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [r/255, g/255, b/255, 1])!
    }
    func drawFrame(_ ctx: CGContext, white: Bool) {
        ctx.setFillColor(white ? encodedColor(255, 255, 255) : encodedColor(38, 18, 10))
        ctx.addPath(frame); ctx.fillPath()
    }
    func drawLenses(_ ctx: CGContext) {
        for lens in lenses {
            ctx.saveGState(); ctx.addPath(lens); ctx.clip()
            gradient(ctx, [encodedColor(0, 0, 0), encodedColor(46, 47, 47)], CGPoint(x: 0, y: 10), CGPoint(x: 0, y: 54))
            ctx.restoreGState()
        }
    }
    func smooth(_ scale: Int, _ draw: (CGContext) -> Void) -> Data {
        // Supersample the curves so thin rims remain continuous even at 1x.
        let high = NSBitmapImageRep(data: render(12, draw))!.cgImage!
        let result = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 142 * scale, pixelsHigh: 54 * scale, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        let ctx = NSGraphicsContext(bitmapImageRep: result)!.cgContext
        ctx.interpolationQuality = .high
        ctx.draw(high, in: CGRect(x: 0, y: 0, width: 142 * scale, height: 54 * scale))
        return result.representation(using: .png, properties: [:])!
    }
    func saveData(_ name: String, _ images: [Int: Data]) throws {
        let dir = catalog.appendingPathComponent(name + ".imageset")
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        var entries = [[String: String]]()
        for scale in images.keys.sorted() {
            let filename = name + (scale == 1 ? "" : "@\(scale)x") + ".png"
            try images[scale]!.write(to: dir.appendingPathComponent(filename))
            entries.append(["filename": filename, "idiom": "universal", "scale": "\(scale)x"])
        }
        let metadata: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
        try (JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted, .sortedKeys]) + Data([10])).write(to: dir.appendingPathComponent("Contents.json"))
    }
    var models = [Int: Data]()
    for scale in 1...3 { models[scale] = smooth(scale) { drawFrame($0, white: false); drawLenses($0) } }
    let frameData = smooth(3) { drawFrame($0, white: true) }
    let detailData = smooth(3, drawLenses)
    try saveData(name, models)
    try saveData("GlassesFrame" + suffix, [3: frameData])
    try saveData("GlassesDetails" + suffix, [3: detailData])
    if let android {
        let dest = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
        try FileManager.default.createDirectory(at: dest, withIntermediateDirectories: true)
        try models[3]!.write(to: dest.appendingPathComponent(androidNames[id - 1] + ".png"))
        try frameData.write(to: dest.appendingPathComponent("glasses_frame_" + suffix + ".png"))
        try detailData.write(to: dest.appendingPathComponent("glasses_details_" + suffix + ".png"))
        let fallback = android.appendingPathComponent("app/src/main/res/drawable/" + androidNames[id - 1] + ".png")
        if FileManager.default.fileExists(atPath: fallback.path) { try models[1]!.write(to: fallback) }
    }
}

for id in 1...20 {
    if id == 16 || id == 17 {
        try exportSmoothOriginal(id)
        print("Smoothed original \(id): \(names[id - 1])")
        continue
    }
    if [18, 19, 20].contains(id) {
        // Preserve every original iOS scale and copy the 3x artwork unchanged.
        if let android {
            let name = names[id - 1]
            let original = catalog.appendingPathComponent(name + ".imageset/" + name + "@3x.png")
            let dest = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi")
            try FileManager.default.createDirectory(at: dest, withIntermediateDirectories: true)
            try Data(contentsOf: original).write(to: dest.appendingPathComponent(androidNames[id - 1] + ".png"))
        }
        print("Preserved original \(id): \(names[id - 1]) (fixed color)")
        continue
    }
    if id == 11 {
        try exportOriginalBridge()
        print("Preserved original \(id): \(names[id - 1]) (bridge tint only)")
        continue
    }
    if id == 5 || id == 6 {
        try exportOriginalShades(id)
        print("Preserved original \(id): \(names[id - 1])")
        continue
    }
    if id == 2 || id == 3 || id == 10 {
        try exportOriginalFrame(id)
        print("Preserved original \(id): \(names[id - 1])")
        continue
    }
    let s = style(id); let suffix = String(format: "%02d", id)
    try save(names[id - 1], [1, 2, 3]) { ctx in drawFrame(ctx, s, color(defaultColors[id - 1])); drawDetails(ctx, s) }
    try save("GlassesFrame" + suffix, [3]) { drawFrame($0, s, color(0xFFFFFF)) }
    try save("GlassesDetails" + suffix, [3]) { drawDetails($0, s) }
    if let android {
        let dest = android.appendingPathComponent("app/src/main/res/drawable-xxhdpi"); try FileManager.default.createDirectory(at: dest, withIntermediateDirectories: true)
        try render(3) { ctx in drawFrame(ctx, s, color(defaultColors[id - 1])); drawDetails(ctx, s) }.write(to: dest.appendingPathComponent(androidNames[id - 1] + ".png"))
        try render(3) { drawFrame($0, s, color(0xFFFFFF)) }.write(to: dest.appendingPathComponent("glasses_frame_" + suffix + ".png"))
        try render(3) { drawDetails($0, s) }.write(to: dest.appendingPathComponent("glasses_details_" + suffix + ".png"))
        let fallback = android.appendingPathComponent("app/src/main/res/drawable/" + androidNames[id - 1] + ".png")
        if FileManager.default.fileExists(atPath: fallback.path) { try render(1) { ctx in drawFrame(ctx, s, color(defaultColors[id - 1])); drawDetails(ctx, s) }.write(to: fallback) }
    }
    print("Exported \(id): \(names[id - 1])")
}
