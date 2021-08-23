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

private struct OverviewItem: Hashable {
    let header: String
    let items: [Item]
    
    static let stubs = [
        OverviewItem(header: "London, UK", items: [
            Item(title: "Fajr", body: "03:26", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunr", body: "05:48", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:03", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Mgrb", body: "20:21", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:31", image: UIImage(systemName: "moon.stars.fill"))
        ]),
        OverviewItem(header: "Paris, France", items: [
            Item(title: "Fajr", body: "03:29", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunr", body: "05:49", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:05", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:02", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Mgrb", body: "20:19", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:28", image: UIImage(systemName: "moon.stars.fill"))
        ]),
        OverviewItem(header: "Dhaka, Bangladesh", items: [
            Item(title: "Fajr", body: "03:32", image: UIImage(systemName: "sun.haze.fill")),
            Item(title: "Sunr", body: "05:51", image: UIImage(systemName: "sunrise.fill")),
            Item(title: "Zuhr", body: "13:04", image: UIImage(systemName: "sun.max.fill")),
            Item(title: "Asr", body: "17:01", image: UIImage(systemName: "sun.min.fill")),
            Item(title: "Mgrb", body: "20:17", image: UIImage(systemName: "sunset.fill")),
            Item(title: "Isha", body: "22:25", image: UIImage(systemName: "moon.stars.fill"))
        ])
    ]
    
}

private final class OverviewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let salahTimesCollectionViewController = OverviewSalahTimesCollectionViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
    }
    
    private func configureUI() {
        contentView.addSubview(salahTimesCollectionViewController.view)
    }
    
    func configure(with item: OverviewItem) {
        salahTimesCollectionViewController.updateSnapshot(items: item.items)
        salahTimesCollectionViewController.setHeader(TitleHeader(headerText: item.header))
    }
    
}

private struct TitleHeader: Header {
    let headerText: String
}

private final class OverviewSalahTimesCollectionViewController: UIViewController {
    
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

private final class SalahCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var salahCellRegistration: UICollectionView.CellRegistration<SalahCell, Item> {
        UICollectionView.CellRegistration<SalahCell, Item> { itemCell, indexPath, item in
            itemCell.configure(with: item)
        }
    }
    
    private let primaryLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .headline))
    private let secondaryLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .body))
    private let imageView = UIImageView()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, primaryLabel, secondaryLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.title.uppercased()
        secondaryLabel.text = item.body
        imageView.image = item.image
    }
    
    private func setupViews() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemOrange
        
        contentView.addSubview(stackView)
        stackView.fillSuperview()
        
        primaryLabel.textAlignment = .center
        secondaryLabel.textAlignment = .center
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
