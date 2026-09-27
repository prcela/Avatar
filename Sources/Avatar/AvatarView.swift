// SPDX-License-Identifier: MPL-2.0

//
//  AvatarView.swift
//  Avatar
//

import SwiftUI
import UIKit

/// Native SwiftUI avatar renderer.
///
/// The UIKit counterpart is `UIAvatarView`.
@MainActor
public struct AvatarView: View {
    private let avatarID: Int64
    private let avatarHexId: String
    private let small: Bool
    @State private var loadedImage: UIImage?
    @State private var loadedRequest: Request?

    private struct Request: Equatable {
        let key: AvatarCache.Key
        let small: Bool
        let hidden: Bool
    }

    public init(avatarID: Int64 = 0, avatarHexId: String = "", small: Bool = false) {
        self.avatarID = avatarID
        self.avatarHexId = avatarHexId
        self.small = small
    }

    public var body: some View {
        let request = Request(key: AvatarCache.key(avatarId: avatarID, avatarHexId: avatarHexId),
                              small: small, hidden: UIAvatarView.hideAll)
        let image = loadedRequest == request ? loadedImage : AvatarCache.cachedImage(for: request.key, small: small)
        return Group {
            if !request.hidden, let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.clear
            }
        }
        .task(id: request) {
            guard !request.hidden else {
                loadedImage = nil
                loadedRequest = nil
                return
            }
            let image = await AvatarCache.image(for: request.key, small: request.small)
            guard !Task.isCancelled else { return }
            loadedImage = image
            loadedRequest = request
        }
        .accessibilityHidden(true)
    }
}
