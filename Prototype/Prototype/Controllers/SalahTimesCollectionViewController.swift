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
    
    private let dataSource: UICollectionViewDiffableDataSource<Section, Item>
    private let collectionView: UICollectionView
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        dataSource = SalahTimesCollectionViewController.createDataSource(for: collectionView)
        
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
    
    private struct Item: Hashable {
        let title: String
        let body: String
        let image: UIImage?
        
        static let stubs = [
            Item(title: "Fajr", body: "03:26 - 05:48", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:03 | 18:06", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Maghrib", body: "20:21", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill")),
        ]
    }
    
}

// MARK: - UICollectionView Helpers
extension SalahTimesCollectionViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private static func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Item> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.imageProperties.tintColor = .systemOrange
            content.text = item.title
            content.textProperties.font = .preferredFont(forTextStyle: .title3)
            content.secondaryText = item.body
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .title3)
            content.prefersSideBySideTextAndSecondaryText = true
            
            cell.contentConfiguration = content
        }
        
        return UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
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
