//
//  SalahTimesViewController.swift
//  SalahTimesiOS
//
//  Created by Suhayl Ahmed on 04/12/2021.
//

import UIKit
import SalahTimes

public final class SalahTimesViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let salahTimesLoader: SalahTimesLoader
    
    private lazy var headerView = HeaderViewBuilder.buildHeaderView(withTitle: searchLocation ?? defaultLocation, onDateSelectedAction: refresh)
    private lazy var salahTimesCollectionViewController = SalahTimesCollectionViewController(onRefresh: refresh)
    private let searchController = UISearchController()
    
    private let defaultLocation = "London, UK"
    private var searchLocation: String? {
        didSet {
            headerView.setTitle(searchLocation ?? defaultLocation)
        }
    }
    
    public init(salahTimesLoader: SalahTimesLoader) {
        self.salahTimesLoader = salahTimesLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupSearchBar()
        performInitialDataLoad()
    }
    
    private func configureUI() {
        title = "Salāh Times"
        
        let black = UIColor(red: 0.00, green: 0.00, blue: 0.03, alpha: 1.00).cgColor
        let darkPurple = UIColor(red: 0.13, green: 0.07, blue: 0.36, alpha: 1.00).cgColor
        let purple = UIColor(red: 0.45, green: 0.20, blue: 0.95, alpha: 1.00).cgColor
        let lightPurple = UIColor(red: 0.78, green: 0.46, blue: 1.00, alpha: 1.00).cgColor
        let pink = UIColor(red: 0.96, green: 0.70, blue: 0.90, alpha: 1.00).cgColor
        
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            darkPurple, purple, lightPurple, pink, purple, darkPurple, black
        ]
        gradient.locations = [0, 0.2, 0.3, 0.4, 0.7, 0.8, 1]
        
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        
        setupSalahTimesCollectionView()
    }
    
    private func setupSalahTimesCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(headerView)
        headerView.setTitle(searchLocation ?? defaultLocation)
        headerView.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 24, left: 16, bottom: 0, right: 16))
        
        add(salahTimesCollectionViewController)
        
        salahTimesCollectionViewController.view.anchor(top: headerView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor)
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.placeholder = "Enter location. E.g. London, UK"
        
        searchController.searchBar.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func dismissKeyboard() {
        searchController.isActive = false
    }
    
    private func performInitialDataLoad() {
        refresh()
    }
    
    @objc private func refresh() {
        print("Getting salāh times for: \(searchLocation ?? defaultLocation), on \(headerView.selectedDate)")
        let endpoint = AladhanAPIEndpoint.timingsByAddress(searchLocation ?? defaultLocation, on: headerView.selectedDate)
        
        salahTimesLoader.loadTimes(from: endpoint) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResult(result)
            }
        }
    }
    
    private func handleResult(_ result: SalahTimesLoader.Result) {
        switch result {
        case .success(let salahTimes):
            self.salahTimesCollectionViewController.updateSalahTimes(salahTimes, for: searchLocation ?? defaultLocation)
            print(salahTimes)
        case .failure:
            break
        }
    }
    
}

extension SalahTimesViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchLocation = searchBar.text
        searchController.isActive = false
        refresh()
    }
    
}
