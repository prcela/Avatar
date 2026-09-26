// SPDX-License-Identifier: MPL-2.0

//
//  EditAvatarView.swift
//  Yamb
//
//  Created by Kresimir Prcela on 25.12.2021..
//  Copyright © 2021 Rika Omega Rika.
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
    private let eyePairView = AvatarEyePairView()
    private let browPairView = AvatarEyePairView()
    private static let emptyEyes = UIGraphicsImageRenderer(size: CGSize(width: 112, height: 44)).image { _ in }
    private static let emptyBrows = UIGraphicsImageRenderer(size: CGSize(width: 112, height: 24)).image { _ in }

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
        // Tuck hair and headwear under the hood without changing the saved style.
        let wearsHood = avatar.addition == .Hood
        hairView.isHidden = wearsHood
        hairBackingView.isHidden = wearsHood
        // Keep selected facial features saved while costume fabric covers them.
        let wearsNinjaMask = !wearsHood && avatar.hair == .NinjaHood
        let wearsHelmet = !wearsHood && (avatar.hair == .MotorcycleHelmet || avatar.hair == .AstronautHelmet)
        mouthImgView.isHidden = wearsNinjaMask || (!wearsHood && avatar.hair == .MotorcycleHelmet)
        noseImgView.isHidden = wearsNinjaMask
        facialHairImgView.isHidden = wearsNinjaMask || wearsHelmet
        let bodyImages = isBot ? nil : AvatarBodyShape.images(for: avatar.bodyType)
        let bodyImage = isBot ? avatar.skin.image()
            : AvatarBodyShape.shadedBody(for: avatar.bodyType, skinColorIndex: avatar.skinColorIdx)
        let dressedBody = bodyImageForClothing(bodyImageWithHair(bodyImage, isBot: isBot))
        bodyImgView.image = bodyImageForHeadwear(dressedBody, isBot: isBot, wearsHood: wearsHood)
        bodyImgView.tintColor = skinColors[avatar.skinColorIdx]
        neckShadowImgView.image = bodyImages?.shadow ?? UIImage(named: "Neck Shadow", in: .module, compatibleWith: nil)
        mouthImgView.image = avatar.mouth.image()
        mouthImgView.transform = CGAffineTransform(scaleX: avatar.mouthWidth.scale, y: 1)
        noseImgView.image = AvatarNoseStyle.image(for: avatar.nose, skinColorIndex: avatar.skinColorIdx)
        // Scale around the visible nose center, six points below its canvas center.
        let noseScale = avatar.noseSize.scale
        noseImgView.transform = CGAffineTransform(translationX: 0, y: 6 * (1 - noseScale))
            .scaledBy(x: noseScale, y: noseScale)
        if avatar.eyeSpacing == .normal && avatar.eyeSize == .normal {
            eyePairView.isHidden = true
            eyesImgView.image = positionedPair(avatar.eyes.image())
        } else {
            if eyePairView.superview == nil {
                eyesImgView.addSubview(eyePairView)
                eyePairView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                eyesImgView.clipsToBounds = false
            }
            // Retain the XIB's original intrinsic size while drawing each eye independently.
            eyesImgView.image = Self.emptyEyes
            eyePairView.frame = eyesImgView.bounds
            eyePairView.isHidden = false
            eyePairView.update(image: avatar.eyes.image(),
                offset: (avatar.bodyType.scaleX - 1) * 20 + avatar.eyeSpacing.offset,
                scale: avatar.eyeSize.eyeScale)
        }
        // Keep the connected eyebrow intact instead of opening a gap in its center.
        if avatar.eyebrow == .UnibrowNatural || avatar.eyeSpacing == .normal {
            browPairView.isHidden = true
            eyesbrowImgView.image = avatar.eyebrow == .UnibrowNatural
                ? avatar.eyebrow.image() : positionedPair(avatar.eyebrow.image())
        } else {
            if browPairView.superview == nil {
                eyesbrowImgView.addSubview(browPairView)
                browPairView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                eyesbrowImgView.clipsToBounds = false
            }
            eyesbrowImgView.image = Self.emptyBrows
            browPairView.frame = eyesbrowImgView.bounds
            browPairView.isHidden = false
            browPairView.update(image: avatar.eyebrow.image(),
                offset: (avatar.bodyType.scaleX - 1) * 20 + avatar.eyeSpacing.offset, scale: 1)
        }
        glassesView.image = avatar.glasses.image(colorIndex: avatar.glassesColorIdx)
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
        var hairScale = avatar.hair.appearanceScale
        var hairScaleY = avatar.hair.appearanceScaleY
        // Fit only the headwear around its brim/eye anchor; body and face stay the same size.
        let headwearFit: CGFloat
        switch avatar.hair {
        case .WitchHat:
            headwearFit = min(1, 106 / (105 * hairScaleY),
                262 / (216 * hairScale * avatar.bodyType.scaleX))
        case .AstronautHelmet:
            headwearFit = min(1, 109 / (97 * hairScaleY))
        default: headwearFit = 1
        }
        hairScale *= headwearFit
        hairScaleY *= headwearFit
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
        clothingImgView.image = avatar.clothing.image(color: clothingColors[avatar.clothingColorIdx], raisedHood: wearsHood)
        clothingImgView.tintColor = clothingColors[avatar.clothingColorIdx]
        let additionColors = Avatar.Part.Addition.colors()
        let additionColor = additionColors.indices.contains(avatar.additionColorIdx) ? additionColors[avatar.additionColorIdx] : additionColors[0]
        // Body hair belongs to the skin layer, beneath every garment.
        additionImgView.image = avatar.addition == .BodyHair ? nil : avatar.addition.avatarImage(color: additionColor)
        if avatar.addition == .Crown && avatar.hair != .None && avatar.hair != .Eyepatch {
            // Leave bald heads at the base position; make room for hair or headwear.
            additionImgView.transform = bodyTransform.translatedBy(x: 0, y: -8)
        }
        let facialHairColors = Avatar.Part.FacialHair.colors()
        if avatar.facialHairColorIdx >= facialHairColors.count {
            avatar.facialHairColorIdx = 0
        }
        facialHairImgView.image = avatar.facialHair.image(color: facialHairColors[avatar.facialHairColorIdx],
            bodyType: isBot ? .normal : avatar.bodyType)
        facialHairImgView.tintColor = facialHairColors[avatar.facialHairColorIdx]
        let facialHairHeight = avatar.facialHair.canvasHeight
        let usesTallBeardCanvas = facialHairHeight != 152
        facialHairImgView.contentMode = usesTallBeardCanvas ? .scaleToFill : .scaleAspectFit
        if usesTallBeardCanvas {
            // Align the mouth opening while extending the taller artwork over the chest.
            facialHairImgView.transform = bodyTransform.translatedBy(x: 0,
                y: (facialHairHeight - 152) / 2 + avatar.facialHair.verticalOffset)
                .scaledBy(x: 1, y: facialHairHeight / 152)
        } else if avatar.facialHair == .BeardLight || avatar.facialHair == .BeardStubble {
            // Extend over the jaw, scaling around the nose at avatar y = 132.
            // The facial-hair view is centered at y = 146, so compensate by 1.4 points.
            facialHairImgView.transform = bodyTransform.translatedBy(x: 0, y: 1.4)
                .scaledBy(x: 1.04, y: 1.1)
        }
        clothingLogoImgView.image = avatar.shirtMarkImage()
        if !avatar.clothing.isJersey || !(1...100).contains(avatar.jerseyNumber) {
            // Place the logo on the viewer's right, following the chest width.
            clothingLogoImgView.transform = CGAffineTransform(translationX: 36 * avatar.bodyType.scaleX, y: 0)
        }
        
        switch avatar.addition {
        case .None, .BodyHair:
            break
        case .Laptop:
            insertSubview(additionImgView, aboveSubview: glassesView)
        case .Blazer:
            insertSubview(additionImgView, aboveSubview: clothingImgView)
        case .Freckles, .Old, .Makeup:
            insertSubview(additionImgView, aboveSubview: bodyImgView)
        case .Hairband, .Crown, .KungFuHeadband:
            insertSubview(additionImgView, aboveSubview: hairView)
        case .Bandana, .Hood:
            // Facial hair lies over the fabric at the jaw and neck.
            insertSubview(additionImgView, belowSubview: facialHairImgView)
        case .GoldChain, .GoldEarring, .DiamondEarrings, .BowTie, .Tie, .Scarf, .DiceChain, .GoldMedal, .SilverBlackNecklace:
            insertSubview(additionImgView, belowSubview: hairView)
        case .AddHearts, .Headphones, .CheekBandage, .EyebrowScar, .EyebrowPiercing:
            insertSubview(additionImgView, aboveSubview: glassesView)
        }
    }

    private func bodyImageForHeadwear(_ image: UIImage?, isBot: Bool, wearsHood: Bool) -> UIImage? {
        guard let image, !isBot, !wearsHood, avatar.hair == .WitchHat else { return image }
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

    private func bodyImageWithHair(_ image: UIImage?, isBot: Bool) -> UIImage? {
        guard avatar.addition == .BodyHair, !isBot,
              let image, let hair = Avatar.Addition.BodyHair.image() else { return image }
        let colors = Avatar.Part.Hair.colors()
        let color = colors[colors.indices.contains(avatar.hairColorIdx) ? avatar.hairColorIdx : 0]
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
            if let armsStartY = avatar.clothing.visibleArmsStartY {
                // Restore skin below short cuffs while keeping it hidden outside the shoulders.
                visibleSkin.append(UIBezierPath(rect: CGRect(x: 0, y: armsStartY * scaleY,
                    width: image.size.width, height: (244 - armsStartY) * scaleY)))
            }
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

/// Clip the source pair before transforming each half. Large eyes, including tears
/// and hearts, can extend beyond the original canvas without being cut off.
final class AvatarEyePairView: UIView {
    private let halves = [UIView(), UIView()]
    private let images = [UIImageView(), UIImageView()]
    private var eyeOffset: CGFloat = 0
    private var eyeScale: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        for index in 0...1 {
            halves[index].clipsToBounds = true
            images[index].contentMode = .scaleToFill
            halves[index].addSubview(images[index])
            addSubview(halves[index])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("AvatarEyePairView is created programmatically")
    }

    func update(image: UIImage?, offset: CGFloat, scale: CGFloat) {
        images.forEach { $0.image = image }
        eyeOffset = offset
        eyeScale = scale
        setNeedsLayout()
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let halfWidth = bounds.width / 2
        let offset = eyeOffset * bounds.width / 112
        for index in 0...1 {
            let half = halves[index]
            half.transform = .identity
            half.frame = CGRect(x: CGFloat(index) * halfWidth, y: 0,
                                width: halfWidth, height: bounds.height)
            images[index].frame = CGRect(x: -CGFloat(index) * halfWidth, y: 0,
                                        width: bounds.width, height: bounds.height)
            half.transform = CGAffineTransform(translationX: index == 0 ? -offset : offset, y: 0)
                .scaledBy(x: eyeScale, y: eyeScale)
        }
    }
}
