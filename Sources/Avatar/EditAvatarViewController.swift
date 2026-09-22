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
    private let bodyTypeButton = UIButton(type: .system)
    private let jerseyNumberButton = UIButton(type: .system)
    
    private func selectCurrentItemsIfPossible() {
        guard let part = selectedPart else { return }

        // Resolve indices from Avatar if available, else fallback to 0
        let symbolsCount = symbolsCollectionView.numberOfItems(inSection: 0)
        let colorsCount = colorsCollectionView.numberOfItems(inSection: 0)

        var symbolIndex = 0
        var colorIndex = 0

        if let idx = avatar.symbolIndex(for: part) {
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
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.cyan.withAlphaComponent(0.8).cgColor
    }

    private func clearSelectionStyle(from cell: UICollectionViewCell) {
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

        bodyTypeButton.showsMenuAsPrimaryAction = true
        bodyTypeButton.accessibilityLabel = NSLocalizedString("Avatar body shape", value: "Body shape", comment: "Avatar editor")
        updateBodyTypeMenu()
        jerseyNumberButton.showsMenuAsPrimaryAction = true
        jerseyNumberButton.accessibilityLabel = NSLocalizedString("Avatar jersey number", value: "Jersey number", comment: "Avatar editor")
        updateJerseyNumberMenu()


        // Do any additional setup after loading the view.
        editAvatarView = Bundle.module.loadNibNamed("EditAvatarView", owner: nil, options: nil)!.first! as? EditAvatarView
        holderView.embedSubview(editAvatarView!)
        editAvatarView?.avatar = avatar
        editAvatarView?.update()
        
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
            var items = [cancel, UIBarButtonItem(systemItem: .flexibleSpace), UIBarButtonItem(customView: bodyTypeButton)]
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

    private func bodyTypeTitle(_ type: Avatar.BodyType) -> String {
        switch type {
        case .normal: return NSLocalizedString("Avatar body normal", value: "Normal", comment: "Avatar body type")
        case .slim: return NSLocalizedString("Avatar body slim", value: "Slim", comment: "Avatar body type")
        case .verySlim: return NSLocalizedString("Avatar body very slim", value: "Very slim", comment: "Avatar body type")
        case .broad: return NSLocalizedString("Avatar body broad", value: "Broad", comment: "Avatar body type")
        case .veryBroad: return NSLocalizedString("Avatar body very broad", value: "Very broad", comment: "Avatar body type")
        }
    }

    private func updateBodyTypeMenu() {
        let title = bodyTypeTitle(avatar.bodyType)
        var configuration = UIButton.Configuration.plain()
        configuration.title = title
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        bodyTypeButton.configuration = configuration
        bodyTypeButton.accessibilityValue = title
        bodyTypeButton.sizeToFit()
        bodyTypeButton.menu = UIMenu(title: bodyTypeButton.accessibilityLabel ?? "", children: Avatar.BodyType.allCases.map { type in
            UIAction(title: bodyTypeTitle(type), state: type == avatar.bodyType ? .on : .off) { [weak self] _ in
                guard let self else { return }
                self.avatar.bodyType = type
                self.editAvatarView?.update()
                self.updateBodyTypeMenu()
            }
        })
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
            let symbol = part.symbols()[indexPath.row]
            let config = UIImage.SymbolConfiguration(scale: .large)
            cell.img.image = symbol.image() ?? UIImage(systemName: "xmark")?.applyingSymbolConfiguration(config)
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
            return part.symbols().count
        default:
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
            let symbol = part.symbols()[indexPath.row]
            avatar.set(part: part, symbol: symbol)
            colorsCollectionView.reloadData()
            selectCurrentItemsIfPossible()
            updateJerseyNumberMenu()
        default:
            avatar.set(part: part, colorIdx: indexPath.row)
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
