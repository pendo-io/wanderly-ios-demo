import UIKit

final class ToastView: UIView {
    private let label = UILabel()
    private let iconView = UIImageView()

    private init(message: String, symbol: String) {
        super.init(frame: .zero)
        backgroundColor = .label.withAlphaComponent(0.9)
        layer.cornerRadius = 22
        layer.cornerCurve = .continuous

        iconView.image = UIImage(systemName: symbol)
        iconView.tintColor = .systemBackground
        label.text = message
        label.textColor = .systemBackground
        label.font = Theme.roundedFont(.subheadline, weight: .semibold)
        label.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.spacing = Theme.Spacing.small
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    static func show(_ message: String, symbol: String = "checkmark.circle.fill", in view: UIView) {
        let toast = ToastView(message: message, symbol: symbol)
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0
        toast.transform = CGAffineTransform(translationX: 0, y: 30)
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Theme.Spacing.large),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Theme.Spacing.large)
        ])

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5) {
            toast.alpha = 1
            toast.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 1.8) {
                toast.alpha = 0
                toast.transform = CGAffineTransform(translationX: 0, y: 20)
            } completion: { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
