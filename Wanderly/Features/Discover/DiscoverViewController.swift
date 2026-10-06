import UIKit

final class DiscoverViewController: UIViewController {
    private enum Section { case main }

    private let tripStore: TripStore
    private var filter = DestinationFilter()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Destination>!

    init(tripStore: TripStore) {
        self.tripStore = tripStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Color.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), primaryAction: UIAction { [weak self] _ in self?.showFilters() })
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sparkles"), primaryAction: UIAction { [weak self] _ in self?.showSurprise() })
        setUpCollectionView()
        applySnapshot()
    }

    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(DestinationCell.self, forCellWithReuseIdentifier: DestinationCell.reuseIdentifier)
        view.addSubview(collectionView)

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, destination in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as! DestinationCell
            cell.configure(with: destination)
            return cell
        }
    }

    private func makeLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(170)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Theme.Spacing.medium
        section.contentInsets = NSDirectionalEdgeInsets(top: Theme.Spacing.small, leading: Theme.Spacing.medium, bottom: Theme.Spacing.large, trailing: Theme.Spacing.medium)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Destination>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filter.apply(to: Destination.samples))
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func showFilters() {
        let sheet = FilterSheetViewController(filter: filter) { [weak self] updated in
            self?.filter = updated
            self?.applySnapshot()
        }
        present(sheet, animated: true)
    }

    private func showSurprise() {
        guard let pick = Destination.samples.randomElement() else { return }
        let popup = CardPopupViewController(symbol: pick.symbol, headline: "How about \(pick.name)?", message: pick.summary, buttonTitle: "Take me there", colors: pick.colors) { [weak self] in
            self?.showDetail(for: pick)
        }
        present(popup, animated: true)
    }

    private func showDetail(for destination: Destination) {
        navigationController?.pushViewController(DestinationDetailViewController(destination: destination, tripStore: tripStore), animated: true)
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destination = dataSource.itemIdentifier(for: indexPath) else { return }
        showDetail(for: destination)
    }
}
