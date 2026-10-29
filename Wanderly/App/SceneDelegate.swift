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

        PendoManager.shared().setup("eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiJiYWMxM2E4MjBhZTU5ODdkNWIzOGRkMDIwYmJmYTk5OWJmZmIyNjY0ZjljOWRhN2MxM2Q1NjZlNzg1OTlhYjk3Y2Q3OWFjMzIwNTczZDI1NmE3M2ZiOWUzNTc0MjdkNjliNGQyOGE3YTFjODIzZGM0NDAyNDZmMDQwZjk3OTE5ZjNlNTBlNWI3Y2EzY2RiMDc5YjNhYjU5OTk3ZDA5NmM1NGYzMDY4ODg0MjBmMTY1NjVkYzUyOTE5ZmQ1YTVmOWYuYWIxMDdmODNjZDk1ZDhlZDBjZTQxMjVhZjNmNTUxMzAuMTU1ZTIxYmIzMDliODM3MDcyOGJhYzg3YTlkZGY3NTU4ZTJiNzY0MTEwNDMxNGFjNjJmZmI5YWMyMmNlMzZkOCJ9.VNwiuLefqDwsnmgIQkCa4UiHlfIblGwwq2aRdHX1yVlqkqFvd1HxkrPa0T07E9Q7-LqXRxYB3y9xEk3aGFFbl4ooSD5poMg8ZW5UeQwdHLVkSEDbjSzyCo67mTPVUcDqfMe7KjVNOqcbuYi3xo8CJflHTb2H_F_LC2UIi-AaWM0")

        PendoManager.shared().startSession(
            "wanderly-visitor-001",
            accountId: "wanderly-account-001",
            visitorData: [
                "full_name": "Wanderly Traveler",
                "role": "traveler"
            ],
            accountData: [
                "name": "Wanderly Demo",
                "plan": "demo"
            ]
        )
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url, url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
        }
    }
}
