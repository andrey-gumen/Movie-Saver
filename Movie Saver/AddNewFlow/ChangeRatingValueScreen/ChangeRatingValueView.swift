import Combine
import UIKit

final class ChangeRatingValueView: UIViewController {

    // MARK: - Properties
    var viewModel: ChangeRatingValueViewModel!

    // MARK: Public
    // MARK: Private
    private let titleLabel = UILabel()
    private let numberPicker = UIPickerView()
    private let saveButton = UIButton()
    private let pickerValues: [Float] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    // MARK: - Subjects
    private var cancellables: Set<AnyCancellable> = []

    // local cache for value
    private let valueSubject = CurrentValueSubject<Float, Never>(10)
    private var isValueValidPublisher: AnyPublisher<Bool, Never> {
        valueSubject
            .map { $0 >= 0 && $0 <= 10 }
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
        view.addSubview(numberPicker)
        view.addSubview(saveButton)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground

        titleLabel.text = "Your Rating"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 24)

        numberPicker.delegate = self
        numberPicker.dataSource = self

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

        numberPicker.pin
            .below(of: titleLabel, offset: 42)
            .centerX(in: view)

        saveButton.pin
            .below(of: numberPicker, offset: 42)
            .centerX(in: view)
            .size(to: CGSize(width: 79, height: 27))
    }

    // MARK: - Helpers
    @objc private func saveButtonDidTapped() {
        viewModel.valueSubject.send(valueSubject.value)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UIPickerViewDelegate / UIPickerViewDataSource

extension ChangeRatingValueView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerValues.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        String(format: "%.1f", pickerValues[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        valueSubject.send(pickerValues[row])
    }
}
