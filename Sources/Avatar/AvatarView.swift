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
    public static var hideAll = false
    public static var enableBots = false
    public var avatarId: Int64? = nil {
        didSet {
            if oldValue != avatarId {
                update()
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        isHidden = Self.hideAll
    }
    
    override public var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            if Self.hideAll {
                super.isHidden = true
            } else {
                super.isHidden = newValue
            }
        }
    }
    
    fileprivate func update() {
        if let avatarId, !Self.hideAll {
            image = AvatarCache.fetchImage(avatarId: avatarId, small: false)
        }
    }
}
