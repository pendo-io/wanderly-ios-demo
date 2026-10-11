import Pendo
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainTabBarController(tripStore: TripStore())
        window.tintColor = Theme.Color.accent
        window.makeKeyAndVisible()
        self.window = window
        handlePendoURLs(connectionOptions.urlContexts)
    }

    // Pendo pairing: the SDK URL scheme (pendo-<id>) opens the app from the Pendo
    // pairing QR code / link, and the URL is handed to the SDK to pair the device.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handlePendoURLs(URLContexts)
    }

    private func handlePendoURLs(_ contexts: Set<UIOpenURLContext>) {
        for context in contexts where context.url.scheme?.hasPrefix("pendo") == true {
            PendoManager.shared().initWith(context.url)
        }
    }
}
