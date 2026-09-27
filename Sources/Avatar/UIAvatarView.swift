// SPDX-License-Identifier: MPL-2.0

//
//  UIAvatarView.swift
//  Yamb
//
//  Created by Kresimir Prcela on 27.12.2021..
//  Copyright © 2021 Rika Omega Rika.
//

import Foundation
import UIKit

public class UIAvatarView: UIImageView {
    public static var hideAll = false
    public static var enableBots = false
    public var avatarId: Int64? = nil {
        didSet {
            if oldValue != avatarId && !settingAvatar {
                update()
            }
        }
    }
    public var avatarHexId = "" {
        didSet { if oldValue != avatarHexId && !settingAvatar { update() } }
    }

    private var settingAvatar = false
    private var imageRequest = UUID()

    public func setAvatar(avatarId: Int64? = nil, avatarHexId: String = "") {
        settingAvatar = true
        self.avatarHexId = avatarHexId
        self.avatarId = avatarId
        settingAvatar = false
        update()
    }
    public var small = false {
        didSet { if oldValue != small { update() } }
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
        let request = UUID()
        imageRequest = request
        if let avatarId = avatarId ?? AvatarHexID(avatarHexId)?.legacyID, !Self.hideAll {
            if let cached = AvatarCache.cachedImage(avatarId: avatarId, avatarHexId: avatarHexId, small: small) {
                image = cached
                return
            }
            image = nil
            AvatarCache.loadImage(avatarId: avatarId, avatarHexId: avatarHexId, small: small) { [weak self] image in
                guard let self, self.imageRequest == request, !Self.hideAll else { return }
                self.image = image
            }
        } else {
            image = nil
        }
    }
}
