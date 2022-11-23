import EasyAutolayout
import UIKit

final class MovieCell: UITableViewCell {

    // MARK: - Properties
    // MARK: Public
    static let reuseIdentifier = "MoviewCell"
    static let cellHeight: CGFloat = 212 + 20
    static let defaultPreview = UIImage(systemName: "photo")

    // MARK: Private
    private let boxView = UIView()
    private let previewImageView = UIImageView()
    private let textGroupView = UIView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview()
        configureConstraints()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API
    func updateView(title: String?, raiting: String?, preview: UIImage?) {}

    // MARK: - Setups
    private func addSubview() {
        boxView.addSubview(previewImageView)
        boxView.addSubview(textGroupView)

        textGroupView.addSubview(titleLabel)
        textGroupView.addSubview(ratingLabel)

        contentView.addSubview(boxView)
    }

    private func configureUI() {
        selectionStyle = UITableViewCell.SelectionStyle.none

        contentView.backgroundColor = ColorScheme.tableViewBackground

        boxView.backgroundColor = ColorScheme.cellBackground
        boxView.layer.cornerRadius = 8
        boxView.dropShadow()

        previewImageView.contentMode = .scaleAspectFit
        previewImageView.image = MovieCell.defaultPreview

        titleLabel.font = UIFont(name: "Manrope-Medium", size: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = "Test"
        titleLabel.sizeToFit()

        ratingLabel.font = UIFont(name: "Manrope", size: 18)
        ratingLabel.textAlignment = .center
        ratingLabel.text = "0 / 10"
        ratingLabel.sizeToFit()
    }

    private func configureConstraints() {
        boxView.pin
            .edges([.top, .left, .right, .bottom], to: contentView, insets: .init(top: 8, left: 16, bottom: 8, right: 16))

        textGroupView.pin
            .top(to: boxView)
            .trailing(to: boxView)
            .bottom(to: boxView)
            .width(to: 138)

        previewImageView.pin
            .top(to: boxView)
            .bottom(to: boxView)
            .leading(to: boxView)
            .before(of: textGroupView)

        titleLabel.pin
            .top(to: textGroupView, offset: 34)
            .centerX(in: textGroupView)

        ratingLabel.pin
            .top(to: titleLabel, offset: 45)
            .centerX(in: textGroupView)
    }
    // MARK: - Helpers
}
