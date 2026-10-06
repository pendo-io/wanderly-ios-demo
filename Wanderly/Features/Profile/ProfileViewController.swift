import UIKit

final class ProfileViewController: UITableViewController {
    private enum Row: CaseIterable {
        case notifications
        case darkMode
        case about
        case signOut

        var title: String {
            switch self {
            case .notifications: "Trip reminders"
            case .darkMode: "Dark mode"
            case .about: "About Wanderly"
            case .signOut: "Sign out"
            }
        }

        var symbol: String {
            switch self {
            case .notifications: "bell.badge.fill"
            case .darkMode: "moon.fill"
            case .about: "info.circle.fill"
            case .signOut: "rectangle.portrait.and.arrow.right"
            }
        }
    }

    private let tripStore: TripStore

    init(tripStore: TripStore) {
        self.tripStore = tripStore
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.tableHeaderView = makeHeader()
    }

    private func makeHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 180))
        let avatar = GradientView(colors: [Theme.Color.accent, .systemPink])
        avatar.layer.cornerRadius = 44
        avatar.clipsToBounds = true

        let initials = UILabel()
        initials.text = "WT"
        initials.font = Theme.roundedFont(.title1, weight: .heavy)
        initials.textColor = .white

        let nameLabel = UILabel()
        nameLabel.text = "Wanderly Traveler"
        nameLabel.font = Theme.roundedFont(.title3, weight: .bold)

        [avatar, initials, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            header.addSubview($0)
        }
        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            avatar.topAnchor.constraint(equalTo: header.topAnchor, constant: Theme.Spacing.medium),
            avatar.widthAnchor.constraint(equalToConstant: 88),
            avatar.heightAnchor.constraint(equalToConstant: 88),
            initials.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            initials.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: Theme.Spacing.medium)
        ])
        return header
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Row.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = row.title
        content.image = UIImage(systemName: row.symbol)
        content.imageProperties.tintColor = row == .signOut ? .systemRed : Theme.Color.accent
        content.textProperties.color = row == .signOut ? .systemRed : .label
        cell.contentConfiguration = content
        cell.accessoryView = switchView(for: row)
        cell.accessoryType = row == .about ? .disclosureIndicator : .none
        cell.selectionStyle = cell.accessoryView == nil ? .default : .none
        return cell
    }

    private func switchView(for row: Row) -> UISwitch? {
        switch row {
        case .notifications:
            let toggle = UISwitch()
            toggle.addAction(UIAction { [weak self] action in
                guard let self, let toggle = action.sender as? UISwitch else { return }
                ToastView.show(toggle.isOn ? "Reminders on" : "Reminders off", symbol: "bell.fill", in: view)
            }, for: .valueChanged)
            return toggle
        case .darkMode:
            let toggle = UISwitch()
            toggle.isOn = traitCollection.userInterfaceStyle == .dark
            toggle.addAction(UIAction { [weak self] action in
                guard let toggle = action.sender as? UISwitch else { return }
                self?.view.window?.overrideUserInterfaceStyle = toggle.isOn ? .dark : .light
            }, for: .valueChanged)
            return toggle
        case .about, .signOut:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Row.allCases[indexPath.row] {
        case .about: showAbout()
        case .signOut: confirmSignOut(from: tableView.cellForRow(at: indexPath))
        case .notifications, .darkMode: break
        }
    }

    private func showAbout() {
        let popup = CardPopupViewController(symbol: "globe.europe.africa.fill", headline: "Wanderly 1.0", message: "A tiny demo app for exploring destinations and planning trips.", buttonTitle: "Close", colors: [Theme.Color.accent, .systemTeal])
        present(popup, animated: true)
    }

    private func confirmSignOut(from cell: UITableViewCell?) {
        let sheet = UIAlertController(title: "Sign out?", message: "Your saved trips will be cleared.", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Sign out", style: .destructive) { [weak self] _ in
            guard let self else { return }
            tripStore.removeAll()
            ToastView.show("Signed out", symbol: "hand.wave.fill", in: view)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.popoverPresentationController?.sourceView = cell
        sheet.popoverPresentationController?.sourceRect = cell?.bounds ?? .zero
        present(sheet, animated: true)
    }
}
