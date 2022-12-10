import Combine
import UIKit

final class ChangeStringValueView: UIViewController {

    // MARK: - Properties
    var viewModel: ChangeStringValueViewModel!

    // MARK: Public
    // MARK: Private
    private let titleLabel = UILabel()
    private let valueTextField = UITextField()
    private let saveButton = UIButton()
    private var validator: ((String) -> Bool)?
    
    //MARK: - Subjects
    private var cancellables: Set<AnyCancellable> = []
        
    // local cache for value
    private let valueSubject = CurrentValueSubject<String, Never>("")
    private var isValueValidPublisher: AnyPublisher<Bool, Never>{
        valueSubject
            .map { self.validator?($0) ?? false }
            .eraseToAnyPublisher()
    }
    

    // MARK: - Lifecycle
    init(title: String, keyboardType: UIKeyboardType = .default, validator: @escaping ((String) -> Bool) = { $0.isEmpty == false }) {
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        valueTextField.keyboardType = keyboardType
        self.validator = validator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        configureUI()
        configureConstraints()
    }

    // MARK: - API
    // MARK: - Setups
    private func addSubview() {
        view.addSubview(titleLabel)
        view.addSubview(valueTextField)
        view.addSubview(saveButton)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground

        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 24)
        
        valueSubject.value = viewModel.valueSubject.value ?? ""
        valueTextField.placeholder = "Name"
        valueTextField.text = valueSubject.value
        valueTextField.textAlignment = .left
        valueTextField.font = UIFont(name: "Manrope-Regular", size: 17)
        valueTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        valueTextField.becomeFirstResponder()
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.setTitleColor(.systemGray, for: .disabled)
        saveButton.addTarget(self, action: #selector(saveButtonDidTapped), for: .touchUpInside)
        
        isValueValidPublisher
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &cancellables)
    }

    private func configureConstraints() {
        titleLabel.pin
            .top(to: view.safeAreaLayoutGuide, offset: 124 - 48)
            .leading(to: view, offset: 16)
            .trailing(to: view, offset: 16)
            .height(to: 26)
        
        valueTextField.pin
            .below(of: titleLabel, offset: 42)
            .centerX(in: view)
            .size(to: CGSize(width: 326, height: 44))

        saveButton.pin
            .below(of: valueTextField, offset: 42)
            .centerX(in: view)
            .size(to: CGSize(width: 79, height: 27))
    }

    // MARK: - Helpers
    @objc private func saveButtonDidTapped() {
        viewModel.valueSubject.send(valueSubject.value)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func valueChanged(_ textField: UITextField) {
        valueSubject.send(textField.text ?? "")
    }
    
}
