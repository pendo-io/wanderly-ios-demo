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
        viewControllers = [
            makeTab(DiscoverViewController(tripStore: tripStore), title: "Discover", symbol: "safari"),
            makeTab(TripsViewController(tripStore: tripStore), title: "Trips", symbol: "suitcase"),
            makeTab(ProfileViewController(tripStore: tripStore), title: "Profile", symbol: "person.crop.circle")
        ]
    }

    private func makeTab(_ root: UIViewController, title: String, symbol: String) -> UINavigationController {
        root.title = title
        let navigation = UINavigationController(rootViewController: root)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: symbol), selectedImage: UIImage(systemName: symbol + ".fill"))
        return navigation
    }
}
