// SPDX-License-Identifier: MPL-2.0

import Foundation
import UIKit

/// Cache bookkeeping and delivery stay on the main actor; bitmap work uses renderQueue.
@MainActor
public class AvatarCache {
    struct Key: Hashable, Sendable {
        let avatarId: Int64
        let avatarHexId: String
        let enableBots: Bool
        let scale: CGFloat
        let interfaceStyle: Int
    }

    private final class Images: @unchecked Sendable {
        let full: UIImage
        let small: UIImage

        init(full: UIImage, small: UIImage) {
            self.full = full
            self.small = small
        }

        var cost: Int {
            [full, small].reduce(0) { $0 + ($1.cgImage.map { $0.bytesPerRow * $0.height } ?? 0) }
        }
    }

    private static let images: NSCache<NSString, Images> = {
        let cache = NSCache<NSString, Images>()
        cache.totalCostLimit = 32 * 1024 * 1024
        return cache
    }()
    private static let renderQueue = DispatchQueue(label: "AvatarCache.render", qos: .userInitiated)
    private static var pending = [Key: [(Images) -> Void]]()
    private static var generation = UUID()

    static func key(avatarId: Int64, avatarHexId: String) -> Key {
        let hex = AvatarHexID(avatarHexId)
        return Key(avatarId: hex?.legacyID ?? avatarId, avatarHexId: hex?.hex ?? "",
                   enableBots: UIAvatarView.enableBots, scale: UIScreen.main.scale,
                   interfaceStyle: UITraitCollection.current.userInterfaceStyle.rawValue)
    }

    private static func cacheKey(_ key: Key) -> NSString {
        "\(key.avatarId):\(key.avatarHexId):\(key.enableBots):\(key.scale):\(key.interfaceStyle)" as NSString
    }

    /// A lookup only. A cache miss never renders or waits for the render queue.
    public class func cachedImage(avatarId: Int64, avatarHexId: String = "", small: Bool) -> UIImage? {
        cachedImage(for: key(avatarId: avatarId, avatarHexId: avatarHexId), small: small)
    }

    static func cachedImage(for key: Key, small: Bool) -> UIImage? {
        guard let pair = images.object(forKey: cacheKey(key)) else { return nil }
        return small ? pair.small : pair.full
    }

    /// Completion runs on the main actor, immediately for an existing cached image.
    public class func loadImage(avatarId: Int64, avatarHexId: String = "", small: Bool,
                                completion: @escaping @MainActor (UIImage) -> Void) {
        loadImage(for: key(avatarId: avatarId, avatarHexId: avatarHexId), small: small, completion: completion)
    }

    private static func loadImage(for key: Key, small: Bool,
                                  completion: @escaping @MainActor (UIImage) -> Void) {
        if let image = cachedImage(for: key, small: small) {
            completion(image)
            return
        }
        let deliver: (Images) -> Void = { completion(small ? $0.small : $0.full) }
        if pending[key] != nil {
            pending[key]?.append(deliver)
            return
        }
        pending[key] = [deliver]
        let requestedGeneration = generation
        renderQueue.async {
            let pair = autoreleasepool { render(key) }
            DispatchQueue.main.async {
                // A memory warning must not be undone by an already-running render.
                if generation == requestedGeneration {
                    images.setObject(pair, forKey: cacheKey(key), cost: pair.cost)
                }
                let completions = pending.removeValue(forKey: key) ?? []
                for completion in completions { completion(pair) }
            }
        }
    }

    public class func image(avatarId: Int64, avatarHexId: String = "", small: Bool) async -> UIImage {
        await image(for: key(avatarId: avatarId, avatarHexId: avatarHexId), small: small)
    }

    static func image(for key: Key, small: Bool) async -> UIImage {
        await withCheckedContinuation { continuation in
            loadImage(for: key, small: small) { continuation.resume(returning: $0) }
        }
    }

    nonisolated private static func render(_ key: Key) -> Images {
        dispatchPrecondition(condition: .notOnQueue(.main))
        let style = UIUserInterfaceStyle(rawValue: key.interfaceStyle) ?? .unspecified
        let traits: UITraitCollection
        if #available(iOS 17.0, *) {
            traits = UITraitCollection {
                $0.displayScale = key.scale
                $0.userInterfaceStyle = style
            }
        } else {
            traits = UITraitCollection(traitsFrom: [
                UITraitCollection(displayScale: key.scale), UITraitCollection(userInterfaceStyle: style)
            ])
        }
        var result: Images!
        traits.performAsCurrent {
            // Decompress here so the mutable Avatar instance never crosses threads.
            let avatar = Avatar.decompress(value: key.avatarId, hexId: key.avatarHexId)
            let full = AvatarRenderer(avatar: avatar, enableBots: key.enableBots).image(scale: key.scale)
            let size = CGSize(width: 30, height: 30)
            let format = UIGraphicsImageRendererFormat()
            format.scale = key.scale
            let small = UIGraphicsImageRenderer(size: size, format: format).image { _ in
                full.draw(in: CGRect(origin: .zero, size: size))
            }
            result = Images(full: full, small: small)
        }
        return result
    }

    public class func didReceiveMemoryWarning() {
        generation = UUID()
        images.removeAllObjects()
    }
}
