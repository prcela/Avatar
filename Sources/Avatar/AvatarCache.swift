//
//  AvatarCache.swift
//  Yamb
//
//  Created by Kresimir Prcela on 27.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import Foundation
import UIKit

public class AvatarCache {
    fileprivate static var images = [Int64:UIImage?]()
    fileprivate static var imagesSmall = [Int64:UIImage?]()
    fileprivate static let editAvatarView = UINib(nibName: "EditAvatarView", bundle: .module).instantiate(withOwner: nil).first as! EditAvatarView
    
    public class func fetchImage(avatarId:Int64, small: Bool) -> UIImage? {
        if small, let smallImg = imagesSmall[avatarId] {
            return smallImg
        } else if !small, let img = images[avatarId] {
            return img
        } else {
            let avatar = Avatar.decompress(value: avatarId)
            editAvatarView.avatar = avatar
            editAvatarView.update()
            let img = editAvatarView.image()
            images[avatarId] = img
            
            var smallImg: UIImage?
            if let img {
                let smallSize = CGSize(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(smallSize, false, 0)
                img.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
                smallImg = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                imagesSmall[avatarId] = smallImg
            }
            return small ? smallImg : img
        }
    }
}
