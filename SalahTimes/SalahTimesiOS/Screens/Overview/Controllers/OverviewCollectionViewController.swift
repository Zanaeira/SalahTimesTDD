//
//  OverviewCollectionViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 22/12/2021.
//

import UIKit
import SalahTimes

final class OverviewCollectionViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private enum Section {
        case main
    }
    
    private let dateHeaderView = TitleHeaderView()
    private let collectionView: UICollectionView
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, OverviewCellModel> = createDataSource(for: collectionView)
    
    private let userDefaults: UserDefaults
    private let salahTimesLoader: SalahTimesLoader
    
    init(client: HTTPClient, userDefaults: UserDefaults) {
        salahTimesLoader = SalahTimesLoader(client: client)
        self.userDefaults = userDefaults
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: OverviewCollectionViewController.createLayout())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureHierarchy()
        loadLocations()
        ensureDateStaysUpToDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        loadLocations()
    }
        
    private func configureUI() {
        collectionView.backgroundColor = .clear
    }
    
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(dateHeaderView)
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        dateHeaderView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor)
        collectionView.anchor(top: dateHeaderView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    private func loadLocations(animated: Bool = false) {
        let suiteNames = userDefaults.stringArray(forKey: "suiteNames") ?? ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
        let allLocationsUserDefaults = suiteNames.compactMap(getBaseUserDefaults(usingSuiteName:))
        
        var loadedTimes = [OverviewCellModel]()
        
        let dispatchGroup = DispatchGroup()
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        for userDefaults in allLocationsUserDefaults {
            dispatchGroup.enter()
            let location = userDefaults.string(forKey: "Location") ?? "London"
            let endpoint = makeEndpoint(usingUserDefaults: userDefaults)
            salahTimesLoader.loadTimes(from: endpoint) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let salahTimes):
                    loadedTimes.append(.init(location: location, salahTimes: salahTimes))
                case .failure(let error):
                    self.handleError(error)
                }
                
                dispatchSemaphore.signal()
                dispatchGroup.leave()
            }
            dispatchSemaphore.wait()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.refreshControl?.endRefreshing()
            self.updateSnapshot(loadedTimes, animated: animated)
            self.dateHeaderView.setTitle(DateFormatter.presentableDateFormatter.string(from: Date()))
        }
    }
    
    private func getBaseUserDefaults(usingSuiteName suiteName: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        userDefaults.register(defaults: [
            "Mithl": 2,
            "Location": "London"
        ])
        
        if let fajrIshaMethod = getEncodedFajrIshaMethod() {
            userDefaults.register(defaults: [
                "FajrIsha": fajrIshaMethod
            ])
        }
        
        return userDefaults
    }
    
    private func getEncodedFajrIshaMethod() -> Data? {
        let fajrIshaMethod = AladhanAPIEndpoint.Method.custom(methodSettings: .init(fajrAngle: 12.0, maghribAngle: nil, ishaAngle: 12.0))
        
        let encoder = JSONEncoder()
        return try? encoder.encode(fajrIshaMethod)
    }
    
    private func makeEndpoint(usingUserDefaults userDefaults: UserDefaults, onDate date: Date = Date()) -> Endpoint {
        let endpoint: Endpoint
        
        let location = userDefaults.string(forKey: "Location") ?? "London"
        let preferredMithl: AladhanAPIEndpoint.Madhhab = userDefaults.integer(forKey: "Mithl") == 2 ? .hanafi : .shafii
        
        let decoder = JSONDecoder()
        if let loadedFajrIshaCalculationMethod = userDefaults.object(forKey: "FajrIsha") as? Data,
           let fajrIshaCalculationMethod: AladhanAPIEndpoint.Method = try? decoder.decode(AladhanAPIEndpoint.Method.self, from: loadedFajrIshaCalculationMethod) {
            endpoint = AladhanAPIEndpoint.timingsByAddress(location, on: date, madhhabForAsr: preferredMithl, fajrIshaMethod: fajrIshaCalculationMethod)
        } else {
            endpoint = AladhanAPIEndpoint.timingsByAddress(location, on: date, madhhabForAsr: preferredMithl)
        }
        
        return endpoint
    }
    
    private func handleError(_ error: SalahTimesLoader.Error) {
        let errorMessage = error == .invalidData ?
            "Sorry, something went wrong.\n\nIf you think this is a mistake, then please try again later." :
            "Sorry, an error occured when trying to load the Salāh Times. Please check your internet connection and try again."
        
        let alert = UIAlertController(title: "An error occurred", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func ensureDateStaysUpToDate() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDateToMatchSystemDate), name: .NSCalendarDayChanged, object: nil)
    }
    
    @objc private func updateDateToMatchSystemDate() {
        DispatchQueue.main.async {
            self.refresh()
        }
    }
    
}

// MARK: - UICollectionView
extension OverviewCollectionViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, OverviewCellModel> {
        let cellRegistration = UICollectionView.CellRegistration<OverviewCell, OverviewCellModel> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, OverviewCellModel>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    private func updateSnapshot(_ loadedTimes: [OverviewCellModel], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OverviewCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(loadedTimes, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
        
}

private extension DateFormatter {
    
    static let presentableDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
    
}
