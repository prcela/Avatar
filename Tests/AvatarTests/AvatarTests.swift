// SPDX-License-Identifier: MPL-2.0

import XCTest
import UIKit
@testable import Avatar

final class AvatarTests: XCTestCase {
    private let legacy: Int64 = 903052408064125018

    func testRandomAvatarsUseValidOptionsAndRoundTrip() throws {
        for _ in 0..<128 {
            let avatar = Avatar.random()
            let hex = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
            let saved = Avatar.decompress(value: 0, hexId: hex.hex)

            XCTAssertEqual(avatar.skin, .Normal)
            XCTAssertNotEqual(hex[.facialHair], 11) // Retired braided beard.
            for part in Avatar.Part.allCases {
                XCTAssertNotNil(avatar.symbolIndex(for: part))
                XCTAssertEqual(saved.symbolIndex(for: part), avatar.symbolIndex(for: part))
                XCTAssertEqual(saved.colorIndex(for: part), avatar.colorIndex(for: part))
                if let colorIdx = avatar.colorIndex(for: part) {
                    XCTAssertTrue(part.colors().indices.contains(colorIdx))
                }
            }
            XCTAssertEqual(saved.bodyType, avatar.bodyType)
            XCTAssertEqual(saved.eyeSpacing, avatar.eyeSpacing)
            XCTAssertEqual(saved.eyeSize, avatar.eyeSize)
            XCTAssertEqual(saved.mouthWidth, avatar.mouthWidth)
            XCTAssertEqual(saved.noseSize, avatar.noseSize)
            XCTAssertEqual(saved.jerseyNumber, avatar.jerseyNumber)
            if avatar.clothing.isJersey {
                XCTAssertTrue((0...100).contains(avatar.jerseyNumber))
            } else {
                XCTAssertEqual(avatar.jerseyNumber, 0)
            }
            XCTAssertEqual(saved.compressHex(), hex.hex)
            XCTAssertEqual(hex.legacyID, avatar.legacyAvatarId)
        }
    }

    func testExpandedHairColorsSurviveSavingAndIndependentEdits() throws {
        let colors = Avatar.Part.Hair.colors()
        XCTAssertEqual(colors, Avatar.Part.FacialHair.colors())
        for sourceHex in ["", "80000000000080000c8849616c39285a"] {
            for hairIndex in 14..<colors.count {
                let beardIndex = colors.count + 13 - hairIndex
                let avatar = Avatar.decompress(value: legacy, hexId: sourceHex)
                var expected = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                avatar.set(part: .Hair, colorIdx: hairIndex)
                avatar.set(part: .FacialHair, colorIdx: beardIndex)
                expected[.hairColor] = hairIndex
                expected[.facialHairColor] = beardIndex
                XCTAssertEqual(avatar.compressHex(), expected.hex)

                let saved = Avatar.decompress(value: avatar.compress(), hexId: avatar.compressHex())
                XCTAssertEqual(saved.colorIndex(for: .Hair), hairIndex)
                XCTAssertEqual(saved.colorIndex(for: .FacialHair), beardIndex)
                XCTAssertEqual(saved.compressHex(), expected.hex)

                // Clearing one extension bit must preserve the other color and unrelated fields.
                saved.set(part: .Hair, colorIdx: 0)
                expected[.hairColor] = 0
                XCTAssertEqual(saved.compressHex(), expected.hex)
                saved.set(part: .FacialHair, colorIdx: 1)
                expected[.facialHairColor] = 1
                XCTAssertEqual(saved.compressHex(), expected.hex)
            }
        }
    }

    func testSixBitClothingPreservesOtherFieldsAndOldEncoding() throws {
        let original = try XCTUnwrap(AvatarHexID("80000000b25e00000c8849616c39285a"))
        var hex = original
        for value in 0...63 {
            hex[.clothing] = value
            XCTAssertEqual(AvatarHexID(hex.hex)?[.clothing], value)
            for field in AvatarHexID.Field.allCases where field != .clothing {
                XCTAssertEqual(hex[field], original[field])
            }
            XCTAssertEqual(hex.bodyType, original.bodyType)
            XCTAssertEqual(hex.additionColor, original.additionColor)
            XCTAssertEqual(hex.jerseyNumber, original.jerseyNumber)
            let expectedHigh = UInt64(0x80000000b25e0000) | (UInt64((value >> 4) & 1) << 8) | (UInt64((value >> 5) & 1) << 30)
            let expectedLow = (UInt64(legacy) & ~(UInt64(15) << 25)) | (UInt64(value & 15) << 25)
            XCTAssertEqual(hex.hex, String(format: "%016llx%016llx", expectedHigh, expectedLow))
            hex[.clothing] = original[.clothing]
            XCTAssertEqual(hex, original)
        }
    }

