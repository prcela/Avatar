// SPDX-License-Identifier: MPL-2.0

import UIKit

// Shared bitmap operations for the editor and the background renderer.
extension Avatar {
    func bodyImageForHeadwear(_ image: UIImage?, isBot: Bool) -> UIImage? {
        guard let image, !isBot, self.addition == .WitchHat else { return image }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        return UIGraphicsImageRenderer(size: image.size, format: format).image { renderer in
            // The hat covers the scalp above avatar y=100; retain the face and ears below it.
            let top = image.size.height * 64 / 244
            renderer.cgContext.clip(to: CGRect(x: 0, y: top,
                width: image.size.width, height: image.size.height - top))
            image.draw(at: .zero)
        }.withRenderingMode(image.renderingMode)
    }

    func bodyImageWithHair(_ image: UIImage?, isBot: Bool) -> UIImage? {
        guard self.addition == .BodyHair, !isBot,
              let image, let hair = Avatar.Addition.BodyHair.image() else { return image }
        let colors = Avatar.Part.Hair.colors()
        let color = colors[colors.indices.contains(self.hairColorIdx) ? self.hairColorIdx : 0]
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        return UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            image.draw(at: .zero)
            // Body-local y=166 is avatar y=202, safely below the face and neck.
            // Source-atop keeps the original skin alpha, including shoulder edges.
            let frame = CGRect(x: 0, y: image.size.height * 166 / 244,
                               width: image.size.width, height: image.size.height * 78 / 244)
            hair.withTintColor(color, renderingMode: .alwaysOriginal)
                .draw(in: frame, blendMode: .sourceAtop, alpha: 1)
        }.withRenderingMode(.alwaysOriginal)
    }

    func bodyImageForClothing(_ image: UIImage?) -> UIImage? {
        guard let image else { return nil }
        guard let torsoWidth = self.clothing.visibleTorsoWidth else { return image }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        return UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            // Keep the head and neckline, hiding skin outside the garment's shoulders.
            let scaleX = image.size.width / 200
            let scaleY = image.size.height / 244
            let visibleSkin = UIBezierPath(rect: CGRect(x: 0, y: 0, width: image.size.width, height: 160 * scaleY))
            visibleSkin.append(UIBezierPath(rect: CGRect(x: (200 - torsoWidth) / 2 * scaleX, y: 160 * scaleY, width: torsoWidth * scaleX, height: 84 * scaleY)))
            if let armsStartY = self.clothing.visibleArmsStartY {
                // Restore skin below short cuffs while keeping it hidden outside the shoulders.
                visibleSkin.append(UIBezierPath(rect: CGRect(x: 0, y: armsStartY * scaleY,
                    width: image.size.width, height: (244 - armsStartY) * scaleY)))
            }
            visibleSkin.addClip()
            image.draw(at: .zero)
        }.withRenderingMode(image.renderingMode)
    }

    func positionedPair(_ image: UIImage?) -> UIImage? {
        guard let image, self.bodyType != .normal else { return image }
        // Move each eye/brow by 3 or 6 points on the 264-point avatar canvas.
        // Only the spacing changes; each half keeps its original size and height.
        let offset = (self.bodyType.scaleX - 1) * 20 * image.size.width / 112
        let halfWidth = image.size.width / 2
        let format = UIGraphicsImageRendererFormat.default()
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        return renderer.image { context in
            for side in 0...1 {
                let shift = side == 0 ? -offset : offset
                let clip = CGRect(x: CGFloat(side) * halfWidth + shift, y: 0,
                                  width: halfWidth, height: image.size.height)
                context.cgContext.saveGState()
                context.cgContext.clip(to: clip)
                image.draw(at: CGPoint(x: shift, y: 0))
                context.cgContext.restoreGState()
            }
        }
    }
    
}
