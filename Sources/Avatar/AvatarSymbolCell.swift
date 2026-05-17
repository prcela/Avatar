//
//  AvatarSymbolCell.swift
//  Yamb
//
//  Created by Kresimir Prcela on 26.12.2021..
//  Copyright © 2021 Rika Omega Rika. All rights reserved.
//

import UIKit

class AvatarSymbolCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
    }
}