    func testNewWardrobeRoundTripsAcrossEveryBodyType() throws {
        let clothes: [Avatar.Clothing] = [.FlannelShirt, .SailorShirt, .Tracksuit, .CableKnitSweater, .Bathrobe, .SafetyVest, .KnightArmor]
        for (index, clothing) in clothes.enumerated() {
            XCTAssertEqual(clothing.rawValue, 27 + index)
            XCTAssertEqual(clothing.usesColor, [0, 2, 3, 4].contains(index))
            for bodyType in Avatar.BodyType.allCases {
                let avatar = Avatar.decompress(value: legacy)
                avatar.set(part: .Clothing, symbol: clothing)
                avatar.bodyType = bodyType
                avatar.clothingColorIdx = 13
                avatar.additionColorIdx = 23
                avatar.jerseyNumber = 100
                let hex = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                let saved = Avatar.decompress(value: 0, hexId: hex.hex)
                XCTAssertEqual(saved.clothing, clothing)
                XCTAssertEqual(saved.bodyType, bodyType)
                XCTAssertEqual(saved.clothingColorIdx, 13)
                XCTAssertEqual(saved.additionColorIdx, 23)
                XCTAssertEqual(saved.jerseyNumber, 100)
                XCTAssertEqual(saved.compressHex(), hex.hex)
                XCTAssertEqual(hex.legacyID, avatar.compress())
            }
        }
        let vest = Avatar.decompress(value: 0, hexId: "00000000725e00000c8849616039285a")
        XCTAssertEqual(vest.clothing, .SafetyVest)
        vest.set(part: .Clothing, symbol: Avatar.Clothing.KnightArmor)
        XCTAssertEqual(vest.compressHex(), "00000000725e00000c8849616239285a")
    }

    func testUnknownSixBitClothingSurvivesUntilExplicitlyReplaced() throws {
        var hex = try XCTUnwrap(AvatarHexID("80000000725e01000c8849617e39285a"))
        let avatar = Avatar.decompress(value: 0, hexId: hex.hex)
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        avatar.bodyType = .slim
        hex.bodyType = 1
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        avatar.set(part: .Clothing, symbol: Avatar.Clothing.Shirt)
        hex[.clothing] = 0
        XCTAssertEqual(avatar.compressHex(), hex.hex)
    }

    func testNationalJerseysUseExtendedClothingFieldWithoutChangingNeighbors() throws {
        let jerseys: [Avatar.Clothing] = [.CroatiaJersey, .SerbiaJersey, .ArgentinaJersey, .PortugalJersey, .FranceJersey]
        let original = AvatarHexID(legacyID: legacy)
        for (index, jersey) in jerseys.enumerated() {
            XCTAssertEqual(jersey.rawValue, 16 + index)
            XCTAssertTrue(jersey.isJersey)
            XCTAssertFalse(jersey.usesColor)
            for number in [0, 1, 8, 11, 100] {
                let avatar = Avatar.decompress(value: legacy)
                avatar.set(part: .Clothing, symbol: jersey)
                avatar.jerseyNumber = number
                let hex = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                XCTAssertEqual(hex[.clothing], jersey.rawValue)
                for field in AvatarHexID.Field.allCases where field != .clothing {
                    XCTAssertEqual(hex[field], original[field])
                }
                let saved = Avatar.decompress(value: 0, hexId: hex.hex)
                XCTAssertEqual(saved.clothing, jersey)
                XCTAssertEqual(saved.jerseyNumber, number)
                XCTAssertEqual(saved.compressHex(), hex.hex)
                XCTAssertEqual(avatar.compress(), avatar.legacyAvatarId)
            }
        }
    }

