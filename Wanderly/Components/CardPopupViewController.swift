import UIKit

final class CardPopupViewController: UIViewController {
    private let symbol: String
    private let headline: String
    private let message: String
    private let buttonTitle: String
    private let colors: [UIColor]
    private let onDismiss: (() -> Void)?

    private let dimmingView = UIView()
    private let cardView = UIView()

    init(symbol: String, headline: String, message: String, buttonTitle: String, colors: [UIColor], onDismiss: (() -> Void)? = nil) {
        self.symbol = symbol
        self.headline = headline
        self.message = message
        self.buttonTitle = buttonTitle
        self.colors = colors
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDimming()
        setUpCard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6) {
            self.cardView.transform = .identity
        }
    }

    private func setUpDimming() {
        dimmingView.backgroundColor = Theme.Color.dimming
        dimmingView.frame = view.bounds
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        view.addSubview(dimmingView)
    }

    private func setUpCard() {
        cardView.backgroundColor = Theme.Color.card
        cardView.layer.cornerRadius = Theme.Radius.card + 8
        cardView.layer.cornerCurve = .continuous
        cardView.clipsToBounds = true

        let header = GradientView(colors: colors)
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text = headline
        titleLabel.font = Theme.roundedFont(.title2, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        let button = PrimaryButton(title: buttonTitle) { [weak self] in self?.close() }

        let body = UIStackView(arrangedSubviews: [titleLabel, messageLabel, button])
        body.axis = .vertical
        body.spacing = Theme.Spacing.medium
        body.setCustomSpacing(Theme.Spacing.large, after: messageLabel)

        [cardView, header, icon, body].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubview(cardView)
        header.addSubview(icon)
        cardView.addSubview(header)
        cardView.addSubview(body)

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.82),
            cardView.widthAnchor.constraint(lessThanOrEqualToConstant: 380),

            header.topAnchor.constraint(equalTo: cardView.topAnchor),
            header.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 140),

            icon.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 64),
            icon.heightAnchor.constraint(equalToConstant: 64),

            body.topAnchor.constraint(equalTo: header.bottomAnchor, constant: Theme.Spacing.large),
            body.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Theme.Spacing.large),
            body.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Theme.Spacing.large),
            body.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Theme.Spacing.large)
        ])
    }

    @objc private func close() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        dismiss(animated: true) { [onDismiss] in onDismiss?() }
    }
}
