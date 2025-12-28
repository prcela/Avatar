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
                let renderer = UIGraphicsImageRenderer(size: smallSize)
                smallImg = renderer.image { _ in
                    img.draw(in: CGRect(origin: .zero, size: smallSize))
                }
                imagesSmall[avatarId] = smallImg
            }
            return small ? smallImg : img
        }
    }
    
    public class func didReceiveMemoryWarning() {
        images.removeAll()
        imagesSmall.removeAll()
    }
}
