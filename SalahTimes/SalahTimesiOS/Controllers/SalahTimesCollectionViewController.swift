//
//  SalahTimesCollectionViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 08/12/2021.
//

import UIKit
import SalahTimes

final class SalahTimesCollectionViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private enum Section {
        case main
    }
    
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    private let salahTimesLoader: SalahTimesLoader
    
    private let collectionView: UICollectionView
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, SalahTimesViewModel> = createDataSource(for: collectionView)
    
    private var location: String? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private let defaultLocation = "London"
    
    private var date: Date?
    
    init(salahTimesLoader: SalahTimesLoader) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        self.salahTimesLoader = salahTimesLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configurePullToRefresh()
        configureHierarchy()
        performInitialDataLoad()
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
    
    private func performInitialDataLoad() {
        refresh()
    }
    
    func updateLocation(to location: String) {
        self.location = location
        refresh()
    }
    
    private func updateDate(to date: Date) {
        self.date = date
        refresh()
    }
    
    @objc private func refresh() {
        let endpoint = AladhanAPIEndpoint.timingsByAddress(location ?? defaultLocation, on: date ?? Date())
        
        salahTimesLoader.loadTimes(from: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResult(result)
            }
        }
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    private func handleResult(_ result: SalahTimesLoader.Result) {
        switch result {
        case .success(let salahTimes):
            self.updateSalahTimes(salahTimes)
        case .failure:
            break
        }
    }
    
    private func updateSalahTimes(_ salahTimes: SalahTimes) {
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
        collectionView.delegate = self
    }
    
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
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, _, _) in
            headerView.setLabelText(self.location ?? self.defaultLocation)
            headerView.setDateSelectedAction(self.updateDate)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, SalahTimesViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { (_, _, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
                
        return dataSource
    }
    
}

extension SalahTimesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
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

