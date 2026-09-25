// SPDX-License-Identifier: MPL-2.0

import Avatar
import UIKit

final class AvatarDemoViewController: UIViewController {
    private static let savedIDKey = "demo.avatarHexID"

    private var avatar = Avatar.random()
    private let avatarView = UIAvatarView()
    private let idLabel = UILabel()
    private let idField = UITextField()
    private let statusLabel = UILabel()
    private var buttonRows: [UIStackView] = []
    private var exportDirectory: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Avatar Demo"
        view.backgroundColor = .systemGroupedBackground
        configureLayout()

        if let savedID = UserDefaults.standard.string(forKey: Self.savedIDKey),
           let validID = AvatarHexID(savedID) {
            avatar = Avatar.decompress(value: 0, hexId: validID.hex)
        }
        showAvatar()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateButtonLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        AvatarCache.didReceiveMemoryWarning()
    }

    private func configureLayout() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        let content = UIStackView()
        content.axis = .vertical
        content.spacing = 16
        view.addSubview(scrollView)
        scrollView.addSubview(content)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false

        let preferredWidth = content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        preferredWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            content.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            content.centerXAnchor.constraint(equalTo: scrollView.frameLayoutGuide.centerXAnchor),
            content.widthAnchor.constraint(lessThanOrEqualToConstant: 520),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            preferredWidth
        ])

        let preview = UIView()
        preview.backgroundColor = .secondarySystemGroupedBackground
        preview.layer.cornerRadius = 24
        avatarView.contentMode = .scaleAspectFit
        avatarView.isAccessibilityElement = true
        avatarView.accessibilityLabel = text("demo.preview")
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        preview.addSubview(avatarView)
        NSLayoutConstraint.activate([
            preview.heightAnchor.constraint(equalToConstant: 248),
            avatarView.topAnchor.constraint(equalTo: preview.topAnchor, constant: 12),
            avatarView.bottomAnchor.constraint(equalTo: preview.bottomAnchor, constant: -12),
            avatarView.leadingAnchor.constraint(equalTo: preview.leadingAnchor, constant: 12),
            avatarView.trailingAnchor.constraint(equalTo: preview.trailingAnchor, constant: -12)
        ])
        content.addArrangedSubview(preview)
        content.addArrangedSubview(buttonRow([
            button("demo.edit", symbol: "slider.horizontal.3", primary: true, action: #selector(editAvatar)),
            button("demo.random", symbol: "shuffle", action: #selector(randomizeAvatar))
        ]))
        content.addArrangedSubview(buttonRow([
            button("demo.savePNG", symbol: "square.and.arrow.down", action: #selector(savePNG)),
            button("demo.copyID", symbol: "doc.on.doc", action: #selector(copyID))
        ]))

        idLabel.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: .monospacedSystemFont(ofSize: 14, weight: .regular))
        idLabel.adjustsFontForContentSizeCategory = true
        idLabel.numberOfLines = 0
        idLabel.lineBreakMode = .byCharWrapping
        idLabel.accessibilityLabel = text("demo.currentID")
        content.addArrangedSubview(label("demo.currentID", style: .headline))
        content.addArrangedSubview(idLabel)

        content.addArrangedSubview(label("demo.restoreTitle", style: .headline))
        content.addArrangedSubview(label("demo.restoreHint", style: .footnote, color: .secondaryLabel))
        idField.borderStyle = .roundedRect
        idField.placeholder = text("demo.idPlaceholder")
        idField.accessibilityLabel = text("demo.idPlaceholder")
        idField.font = .preferredFont(forTextStyle: .body)
        idField.adjustsFontForContentSizeCategory = true
        idField.autocapitalizationType = .none
        idField.autocorrectionType = .no
        idField.spellCheckingType = .no
        idField.keyboardType = .asciiCapable
        idField.returnKeyType = .go
        idField.clearButtonMode = .whileEditing
        idField.delegate = self
        idField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        content.addArrangedSubview(idField)
        content.addArrangedSubview(buttonRow([
            button("demo.pasteID", symbol: "doc.on.clipboard", action: #selector(pasteID)),
            button("demo.loadID", symbol: "arrow.clockwise", action: #selector(loadID))
        ]))

        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.adjustsFontForContentSizeCategory = true
        statusLabel.textColor = .secondaryLabel
        statusLabel.numberOfLines = 0
        content.addArrangedSubview(statusLabel)
        updateButtonLayout()
    }

    private func text(_ key: String) -> String {
        NSLocalizedString(key, comment: "Avatar demo")
    }

    private func label(_ key: String, style: UIFont.TextStyle, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.text = text(key)
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.numberOfLines = 0
        if style == .headline { label.accessibilityTraits = .header }
        return label
    }

    private func button(_ key: String, symbol: String, primary: Bool = false, action: Selector) -> UIButton {
        var configuration: UIButton.Configuration = primary ? .filled() : .tinted()
        configuration.title = text(key)
        configuration.image = UIImage(systemName: symbol)
        configuration.imagePadding = 8
        configuration.cornerStyle = .medium
        configuration.titleLineBreakMode = .byWordWrapping
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        return button
    }

    private func buttonRow(_ buttons: [UIButton]) -> UIStackView {
        let row = UIStackView(arrangedSubviews: buttons)
        row.spacing = 12
        row.distribution = .fillEqually
        buttonRows.append(row)
        return row
    }

    private func updateButtonLayout() {
        let axis: NSLayoutConstraint.Axis = traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? .vertical : .horizontal
        buttonRows.forEach { $0.axis = axis }
    }

    private func showAvatar() {
        let id = avatar.compressHex()
        avatarView.setAvatar(avatarHexId: id)
        idLabel.text = id
        idLabel.accessibilityValue = id
        idField.text = id
        UserDefaults.standard.set(id, forKey: Self.savedIDKey)
    }

    private func showStatus(_ key: String) {
        statusLabel.text = text(key)
        UIAccessibility.post(notification: .announcement, argument: statusLabel.text)
    }

    private func showError(_ key: String) {
        let alert = UIAlertController(title: text("demo.errorTitle"), message: text(key), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: text("demo.ok"), style: .default))
        present(alert, animated: true)
    }

    @objc private func editAvatar() {
        view.endEditing(true)
        let editor = AvatarEditorViewController.instantiate()
        editor.avatar = avatar
        editor.delegate = self
        present(editor, animated: true)
    }

    @objc private func randomizeAvatar() {
        view.endEditing(true)
        avatar = Avatar.random()
        showAvatar()
        showStatus("demo.randomized")
    }

    @objc private func copyID() {
        UIPasteboard.general.string = avatar.compressHex()
        showStatus("demo.copied")
    }

    @objc private func pasteID() {
        // Read the clipboard only in response to the user's explicit Paste action.
        guard let value = UIPasteboard.general.string else {
            showError("demo.emptyClipboard")
            return
        }
        idField.text = value
        loadID()
    }

    @objc private func loadID() {
        let value = (idField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let id = AvatarHexID(value) else {
            showError("demo.invalidID")
            return
        }
        view.endEditing(true)
        avatar = Avatar.decompress(value: 0, hexId: id.hex)
        showAvatar()
        showStatus("demo.restored")
    }

    @objc private func savePNG() {
        view.endEditing(true)
        // Export the package-rendered image, without the demo's preview background.
        guard let png = avatarView.image?.pngData() else {
            showError("demo.exportError")
            return
        }
        removeExportFiles()
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        exportDirectory = directory
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let file = directory.appendingPathComponent("avatar-\(avatar.compressHex()).png")
            try png.write(to: file, options: .atomic)
            let picker = UIDocumentPickerViewController(forExporting: [file], asCopy: true)
            picker.delegate = self
            present(picker, animated: true)
            picker.presentationController?.delegate = self
        } catch {
            removeExportFiles()
            showError("demo.exportError")
        }
    }

    private func removeExportFiles() {
        if let exportDirectory {
            try? FileManager.default.removeItem(at: exportDirectory)
        }
        exportDirectory = nil
    }
}

extension AvatarDemoViewController: EditAvatarViewControllerDelegate {
    func doneAvatar(_ avatar: Avatar) {
        self.avatar = avatar
        showAvatar()
        showStatus("demo.updated")
    }
}

extension AvatarDemoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loadID()
        return true
    }
}

extension AvatarDemoViewController: UIDocumentPickerDelegate, UIAdaptivePresentationControllerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        removeExportFiles()
        showStatus("demo.exported")
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        removeExportFiles()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        removeExportFiles()
    }
}
