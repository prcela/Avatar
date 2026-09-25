//
//  EditAvatarViewController.swift
//  Yamb
//
//  Created by Kresimir Prcela on 26.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import UIKit

public class EditAvatarViewController: UIViewController {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet var btns: [UIButton]!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var symbolsCollectionView: UICollectionView!
    
    public weak var delegate: EditAvatarViewControllerDelegate? = nil
    
    var editAvatarView: EditAvatarView? = nil
    public var avatar = Avatar()
    
    var parts = Avatar.Part.allCases
    var selectedPart: Avatar.Part? = nil
    private let bodyTypes: [Avatar.BodyType] = [.verySlim, .slim, .normal, .broad, .veryBroad]
    private let jerseyNumberButton = UIButton(type: .system)
    #if DEBUG
    private let selectedPartDebugLabel = UILabel()
    #endif
    
    private func selectCurrentItemsIfPossible() {
        guard let part = selectedPart else { return }
        #if DEBUG
        updateSelectedPartDebugLabel()
        #endif

        // Resolve indices from Avatar if available, else fallback to 0
        let symbolsCount = symbolsCollectionView.numberOfItems(inSection: 0)
        let colorsCount = colorsCollectionView.numberOfItems(inSection: 0)

        var symbolIndex = 0
        var colorIndex = 0

        if part == .Skin {
            symbolIndex = bodyTypes.firstIndex(of: avatar.bodyType) ?? 2
        } else if let idx = avatar.symbolIndex(for: part) {
            symbolIndex = idx
        }
        if let idx = avatar.colorIndex(for: part) {
            colorIndex = idx
        }

        if symbolsCount > 0 {
            let indexPath = IndexPath(item: symbolIndex, section: 0)
            symbolsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [.centeredVertically, .centeredHorizontally])
            if let cell = symbolsCollectionView.cellForItem(at: indexPath) {
                applySelectionStyle(to: cell)
            }
        }
        if colorsCount > 0 {
            let indexPath = IndexPath(item: colorIndex, section: 0)
            colorsCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [.centeredVertically, .centeredHorizontally])
            if let cell = colorsCollectionView.cellForItem(at: indexPath) {
                applySelectionStyle(to: cell)
            }
        }
    }
    
    private func applySelectionStyle(to cell: UICollectionViewCell) {
        cell.accessibilityTraits.insert(.selected)
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.cyan.withAlphaComponent(0.8).cgColor
    }

    private func clearSelectionStyle(from cell: UICollectionViewCell) {
        cell.accessibilityTraits.remove(.selected)
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.borderColor = nil
    }

    private func configureCollectionViewLayouts() {
        if let layout = symbolsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 100, height: 100)
            layout.estimatedItemSize = .zero
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }

        if let layout = colorsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 44, height: 44)
            layout.estimatedItemSize = .zero
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
    }
    
    public class func instantiate() -> Self {
        return UIStoryboard(name: "Avatar", bundle: .module).instantiateInitialViewController() as! Self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        for button in btns {
            guard parts.indices.contains(button.tag), var configuration = button.configuration else { continue }
            configuration.title = partTitle(parts[button.tag])
            button.configuration = configuration
        }

        jerseyNumberButton.showsMenuAsPrimaryAction = true
        jerseyNumberButton.accessibilityLabel = NSLocalizedString("Avatar jersey number", value: "Jersey number", comment: "Avatar editor")
        updateJerseyNumberMenu()


        // Do any additional setup after loading the view.
        editAvatarView = Bundle.module.loadNibNamed("EditAvatarView", owner: nil, options: nil)!.first! as? EditAvatarView
        holderView.embedSubview(editAvatarView!)
        editAvatarView?.avatar = avatar
        editAvatarView?.update()

        #if DEBUG
        selectedPartDebugLabel.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        selectedPartDebugLabel.textColor = .secondaryLabel
        selectedPartDebugLabel.textAlignment = .center
        selectedPartDebugLabel.adjustsFontSizeToFitWidth = true
        selectedPartDebugLabel.minimumScaleFactor = 0.7
        selectedPartDebugLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectedPartDebugLabel)
        // Use the existing gap below the preview, outside the rendered avatar.
        NSLayoutConstraint.activate([
            selectedPartDebugLabel.topAnchor.constraint(equalTo: holderView.bottomAnchor, constant: 1),
            selectedPartDebugLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            selectedPartDebugLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            selectedPartDebugLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        #endif
        
        symbolsCollectionView.allowsMultipleSelection = false
        colorsCollectionView.allowsMultipleSelection = false
        
        symbolsCollectionView.allowsSelection = true
        colorsCollectionView.allowsSelection = true
        configureCollectionViewLayouts()
        
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        
        symbolsCollectionView.reloadData()
        colorsCollectionView.reloadData()
        selectCurrentItemsIfPossible()
        
        if let selected = symbolsCollectionView.indexPathsForSelectedItems?.first,
           let cell = symbolsCollectionView.cellForItem(at: selected) {
            applySelectionStyle(to: cell)
        }
        if let selected = colorsCollectionView.indexPathsForSelectedItems?.first,
           let cell = colorsCollectionView.cellForItem(at: selected) {
            applySelectionStyle(to: cell)
        }
    }
    
    @IBAction func selectPart(_ sender: UIButton) {
        btns.forEach { $0.isSelected = false }
        sender.isSelected = true

        let idx = sender.tag
        guard parts.indices.contains(idx) else { return }
        selectedPart = parts[idx]

        symbolsCollectionView.reloadData()
        colorsCollectionView.reloadData()
        selectCurrentItemsIfPossible()
        
        if let selected = symbolsCollectionView.indexPathsForSelectedItems?.first,
           let cell = symbolsCollectionView.cellForItem(at: selected) {
            applySelectionStyle(to: cell)
        }
        if let selected = colorsCollectionView.indexPathsForSelectedItems?.first,
           let cell = colorsCollectionView.cellForItem(at: selected) {
            applySelectionStyle(to: cell)
        }
    }

    #if DEBUG
    private func updateSelectedPartDebugLabel() {
        guard let part = selectedPart else {
            selectedPartDebugLabel.text = nil
            return
        }
        if part == .Skin {
            selectedPartDebugLabel.text = "Body.\(avatar.bodyType)"
        } else if let index = avatar.symbolIndex(for: part), part.symbols().indices.contains(index) {
            selectedPartDebugLabel.text = "\(part).\(part.symbols()[index])"
        } else {
            selectedPartDebugLabel.text = nil
        }
    }
    #endif

    private func updateJerseyNumberMenu() {
        let noNumber = NSLocalizedString("Avatar no number", value: "No number", comment: "Avatar jersey")
        var actions: [UIMenuElement] = [UIAction(title: noNumber, state: avatar.jerseyNumber == 0 ? .on : .off) { [weak self] _ in
            self?.setJerseyNumber(0)
        }]
        for start in stride(from: 0, through: 90, by: 10) {
            let numbers = (start..<(start + 10)).map { number in
                UIAction(title: String(number), state: avatar.jerseyNumber == number + 1 ? .on : .off) { [weak self] _ in
                    self?.setJerseyNumber(number + 1)
                }
            }
            actions.append(UIMenu(title: "\(start)-\(start + 9)", children: numbers))
        }
        jerseyNumberButton.setTitle(avatar.jerseyNumber == 0 ? "#--" : "#\(avatar.jerseyNumber - 1)", for: .normal)
        jerseyNumberButton.menu = UIMenu(title: jerseyNumberButton.accessibilityLabel ?? "", children: actions)
        jerseyNumberButton.sizeToFit()
        if let toolbar = view.subviews.compactMap({ $0 as? UIToolbar }).first,
           let cancel = toolbar.items?.first, let done = toolbar.items?.last {
            var items = [cancel]
            if avatar.clothing.isJersey {
                items.append(UIBarButtonItem(systemItem: .flexibleSpace))
                items.append(UIBarButtonItem(customView: jerseyNumberButton))
            }
            items += [UIBarButtonItem(systemItem: .flexibleSpace), done]
            toolbar.items = items
        }
    }

    private func setJerseyNumber(_ number: Int) {
        avatar.jerseyNumber = number
        editAvatarView?.update()
        updateJerseyNumberMenu()
    }

    private func partTitle(_ part: Avatar.Part) -> String {
        switch part {
        case .Eyes: return NSLocalizedString("Avatar eyes", value: "Eyes", comment: "Avatar editor category")
        case .Mouth: return NSLocalizedString("Avatar mouth", value: "Mouth", comment: "Avatar editor category")
        case .Eyebrow: return NSLocalizedString("Avatar eyebrows", value: "Eyebrow", comment: "Avatar editor category")
        case .Glasses: return NSLocalizedString("Avatar glasses", value: "Glasses", comment: "Avatar editor category")
        case .Hair: return NSLocalizedString("Avatar hair", value: "Hair", comment: "Avatar editor category")
        case .Clothing: return NSLocalizedString("Avatar clothing", value: "Clothing", comment: "Avatar editor category")
        case .FacialHair: return NSLocalizedString("Avatar facial hair", value: "Facial hair", comment: "Avatar editor category")
        case .Addition: return NSLocalizedString("Avatar accessories", value: "Addon", comment: "Avatar editor category")
        case .Skin: return NSLocalizedString("Avatar body", value: "Body", comment: "Avatar editor category")
        case .Nose: return NSLocalizedString("Avatar nose", value: "Nose", comment: "Avatar editor category")
        case .ClothLogo: return NSLocalizedString("Avatar logo", value: "Logo", comment: "Avatar editor category")
        }
    }

    private func bodyTypeTitle(_ type: Avatar.BodyType) -> String {
        switch type {
        case .normal: return NSLocalizedString("Avatar body normal", value: "Normal", comment: "Avatar body type")
        case .slim: return NSLocalizedString("Avatar body slim", value: "Slim", comment: "Avatar body type")
        case .verySlim: return NSLocalizedString("Avatar body very slim", value: "Very slim", comment: "Avatar body type")
        case .broad: return NSLocalizedString("Avatar body broad", value: "Broad", comment: "Avatar body type")
        case .veryBroad: return NSLocalizedString("Avatar body very broad", value: "Very broad", comment: "Avatar body type")
        }
    }

    private func bodyTypePreview(_ type: Avatar.BodyType) -> UIImage? {
        // Preview a copy so browsing the options never changes the selected avatar.
        let preview = Avatar.decompress(value: avatar.compress(), hexId: avatar.compressHex())
        preview.bodyType = type
        return AvatarCache.fetchImage(avatarId: preview.compress(), avatarHexId: preview.compressHex(), small: false)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true)
        delegate?.doneAvatar(avatar)
    }
    
}

