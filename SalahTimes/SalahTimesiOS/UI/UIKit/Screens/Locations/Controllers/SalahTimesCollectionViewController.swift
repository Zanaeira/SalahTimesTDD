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
    
    private let salahTimesLoader: TimesLoader
    private let userDefaults: UserDefaults
    
    private let collectionView: UICollectionView
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, SalahTimesCellModel> = createDataSource(for: collectionView)
    
    private var salahTimesCellModels = [SalahTimesCellModel]()
    
    private(set) var location: String? {
        didSet {
            userDefaults.set(location, forKey: "Location")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private lazy var defaultLocation = userDefaults.string(forKey: "Location") ?? "London"
    
    private var date: Date?
    
    private var preferredMithl: AladhanAPIEndpoint.Madhhab { userDefaults.integer(forKey: "Mithl") == 2 ? .hanafi : .shafii }
    private var asrSubtitle: String { preferredMithl == .hanafi ? "[2]" : "[1]" }
    
    init(salahTimesLoader: TimesLoader, userDefaults: UserDefaults) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: SalahTimesCollectionViewController.createLayout())
        self.salahTimesLoader = salahTimesLoader
        self.userDefaults = userDefaults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureHierarchy()
        performInitialDataLoad()
        ensureDateStaysUpToDate()
    }
    
    private func configureUI() {
        view.backgroundColor = .clear
        collectionView.backgroundColor = .clear
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
    
    @objc func refresh() {
        let location = self.location ?? defaultLocation
        let date = self.date ?? Date()
        
        loadSalahTimes(forLocation: location, onDate: date)
        
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    private func loadSalahTimes(forLocation location: String, onDate date: Date) {
        let endpoint: Endpoint
        
        let decoder = JSONDecoder()
        if let loadedFajrIshaCalculationMethod = userDefaults.object(forKey: "FajrIsha") as? Data,
           let fajrIshaCalculationMethod: AladhanAPIEndpoint.Method = try? decoder.decode(AladhanAPIEndpoint.Method.self, from: loadedFajrIshaCalculationMethod) {
            endpoint = AladhanAPIEndpoint.timingsByAddress(location, on: date, madhhabForAsr: preferredMithl, fajrIshaMethod: fajrIshaCalculationMethod)
        } else {
            endpoint = AladhanAPIEndpoint.timingsByAddress(location, on: date, madhhabForAsr: preferredMithl)
        }
        
        salahTimesLoader.load(from: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResult(result, forLocation: location, onDate: date)
            }
        }
    }
    
    private func handleResult(_ result: TimesLoader.Result, forLocation location: String, onDate date: Date) {
        switch result {
        case .success(let salahTimes):
            self.location = location
            self.date = date
            
            self.updateSalahTimes(salahTimes)
        case .failure(let error):
            handleError(error, location: location)
        }
    }
    
    private func handleError(_ error: LoaderError, location: String) {
        let errorMessage = error == .invalidData ?
            "Sorry, we were unable to find any Salāh Times for: \(location).\n\nIf you think this is a mistake, then please try again later." :
            "Sorry, an error occured when trying to load the Salāh Times. Please check your internet connection and try again."
        
        let alert = UIAlertController(title: "An error occurred", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.dismiss(animated: false)
        present(alert, animated: true)
        
        collectionView.reloadData()
    }
    
    private func updateSalahTimes(_ salahTimes: SalahTimes) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SalahTimesCellModel>()
        snapshot.appendSections([.main])
        salahTimesCellModels = map(salahTimes)
        snapshot.appendItems(salahTimesCellModels, toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func map(_ salahTimes: SalahTimes) -> [SalahTimesCellModel] {
        var salahTimesCellModels = [SalahTimesCellModel]()
        salahTimesCellModels.append(.init(name: "Fajr", time: salahTimes.fajr, imageName: "sun.haze.fill"))
        salahTimesCellModels.append(.init(name: "Sunrise", time: salahTimes.sunrise, imageName: "sunrise.fill"))
        salahTimesCellModels.append(.init(name: "Zuhr", time: salahTimes.zuhr, imageName: "sun.max.fill"))
        salahTimesCellModels.append(.init(name: "Asr \(asrSubtitle)", time: salahTimes.asr, imageName: "sun.min.fill"))
        salahTimesCellModels.append(.init(name: "Maghrib", time: salahTimes.maghrib, imageName: "sunset.fill"))
        salahTimesCellModels.append(.init(name: "Isha", time: salahTimes.isha, imageName: "moon.stars.fill"))
        
        return salahTimesCellModels
    }
    
    private func ensureDateStaysUpToDate() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDateToMatchSystemDate), name: .NSCalendarDayChanged, object: nil)
    }
    
    @objc private func updateDateToMatchSystemDate() {
        self.date = Date()
        
        DispatchQueue.main.async {
            self.refresh()
        }
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
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, SalahTimesCellModel> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SalahTimesCellModel> { (cell, indexPath, item) in
            let background = UIBackgroundConfiguration.listSidebarCell()
            cell.backgroundConfiguration = background
            
            cell.configure(with: item)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, _, _) in
            headerView.setLabelText(self.location ?? self.defaultLocation)
            headerView.setDate(self.date ?? Date())
            headerView.onDateSelected = self.updateDate
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, SalahTimesCellModel>(collectionView: collectionView) { collectionView, indexPath, item in
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
        return didSelectAsr(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let currentPreferredMithl = userDefaults.integer(forKey: "Mithl")
        let newPreferredMithl = currentPreferredMithl == 2 ? 1 : 2
        
        userDefaults.set(newPreferredMithl, forKey: "Mithl")
        refresh()
    }
    
    private func didSelectAsr(at indexPath: IndexPath) -> Bool {
        return salahTimesCellModels[indexPath.item].name.starts(with: "Asr")
    }
    
}

private extension UICollectionViewListCell {
    
    func configure(with viewModel: SalahTimesCellModel) {
        var content = defaultContentConfiguration()
        
        content.text = viewModel.name
        content.textProperties.font = .preferredFont(forTextStyle: .title2)
        content.secondaryText = viewModel.time
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .title2)
        content.prefersSideBySideTextAndSecondaryText = true
        content.image = UIImage(systemName: viewModel.imageName)
        content.imageProperties.tintColor = .systemOrange
        
        contentConfiguration = content
    }
    
}

