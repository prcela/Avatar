// SPDX-License-Identifier: MPL-2.0

//
//  AvatarSymbolCell.swift
//  Yamb
//
//  Created by Kresimir Prcela on 26.12.2021..
//  Copyright © 2021 Rika Omega Rika.
//

import UIKit

class AvatarSymbolCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    private let caption = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.font = .systemFont(ofSize: 11)
        caption.textAlignment = .center
        caption.adjustsFontSizeToFitWidth = true
        caption.minimumScaleFactor = 0.8
        caption.isHidden = true
        contentView.addSubview(caption)
        NSLayoutConstraint.activate([
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            caption.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func setCaption(_ text: String?) {
        caption.text = text
        caption.isHidden = text == nil
        imageBottomConstraint.constant = text == nil ? 8 : 26
        isAccessibilityElement = text != nil
        accessibilityLabel = text
        accessibilityTraits = text == nil ? [] : [.button]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
        setCaption(nil)
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
    }
}
