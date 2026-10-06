import XCTest
@testable import Wanderly

@MainActor
final class ViewControllerTests: XCTestCase {
    private var store: TripStore!

    override func setUp() {
        super.setUp()
        store = TripStore()
    }

    override func tearDown() {
        store = nil
        super.tearDown()
    }

    func testTabBarHasThreeTabsInOrder() {
        let tabBar = MainTabBarController(tripStore: store)
        tabBar.loadViewIfNeeded()

        XCTAssertEqual(tabBar.viewControllers?.map(\.tabBarItem.title), ["Discover", "Trips", "Profile"])
    }

    func testTripsListReflectsStoreChanges() {
        let trips = TripsViewController(tripStore: store)
        trips.loadViewIfNeeded()
        XCTAssertEqual(trips.tableView.numberOfRows(inSection: 0), 0)
        XCTAssertNotNil(trips.tableView.backgroundView)

        store.add(Destination.samples[0])

        XCTAssertEqual(trips.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertNil(trips.tableView.backgroundView)
    }

    func testProfileShowsAllSettingsRows() {
        let profile = ProfileViewController(tripStore: store)
        profile.loadViewIfNeeded()

        XCTAssertEqual(profile.tableView.numberOfRows(inSection: 0), 4)
    }

    func testDetailLoadsWithDestinationTitle() {
        let destination = Destination.samples[2]
        let detail = DestinationDetailViewController(destination: destination, tripStore: store)
        detail.loadViewIfNeeded()

        XCTAssertEqual(detail.title, destination.name)
        XCTAssertNotNil(detail.navigationItem.rightBarButtonItem)
    }

    func testCardPopupPresentsOverFullScreen() {
        let popup = CardPopupViewController(symbol: "star", headline: "Hi", message: "There", buttonTitle: "OK", colors: [.red, .blue])

        XCTAssertEqual(popup.modalPresentationStyle, .overFullScreen)
    }
}
