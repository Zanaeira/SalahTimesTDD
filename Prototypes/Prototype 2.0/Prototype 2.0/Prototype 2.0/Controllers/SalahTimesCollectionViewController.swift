//
//  SalahTimesCollectionViewController.swift
//  Prototype 2.0
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import UIKit

final class SalahTimesCollectionViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private enum Section {
        case main
    }
    
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    private let collectionView: UICollectionView
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, SalahTimesViewModel> = createDataSource(for: collectionView)
    
    private let onRefresh: (() -> Void)?
    private var locationTitle: String? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init(onRefresh: @escaping () -> Void) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        self.onRefresh = onRefresh
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configurePullToRefresh()
        configureHierarchy()
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }
    
    private func configurePullToRefresh() {
        let refreshControl = UIRefreshControl()
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        onRefresh?()
        collectionView.refreshControl?.endRefreshing()
    }
    
    func updateSalahTimes(_ salahTimes: SalahTimes, for location: String) {
        locationTitle = location
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SalahTimesViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(map(salahTimes), toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func map(_ salahTimes: SalahTimes) -> [SalahTimesViewModel] {
        var salahTimesViewModel = [SalahTimesViewModel]()
        salahTimesViewModel.append(.init(name: "Fajr", time: salahTimes.fajr, imageName: "sun.haze.fill"))
        salahTimesViewModel.append(.init(name: "Sunrise", time: salahTimes.sunrise, imageName: "sunrise.fill"))
        salahTimesViewModel.append(.init(name: "Zuhr", time: salahTimes.zuhr, imageName: "sun.max.fill"))
        salahTimesViewModel.append(.init(name: "Asr", time: salahTimes.asr, imageName: "sun.min.fill"))
        salahTimesViewModel.append(.init(name: "Maghrib", time: salahTimes.maghrib, imageName: "sunset.fill"))
        salahTimesViewModel.append(.init(name: "Isha", time: salahTimes.isha, imageName: "moon.stars.fill"))
        
        return salahTimesViewModel
    }
        
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

private struct SalahTimesViewModel: Hashable {
    
    let name: String
    let time: String
    let imageName: String
    
}

private extension SalahTimesCollectionViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 6)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SalahTimesCollectionViewController.sectionBackgroundDecorationElementKind)
        section.decorationItems = [sectionBackgroundDecoration]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SalahTimesBackgroundDecorationView.self, forDecorationViewOfKind: SalahTimesCollectionViewController.sectionBackgroundDecorationElementKind)
        
        return layout
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, SalahTimesViewModel> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SalahTimesViewModel> { (cell, indexPath, item) in
            let background = UIBackgroundConfiguration.listSidebarCell()
            cell.backgroundConfiguration = background
            
            cell.configure(with: item)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (_, _, _) in }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, SalahTimesViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (_, _, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
                
        return dataSource
    }
    
}

private extension UICollectionViewListCell {
    
    func configure(with viewModel: SalahTimesViewModel) {
        var content = defaultContentConfiguration()
        
        content.text = viewModel.name
        content.textProperties.font = .preferredFont(forTextStyle: .title2)
        content.textProperties.alignment = .center
        content.secondaryText = viewModel.time
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .title2)
        content.prefersSideBySideTextAndSecondaryText = true
        content.image = UIImage(systemName: viewModel.imageName)
        content.imageProperties.tintColor = .systemOrange
        
        contentConfiguration = content
    }
    
}
