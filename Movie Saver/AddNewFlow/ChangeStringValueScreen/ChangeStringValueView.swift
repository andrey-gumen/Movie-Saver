import Combine
import UIKit

final class ChangeStringValueView: UIViewController {

    // MARK: - Properties
    var viewModel: ChangeStringValueViewModel!

    // MARK: Public
    // MARK: Private
    private var titleCache = ""
    
    private let titleLabel = UILabel()
    private let valueTextField = UITextField()
    private let saveButton = UIButton()
    
    //MARK: - Subjects
    private var cancellables: Set<AnyCancellable> = []
        
    private var isValueValidPublisher: AnyPublisher<Bool, Never>{
        viewModel.valueSubject
            .map { !$0.isEmpty }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    

    // MARK: - Lifecycle
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        titleCache = title
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

        titleLabel.text = titleCache
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 24)
        
        valueTextField.placeholder = "Name"
        valueTextField.textAlignment = .left
        valueTextField.font = UIFont(name: "Manrope-Regular", size: 17)
        valueTextField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func valueChanged(_ textField: UITextField) {
        viewModel.valueSubject.send(textField.text ?? "")
    }
}
