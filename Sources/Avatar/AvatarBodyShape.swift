import UIKit

/// Local contours on the existing 200 x 244 body canvas. The overall width is
/// still applied by the view so clothing, hair and accessories keep their fit.
struct AvatarBodyShape {
    let neckHalfWidth: CGFloat
    let jawHalfWidth: CGFloat
    let cheekControlX: CGFloat
    let chinY: CGFloat
    let shoulderControlY: CGFloat
    let shadowDepth: CGFloat

    init?(bodyType: Avatar.BodyType) {
        switch bodyType {
        case .normal:
            return nil
        case .slim:
            (neckHalfWidth, jawHalfWidth, cheekControlX, chinY, shoulderControlY, shadowDepth) = (22, 25, 140, 151, 172, 7)
        case .verySlim:
            (neckHalfWidth, jawHalfWidth, cheekControlX, chinY, shoulderControlY, shadowDepth) = (20, 22, 135, 152, 179, 6)
        case .broad:
            (neckHalfWidth, jawHalfWidth, cheekControlX, chinY, shoulderControlY, shadowDepth) = (27, 32, 152, 151, 165, 9)
        case .veryBroad:
            (neckHalfWidth, jawHalfWidth, cheekControlX, chinY, shoulderControlY, shadowDepth) = (30, 35, 158, 153, 163, 10)
        }
    }

    var lowerFacePath: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 44, y: 94))
        path.addLine(to: CGPoint(x: 156, y: 94))
        path.addCurve(to: CGPoint(x: 100 + jawHalfWidth, y: chinY - 8),
                      control1: CGPoint(x: 156, y: 112), control2: CGPoint(x: cheekControlX, y: 132))
        path.addCurve(to: CGPoint(x: 100, y: chinY),
                      control1: CGPoint(x: 100 + jawHalfWidth * 0.6, y: chinY),
                      control2: CGPoint(x: 100 + jawHalfWidth * 0.3, y: chinY))
        path.addCurve(to: CGPoint(x: 100 - jawHalfWidth, y: chinY - 8),
                      control1: CGPoint(x: 100 - jawHalfWidth * 0.3, y: chinY),
                      control2: CGPoint(x: 100 - jawHalfWidth * 0.6, y: chinY))
        path.addCurve(to: CGPoint(x: 44, y: 94),
                      control1: CGPoint(x: 200 - cheekControlX, y: 132), control2: CGPoint(x: 44, y: 112))
        path.closeSubpath()
        return path
    }

    var torsoPath: CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 100 - neckHalfWidth, y: 130))
        path.addLine(to: CGPoint(x: 100 + neckHalfWidth, y: 130))
        path.addLine(to: CGPoint(x: 100 + neckHalfWidth, y: 159))
        path.addQuadCurve(to: CGPoint(x: 104 + neckHalfWidth, y: 163),
                          control: CGPoint(x: 100 + neckHalfWidth, y: 163))
        path.addCurve(to: CGPoint(x: 200, y: 235),
                      control1: CGPoint(x: 166, y: shoulderControlY), control2: CGPoint(x: 200, y: 195))
        path.addLine(to: CGPoint(x: 200, y: 244))
        path.addLine(to: CGPoint(x: 0, y: 244))
        path.addLine(to: CGPoint(x: 0, y: 235))
        path.addCurve(to: CGPoint(x: 96 - neckHalfWidth, y: 163),
                      control1: CGPoint(x: 0, y: 195), control2: CGPoint(x: 34, y: shoulderControlY))
        path.addQuadCurve(to: CGPoint(x: 100 - neckHalfWidth, y: 159),
                          control: CGPoint(x: 100 - neckHalfWidth, y: 163))
        path.closeSubpath()
        return path
    }

    var shadowPath: CGPath {
        let path = CGMutablePath()
        path.addPath(lowerFacePath)
        path.addPath(lowerFacePath, transform: CGAffineTransform(translationX: 0, y: shadowDepth))
        return path
    }
}

extension AvatarBodyShape {
    final class Images {
        let body: UIImage
        let shadow: UIImage

        init(shape: AvatarBodyShape, originalBody: UIImage) {
            body = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 244)).image { renderer in
                let context = renderer.cgContext
                context.setFillColor(UIColor.white.cgColor)
                context.addPath(shape.torsoPath)
                context.addPath(shape.lowerFacePath)
                context.fillPath()
                // Preserve the scalp, temples and ears used to position existing hair/headwear.
                context.clip(to: CGRect(x: 0, y: 0, width: 200, height: 100))
                originalBody.draw(in: CGRect(x: 0, y: 0, width: 200, height: 244))
            }.withRenderingMode(.alwaysTemplate)
            shadow = UIGraphicsImageRenderer(size: CGSize(width: 112, height: 79)).image { renderer in
                let context = renderer.cgContext
                // Body frame (32, 36) relative to the neck shadow frame (76, 122).
                context.translateBy(x: -44, y: -86)
                context.addPath(shape.torsoPath)
                context.clip()
                context.addPath(shape.shadowPath)
                context.setFillColor(UIColor.black.withAlphaComponent(0.1).cgColor)
                context.drawPath(using: .eoFill)
            }.withRenderingMode(.alwaysOriginal)
        }
    }

    private static let imageCache = NSCache<NSNumber, Images>()

    static func images(for bodyType: Avatar.BodyType) -> Images? {
        guard let shape = AvatarBodyShape(bodyType: bodyType) else { return nil }
        let key = NSNumber(value: bodyType.rawValue)
        if let images = imageCache.object(forKey: key) { return images }
        guard let originalBody = UIImage(named: "Body", in: .module, compatibleWith: nil) else { return nil }
        let images = Images(shape: shape, originalBody: originalBody)
        imageCache.setObject(images, forKey: key)
        return images
    }
}
