import UIKit

final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }

    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    var colors: [UIColor] = [] {
        didSet { gradientLayer.colors = colors.map(\.cgColor) }
    }

    init(colors: [UIColor] = []) {
        super.init(frame: .zero)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.colors = colors
        gradientLayer.colors = colors.map(\.cgColor)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }
}
