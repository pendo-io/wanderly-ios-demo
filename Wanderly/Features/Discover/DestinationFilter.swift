import Foundation

enum DestinationSort: String, CaseIterable, Sendable {
    case featured = "Featured"
    case rating = "Top rated"
    case price = "Lowest price"

    func sorted(_ destinations: [Destination]) -> [Destination] {
        switch self {
        case .featured: destinations
        case .rating: destinations.sorted { $0.rating > $1.rating }
        case .price: destinations.sorted { $0.pricePerNight < $1.pricePerNight }
        }
    }
}

struct DestinationFilter: Equatable, Sendable {
    var sort: DestinationSort = .featured
    var maxPrice: Int = 250

    func apply(to destinations: [Destination]) -> [Destination] {
        sort.sorted(destinations.filter { $0.pricePerNight <= maxPrice })
    }
}
