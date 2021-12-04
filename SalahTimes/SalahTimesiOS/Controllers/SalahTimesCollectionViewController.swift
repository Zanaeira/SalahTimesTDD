//
//  SalahTimesCollectionViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 04/12/2021.
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
        collectionView.contentInset = .init(top: -10, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

private extension SalahTimesCollectionViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .clear
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, SalahTimesViewModel> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SalahTimesViewModel> { (cell, indexPath, item) in
            cell.configure(with: item)
            
            let darkViolet = UIColor(red: 0.32, green: 0.24, blue: 0.43, alpha: 1.00)
            cell.contentView.backgroundColor = darkViolet
        }
                
        let dataSource = UICollectionViewDiffableDataSource<Section, SalahTimesViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
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
