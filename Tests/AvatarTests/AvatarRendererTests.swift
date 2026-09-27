// SPDX-License-Identifier: MPL-2.0

import XCTest
import UIKit
@testable import Avatar

final class AvatarRendererTests: XCTestCase {
    @MainActor
    func testBitmapRendererMatchesEditorAcrossBodiesHairAndCostumes() throws {
        let previous = UIAvatarView.enableBots
        UIAvatarView.enableBots = true
        defer { UIAvatarView.enableBots = previous }
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: 903052408064125018)
        view.avatar = avatar
        view.layoutIfNeeded()

        func compare(_ label: String) throws {
            view.update()
            let expected = try pixels(XCTUnwrap(view.image()))
            let actual = try pixels(AvatarRenderer(avatar: avatar, enableBots: true).image(scale: 2))
            XCTAssertEqual(actual.count, expected.count)
            let difference = zip(actual, expected).reduce(0) { $0 + abs(Int($1.0) - Int($1.1)) }
            // CALayer and bitmap drawing can antialias edges differently.
            XCTAssertLessThan(Double(difference) / Double(expected.count * 255), 0.025, label)
        }

        for body in Avatar.BodyType.allCases {
            avatar.bodyType = body
            for hair in [Avatar.Hair.LongWavy, .ShavedSides, .HighPonytail, .FrenchBob] {
                avatar.set(part: .Hair, symbol: hair)
                avatar.set(part: .Addition, symbol: Avatar.Addition.None)
                try compare("body=\(body), hair=\(hair)")
            }
        }
        avatar.bodyType = .normal
        for addition in Avatar.Addition.allCases {
            avatar.set(part: .Addition, symbol: addition)
            try compare("addition=\(addition)")
        }
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        for spacing in Avatar.EyeSpacing.allCases {
            avatar.eyeSpacing = spacing
            avatar.eyeSize = .large
            avatar.mouthWidth = .small
            avatar.noseSize = .large
            avatar.set(part: .Glasses, symbol: Avatar.Glasses.Monocle)
            avatar.set(part: .FacialHair, symbol: Avatar.FacialHair.BeardSanta)
            try compare("spacing=\(spacing), enlarged features and tall beard")
        }
        avatar.skin = .Bot
        try compare("bot")
    }

    private func pixels(_ image: UIImage) throws -> [UInt8] {
        let source = try XCTUnwrap(image.cgImage)
        let width = 264, height = 280
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        try pixels.withUnsafeMutableBytes { bytes in
            let context = try XCTUnwrap(CGContext(data: bytes.baseAddress, width: width, height: height,
                bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue))
            context.draw(source, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        return pixels
    }
}
