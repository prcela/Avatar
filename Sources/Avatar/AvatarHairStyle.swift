import UIKit

/// Placement of the shaded hair sprites on the 266 x 280 canvas.
/// Keep these values in sync with AvatarHairStyle.kt on Android.
struct AvatarHairStyle {
    let scaleX: CGFloat
    let scaleY: CGFloat
    let offsetX: CGFloat
    let offsetY: CGFloat

    static func placement(for hair: Avatar.Hair) -> AvatarHairStyle? {
        placements[hair]
    }

    private static let placements: [Avatar.Hair: AvatarHairStyle] = [
        .Dreads1: .init(scaleX: 0.781, scaleY: 0.726, offsetX: -0.458, offsetY: 5.692),
        .Dreads2: .init(scaleX: 0.821, scaleY: 0.817, offsetX: -3.667, offsetY: -0.272),
        .Frizzle: .init(scaleX: 0.8, scaleY: 0.682, offsetX: 0.267, offsetY: 0.352),
        .ShaggyMullet: .init(scaleX: 1.002, scaleY: 1.01, offsetX: -2.149, offsetY: 2.116),
        .Shaggy: .init(scaleX: 0.963, scaleY: 0.846, offsetX: 5.526, offsetY: 7.205),
        .ShortCurly: .init(scaleX: 0.811, scaleY: 0.817, offsetX: -0.447, offsetY: -2.988),
        .ShortFlat: .init(scaleX: 0.884, scaleY: 0.884, offsetX: -0.795, offsetY: -5.101),
        .ShortRound: .init(scaleX: 0.889, scaleY: 0.72, offsetX: -0.741, offsetY: 9.68),
        .ShortWaved: .init(scaleX: 0.83, scaleY: 0.825, offsetX: -2.403, offsetY: -7.317),
        .Sides: .init(scaleX: 0.861, scaleY: 0.512, offsetX: -0.143, offsetY: 35.585),
        .CeasarSide: .init(scaleX: 0.88, scaleY: 0.733, offsetX: 0.0, offsetY: 13.992),
        .Ceasar: .init(scaleX: 0.901, scaleY: 0.698, offsetX: 1.202, offsetY: 11.96),
        .Bun: .init(scaleX: 0.859, scaleY: 0.697, offsetX: 0.573, offsetY: -11.147),
        .Curvy: .init(scaleX: 1.079, scaleY: 1.093, offsetX: 0.5, offsetY: -3.67),
        .Dreads: .init(scaleX: 1.042, scaleY: 1.061, offsetX: 1.291, offsetY: -1.203),
        .Frida: .init(scaleX: 0.86, scaleY: 0.84, offsetX: -1.143, offsetY: -11.755),
        .ShavedSides: .init(scaleX: 1.044, scaleY: 1.031, offsetX: 3.342, offsetY: 0.061),
        .Straight: .init(scaleX: 1.047, scaleY: 1.101, offsetX: 0.297, offsetY: -13.623),
        .StraightStrand: .init(scaleX: 0.902, scaleY: 0.915, offsetX: 2.855, offsetY: 5.494),
        .LStraight: .init(scaleX: 1.035, scaleY: 1.042, offsetX: 0.69, offsetY: -4.922),
        .MiaWallace: .init(scaleX: 0.983, scaleY: 1.043, offsetX: 0.0, offsetY: -7.783),
        .LongButNotTooLong: .init(scaleX: 0.984, scaleY: 1.006, offsetX: -2.696, offsetY: -1.782),
        .Fro: .init(scaleX: 0.938, scaleY: 0.871, offsetX: -0.625, offsetY: -4.644),
        .Curly: .init(scaleX: 1.004, scaleY: 1.08, offsetX: -2.846, offsetY: -8.72),
        .Bob: .init(scaleX: 1.043, scaleY: 1.059, offsetX: 1.738, offsetY: -4.0),
        .Big: .init(scaleX: 1.033, scaleY: 1.072, offsetX: -0.5, offsetY: -7.731),
        .ShortRoundFriz: .init(scaleX: 0.862, scaleY: 0.704, offsetX: -1.603, offsetY: 1.714),
        .StraightLeft: .init(scaleX: 0.896, scaleY: 0.914, offsetX: -3.396, offsetY: -2.667),
        .BuzzCut: .init(scaleX: 0.924, scaleY: 0.734, offsetX: 0.167, offsetY: 9.057),
        .Bieber: .init(scaleX: 1.012, scaleY: 0.873, offsetX: -2.825, offsetY: 4.34),
        .MessyFringe: .init(scaleX: 0.998, scaleY: 1.04, offsetX: -2.497, offsetY: -2.05),
        .LongWavy: .init(scaleX: 0.918, scaleY: 0.967, offsetX: -0.612, offsetY: -3.306),
        .GlamWaves: .init(scaleX: 1.029, scaleY: 1.016, offsetX: -2.971, offsetY: -7.01),
        .SleekBob: .init(scaleX: 1.015, scaleY: 0.984, offsetX: 0.992, offsetY: 1.603),
        .WavyBob: .init(scaleX: 0.978, scaleY: 1.136, offsetX: 1.696, offsetY: -9.309),
        .TexturedCrop: .init(scaleX: 0.977, scaleY: 0.969, offsetX: -0.886, offsetY: -4.447),
        .SideSweep: .init(scaleX: 0.991, scaleY: 0.964, offsetX: 0.658, offsetY: -2.492),
        .Spiky: .init(scaleX: 0.996, scaleY: 0.936, offsetX: 0.0, offsetY: -4.111),
        .Mohawk: .init(scaleX: 0.732, scaleY: 0.662, offsetX: 0.659, offsetY: 0.363),
        .Pompadour: .init(scaleX: 0.869, scaleY: 0.81, offsetX: 0.814, offsetY: -0.363),
        .CurtainPart: .init(scaleX: 0.887, scaleY: 0.835, offsetX: -0.591, offsetY: 1.46),
        .LowFade: .init(scaleX: 0.813, scaleY: 0.903, offsetX: -0.573, offsetY: 7.551),
        .FlatTop: .init(scaleX: 0.88, scaleY: 0.901, offsetX: -0.147, offsetY: -2.292),
        .TwinBraids: .init(scaleX: 0.934, scaleY: 0.821, offsetX: 0.0, offsetY: -3.393),
        .LongStraightBangs: .init(scaleX: 1, scaleY: 1, offsetX: 0, offsetY: -4),
        .Einstein: .init(scaleX: 0.9, scaleY: 0.9, offsetX: 0, offsetY: 2)
    ]

