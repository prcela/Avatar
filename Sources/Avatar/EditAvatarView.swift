//
//  AvatarView.swift
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
        let skinColors = Avatar.Part.Skin.colors()
        if avatar.skinColorIdx >= skinColors.count {
            avatar.skinColorIdx = 0
        }
        bodyImgView.tintColor = skinColors[avatar.skinColorIdx]
        mouthImgView.image = avatar.mouth.image()
        noseImgView.image = avatar.nose.image()
        eyesImgView.image = avatar.eyes.image()
        eyesbrowImgView.image = avatar.eyebrow.image()
        glassesView.image = avatar.glasses.image()
        hairView.image = avatar.hair.image()
        let hairColors = Avatar.Part.Hair.colors()
        if avatar.hairColorIdx >= hairColors.count {
            avatar.hairColorIdx = 0
        }
        hairView.tintColor = hairColors[avatar.hairColorIdx]
        clothingImgView.image = avatar.clothing.image()
        let clothingColors = Avatar.Part.Clothing.colors()
        if avatar.clothingColorIdx >= clothingColors.count {
            avatar.clothingColorIdx = 0
        }
        clothingImgView.tintColor = clothingColors[avatar.clothingColorIdx]
        additionImgView.image = avatar.addition.image()
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
        case .Hairband:
            insertSubview(additionImgView, aboveSubview: hairView)
        case .AddHearts:
            insertSubview(additionImgView, aboveSubview: glassesView)
        }
    }
    
}
