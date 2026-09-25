// SPDX-License-Identifier: MPL-2.0

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
            // Overall body scaling already widens the neck; keep it inside clothing collars.
            (neckHalfWidth, jawHalfWidth, cheekControlX, chinY, shoulderControlY, shadowDepth) = (24, 35, 158, 153, 163, 10)
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

    /// Extra face width relative to the original round head, in avatar coordinates.
    func hairCheekOffset(at y: CGFloat) -> CGFloat {
        let localY = y - 36
        guard localY > 100, y < 220 else { return 0 }
        func cubic(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat, _ t: CGFloat) -> CGFloat {
            let u = 1 - t
            return u * u * u * a + 3 * u * u * t * b + 3 * u * t * t * c + t * t * t * d
        }
        var faceWidth: CGFloat = 0
        if localY < chinY {
            let upper = localY < chinY - 8
            let ys: [CGFloat] = upper ? [94, 112, 132, chinY - 8] : [chinY - 8, chinY, chinY, chinY]
            let xs: [CGFloat] = upper ? [56, 56, cheekControlX - 100, jawHalfWidth]
                : [jawHalfWidth, jawHalfWidth * 0.6, jawHalfWidth * 0.3, 0]
            var low: CGFloat = 0
            var high: CGFloat = 1
            for _ in 0..<16 {
                let t = (low + high) / 2
                if cubic(ys[0], ys[1], ys[2], ys[3], t) < localY { low = t } else { high = t }
            }
            faceWidth = cubic(xs[0], xs[1], xs[2], xs[3], (low + high) / 2)
        }
        let originalWidth = max(24, sqrt(max(0, 56 * 56 - (localY - 94) * (localY - 94))))
        let fade = max(0, min(1, (y - 196) / 24))
        return max(0, max(neckHalfWidth, faceWidth) - originalWidth) * (1 - fade * fade * (3 - 2 * fade))
    }

    /// Fit short stubble to the cheek/jaw contour after its existing 1.04 x 1.1 placement.
    func fittedStubbleImage(_ image: CGImage) -> CGImage? {
        let scale = 3, width = 504, height = 456
        let info = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let space = CGColorSpaceCreateDeviceRGB()
        guard let source = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
                                     bytesPerRow: width * 4, space: space, bitmapInfo: info),
              let output = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
                                     bytesPerRow: width * 4, space: space, bitmapInfo: info),
              let sourceData = source.data, let outputData = output.data else { return nil }
        source.interpolationQuality = .high
        source.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        let src = sourceData.assumingMemoryBound(to: UInt8.self)
        let dst = outputData.assumingMemoryBound(to: UInt8.self)
        let center = CGFloat(width) / 2
        let inner = CGFloat(20 * scale), edge = CGFloat(48 * scale)
        for y in 0..<height {
            let placedY = 63.8 + (CGFloat(y) + 0.5) / CGFloat(scale) * 1.1
            let offset = hairCheekOffset(at: placedY) / 1.04 * CGFloat(scale)
            for x in 0..<width {
                let dx = CGFloat(x) + 0.5 - center
                let distance = abs(dx)
                // Keep the mouth opening fixed; spread only the cheek and jaw texture.
                let sample: CGFloat
                if distance <= inner {
                    sample = distance
                } else if distance < edge + offset {
                    sample = inner + (distance - inner) * (edge - inner) / (edge + offset - inner)
                } else {
                    sample = distance - offset
                }
                let sourceX = min(CGFloat(width - 1), max(0, center + (dx < 0 ? -sample : sample) - 0.5))
                let x0 = Int(floor(sourceX)), x1 = min(width - 1, x0 + 1)
                let fraction = sourceX - CGFloat(x0)
                for channel in 0..<4 {
                    let a = CGFloat(src[(y * width + x0) * 4 + channel])
                    let b = CGFloat(src[(y * width + x1) * 4 + channel])
                    dst[(y * width + x) * 4 + channel] = UInt8((a * (1 - fraction) + b * fraction).rounded())
                }
            }
        }
        // Stubble stays on the skin, including the flatter bottom of a broad jaw.
        output.translateBy(x: 0, y: CGFloat(height))
        output.scaleBy(x: CGFloat(scale), y: -CGFloat(scale))
        let outside = CGMutablePath()
        outside.addRect(CGRect(x: 0, y: 0, width: 168, height: 152))
        outside.addRect(CGRect(x: 0, y: 0, width: 168, height: (130 - 63.8) / 1.1))
        outside.addPath(lowerFacePath, transform: CGAffineTransform(a: 1 / 1.04, b: 0, c: 0, d: 1 / 1.1,
            tx: 84 - 100 / 1.04, ty: (36 - 63.8) / 1.1))
        output.setBlendMode(.clear)
        output.addPath(outside)
        output.drawPath(using: .eoFill)
        return output.makeImage()
    }

    func fittedHairImage(_ image: CGImage, clearFace: Bool = false) -> CGImage? {
        let scale = 3
        let width = 266 * scale, height = 280 * scale
        let info = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let space = CGColorSpaceCreateDeviceRGB()
        guard let source = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
                                     bytesPerRow: width * 4, space: space, bitmapInfo: info),
              let output = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
                                     bytesPerRow: width * 4, space: space, bitmapInfo: info),
              let sourceData = source.data, let outputData = output.data else { return nil }
        source.interpolationQuality = .high
        source.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        if clearFace {
            // ShavedSides has no front locks over the cheeks: keep its straight sides intact.
            source.translateBy(x: 0, y: CGFloat(height))
            source.scaleBy(x: CGFloat(scale), y: -CGFloat(scale))
            source.translateBy(x: 33, y: 36)
            source.setBlendMode(.clear)
            source.addPath(lowerFacePath)
            source.fillPath()
            return source.makeImage()
        }
        outputData.copyMemory(from: sourceData, byteCount: width * height * 4)
        let src = sourceData.assumingMemoryBound(to: UInt8.self)
        let dst = outputData.assumingMemoryBound(to: UInt8.self)
        let center = CGFloat(width) / 2
        let inner = CGFloat(24 * scale), edge = CGFloat(48 * scale), outer = CGFloat(72 * scale)
        // Resample only the cheek/neck area. The scalp, outer silhouette and lower hair stay intact.
        for y in (136 * scale)..<(220 * scale) {
            let offset = hairCheekOffset(at: (CGFloat(y) + 0.5) / CGFloat(scale)) * CGFloat(scale)
            if offset == 0 { continue }
            for x in (61 * scale)..<(205 * scale) {
                let dx = CGFloat(x) + 0.5 - center
                let distance = abs(dx)
                let sample: CGFloat
                if distance < inner + offset {
                    sample = distance * inner / (inner + offset)
                } else if distance < edge + offset {
                    sample = distance - offset
                } else {
                    sample = edge + (distance - edge - offset) / (1 - offset / (outer - edge))
                }
                let sourceX = (dx < 0 ? -sample : sample) + center - 0.5
                let x0 = Int(floor(sourceX)), fraction = sourceX - CGFloat(x0)
                for channel in 0..<4 {
                    let a = CGFloat(src[(y * width + x0) * 4 + channel])
                    let b = CGFloat(src[(y * width + x0 + 1) * 4 + channel])
                    dst[(y * width + x) * 4 + channel] = UInt8((a * (1 - fraction) + b * fraction).rounded())
                }
            }
        }
        return output.makeImage()
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
    private static let shadedImageCache = NSCache<NSString, UIImage>()
    private static let fittedStubbleCache = NSCache<NSNumber, UIImage>()
    private static let fittedHairCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 16 * 1024 * 1024
        return cache
    }()

    static func fittedStubble(bodyType: Avatar.BodyType) -> UIImage? {
        guard bodyType == .broad || bodyType == .veryBroad,
              let shape = AvatarBodyShape(bodyType: bodyType) else { return Avatar.FacialHair.BeardStubble.image() }
        let key = NSNumber(value: bodyType.rawValue)
        if let image = fittedStubbleCache.object(forKey: key) { return image }
        guard let original = Avatar.FacialHair.BeardStubble.image(), let cgImage = original.cgImage,
              let fitted = shape.fittedStubbleImage(cgImage) else { return Avatar.FacialHair.BeardStubble.image() }
        let image = UIImage(cgImage: fitted, scale: 3, orientation: .up).withRenderingMode(.alwaysOriginal)
        fittedStubbleCache.setObject(image, forKey: key)
        return image
    }

    static func fittedHair(_ hair: Avatar.Hair, bodyType: Avatar.BodyType) -> UIImage? {
        guard hair.followsCheekShape, bodyType == .broad || bodyType == .veryBroad,
              let shape = AvatarBodyShape(bodyType: bodyType) else { return hair.image() }
        let key = "\(hair.rawValue)-\(bodyType.rawValue)" as NSString
        if let image = fittedHairCache.object(forKey: key) { return image }
        guard let original = hair.image(), let cgImage = original.cgImage,
              let fitted = shape.fittedHairImage(cgImage, clearFace: hair == .ShavedSides) else { return hair.image() }
        let image = UIImage(cgImage: fitted, scale: 3, orientation: .up).withRenderingMode(original.renderingMode)
        fittedHairCache.setObject(image, forKey: key, cost: fitted.bytesPerRow * fitted.height)
        return image
    }

    static func shadedBody(for bodyType: Avatar.BodyType, skinColorIndex: Int) -> UIImage? {
        let key = "\(bodyType.rawValue)-\(skinColorIndex)" as NSString
        if let image = shadedImageCache.object(forKey: key) { return image }
        guard let mask = images(for: bodyType)?.body
            ?? UIImage(named: "Body", in: .module, compatibleWith: nil) else { return nil }
        let color = Avatar.Part.Skin.colors()[skinColorIndex]
        let format = UIGraphicsImageRendererFormat()
        format.scale = mask.scale
        let size = CGSize(width: 200, height: 244)
        let image = UIGraphicsImageRenderer(size: size, format: format).image { renderer in
            let context = renderer.cgContext
            let bounds = CGRect(origin: .zero, size: size)
            mask.withRenderingMode(.alwaysOriginal).draw(in: bounds)
            context.setBlendMode(.sourceIn)
            context.setFillColor(color.cgColor)
            context.fill(bounds)
            AvatarBodyShading.draw(in: context)
        }.withRenderingMode(.alwaysOriginal)
        // Reuse lighting when changing clothing/accessories or showing the same avatar in a list.
        let cost = Int(size.width * size.height * format.scale * format.scale) * 4
        shadedImageCache.setObject(image, forKey: key, cost: cost)
        return image
    }

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
