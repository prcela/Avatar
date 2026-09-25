// SPDX-License-Identifier: MPL-2.0

//
//  AvatarCache.swift
//  Yamb
//
//  Created by Kresimir Prcela on 27.12.2021..
//  Copyright © 2021 Rika Omega Rika.
//

import Foundation
import UIKit

public class AvatarCache {
    fileprivate static var images = [String:UIImage?]()
    fileprivate static var imagesSmall = [String:UIImage?]()
    fileprivate static let editAvatarView = UINib(nibName: "EditAvatarView", bundle: .module).instantiate(withOwner: nil).first as! EditAvatarView
    
    public class func fetchImage(avatarId:Int64, avatarHexId: String = "", small: Bool) -> UIImage? {
        let key = AvatarHexID(avatarHexId)?.hex ?? "legacy:\(avatarId)"
        if small, let smallImg = imagesSmall[key] {
            return smallImg
        } else if !small, let img = images[key] {
            return img
        } else {
            let avatar = Avatar.decompress(value: avatarId, hexId: avatarHexId)
            editAvatarView.avatar = avatar
            editAvatarView.update()
            let img = editAvatarView.image()
            images[key] = img
            
            var smallImg: UIImage?
            if let img {
                let smallSize = CGSize(width: 30, height: 30)
                let renderer = UIGraphicsImageRenderer(size: smallSize)
                smallImg = renderer.image { _ in
                    img.draw(in: CGRect(origin: .zero, size: smallSize))
                }
            imagesSmall[key] = smallImg
            }
            return small ? smallImg : img
        }
    }
    
    public class func didReceiveMemoryWarning() {
        images.removeAll()
        imagesSmall.removeAll()
    }
}
