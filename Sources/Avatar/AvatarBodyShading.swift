import CoreGraphics

/// Soft lighting in the unchanged 200 x 244 body coordinates. Source-atop
/// preserves every alpha value, including antialiased edges of the silhouette.
enum AvatarBodyShading {
    private struct Light {
        let center: CGPoint
        let radius: CGSize
        let gradient: CGGradient

        init(_ x: CGFloat, _ y: CGFloat, _ rx: CGFloat, _ ry: CGFloat,
             white: Bool, opacity: CGFloat) {
            center = CGPoint(x: x, y: y)
            radius = CGSize(width: rx, height: ry)
            let value: CGFloat = white ? 1 : 0
            let space = CGColorSpaceCreateDeviceRGB()
            let colors = [opacity, opacity * 0.55, 0].map {
                CGColor(colorSpace: space, components: [value, value, value, $0])!
            }
            gradient = CGGradient(colorsSpace: space, colors: colors as CFArray,
                                  locations: [0, 0.45, 1])!
        }
    }

    // Keep these lights in sync with AvatarBodyShading.kt on Android.
    private static let lights = [
        Light(83, 45, 64, 85, white: true, opacity: 0.16),
        Light(152, 81, 24, 68, white: false, opacity: 0.15),
        Light(46, 89, 20, 61, white: false, opacity: 0.07),
        Light(80, 102, 26, 27, white: true, opacity: 0.07),
        // The separate neck-shadow image already provides depth below the chin.
        Light(106, 149, 56, 18, white: false, opacity: 0.05),
        Light(44, 188, 39, 35, white: true, opacity: 0.14),
        Light(157, 192, 40, 38, white: true, opacity: 0.08),
        Light(91, 215, 62, 52, white: true, opacity: 0.09),
        Light(0, 222, 35, 58, white: false, opacity: 0.12),
        Light(203, 221, 44, 63, white: false, opacity: 0.18)
    ]

    static func draw(in context: CGContext) {
        context.saveGState()
        context.setBlendMode(.sourceAtop)
        for light in lights {
            context.saveGState()
            context.translateBy(x: light.center.x, y: light.center.y)
            context.scaleBy(x: light.radius.width, y: light.radius.height)
            context.drawRadialGradient(light.gradient, startCenter: .zero, startRadius: 0,
                                       endCenter: .zero, endRadius: 1, options: [])
            context.restoreGState()
        }
        context.restoreGState()
    }
}
