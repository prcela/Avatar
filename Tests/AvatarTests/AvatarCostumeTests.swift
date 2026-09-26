// SPDX-License-Identifier: MPL-2.0

import XCTest
import UIKit
@testable import Avatar

final class AvatarCostumeTests: XCTestCase {
    func testCostumeOptionsRoundTripWithoutChangingNeighborFields() throws {
        let options: [(Avatar.Part, AvatarHexID.Field, [AvatarSymbol])] = [
            (.Hair, .hair, [Avatar.Hair.PoliceCap, Avatar.Hair.ConstructionHelmet,
                Avatar.Hair.PilotCap,
                Avatar.Hair.MotorcycleHelmet, Avatar.Hair.AstronautHelmet,
                Avatar.Hair.NinjaHood, Avatar.Hair.WitchHat]),
            (.Clothing, .clothing, [Avatar.Clothing.PoliceUniform, Avatar.Clothing.WorkerOveralls,
                Avatar.Clothing.GuardsUniform, Avatar.Clothing.FireUniform,
                Avatar.Clothing.NinjaSuit, Avatar.Clothing.SuperheroSuit]),
            (.Addition, .addition, [Avatar.Addition.Laptop]),
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
        view.avatar = avatar
        view.layoutIfNeeded()
        for (hair, hidesMouth, hidesNose, hidesBeard) in [
            (Avatar.Hair.NinjaHood, true, true, true),
            (.PoliceCap, false, false, false),
            (.MotorcycleHelmet, true, false, true),
            (.AstronautHelmet, false, false, true),
            (.None, false, false, false)
        ] {
            avatar.set(part: .Hair, symbol: hair)
            let saved = avatar.compressHex()
            view.update()
            XCTAssertEqual(view.mouthImgView.isHidden, hidesMouth)
            XCTAssertEqual(view.noseImgView.isHidden, hidesNose)
            XCTAssertEqual(view.facialHairImgView.isHidden, hidesBeard)
            XCTAssertEqual(avatar.compressHex(), saved)
        }
        avatar.set(part: .Hair, symbol: Avatar.Hair.NinjaHood)
        avatar.set(part: .Addition, symbol: Avatar.Addition.Hood)
        view.update()
        XCTAssertTrue(view.hairView.isHidden)
        XCTAssertFalse(view.mouthImgView.isHidden)
        XCTAssertFalse(view.noseImgView.isHidden)
        XCTAssertFalse(view.facialHairImgView.isHidden)
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        view.update()
        XCTAssertFalse(view.hairView.isHidden)
        XCTAssertTrue(view.mouthImgView.isHidden)
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
