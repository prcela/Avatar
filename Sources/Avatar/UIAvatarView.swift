//
//  UIAvatarView.swift
//  Yamb
//
//  Created by Kresimir Prcela on 27.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import Foundation
import UIKit

public class UIAvatarView: UIImageView {
    public static var hideAll = false
    public static var enableBots = false
    public var avatarId: Int64? = nil {
        didSet {
            if oldValue != avatarId {
                update()
            }
        }
    }
    public var avatarHexId = "" {
        didSet { if oldValue != avatarHexId { update() } }
    }

    public func setAvatar(avatarId: Int64? = nil, avatarHexId: String = "") {
        self.avatarHexId = avatarHexId
        self.avatarId = avatarId
    }
    public var small = false
    
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
        if let avatarId = avatarId ?? AvatarHexID(avatarHexId)?.legacyID, !Self.hideAll {
            image = AvatarCache.fetchImage(avatarId: avatarId, avatarHexId: avatarHexId, small: small)
        } else {
            image = nil
        }
    }
}
