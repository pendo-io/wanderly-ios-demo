import Foundation
import Pendo

@MainActor
final class TripStore {
    static let didChangeNotification = Notification.Name("TripStoreDidChange")

    private(set) var trips: [Destination] = []

    func contains(_ destination: Destination) -> Bool {
        trips.contains(destination)
    }

    func add(_ destination: Destination) {
        guard !contains(destination) else { return }
        trips.append(destination)
        PendoManager.shared().track("Trip saved", properties: nil)
        notifyChange()
    }

    func remove(at index: Int) {
        trips.remove(at: index)
        PendoManager.shared().track("Trip removed", properties: nil)
        notifyChange()
    }

    func removeAll() {
        trips.removeAll()
        PendoManager.shared().track("All trips cleared", properties: nil)
        notifyChange()
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
    }
}
