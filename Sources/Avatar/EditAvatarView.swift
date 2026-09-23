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
    @IBOutlet weak var neckShadowImgView: UIImageView!
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

    private let hairBackingView = UIImageView()
    private let hairBackingMask = CAShapeLayer()
    private let hairFaceMask = CAShapeLayer()

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
        let isBot = avatar.skin == .Bot && UIAvatarView.enableBots
        let bodyImages = isBot ? nil : AvatarBodyShape.images(for: avatar.bodyType)
        let bodyImage = isBot ? avatar.skin.image()
            : AvatarBodyShape.shadedBody(for: avatar.bodyType, skinColorIndex: avatar.skinColorIdx)
        bodyImgView.image = bodyImageForClothing(bodyImage)
        bodyImgView.tintColor = skinColors[avatar.skinColorIdx]
        neckShadowImgView.image = bodyImages?.shadow ?? UIImage(named: "Neck Shadow", in: .module, compatibleWith: nil)
        mouthImgView.image = avatar.mouth.image()
        noseImgView.image = avatar.nose.image()
        eyesImgView.image = positionedPair(avatar.eyes.image())
        // Keep the connected eyebrow intact instead of opening a gap in its center.
        eyesbrowImgView.image = avatar.eyebrow == .UnibrowNatural
            ? avatar.eyebrow.image() : positionedPair(avatar.eyebrow.image())
        glassesView.image = avatar.glasses.image()
        // Follow 60% of the body width change to keep lenses closer to the eyes.
        let glassesScaleX = 1 + (avatar.bodyType.scaleX - 1) * 0.6
        let glassesTransform = CGAffineTransform(scaleX: glassesScaleX, y: 1)
        glassesView.transform = glassesTransform
        if avatar.glasses == .Monocle {
            // Enlarge around the lens/eye center (160, 110), retaining the 8-point drop.
            glassesView.transform = glassesTransform.translatedBy(x: -11.2, y: 11.6).scaledBy(x: 1.4, y: 1.4)
        }
        let hairColors = Avatar.Part.Hair.colors()
        if avatar.hairColorIdx >= hairColors.count {
            avatar.hairColorIdx = 0
        }
        hairView.image = avatar.hair.image(color: hairColors[avatar.hairColorIdx])
        if !isBot && avatar.hair.followsCheekShape {
            hairView.image = AvatarBodyShape.fittedHair(avatar.hair, bodyType: avatar.bodyType)
        }
        hairView.tintColor = hairColors[avatar.hairColorIdx]
        let hairScale = avatar.hair.appearanceScale
        let hairScaleY = avatar.hair.appearanceScaleY
        let hairWidthScale = isBot ? 1 : avatar.hair.widthScale(for: avatar.bodyType)
        let hairStyle = avatar.hair.style
        let hairOffsetX: CGFloat = hairStyle?.offsetX ?? (avatar.hair == .Beret ? -4 : 0)
        let hairOffsetY = (1 - hairScaleY) * (avatar.hair.scaleAnchorY - 140) + (hairStyle?.offsetY ?? 0)
        // Raise the ponytail by 5% of the 280-point avatar canvas.
        let hairLift: CGFloat = avatar.hair == .HighPonytail ? 14 : 0
        let hairTransform = bodyTransform.translatedBy(x: hairOffsetX, y: hairOffsetY - hairLift)
            .scaledBy(x: hairScale, y: hairScaleY)
        hairView.transform = hairTransform.scaledBy(x: hairWidthScale, y: 1)
        if !isBot, let hairStyle {
            hairFaceMask.frame = hairView.bounds
            hairFaceMask.fillRule = .evenOdd
            hairFaceMask.path = hairStyle.frontMask(for: avatar.bodyType, bounds: hairView.bounds)
            hairView.layer.mask = hairFaceMask
        } else {
            hairView.layer.mask = nil
        }
        let needsHairBacking = hairStyle != nil || avatar.hair == .HighPonytail
            || (avatar.hair == .LongWavy && (avatar.bodyType == .broad || avatar.bodyType == .veryBroad))
        if !isBot && needsHairBacking {
            // Fill openings behind the skin when widening the front hair.
            if hairBackingView.superview == nil {
                insertSubview(hairBackingView, belowSubview: bodyImgView)
            }
            hairBackingView.bounds = hairView.bounds
            hairBackingView.center = hairView.center
            hairBackingView.contentMode = hairView.contentMode
            hairBackingView.transform = hairTransform
            hairBackingView.image = hairStyle != nil ? hairView.image
                : avatar.hair.image(color: hairColors[avatar.hairColorIdx])
            if avatar.hair == .ShavedSides {
                // Continuous strands behind the ears and cheeks, preserving the front cutouts.
                hairBackingView.image = avatar.hair.image(color: hairColors[avatar.hairColorIdx], backing: true)
            }
            hairBackingView.tintColor = hairView.tintColor
            hairBackingView.layer.mask = nil
            if hairStyle != nil {
                // A narrower rear layer closes transparent gaps around the jaw and neck.
                let backingWidth: CGFloat
                switch avatar.hair {
                case .ShavedSides:
                    // Keep the strands connected behind the ears.
                    backingWidth = 1
                case .Bob:
                    // Bring the inner ends against the lower cheeks and jaw.
                    backingWidth = 0.65
                default:
                    backingWidth = 0.9
                }
                hairBackingView.transform = hairTransform.scaledBy(x: backingWidth, y: 1)
            }
            if avatar.hair == .HighPonytail {
                // Keep only the original scalp behind the temples, excluding the ponytail.
                hairBackingView.transform = hairTransform.scaledBy(x: (hairScale - 0.1) / hairScale, y: 1)
                hairBackingMask.frame = hairBackingView.bounds
                hairBackingMask.path = UIBezierPath(rect: CGRect(x: 0, y: 0,
                    width: hairBackingView.bounds.width * 196 / 266,
                    height: hairBackingView.bounds.height / 2)).cgPath
                hairBackingView.layer.mask = hairBackingMask
            }
        } else {
            hairBackingView.image = nil
            hairBackingView.layer.mask = nil
        }
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

    private func bodyImageForClothing(_ image: UIImage?) -> UIImage? {
        guard let image else { return nil }
        guard let torsoWidth = avatar.clothing.visibleTorsoWidth else { return image }
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        return UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            // Keep the head and neckline, hiding skin outside the garment's shoulders.
            let scaleX = image.size.width / 200
            let scaleY = image.size.height / 244
            let visibleSkin = UIBezierPath(rect: CGRect(x: 0, y: 0, width: image.size.width, height: 160 * scaleY))
            visibleSkin.append(UIBezierPath(rect: CGRect(x: (200 - torsoWidth) / 2 * scaleX, y: 160 * scaleY, width: torsoWidth * scaleX, height: 84 * scaleY)))
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
