import XCTest
import UIKit
@testable import Avatar

final class AvatarGlassesColorTests: XCTestCase {
    private let source = "8000004cc00000000c8849616c39285a"

    func testEveryModelAndColorRoundTripsWithoutChangingOtherFields() throws {
        for style in Avatar.Glasses.allCases {
            for index in Avatar.Part.Glasses.colors().indices {
                let avatar = Avatar.decompress(value: 0, hexId: source)
                avatar.set(part: .Glasses, symbol: style)
                var expected = try XCTUnwrap(AvatarHexID(avatar.compressHex()))
                avatar.set(part: .Glasses, colorIdx: index)
                expected.glassesColor = index
                XCTAssertEqual(avatar.compressHex(), expected.hex)
                let restored = Avatar.decompress(value: 0, hexId: expected.hex)
                XCTAssertEqual(restored.glasses, style)
                XCTAssertEqual(restored.glassesColorIdx, index)
                XCTAssertEqual(restored.compressHex(), expected.hex)
            }
        }
    }

    func testLegacyDefaultsResetAndModelChanges() {
        let avatar = Avatar.decompress(value: 903052408064125018)
        let original = avatar.compressHex()
        XCTAssertEqual(avatar.glassesColorIdx, 0)
        avatar.glassesColorIdx = 12
        avatar.set(part: .Glasses, symbol: Avatar.Glasses.None)
        for style in [Avatar.Glasses.Monocle, .SkiGoggles, .FutureVisor] {
            avatar.set(part: .Glasses, symbol: style)
            XCTAssertFalse(avatar.glasses.supportsFrameColor)
            XCTAssertEqual(Avatar.decompress(value: 0, hexId: avatar.compressHex()).glassesColorIdx, 12)
        }
        avatar.set(part: .Glasses, symbol: Avatar.Glasses.Round)
        XCTAssertTrue(avatar.glasses.supportsFrameColor)
        XCTAssertEqual(Avatar.decompress(value: 0, hexId: avatar.compressHex()).glassesColorIdx, 12)
        let reset = Avatar.decompress(value: 0, hexId: original)
        reset.glassesColorIdx = 15
        XCTAssertEqual(reset.legacyAvatarId, 903052408064125018)
        reset.glassesColorIdx = 0
        XCTAssertEqual(reset.compressHex(), original)
    }

    func testUnknownColorsSurviveUntilExplicitSelection() throws {
        for index in 16...31 {
            var expected = try XCTUnwrap(AvatarHexID(source))
            expected.glassesColor = index
            let avatar = Avatar.decompress(value: 0, hexId: expected.hex)
            XCTAssertEqual(avatar.glassesColorIdx, 0)
            XCTAssertEqual(avatar.compressHex(), expected.hex)
            avatar.set(part: .Hair, colorIdx: 2)
            expected[.hairColor] = 2
            XCTAssertEqual(avatar.compressHex(), expected.hex)
            avatar.glassesColorIdx = 0
            expected.glassesColor = 0
            XCTAssertEqual(avatar.compressHex(), expected.hex)
        }
    }

    func testSharedAndroidFixture() throws {
        var hex = try XCTUnwrap(AvatarHexID("0000004cc00000000c8849616c39285a"))
        hex.glassesColor = 12
        XCTAssertEqual(hex.hex, "0000064cc00000000c8849616c39285a")
        for index in 0...31 {
            var other = try XCTUnwrap(AvatarHexID(source))
            other.glassesColor = index
            XCTAssertEqual(AvatarHexID(other.hex)?.glassesColor, index)
            other.glassesColor = 0
            XCTAssertEqual(other.hex, source)
        }
    }

