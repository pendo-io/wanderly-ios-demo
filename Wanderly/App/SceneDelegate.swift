import UIKit
import Pendo

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainTabBarController(tripStore: TripStore())
        window.tintColor = Theme.Color.accent
        window.makeKeyAndVisible()
        self.window = window

        PendoManager.shared().setup("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiJkY2IzNzMyODM4MDgzZjYyYWIzN2FmYzYzZmI4NTBmMzg3NGZjMDVmMzJmZjViMzVjODA5YTg1YzRjYWM5OWUyNDBmZjRjZTVmYTg2ZDhmNTBlNmNkZmRhZTg1YWUyODcwMTYxMThiMGZjY2VmOTMwZjJlNmM0OTk0MjcxZTlkZmJiMmU2NjAwNGMxZDA2NWNmOGNmMWM5MWY2ZDc1ZWE5YWRmMTg1ZGVlODczM2E3MGEzZjYwYTFlMDJlZjczYWEuOWRlNGRkZDM4MDc5NGY3MTA2YzI5ODUzMDM3NTg4ZmUuNDk5ZTBjYjFiMTQ3ZGFmNDc4OWFmNDUyYWIxMGIzNjE3Zjc4OGFhNjIyNjQ1MjJlZWU3NjVkMGIwNjAwZGFmYyJ9.QyKAeUvywokmqmGtPs4ySfUycfPwWFDRwDnhkz76ts_3qTJrjRhvbh-Qiup8tcIp6HJlZO3pNAuNPcao6KooCamO9Ap-prfAZKq3-LF-W-YSqRjFfivtVFkI_ONlMj_zI0NOn-w3to4NuiT0GcQLqStYCdXk9LTG1iYTTk035I0")

        PendoManager.shared().startSession(
            "wanderly-visitor",
            accountId: "wanderly-account",
            visitorData: [
                "name": "Wanderly Traveler",
                "role": "traveler"
            ],
            accountData: [
                "name": "Wanderly Demo"
            ]
        )
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
        }
    }
}
