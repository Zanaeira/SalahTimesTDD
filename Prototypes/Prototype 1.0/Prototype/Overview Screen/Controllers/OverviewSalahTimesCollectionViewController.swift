//
//  OverviewSalahTimesCollectionViewController.swift
//  Prototype
//
//  Created by Suhayl Ahmed on 23/08/2021.
//

import UIKit

final class OverviewSalahTimesCollectionViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = makeDataSource()
    
    private var header: Header? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureHeaderRegistration()
    }
    
    func setHeader(_ header: Header) {
        self.header = header
    }
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    private func configureHeaderRegistration() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
            headerView.configureAsHeader(TitleHeader(headerText: self.header?.headerText ?? ""))
            headerView.contentView.backgroundColor = .tertiarySystemGroupedBackground
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func updateSnapshot(items: [Item]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections([.main])
            snapshot.appendItems(items)
            
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return collectionView
    }
    
    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
            let numberOfColumns = 6
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfColumns)
            group.interItemSpacing = .fixed(2)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 30)
            
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [headerItem]
            
            return section

        }
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: SalahCell.salahCellRegistration, for: indexPath, item: item)
        })
        
        return dataSource
    }
    
}

private extension UICollectionViewListCell {
    
    func configureAsHeader(_ header: Header) {
        var config = defaultContentConfiguration()
        config.text = header.headerText
        config.textProperties.font = .preferredFont(forTextStyle: .title1)
        config.textProperties.alignment = .center
        config.directionalLayoutMargins = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
        
        contentConfiguration = config
    }
    
}
