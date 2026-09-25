// SPDX-License-Identifier: MPL-2.0

// Run from the package root: swift Scripts/generate-hairstyles.swift
// Vector artwork in the avatar's 264 x 280 point coordinates, exported as tintable masks.
import AppKit

final class Outline {
    let path = CGMutablePath()
    func m(_ x: CGFloat, _ y: CGFloat) { path.move(to: CGPoint(x: x, y: y)) }
    func l(_ x: CGFloat, _ y: CGFloat) { path.addLine(to: CGPoint(x: x, y: y)) }
    func q(_ cx: CGFloat, _ cy: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: cx, y: cy))
    }
    func c(_ x1: CGFloat, _ y1: CGFloat, _ x2: CGFloat, _ y2: CGFloat, _ x: CGFloat, _ y: CGFloat) {
        path.addCurve(to: CGPoint(x: x, y: y), control1: CGPoint(x: x1, y: y1), control2: CGPoint(x: x2, y: y2))
    }
    func close() { path.closeSubpath() }
}

func shape(_ draw: (Outline) -> Void) -> CGPath {
    let outline = Outline()
    draw(outline)
    return outline.path
}

func fill(_ context: CGContext, _ path: CGPath, alpha: CGFloat = 1) {
    context.setFillColor(CGColor(gray: 0, alpha: alpha))
    context.addPath(path)
    context.fillPath()
}

func details(_ context: CGContext, _ path: CGPath, alpha: CGFloat = 0.15, width: CGFloat = 1.1) {
    context.saveGState()
    context.setBlendMode(.destinationOut)
    context.setStrokeColor(CGColor(gray: 0, alpha: alpha))
    context.setLineWidth(width)
    context.setLineCap(.round)
    context.setLineJoin(.round)
    context.addPath(path)
    context.strokePath()
    context.restoreGState()
}

let slickCap = shape { p in
    p.m(76, 102)
    p.c(67, 51, 84, 24, 132, 22)
    p.c(180, 24, 197, 51, 188, 102)
    p.q(182, 101, 179, 82)
    p.c(173, 68, 150, 60, 132, 57)
    p.c(114, 60, 91, 68, 85, 82)
    p.q(82, 101, 76, 102)
    p.close()
}

let shavedSides = shape { p in
    p.m(76, 101)
    p.l(76, 92)
    p.c(76, 61, 101, 36, 132, 36)
    p.c(163, 36, 188, 61, 188, 92)
    p.l(188, 101)
    p.l(183, 95)
    p.c(184, 73, 170, 51, 151, 46)
    p.q(132, 40, 113, 46)
    p.c(94, 51, 80, 73, 81, 95)
    p.close()
}

func mohawk(_ context: CGContext) {
    fill(context, shavedSides, alpha: 0.22)
    context.saveGState()
    defer { context.restoreGState() }
    // Raise the base by 10% of the crest's height without clipping its highest tip.
    context.translateBy(x: 0, y: 3)
    context.scaleBy(x: 1, y: 0.9)
    context.translateBy(x: 0, y: -3)
    let crest = shape { p in
        p.m(113, 70)
        p.c(106, 53, 105, 33, 110, 19)
        p.l(117, 28)
        p.q(117, 15, 123, 6)
        p.l(130, 20)
        p.q(132, 9, 139, 3)
        p.l(145, 23)
        p.l(154, 13)
        p.q(157, 27, 154, 39)
        p.l(161, 33)
        p.c(162, 48, 158, 62, 150, 70)
        p.q(132, 64, 113, 70)
        p.close()
    }
    fill(context, crest)
    details(context, shape { p in
        p.m(126, 61); p.q(119, 44, 123, 23)
        p.m(140, 59); p.q(146, 45, 145, 32)
    }, alpha: 0.12)
}

func pompadour(_ context: CGContext) {
    fill(context, shavedSides, alpha: 0.3)
    let swept = shape { p in
        p.m(76, 102)
        p.c(69, 82, 70, 53, 84, 42)
        p.c(78, 34, 88, 22, 104, 18)
        p.c(128, 9, 149, 14, 169, 17)
        p.c(184, 19, 196, 10, 201, 13)
        p.c(213, 27, 205, 45, 191, 55)
        p.c(192, 73, 189, 92, 183, 102)
        p.l(179, 80)
        p.c(177, 67, 167, 60, 154, 61)
        p.c(128, 64, 104, 48, 85, 64)
        p.q(79, 82, 76, 102)
        p.close()
    }
    fill(context, swept)
    details(context, shape { p in
        p.m(88, 46); p.c(113, 29, 165, 51, 196, 25)
        p.m(91, 36); p.c(118, 17, 150, 35, 183, 25)
        p.m(90, 54); p.c(120, 42, 158, 62, 185, 47)
    })
}

