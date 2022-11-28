import Combine
import UIKit
import WebKit

final class DetailsView: UIViewController {

    // MARK: - Properties
    var viewModel: DetailsViewModel!

    // MARK: Public
    // MARK: Private
    private let posterImageView = UIImageView()

    private let infocontainer = UIView()
    private let infoPadding = UIView()

    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private let trailerView = WKWebView()
    private var webviewHeightConstraint: NSLayoutConstraint?

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
        
        //trailerView.isHidden = movie?.youtubeLink == nil
        if let url = movie?.youtubeLink {
            let trailerRequest = URLRequest(url: url)
            trailerView.load(trailerRequest)
        }
    }
    
    // MARK: - Setups
    private func addSubview() {
        view.addSubview(posterImageView)

        view.addSubview(infocontainer)
        infocontainer.addSubview(infoPadding)
        infoPadding.addSubview(titleLabel)
        infoPadding.addSubview(ratingLabel)
        infoPadding.addSubview(descriptionTextView)
        infoPadding.addSubview(trailerView)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.viewBackground
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = ColorScheme.tableViewBackground
        
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 24)
        titleLabel.numberOfLines = 2
        
        infocontainer.backgroundColor = ColorScheme.viewBackground
        infocontainer.layer.cornerRadius = 16
        
        ratingLabel.textAlignment = .left
        ratingLabel.font = UIFont(name: "Manrope-Bold", size: 14)
        
        descriptionTextView.textAlignment = .left
        descriptionTextView.font = UIFont(name: "Manrope-Regular", size: 14)
        descriptionTextView.isEditable = false
        
        trailerView.contentMode = .center
        trailerView.navigationDelegate = self
    }

    private func configureConstraints() {
        posterImageView.pin
            .top(to: view)
            .leading(to: view)
            .trailing(to: view)
            .height(to: 286)
        
        infocontainer.pin
            .below(of: posterImageView, offset: -29)
            .leading(to: view)
            .trailing(to: view)
            .bottom(to: view)
        
        infoPadding.pin
            .top(to: infocontainer)
            .centerX(in: infocontainer)
            .bottom(to: infocontainer)
            .width(to: 375)
        
        titleLabel.pin
            .top(to: infoPadding)
            .leading(to: infoPadding, offset: 19)
            .trailing(to: infoPadding, offset: -19)
            .height(to: 65)
        
        ratingLabel.pin
            .below(of: titleLabel, offset: 14)
            .leading(to: infoPadding, offset: 19)
            .trailing(to: infoPadding, offset: -19)
            .height(to: 24)
        
        descriptionTextView.pin
            .below(of: ratingLabel, offset: 13)
            .leading(to: infoPadding, offset: 19)
            .trailing(to: infoPadding, offset: -19)
            .height(to: 138)

        trailerView.translatesAutoresizingMaskIntoConstraints = false
        trailerView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24).isActive = true
        trailerView.leadingAnchor.constraint(equalTo: infoPadding.leadingAnchor, constant: 19).isActive = true
        trailerView.trailingAnchor.constraint(equalTo: infoPadding.trailingAnchor, constant: -19).isActive = true
        
        webviewHeightConstraint = trailerView.heightAnchor.constraint(equalToConstant: 196)
        webviewHeightConstraint?.isActive = true
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

extension DetailsView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.webviewHeightConstraint?.constant = webView.scrollView.contentSize.height
        }
    }
}
