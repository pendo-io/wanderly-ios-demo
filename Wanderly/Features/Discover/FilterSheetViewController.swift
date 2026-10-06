import UIKit

final class FilterSheetViewController: UIViewController {
    private var filter: DestinationFilter
    private let onApply: (DestinationFilter) -> Void

    private let priceLabel = UILabel()
    private let priceSlider = UISlider()
    private let sortControl = UISegmentedControl(items: DestinationSort.allCases.map(\.rawValue))

    init(filter: DestinationFilter, onApply: @escaping (DestinationFilter) -> Void) {
        self.filter = filter
        self.onApply = onApply
        super.init(nibName: nil, bundle: nil)
        configureSheet()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpViews()
        render()
    }

    private func configureSheet() {
        guard let sheet = sheetPresentationController else { return }
        sheet.detents = [.medium()]
        sheet.prefersGrabberVisible = true
        sheet.preferredCornerRadius = Theme.Radius.card + 8
    }

    private func setUpViews() {
        let titleLabel = UILabel()
        titleLabel.text = "Filters"
        titleLabel.font = Theme.roundedFont(.title2, weight: .bold)

        let sortTitle = sectionLabel("Sort by")
        sortControl.addAction(UIAction { [weak self] _ in self?.sortChanged() }, for: .valueChanged)

        let priceTitle = sectionLabel("Max price per night")
        priceLabel.font = Theme.roundedFont(.headline, weight: .semibold)
        priceLabel.textColor = Theme.Color.accent
        priceSlider.minimumValue = 80
        priceSlider.maximumValue = 250
        priceSlider.addAction(UIAction { [weak self] _ in self?.priceChanged() }, for: .valueChanged)

        let priceHeader = UIStackView(arrangedSubviews: [priceTitle, priceLabel])
        let applyButton = PrimaryButton(title: "Show results", symbol: "line.3.horizontal.decrease") { [weak self] in self?.apply() }

        let stack = UIStackView(arrangedSubviews: [titleLabel, sortTitle, sortControl, priceHeader, priceSlider, applyButton])
        stack.axis = .vertical
        stack.spacing = Theme.Spacing.small
        stack.setCustomSpacing(Theme.Spacing.large, after: titleLabel)
        stack.setCustomSpacing(Theme.Spacing.large, after: sortControl)
        stack.setCustomSpacing(Theme.Spacing.large, after: priceSlider)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.Spacing.large + 8),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.Spacing.large),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.Spacing.large)
        ])
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }

    private func render() {
        sortControl.selectedSegmentIndex = DestinationSort.allCases.firstIndex(of: filter.sort) ?? 0
        priceSlider.value = Float(filter.maxPrice)
        priceLabel.text = "$\(filter.maxPrice)"
    }

    private func sortChanged() {
        filter.sort = DestinationSort.allCases[sortControl.selectedSegmentIndex]
    }

    private func priceChanged() {
        filter.maxPrice = Int(priceSlider.value.rounded())
        priceLabel.text = "$\(filter.maxPrice)"
    }

    private func apply() {
        onApply(filter)
        dismiss(animated: true)
    }
}
