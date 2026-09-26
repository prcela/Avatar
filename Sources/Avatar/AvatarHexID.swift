// SPDX-License-Identifier: MPL-2.0

import Foundation

/// 128-bit avatar identity: extension word followed by the unchanged legacy word.
public struct AvatarHexID: Equatable, Hashable {
    public enum Field: Int, CaseIterable {
        case skin, skinColor, eyes, mouth, eyebrow, glasses, hair, hairColor
        case clothing, clothingColor, facialHair, facialHairColor, addition, nose, logo

        fileprivate var width: Int { [1, 4, 5, 5, 4, 5, 6, 4, 4, 5, 4, 4, 4, 3, 5][rawValue] }
        fileprivate var offset: Int { [62, 58, 53, 48, 44, 39, 33, 29, 25, 20, 16, 12, 8, 5, 0][rawValue] }
    }

    private var high: UInt64
    private var low: UInt64

    /// High-word bit 30 is clothing bit 5; the existing clothing extension stays at bit 8.
    private static let clothingExtensionOffset = 30
    /// High-word bit 44 is accessory bit 5, after the glasses-color field.
    private static let additionExtensionOffset = 44

    public init(legacyID: Int64) {
        high = 0
        low = UInt64(bitPattern: legacyID)
    }

    public init?(_ hex: String) {
        guard hex.utf8.count == 32,
              hex.utf8.allSatisfy({ (48...57).contains($0) || (65...70).contains($0) || (97...102).contains($0) }),
              let high = UInt64(hex.prefix(16), radix: 16),
              let low = UInt64(hex.suffix(16), radix: 16) else { return nil }
        self.high = high
        self.low = low
    }

    public var hex: String { String(format: "%016llx%016llx", high, low) }
    public var legacyID: Int64 { Int64(bitPattern: low) }

    public subscript(field: Field) -> Int {
        get {
            let mask = (UInt64(1) << field.width) - 1
            let value = Int((low >> field.offset) & mask) | (Int((high >> field.rawValue) & 1) << field.width)
            switch field {
            case .clothing: return value | (Int((high >> Self.clothingExtensionOffset) & 1) << 5)
            case .addition: return value | (Int((high >> Self.additionExtensionOffset) & 1) << 5)
            default: return value
            }
        }
        set {
            let extraWidth = field == .clothing || field == .addition ? 2 : 1
            precondition(newValue >= 0 && newValue < (1 << (field.width + extraWidth)))
            let mask = (UInt64(1) << field.width) - 1
            low = (low & ~(mask << field.offset)) | ((UInt64(newValue) & mask) << field.offset)
            let extensionMask = UInt64(1) << field.rawValue
            high = (high & ~extensionMask) | (UInt64((newValue >> field.width) & 1) << field.rawValue)
            if field == .clothing {
                let clothingMask = UInt64(1) << Self.clothingExtensionOffset
                high = (high & ~clothingMask) | (UInt64((newValue >> 5) & 1) << Self.clothingExtensionOffset)
            } else if field == .addition {
                let additionMask = UInt64(1) << Self.additionExtensionOffset
                high = (high & ~additionMask) | (UInt64((newValue >> 5) & 1) << Self.additionExtensionOffset)
            }
        }
    }

    /// High-word bits 15...17: normal, slim, very slim, broad, very broad; 5...7 reserved.
    public var bodyType: Int {
        get { Int((high >> 15) & 7) }
        set {
            precondition((0...7).contains(newValue))
            high = (high & ~(UInt64(7) << 15)) | (UInt64(newValue) << 15)
        }
    }

    /// High-word bits 18...22; palette indices 26...31 are reserved.
    public var additionColor: Int {
        get { Int((high >> 18) & 31) }
        set {
            precondition((0...31).contains(newValue))
            high = (high & ~(UInt64(31) << 18)) | (UInt64(newValue) << 18)
        }
    }

    /// High-word bits 23...29: 0 = no number, 1...100 = jersey numbers 0...99.
    public var jerseyNumber: Int {
        get { Int((high >> 23) & 127) }
        set {
            precondition((0...127).contains(newValue))
            high = (high & ~(UInt64(127) << 23)) | (UInt64(newValue) << 23)
        }
    }

    // Two bits per proportion: 0 = unchanged, 1 = small/narrow, 2 = large/wide.
    // Value 3 is reserved and must survive edits to other fields.
    public var eyeSpacing: Int {
        get { proportion(at: 31) }
        set { setProportion(newValue, at: 31) }
    }

    public var eyeSize: Int {
        get { proportion(at: 33) }
        set { setProportion(newValue, at: 33) }
    }

    public var mouthWidth: Int {
        get { proportion(at: 35) }
        set { setProportion(newValue, at: 35) }
    }

    public var noseSize: Int {
        get { proportion(at: 37) }
        set { setProportion(newValue, at: 37) }
    }

    /// High-word bits 39...43; zero keeps the model's original frame color.
    public var glassesColor: Int {
        get { Int((high >> 39) & 31) }
        set {
            precondition((0...31).contains(newValue))
            high = (high & ~(UInt64(31) << 39)) | (UInt64(newValue) << 39)
        }
    }

    private func proportion(at offset: Int) -> Int {
        Int((high >> offset) & 3)
    }

    private mutating func setProportion(_ value: Int, at offset: Int) {
        precondition((0...3).contains(value))
        high = (high & ~(UInt64(3) << offset)) | (UInt64(value) << offset)
    }
}