    func testNationalJerseyDefaultsOnlyApplyWhenChangingClothing() {
        let avatar = Avatar.decompress(value: legacy)
        let defaults: [(Avatar.Clothing, Int)] = [(.ArgentinaJersey, 10), (.PortugalJersey, 7), (.FranceJersey, 10)]
        for (jersey, number) in defaults {
            avatar.set(part: .Clothing, symbol: jersey)
            XCTAssertEqual(avatar.jerseyNumber, number + 1)
            avatar.jerseyNumber = 24
            avatar.set(part: .Clothing, symbol: jersey)
            XCTAssertEqual(avatar.jerseyNumber, 24)
            let saved = Avatar.decompress(value: 0, hexId: avatar.compressHex())
            XCTAssertEqual(saved.jerseyNumber, 24)
        }
        avatar.set(part: .Clothing, symbol: Avatar.Clothing.CroatiaJersey)
        XCTAssertEqual(avatar.jerseyNumber, 24)
        avatar.set(part: .Clothing, symbol: Avatar.Clothing.SerbiaJersey)
        XCTAssertEqual(avatar.jerseyNumber, 24)
    }

    func testSharedAccessoryHeaderFixture() {
        var hex = AvatarHexID(legacyID: legacy)
        hex.bodyType = 4
        hex.additionColor = 23
        hex.jerseyNumber = 100
        XCTAssertEqual(hex.hex, "00000000325e00000c8849616c39285a")
    }

    func testExpandedAccessoriesKeepLegacyFieldsAndNewOptions() {
        let avatar = Avatar.decompress(value: legacy)
        avatar.addition = .Scarf
        avatar.additionColorIdx = 23
        avatar.clothing = .SportsJersey
        avatar.jerseyNumber = 100
        let saved = Avatar.decompress(value: 0, hexId: avatar.compressHex())
        XCTAssertEqual(saved.addition, .Scarf)
        XCTAssertEqual(saved.additionColorIdx, 23)
        XCTAssertEqual(saved.jerseyNumber, 100)
        XCTAssertEqual(saved.clothing, .SportsJersey)
        XCTAssertEqual(saved.facialHairColorIdx, avatar.facialHairColorIdx)
        XCTAssertEqual(avatar.compress(), avatar.legacyAvatarId)
    }

    func testReservedAccessoryOptionsSurviveUnrelatedEdits() throws {
        var hex = try XCTUnwrap(AvatarHexID("80000000400000000c8849616c39285a"))
        hex.additionColor = 31
        hex.jerseyNumber = 127
        let avatar = Avatar.decompress(value: 0, hexId: hex.hex)
        XCTAssertEqual(avatar.additionColorIdx, 0)
        XCTAssertEqual(avatar.jerseyNumber, 0)
        avatar.bodyType = .slim
        hex.bodyType = 1
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        avatar.additionColorIdx = 0
        avatar.jerseyNumber = 0
        hex.additionColor = 0
        hex.jerseyNumber = 0
        XCTAssertEqual(avatar.compressHex(), hex.hex)
    }

    func testFirstExtendedHairRoundTripsWithoutChangingLegacyNeighbors() throws {
        let avatar = Avatar.decompress(value: legacy)
        avatar.set(part: .Hair, symbol: Avatar.Hair.Einstein)
        let hex = avatar.compressHex()
        XCTAssertEqual(hex, "00000000000000400c8849016c39285a")
        let saved = Avatar.decompress(value: 0, hexId: hex)
        XCTAssertEqual(saved.hair, .Einstein)
        XCTAssertEqual(saved.compressHex(), hex)

        let expectedLegacy = legacy & ~(Int64(63) << 33)
        XCTAssertEqual(avatar.compress(), expectedLegacy)
        XCTAssertEqual(saved.legacyAvatarId, expectedLegacy)
        XCTAssertEqual(Avatar.decompress(value: expectedLegacy).hair, .None)
        let encoded = try XCTUnwrap(AvatarHexID(hex))
        let original = AvatarHexID(legacyID: legacy)
        for field in AvatarHexID.Field.allCases where field != .hair {
            XCTAssertEqual(encoded[field], original[field])
        }
    }

