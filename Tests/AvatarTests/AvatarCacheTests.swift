// SPDX-License-Identifier: MPL-2.0

import XCTest
import UIKit
@testable import Avatar

final class AvatarCacheTests: XCTestCase {
    private let legacy: Int64 = 903052408064125018

    @MainActor
    func testMissReturnsBeforeDeliveryAndConcurrentRequestsShareImages() async {
        AvatarCache.didReceiveMemoryWarning()
        var returned = false
        var first: UIImage?
        var second: UIImage?
        var thumbnail: UIImage?
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            AvatarCache.loadImage(avatarId: legacy, small: false) { image in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertTrue(returned)
                first = image
            }
            AvatarCache.loadImage(avatarId: legacy, small: false) { second = $0 }
            AvatarCache.loadImage(avatarId: legacy, small: true) {
                thumbnail = $0
                continuation.resume()
            }
            XCTAssertNil(first)
            XCTAssertNil(AvatarCache.cachedImage(avatarId: legacy, small: false))
            returned = true
        }
        XCTAssertNotNil(first)
        XCTAssertTrue(first === second)
        XCTAssertTrue(first === AvatarCache.cachedImage(avatarId: legacy, small: false))
        XCTAssertTrue(thumbnail === AvatarCache.cachedImage(avatarId: legacy, small: true))
        XCTAssertEqual(first?.size, CGSize(width: 264, height: 280))
        XCTAssertEqual(thumbnail?.size, CGSize(width: 30, height: 30))
    }

    @MainActor
    func testMemoryWarningDuringRenderingDeliversWithoutRepopulatingCache() async {
        AvatarCache.didReceiveMemoryWarning()
        let image: UIImage = await withCheckedContinuation { continuation in
            AvatarCache.loadImage(avatarId: legacy, small: false) { continuation.resume(returning: $0) }
            AvatarCache.didReceiveMemoryWarning()
        }
        XCTAssertEqual(image.size, CGSize(width: 264, height: 280))
        XCTAssertNil(AvatarCache.cachedImage(avatarId: legacy, small: false))
        XCTAssertNil(AvatarCache.cachedImage(avatarId: legacy, small: true))
        _ = await AvatarCache.image(avatarId: legacy, small: false)
        XCTAssertNotNil(AvatarCache.cachedImage(avatarId: legacy, small: false))
    }

    @MainActor
    func testHexIdentityAndBotSettingArePartOfTheCacheKey() async {
        AvatarCache.didReceiveMemoryWarning()
        let previous = UIAvatarView.enableBots
        defer { UIAvatarView.enableBots = previous }
        let avatar = Avatar.decompress(value: legacy)
        avatar.skin = .Bot
        let hex = avatar.compressHex()
        UIAvatarView.enableBots = false
        let human = await AvatarCache.image(avatarId: 0, avatarHexId: hex, small: false)
        let same = await AvatarCache.image(avatarId: 1234, avatarHexId: hex.uppercased(), small: false)
        XCTAssertTrue(human === same)
        UIAvatarView.enableBots = true
        XCTAssertNil(AvatarCache.cachedImage(avatarId: 0, avatarHexId: hex, small: false))
        let bot = await AvatarCache.image(avatarId: 0, avatarHexId: hex, small: false)
        XCTAssertNotEqual(human.pngData(), bot.pngData())
    }

    @MainActor
    func testReusedOrClearedImageViewIgnoresOldResults() async {
        AvatarCache.didReceiveMemoryWarning()
        let previous = UIAvatarView.hideAll
        UIAvatarView.hideAll = false
        defer { UIAvatarView.hideAll = previous }
        let view = UIAvatarView()
        view.setAvatar(avatarId: legacy)
        view.setAvatar(avatarId: 1234)
        _ = await AvatarCache.image(avatarId: legacy, small: false)
        let replacement = await AvatarCache.image(avatarId: 1234, small: false)
        XCTAssertTrue(view.image === replacement)

        AvatarCache.didReceiveMemoryWarning()
        view.setAvatar(avatarId: legacy)
        view.setAvatar()
        _ = await AvatarCache.image(avatarId: legacy, small: false)
        XCTAssertNil(view.image)
    }
}
