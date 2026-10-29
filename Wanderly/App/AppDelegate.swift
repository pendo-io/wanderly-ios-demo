import Pendo
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpPendo()
        return true
    }

    private func setUpPendo() {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "PendoAppKey") as? String, !appKey.isEmpty else {
            return
        }
        
        PendoManager.shared().setDebugMode(true)
        
        let opt = PendoOptions()
        opt.environmentName = "automation"
        let key = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiI0ZmZiYmQyMTNiODEzMzg5OTg4NDVkYWU1ZWI1MTJkOTdjYjZiMDg1MTY1ZWNhNGQyZDhlYjI4MWJjMWI5YTI1NzA1Yjg1ZTQ4OTI0MjlmN2M5ZDE0MTFkMmVhMTg4ZDE5OThiOTlhZjViYzFiOTE5ODg3MzBiNzE0NmFiMjE1M2ZjZmZmM2UxZmI0Y2U1YTdjNzVjODY5ZWMxZWRlM2M5OTBlZjgwZGE3NGJhYTZiYjBlZTg1OTA4NTY3OThkOTUuZWY0MmM3YzU1ZWI4ZDYxNDY0ZGI1NGYzMTNlN2RmM2EuMGQwY2ZhZmJhOGMyOTg1NWZlYWFjNjk4ZTJmNzRjYTY0YjY1OTc2MWQ0ZGVlMjVmMTZkZmIzNzk4Y2Y4MWY4OCJ9.hSTZvSmDUEfQF9UmkEYPSaZBkZhwVA3NZB3hMSGWBlDXu9kZUPbL-TtzYtfUeBvjOGlaIfryJaU0SQdZOVIWWR49uYRcHnXdOFisxFej_i3t7a6qdLlU517zCbETDQpeX0QFiARORjvYJGcvedgtyHMUUgw_s9FsiIniMfdd-KI"
        
        PendoManager.shared().setup(key, with: opt)
        PendoManager.shared().startSession("visitor", accountId: "account", visitorData: nil, accountData: nil)
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
