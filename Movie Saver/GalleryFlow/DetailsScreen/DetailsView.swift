import Combine
import UIKit
import WebKit

final class DetailsView: UIViewController {

    // MARK: - Properties
    var viewModel: DetailsViewModel!

    // MARK: Public
    // MARK: Private
    private let posterImageView = UIImageView()

    private let infoContainer = UIView()

    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let trailerView = WKWebView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        configureUI()
        configureConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView(movie: viewModel?.moviewSubject.value)
    }

    // MARK: - API
    func updateView(movie: Movie?) {
        posterImageView.image = movie?.poster
        titleLabel.text = movie?.title ?? "-"
        ratingLabel.attributedText = formRatingInformation(movie)
        descriptionTextView.text = movie?.notes ?? ""
        
        trailerView.isHidden = movie?.youtubeLink == nil
        if let url = movie?.youtubeLink {
            let trailerRequest = URLRequest(url: url)
            trailerView.load(trailerRequest)
        }
    }
    
    // MARK: - Setups
    private func addSubview() {
        view.addSubview(posterImageView)

        view.addSubview(infoContainer)
        infoContainer.addSubview(titleLabel)
        infoContainer.addSubview(ratingLabel)
        infoContainer.addSubview(descriptionTextView)
        infoContainer.addSubview(trailerView)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = ColorScheme.tableViewBackground
        
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 24)
        titleLabel.numberOfLines = 2
        
        infoContainer.backgroundColor = ColorScheme.viewBackground
        infoContainer.layer.cornerRadius = 16
        
        ratingLabel.textAlignment = .left
        ratingLabel.font = UIFont(name: "Manrope-Bold", size: 14)
        
        descriptionTextView.textAlignment = .left
        descriptionTextView.font = UIFont(name: "Manrope-Regular", size: 14)
        descriptionTextView.isEditable = false
        
        trailerView.contentMode = .center
    }

    private func configureConstraints() {
        posterImageView.pin
            .top(to: view)
            .leading(to: view)
            .trailing(to: view)
            .height(to: 286)
        
        infoContainer.pin
            .below(of: posterImageView, offset: -29)
            .centerX(in: view)
            .bottom(to: view)
            .width(to: 375)
        
        titleLabel.pin
            .top(to: infoContainer)
            .leading(to: infoContainer, offset: 19)
            .trailing(to: infoContainer, offset: -19)
            .height(to: 65)
        
        ratingLabel.pin
            .below(of: titleLabel, offset: 14)
            .leading(to: infoContainer, offset: 19)
            .trailing(to: infoContainer, offset: -19)
            .height(to: 24)
        
        descriptionTextView.pin
            .below(of: ratingLabel, offset: 13)
            .leading(to: infoContainer, offset: 19)
            .trailing(to: infoContainer, offset: -19)
            .height(to: 138)

        trailerView.pin
            .bottom(to: descriptionTextView, offset: 24)
            .leading(to: infoContainer, offset: 19)
            .trailing(to: infoContainer, offset: -19)
            .height(to: 196)
    }


    // MARK: - Helpers
    private func formRatingInformation(_ movie: Movie?) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "star.fill")
        
        let firstAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Manrope-Bold", size: 14)!
        ]
        let secondAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Manrope-Light", size: 14)!
        ]
        let thirdAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.592, green: 0.592, blue: 0.592, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: "Manrope-Light", size: 14)!
        ]

        let firstString = NSMutableAttributedString(string: movie?.rating != nil ? "  \(movie!.rating!)" : "-", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "/10", attributes: secondAttributes)
        let thirdString = NSAttributedString(string: movie?.releaseDate != nil ? " \(movie!.releaseDate!)" : "-", attributes: thirdAttributes)
        
        let result = NSMutableAttributedString(attachment: attachment)
        result.append(firstString)
        result.append(secondString)
        result.append(thirdString)
        return result
    }
}
