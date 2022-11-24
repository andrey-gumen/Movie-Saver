import Combine
import UIKit

final class AddNewView: UIViewController {

    // MARK: - Properties
    var viewModel: AddNewViewModel!

    // MARK: Public
    // MARK: Private
    private var cancellables: Set<AnyCancellable> = []

    private let titleLabel = UILabel()
    
    private let previewPicker = PreviewPicker()

    private let changablesContainer = UIView()
    private let nameView = ChangableAttributeView()
    private let releaseDateView = ChangableAttributeView()
    private let yourRatingView = ChangableAttributeView()
    private let youtubeLinkView = ChangableAttributeView()
    
    private let descriptionTitleLabel = UILabel()
    private let descriptionTextField = UITextView()

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
            viewModel.movedFromParentSubject.send()
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
        view.addSubview(descriptionTextField)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground

        titleLabel.text = "Add new"
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        
        previewPicker.viewCntroller = self
        
        nameView.updateTille(title: "Name")
        releaseDateView.updateTille(title: "Release Date")
        yourRatingView.updateTille(title: "Your Rating")
        youtubeLinkView.updateTille(title: "Youtube Link")
        
        descriptionTitleLabel.text = "Description"
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.font = UIFont(name: "Manrope-Medium", size: 18)
        
        descriptionTextField.font = UIFont(name: "Manrope-Regular", size: 14)
        descriptionTextField.textAlignment = .left
        descriptionTextField.text = "With Spider-Man's identity now revealed, Peter asks Doctor Strange..."
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

        descriptionTextField.pin
            .below(of: descriptionTitleLabel, offset: 11)
            .centerX(in: view)
            .size(to: CGSize(width: 311, height: 145))
    }
    
    private func configureSubjects() {
        // outputs
        nameView.changeSubject
            .sink { [weak self] in
                self?.viewModel.changeNameSubject.send()
            }
            .store(in: &cancellables)
        
        releaseDateView.changeSubject
            .sink { [weak self] in
                self?.viewModel.changeReleaseDateSubject.send()
            }
            .store(in: &cancellables)
        
        yourRatingView.changeSubject
            .sink { [weak self] in
                self?.viewModel.changeRatingSubject.send()
            }
            .store(in: &cancellables)
        
        youtubeLinkView.changeSubject
            .sink { [weak self] in
                self?.viewModel.changeYoutubeLinkSubject.send()
            }
            .store(in: &cancellables)
        
        // inputs
        viewModel.nameValueSubject
            .sink { [weak self] value in
                self?.nameView.updateValue(value)
            }
            .store(in: &cancellables)
        
        viewModel.youtubeLinkValueSubject
            .sink { [weak self] value in
                self?.youtubeLinkView.updateValue(value)
            }
            .store(in: &cancellables)
    }

    private func configureToolbar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonDidTapped))
        navigationItem.setRightBarButton(barButton, animated: false)
        navigationController?.isToolbarHidden = false
    }

    private func restoreToolbar() {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Helpers
    @objc private func saveButtonDidTapped() {
        print(#function)
    }
}
