//
//  AvatarView.swift
//  Avatar
//

import SwiftUI
import UIKit

/// Native SwiftUI avatar renderer.
///
/// The UIKit counterpart is `UIAvatarView`.
public struct AvatarView: View {
    private let avatarID: Int64
    private let avatarHexId: String
    private let small: Bool

    public init(avatarID: Int64 = 0, avatarHexId: String = "", small: Bool = false) {
        self.avatarID = avatarID
        self.avatarHexId = avatarHexId
        self.small = small
    }

    public var body: some View {
        Group {
            if !UIAvatarView.hideAll,
               let image = AvatarCache.fetchImage(avatarId: avatarID, avatarHexId: avatarHexId, small: small) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear
            }
        }
        .accessibilityHidden(true)
    }
}