    @MainActor
    func testEditorShowsFrameColorsOnFirstSelectionAfterHiddenStyles() throws {
        let editor = AvatarEditorViewController.instantiate()
        editor.avatar.set(part: .Glasses, symbol: Avatar.Glasses.None)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.rootViewController = editor
        window.isHidden = false
        defer {
            window.isHidden = true
            window.rootViewController = nil
        }
        func layout() {
            window.layoutIfNeeded()
            editor.view.layoutIfNeeded()
        }
        editor.loadViewIfNeeded()
        layout()
        let groupControl = try XCTUnwrap(editor.view.subviews.compactMap { $0 as? UISegmentedControl }.first)
        groupControl.selectedSegmentIndex = 2 // Style group.
        groupControl.sendActions(for: .valueChanged)
        layout()
        let parts = try XCTUnwrap(editor.view.subviews.compactMap { $0 as? UIScrollView }.first)
        let partStack = try XCTUnwrap(parts.subviews.compactMap { $0 as? UIStackView }.first)
        let glassesButton = try XCTUnwrap(partStack.arrangedSubviews.compactMap { $0 as? UIButton }.dropFirst(2).first)
        glassesButton.sendActions(for: .touchUpInside)
        layout()
        func collections(in view: UIView) -> [UICollectionView] {
            let own = (view as? UICollectionView).map { [$0] } ?? []
            return own + view.subviews.flatMap { collections(in: $0) }
        }
        let allCollections = collections(in: editor.view)
        let colors = try XCTUnwrap(allCollections.first {
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal
        })
        let symbols = try XCTUnwrap(allCollections.first { $0 !== colors })
        let colorSection = try XCTUnwrap(colors.superview as? UIStackView)
        for color in [0, 12] {
            editor.avatar.glassesColorIdx = color
            for hiddenStyle in [Avatar.Glasses.None, .None, .Monocle, .SkiGoggles, .FutureVisor] {
                editor.collectionView(symbols, didSelectItemAt: IndexPath(item: hiddenStyle.rawValue, section: 0))
                layout()
                XCTAssertTrue(colorSection.isHidden)
                XCTAssertEqual(colors.numberOfItems(inSection: 0), 0)

                // One tap must restore visible swatches and the stored color.
                editor.collectionView(symbols, didSelectItemAt: IndexPath(item: Avatar.Glasses.Kurt.rawValue, section: 0))
                layout()
                XCTAssertFalse(colorSection.isHidden)
                XCTAssertEqual(colors.numberOfItems(inSection: 0), Avatar.Part.Glasses.colors().count)
                XCTAssertEqual(colors.bounds.height, 52, accuracy: 0.5)
                let selected = IndexPath(item: color, section: 0)
                XCTAssertEqual(colors.indexPathsForSelectedItems, [selected])
                XCTAssertNotNil(colors.cellForItem(at: selected), "Palette missing after first tap from \(hiddenStyle)")
                XCTAssertEqual(editor.avatar.glassesColorIdx, color)
            }
        }
    }

    func testTintableFramesKeepTheirLensesAndFixedStylesKeepOriginalArtwork() throws {
        for style in [Avatar.Glasses.Monocle, .SkiGoggles, .FutureVisor] {
            let original = try XCTUnwrap(style.image())
            for colorIndex in 0...31 {
                let image = try XCTUnwrap(style.image(colorIndex: colorIndex))
                XCTAssertEqual(image.pngData(), original.pngData(), "Fixed artwork changed for \(style)")
            }
        }
        for style in Avatar.Glasses.allCases where style.supportsFrameColor {
            let red = try XCTUnwrap(style.image(colorIndex: 8))
            let blue = try XCTUnwrap(style.image(colorIndex: 12))
            XCTAssertEqual(red.size, CGSize(width: 142, height: 54))
            XCTAssertNotEqual(red.pngData(), blue.pngData(), "Missing tint layers for \(style)")
        }
        let samples: [(Avatar.Glasses, CGPoint)] = [
            (.Kurt, CGPoint(x: 35, y: 28)), (.Sunglasses, CGPoint(x: 40, y: 30)),
            (.OliverGreen, CGPoint(x: 35, y: 26)), (.Prozirne, CGPoint(x: 35, y: 26)),
            (.StarsGlasses, CGPoint(x: 42, y: 28)), (.SkiGoggles, CGPoint(x: 36, y: 28)),
            (.Monocle, CGPoint(x: 99, y: 17)), (.FutureVisor, CGPoint(x: 40, y: 25))
        ]
        for (style, point) in samples {
            let red = try XCTUnwrap(style.image(colorIndex: 8))
            let blue = try XCTUnwrap(style.image(colorIndex: 12))
            XCTAssertEqual(pixel(red, at: point), pixel(blue, at: point), "Lens tinted for \(style)")
        }
    }

    private func pixel(_ image: UIImage, at point: CGPoint) -> [UInt8] {
        let cg = image.cgImage!
        let ctx = CGContext(data: nil, width: cg.width, height: cg.height, bitsPerComponent: 8,
                            bytesPerRow: cg.width * 4, space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        ctx.draw(cg, in: CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        let bytes = ctx.data!.assumingMemoryBound(to: UInt8.self)
        let offset = Int(point.y * image.scale) * ctx.bytesPerRow + Int(point.x * image.scale) * 4
        return (0..<4).map { bytes[offset + $0] }
    }
}