    /// Protect the face after placement, leaving side lengths in front of clothing.
    /// The full sprite is also drawn behind the skin to close gaps at the temples.
    func frontMask(for bodyType: Avatar.BodyType, bounds: CGRect) -> CGPath {
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: 266, height: 280))
        // Body origin is (33, 36) within the hair image; undo the hair placement.
        let inverse = CGAffineTransform(a: 1 / scaleX, b: 0, c: 0, d: 1 / scaleY,
            tx: (33 - 133 * (1 - scaleX) - offsetX) / scaleX,
            ty: (36 - offsetY) / scaleY)
        path.addPath(Self.protectedFace(bodyType), transform: inverse)
        var sizeTransform = CGAffineTransform(scaleX: bounds.width / 266, y: bounds.height / 280)
        return path.copy(using: &sizeTransform) ?? path
    }

    private static func protectedFace(_ bodyType: Avatar.BodyType) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 44, y: 94))
        path.addLine(to: CGPoint(x: 44, y: 80))
        path.addQuadCurve(to: CGPoint(x: 60, y: 64), control: CGPoint(x: 44, y: 64))
        path.addLine(to: CGPoint(x: 140, y: 64))
        path.addQuadCurve(to: CGPoint(x: 156, y: 80), control: CGPoint(x: 156, y: 64))
        path.addLine(to: CGPoint(x: 156, y: 94))
        if let shape = AvatarBodyShape(bodyType: bodyType) {
            let jaw = shape.jawHalfWidth, chin = shape.chinY, cheek = shape.cheekControlX
            path.addCurve(to: CGPoint(x: 100 + jaw, y: chin - 8),
                          control1: CGPoint(x: 156, y: 112), control2: CGPoint(x: cheek, y: 132))
            path.addCurve(to: CGPoint(x: 100, y: chin),
                          control1: CGPoint(x: 100 + jaw * 0.6, y: chin), control2: CGPoint(x: 100 + jaw * 0.3, y: chin))
            path.addCurve(to: CGPoint(x: 100 - jaw, y: chin - 8),
                          control1: CGPoint(x: 100 - jaw * 0.3, y: chin), control2: CGPoint(x: 100 - jaw * 0.6, y: chin))
            path.addCurve(to: CGPoint(x: 44, y: 94),
                          control1: CGPoint(x: 200 - cheek, y: 132), control2: CGPoint(x: 44, y: 112))
        } else {
            path.addCurve(to: CGPoint(x: 100, y: 150),
                          control1: CGPoint(x: 156, y: 124.928), control2: CGPoint(x: 130.928, y: 150))
            path.addCurve(to: CGPoint(x: 44, y: 94),
                          control1: CGPoint(x: 69.072, y: 150), control2: CGPoint(x: 44, y: 124.928))
        }
        path.closeSubpath()
        return path
    }
}
