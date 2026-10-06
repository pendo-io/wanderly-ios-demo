import XCTest
@testable import Wanderly

@MainActor
final class TripStoreTests: XCTestCase {
    private var store: TripStore!
    private let kyoto = Destination.samples[0]
    private let reykjavik = Destination.samples[1]

    override func setUp() {
        super.setUp()
        store = TripStore()
    }

    override func tearDown() {
        store = nil
        super.tearDown()
    }

    func testAddAppendsDestination() {
        store.add(kyoto)

        XCTAssertEqual(store.trips, [kyoto])
        XCTAssertTrue(store.contains(kyoto))
    }

    func testAddIgnoresDuplicates() {
        store.add(kyoto)
        store.add(kyoto)

        XCTAssertEqual(store.trips.count, 1)
    }

    func testRemoveAtIndexRemovesOnlyThatTrip() {
        store.add(kyoto)
        store.add(reykjavik)

        store.remove(at: 0)

        XCTAssertEqual(store.trips, [reykjavik])
    }

    func testRemoveAllEmptiesTrips() {
        store.add(kyoto)
        store.add(reykjavik)

        store.removeAll()

        XCTAssertTrue(store.trips.isEmpty)
    }

    func testAddPostsChangeNotification() {
        let posted = expectation(forNotification: TripStore.didChangeNotification, object: store)

        store.add(kyoto)

        wait(for: [posted], timeout: 1)
    }

    func testDuplicateAddDoesNotPostNotification() {
        store.add(kyoto)
        let posted = expectation(forNotification: TripStore.didChangeNotification, object: store)
        posted.isInverted = true

        store.add(kyoto)

        wait(for: [posted], timeout: 0.2)
    }
}
