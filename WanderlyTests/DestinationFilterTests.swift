import XCTest
@testable import Wanderly

final class DestinationFilterTests: XCTestCase {
    private let samples = Destination.samples

    func testDefaultFilterKeepsFeaturedOrderAndAllItems() {
        XCTAssertEqual(DestinationFilter().apply(to: samples), samples)
    }

    func testRatingSortIsDescending() {
        let ratings = DestinationFilter(sort: .rating).apply(to: samples).map(\.rating)

        XCTAssertEqual(ratings, ratings.sorted(by: >))
    }

    func testPriceSortIsAscending() {
        let prices = DestinationFilter(sort: .price).apply(to: samples).map(\.pricePerNight)

        XCTAssertEqual(prices, prices.sorted())
    }

    func testMaxPriceExcludesMoreExpensiveDestinations() {
        let result = DestinationFilter(maxPrice: 150).apply(to: samples)

        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.allSatisfy { $0.pricePerNight <= 150 })
    }

    func testMaxPriceBelowEveryDestinationReturnsEmpty() {
        XCTAssertTrue(DestinationFilter(maxPrice: 10).apply(to: samples).isEmpty)
    }

    func testSampleIdentifiersAreUnique() {
        XCTAssertEqual(Set(samples.map(\.id)).count, samples.count)
    }
}
