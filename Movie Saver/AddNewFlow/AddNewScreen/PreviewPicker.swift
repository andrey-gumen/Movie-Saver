import Combine
import EasyAutolayout
import UIKit

final class PreviewPicker: UIView {

    // MARK: - Properties
    // MARK: Public
    let previewChangedSubject = PassthroughSubject<UIImage?, Never>()

    // MARK: Private
    private let actionButton = UIButton()
    private let mainImage = UIImageView()

    private static let defaultPreview = UIImage(systemName: "photo")

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        configureUI()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API
    // MARK: - Setups
    private func addSubview() {
        addSubview(actionButton)
        actionButton.addSubview(mainImage)
    }

    private func configureUI() {
        mainImage.contentMode = .scaleAspectFit
        mainImage.image = PreviewPicker.defaultPreview

        actionButton.addTarget(self, action: #selector(actionButtonDidTapped), for: .touchUpInside)
    }

    private func configureConstraints() {
        actionButton.pin
            .edges([.top, .bottom, .left, .right], to: self)
        mainImage.pin
            .edges([.top, .bottom, .left, .right], to: self)
    }

    // MARK: - Helpers
    @objc func actionButtonDidTapped() {
        print(#function)
    }
}
