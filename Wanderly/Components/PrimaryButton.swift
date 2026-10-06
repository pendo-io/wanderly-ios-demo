import UIKit

final class PrimaryButton: UIButton {
    enum Style {
        case filled
        case tinted
    }

    init(title: String, symbol: String? = nil, style: Style = .filled, action: @escaping () -> Void) {
        super.init(frame: .zero)
        var configuration: UIButton.Configuration = style == .filled ? .filled() : .tinted()
        configuration.title = title
        configuration.image = symbol.flatMap { UIImage(systemName: $0) }
        configuration.imagePadding = Theme.Spacing.small
        configuration.cornerStyle = .large
        configuration.buttonSize = .large
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var updated = attributes
            updated.font = Theme.roundedFont(.headline, weight: .semibold)
            return updated
        }
        self.configuration = configuration
        addAction(UIAction { _ in action() }, for: .primaryActionTriggered)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }
}
