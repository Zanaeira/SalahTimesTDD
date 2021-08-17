//
//  SalahTimesCollectionViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 16/08/2021.
//

import UIKit

final class SalahTimesCollectionViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private static let elementKindSectionHeader = "SupplementaryViewHeader"
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = createDataSource(for: collectionView)
    private let collectionView: UICollectionView
    
    private let headerText: String
    
    init(headerText: String) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        self.headerText = headerText
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialSnapshot()
        configureHierarchy()
    }
    
}

// MARK: - Helper Types
extension SalahTimesCollectionViewController {
    
    private enum Section { case main }
    
    fileprivate struct Item: Hashable {
        let title: String
        let body: String
        let image: UIImage?
        
        static let stubs = [
            Item(title: "Fajr", body: "03:26", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunrise", body: "05:48", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "18:06", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:21", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill")),
        ]
    }
    
}

// MARK: - UICollectionView Helpers
extension SalahTimesCollectionViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        config.backgroundColor = .tertiarySystemGroupedBackground
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { listCell, elementKind, indexPath in
            listCell.configureAsHeader(self.headerText)
        }
        
        let dataSource =  UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    private func configureInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Item.stubs, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

private extension UICollectionViewListCell {
    
    typealias Item = SalahTimesCollectionViewController.Item
    
    func configure(with item: Item) {
        var content = defaultContentConfiguration()
        content.image = item.image
        content.imageProperties.tintColor = .systemOrange
        content.text = item.title
        content.textProperties.font = .preferredFont(forTextStyle: .title3)
        content.secondaryText = item.body
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .title3)
        content.prefersSideBySideTextAndSecondaryText = true
        
        contentConfiguration = content
    }
    
    func configureAsHeader(_ title: String) {
        var config = defaultContentConfiguration()
        config.text = title
        config.textProperties.font = .preferredFont(forTextStyle: .title1)
        config.textProperties.alignment = .center
        config.directionalLayoutMargins = .init(top: 20, leading: 0, bottom: 10, trailing: 0)
        
        contentConfiguration = config

    }
    
}
