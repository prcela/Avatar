//
//  AvatarEditorViewController.swift
//  Avatar
//

import UIKit

public class AvatarEditorViewController: UIViewController {
    public weak var delegate: EditAvatarViewControllerDelegate?
    public var avatar = Avatar()

    private let groups: [[Avatar.Part]] = [
        [.Skin, .Eyes, .Eyebrow, .Nose, .Mouth],
        [.Hair, .FacialHair],
        [.Clothing, .ClothLogo, .Glasses, .Addition]
    ]
    private let bodyTypes: [Avatar.BodyType] = [.verySlim, .slim, .normal, .broad, .veryBroad]
    private let sizes: [Avatar.FeatureSize] = [.small, .normal, .large]
    private let spacings: [Avatar.EyeSpacing] = [.narrow, .normal, .wide]
    private var selectedPart: Avatar.Part = .Eyes
    private var selectedGroup = 0
    private var rememberedParts: [Avatar.Part] = [.Eyes, .Hair, .Clothing]

    private let preview = UIImageView()
    private let groupControl = UISegmentedControl()
    private let partScrollView = UIScrollView()
    private let partStack = UIStackView()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let partLabel = UILabel()
    private let proportionsStack = UIStackView()
    private let colorsSection = UIStackView()
    private let jerseySection = UIStackView()
    private let jerseyNumberButton = UIButton(type: .system)
    private let jerseyLogoHint = UILabel()
    private let symbolsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var symbolsHeight: NSLayoutConstraint!
    private var previewHeight: NSLayoutConstraint!

    public required init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public class func instantiate() -> Self {
        self.init()
    }