    func testSantaBeardRoundTripsWithoutReusingRetiredIdentifier() throws {
        let avatar = Avatar.decompress(value: legacy)
        avatar.set(part: .FacialHair, symbol: Avatar.FacialHair.BeardSanta)
        let expectedLegacy = (legacy & ~(Int64(15) << 16)) | (Int64(12) << 16)
        XCTAssertEqual(avatar.compress(), expectedLegacy)
        XCTAssertEqual(Avatar.decompress(value: expectedLegacy).facialHair, .BeardSanta)
        let hex = avatar.compressHex()
        XCTAssertEqual(hex, "00000000000000000c8849616c3c285a")
        XCTAssertEqual(Avatar.decompress(value: 0, hexId: hex).facialHair, .BeardSanta)
        XCTAssertNil(Avatar.FacialHair(rawValue: 11))
        let encoded = try XCTUnwrap(AvatarHexID(hex))
        let original = AvatarHexID(legacyID: legacy)
        for field in AvatarHexID.Field.allCases where field != .facialHair {
            XCTAssertEqual(encoded[field], original[field])
        }
    }

    func testEmptyAndInvalidHexUseLegacyAppearance() {
        for hex in ["", "bad", String(repeating: "g", count: 32)] {
            let avatar = Avatar.decompress(value: legacy, hexId: hex)
            XCTAssertEqual(avatar.compress(), legacy)
            XCTAssertEqual(avatar.bodyType, .normal)
        }
    }

    func testSharedHexFixtureAndBodyOnlyEdit() {
        let avatar = Avatar.decompress(value: 0, hexId: "00000000000080000c8849616c39285a")
        XCTAssertEqual(avatar.hair, .CowboyHat)
        XCTAssertEqual(avatar.bodyType, .slim)
        XCTAssertEqual(avatar.legacyAvatarId, legacy)
        avatar.bodyType = .broad
        XCTAssertEqual(avatar.compressHex(), "00000000000180000c8849616c39285a")
        XCTAssertEqual(avatar.legacyAvatarId, legacy)
    }

    func testUnknownFieldsAndReservedBitsSurviveUnrelatedEdits() throws {
        var future = try XCTUnwrap(AvatarHexID("800000000003ffff0c8849616c39285a"))
        future[.hair] = 100
        future[.hairColor] = 30
        let avatar = Avatar.decompress(value: 0, hexId: future.hex)
        XCTAssertEqual(avatar.hair, .None)
        XCTAssertEqual(avatar.hairColorIdx, 0)
        XCTAssertEqual(avatar.compressHex(), future.hex)
        avatar.bodyType = .slim
        future.bodyType = 1
        XCTAssertEqual(avatar.compressHex(), future.hex)
        avatar.set(part: .Hair, symbol: Avatar.Hair.None)
        future[.hair] = 0
        XCTAssertEqual(avatar.compressHex(), future.hex)
    }

    func testEveryFieldHasOneExtraBitWithoutChangingNeighbors() throws {
        let widths = [1, 4, 5, 5, 4, 5, 6, 4, 4, 5, 4, 4, 4, 3, 5]
        for (index, field) in AvatarHexID.Field.allCases.enumerated() {
            var value = try XCTUnwrap(AvatarHexID("80000000000400008000000000000000"))
            let maxValue = (1 << (widths[index] + 1)) - 1
            value[field] = maxValue
            XCTAssertEqual(value[field], maxValue)
            XCTAssertEqual(value.bodyType, 0)
            for other in AvatarHexID.Field.allCases where other != field {
                XCTAssertEqual(value[other], 0)
            }
            value[field] = 0
            XCTAssertEqual(value.hex, "80000000000400008000000000000000")
        }
    }

    func testCanonicalHexAndSignedLegacyRoundTrip() {
        XCTAssertEqual(AvatarHexID(String(repeating: "F", count: 32))?.hex, String(repeating: "f", count: 32))
        XCTAssertEqual(AvatarHexID(legacyID: -1).hex, "0000000000000000ffffffffffffffff")
        XCTAssertNil(AvatarHexID(" 00000000000000000000000000000000"))
        XCTAssertNil(AvatarHexID("0x000000000000000000000000000000"))
    }

    func testFiveBodyLevelsShareTheSameLegacyAppearance() {
        let types: [Avatar.BodyType] = [.normal, .slim, .verySlim, .broad, .veryBroad]
        let words = ["0000000000000000", "0000000000008000", "0000000000010000", "0000000000018000", "0000000000020000"]
        let scales: [CGFloat] = [1, 0.85, 0.70, 1.15, 1.30]
        for (index, type) in types.enumerated() {
            let hex = words[index] + "0c8849616c39285a"
            let avatar = Avatar.decompress(value: 0, hexId: hex)
            XCTAssertEqual(type.rawValue, index)
            XCTAssertEqual(avatar.bodyType, type)
            XCTAssertEqual(avatar.bodyType.scaleX, scales[index], accuracy: 0.0001)
            XCTAssertEqual(avatar.legacyAvatarId, legacy)
            XCTAssertEqual(avatar.compressHex(), hex)
            avatar.bodyType = .normal
            XCTAssertEqual(avatar.compressHex(), words[0] + "0c8849616c39285a")
        }
    }

