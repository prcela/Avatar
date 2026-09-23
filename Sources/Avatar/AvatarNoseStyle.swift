import UIKit

/// Skin-independent highlights and shadows on the original 56 x 36 nose canvas.
/// Keep geometry and opacity in sync with AvatarNoseStyle.kt.
enum AvatarNoseStyle {
    private static let cache = NSCache<NSNumber, UIImage>()

    static func image(for nose: Avatar.Nose) -> UIImage {
        let key = NSNumber(value: nose.rawValue)
        if let image = cache.object(forKey: key) { return image }
        let format = UIGraphicsImageRendererFormat()
        format.scale = 3
        let image = UIGraphicsImageRenderer(size: CGSize(width: 56, height: 36), format: format).image {
            draw(nose, in: $0.cgContext)
        }.withRenderingMode(.alwaysOriginal)
        cache.setObject(image, forKey: key)
        return image
    }

    static func draw(_ nose: Avatar.Nose, in context: CGContext) {
        context.saveGState()
        let path = CGMutablePath()
        switch nose {
        case .Normal:
            path.move(to: CGPoint(x: 16, y: 20))
            path.addLine(to: CGPoint(x: 40, y: 20))
            path.addCurve(to: CGPoint(x: 28, y: 28),
                          control1: CGPoint(x: 39, y: 25), control2: CGPoint(x: 34, y: 28))
            path.addCurve(to: CGPoint(x: 16, y: 20),
                          control1: CGPoint(x: 22, y: 28), control2: CGPoint(x: 17, y: 25))
            path.closeSubpath()
            context.addPath(path)
            context.clip()
            shade(in: context, from: 20, to: 28, top: 0.025, bottom: 0.19)
            light(in: context, x: 26.5, y: 21, rx: 10, ry: 3.5, white: true, alpha: 0.17)
        case .Mini:
            path.move(to: CGPoint(x: 15, y: 20))
            path.addCurve(to: CGPoint(x: 28, y: 28),
                          control1: CGPoint(x: 16, y: 25.5), control2: CGPoint(x: 21, y: 28))
            path.addCurve(to: CGPoint(x: 41, y: 20),
                          control1: CGPoint(x: 35, y: 28), control2: CGPoint(x: 40, y: 25.5))
            light(in: context, x: 28, y: 27.5, rx: 12, ry: 2.5, white: false, alpha: 0.075)
            light(in: context, x: 26.5, y: 23, rx: 10, ry: 5, white: true, alpha: 0.14)
            outline(path, in: context, width: 1.5, from: 19, to: 29)
        case .Big:
            path.move(to: CGPoint(x: 18, y: 10))
            path.addCurve(to: CGPoint(x: 16, y: 26),
                          control1: CGPoint(x: 17, y: 15), control2: CGPoint(x: 15, y: 21))
            path.addCurve(to: CGPoint(x: 28, y: 32),
                          control1: CGPoint(x: 16, y: 30.5), control2: CGPoint(x: 20, y: 32))
            path.addCurve(to: CGPoint(x: 40, y: 26),
                          control1: CGPoint(x: 36, y: 32), control2: CGPoint(x: 40, y: 30.5))
            path.addCurve(to: CGPoint(x: 38, y: 10),
                          control1: CGPoint(x: 41, y: 21), control2: CGPoint(x: 39, y: 15))
            light(in: context, x: 28, y: 31, rx: 12, ry: 3, white: false, alpha: 0.09)
            light(in: context, x: 25, y: 23, rx: 10, ry: 10, white: true, alpha: 0.15)
            outline(path, in: context, width: 1.65, from: 9, to: 33)
        case .Left:
            path.move(to: CGPoint(x: 27, y: 5))
            path.addCurve(to: CGPoint(x: 20, y: 20),
                          control1: CGPoint(x: 26.5, y: 10), control2: CGPoint(x: 23, y: 16))
            path.addCurve(to: CGPoint(x: 14, y: 28),
                          control1: CGPoint(x: 17, y: 24), control2: CGPoint(x: 13, y: 26))
            path.addCurve(to: CGPoint(x: 28, y: 32),
                          control1: CGPoint(x: 15, y: 31), control2: CGPoint(x: 22, y: 32))
            light(in: context, x: 22, y: 30.5, rx: 8, ry: 3, white: false, alpha: 0.07)
            light(in: context, x: 22, y: 25, rx: 6.5, ry: 6, white: true, alpha: 0.15)
            outline(path, in: context, width: 1.65, from: 4, to: 33)
        case .Round:
            path.move(to: CGPoint(x: 22, y: 14))
            path.addCurve(to: CGPoint(x: 15, y: 21),
                          control1: CGPoint(x: 18, y: 14), control2: CGPoint(x: 15, y: 16.5))
            path.addCurve(to: CGPoint(x: 28, y: 29),
                          control1: CGPoint(x: 15, y: 26.5), control2: CGPoint(x: 20, y: 29))
            path.addCurve(to: CGPoint(x: 41, y: 21),
                          control1: CGPoint(x: 36, y: 29), control2: CGPoint(x: 41, y: 26.5))
            path.addCurve(to: CGPoint(x: 34, y: 14),
                          control1: CGPoint(x: 41, y: 16.5), control2: CGPoint(x: 38, y: 14))
            light(in: context, x: 28, y: 27, rx: 12, ry: 3.5, white: false, alpha: 0.07)
            light(in: context, x: 25.5, y: 19.5, rx: 10, ry: 6.5, white: true, alpha: 0.17)
            outline(path, in: context, width: 1.5, from: 13, to: 30)
        }
        context.restoreGState()
    }

    private static func outline(_ path: CGPath, in context: CGContext, width: CGFloat,
                                from: CGFloat, to: CGFloat) {
        context.saveGState()
        context.addPath(path.copy(strokingWithWidth: width, lineCap: .round, lineJoin: .round, miterLimit: 2))
        context.clip()
        shade(in: context, from: from, to: to, top: 0.08, bottom: 0.25)
        context.restoreGState()
    }

    private static func shade(in context: CGContext, from: CGFloat, to: CGFloat,
                              top: CGFloat, bottom: CGFloat) {
        let colors = [top, bottom].map { CGColor(gray: 0, alpha: $0) }
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceGray(), colors: colors as CFArray,
                                  locations: [0, 1])!
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: from), end: CGPoint(x: 0, y: to),
                                   options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }

    private static func light(in context: CGContext, x: CGFloat, y: CGFloat, rx: CGFloat, ry: CGFloat,
                              white: Bool, alpha: CGFloat) {
        context.saveGState()
        context.translateBy(x: x, y: y)
        context.scaleBy(x: rx, y: ry)
        let colors = [alpha, alpha * 0.5, 0].map { CGColor(gray: white ? 1 : 0, alpha: $0) }
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceGray(), colors: colors as CFArray,
                                  locations: [0, 0.45, 1])!
        context.drawRadialGradient(gradient, startCenter: .zero, startRadius: 0,
                                   endCenter: .zero, endRadius: 1, options: [])
        context.restoreGState()
    }
}
