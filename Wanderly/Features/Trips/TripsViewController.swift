import UIKit

final class TripsViewController: UITableViewController {
    private let tripStore: TripStore
    private let emptyState = EmptyStateView(symbol: "airplane.departure", title: "No trips yet", message: "Add destinations from Discover and they'll show up here.")

    init(tripStore: TripStore) {
        self.tripStore = tripStore
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TripCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", primaryAction: UIAction { [weak self] _ in self?.confirmClearAll() })
        NotificationCenter.default.addObserver(self, selector: #selector(tripsChanged), name: TripStore.didChangeNotification, object: tripStore)
        render()
    }

    @objc private func tripsChanged() {
        render()
    }

    private func render() {
        tableView.reloadData()
        tableView.backgroundView = tripStore.trips.isEmpty ? emptyState : nil
        navigationItem.rightBarButtonItem?.isEnabled = !tripStore.trips.isEmpty
        navigationController?.tabBarItem.badgeValue = tripStore.trips.isEmpty ? nil : "\(tripStore.trips.count)"
    }

    private func confirmClearAll() {
        let alert = UIAlertController(title: "Clear all trips?", message: "This removes every saved destination.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            guard let self else { return }
            tripStore.removeAll()
            ToastView.show("All trips cleared", symbol: "trash.fill", in: view)
        })
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tripStore.trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trip = tripStore.trips[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath)
        var content = UIListContentConfiguration.subtitleCell()
        content.text = trip.name
        content.secondaryText = "\(trip.country) · $\(trip.pricePerNight)/night"
        content.image = UIImage(systemName: trip.symbol)
        content.imageProperties.tintColor = trip.colors.first
        content.textProperties.font = Theme.roundedFont(.headline, weight: .semibold)
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
            self?.tripStore.remove(at: indexPath.row)
            completion(true)
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
