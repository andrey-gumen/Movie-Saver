import Combine
import UIKit

final class AddNewView: UIViewController {

    // MARK: - Properties
    var viewModel: AddNewViewModel!

    // MARK: Public
    // MARK: Private
    private static let defaultPreview = UIImage(systemName: "photo")
    private var cancellables: Set<AnyCancellable> = []

    private let titleLabel = UILabel()
    
    private let previewButton = UIButton()

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
        
        view.addSubview(previewButton)

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
        
        previewButton.backgroundColor = UIColor(red: 0.868, green: 0.868, blue: 0.868, alpha: 1)
        

        previewButton.contentHorizontalAlignment = .fill
        previewButton.contentVerticalAlignment = .fill
        previewButton.layer.cornerRadius = 75
        previewButton.clipsToBounds = true
        previewButton.setImage(AddNewView.defaultPreview, for: .normal)
        
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
        
        previewButton.pin
            .below(of: titleLabel, offset: 35)
            .centerX(in: view)
            .size(to: CGSize(width: 150, height: 150))

        changablesContainer.pin
            .below(of: previewButton, offset: 32)
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
