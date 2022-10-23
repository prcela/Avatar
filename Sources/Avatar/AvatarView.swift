//
//  AvatarView.swift
//  Yamb
//
//  Created by Kresimir Prcela on 27.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import Foundation
import UIKit

public class AvatarView: UIImageView {
    public var avatarId: Int64? = nil {
        didSet {
            if oldValue != avatarId {
                update()
            }
        }
    }
    
    fileprivate func update() {
        if let id = avatarId {
            image = AvatarCache.fetchImage(avatarId: id)
        }
    }
}
