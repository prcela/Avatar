// SPDX-License-Identifier: MPL-2.0

import XCTest
import UIKit
@testable import Avatar

final class AvatarCostumeTests: XCTestCase {
    func testCostumeOptionsRoundTripWithoutChangingNeighborFields() throws {
        let options: [(Avatar.Part, AvatarHexID.Field, [AvatarSymbol])] = [
            (.Clothing, .clothing, [Avatar.Clothing.PoliceUniform, Avatar.Clothing.WorkerOveralls,
                Avatar.Clothing.GuardsUniform, Avatar.Clothing.FireUniform,
                Avatar.Clothing.NinjaSuit, Avatar.Clothing.SuperheroSuit]),
            (.Addition, .addition, Avatar.Addition.allCases.filter { $0.rawValue >= Avatar.Addition.Laptop.rawValue }),
            (.Glasses, .glasses, [Avatar.Glasses.HeroMask]),
            (.ClothLogo, .logo, [Avatar.ClothLogo.NASA])
        ]
        for (part, field, symbols) in options {
            for symbol in symbols {
                let avatar = Avatar.decompress(value: 0, hexId: "8000004cc00000000c8849616c39285a")
                var expected = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                avatar.set(part: part, symbol: symbol)
                expected[field] = symbol.rawValue
                XCTAssertEqual(avatar.compressHex(), expected.hex)
                let restored = Avatar.decompress(value: avatar.legacyAvatarId, hexId: expected.hex)
                XCTAssertEqual(restored.compressHex(), expected.hex)
                XCTAssertEqual(restored.symbolIndex(for: part), avatar.symbolIndex(for: part))
                XCTAssertNotNil(symbol.image())
            }
        }
    }

    @MainActor
    func testMasksHideCoveredFeaturesAndRestoreThemWithoutChangingSelections() throws {
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: 903052408064125018)
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        avatar.set(part: .FacialHair, symbol: Avatar.FacialHair.BeardMedium)
        avatar.set(part: .Hair, symbol: Avatar.Hair.FrenchBob)
        view.avatar = avatar
        view.layoutIfNeeded()
        for (addition, hidesMouth, hidesNose, hidesBeard) in [
            (Avatar.Addition.NinjaHood, true, true, true),
            (.PoliceCap, false, false, false),
            (.MotorcycleHelmet, true, false, true),
            (.AstronautHelmet, false, false, true),
            (.None, false, false, false)
        ] {
            avatar.set(part: .Addition, symbol: addition)
            let saved = avatar.compressHex()
            view.update()
            XCTAssertEqual(view.mouthImgView.isHidden, hidesMouth)
            XCTAssertEqual(view.noseImgView.isHidden, hidesNose)
            XCTAssertEqual(view.facialHairImgView.isHidden, hidesBeard)
            XCTAssertEqual(avatar.compressHex(), saved)
            XCTAssertEqual(avatar.hair, .FrenchBob)
        }
        avatar.set(part: .Addition, symbol: Avatar.Addition.Hood)
        view.update()
        XCTAssertTrue(view.hairView.isHidden)
        XCTAssertFalse(view.mouthImgView.isHidden)
        XCTAssertFalse(view.noseImgView.isHidden)
        XCTAssertFalse(view.facialHairImgView.isHidden)
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        view.update()
        XCTAssertFalse(view.hairView.isHidden)
        XCTAssertFalse(view.mouthImgView.isHidden)
        XCTAssertEqual(avatar.hair, .FrenchBob)
        avatar.set(part: .Addition, symbol: Avatar.Addition.NinjaHood)
        view.update()
        XCTAssertTrue(view.mouthImgView.isHidden)
        XCTAssertEqual(avatar.hair, .FrenchBob)
    }

    @MainActor
    func testRemovingHeadwearRestoresHairAndKeepsAvatarGeometry() throws {
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: 903052408064125018)
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        avatar.set(part: .Hair, symbol: Avatar.Hair.FrenchBob)
        avatar.set(part: .Hair, colorIdx: 5)
        view.avatar = avatar
        view.layoutIfNeeded()
        for bodyType in Avatar.BodyType.allCases {
            avatar.bodyType = bodyType
            view.update()
            let original = try XCTUnwrap(view.image()?.pngData())
            let hairTransform = view.hairView.transform
            let bodyTransform = view.bodyImgView.transform
            let eyeTransform = view.eyesImgView.transform
            let clothingTransform = view.clothingImgView.transform
            for headwear in Avatar.Addition.allCases where headwear.isHeadwear {
                avatar.set(part: .Addition, symbol: headwear)
                view.update()
                XCTAssertEqual(avatar.hair, .FrenchBob)
                XCTAssertEqual(avatar.hairColorIdx, 5)
                XCTAssertNotNil(view.hairView.image)
                XCTAssertNil(view.hairView.layer.mask)
                XCTAssertNil(view.additionImgView.image)
                XCTAssertEqual(view.bodyImgView.transform, bodyTransform)
                XCTAssertEqual(view.eyesImgView.transform, eyeTransform)
                XCTAssertEqual(view.clothingImgView.transform, clothingTransform)
                XCTAssertTrue(CATransform3DIsIdentity(view.layer.sublayerTransform))
                avatar.set(part: .Addition, symbol: Avatar.Addition.None)
                view.update()
                XCTAssertEqual(view.hairView.transform, hairTransform)
                XCTAssertEqual(view.image()?.pngData(), original)
            }
        }
        let originalHair = view.hairView.image?.pngData()
        avatar.set(part: .Addition, symbol: Avatar.Addition.Eyepatch)
        view.update()
        XCTAssertFalse(view.hairView.isHidden)
        XCTAssertEqual(view.hairView.image?.pngData(), originalHair)
        XCTAssertNotNil(view.additionImgView.image)
    }

    @MainActor
    func testLaptopMovesInFrontAndSwitchingAccessoriesRestoresTheirLayer() throws {
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: 903052408064125018)
        view.avatar = avatar
        view.layoutIfNeeded()
        func index(_ subview: UIView) throws -> Int { try XCTUnwrap(view.subviews.firstIndex(of: subview)) }
        avatar.set(part: .Addition, symbol: Avatar.Addition.Laptop)
        view.update()
        XCTAssertNotNil(view.additionImgView.image)
        XCTAssertGreaterThan(try index(view.additionImgView), try index(view.glassesView))
        avatar.set(part: .Addition, symbol: Avatar.Addition.Freckles)
        view.update()
        XCTAssertLessThan(try index(view.additionImgView), try index(view.clothingImgView))
        avatar.set(part: .Addition, symbol: Avatar.Addition.Laptop)
        view.update()
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        view.update()
        XCTAssertNil(view.additionImgView.image)
    }
}
