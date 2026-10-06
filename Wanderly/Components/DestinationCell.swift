import UIKit

final class DestinationCell: UICollectionViewCell {
    static let reuseIdentifier = "DestinationCell"

    private let backgroundGradient = GradientView()
    private let iconView = UIImageView()
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    private let ratingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    func configure(with destination: Destination) {
        backgroundGradient.colors = destination.colors
        iconView.image = UIImage(systemName: destination.symbol)
        nameLabel.text = destination.name
        detailLabel.text = "\(destination.country) · from $\(destination.pricePerNight)/night"
        ratingLabel.text = "★ \(destination.rating)"
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }

    private func setUpViews() {
        contentView.layer.cornerRadius = Theme.Radius.card
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 6)

        iconView.tintColor = .white.withAlphaComponent(0.9)
        iconView.contentMode = .scaleAspectFit
        nameLabel.font = Theme.roundedFont(.title2, weight: .bold)
        nameLabel.textColor = .white
        detailLabel.font = Theme.roundedFont(.subheadline, weight: .medium)
        detailLabel.textColor = .white.withAlphaComponent(0.85)
        ratingLabel.font = Theme.roundedFont(.footnote, weight: .bold)
        ratingLabel.textColor = .white
        ratingLabel.backgroundColor = .black.withAlphaComponent(0.2)
        ratingLabel.layer.cornerRadius = 10
        ratingLabel.clipsToBounds = true
        ratingLabel.textAlignment = .center

        let textStack = UIStackView(arrangedSubviews: [nameLabel, detailLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        [backgroundGradient, iconView, textStack, ratingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            backgroundGradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundGradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundGradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundGradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.Spacing.medium),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            iconView.widthAnchor.constraint(equalToConstant: 72),
            iconView.heightAnchor.constraint(equalToConstant: 72),

            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.Spacing.medium),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Theme.Spacing.medium),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: iconView.leadingAnchor, constant: -Theme.Spacing.small),

            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.Spacing.medium),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.Spacing.medium),
            ratingLabel.widthAnchor.constraint(equalToConstant: 56),
            ratingLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
