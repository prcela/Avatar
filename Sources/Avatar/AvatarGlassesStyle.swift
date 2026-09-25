import UIKit

/// Frame color is independent of the lenses, reflections and frame highlights.
enum AvatarGlassesStyle {
    private static let cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 6 * 1024 * 1024
        return cache
    }()

    static func image(for glasses: Avatar.Glasses, colorIndex: Int) -> UIImage? {
        guard glasses != .None else { return nil }
        let colors = Avatar.Part.Glasses.colors()
        guard glasses.supportsFrameColor, colorIndex > 0, colors.indices.contains(colorIndex) else {
            return glasses.image()
        }
        let key = "\(glasses.rawValue):\(colorIndex)" as NSString
        if let cached = cache.object(forKey: key) { return cached }
        let suffix = String(format: "%02d", glasses.rawValue)
        guard let frame = UIImage(named: "GlassesFrame" + suffix, in: .module, compatibleWith: nil),
              let details = UIImage(named: "GlassesDetails" + suffix, in: .module, compatibleWith: nil) else {
            return glasses.image()
        }
        let format = UIGraphicsImageRendererFormat()
        format.scale = frame.scale
        let result = UIGraphicsImageRenderer(size: frame.size, format: format).image { _ in
            frame.avatarTinted(colors[colorIndex]).draw(at: .zero)
            details.draw(at: .zero)
        }.withRenderingMode(.alwaysOriginal)
        cache.setObject(result, forKey: key, cost: Int(result.size.width * result.scale * result.size.height * result.scale) * 4)
        return result
    }
}
