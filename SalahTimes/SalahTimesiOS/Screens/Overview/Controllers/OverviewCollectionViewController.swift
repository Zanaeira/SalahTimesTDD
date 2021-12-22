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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadLocations()
    }
    
    private func configureUI() {
        collectionView.backgroundColor = .clear
    }
    
    private func loadLocations() {
        let suiteNames = userDefaults.stringArray(forKey: "suiteNames") ?? ["253FAFE2-96C6-42AF-8908-33DA339BD6C7"]
        let allLocationsUserDefaults = suiteNames.compactMap(UserDefaults.init(suiteName:))
        
        var loadedTimes = [OverviewCellModel]()
        
        for userDefaults in allLocationsUserDefaults {
            let location = userDefaults.string(forKey: "Location") ?? "London"
            loadSalahTimes(usingUserDefaults: userDefaults) { salahTimes in
                loadedTimes.append(.init(location: location, salahTimes: salahTimes))
                DispatchQueue.main.async {
                    self.updateSnapshot(loadedTimes)
                }
            }
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
        section.interGroupSpacing = 10
        
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
    
    private func loadSalahTimes(usingUserDefaults userDefaults: UserDefaults, onDate date: Date = Date(), completion: @escaping (SalahTimes) -> Void) {
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
        
        salahTimesLoader.loadTimes(from: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let salahTimes):
                completion(salahTimes)
            case .failure(let error):
                self.handleError(error)
            }
        }
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
    
    private func updateSnapshot(_ loadedTimes: [OverviewCellModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, OverviewCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(loadedTimes, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
}

private final class OverviewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let locationLabel = dynamicLabel(font: .preferredFont(forTextStyle: .title1))
    private let fajrLabel = dynamicLabel()
    private let sunriseLabel = dynamicLabel()
    private let zuhrLabel = dynamicLabel()
    private let asrLabel = dynamicLabel()
    private let maghribLabel = dynamicLabel()
    private let ishaLabel = dynamicLabel()
    
    var timesLabels: [UILabel] {
        [fajrLabel, sunriseLabel, zuhrLabel, asrLabel, maghribLabel, ishaLabel]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    private func configureUI() {
        let topTimesStackView = UIStackView(arrangedSubviews: [
            fajrLabel, sunriseLabel, zuhrLabel
        ])
        let bottomTimesStackView = UIStackView(arrangedSubviews: [
            asrLabel, maghribLabel, ishaLabel
        ])
        
        let timesStackView = UIStackView(arrangedSubviews: [topTimesStackView, bottomTimesStackView])
        timesStackView.axis = .vertical
        timesStackView.spacing = 10
        
        let outerStackView = UIStackView(arrangedSubviews: [locationLabel, timesStackView])
        outerStackView.axis = .vertical
        outerStackView.distribution = .fill
        outerStackView.spacing = 10
        outerStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        outerStackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(outerStackView)
        outerStackView.fillSuperview()
        
        contentView.backgroundColor = .systemTeal.withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func configure(with overviewCellModel: OverviewCellModel) {
        locationLabel.text = overviewCellModel.location
        for (label, times) in zip(timesLabels, overviewCellModel.times) {
            label.text = "\(times.name)\n\(times.time)"
        }
    }
    
    private static func dynamicLabel(font: UIFont = .preferredFont(forTextStyle: .title3), textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = textAlignment
        label.font = font
        
        return label
    }
    
}

private struct OverviewCellModel: Hashable {
    
    let location: String
    let fajr: SalahTimesCellModel
    let sunrise: SalahTimesCellModel
    let zuhr: SalahTimesCellModel
    let asr: SalahTimesCellModel
    let maghrib: SalahTimesCellModel
    let isha: SalahTimesCellModel
    
    var times: [SalahTimesCellModel] {
        [fajr, sunrise, zuhr, asr, maghrib, isha]
    }
    
    init(location: String, salahTimes: SalahTimes) {
        self.location = location
        fajr = .init(name: "Fajr", time: salahTimes.fajr, imageName: "sun.haze.fill")
        sunrise = .init(name: "Sunrise", time: salahTimes.sunrise, imageName: "sunrise.fill")
        zuhr = .init(name: "Zuhr", time: salahTimes.zuhr, imageName: "sun.max.fill")
        asr = .init(name: "Asr", time: salahTimes.asr, imageName: "sun.min.fill")
        maghrib = .init(name: "Maghrib", time: salahTimes.maghrib, imageName: "sunset.fill")
        isha = .init(name: "Isha", time: salahTimes.isha, imageName: "moon.stars.fill")
    }
    
}