    public override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let toolbar = UIToolbar()
        let title = UILabel()
        title.text = NSLocalizedString("Avatar editor title", value: "Edit avatar", comment: "Avatar editor")
        title.font = .preferredFont(forTextStyle: .headline)
        title.adjustsFontForContentSizeCategory = true
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(customView: title),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        ]

        preview.contentMode = .scaleAspectFit
        preview.isAccessibilityElement = true
        preview.accessibilityLabel = NSLocalizedString("Avatar preview", value: "Avatar preview", comment: "Avatar editor accessibility")
        preview.backgroundColor = .secondarySystemBackground
        preview.layer.cornerRadius = 18

        for (index, name) in [
            NSLocalizedString("Avatar group face", value: "Face", comment: "Avatar editor group"),
            NSLocalizedString("Avatar group hair", value: "Hair", comment: "Avatar editor group"),
            NSLocalizedString("Avatar group style", value: "Style", comment: "Avatar editor group")
        ].enumerated() {
            groupControl.insertSegment(withTitle: name, at: index, animated: false)
        }
        groupControl.selectedSegmentIndex = selectedGroup
        groupControl.addTarget(self, action: #selector(selectGroup), for: .valueChanged)
        groupControl.accessibilityLabel = NSLocalizedString("Avatar category", value: "Category", comment: "Avatar editor")

        partScrollView.showsHorizontalScrollIndicator = false
        partStack.axis = .horizontal
        partStack.spacing = 8
        partStack.alignment = .fill
        partScrollView.addSubview(partStack)

        scrollView.alwaysBounceVertical = true
        contentStack.axis = .vertical
        contentStack.spacing = 16
        scrollView.addSubview(contentStack)
        partLabel.font = .preferredFont(forTextStyle: .title2)
        partLabel.adjustsFontForContentSizeCategory = true
        partLabel.numberOfLines = 0
        partLabel.accessibilityTraits = .header
        contentStack.addArrangedSubview(partLabel)
        proportionsStack.axis = .vertical
        proportionsStack.spacing = 12
        contentStack.addArrangedSubview(proportionsStack)

        configureCollections()
        colorsSection.axis = .vertical
        colorsSection.spacing = 8
        colorsSection.addArrangedSubview(sectionLabel(NSLocalizedString("Avatar color", value: "Color", comment: "Avatar editor")))
        colorsSection.addArrangedSubview(colorsCollectionView)
        contentStack.addArrangedSubview(colorsSection)

        jerseySection.axis = .vertical
        jerseySection.spacing = 8
        let jerseyTitle = NSLocalizedString("Avatar jersey number", value: "Jersey number", comment: "Avatar editor")
        jerseySection.addArrangedSubview(sectionLabel(jerseyTitle))
        jerseyNumberButton.accessibilityLabel = jerseyTitle
        jerseyNumberButton.showsMenuAsPrimaryAction = true
        jerseyNumberButton.configuration = .tinted()
        let jerseyHeight = jerseyNumberButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        jerseyHeight.priority = UILayoutPriority(999)
        jerseyHeight.isActive = true
        jerseySection.addArrangedSubview(jerseyNumberButton)
        jerseyLogoHint.text = NSLocalizedString("Avatar jersey logo hint", value: "Choose No number to show a shirt logo.", comment: "Avatar editor")
        jerseyLogoHint.font = .preferredFont(forTextStyle: .footnote)
        jerseyLogoHint.adjustsFontForContentSizeCategory = true
        jerseyLogoHint.textColor = .secondaryLabel
        jerseyLogoHint.numberOfLines = 0
        jerseySection.addArrangedSubview(jerseyLogoHint)
        contentStack.addArrangedSubview(jerseySection)
        contentStack.addArrangedSubview(sectionLabel(NSLocalizedString("Avatar shape", value: "Shape", comment: "Avatar editor")))
        contentStack.addArrangedSubview(symbolsCollectionView)

        for child in [toolbar, preview, groupControl, partScrollView, scrollView] {
            child.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(child)
        }
        partStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        let safeArea = view.safeAreaLayoutGuide
        previewHeight = preview.heightAnchor.constraint(equalToConstant: 180)
        symbolsHeight = symbolsCollectionView.heightAnchor.constraint(equalToConstant: 100)
        // Hidden stack sections must be able to collapse their fixed-height children.
        let colorsHeight = colorsCollectionView.heightAnchor.constraint(equalToConstant: 52)
        colorsHeight.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44),
            preview.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 8),
            preview.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            previewHeight,
            groupControl.topAnchor.constraint(equalTo: preview.bottomAnchor, constant: 12),
            groupControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            groupControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            groupControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 36),
            partScrollView.topAnchor.constraint(equalTo: groupControl.bottomAnchor, constant: 8),
            partScrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            partScrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            partStack.topAnchor.constraint(equalTo: partScrollView.contentLayoutGuide.topAnchor),
            partStack.bottomAnchor.constraint(equalTo: partScrollView.contentLayoutGuide.bottomAnchor),
            partStack.leadingAnchor.constraint(equalTo: partScrollView.contentLayoutGuide.leadingAnchor),
            partStack.trailingAnchor.constraint(equalTo: partScrollView.contentLayoutGuide.trailingAnchor),
            partStack.heightAnchor.constraint(equalTo: partScrollView.frameLayoutGuide.heightAnchor),
            partStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            scrollView.topAnchor.constraint(equalTo: partScrollView.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            colorsHeight,
            symbolsHeight
        ])
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Editing is a draft: Cancel also leaves a caller's shared Avatar untouched.
        avatar = Avatar.decompress(value: avatar.legacyAvatarId, hexId: avatar.compressHex())
        rebuildPartButtons()
        reloadPart()
        updatePreview()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let availableHeight = view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        let height = max(64, min(220, availableHeight * 0.25))
        if previewHeight.constant != height { previewHeight.constant = height }
        if let layout = symbolsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = symbolsCollectionView.bounds.width
            let minimum: CGFloat = traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? 120 : 76
            let columns = max(1, Int((width + 8) / (minimum + 8)))
            let side = max(1, floor((width - CGFloat(columns - 1) * 8) / CGFloat(columns)))
            let itemSize = CGSize(width: side, height: side + 24)
            if layout.itemSize != itemSize {
                layout.itemSize = itemSize
                layout.invalidateLayout()
            }
            symbolsCollectionView.layoutIfNeeded()
            let height = layout.collectionViewContentSize.height
            if symbolsHeight.constant != height { symbolsHeight.constant = height }
        }
    }

    private func configureCollections() {
        for collection in [symbolsCollectionView, colorsCollectionView] {
            collection.backgroundColor = .clear
            collection.dataSource = self
            collection.delegate = self
            collection.allowsMultipleSelection = false
            collection.register(AvatarEditorOptionCell.self, forCellWithReuseIdentifier: "CellId")
            collection.translatesAutoresizingMaskIntoConstraints = false
        }
        symbolsCollectionView.isScrollEnabled = false
        if let layout = symbolsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.estimatedItemSize = .zero
        }
        colorsCollectionView.showsHorizontalScrollIndicator = false
        if let layout = colorsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 44, height: 44)
            layout.minimumLineSpacing = 8
            layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        }
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.accessibilityTraits = .header
        return label
    }

    @objc private func selectGroup() {
        selectedGroup = groupControl.selectedSegmentIndex
        selectedPart = rememberedParts[selectedGroup]
        rebuildPartButtons()
        reloadPart()
        scrollView.setContentOffset(.zero, animated: false)
    }

    private func rebuildPartButtons() {
        partStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for part in groups[selectedGroup] {
            let button = UIButton(type: .system)
            var config: UIButton.Configuration = part == selectedPart ? .filled() : .tinted()
            config.title = partTitle(part)
            config.cornerStyle = .capsule
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
            button.configuration = config
            button.accessibilityTraits = part == selectedPart ? [.button, .selected] : [.button]
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.selectedPart = part
                self.rememberedParts[self.selectedGroup] = part
                self.rebuildPartButtons()
                self.reloadPart()
                self.scrollView.setContentOffset(.zero, animated: false)
            }, for: .touchUpInside)
            partStack.addArrangedSubview(button)
        }
        partScrollView.layoutIfNeeded()
        if let index = groups[selectedGroup].firstIndex(of: selectedPart) {
            partScrollView.scrollRectToVisible(partStack.arrangedSubviews[index].frame, animated: false)
        }
    }

    private var showsColors: Bool {
        if selectedPart == .Addition { return avatar.addition.usesColor }
        if selectedPart == .Clothing { return avatar.clothing.usesColor }
        return !selectedPart.colors().isEmpty
    }

    private func reloadPart() {
        partLabel.text = partTitle(selectedPart)
        configureProportions()
        colorsSection.isHidden = !showsColors
        updateJerseyNumberMenu()
        symbolsCollectionView.reloadData()
        colorsCollectionView.reloadData()
        selectCurrentItems()
        view.setNeedsLayout()
    }

    private func selectCurrentItems() {
        let symbolIndex = selectedPart == .Skin
            ? bodyTypes.firstIndex(of: avatar.bodyType) : avatar.symbolIndex(for: selectedPart)
        if let symbolIndex {
            symbolsCollectionView.selectItem(at: IndexPath(item: symbolIndex, section: 0), animated: false, scrollPosition: [])
        }
        if showsColors, let color = avatar.colorIndex(for: selectedPart) {
            colorsCollectionView.selectItem(at: IndexPath(item: color, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        }
    }

    private func configureProportions() {
        proportionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let small = NSLocalizedString("Avatar size small", value: "Small", comment: "Avatar proportions")
        let normal = NSLocalizedString("Avatar size normal", value: "Normal", comment: "Avatar proportions")
        let large = NSLocalizedString("Avatar size large", value: "Large", comment: "Avatar proportions")
        switch selectedPart {
        case .Eyes:
            addProportion(title: NSLocalizedString("Avatar eye size", value: "Eye size", comment: "Avatar editor"),
                          options: [small, normal, large], selected: sizes.firstIndex(of: avatar.eyeSize) ?? 1) { [weak self] index in
                guard let self else { return }
                self.avatar.eyeSize = self.sizes[index]
            }
            addProportion(title: NSLocalizedString("Avatar eye spacing", value: "Eye spacing", comment: "Avatar editor"),
                          options: [NSLocalizedString("Avatar spacing narrow", value: "Close", comment: "Eye spacing"),
                                    NSLocalizedString("Avatar spacing normal", value: "Medium", comment: "Eye spacing"),
                                    NSLocalizedString("Avatar spacing wide", value: "Wide", comment: "Eye spacing")],
                          selected: spacings.firstIndex(of: avatar.eyeSpacing) ?? 1) { [weak self] index in
                guard let self else { return }
                self.avatar.eyeSpacing = self.spacings[index]
            }
        case .Mouth:
            addProportion(title: NSLocalizedString("Avatar mouth width", value: "Mouth width", comment: "Avatar editor"),
                          options: [NSLocalizedString("Avatar width narrow", value: "Narrow", comment: "Mouth width"),
                                    NSLocalizedString("Avatar width normal", value: "Normal", comment: "Mouth width"),
                                    NSLocalizedString("Avatar width wide", value: "Wide", comment: "Mouth width")],
                          selected: sizes.firstIndex(of: avatar.mouthWidth) ?? 1) { [weak self] index in
                guard let self else { return }
                self.avatar.mouthWidth = self.sizes[index]
            }
        case .Nose:
            addProportion(title: NSLocalizedString("Avatar nose size", value: "Nose size", comment: "Avatar editor"),
                          options: [NSLocalizedString("Avatar nose small", value: "Small", comment: "Nose size"),
                                    NSLocalizedString("Avatar nose normal", value: "Normal", comment: "Nose size"),
                                    NSLocalizedString("Avatar nose large", value: "Large", comment: "Nose size")],
                          selected: sizes.firstIndex(of: avatar.noseSize) ?? 1) { [weak self] index in
                guard let self else { return }
                self.avatar.noseSize = self.sizes[index]
            }
        default:
            break
        }
        proportionsStack.isHidden = proportionsStack.arrangedSubviews.isEmpty
        guard !proportionsStack.isHidden else { return }
        let reset = UIButton(type: .system)
        reset.setTitle(NSLocalizedString("Avatar reset proportions", value: "Reset proportions", comment: "Reset proportions of the selected avatar part"), for: .normal)
        reset.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        reset.titleLabel?.adjustsFontForContentSizeCategory = true
        reset.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        reset.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            switch self.selectedPart {
            case .Eyes:
                self.avatar.eyeSize = .normal
                self.avatar.eyeSpacing = .normal
            case .Mouth: self.avatar.mouthWidth = .normal
            case .Nose: self.avatar.noseSize = .normal
            default: break
            }
            self.configureProportions()
            self.updatePreview()
        }, for: .touchUpInside)
        proportionsStack.addArrangedSubview(reset)
    }

    private func addProportion(title: String, options: [String], selected: Int, change: @escaping (Int) -> Void) {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.addArrangedSubview(sectionLabel(title))
        let control = UISegmentedControl(items: options)
        control.selectedSegmentIndex = selected
        control.accessibilityLabel = title
        control.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        control.addAction(UIAction { [weak self, weak control] _ in
            guard let control else { return }
            change(control.selectedSegmentIndex)
            self?.updatePreview()
            UISelectionFeedbackGenerator().selectionChanged()
        }, for: .valueChanged)
        stack.addArrangedSubview(control)
        proportionsStack.addArrangedSubview(stack)
    }

    private func updatePreview() {
        preview.image = AvatarCache.fetchImage(avatarId: avatar.legacyAvatarId, avatarHexId: avatar.compressHex(), small: false)
    }

    private func updateJerseyNumberMenu() {
        jerseySection.isHidden = !avatar.clothing.isJersey || (selectedPart != .Clothing && selectedPart != .ClothLogo)
        jerseyLogoHint.isHidden = selectedPart != .ClothLogo || avatar.jerseyNumber == 0
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
        jerseyNumberButton.setTitle(avatar.jerseyNumber == 0 ? noNumber : "#\(avatar.jerseyNumber - 1)", for: .normal)
        jerseyNumberButton.menu = UIMenu(title: jerseyNumberButton.accessibilityLabel ?? "", children: actions)
    }

    private func setJerseyNumber(_ number: Int) {
        avatar.jerseyNumber = number
        updateJerseyNumberMenu()
        updatePreview()
    }

    private func partTitle(_ part: Avatar.Part) -> String {
        switch part {
        case .Eyes: return NSLocalizedString("Avatar eyes", value: "Eyes", comment: "Avatar editor category")
        case .Mouth: return NSLocalizedString("Avatar mouth", value: "Mouth", comment: "Avatar editor category")
        case .Eyebrow: return NSLocalizedString("Avatar eyebrows", value: "Eyebrows", comment: "Avatar editor category")
        case .Glasses: return NSLocalizedString("Avatar glasses", value: "Glasses", comment: "Avatar editor category")
        case .Hair: return NSLocalizedString("Avatar hair", value: "Hair", comment: "Avatar editor category")
        case .Clothing: return NSLocalizedString("Avatar clothing", value: "Clothing", comment: "Avatar editor category")
        case .FacialHair: return NSLocalizedString("Avatar facial hair", value: "Facial hair", comment: "Avatar editor category")
        case .Addition: return NSLocalizedString("Avatar accessories", value: "Accessories", comment: "Avatar editor category")
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

    @objc private func cancel() {
        dismiss(animated: true)
    }

    @objc private func done() {
        dismiss(animated: true)
        delegate?.doneAvatar(avatar)
    }
}

extension AvatarEditorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorsCollectionView { return showsColors ? selectedPart.colors().count : 0 }
        return selectedPart == .Skin ? bodyTypes.count : selectedPart.symbols().count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! AvatarEditorOptionCell
        if collectionView == colorsCollectionView {
            let label = String(format: NSLocalizedString("Avatar color number", value: "Color %d", comment: "Avatar color accessibility"), indexPath.item + 1)
            cell.configure(image: nil, caption: nil, color: selectedPart.colors()[indexPath.item], label: label)
        } else if selectedPart == .Skin {
            let type = bodyTypes[indexPath.item]
            let copy = Avatar.decompress(value: avatar.legacyAvatarId, hexId: avatar.compressHex())
            copy.bodyType = type
            let image = AvatarCache.fetchImage(avatarId: copy.legacyAvatarId, avatarHexId: copy.compressHex(), small: false)
            let title = bodyTypeTitle(type)
            cell.configure(image: image, caption: title, color: nil, label: title)
        } else {
            let symbol = selectedPart.symbols()[indexPath.item]
            let image = symbol.image()
            let none = NSLocalizedString("Avatar none", value: "None", comment: "Avatar style")
            let label = String(format: NSLocalizedString("Avatar style number", value: "%@, style %d", comment: "Avatar style accessibility"), partTitle(selectedPart), indexPath.item + 1)
            cell.configure(image: image ?? UIImage(systemName: "nosign"), caption: image == nil ? none : nil,
                           color: nil, label: image == nil ? none : label)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UISelectionFeedbackGenerator().selectionChanged()
        if collectionView == colorsCollectionView {
            avatar.set(part: selectedPart, colorIdx: indexPath.item)
            if selectedPart == .Skin {
                symbolsCollectionView.reloadData()
                selectCurrentItems()
            }
        } else {
            if selectedPart == .Skin {
                avatar.bodyType = bodyTypes[indexPath.item]
            } else {
                avatar.set(part: selectedPart, symbol: selectedPart.symbols()[indexPath.item])
            }
            colorsSection.isHidden = !showsColors
            colorsCollectionView.reloadData()
            updateJerseyNumberMenu()
            selectCurrentItems()
        }
        updatePreview()
    }
}
