import UIKit

struct Destination: Hashable, Sendable {
    let id: Int
    let name: String
    let country: String
    let symbol: String
    let rating: Double
    let pricePerNight: Int
    let summary: String
    let gradient: [Theme.RGB]

    var colors: [UIColor] { gradient.map(\.color) }
}

extension Destination {
    static let samples: [Destination] = [
        Destination(id: 1, name: "Kyoto", country: "Japan", symbol: "building.columns.fill", rating: 4.9, pricePerNight: 180, summary: "Temples, tea houses and quiet gardens tucked between wooden streets.", gradient: [.init(0.95, 0.45, 0.55), .init(0.98, 0.70, 0.45)]),
        Destination(id: 2, name: "Reykjavík", country: "Iceland", symbol: "snowflake", rating: 4.7, pricePerNight: 210, summary: "Northern lights, hot springs and volcanic coastlines a short drive away.", gradient: [.init(0.30, 0.55, 0.95), .init(0.45, 0.85, 0.90)]),
        Destination(id: 3, name: "Marrakesh", country: "Morocco", symbol: "sun.max.fill", rating: 4.6, pricePerNight: 95, summary: "Spice-scented souks, riad courtyards and desert sunsets.", gradient: [.init(0.98, 0.55, 0.25), .init(0.95, 0.80, 0.35)]),
        Destination(id: 4, name: "Patagonia", country: "Chile", symbol: "mountain.2.fill", rating: 4.8, pricePerNight: 140, summary: "Granite towers, glacier lakes and trails at the end of the world.", gradient: [.init(0.25, 0.65, 0.55), .init(0.55, 0.85, 0.60)]),
        Destination(id: 5, name: "Santorini", country: "Greece", symbol: "water.waves", rating: 4.7, pricePerNight: 230, summary: "Whitewashed cliffs above a sapphire caldera.", gradient: [.init(0.35, 0.45, 0.95), .init(0.60, 0.45, 0.95)]),
        Destination(id: 6, name: "Banff", country: "Canada", symbol: "tree.fill", rating: 4.8, pricePerNight: 160, summary: "Turquoise lakes, elk on the roads and endless pine forests.", gradient: [.init(0.20, 0.60, 0.45), .init(0.30, 0.45, 0.70)])
    ]
}