    func testReservedBodyValuesPreserveNeighborBits() throws {
        for value in 5...7 {
            var hex = try XCTUnwrap(AvatarHexID("80000000000440000c8849616c39285a"))
            hex.bodyType = value
            let avatar = Avatar.decompress(value: 0, hexId: hex.hex)
            XCTAssertEqual(avatar.bodyType, .normal)
            XCTAssertEqual(avatar.compressHex(), hex.hex)
            avatar.bodyType = .normal
            XCTAssertEqual(avatar.compressHex(), "80000000000440000c8849616c39285a")
        }
    }
}

extension AvatarTests {
    func testAllFaceProportionsRoundTripWithoutChangingOtherFields() throws {
        for source in ["00000000000000000c8849616c39285a", "80000000725e01000c8849617e39285a"] {
            let original = try XCTUnwrap(AvatarHexID(source))
            for spacing in Avatar.EyeSpacing.allCases {
                for eyeSize in Avatar.FeatureSize.allCases {
                    for mouthWidth in Avatar.FeatureSize.allCases {
                        for noseSize in Avatar.FeatureSize.allCases {
                            let avatar = Avatar.decompress(value: legacy, hexId: source)
                            avatar.eyeSpacing = spacing
                            avatar.eyeSize = eyeSize
                            avatar.mouthWidth = mouthWidth
                            avatar.noseSize = noseSize
                            let encoded = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                            XCTAssertEqual(encoded.legacyID, original.legacyID)
                            for field in AvatarHexID.Field.allCases {
                                XCTAssertEqual(encoded[field], original[field])
                            }
                            XCTAssertEqual(encoded.bodyType, original.bodyType)
                            XCTAssertEqual(encoded.additionColor, original.additionColor)
                            XCTAssertEqual(encoded.jerseyNumber, original.jerseyNumber)
                            let restored = Avatar.decompress(value: 0, hexId: encoded.hex)
                            XCTAssertEqual(restored.eyeSpacing, spacing)
                            XCTAssertEqual(restored.eyeSize, eyeSize)
                            XCTAssertEqual(restored.mouthWidth, mouthWidth)
                            XCTAssertEqual(restored.noseSize, noseSize)
                            XCTAssertEqual(restored.compressHex(), encoded.hex)
                        }
                    }
                }
            }
        }
    }

    func testLegacyFaceProportionsAndResetPreserveIdentity() {
        let avatar = Avatar.decompress(value: legacy)
        let original = avatar.compressHex()
        XCTAssertEqual(avatar.eyeSpacing, .normal)
        XCTAssertEqual(avatar.eyeSize, .normal)
        XCTAssertEqual(avatar.mouthWidth, .normal)
        XCTAssertEqual(avatar.noseSize, .normal)
        avatar.eyeSpacing = .wide
        avatar.eyeSize = .large
        avatar.mouthWidth = .small
        avatar.noseSize = .large
        XCTAssertNotEqual(avatar.compressHex(), original)
        XCTAssertEqual(avatar.legacyAvatarId, legacy)
        avatar.eyeSpacing = .normal
        avatar.eyeSize = .normal
        avatar.mouthWidth = .normal
        avatar.noseSize = .normal
        XCTAssertEqual(avatar.compressHex(), original)
    }

    func testSharedFaceProportionFixtureAndClothingBit() throws {
        var hex = AvatarHexID(legacyID: legacy)
        hex[.clothing] = 38
        hex.eyeSpacing = 1
        hex.eyeSize = 2
        hex.mouthWidth = 1
        hex.noseSize = 2
        XCTAssertEqual(hex.hex, "0000004cc00000000c8849616c39285a")
        let avatar = Avatar.decompress(value: 0, hexId: hex.hex)
        XCTAssertEqual(avatar.eyeSpacing, .narrow)
        XCTAssertEqual(avatar.eyeSize, .large)
        XCTAssertEqual(avatar.mouthWidth, .small)
        XCTAssertEqual(avatar.noseSize, .large)
        // An unsupported clothing style must also survive an unrelated face edit.
        avatar.eyeSpacing = .wide
        hex.eyeSpacing = 2
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        XCTAssertEqual(AvatarHexID(avatar.compressHex())?[.clothing], 38)
    }

