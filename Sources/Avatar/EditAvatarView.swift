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
        bodyImgView.image = avatar.skin.image()
        bodyImgView.tintColor = skinColors[avatar.skinColorIdx]
        mouthImgView.image = avatar.mouth.image()
        noseImgView.image = avatar.nose.image()
        eyesImgView.image = positionedPair(avatar.eyes.image())
        // Keep the connected eyebrow intact instead of opening a gap in its center.
        eyesbrowImgView.image = avatar.eyebrow == .UnibrowNatural
            ? avatar.eyebrow.image() : positionedPair(avatar.eyebrow.image())
        glassesView.image = avatar.glasses.image()
        let hairColors = Avatar.Part.Hair.colors()
        if avatar.hairColorIdx >= hairColors.count {
            avatar.hairColorIdx = 0
        }
        hairView.image = avatar.hair.image(color: hairColors[avatar.hairColorIdx])
        hairView.tintColor = hairColors[avatar.hairColorIdx]
        clothingImgView.image = avatar.clothing.image()
        let clothingColors = Avatar.Part.Clothing.colors()
        if avatar.clothingColorIdx >= clothingColors.count {
            avatar.clothingColorIdx = 0
        }
        clothingImgView.tintColor = clothingColors[avatar.clothingColorIdx]
        additionImgView.image = avatar.addition.avatarImage()
        facialHairImgView.image = avatar.facialHair.image()
        let facialHairColors = Avatar.Part.FacialHair.colors()
        if avatar.facialHairColorIdx >= facialHairColors.count {
            avatar.facialHairColorIdx = 0
        }
        facialHairImgView.tintColor = facialHairColors[avatar.facialHairColorIdx]
        clothingLogoImgView.image = avatar.clothLogo.image()
        
        switch avatar.addition {
        case .None:
            break
        case .Blazer:
            insertSubview(additionImgView, aboveSubview: clothingImgView)
        case .Freckles, .Old, .Makeup:
            insertSubview(additionImgView, aboveSubview: bodyImgView)
        case .Hairband, .Crown:
            insertSubview(additionImgView, aboveSubview: hairView)
        case .Bandana:
            insertSubview(additionImgView, belowSubview: facialHairImgView)
        case .GoldChain, .GoldEarring, .DiamondEarrings:
            insertSubview(additionImgView, belowSubview: hairView)
        case .AddHearts, .Headphones:
            insertSubview(additionImgView, aboveSubview: glassesView)
        }
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
