import Combine
import EasyAutolayout
import UIKit

final class ChangableAttributeView<TYPE>: UIView {

    // MARK: - Properties
    // MARK: Public
    // MARK: Private
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let changeButton = UIButton()
    
    // MARK: - Subjects
    let titleSubject = CurrentValueSubject<String, Never>("")
    let valueSubject = CurrentValueSubject<TYPE?, Never>(nil)
    let changeButtonSubject = PassthroughSubject<TYPE?, Never>()

    private var cancellables: Set<AnyCancellable> = []
    private var formatter: Formatter?
    
    // MARK: - Lifecycle
    convenience init(title: String) {
        self.init(title: title, formatter: nil)
    }
    
    convenience init(title: String, formatter: Formatter?) {
        self.init(frame: CGRect.zero)
        titleSubject.value = title
        self.formatter = formatter
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview()
        configureUI()
        configureConstraints()
        configureSubjects()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API
    // MARK: - Setups
    private func addSubview() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(changeButton)
    }

    private func configureUI() {
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 18)
        titleLabel.textAlignment = .center
        
        valueLabel.font = UIFont(name: "Manrope-Medium", size: 18)
        valueLabel.textAlignment = .center

        changeButton.setTitle("Change", for: .normal)
        let buttonTextColor = UIColor(red: 0.184, green: 0.502, blue: 0.929, alpha: 1)
        changeButton.setTitleColor(buttonTextColor, for: .normal)
        changeButton.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 18)
        changeButton.addTarget(self, action: #selector(changeButtonDidTapped), for: .touchUpInside)
    }

    private func configureConstraints() {
        titleLabel.pin
            .top(to: self)
            .leading(to: self)
            .trailing(to: self)
            .height(to: 27)

        valueLabel.pin
            .below(of: titleLabel)
            .leading(to: self)
            .trailing(to: self)
            .height(to: 18)

        changeButton.pin
            .below(of: valueLabel)
            .leading(to: self)
            .trailing(to: self)
            .height(to: 27)
    }
    
    private func configureSubjects() {
        titleSubject.sink { [weak self] title in
            self?.titleLabel.text = title
        }
        .store(in: &cancellables)
        
        valueSubject.sink { [weak self] value in
            self?.valueLabel.text = self?.format(value: value)
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Helpers
    @objc private func changeButtonDidTapped() {
        changeButtonSubject.send(valueSubject.value)
    }
    
    private func format(value: TYPE?) -> String {
        guard let value else {
            return "-"
        }
        
        return formatter?.string(for: value) ?? "\(value)"
    }
    
}
