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
            return Int((low >> field.offset) & mask) | (Int((high >> field.rawValue) & 1) << field.width)
        }
        set {
            precondition(newValue >= 0 && newValue < (1 << (field.width + 1)))
            let mask = (UInt64(1) << field.width) - 1
            low = (low & ~(mask << field.offset)) | ((UInt64(newValue) & mask) << field.offset)
            let extensionMask = UInt64(1) << field.rawValue
            high = (high & ~extensionMask) | (UInt64(newValue >> field.width) << field.rawValue)
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
}
