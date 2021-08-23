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
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, OverviewItem> {
        let cellRegistration = UICollectionView.CellRegistration<OverviewCell, OverviewItem> { (cell, indexPath, item) in
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
