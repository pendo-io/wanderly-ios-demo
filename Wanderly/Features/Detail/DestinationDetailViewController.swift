import UIKit

final class DestinationDetailViewController: UIViewController {
    private let destination: Destination
    private let tripStore: TripStore

    init(destination: Destination, tripStore: TripStore) {
        self.destination = destination
        self.tripStore = tripStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = destination.name
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = Theme.Color.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .action, primaryAction: UIAction { [weak self] _ in self?.showShareOptions() })
        setUpViews()
    }

    private func setUpViews() {
        let hero = makeHero()
        let infoCard = makeInfoCard()
        let addButton = PrimaryButton(title: "Add to my trips", symbol: "plus.circle.fill") { [weak self] in self?.confirmAddToTrips() }

        let stack = UIStackView(arrangedSubviews: [hero, infoCard, addButton])
        stack.axis = .vertical
        stack.spacing = Theme.Spacing.large
        stack.translatesAutoresizingMaskIntoConstraints = false

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Theme.Spacing.medium),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            stack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: Theme.Spacing.medium),
            stack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -Theme.Spacing.medium),
            hero.heightAnchor.constraint(equalToConstant: 240)
        ])
    }

    private func makeHero() -> UIView {
        let hero = GradientView(colors: destination.colors)
        hero.layer.cornerRadius = Theme.Radius.card + 8
        hero.layer.cornerCurve = .continuous
        hero.clipsToBounds = true

        let icon = UIImageView(image: UIImage(systemName: destination.symbol))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        hero.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: hero.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: hero.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 110),
            icon.heightAnchor.constraint(equalToConstant: 110)
        ])
        return hero
    }

    private func makeInfoCard() -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Color.card
        card.layer.cornerRadius = Theme.Radius.card
        card.layer.cornerCurve = .continuous

        let countryLabel = UILabel()
        countryLabel.text = destination.country.uppercased()
        countryLabel.font = .preferredFont(forTextStyle: .caption1)
        countryLabel.textColor = .secondaryLabel

        let summaryLabel = UILabel()
        summaryLabel.text = destination.summary
        summaryLabel.font = .preferredFont(forTextStyle: .body)
        summaryLabel.numberOfLines = 0

        let stats = UIStackView(arrangedSubviews: [
            statView(value: "★ \(destination.rating)", caption: "Rating"),
            statView(value: "$\(destination.pricePerNight)", caption: "Per night")
        ])
        stats.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [countryLabel, summaryLabel, stats])
        stack.axis = .vertical
        stack.spacing = Theme.Spacing.medium
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: Theme.Spacing.medium),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Theme.Spacing.medium),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Theme.Spacing.medium),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Theme.Spacing.medium)
        ])
        return card
    }

    private func statView(value: String, caption: String) -> UIView {
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = Theme.roundedFont(.title3, weight: .bold)
        valueLabel.textColor = Theme.Color.accent

        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = .preferredFont(forTextStyle: .caption1)
        captionLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [valueLabel, captionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }

    private func confirmAddToTrips() {
        guard !tripStore.contains(destination) else {
            ToastView.show("\(destination.name) is already in your trips", symbol: "info.circle.fill", in: view)
            return
        }
        let alert = UIAlertController(title: "Add \(destination.name)?", message: "We'll save it to your trips so you can plan later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in self?.addToTrips() })
        present(alert, animated: true)
    }

    private func addToTrips() {
        tripStore.add(destination)
        let popup = CardPopupViewController(symbol: "checkmark.seal.fill", headline: "Trip saved!", message: "\(destination.name) is waiting for you in the Trips tab.", buttonTitle: "Awesome", colors: destination.colors)
        present(popup, animated: true)
    }

    private func showShareOptions() {
        let sheet = UIAlertController(title: destination.name, message: "Share this destination", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Copy link", style: .default) { [weak self] _ in self?.copyLink() })
        sheet.addAction(UIAlertAction(title: "Share…", style: .default) { [weak self] _ in self?.presentShareSheet() })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(sheet, animated: true)
    }

    private func copyLink() {
        UIPasteboard.general.string = shareText
        ToastView.show("Link copied", symbol: "link", in: view)
    }

    private func presentShareSheet() {
        let activity = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activity, animated: true)
    }

    private var shareText: String {
        "Let's go to \(destination.name), \(destination.country)! https://example.com/wanderly/\(destination.id)"
    }
}