func curtainPart(_ context: CGContext) {
    context.saveGState()
    defer { context.restoreGState() }
    // Enlarge around the parting so it remains aligned with the top of the head.
    context.translateBy(x: 132, y: 37)
    context.scaleBy(x: 1.15, y: 1.15)
    context.translateBy(x: -132, y: -37)
    let curtains = shape { p in
        p.m(74, 105)
        p.c(68, 81, 67, 42, 87, 29)
        p.c(103, 18, 120, 20, 132, 28)
        p.c(144, 20, 161, 18, 177, 29)
        p.c(197, 42, 196, 81, 190, 105)
        p.c(181, 106, 176, 95, 174, 85)
        p.c(171, 73, 154, 66, 144, 54)
        p.q(137, 45, 132, 37)
        p.q(127, 45, 120, 54)
        p.c(110, 66, 93, 73, 90, 85)
        p.c(88, 95, 83, 106, 74, 105)
        p.close()
    }
    fill(context, curtains)
    details(context, shape { p in
        p.m(124, 29); p.c(98, 25, 77, 47, 80, 85)
        p.m(120, 38); p.c(107, 39, 91, 52, 86, 72)
        p.m(140, 29); p.c(166, 25, 187, 47, 184, 85)
        p.m(144, 38); p.c(157, 39, 173, 52, 178, 72)
    })
}

func highPonytail(_ context: CGContext) {
    let tail = shape { p in
        p.m(143, 28)
        p.c(135, 12, 146, 1, 160, 3)
        p.c(187, 7, 208, 31, 217, 61)
        p.c(232, 108, 215, 150, 201, 185)
        p.c(196, 196, 193, 205, 196, 216)
        p.c(179, 205, 179, 186, 182, 168)
        p.c(185, 150, 193, 132, 195, 111)
        p.c(199, 76, 181, 48, 162, 40)
        p.close()
    }
    fill(context, tail)
    details(context, shape { p in
        p.m(165, 14); p.c(207, 43, 220, 94, 204, 141)
        p.m(175, 34); p.c(215, 78, 199, 145, 188, 187)
    })
    fill(context, slickCap)
    details(context, shape { p in
        p.m(84, 64); p.c(101, 42, 129, 35, 151, 29)
        p.m(91, 47); p.q(119, 28, 148, 26)
        p.m(177, 66); p.q(172, 47, 156, 32)
    })
    details(context, shape { p in
        p.m(146, 23); p.q(153, 22, 160, 27)
    }, alpha: 0.5, width: 2)
}

func spaceBuns(_ context: CGContext) {
    let bun = shape { p in
        p.m(65, 24)
        p.c(61, 11, 71, 3, 84, 5)
        p.c(96, 2, 107, 13, 104, 26)
        p.c(104, 39, 92, 45, 78, 41)
        p.c(69, 39, 63, 32, 65, 24)
        p.close()
    }
    let twist = shape { p in
        p.m(72, 20)
        p.c(73, 10, 93, 12, 97, 21)
        p.c(101, 31, 85, 38, 77, 31)
        p.c(72, 26, 82, 19, 89, 22)
    }
    for mirrored in [false, true] {
        context.saveGState()
        if mirrored {
            context.translateBy(x: 264, y: 0)
            context.scaleBy(x: -1, y: 1)
        }
        fill(context, bun)
        details(context, twist, alpha: 0.23)
        context.restoreGState()
    }
    fill(context, slickCap)
    details(context, shape { p in
        p.m(132, 25); p.q(129, 39, 132, 52)
    }, alpha: 0.35, width: 1.4)
    details(context, shape { p in
        p.m(121, 33); p.q(97, 38, 83, 63)
        p.m(118, 44); p.q(96, 53, 87, 67)
        p.m(143, 33); p.q(167, 38, 181, 63)
        p.m(146, 44); p.q(168, 53, 177, 67)
    })
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    .appendingPathComponent("Sources/Avatar/Avatar.xcassets")
let styles: [(String, String, (CGContext) -> Void)] = [
    ("Mohawk", "Short Hair", mohawk),
    ("Pompadour", "Short Hair", pompadour),
    ("CurtainPart", "Short Hair", curtainPart),
    ("HighPonytail", "Long Hair", highPonytail),
    ("SpaceBuns", "Long Hair", spaceBuns)
]
for (name, category, draw) in styles {
    let directory = root.appendingPathComponent(category).appendingPathComponent(name + ".imageset")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    var entries = [[String: String]]()
    for scale in 1...3 {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: 264 * scale, pixelsHigh: 280 * scale,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        let context = NSGraphicsContext(bitmapImageRep: bitmap)!.cgContext
        context.clear(CGRect(x: 0, y: 0, width: 264 * scale, height: 280 * scale))
        context.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
        context.translateBy(x: 0, y: 280)
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
    print("Exported \(name), 264 x 280 points, 1x/2x/3x template.")
}
