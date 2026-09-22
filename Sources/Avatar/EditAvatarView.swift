//
//  EditAvatarView.swift
//  Yamb
//
//  Created by Kresimir Prcela on 25.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import Foundation
import UIKit

public class EditAvatarView : UIView {
    
    @IBOutlet weak var bodyImgView: UIImageView!
    @IBOutlet weak var clothingImgView: UIImageView!
    @IBOutlet weak var clothingLogoImgView: UIImageView!
    @IBOutlet public weak var additionImgView: UIImageView!
    @IBOutlet weak var eyesImgView: UIImageView!
    @IBOutlet weak var mouthImgView: UIImageView!
    @IBOutlet weak var eyesbrowImgView: UIImageView!
    @IBOutlet weak var facialHairImgView: UIImageView!
    @IBOutlet weak var noseImgView: UIImageView!
    @IBOutlet weak var hairView: UIImageView!
    @IBOutlet weak var glassesView: UIImageView!
    
    var avatar = Avatar()
    
    func update() {
        layer.sublayerTransform = CATransform3DIdentity
        let fixedSizeViews: [UIView] = [eyesImgView, mouthImgView, eyesbrowImgView, noseImgView, clothingLogoImgView]
        let bodyTransform = CGAffineTransform(scaleX: avatar.bodyType.scaleX, y: 1)
        // All image views are centered on the avatar's X axis, including the neck shadow.
        for subview in subviews {
            subview.transform = fixedSizeViews.contains(where: { $0 === subview }) ? .identity : bodyTransform
        }
        let skinColors = Avatar.Part.Skin.colors()
        if avatar.skinColorIdx >= skinColors.count {
            avatar.skinColorIdx = 0
        }
        bodyImgView.image = bodyImageForClothing()
        bodyImgView.tintColor = skinColors[avatar.skinColorIdx]
        mouthImgView.image = avatar.mouth.image()
        noseImgView.image = avatar.nose.image()
        eyesImgView.image = positionedPair(avatar.eyes.image())
        // Keep the connected eyebrow intact instead of opening a gap in its center.
        eyesbrowImgView.image = avatar.eyebrow == .UnibrowNatural
            ? avatar.eyebrow.image() : positionedPair(avatar.eyebrow.image())
        glassesView.image = avatar.glasses.image()
        if avatar.glasses == .Monocle {
            // Enlarge around the lens/eye center (160, 110), retaining the 8-point drop.
            glassesView.transform = bodyTransform.translatedBy(x: -11.2, y: 11.6).scaledBy(x: 1.4, y: 1.4)
        }
        let hairColors = Avatar.Part.Hair.colors()
        if avatar.hairColorIdx >= hairColors.count {
            avatar.hairColorIdx = 0
        }
        hairView.image = avatar.hair.image(color: hairColors[avatar.hairColorIdx])
        hairView.tintColor = hairColors[avatar.hairColorIdx]
        let hairScale = avatar.hair.appearanceScale
        let hairOffsetX: CGFloat = avatar.hair == .Beret ? -4 : 0
        let hairOffsetY = (1 - hairScale) * (avatar.hair.scaleAnchorY - 140)
        hairView.transform = bodyTransform.translatedBy(x: hairOffsetX, y: hairOffsetY).scaledBy(x: hairScale, y: hairScale)
        let clothingColors = Avatar.Part.Clothing.colors()
        if avatar.clothingColorIdx >= clothingColors.count {
            avatar.clothingColorIdx = 0
        }
        clothingImgView.image = avatar.clothing.image(color: clothingColors[avatar.clothingColorIdx])
        clothingImgView.tintColor = clothingColors[avatar.clothingColorIdx]
        let additionColors = Avatar.Part.Addition.colors()
        let additionColor = additionColors.indices.contains(avatar.additionColorIdx) ? additionColors[avatar.additionColorIdx] : additionColors[0]
        additionImgView.image = avatar.addition.avatarImage(color: additionColor)
        facialHairImgView.image = avatar.facialHair.image()
        let facialHairColors = Avatar.Part.FacialHair.colors()
        if avatar.facialHairColorIdx >= facialHairColors.count {
            avatar.facialHairColorIdx = 0
        }
        facialHairImgView.tintColor = facialHairColors[avatar.facialHairColorIdx]
        clothingLogoImgView.image = avatar.shirtMarkImage()
        
        switch avatar.addition {
        case .None:
            break
        case .Blazer:
            insertSubview(additionImgView, aboveSubview: clothingImgView)
        case .Freckles, .Old, .Makeup:
            insertSubview(additionImgView, aboveSubview: bodyImgView)
        case .Hairband, .Crown, .KungFuHeadband:
            insertSubview(additionImgView, aboveSubview: hairView)
        case .Bandana:
            insertSubview(additionImgView, belowSubview: facialHairImgView)
        case .GoldChain, .GoldEarring, .DiamondEarrings, .BowTie, .Tie, .Scarf, .DiceChain, .GoldMedal:
            insertSubview(additionImgView, belowSubview: hairView)
        case .AddHearts, .Headphones, .CheekBandage, .EyebrowScar, .EyebrowPiercing:
            insertSubview(additionImgView, aboveSubview: glassesView)
        }
    }

    private func bodyImageForClothing() -> UIImage? {
        guard let image = avatar.skin.image() else { return nil }
        guard avatar.clothing.verticalOffset > 0 else { return image }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        return UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            // Keep the head and neck, hiding the bare shoulder rim above lowered clothing.
            let scaleX = image.size.width / 200
            let scaleY = image.size.height / 244
            let visibleSkin = UIBezierPath(rect: CGRect(x: 0, y: 0, width: image.size.width, height: 160 * scaleY))
            visibleSkin.append(UIBezierPath(rect: CGRect(x: 68 * scaleX, y: 160 * scaleY, width: 64 * scaleX, height: 84 * scaleY)))
            visibleSkin.addClip()
            image.draw(at: .zero)
        }.withRenderingMode(image.renderingMode)
    }

    private func positionedPair(_ image: UIImage?) -> UIImage? {
        guard let image, avatar.bodyType != .normal else { return image }
        // Move each eye/brow by 3 or 6 points on the 264-point avatar canvas.
        // Only the spacing changes; each half keeps its original size and height.
        let offset = (avatar.bodyType.scaleX - 1) * 20 * image.size.width / 112
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
