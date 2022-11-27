import Combine
import UIKit

final class AddNewMovieView: UIViewController {

    // MARK: - Properties
    var inputs: AddNewMovieViewModelInputs!
    var outputs: AddNewMovieViewModelOutputs!

    // MARK: Public
    // MARK: Private
    private let titleLabel = UILabel()
    private var saveButton: UIBarButtonItem?

    private let previewPicker = PreviewPicker()

    private let changablesContainer = UIView()
    private let nameView = ChangableAttributeView<String>(title: "Name")
    private let releaseDateView = ChangableAttributeView<Date>(title: "Release Date", formatter: ShortDateFormatter())
    private let yourRatingView = ChangableAttributeView<Float>(title: "Your Rating", formatter: RatingFormatter())
    private let youtubeLinkView = ChangableAttributeView<String>(title: "Youtube Link")

    private let descriptionTitleLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    //MARK: - Subjects
    private var cancellables: Set<AnyCancellable> = []
        
    private var isNameValidPublisher: AnyPublisher<Bool, Never>{
        nameView.valueSubject
            .map { $0?.isEmpty == false }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    private var isReleaseDateValidPublisher: AnyPublisher<Bool, Never>{
        releaseDateView.valueSubject
            .map { $0?.compare(Date.now) != .orderedDescending }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    private var isRatingValidPublisher: AnyPublisher<Bool, Never>{
        yourRatingView.valueSubject
            .map { $0 != nil ? ($0! >= 0 && $0! <= 10) : false }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    private var isDataValidPublisher: AnyPublisher<Bool, Never>{
        Publishers.CombineLatest3(
            isNameValidPublisher,
            isReleaseDateValidPublisher,
            isRatingValidPublisher
        )
        .map { $0 && $1 && $2 }
        .eraseToAnyPublisher()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        configureUI()
        configureConstraints()
        configureSubjects()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureToolbar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        restoreToolbar()
        if isMovingFromParent {
            outputs.movedFromParentSubject.send()
        }
    }

    // MARK: - API
    // MARK: - Setups
    private func addSubview() {
        view.addSubview(titleLabel)

        view.addSubview(previewPicker)

        view.addSubview(changablesContainer)
        changablesContainer.addSubview(nameView)
        changablesContainer.addSubview(releaseDateView)
        changablesContainer.addSubview(yourRatingView)
        changablesContainer.addSubview(youtubeLinkView)

        view.addSubview(descriptionTitleLabel)
        view.addSubview(descriptionTextView)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground

        titleLabel.text = "Add new"
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34)

        previewPicker.viewCntroller = self

        descriptionTitleLabel.text = "Description"
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.font = UIFont(name: "Manrope-Medium", size: 18)

        descriptionTextView.font = UIFont(name: "Manrope-Regular", size: 14)
        descriptionTextView.textAlignment = .left
        descriptionTextView.delegate = self
        textViewDidEndEditing(descriptionTextView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    private func configureConstraints() {
        titleLabel.pin
            .top(to: view.safeAreaLayoutGuide)
            .leading(to: view, offset: 16)
            .trailing(to: view, offset: 16)
            .height(to: 41)

        previewPicker.pin
            .below(of: titleLabel, offset: 35)
            .centerX(in: view)
            .size(to: CGSize(width: 150, height: 150))

        changablesContainer.pin
            .below(of: previewPicker, offset: 32)
            .centerX(in: view)
            .size(to: CGSize(width: 125 + 45 + 125, height: 82 + 32 + 82))

        nameView.pin
            .top(to: changablesContainer)
            .leading(to: changablesContainer)
            .size(to: CGSize(width: 125, height: 82))

        releaseDateView.pin
            .bottom(to: changablesContainer)
            .leading(to: changablesContainer)
            .size(to: CGSize(width: 125, height: 82))

        yourRatingView.pin
            .top(to: changablesContainer)
            .trailing(to: changablesContainer)
            .size(to: CGSize(width: 125, height: 82))

        youtubeLinkView.pin
            .bottom(to: changablesContainer)
            .trailing(to: changablesContainer)
            .size(to: CGSize(width: 125, height: 82))

        descriptionTitleLabel.pin
            .below(of: changablesContainer, offset: 36)
            .centerX(in: view)
            .size(to: CGSize(width: 311, height: 26))

        descriptionTextView.pin
            .below(of: descriptionTitleLabel, offset: 11)
            .centerX(in: view)
            .size(to: CGSize(width: 311, height: 145))
    }

    private func configureSubjects() {
        // outputs
        nameView.changeButtonSubject
            .sink { [weak self] value in self?.outputs.nameSubject.send(value) }
            .store(in: &cancellables)
        releaseDateView.changeButtonSubject
            .sink { [weak self] value in self?.outputs.releaseDateSubject.send(value) }
            .store(in: &cancellables)
        yourRatingView.changeButtonSubject
            .sink { [weak self] value in self?.outputs.ratingSubject.send(value) }
            .store(in: &cancellables)
        youtubeLinkView.changeButtonSubject
            .sink { [weak self] value in self?.outputs.youtubeLinkSubject.send(value) }
            .store(in: &cancellables)

        // inputs
        inputs.nameSubject
            .sink { [weak self] value in self?.nameView.valueSubject.send(value) }
            .store(in: &cancellables)
        inputs.releaseDateSubject
            .sink { [weak self] value in self?.releaseDateView.valueSubject.send(value) }
            .store(in: &cancellables)
        inputs.ratingSubject
            .sink { [weak self] value in self?.yourRatingView.valueSubject.send(value) }
            .store(in: &cancellables)
        inputs.youtubeLinkSubject
            .sink { [weak self] value in self?.youtubeLinkView.valueSubject.send(value) }
            .store(in: &cancellables)
    }

    private func configureToolbar() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonDidTapped))
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationController?.isToolbarHidden = false
        
        // ui
        isDataValidPublisher
            .assign(to: \.isEnabled, on: saveButton!)
            .store(in: &cancellables)
    }

    private func restoreToolbar() {
        saveButton = nil
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Helpers
    @objc private func saveButtonDidTapped() {
        let movie = Movie(
            poster: previewPicker.preview,
            title: nameView.valueSubject.value,
            releaseDate: releaseDateView.valueSubject.value,
            rating: yourRatingView.valueSubject.value,
            youtubeLink: youtubeLinkView.valueSubject.value?.toURL(),
            notes: descriptionTextView.text
        )
        outputs.saveMovieSubject.send(movie)
        outputs.movedFromParentSubject.send()
    }

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        descriptionTextView.resignFirstResponder()
    }
}

// MARK: TextView extension

extension AddNewMovieView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = .lightGray
        }
    }
}
