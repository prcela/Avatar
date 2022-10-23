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
        
    }
    
    @IBAction func selectPart(_ sender: UIButton) {
        btns.forEach { btn in
            btn.isSelected = false
        }
        sender.isSelected = true
        selectedPart = parts[sender.tag]
        
        symbolsCollectionView.reloadData()
        colorsCollectionView.reloadData()
        
        
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
        switch collectionView {
        case symbolsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! AvatarSymbolCell
            let symbol = selectedPart!.symbols()[indexPath.row]
            let config = UIImage.SymbolConfiguration(scale: .large)
            cell.img.image = symbol.image() ?? UIImage(systemName: "xmark")?.applyingSymbolConfiguration(config)
            return cell
        default:
            // colors
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
            cell.contentView.backgroundColor = selectedPart!.colors()[indexPath.row]
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
        switch collectionView {
        case symbolsCollectionView:
            let symbol = selectedPart!.symbols()[indexPath.row]
            avatar.set(part: selectedPart!, symbol: symbol)
        default:
            avatar.set(part: selectedPart!, colorIdx: indexPath.row)
        }
        editAvatarView?.avatar = avatar
        editAvatarView?.update()
        
    }
}

public protocol EditAvatarViewControllerDelegate: AnyObject {
    func doneAvatar(_ avatar: Avatar)
}
