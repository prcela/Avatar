//
//  AvatarCache.swift
//  Yamb
//
//  Created by Kresimir Prcela on 27.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import Foundation
import UIKit

class AvatarCache {
    fileprivate static var images = [Int64:UIImage?]()
    fileprivate static let editAvatarView =  UINib(nibName: "EditAvatarView", bundle: .module).instantiate(withOwner: nil).first as! EditAvatarView
    
    class func fetchImage(avatarId:Int64) -> UIImage? {
        if let img = images[avatarId] {
            return img
        } else {
            let avatar = Avatar.decompress(value: avatarId)
            editAvatarView.avatar = avatar
            editAvatarView.update()
            let img = editAvatarView.image()
            images[avatarId] = img
            return img
        }
    }
}
