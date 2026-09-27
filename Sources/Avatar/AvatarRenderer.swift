// SPDX-License-Identifier: MPL-2.0

import UIKit

/// Bitmap composition only: no views, layers, nibs or main-thread state.
/// Geometry and stacking mirror EditAvatarView.xib and EditAvatarView.update().
struct AvatarRenderer {
    static let size = CGSize(width: 264, height: 280)
    let avatar: Avatar
    let enableBots: Bool

    func image(scale: CGFloat) -> UIImage {
        let layers = makeLayers()
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: Self.size, format: format).image { renderer in
            for layer in layers { layer.draw(in: renderer.cgContext) }
        }
    }

    // Each instance belongs to one render. These are drawing instructions, not CALayers.
    private final class Layer {
        let frame: CGRect
        var image: UIImage?
        var transform = CGAffineTransform.identity
        var tintColor = UIColor(red: 254 / 255, green: 239 / 255, blue: 205 / 255, alpha: 1)
        var hidden = false
        var aspectFit = true
        var mask: CGPath?
        var evenOddMask = false
        var pair: (offset: CGFloat, scale: CGFloat)?

        init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
            frame = CGRect(x: x, y: y, width: width, height: height)
        }

        func draw(in context: CGContext) {
            guard !hidden, let source = image else { return }
            let image = source.renderingMode == .alwaysTemplate
                ? source.withTintColor(tintColor, renderingMode: .alwaysOriginal) : source
            let bounds = CGRect(origin: .zero, size: frame.size)
            context.saveGState()
            defer { context.restoreGState() }
            context.translateBy(x: frame.midX, y: frame.midY)
            context.concatenate(transform)
            context.translateBy(x: -bounds.midX, y: -bounds.midY)
            if let mask {
                context.addPath(mask)
                context.clip(using: evenOddMask ? .evenOdd : .winding)
            }
            if let pair {
                // Clip each source half before scaling, allowing large eyes to overflow.
                let halfWidth = bounds.width / 2
                let offset = pair.offset * bounds.width / 112
                for side in 0...1 {
                    let half = CGRect(x: CGFloat(side) * halfWidth, y: 0,
                                      width: halfWidth, height: bounds.height)
                    context.saveGState()
                    context.translateBy(x: half.midX + (side == 0 ? -offset : offset), y: half.midY)
                    context.scaleBy(x: pair.scale, y: pair.scale)
                    context.translateBy(x: -half.midX, y: -half.midY)
                    context.clip(to: half)
                    image.draw(in: bounds)
                    context.restoreGState()
                }
            } else {
                context.clip(to: bounds)
                var destination = bounds
                if aspectFit, image.size.width > 0, image.size.height > 0 {
                    let ratio = min(bounds.width / image.size.width, bounds.height / image.size.height)
                    let size = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
                    destination = CGRect(x: (bounds.width - size.width) / 2,
                                         y: (bounds.height - size.height) / 2,
                                         width: size.width, height: size.height)
                }
                image.draw(in: destination)
            }
        }
    }

    private func makeLayers() -> [Layer] {
        let body = Layer(32, 36, 200, 244)
        let eyes = Layer(76, 90, 112, 44)
        let neck = Layer(76, 122, 112, 79)
        let mouth = Layer(78, 134, 108, 44)
        let brows = Layer(76, 82, 112, 24)
        let clothing = Layer(0, 170, 264, 110)
        let logo = Layer(77, 236, 110, 44)
        let hair = Layer(-1, 0, 266, 280)
        let backing = Layer(-1, 0, 266, 280)
        let addition = Layer(0, 0, 264, 280)
        let beard = Layer(48, 70, 168, 152)
        let nose = Layer(104, 110, 56, 36)
        let glasses = Layer(61, 84, 142, 54)
        var layers = [backing, body, eyes, neck, mouth, brows, clothing, logo, hair, addition, beard, nose, glasses]
        let bodyTransform = CGAffineTransform(scaleX: avatar.bodyType.scaleX, y: 1)
        for layer in [body, neck, clothing, hair, backing, addition, beard, glasses] {
            layer.transform = bodyTransform
        }
        let skinColors = Avatar.Part.Skin.colors()
        let skinIndex = skinColors.indices.contains(avatar.skinColorIdx) ? avatar.skinColorIdx : 0
        let isBot = avatar.skin == .Bot && enableBots
        let wearsHood = avatar.addition == .Hood
        let wearsHeadwear = avatar.addition.isHeadwear
        let wearsNinjaMask = avatar.addition == .NinjaHood
        let wearsHelmet = avatar.addition == .MotorcycleHelmet || avatar.addition == .AstronautHelmet
        hair.hidden = wearsHood
        backing.hidden = wearsHood
        mouth.hidden = wearsNinjaMask || avatar.addition == .MotorcycleHelmet
        nose.hidden = wearsNinjaMask
        beard.hidden = wearsNinjaMask || wearsHelmet
        let bodyImages = isBot ? nil : AvatarBodyShape.images(for: avatar.bodyType)
        // Read the captured bot setting, never UIAvatarView from the render queue.
        let bodyImage = isBot ? UIImage(named: "Bot", in: .module, compatibleWith: .current)
            : AvatarBodyShape.shadedBody(for: avatar.bodyType, skinColorIndex: skinIndex)
        let dressedBody = avatar.bodyImageForClothing(avatar.bodyImageWithHair(bodyImage, isBot: isBot))
        body.image = avatar.bodyImageForHeadwear(dressedBody, isBot: isBot)
        body.tintColor = skinColors[skinIndex]
        neck.image = bodyImages?.shadow ?? UIImage(named: "Neck Shadow", in: .module, compatibleWith: .current)
        mouth.image = avatar.mouth.image()
        mouth.transform = CGAffineTransform(scaleX: avatar.mouthWidth.scale, y: 1)
        nose.image = AvatarNoseStyle.image(for: avatar.nose, skinColorIndex: skinIndex)
        let noseScale = avatar.noseSize.scale
        nose.transform = CGAffineTransform(translationX: 0, y: 6 * (1 - noseScale))
            .scaledBy(x: noseScale, y: noseScale)
        let eyeOffset = (avatar.bodyType.scaleX - 1) * 20 + avatar.eyeSpacing.offset
        if avatar.eyeSpacing == .normal && avatar.eyeSize == .normal {
            eyes.image = avatar.positionedPair(avatar.eyes.image())
        } else {
            eyes.image = avatar.eyes.image()
            eyes.pair = (eyeOffset, avatar.eyeSize.eyeScale)
        }
        if avatar.eyebrow == .UnibrowNatural || avatar.eyeSpacing == .normal {
            brows.image = avatar.eyebrow == .UnibrowNatural
                ? avatar.eyebrow.image() : avatar.positionedPair(avatar.eyebrow.image())
        } else {
            brows.image = avatar.eyebrow.image()
            brows.pair = (eyeOffset, 1)
        }
        glasses.image = avatar.glasses.image(colorIndex: avatar.glassesColorIdx)
        let glassesScaleX = 1 + (avatar.bodyType.scaleX - 1) * 0.6
        glasses.transform = CGAffineTransform(scaleX: glassesScaleX, y: 1)
        if avatar.glasses == .Monocle {
            glasses.transform = glasses.transform.translatedBy(x: -11.2, y: 11.6).scaledBy(x: 1.4, y: 1.4)
        }
        let additionColors = Avatar.Part.Addition.colors()
        let additionColor = additionColors[additionColors.indices.contains(avatar.additionColorIdx) ? avatar.additionColorIdx : 0]
        let hairColors = Avatar.Part.Hair.colors()
        let hairColor = hairColors[hairColors.indices.contains(avatar.hairColorIdx) ? avatar.hairColorIdx : 0]
        hair.image = wearsHeadwear ? avatar.addition.headwearImage(color: additionColor) : avatar.hair.image(color: hairColor)
        if !isBot && !wearsHeadwear && avatar.hair.followsCheekShape {
            hair.image = AvatarBodyShape.fittedHair(avatar.hair, bodyType: avatar.bodyType)
        }
        hair.tintColor = wearsHeadwear ? additionColor : hairColor
        var hairScale = wearsHeadwear ? avatar.addition.headwearScale : avatar.hair.appearanceScale
        var hairScaleY = wearsHeadwear ? avatar.addition.headwearScaleY : avatar.hair.appearanceScaleY
        let headwearFit: CGFloat
        switch avatar.addition {
        case .WitchHat:
            headwearFit = min(1, 106 / (105 * hairScaleY), 262 / (216 * hairScale * avatar.bodyType.scaleX))
        case .AstronautHelmet:
            headwearFit = min(1, 109 / (97 * hairScaleY))
        default: headwearFit = 1
        }
        hairScale *= headwearFit
        hairScaleY *= headwearFit
        let hairWidthScale = isBot ? 1 : (wearsHeadwear
            ? avatar.addition.headwearWidthScale(for: avatar.bodyType) : avatar.hair.widthScale(for: avatar.bodyType))
        let hairStyle = wearsHeadwear ? nil : avatar.hair.style
        let hairOffsetX: CGFloat = hairStyle?.offsetX ?? (avatar.addition == .Beret ? -4 : 0)
        let hairAnchorY = wearsHeadwear ? avatar.addition.headwearAnchorY : avatar.hair.scaleAnchorY
        let hairOffsetY = (1 - hairScaleY) * (hairAnchorY - 140) + (hairStyle?.offsetY ?? 0)
        let hairLift: CGFloat = !wearsHeadwear && avatar.hair == .HighPonytail ? 14 : 0
        let hairTransform = bodyTransform.translatedBy(x: hairOffsetX, y: hairOffsetY - hairLift)
            .scaledBy(x: hairScale, y: hairScaleY)
        hair.transform = hairTransform.scaledBy(x: hairWidthScale, y: 1)
        if !isBot, let hairStyle {
            hair.mask = hairStyle.frontMask(for: avatar.bodyType, bounds: CGRect(origin: .zero, size: hair.frame.size))
            hair.evenOddMask = true
        }
        let needsHairBacking = hairStyle != nil || avatar.hair == .HighPonytail
            || (avatar.hair == .LongWavy && (avatar.bodyType == .broad || avatar.bodyType == .veryBroad))
        if !isBot && !wearsHeadwear && needsHairBacking {
            backing.transform = hairTransform
            backing.image = hairStyle != nil ? hair.image : avatar.hair.image(color: hairColor)
            if avatar.hair == .ShavedSides {
                backing.image = avatar.hair.image(color: hairColor, backing: true)
            }
            backing.tintColor = hair.tintColor
            if hairStyle != nil {
                let width: CGFloat
                switch avatar.hair {
                case .ShavedSides: width = 1
                case .Bob: width = 0.65
                default: width = 0.9
                }
                backing.transform = hairTransform.scaledBy(x: width, y: 1)
            }
            if avatar.hair == .HighPonytail {
                backing.transform = hairTransform.scaledBy(x: (hairScale - 0.1) / hairScale, y: 1)
                backing.mask = CGPath(rect: CGRect(x: 0, y: 0, width: 196, height: 140), transform: nil)
            }
        }
        let clothingColors = Avatar.Part.Clothing.colors()
        let clothingColor = clothingColors[clothingColors.indices.contains(avatar.clothingColorIdx) ? avatar.clothingColorIdx : 0]
        clothing.image = avatar.clothing.image(color: clothingColor, raisedHood: wearsHood)
        clothing.tintColor = clothingColor
        addition.image = (avatar.addition == .BodyHair || wearsHeadwear) ? nil : avatar.addition.avatarImage(color: additionColor)
        if avatar.addition == .Crown && avatar.hair != .None {
            addition.transform = bodyTransform.translatedBy(x: 0, y: -8)
        }
        let beardColors = Avatar.Part.FacialHair.colors()
        let beardColor = beardColors[beardColors.indices.contains(avatar.facialHairColorIdx) ? avatar.facialHairColorIdx : 0]
        beard.image = avatar.facialHair.image(color: beardColor, bodyType: isBot ? .normal : avatar.bodyType)
        beard.tintColor = beardColor
        let beardHeight = avatar.facialHair.canvasHeight
        if beardHeight != 152 {
            beard.aspectFit = false
            beard.transform = bodyTransform.translatedBy(x: 0, y: (beardHeight - 152) / 2 + avatar.facialHair.verticalOffset)
                .scaledBy(x: 1, y: beardHeight / 152)
        } else if avatar.facialHair == .BeardLight || avatar.facialHair == .BeardStubble {
            beard.transform = bodyTransform.translatedBy(x: 0, y: 1.4).scaledBy(x: 1.04, y: 1.1)
        }
        logo.image = avatar.shirtMarkImage()
        if !avatar.clothing.isJersey || !(1...100).contains(avatar.jerseyNumber) {
            logo.transform = CGAffineTransform(translationX: 36 * avatar.bodyType.scaleX, y: 0)
        }
        func place(_ layer: Layer, relativeTo other: Layer, above: Bool) {
            layers.removeAll { $0 === layer }
            if let index = layers.firstIndex(where: { $0 === other }) {
                layers.insert(layer, at: index + (above ? 1 : 0))
            }
        }
        place(hair, relativeTo: avatar.addition == .WitchHat ? glasses : logo, above: true)
        switch avatar.addition {
        case .None, .BodyHair, .Hat, .Turban, .Hijab,
             .WinterHat1, .WinterHat2, .WinterHat3, .WinterHat4,
             .CowboyHat, .BaseballCap, .ChefHat, .VikingHelmet, .BucketHat, .Beret, .BackwardCap,
             .PoliceCap, .ConstructionHelmet, .PilotCap, .MotorcycleHelmet,
             .AstronautHelmet, .NinjaHood, .WitchHat:
            break
        case .Laptop, .AddHearts, .Headphones, .CheekBandage, .EyebrowScar, .EyebrowPiercing:
            place(addition, relativeTo: glasses, above: true)
        case .Blazer:
            place(addition, relativeTo: clothing, above: true)
        case .Freckles, .Old, .Makeup:
            place(addition, relativeTo: body, above: true)
        case .Hairband, .Crown, .KungFuHeadband, .Eyepatch:
            place(addition, relativeTo: hair, above: true)
        case .Bandana, .Hood:
            place(addition, relativeTo: beard, above: false)
        case .GoldChain, .GoldEarring, .DiamondEarrings, .BowTie, .Tie, .Scarf, .DiceChain, .GoldMedal, .SilverBlackNecklace:
            place(addition, relativeTo: hair, above: false)
        }
        return layers
    }
}
