import Combine
import UIKit

final class ChangeDateValueView: UIViewController {

    // MARK: - Properties
    var viewModel: ChangeDateValueViewModel!

    // MARK: Public
    // MARK: Private
    private let titleLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let saveButton = UIButton()
    
    //MARK: - Subjects
    private var cancellables: Set<AnyCancellable> = []
        
    // local cache for value
    private let valueSubject = CurrentValueSubject<Date, Never>(Date.now)
    private var isValueValidPublisher: AnyPublisher<Bool, Never>{
        valueSubject
            .map { $0.compare(Date.now) == .orderedAscending }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    

    // MARK: - Lifecycle
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
        view.addSubview(datePicker)
        view.addSubview(saveButton)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground

        titleLabel.text = "Release Date"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 24)
        
        valueSubject.value = viewModel.valueSubject.value ?? Date.now
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = valueSubject.value
        datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
        
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
        
        datePicker.pin
            .below(of: titleLabel, offset: 42)
            .centerX(in: view)

        saveButton.pin
            .below(of: datePicker, offset: 42)
            .centerX(in: view)
            .size(to: CGSize(width: 79, height: 27))
    }

    // MARK: - Helpers
    @objc private func saveButtonDidTapped() {
        viewModel.valueSubject.send(valueSubject.value)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dateValueChanged(_ datePicker: UIDatePicker) {
        valueSubject.send(datePicker.date)
    }
}