    func testReservedFaceProportionsSurviveUntilExplicitlyReplaced() throws {
        var hex = try XCTUnwrap(AvatarHexID("80000000725e01000c8849617e39285a"))
        hex.eyeSpacing = 3
        hex.eyeSize = 3
        hex.mouthWidth = 3
        hex.noseSize = 3
        let avatar = Avatar.decompress(value: 0, hexId: hex.hex)
        XCTAssertEqual(avatar.eyeSpacing, .normal)
        XCTAssertEqual(avatar.eyeSize, .normal)
        XCTAssertEqual(avatar.mouthWidth, .normal)
        XCTAssertEqual(avatar.noseSize, .normal)
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        avatar.set(part: .Hair, colorIdx: 2)
        hex[.hairColor] = 2
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        avatar.eyeSize = .normal
        hex.eyeSize = 0
        XCTAssertEqual(avatar.compressHex(), hex.hex)
        avatar.eyeSpacing = .normal
        hex.eyeSpacing = 0
        avatar.mouthWidth = .normal
        hex.mouthWidth = 0
        avatar.noseSize = .normal
        hex.noseSize = 0
        XCTAssertEqual(avatar.compressHex(), hex.hex)
    }

    @MainActor
    func testResetFaceProportionsRestoresRenderedAvatar() throws {
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: legacy)
        view.avatar = avatar
        view.layoutIfNeeded()
        view.update()
        let original = try XCTUnwrap(view.image()?.pngData())
        avatar.eyeSpacing = .wide
        avatar.eyeSize = .large
        avatar.mouthWidth = .small
        avatar.noseSize = .large
        view.update()
        XCTAssertNotEqual(view.image()?.pngData(), original)
        avatar.eyeSpacing = .normal
        avatar.eyeSize = .normal
        avatar.mouthWidth = .normal
        avatar.noseSize = .normal
        view.update()
        XCTAssertEqual(view.image()?.pngData(), original)
    }

    @MainActor
    func testEyeSizeKeepsEachEyeCenterAndDoesNotClipOuterEdges() {
        let pair = AvatarEyePairView(frame: CGRect(x: 0, y: 0, width: 112, height: 44))
        for body in Avatar.BodyType.allCases {
            for spacing in Avatar.EyeSpacing.allCases {
                let offset = (body.scaleX - 1) * 20 + spacing.offset
                for size in Avatar.FeatureSize.allCases {
                    pair.update(image: nil, offset: offset, scale: size.eyeScale)
                    XCTAssertFalse(pair.clipsToBounds)
                    for (index, half) in pair.subviews.enumerated() {
                        let center = half.convert(CGPoint(x: half.bounds.midX, y: half.bounds.midY), to: pair)
                        XCTAssertEqual(center.x, index == 0 ? 28 - offset : 84 + offset, accuracy: 0.001)
                        XCTAssertEqual(center.y, 22, accuracy: 0.001)
                        XCTAssertEqual(half.frame.height, 44 * size.eyeScale, accuracy: 0.001)
                        XCTAssertTrue(half.clipsToBounds)
                    }
                }
            }
        }
    }
}

extension AvatarTests {
    func testBodyHairRoundTripsUsingExistingHairColorWithoutChangingOtherFields() throws {
        for color in Avatar.Part.Hair.colors().indices {
            let avatar = Avatar.decompress(value: 0, hexId: "8000004cc00000000c8849616c39285a")
            var expected = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
            avatar.set(part: .Addition, symbol: Avatar.Addition.BodyHair)
            avatar.set(part: .Hair, colorIdx: color)
            expected[.addition] = 24
            expected[.hairColor] = color
            XCTAssertEqual(avatar.compressHex(), expected.hex)
            let restored = Avatar.decompress(value: avatar.legacyAvatarId, hexId: expected.hex)
            XCTAssertEqual(restored.addition, .BodyHair)
            XCTAssertFalse(restored.addition.usesColor)
            XCTAssertEqual(restored.hairColorIdx, color)
            XCTAssertEqual(restored.additionColorIdx, expected.additionColor)
            XCTAssertEqual(restored.compressHex(), expected.hex)
        }
    }

