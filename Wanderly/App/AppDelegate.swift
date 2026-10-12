import Pendo
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpPendo()
        return true
    }

    /// Starts the Pendo SDK. The app key comes from the `PENDO_APP_KEY` build setting
    /// (surfaced through Info.plist); setup is skipped while it is empty.
    private func setUpPendo() {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "PendoAppKey") as? String,
              !appKey.isEmpty else { return }
        PendoManager.shared().setup(appKey)
        // Wanderly has no accounts or login, so start an anonymous session.
        PendoManager.shared().startSession(nil, accountId: nil, visitorData: nil, accountData: nil)
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
