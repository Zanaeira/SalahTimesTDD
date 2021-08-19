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
    
    private var header: Header {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init(header: Header) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        self.header = header
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialSnapshot()
        configureHierarchy()
    }
    
}

// MARK: - CollectionViewDelegate
extension SalahTimesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
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
            listCell.configureAsHeader(self.header)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showDatePicker))
            listCell.addGestureRecognizer(tapGestureRecognizer)
        }
        
        let dataSource =  UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    @objc private func showDatePicker() {
        let datePickerViewController = DatePickerViewController(mode: .date, style: .inline) { date in
            self.header = Header(date: date)
            self.updateSnapshot()
        }
        
        self.present(datePickerViewController, animated: true, completion: nil)
    }
    
    private func configureInitialSnapshot() {
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Item.random(), toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

private extension UICollectionViewListCell {
    
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
    
    func configureAsHeader(_ header: Header) {
        var config = defaultContentConfiguration()
        config.text = header.headerText
        config.textProperties.font = .preferredFont(forTextStyle: .title1)
        config.textProperties.alignment = .center
        config.directionalLayoutMargins = .init(top: 4, leading: 0, bottom: 10, trailing: 0)
        
        contentConfiguration = config
    }
    
}
