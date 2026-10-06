import UIKit

enum Theme {
    enum Color {
        static let accent = UIColor(named: "AccentColor") ?? .systemIndigo
        static let background = UIColor.systemGroupedBackground
        static let card = UIColor.secondarySystemGroupedBackground
        static let dimming = UIColor.black.withAlphaComponent(0.45)
    }

    enum Radius {
        static let card: CGFloat = 20
        static let button: CGFloat = 14
    }

    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    struct RGB: Hashable, Sendable {
        let red: Double
        let green: Double
        let blue: Double

        init(_ red: Double, _ green: Double, _ blue: Double) {
            self.red = red
            self.green = green
            self.blue = blue
        }

        var color: UIColor { UIColor(red: red, green: green, blue: blue, alpha: 1) }
    }

    static func roundedFont(_ style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let base = UIFont.preferredFont(forTextStyle: style)
        let font = UIFont.systemFont(ofSize: base.pointSize, weight: weight)
        guard let descriptor = font.fontDescriptor.withDesign(.rounded) else { return font }
        return UIFont(descriptor: descriptor, size: base.pointSize)
    }
}