    @MainActor
    func testBodyHairLeavesFaceAndNeckUnchangedAndFollowsHairColor() throws {
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: legacy)
        avatar.skin = .Normal
        avatar.set(part: .Clothing, symbol: Avatar.Clothing.Undershirt)
        avatar.set(part: .Hair, symbol: Avatar.Hair.None)
        view.avatar = avatar
        view.layoutIfNeeded()
        func protectedPixels() throws -> Data {
            let image = try XCTUnwrap(view.bodyImgView.image)
            let crop = try XCTUnwrap(image.cgImage?.cropping(to: CGRect(
                x: 0, y: 0, width: image.size.width * image.scale, height: 166 * image.scale)))
            return try XCTUnwrap(UIImage(cgImage: crop).pngData())
        }
        for body in Avatar.BodyType.allCases {
            avatar.bodyType = body
            avatar.set(part: .Addition, symbol: Avatar.Addition.None)
            view.update()
            let original = try XCTUnwrap(view.bodyImgView.image?.pngData())
            let protected = try protectedPixels()
            avatar.set(part: .Addition, symbol: Avatar.Addition.BodyHair)
            avatar.set(part: .Hair, colorIdx: 0)
            view.update()
            XCTAssertNil(view.additionImgView.image)
            XCTAssertEqual(try protectedPixels(), protected)
            let dark = try XCTUnwrap(view.bodyImgView.image?.pngData())
            XCTAssertNotEqual(dark, original)
            avatar.set(part: .Hair, colorIdx: 5)
            view.update()
            XCTAssertEqual(try protectedPixels(), protected)
            XCTAssertNotEqual(view.bodyImgView.image?.pngData(), dark)
            avatar.set(part: .Addition, symbol: Avatar.Addition.None)
            view.update()
            XCTAssertEqual(view.bodyImgView.image?.pngData(), original)
        }
    }

    func testHoodRoundTripsWithColorAndPreservesOtherFields() throws {
        for body in Avatar.BodyType.allCases {
            for color in Avatar.Part.Addition.colors().indices {
                let avatar = Avatar.decompress(value: 0, hexId: "8000004cc00000000c8849616c39285a")
                var expected = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                avatar.set(part: .Addition, symbol: Avatar.Addition.Hood)
                avatar.set(part: .Addition, colorIdx: color)
                avatar.bodyType = body
                expected[.addition] = 23
                expected.additionColor = color
                expected.bodyType = body.rawValue
                XCTAssertEqual(avatar.compressHex(), expected.hex)
                let restored = Avatar.decompress(value: avatar.legacyAvatarId, hexId: expected.hex)
                XCTAssertEqual(restored.addition, .Hood)
                XCTAssertTrue(restored.addition.usesColor)
                XCTAssertEqual(restored.additionColorIdx, color)
                XCTAssertEqual(restored.compressHex(), expected.hex)
            }
        }
    }

    @MainActor
    func testRemovingHoodRestoresHairAndOriginalHoodie() throws {
        let view = try XCTUnwrap(Bundle.module.loadNibNamed("EditAvatarView", owner: nil)?.first as? EditAvatarView)
        let avatar = Avatar.decompress(value: legacy)
        avatar.set(part: .Addition, symbol: Avatar.Addition.None)
        avatar.set(part: .Clothing, symbol: Avatar.Clothing.Hoodie)
        view.avatar = avatar
        view.layoutIfNeeded()
        for hair in [Avatar.Hair.LongWavy, .CowboyHat] {
            avatar.set(part: .Hair, symbol: hair)
            view.update()
            let original = try XCTUnwrap(view.image()?.pngData())
            avatar.set(part: .Addition, symbol: Avatar.Addition.Hood)
            view.update()
            XCTAssertTrue(view.hairView.isHidden)
            XCTAssertEqual(avatar.hair, hair)
            XCTAssertNotNil(view.additionImgView.image)
            XCTAssertNotEqual(view.image()?.pngData(), original)
            avatar.set(part: .Addition, symbol: Avatar.Addition.None)
            view.update()
            XCTAssertFalse(view.hairView.isHidden)
            XCTAssertEqual(avatar.hair, hair)
            XCTAssertEqual(view.image()?.pngData(), original)
        }
    }
}
