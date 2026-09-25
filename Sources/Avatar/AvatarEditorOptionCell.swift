// SPDX-License-Identifier: MPL-2.0

import UIKit

final class AvatarEditorOptionCell: UICollectionViewCell {
    private let img = UIImageView()
    private let caption = UILabel()
    private let swatch = UIView()
    private let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    private func configureViews() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        img.contentMode = .scaleAspectFit
        caption.font = .preferredFont(forTextStyle: .caption2)
        caption.adjustsFontForContentSizeCategory = true
        caption.adjustsFontSizeToFitWidth = true
        caption.minimumScaleFactor = 0.7
        caption.textAlignment = .center
        swatch.layer.cornerRadius = 16
        swatch.layer.borderWidth = 0.5
        swatch.layer.borderColor = UIColor.separator.cgColor
        checkmark.backgroundColor = .systemBackground
        checkmark.layer.cornerRadius = 9
        checkmark.isHidden = true
        for child in [swatch, img, caption, checkmark] {
            child.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(child)
        }
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            img.bottomAnchor.constraint(equalTo: caption.topAnchor, constant: -2),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            caption.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            caption.heightAnchor.constraint(equalToConstant: 18),
            swatch.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            swatch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            swatch.widthAnchor.constraint(equalToConstant: 32),
            swatch.heightAnchor.constraint(equalToConstant: 32),
            checkmark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            checkmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            checkmark.widthAnchor.constraint(equalToConstant: 18),
            checkmark.heightAnchor.constraint(equalToConstant: 18)
        ])
        isAccessibilityElement = true
    }

    func configure(image: UIImage?, caption text: String?, color: UIColor?, label: String) {
        img.image = image
        img.isHidden = color != nil
        caption.text = text
        caption.isHidden = text == nil
        swatch.backgroundColor = color
        swatch.isHidden = color == nil
        contentView.backgroundColor = color == nil ? .secondarySystemBackground : .clear
        accessibilityLabel = label
        updateSelection()
    }

    override var isSelected: Bool {
        didSet { updateSelection() }
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        updateSelection()
    }

    private func updateSelection() {
        contentView.layer.borderWidth = isSelected ? 2 : 0
        contentView.layer.borderColor = tintColor.cgColor
        checkmark.isHidden = !isSelected
        accessibilityTraits = isSelected ? [.button, .selected] : [.button]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
        caption.text = nil
        swatch.backgroundColor = nil
        accessibilityLabel = nil
        isSelected = false
    }
}
