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

