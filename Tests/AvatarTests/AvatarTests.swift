import XCTest
@testable import Avatar

final class AvatarTests: XCTestCase {
    private let legacy: Int64 = 903052408064125018

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
