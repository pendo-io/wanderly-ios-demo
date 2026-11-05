import Pendo
import UIKit

final class MainTabBarController: UITabBarController {
    private let tripStore: TripStore

    init(tripStore: TripStore) {
        self.tripStore = tripStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        let discover = makeTab(DiscoverViewController(tripStore: tripStore), title: "Discover", symbol: "safari")
        discover.tabBarItem.pendoTag = "Switch to Discover tab"
        let trips = makeTab(TripsViewController(tripStore: tripStore), title: "Trips", symbol: "suitcase")
        trips.tabBarItem.pendoTag = "Switch to Trips tab"
        let profile = makeTab(ProfileViewController(tripStore: tripStore), title: "Profile", symbol: "person.crop.circle")
        profile.tabBarItem.pendoTag = "Switch to Profile tab"
        viewControllers = [discover, trips, profile]
    }

    private func makeTab(_ root: UIViewController, title: String, symbol: String) -> UINavigationController {
        root.title = title
        let navigation = UINavigationController(rootViewController: root)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: symbol), selectedImage: UIImage(systemName: symbol + ".fill"))
        return navigation
    }
}
