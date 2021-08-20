//
//  OverviewViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 19/08/2021.
//

import UIKit

final class OverviewViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, OverviewItem> = createDataSource(for: collectionView)
    private let collectionView: UICollectionView
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: OverviewViewController.createLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureInitialSnapshot()
        configureHierarchy()

    }
    
    private func configureUI() {
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
    }
    
}

// MARK: - CollectionView Helpers
extension OverviewViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, OverviewItem> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OverviewItem> { (cell, indexPath, item) in
            cell.configure(with: item)
            cell.contentView.backgroundColor = .secondarySystemGroupedBackground
        }
        
        return UICollectionViewDiffableDataSource<Section, OverviewItem>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    private func configureInitialSnapshot() {
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OverviewItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(OverviewItem.stubs, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

private struct OverviewItem: Hashable {
    let header: String
    let items: [Item]
    
    static let stubs = [
        OverviewItem(header: "London, UK", items: [
            Item(title: "Fajr", body: "03:26", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:48", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:03", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:21", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill"))
        ]),
        OverviewItem(header: "Paris, France", items: [
            Item(title: "Fajr", body: "03:29", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:49", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:02", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:19", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:28", image: UIImage(systemName: "moon.stars.fill"))
        ]),
        OverviewItem(header: "Dhaka, Bangladesh", items: [
            Item(title: "Fajr", body: "03:32", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:51", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:04", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:01", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:17", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:25", image: UIImage(systemName: "moon.stars.fill"))
        ])
    ]
    
}

private extension UICollectionViewListCell {
    
    func configure(with item: OverviewItem) {
        var config = defaultContentConfiguration()
        config.text = item.header
        config.textProperties.font = .preferredFont(forTextStyle: .title1)
        
        contentConfiguration = config
    }
    
}
