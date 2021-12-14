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
    private let userDefaults: UserDefaults
    
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
    
    init(salahTimesLoader: SalahTimesLoader, userDefaults: UserDefaults) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        self.salahTimesLoader = salahTimesLoader
        self.userDefaults = userDefaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configurePullToRefresh()
        configureHierarchy()
        performInitialDataLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refresh()
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
        loadSalahTimes(forLocation: location ?? defaultLocation, onDate: date ?? Date())
    }
    
    func updateLocation(to location: String) {
        loadSalahTimes(forLocation: location, onDate: date ?? Date())
    }
    
    private func updateDate(to date: Date) {
        loadSalahTimes(forLocation: location ?? defaultLocation, onDate: date)
    }
    
    @objc private func refresh() {
        let location = self.location ?? defaultLocation
        let date = self.date ?? Date()
        
        loadSalahTimes(forLocation: location, onDate: date)
        
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    private func loadSalahTimes(forLocation location: String, onDate date: Date) {
        let preferredMithl: AladhanAPIEndpoint.Madhhab = userDefaults.integer(forKey: "Mithl") == 2 ? .hanafi : .shafii
        let endpoint = AladhanAPIEndpoint.timingsByAddress(location, on: date, madhhabForAsr: preferredMithl)
        
        salahTimesLoader.loadTimes(from: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResult(result, forLocation: location, onDate: date)
            }
        }
    }
    
    private func handleResult(_ result: SalahTimesLoader.Result, forLocation location: String, onDate date: Date) {
        switch result {
        case .success(let salahTimes):
            self.location = location
            self.date = date
            
            self.updateSalahTimes(salahTimes)
        case .failure(let error):
            handleError(error, location: location)
        }
    }
    
    private func handleError(_ error: SalahTimesLoader.Error, location: String) {
        let errorMessage = error == .invalidData ?
            "Sorry, we were unable to find any Salāh Times for: \(location)" :
            "Sorry, an error occured when trying to load the Salāh Times. Please check your internet connection and try again."
        
        let alert = UIAlertController(title: "An error occurred", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        present(alert, animated: true)
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