extension EditAvatarViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let part = selectedPart else { return UICollectionViewCell() }
        switch collectionView {
        case symbolsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! AvatarSymbolCell
            if part == .Skin {
                let type = bodyTypes[indexPath.row]
                cell.img.image = bodyTypePreview(type)
                cell.setCaption(bodyTypeTitle(type))
            } else {
                let symbol = part.symbols()[indexPath.row]
                let config = UIImage.SymbolConfiguration(scale: .large)
                cell.img.image = (symbol as? Avatar.Glasses)?.image(colorIndex: avatar.glassesColorIdx)
                    ?? symbol.image() ?? UIImage(systemName: "xmark")?.applyingSymbolConfiguration(config)
                cell.setCaption(nil)
            }
            // Selection styling
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) == true {
                applySelectionStyle(to: cell)
            } else {
                clearSelectionStyle(from: cell)
            }
            return cell
        default:
            // colors
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
            cell.contentView.backgroundColor = part.colors()[indexPath.row]
            let original = part == .Glasses && indexPath.row == 0
            cell.contentView.subviews.filter { $0.tag == 7319 }.forEach { $0.removeFromSuperview() }
            if original {
                let label = UILabel(frame: cell.contentView.bounds)
                label.tag = 7319
                label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                label.text = NSLocalizedString("Avatar original color", value: "Original", comment: "Original glasses frame color")
                label.font = .systemFont(ofSize: 10)
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = true
                cell.contentView.addSubview(label)
                cell.contentView.backgroundColor = .secondarySystemBackground
            }
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            if collectionView.indexPathsForSelectedItems?.contains(indexPath) == true {
                applySelectionStyle(to: cell)
            } else {
                clearSelectionStyle(from: cell)
            }
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let part = selectedPart else {return 0}
        
        switch collectionView {
        case symbolsCollectionView:
            return part == .Skin ? bodyTypes.count : part.symbols().count
        default:
            if part == .Glasses && !avatar.glasses.supportsFrameColor { return 0 }
            if part == .Addition && !avatar.addition.usesColor { return 0 }
            if part == .Clothing && !avatar.clothing.usesColor { return 0 }
            return part.colors().count
        }
    }
}

extension EditAvatarViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let part = selectedPart else { return }
        // Light haptic feedback for selection
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        switch collectionView {
        case symbolsCollectionView:
            if part == .Skin {
                avatar.bodyType = bodyTypes[indexPath.row]
            } else {
                let symbol = part.symbols()[indexPath.row]
                avatar.set(part: part, symbol: symbol)
            }
            colorsCollectionView.reloadData()
            selectCurrentItemsIfPossible()
            updateJerseyNumberMenu()
        default:
            avatar.set(part: part, colorIdx: indexPath.row)
            if part == .Glasses { symbolsCollectionView.reloadData() }
            if part == .Skin {
                symbolsCollectionView.reloadData()
                selectCurrentItemsIfPossible()
            }
        }
        editAvatarView?.avatar = avatar
        editAvatarView?.update()
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            applySelectionStyle(to: cell)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            clearSelectionStyle(from: cell)
        }
    }
}

@MainActor
public protocol EditAvatarViewControllerDelegate: AnyObject {
    func doneAvatar(_ avatar: Avatar)
}
