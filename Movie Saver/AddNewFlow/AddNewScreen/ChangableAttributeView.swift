import Combine
import EasyAutolayout
import UIKit

final class ChangableAttributeView: UIView {

    // MARK: - Properties
    // MARK: Public
    let changeSubject = PassthroughSubject<Void, Never>()

    // MARK: Private
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let changeButton = UIButton()

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
    func updateTille(title: String) {
        titleLabel.text = title
    }
    
    func updateValue(_ value: String?) {
        valueLabel.text = value ?? "-"
    }

    // MARK: - Setups
    private func addSubview() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(changeButton)
    }

    private func configureUI() {
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = "Title"
        titleLabel.sizeToFit()

        valueLabel.font = UIFont(name: "Manrope-Medium", size: 18)
        valueLabel.textAlignment = .center
        valueLabel.text = "-"
        valueLabel.sizeToFit()

        changeButton.setTitle("Change", for: .normal)
        let buttonTextColor = UIColor(red: 0.184, green: 0.502, blue: 0.929, alpha: 1)
        changeButton.setTitleColor(buttonTextColor, for: .normal)
        changeButton.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 18)
        changeButton.addTarget(self, action: #selector(changeButtonDidTapped), for: .touchUpInside)
    }

    private func configureConstraints() {
        titleLabel.pin
            .top(to: self)
            .centerX(in: self)
            .height(to: 27)

        valueLabel.pin
            .below(of: titleLabel)
            .centerX(in: titleLabel)
            .height(to: 18)

        changeButton.pin
            .below(of: valueLabel)
            .centerX(in: titleLabel)
            .height(to: 27)
    }

    // MARK: - Helpers
    @objc func changeButtonDidTapped() {
        changeSubject.send()
    }
}
